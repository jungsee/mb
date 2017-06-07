


/*Please load the SAS dataset Sample into your work library and name it 'sample';
*Please load the SAS dataset Factors_monthly into your work library and name it 'factors_monthly'
*The sample data contains stock-month observation for 2009-2010 period and Permno<=15000 stocks;
*The Sample data contains 
PERMNO:stock identifier;
Date:the last trading day of holding month return;
MT: time identifier. MT = 12*(year(date)-1963)+month(date)-6, MT=0 for June 1963;
Ret: the holding month return;
Size_lag: last month market cap, used for value weighting;
logme: Size defined in Fama and French (1992);
logbm: Book-to-market ratio defined in Fama and Frech (1992);

*The Factors_monthly data contain MT, four common factors, and risk-free rate;
*/


* Example 1. Single Portfolio sort;
* Examine size effect;

*sorting variable;
%let rankvar = logme;
*depdendent variable;
%let var = ret;
*time variable and number of groups;
%let timevar = mt; 
%let n=10;*10 groups for example;

data sample2;
set sample;
keep permno mt ret &rankvar size_lag;
run;

proc sort;      by &timevar;      run;


proc rank data=sample2(where=(&rankvar~=.)) out=test group=&n; 
      by &timevar; 
      var &rankvar; 
      ranks ranksort;
      run;
proc sort; by &timevar ranksort;   run;

data test; 
      set test; 
      ranksort=ranksort+1;
      &var =&var*100;
      run;

 
proc means data=test noprint;       by &timevar ranksort;   var &var;       output out=ewmeanret mean=;   run;
data ewmeanret;   set ewmeanret;    weight='EW';      run;
proc means data=test noprint;       by &timevar ranksort;   var &var;       weight size_lag; output out=vwmeanret mean=;   run;
data vwmeanret;   set vwmeanret;    weight='VW';      run;

data meanret;     set ewmeanret vwmeanret;      run;

data meanret;     set meanret;      if ranksort=. then delete;    run;


*use single sort macro to generate long-short spread and alphas,ourt reports in row, outc reports in column;
%singlesort_adj(lag=3, data=meanret, byvar=weight, rankvar=ranksort, timevar= &timevar, var=&var, outr=sort1, outc=sort2);





%macro singlesort_adj(lag=, data=, byvar=, rankvar=, timevar=, var=, outr=, outc=);


* transpose if multiple key variables;
proc sort data=&data; 
	by &byvar &rankvar &timevar;
	run;

proc transpose data=&data out=data; 
	by &byvar &rankvar &timevar; 
	var &var;
	run;

*Find H-L difference;
proc sort data=&data out=sum; 
	by &byvar &timevar &rankvar;
	run;

data sum_diff; 
	set sum; 
	by &byvar &timevar &rankvar; 
	if first.&timevar or last.&timevar;
	if first.&timevar then &rankvar=1; 
	if last.&timevar then &rankvar=2; 
	run;

proc transpose data=sum_diff out=sum_diff2; 
	by &byvar &timevar; 
	var &var; 
	id &rankvar; 
	run;

data sum_diff2; 
	set sum_diff2; 
	&rankvar=99; 
	col1 = _2 - _1; 
	drop _2 _1; 
	run;

data sum_diff2; 
	set data sum_diff2;
	run;

proc sort data=sum_diff2; 
	by &byvar _name_ &rankvar;
	run;

*** link four factors to get alpha;
proc sql;
  create table sum_diff2 as
  select a.*, (a.col1-b.rf*100) as exret, b.mktrf*100 as mktrf, b.smb*100 as smb, b.hml*100 as hml, b.umd*100 as umd
  from sum_diff2 as a left join factors_monthly as b
  on a.&timevar = b.mt;
quit;

proc sort data=sum_diff2; 
	by &byvar _name_ &rankvar &timevar;

data sum_diff2; 
	set sum_diff2; 
	if &rankvar=99 then exret=col1; 
	run;


proc sort data=sum_diff2; 
	by &byvar _name_ &rankvar &timevar;
	run;

*** average return;
options nonotes;

proc model data=sum_diff2; 
	by &byvar _name_ &rankvar;
	parms a; 
	exogenous col1 ; 
	instruments / intonly;
 	col1=a; 
	fit col1 / gmm kernel=(bart, %eval(&lag+1), 0);*lag=6;

ods output parameterestimates=param0  fitstatistics=fitresult
	OutputStatistics=residual;
	quit;

data param0; 
	set param0; 
	type='Average ret';
	run;


*** CAPM alpha; 
options nonotes;
proc model data=sum_diff2; 
	by &byvar _name_ &rankvar;
	parms a b1;
	instruments mktrf;
	exret =a+b1* mktrf; 
	fit exret / gmm kernel=(bart, %eval(&lag+1), 0);
ods output parameterestimates=param1  fitstatistics=fitresult
	OutputStatistics=residual;
	quit;

data param1; 
	set param1; 
	type='CAPM Alpha'; 
	if parameter='a';
	run;

