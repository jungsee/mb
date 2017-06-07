


dm 'log; clear; output; clear;'; 


libname dd "D:\mb\sas_data";

data   all0601_e ;
set  dd.all0601_e;
run;


proc reg data=all0601_e;
model mb= cf rd  own bhi size roa ebit lev tat sg dual inddir magshare  /dw  ; 
run;
quit;



%let outcomevar=mb;
%let tablename=Table_3_Part1;
ods listing close;

proc reg data=all0601_e;

model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  /p clm;

model &outcomevar= cf rd     /p clm;
model &outcomevar= cf rd own     /p clm;
model &outcomevar= cf rd own bhi    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg   /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"   format=comma8.5;
define Model2Estimate /"2"   format=comma8.5;
define Model3Estimate /"3"   format=comma8.5;
define Model4Estimate /"4"   format=comma8.5;
define Model5Estimate /"5"   format=comma8.5;
define Model6Estimate /"6"   format=comma8.5;


define Model1STDerr /""   format=comma8.5;
define Model2STDerr /""   format=comma8.5;
define Model3STDerr  /""  format=comma8.5;
define Model4STDerr /""   format=comma8.5;
define Model5STDerr /""   format=comma8.5;
define Model6STDerr /""   format=comma8.5;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_01") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;




dm 'log; clear; output; clear;'; 



/********************** Correlation_Table ***********************/


ods tagsets.excelxp file="D:\mb\RESULTS\Correlation_Table.xls" options(sheet_name="Correlation_Table") style=analysis;

proc corr data=all0601_e  ;
 var mb cf rd  own bhi size roa ebit lev tat sg dual inddir magshare ;
ods output PearsonCorr = PearsonCorr ;
run; 

ods tagsets.excelxp close;





dm 'log; clear; output; clear;'; 



%let outcomevar=mb;
%let tablename=Table_3_Part2;
ods listing close;

proc reg data=all0601_e;


model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

model &outcomevar= cf rd  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg year2001-year2016 sic_dummy2-sic_dummy76  /p clm;


*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_02") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;






dm 'log; clear; output; clear;'; 




/*************** TABLE 4  ***************/


DATA table4_data;
set all0601_e;
if year<2008;
run;




%let outcomevar=mb;
%let tablename=Table_4_Part1;
ods listing close;

proc reg data=table4_data;

model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  /p clm;

model &outcomevar= cf rd     /p clm;
model &outcomevar= cf rd own     /p clm;
model &outcomevar= cf rd own bhi    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg   /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_03") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;

 



dm 'log; clear; output; clear;'; 




%let outcomevar=mb;
%let tablename=Table_4_Part2;
ods listing close;

proc reg data=table4_data;


model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

model &outcomevar= cf rd  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg year2001-year2016 sic_dummy2-sic_dummy76  /p clm;


*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_04") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;







dm 'log; clear; output; clear;'; 




/*************** TABLE 5  ***************/


DATA table5_data;
set all0601_e;
if year>=2008;
run;




%let outcomevar=mb;
%let tablename=Table_5_Part1;
ods listing close;

proc reg data=table5_data;

model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  /p clm;

model &outcomevar= cf rd     /p clm;
model &outcomevar= cf rd own     /p clm;
model &outcomevar= cf rd own bhi    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare    /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg   /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_05") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;

 


dm 'log; clear; output; clear;'; 





%let outcomevar=mb;
%let tablename=Table_5_Part2;
ods listing close;

proc reg data=table5_data;


model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

model &outcomevar= cf rd  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf rd own bhi  dual inddir magshare size roa ebit lev tat sg year2001-year2016 sic_dummy2-sic_dummy76  /p clm;


*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_06") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;



  

dm 'log; clear; output; clear;'; 




/*************  table 6  **********/

data table6_data;
set all0601_e;

cs=cf*size;
rs=rd*size;
co=cf*own;
ro=rd*own;
cb=cf*bhi;
rb=rd*bhi;
crs=cf*rd*size;
cro=cf*rd*own;
crb=cf*rd*bhi;
run;




%let outcomevar=mb;
%let tablename=Table_6_Part1;
ods listing close;

proc reg data=table6_data;

model &outcomevar= cs rs co ro cb rb crs cro crb  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb  /p clm;

model &outcomevar= cs rs co ro cb rb    /p clm;
model &outcomevar= crs cro crb  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb  /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_07") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;

 



dm 'log; clear; output; clear;'; 




%let outcomevar=mb;
%let tablename=Table_6_Part2;
ods listing close;

proc reg data=table6_data;

model &outcomevar= cs rs co ro cb rb crs cro crb   year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb   year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb   year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

model &outcomevar= cs rs co ro cb rb    year2001-year2016 sic_dummy2-sic_dummy76   /p clm;
model &outcomevar= crs cro crb   year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cs rs co ro cb rb crs cro crb    year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_08") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;



 

options nodate nonumber;
ods listing close;
ods rtf file='D:\mb\RESULTS\Table7.doc';
  
DATA producer;
SET all0601_e;
 
PROC SYSLIN 2sls vardef=n first;
ENDOGENOUS mb  ;
INSTRUMENTS cf rd own bhi size ;
m0: MODEL  mb = cf rd own bhi size ;

m1: MODEL  cf = mb rd own bhi size ;
m2: MODEL  rd =mb  cf   own bhi size ;
m3: MODEL  own =mb cf rd  bhi size ;
m4: MODEL  bhi =mb cf rd own   size ;

RUN; 


  
ods rtf close;
ods listing;






/*************** TABLE 4 remove r & d   ***************/


