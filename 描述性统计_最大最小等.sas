
/*Kaz's SAS juku*/
/*www.estat.us*/
/*PROC CONTENTS to create a data dictionary*/


Data ABC;
set sashelp.Prdsale; /*This is a SAS default data set for a practice*/
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
proc means data=ABC;
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




