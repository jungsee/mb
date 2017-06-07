/*******************************************************************\    
|SAS PROGRAM to demonstrate how to make a regression table in one SAS program | 
 Creates an excel sheet table in my document folder.
|by Kazuaki Uekawa, Ph.D. 																					|
|Independent SAS consultant																				|
|(ueka@src.uchicago.edu)																					    |           	
|http://www.src.uchicago.edu/users/ueka																|
|http://www.geocities.com/sastip																			|
********************************************************************/ 


data kaz;
input
acro $ NATION $ 6-14   NAME  $    15-33          MAT7  MAT8         GNP14 PROP NATEXAM NATSYLB NATTEXT block $;
cards;
aus  Australi Australia           498 529.63 -0.15526   84    0       1       0    ocea
aut  Austria  Austria             509 539.43 -0.29163  100    0       0       1    weuro
bfl  Belgi_FL Belgium (Fl)        558 565.18 -0.25157  100    1       1       0    weuro
bfr  Belgi_FR Belgium (Fr)        507 526.26 -0.25157  100    0       1       0    weuro
can  Canada   Canada              494 527.24  0.07184   88    0       0       0    namer
col  Colombia Colombia            369 384.76 -0.23699   62    0       1       0    samer
cyp  Cyprus   Cyprus              446 473.59 -0.41906   95    0       1       1    seuro
csk  Czech    Czech Republic      523 563.75 -0.34840   86    0       1       0    eeuro
dnk  Denmark  Denmark             465 502.29 -0.34057  100    1       0       0    weuro
fra  France   France              492 537.83  0.55791  100    0       1       0    weuro
deu  Germany  Germany             484 509.16  0.91992  100    0       0       0    weuro
grc  Greece   Greece              440 483.90 -0.32620   99    0       1       1    seuro
hkg  HongKong Hong Kong           564 588.02 -0.31638   98    1       1       1    seasia
hun  Hungary  Hungary             502 537.26 -0.37602   81    0       0       0    eeuro
isl  Iceland  Iceland             459 486.78 -0.42606  100    0       0       0    neuro
irn  Iran     Iran, Islamic Rep.  401 428.33 -0.17095   66    0       1       1    meast
irl  Ireland  Ireland             500 527.40 -0.38919  100    1       1       0    weuro
isr  Israel   Israel                . 521.59 -0.35464   87    0       1       0    meast
jpn  Japan    Japan               571 604.77  1.85543   96    0       1       0    seasia
kor  Korea    Korea               577 607.38 -0.01168   93    0       1       1    seasia
kwt  Kuwait   Kuwait                . 392.18 -0.40359   60    0       1       1    meast
lva  Latvia   Latvia (LSS)        462 493.36 -0.42319   87    0       0       0    eeuro
ltu  Lithuani Lithuania           428 477.23 -0.41785   78    1       1       1    eeuro
nld  Netherla Netherlands         516 540.99 -0.18184   93    1       0       0    weuro
nzl  NewZeala New Zealand         472 507.80 -0.38319  100    1       1       0    ocea
nor  Norway   Norway              461 503.29 -0.35450  100    0       1       1    neuro
prt  Portugal Portugal            423 454.45 -0.32588   81    0       1       0    weuro
rom  Romania  Romania             454 481.55 -0.35396   82    1       1       1    eeuro
rus  RussianF Russian Federation  501 535.47  0.12827   88    1       0       0    eeuro
sco  Scotland Scotland            463 498.46  0.48017  100    0       0       0    weuro
sgp  Singapor Singapore           601 643.30 -0.37279   84    1       1       1    seasia
slv  SlovakRe Slovak Republic     508 547.11 -0.40217   89    0       1       0    eeuro
svn  Slovenia Slovenia            498 540.80 -0.41310   85    0       1       1    eeuro
esp  Spain    Spain               448 487.35  0.03461  100    0       1       1    weuro
swe  Sweden   Sweden              477 518.64 -0.30049   99    0       1       0    neuro
che  Switzerl Switzerland         506 545.44 -0.27916   91    0       0       0    weuro
tha  Thailand Thailand            495 522.37 -0.14533   37    0       1       1    seasia
usa  USA      United States       476 499.76  5.37506   97    0       0       0    namer
;run;
proc print;run;


ods listing close;/*this suppresses printing of results*/
/*Do OLS regression here and produces reult data set using ODS line*/
/*data set param1 will contain results*/
proc reg data=kaz;
title "math department density modeling";
model mat8= mat7;
model mat8=mat7 gnp14;
model mat8= mat7 gnp14 prop;
model mat8= mat7 gnp14 prop natexam;
model mat8= mat7 gnp14 prop natexam natsylb;
ods output parameterestimates=param1;
run;
ods listing;/*now allows printing*/

/*transpose result data twice, so it looks like a table*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;

/*I assign *** depending on the level of significance*/
/*There may be a better way to do this--without using this one data step.
Maybe assign *** in the final proc report part*/
data paramT4;set paramT3;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='~';
if model&suji.probT < 0.05 then model&suji.SIG='*';
if model&suji.probT < 0.01 then model&suji.SIG='**';
if model&suji.probT < 0.001 then model&suji.SIG='***';
if model&suji.probT < 0.0001 then model&suji.SIG='****';
if model&suji.probT <-9999 then model&suji.SIG='     ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);

run;

/*using PROC REPORT, print out the content of data set paramT4*/
ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: Modeling Mathematics achievement Level";
footnote1 "Continuous Variables are standardized, mean=0 std=1.";
footnote2 "";
column  
_NAME_
Model1Estimate
Model1STDerr
model1SIG
Model2Estimate
Model2STDerr
Model2SIG
Model3Estimate
Model3STDerr
Model3SIG
Model4Estimate
Model4STDerr
Model4SIG
Model5Estimate
Model5STDerr
Model5SIG
;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"A"  format=comma6.2;
define Model2Estimate /"B"  format=comma6.2;
define Model3Estimate /"C"  format=comma6.2;
define Model4Estimate /"D"  format=comma6.2;
define Model5Estimate /"E"  format=comma6.2;
define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
run;

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "d:\OLSparam1.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