DATA table4_data;
set all0601_e;
if year<2008;
run;




%let outcomevar=mb;
%let tablename=Table_4_Part1_plus;
ods listing close;

proc reg data=table4_data;

model &outcomevar= cf  own bhi  dual inddir magshare size roa ebit lev tat sg  /p clm;

model &outcomevar= cf      /p clm;
model &outcomevar= cf  own     /p clm;
model &outcomevar= cf  own bhi    /p clm;
model &outcomevar= cf  own bhi  dual inddir magshare    /p clm;
model &outcomevar= cf  own bhi  dual inddir magshare size roa ebit lev tat sg   /p clm;

*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_03_plus") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;

 



dm 'log; clear; output; clear;'; 




%let outcomevar=mb;
%let tablename=Table_4_Part2_plus;
ods listing close;

proc reg data=table4_data;


model &outcomevar= cf  own bhi  dual inddir magshare size roa ebit lev tat sg  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;

model &outcomevar= cf   year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf  own  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf  own bhi  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf  own bhi  dual inddir magshare  year2001-year2016 sic_dummy2-sic_dummy76  /p clm;
model &outcomevar= cf  own bhi  dual inddir magshare size roa ebit lev tat sg year2001-year2016 sic_dummy2-sic_dummy76  /p clm;


*id acro;
ods output parameterestimates=param1 anova=anovaresult  fitstatistics=fitresult
OutputStatistics=residual
;
run;

*%include "C:\REGassist.sas";



/*Getting N of observation, as well as results of F-test*/
data anovaresultA;set anovaresult;
keep model Nobs;
if source="Corrected Total";
Nobs=DF;
data anovaresultB;
retain model Fvalue DF probF;
set anovaresult;

keep model Fvalue probF DF;
if source="Model";
Nobs=DF;
data anova;merge anovaresultA anovaresultB;
by model;
run;


/*Getting R-squares*/
data RsquareA;set fitresult;
keep model Rsquare;
if label2="R-Square";
Rsquare=nvalue2;
data RsquareB;set fitresult;
keep model AdjRsquare;
if label2="Adj R-Sq";
AdjRsquare=nvalue2;
data Rsquare;merge RsquareA RsquareB;
by model;
run;


/*Put together info from Anova and Fitstatistics*/
data info;merge Anova Rsquare;
by model;
run;
proc transpose data=info out=infoT;
id model;
run;

/*and put this into a form that is meargeable with parameter data below*/
data infoT2;
set infoT;
Model1Estimate=Model1;
Model2Estimate=Model2;
Model3Estimate=Model3;
Model4Estimate=Model4;
Model5Estimate=Model5;
Model6Estimate=Model6;

drop _label_ model1 model2 model3 model4 model5 model6 ;
run;

/*Next manupulate main result data*/
proc transpose data=param1 out=paramT;by model;id variable;run;
data paramT2;set paramT;new=compress(Model||_name_)  ;drop _label_;run;
proc transpose data=paramT2 out=paramT3;id new;run;


data paramT4;set paramT3 infoT2;
%macro keisan (suji);
if model&suji.probT < 0.1 then model&suji.SIG='*';
if model&suji.probT < 0.05 then model&suji.SIG='**';
if model&suji.probT < 0.01 then model&suji.SIG='***';
if model&suji.probT < 0.001 then model&suji.SIG='****';
if model&suji.probT < 0.0001 then model&suji.SIG='+';
if model&suji.probT <-9999 then model&suji.SIG='    ';
%mend keisan;
%keisan (suji=1);
%keisan (suji=2);
%keisan (suji=3);
%keisan (suji=4);
%keisan (suji=5);
%keisan (suji=6); /*for now I created up to model 10*/
run;


ods listing;
proc report  data=paramT4  nowd headline  spacing=1 out=OLSparam;
title1 "Table 1: &tablename";
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
Model6Estimate
Model6STDerr
Model6SIG

;
*define _name_/"" order=data;
define _NAME_ /"Variables";
define Model1Estimate /"1"  format=comma6.2;
define Model2Estimate /"2"  format=comma6.2;
define Model3Estimate /"3"  format=comma6.2;
define Model4Estimate /"4"  format=comma6.2;
define Model5Estimate /"5"  format=comma6.2;
define Model6Estimate /"6"  format=comma6.2;


define Model1STDerr /""  format=comma6.2;
define Model2STDerr /""  format=comma6.2;
define Model3STDerr  /""  format=comma6.2;
define Model4STDerr /""  format=comma6.2;
define Model5STDerr /""  format=comma6.2;
define Model6STDerr /""  format=comma6.2;

define model1SIG /"" ;
define model2SIG /"" ;
define model3SIG /"" ;
define model4SIG /"" ;
define model5SIG /"" ;
define model6SIG /"" ;

run;



proc transpose data=residual out=residual2;
by model;
var   residual;run;
*proc print data=residual2;
*run;

data residual3; set residual2;
drop _name_;
proc transpose data=residual3 out=residual4;
run;
*proc print data=residual4;
*run;

data justname;set residual;
where ="MODEL1";
keep acro;
run;

data residualfile;
merge justname  residual4;
if _name_ ne "";
drop _name_;
run;
proc print;
title "&tablename";
run;

/*

PROC EXPORT DATA= WORK.OLSparam
            OUTFILE= "D:\project_ma\rawdata0417\out\&tablename..xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;
*/



ods tagsets.excelxp file="D:\mb\RESULTS\&tablename..xls" options(sheet_name="Regression_04") style=analysis;

proc print data=WORK.OLSparam;
run;

ods tagsets.excelxp close;





