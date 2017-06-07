


dm 'log; clear; output; clear;'; 


libname dd "D:\mb\sas_data";






/**********************************************************
Purpose: trim or winsorize SAS dataset to remove the impact from extreme values

Input
 dsetin  : dataset to winsorize/trim
 byvar   : define subset to winsorize/trim,e.g. 'date'. type 'none' for the whole dataset
 type    : 'delete' or 'winsor' (delete will trim, winsor will winsorize
 vars    : subsetting variables to winsorize/trim on; type 'none for no byvar
 pctl    : the percenagte of left and right tails to trim/winsorize

Output
 dsetout : dataset to output with winsorized/trimmed values
************************************************************/

%macro winsor(dsetin=, dsetout=, byvar=none, vars=, type=winsor, pctl=1 99);

%if &dsetout = %then %let dsetout = &dsetin;
    
%let varL=;
%let varH=;
%let xn=1;

%do %until ( %scan(&vars,&xn)= );
    %let token = %scan(&vars,&xn);
    %let varL = &varL &token.L;
    %let varH = &varH &token.H;
    %let xn=%EVAL(&xn + 1);
%end;

%let xn=%eval(&xn-1);

data xtemp;
    set &dsetin;
    run;

%if &byvar = none %then %do;

    data xtemp;
        set xtemp;
        xbyvar = 1;
        run;

    %let byvar = xbyvar;

%end;

proc sort data = xtemp;
    by &byvar;
    run;

proc univariate data = xtemp noprint;
    by &byvar;
    var &vars;
    output out = xtemp_pctl PCTLPTS = &pctl PCTLPRE = &vars PCTLNAME = L H;
    run;

data &dsetout;
    merge xtemp xtemp_pctl;
    by &byvar;
    array trimvars{&xn} &vars;
    array trimvarl{&xn} &varL;
    array trimvarh{&xn} &varH;

    do xi = 1 to dim(trimvars);

        %if &type = winsor %then %do;
            if not missing(trimvars{xi}) then do;
              if (trimvars{xi} < trimvarl{xi}) then trimvars{xi} = trimvarl{xi};
              if (trimvars{xi} > trimvarh{xi}) then trimvars{xi} = trimvarh{xi};
            end;
        %end;

        %else %do;
            if not missing(trimvars{xi}) then do;
              if (trimvars{xi} < trimvarl{xi}) then delete;
              if (trimvars{xi} > trimvarh{xi}) then delete;
            end;
        %end;

    end;
    drop &varL &varH xbyvar xi;
    run;

%mend winsor;



dm 'log; clear; output; clear;'; 


libname dd "D:\mb\sas_data";



data all0601_d(encoding=wlatin1);
set  dd.all0601_d(encoding=wlatin1);
run;


%winsor(dsetin=all0601_d, dsetout=all0601_e,byvar=none, vars= mb cf rd  own bhi size roa ebit lev tat sg dual inddir magshare ,type=winsor, pctl=5 95);
 
proc means data= all0601_e;
var  mb cf rd  own bhi size roa ebit lev tat sg dual inddir magshare  ;
run;



data dd.all0601_e(encoding=wlatin1);
set  all0601_e(encoding=wlatin1);
run;



data dd.abc(encoding=wlatin1);
set  all0601_e(encoding=wlatin1);
run;


Data ABC;
set dd.abc(keep= mb cf rd  own bhi size roa ebit lev tat sg dual inddir magshare ) ; /*This is a SAS default data set for a practice*/
run;


/*1111111111111111111111111*/
/*simple way*/
/*I like "position option" because it gives me a table that is sorted by the position
of variables in the data, in addition to alphabetically sorted table*/
proc contents data=ABC position;
run;




/*2222222222222222222222222*/
/*Easiest way to produce RTF or EXCEL documents off PROC CONTENTS*/
/*but I don't like this way because it comes with too many details*/
ods rtf file ="C:\datadictionary1.rtf";
proc contents data=ABC position;
run;
ods rtf close;

ods html file ="C:\datadictionary1.xls";
proc contents data=ABC position;
run;
ods html close;

/*Using ODS we get only the data we want.*/
proc contents data=ABC position;
ods output position=whatever_name_you_want ;
run;

ods rtf file ="C:\datadictionary2.rtf";
proc print data=whatever_name_you_want noobs;
title "data dictionary in RTF";
var variable label ;
run;
ods rtf close;

ods html file ="C:\datadictionary2.xls";
proc print data=whatever_name_you_want noobs;
title "data dictionary in Excel";
var variable label ;
run;
ods html close;




/*3333333333333333333333333*/
/*And you can use data steps to manipute the result data set to customize it*/
/*Here I do something tedious but worth while doing*/
/*Merge content data with descriptive statistics*/
/*Feels tedious, but once you write this, you can use it for later use or you can even just use this program 
for your purpose*/
/*proc contents here*/
proc contents data=ABC position;
ods output position=whatever_name_you_want ;
run;

/*get means here*/


proc means data=ABC  n  min max mean median std stderr Skewness Kurtosis t prt  maxdec =3 ;
var  mb cf rd  own bhi size roa ebit lev tat sg dual inddir magshare;
ods output summary=result_from_proc_mean;
run;




proc transpose data=result_from_proc_mean out=transposed_data;
run;

data transposed_data;
set transposed_data;
/*get rid of part of the names*/
_name_=tranwrd(_name_,"_Mean","");
_name_=tranwrd(_name_,"_StdDev","");
_name_=tranwrd(_name_,"_Max","");
_name_=tranwrd(_name_,"_Min","");
_name_=tranwrd(_name_,"_N","");

_name_=tranwrd(_name_,"_StdErr","");
_name_=tranwrd(_name_,"_Skew","");
_name_=tranwrd(_name_,"_Kurt","");
_name_=tranwrd(_name_,"_t","");
_name_=tranwrd(_name_,"_Probt","");
_name_=tranwrd(_name_,"_Median","");


run;

proc transpose data=transposed_data out=transposed_data2;
by _name_  notsorted ;
var col1;
id _label_;
run;

data transposed_data2;
length variable $ 32; /*I needed to do this because in the content data the length is 32*/
set transposed_data2;
variable=_name_;
run;


proc sort data=whatever_name_you_want;by variable;run;
proc sort data=transposed_data2;by variable;run;

data newdata;
merge whatever_name_you_want transposed_data2;
by variable;
run;

/*I want to retain the original sequence of variables (which I lost by PROC SORT above that I had to use
before merging*/
proc sort;
by  Num;run;


ods rtf file ="C:\datadictionary3.rtf";
proc print data=newdata noobs;
title "data dictionary in RTF";
var variable label N Mean STD_dev Minimum Maximum ;
run;
ods rtf close;

ods html file ="C:\datadictionary3.xls";
proc print data=newdata noobs;
title "data dictionary in Excel";
var variable label N Mean STD_dev Minimum Maximum ;
run;
ods html close;







ods tagsets.excelxp file="D:\mb\RESULTS\Descriptive_Table.xls" options(sheet_name="Descriptive_Table") style=analysis;

proc print data=newdata    ;
 
run; 

ods tagsets.excelxp close;