*** Three Factor alpha;
options nonotes;
proc model data=sum_diff2; 
	by &byvar _name_ &rankvar;
	parms a b1 b2 b3;
	instruments mktrf smb hml;
	exret =a+b1* mktrf+b2* smb+b3*hml; 
	fit exret / gmm kernel=(bart, %eval(&lag+1), 0);
ods output parameterestimates=param2  fitstatistics=fitresult
	OutputStatistics=residual;
	quit;

data param2; 
	set param2; 
	type='FF3 Alpha'; 
	if parameter='a';
	run;

*Four factor alpha*;
options nonotes;
proc model data=sum_diff2; 
	by &byvar _name_ &rankvar;
	parms a b1 b2 b3 b4;
	instruments mktrf smb hml umd;
	exret =a+b1* mktrf+b2* smb+b3*hml+b4*umd; 
	fit exret / gmm kernel=(bart, %eval(&lag+1), 0);
ods output parameterestimates=param3  fitstatistics=fitresult
	OutputStatistics=residual;
	quit;

data param3; 
	set param3; 
	type='FF4 Alpha'; 
	if parameter='a'; 
	run;

data param; 
	set param0 param1 param2 param3;
	run;

data param; 
	set param;
	if probt<0.1 then p='*  '; 
	if probt<0.05 then p='** '; 
	if probt<0.01 then p='***';
	tvalue2=put(tvalue,7.2); 
	est=put(estimate, 12.2); 
	param=est;
	if  &rankvar=99 then PARAM=compress(est||p);
	T=compress('('||tvalue2||')'); 
	keep &byvar &rankvar type _name_ param T;
	rename _name_=name;
	run;

*** output to row data;
proc sort data=param; 
	by name &byvar type &rankvar;
	run;
proc transpose data=param out=&outr;
	by name &byvar type; 
	var param T; 
	id &rankvar; 
	run;
data &outr;
	set &outr;
	rename _99=H_L;
	run;
option notes;

*** output to column data;
proc transpose data=param out=j; 
	by name &byvar type &rankvar; 
	var param t; 
	run; 
data j; 
	set j; 
	id=weight||name||type;
	run; 
proc sort data=j; 
	by &rankvar descending _name_ id;
	run;
proc transpose data=j out=&outc; 
	by &rankvar descending _name_; 
	var col1; 
	id id;
	run;


%mend singlesort_adj;



* Example 2. Fama-MacBeth Regression;
* Test the cross-section relation b/w return annd siz, BE/ME;

**1. FM regression each month;

data FM; set sample;run;

proc sort;by mt;run;

%let y = ret; * define dep var here;

proc reg data=FM outest=FB noprint;
	by mt;
	model &y =logme logbm /adjrsq;
	model &y = logme /adjrsq;
    model &y = logbm /adjrsq;

quit;


** 2. drop irrelevant estimates;
proc sort data=FB; by _model_ mt; run;
data FB2; set FB; drop  &y _TYPE_  _DEPVAR_  _RMSE_ _IN_  _P_  _EDF_;
 rename _model_=model; run;

proc transpose data=FB2 out=FBny name=name prefix=coef;
 by model mt; run;
data FBny; set FBny; retain code; 
 by model mt; code=code+1; if first.mt then code=1;run;

proc sort data=FBny; by model code name;run;

** 3. Newey-West t-stat for the time-series average of coefficients;

%let lag=3;*lags for Newey-West t-stat; 
proc model data=FBny; 
 by model code name;
 parms a; exogenous coef1 ; 
 instruments / intonly;
 coef1 =a; 
 fit coef1 / gmm kernel=(bart, %eval(&lag+1), 0);
 ods output parameterestimates=param1  fitstatistics=fitresult
 OutputStatistics=residual;
quit;

** 4. output into column table;

data param1; set param1; 
 tvalue2=put(tvalue,7.2); if probt<0.1 then p='*  ';
 if probt<0.05 then p='** '; if probt<0.01 then p='***';
 T=compress('('||tvalue2||')'); PARAM=compress(put(estimate,7.3)||p);
 run;

data param1a; set param1; keep model code name coef _name_; 
 _name_='PARAM'; coef=PARAM; run;
data param1b; set param1; keep model code name coef _name_;
 _name_='T'; coef=T; run;
data param2; set param1a param1b;run;
proc sort data=param2; by  code _name_ model;run;

proc transpose data=param2 out=param3; 
 by code name _name_; id model; var coef; run;
data param3; set param3; if _name_='T' then do;
 code=. ;name=.;end;run;

** 5. find the range of periods and obs used;

proc sort data=fb out=fb3; by _model_; run;
data fb3; set fb3; keep _model_ mt num; num = _edf_+_p_;
 rename _model_=model; run;
proc sql; create table num(where=(model='MODEL1')) as select
 model, min(mt) as start, max(mt) as end, count(mt) as range,
 sum(num) as obs from fb3 group by model;quit;
proc transpose data=num out=num; by model; var start -- obs; run;
data num; set num; rename _name_=name; MODEL1=put(col1, 7.0);
 drop model col1; run;


 *make final table for reporting;
data param3; set param3 num; run;
 
