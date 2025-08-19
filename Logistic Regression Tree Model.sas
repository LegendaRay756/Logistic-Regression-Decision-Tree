libname Banking "/home/u64097142/Banking";

/*output out : apply training on existing dataset 
store out: only remembers the training parameters without prediction
score out: apply training on a new dataset and predict*/


proc print data=banking.baddata (obs=100);run; 

data base;
set banking.baddata;
obsid = _n_; /*include id column for reference*/
run; 

proc contents data=base out=basevar ; run; 

proc sql; 
select name into:_var_ separated by " " from basevar ; quit; 
%put &=_var_;


/* 1. Tree with train/validate split and leaf IDs */
proc hpsplit data=base seed=12345 maxdepth=15 leafsize=15 ;
/*Overfitting/ Bad Training Corrections*/
/*Maxdepth: how deep/bushy, leafsize: min number of obs in a leaf, the larger, the simpler*/
  class reason job bad;
  model bad = mortdue value yoj derog delinq clage ninq clno debtinc reason job;
  grow entropy;
  prune costcomplexity;
  partition fraction(validate=0.3); /*30* data for validation, 70% for training*/
  id  &_var_;
  /* write reusable scoring code (optional) */
  code file="/home/u64097142/hpsplit_score.sas";
  output OUT=tree_out ; /*Score Out is not supported in hpsplit*/
run;


/*Finding Significant Leaves, make sure proc logistic are meaningful */
proc sql;
  create table good_leaves as
  select _leaf_
  from tree_out
  group by _leaf_
  having count(*) >= 200           /* total records in the leaf */
     and sum(bad=1) >= 30;         /* at least 30 bads */
quit;

proc sql;
create table sigleaf as  
select * , b._leaf_ from tree_out a
inner join good_leaves b on 
b._leaf_=a._leaf_;
quit; 

/*proc sql ; 
select distinct _leaf_ from sigleaf ; quit; */


proc sort data=tree_out; by _leaf_; run;

proc logistic data=sigleaf outest=coef_by_leaf;
  by _leaf_;
  class reason job bad/ param=ref;
  model bad(event='1') = mortdue value yoj derog delinq clage ninq clno debtinc reason job;
  store out=work._leaf_;  
run;

/*apply training to the entire dataset*/
data score_in; set banking.baddata; run;
%include "/home/u64097142/hpsplit_score.sas";  

/*Create empty dataset*/
data scored_all; length pd 8.; stop; run;

proc sql noprint; select distinct _leaf_ into :leaflist separated by ' ' from score_in; quit;

%macro apply_leaf_models;
  %local L;
  %do i=1 %to %sysfunc(countw(&leaflist));
    %let L = %scan(&leaflist,&i);

    /* If model exists, use it */
    proc plm restore=leafStore._leaf_;
      score data=score_in(where=(_leaf_=&L)) out=scored_leaf&i / ilink;
    run;
    data scored_all; set scored_all scored_leaf&i; run;

  %end;
%mend;

%apply_leaf_models;
