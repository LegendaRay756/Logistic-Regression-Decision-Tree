****************************************************************;
******        HP TREE (PROC HPSPLIT) SCORING CODE        ******;
****************************************************************;
 
******              LABELS FOR NEW VARIABLES              ******;
LABEL _Node_ = 'Node number';
LABEL _Leaf_ = 'Leaf number';
LABEL _WARN_ = 'Warnings';
LABEL P_BAD0 = 'Predicted: BAD=0';
LABEL P_BAD1 = 'Predicted: BAD=1';
LABEL V_BAD0 = 'Validated: BAD=0';
LABEL V_BAD1 = 'Validated: BAD=1';
 
 _WARN_ = ' ';
 
******      TEMPORARY VARIABLES FOR FORMATTED VALUES      ******;
 
******             ASSIGN OBSERVATION TO NODE             ******;
IF NOT MISSING(DEBTINC) AND ((DEBTINC >= 43.84338265477999))
 THEN DO;
  IF NOT MISSING(CLAGE) AND ((CLAGE >= 222.358612846148))
   THEN DO;
    _Node_ = 6;
    _Leaf_ = 1;
    P_BAD0 = 0.5625;
    P_BAD1 = 0.4375;
    V_BAD0 = 0.66666667;
    V_BAD1 = 0.33333333;
  END;
  ELSE DO;
    _Node_ = 5;
    _Leaf_ = 0;
    P_BAD0 = 0;
    P_BAD1 = 1;
    V_BAD0 = 0.1;
    V_BAD1 = 0.9;
  END;
END;
ELSE DO;
IF NOT MISSING(DEROG) AND ((DEROG >= 1.1))
 THEN DO;
  IF NOT MISSING(DEROG) AND ((DEROG >= 2.1))
   THEN DO;
    _Node_ = 10;
    _Leaf_ = 4;
    P_BAD0 = 0.38095238;
    P_BAD1 = 0.61904762;
    V_BAD0 = 0.25;
    V_BAD1 = 0.75;
  END;
  ELSE DO;
    _Node_ = 9;
    _Leaf_ = 3;
    P_BAD0 = 0.73913043;
    P_BAD1 = 0.26086957;
    V_BAD0 = 0.88461538;
    V_BAD1 = 0.11538462;
  END;
END;
ELSE DO;
  IF NOT MISSING(DELINQ) AND ((DELINQ >= 3.1))
   THEN DO;
    _Node_ = 8;
    _Leaf_ = 2;
    P_BAD0 = 0.47619048;
    P_BAD1 = 0.52380952;
    V_BAD0 = 0.3;
    V_BAD1 = 0.7;
  END;
  ELSE DO;
    IF NOT MISSING(CLAGE) AND ((CLAGE < 175.64873886818))
     THEN DO;
      IF NOT MISSING(VALUE) AND ((VALUE < 50634.36))
       THEN DO;
        IF NOT MISSING(CLAGE) AND ((CLAGE >= 128.938864890212))
         THEN DO;
          _Node_ = 16;
          _Leaf_ = 8;
          P_BAD0 = 0.25;
          P_BAD1 = 0.75;
          V_BAD0 = 0.6;
          V_BAD1 = 0.4;
        END;
        ELSE DO;
          _Node_ = 15;
          _Leaf_ = 7;
          P_BAD0 = 0.89041096;
          P_BAD1 = 0.10958904;
          V_BAD0 = 0.78947368;
          V_BAD1 = 0.21052632;
        END;
      END;
      ELSE DO;
        _Node_ = 14;
        _Leaf_ = 6;
        P_BAD0 = 0.92989691;
        P_BAD1 = 0.070103093;
        V_BAD0 = 0.92970522;
        V_BAD1 = 0.070294785;
      END;
    END;
    ELSE DO;
      _Node_ = 12;
      _Leaf_ = 5;
      P_BAD0 = 0.97051171;
      P_BAD1 = 0.029488291;
      V_BAD0 = 0.97111111;
      V_BAD1 = 0.028888889;
    END;
  END;
END;
END;
****************************************************************;
******     END OF HP TREE (PROC HPSPLIT) SCORING CODE    ******;
****************************************************************;
