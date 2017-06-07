*CP3;

*from pgm: A_NEW Table 4_drips-nondrips-interact_F-M_Panel_2008_2012;
*revised Aug-1-14;			*** for 9612 analysis, before 2008 exclude firms that started drip in 2008;

*this pgm tests coeff of part1-2 in AR(0) regression
*allowing ONLY coeff of PART to change for DRIP vs Non-DRIP stocks;


libname   pp 'R:\users\pkoch\PK_Space\FIN 938_computer problems\CP3_F-M_Panel w clus_Panel w FE_DRIPs';

%include 'R:\users\pkoch\PK_Space\FIN 938_computer problems\CP2_Fama-MacBeth Regressions_dividend pay dates/clus2D.sas';

options obs=max;
ods html close;
ods listing;



*** *** *** *** *** *** *** *** *** ***;
***************************************;
***       BEGIN ANALYSIS HERE       ***;
***************************************;
*** *** *** *** *** *** *** *** *** ***;


data all4;
set  pp.all1_qtr_9612_abridged_before_08;
year=year(date);
m=month(date);
if m in (1,2,3) then q=1;
if m in (4,5,6) then q=2;
if m in (7,8,9) then q=3;
if m in (10,11,12) then q=4;
qrt=year*4+q;
*if (year ge 2008) and (year le 2012);

yld_drip      =yld      *drip;
lnsize_drip   =lnsize   *drip;
Lpct_inst_drip=Lpct_inst*drip;
spread_drip   =spread   *drip;
log_hilo_drip =log_hilo *drip;

run;




********************************************;
*** 1. Fama-MacBeth Regressions on AR(0) ***;

proc sort data=all4;by qrt;run;


*** 1st stage - qtrly AR(0) regr ***;
proc reg data=all4 tableout outest= xxbm_ar0  edf adjrsq noprint;
model  bm_ar0 =drip  yld lnsize Lpct_inst spread log_hilo;
by qrt ;
run;


*xxbm_ar0 contains qtrly t.s. of regression parameters for qtrly AR(0) regressions;
data para_bm_ar0;
set  xxbm_ar0;
where _TYPE_ eq 'PARMS';
bm_ar0_EDF    = _EDF_;
bm_ar0_RSQ    = _RSQ_;
bm_ar0_ADJRSQ = _ADJRSQ_;
dot1=.;
constant=1;
zero=0;

keep  intercept  constant  zero  DRIP
	yld  lnsize  Lpct_inst  spread  log_hilo
	dot1  qrt  bm_ar0_EDF  bm_ar0_RSQ  bm_ar0_ADJRSQ;
run;


*** 2nd stage - t.s. means of qtrly bm_ar0 regr coeffs ***;
proc means data=para_bm_ar0 mean t prt median n;
var intercept  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo
	bm_ar0_EDF  bm_ar0_RSQ  bm_ar0_ADJRSQ
	;
title '1.  Fama-MacBeth Regressions -- 1996-2012 -- ABRIDGED';
*title '1.  Fama-MacBeth Regressions -- 2008-2012';
title2 '';
title3 '1.  dep var  =  bm_ar0  =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
run;



*************************************************************************;
*		Alternative STEP2:  get
*		Fama-MacBeth mean parameter estimates,  obtained using regression;
*		Using Newey-West adj std errors for t.s. mean of qtrly F-M coeffs;
*************************************************************************;
*Dep Var:  AR(0)  =  DRIP PART DRIP*PART  lnsize spread log_hilo yld;


*1.a	t.s. mean of qtrly c.s. OLS coefficients for - intercept;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		intercept = b0*constant;
		fit intercept /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.a.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1  ';
		title6 '';
		title7 'This run gets mean OLS coeff for - intercept';
		run;

*1.b	t.s. mean of qtrly c.s. OLS coefficients for - drip;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		DRIP = b0*constant;
		fit DRIP /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.b.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - DRIP    ';
		run;

*1.c	t.s. mean of qtrly c.s. OLS coefficients for - yld;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		yld    = b0*constant;
		fit yld    /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.c.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1';
		title6 '';
		title7 'This run gets mean OLS coeff for - yld    ';
		run;

*1.d	t.s. mean of qtrly c.s. OLS coefficients for - lnsize;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		lnsize = b0*constant;
		fit lnsize /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.d.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - lnsize  ';
		run;

*1.e	t.s. mean of qtrly c.s. OLS coefficients for - Lpct_inst;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		Lpct_inst = b0*constant;
		fit Lpct_inst /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.e.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1  ';
		title6 '';
		title7 'This run gets mean OLS coeff for - Lpct_inst';
		run;

*1.f	t.s. mean of qtrly c.s. OLS coefficients for - spread;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		spread   = b0*constant;
		fit spread   /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.f.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - spread  ';
		run;

*1.g	t.s. mean of qtrly c.s. OLS coefficients for - log_hilo;
		proc model data=para_bm_ar0;
		parms b0;
		instruments constant;
		log_hilo = b0*constant;
		fit log_hilo /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.g.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - log_hilo';
		run;

****************** Done with Fama-MacBeth ********************;
**************************************************************;



**************************************************************;
************  Panel Regr with Clustered Std Errs *************;

title '2. Panel Regressions -- All Stocks -- 1996-2012 -- ABRIDGED';
*title '2. Panel Regressions -- All Stocks -- 2008-2012';
title2 'Clustered Std Errors -- by permno & qrt';
title3 '';
title4 '2.  dep var = bm_ar0 = f(drip  yld  lnsize  Lpct_inst  spread  log_hilo)';
%clus2D( bm_ar0 , drip  yld lnsize Lpct_inst spread log_hilo , permno, qrt, all4)

******** Done with Panel Regr with Clustered Std Errs ********;
**************************************************************;



**************************************************************;
******** Panel Regr on AR(0) with FE for permno & qrt ********;

proc sort data=all4;by permno qrt;run;

proc glm data=all4;
class  permno qrt;			*** fixed effects ***;
model  bm_ar0 = drip  yld  lnsize  Lpct_inst  spread  log_hilo  permno qrt / SOLUTION;
title '3.  Panel Regression on bm_ar0 with F.E. for permno & qrt -- 1996-2012 -- ABRIDGED';
*title '3.  Panel Regression on bm_ar0 with F.E. for permno & qrt -- 2008-2012';
title2 '';
title3 'All stocks - DRIPS & Non-DRIPs';
title4 '';
title5 'model  bm_ar0 = drip  yld  lnsize  Lpct_inst  spread  log_hilo  permno  qrt';
run;

*** Done with Panel Regr on AR(0) with FE for permno & qrt ***;
**************************************************************;



*************************************************************;
******** Panel Regr on AR(0) with FE for permno ONLY ********;

proc sort data=all4;by permno qrt;run;

proc glm data=all4;
class  permno    ;			*** fixed effects ***;
model  bm_ar0 = drip  yld  lnsize  Lpct_inst  spread  log_hilo  permno / SOLUTION;
title '4.  Panel Regression on bm_ar0 with F.E. for permno ONLY -- 1996-2012 -- ABRIDGED';
*title '4.  Panel Regression on bm_ar0 with F.E. for permno ONLY -- 2008-2012';
title2 '';
title3 'All stocks - DRIPS & Non-DRIPs';
title4 '';
title5 'model  bm_ar0 = drip  yld  lnsize  Lpct_inst  spread  log_hilo  permno';
run;

*** Done with Panel Regr on AR(0) with FE for permno ONLY ***;
*************************************************************;




*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ;




********************************************************************;
*** Now redo F-M on DRIPs vs Non-DRIPS separately + interactions ***;



*********************************************************;
********  I.  F-M Analysis of AR(0) -- MODEL 1   ********;
*********************************************************;

********************************************************************;
***  I.A. STEP 1 - Fama-MacBeth regressions for AR(0) - DRIPS vs non;
********************************************************************;

proc sort data=all4 sortsize=1G;by qrt drip;run;

proc reg  data=all4 outest=x tableout  edf adjrsq NOPRINT ;
model bm_ar0  =        yld  lnsize  Lpct_inst  spread  log_hilo;
BY QUARTER drip;
*** gets F-M coeffs for DRIPs vs Non-DRIPs separately, each qtr  ***;
where quarter ne .;
run;

proc sort data=x; by drip; run;

*x contains qtrly t.s. of regression parameters for qtrly AR regressions;
data para_AR;set x;
where _TYPE_ eq 'PARMS';
by DRIP;
AR_EDF    = _EDF_;
AR_RSQ    = _RSQ_;
AR_ADJRSQ = _ADJRSQ_;
dot1=.;
constant=1;
zero=0;
keep intercept  constant  zero
	       yld  lnsize  Lpct_inst  spread  log_hilo
	 quarter  DRIP  AR_EDF  AR_RSQ  AR_ADJRSQ  dot1;
run;


*************************************************************************;
*** I.B. STEP2:  get
*		  Fama-MacBeth mean parameter est, t-ratios, sample size, & R-squ;
*************************************************************************;

title 'I.1  Fama-MacBeth Regressions  -- 1996-2012 -- ABRIDGED -- Dep.Var. = AR(0)';
*title 'I.1.  Fama-MacBeth Regressions  --  2008-2012  --  Dep.Var. = AR(0)';
title2 '';
title3 'Non-DRIP Stocks  vs  DRIP Stocks  --  Separate Regressions each qtr';
title4 '';
title5 'MODEL 1:  AR(0)  =        yld  lnsize  Lpct_inst  spread  log_hilo ';
title6 '';
title7 't-stats based on std errors of t.s means of Fama-MacBeth qtrly coefficients';
proc means data=para_AR mean t prt n;
var intercept
	yld  lnsize  Lpct_inst  spread  log_hilo
	dot1  AR_EDF  AR_RSQ  AR_ADJRSQ;
output out=AR_FM_results_DRIP_vs_NonDRIP
mean=intercept
	yld  lnsize  Lpct_inst  spread  log_hilo
	dot1  AR_EDF  AR_RSQ  AR_ADJRSQ
t=	t_intercept
	t_yld   t_lnsize  t_Lpct_inst  t_spread  t_log_hilo
	t_dot1  t_AR_EDF  t_AR_RSQ  t_AR_ADJRSQ
;
by DRIP;	*** gets F-M mean coeffs for DRIPs vs Non-DRIPs separately ***;
run;




*************************************************************************;
*  I.B  Alternative STEP2:  get
*		Fama-MacBeth mean parameter estimates,  obtained using regression;
*		Using Newey-West adj std errors for t.s. mean of qtrly F-M coeffs;
*************************************************************************;
*Dep Var:  AR(0)  =  DRIP PART DRIP*PART  lnsize spread log_hilo yld;


*1.a	t.s. mean of qtrly c.s. OLS coefficients for - intercept;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		intercept = b0*constant;
		fit intercept /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.a.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1  ';
		title6 '';
		title7 'This run gets mean OLS coeff for - intercept';
		run;

		*1.c	t.s. mean of qtrly c.s. OLS coefficients for - yld;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		yld    = b0*constant;
		fit yld    /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.c.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1';
		title6 '';
		title7 'This run gets mean OLS coeff for - yld    ';
		run;

*1.d	t.s. mean of qtrly c.s. OLS coefficients for - lnsize;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		lnsize = b0*constant;
		fit lnsize /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.d.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - lnsize  ';
		run;

*1.e	t.s. mean of qtrly c.s. OLS coefficients for - Lpct_inst;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		Lpct_inst = b0*constant;
		fit Lpct_inst /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.e.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1  ';
		title6 '';
		title7 'This run gets mean OLS coeff for - Lpct_inst';
		run;

*1.f	t.s. mean of qtrly c.s. OLS coefficients for - spread;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		spread   = b0*constant;
		fit spread   /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.f.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - spread  ';
		run;

*1.g	t.s. mean of qtrly c.s. OLS coefficients for - log_hilo;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		log_hilo = b0*constant;
		fit log_hilo /gmm kernel = (bart,2,0);
		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.g.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - log_hilo';
		run;








*************************************************************************;
*** I.C. STEP1:  run Fama-MacBeth regressions with ALL DRIP INTERACTIONS;
***		  to test H0: Fama-MacBeth mean coeffs = for DRIPs vs Non-DRIPs  ;
*************************************************************************;

proc sort data=all4 sortsize=1G;by qrt drip;run;
proc reg  data=all4 outest=x tableout  edf adjrsq NOPRINT ;
model bm_ar0  =    yld       lnsize       Lpct_inst       spread       log_hilo
		     DRIP  yld_DRIP  lnsize_DRIP  Lpct_inst_DRIP  spread_DRIP  log_hilo_DRIP;
BY QUARTER;		*** not also by drip ***;
where quarter ne .;
run;

*x contains qtrly t.s. of regression parameters for qtrly AR regressions;
data para_AR;set x;
where _TYPE_ eq 'PARMS';
*by DRIP;					*** NO!!! Not also by DRIP !!!! ***;
AR_EDF    = _EDF_;
AR_RSQ    = _RSQ_;
AR_ADJRSQ = _ADJRSQ_;
dot1=.;
constant=1;
zero=0;
keep intercept  constant zero
		  yld       lnsize       Lpct_inst       spread       log_hilo
	DRIP  yld_DRIP  lnsize_DRIP  Lpct_inst_DRIP  spread_DRIP  log_hilo_DRIP
	dot1 quarter  AR_EDF  AR_RSQ  AR_ADJRSQ;
run;


*************************************************************************;
*** I.D. STEP2:  get
*		  Fama-MacBeth mean parameter est, t-ratios, sample size, & R-squ;
*************************************************************************;

title 'I.2.  Fama-MacBeth Regressions -- 1996-2012 -- ABRIDGED -- Dep.Var. = AR';
*title 'I.2.  Fama-MacBeth Regressions  --  2008-2012  --  Dep.Var. = AR';
title2 'Non-DRIP Stocks  vs  DRIP Stocks   --   Single Regr with ALL DRIP INTERACTIONs';
title3 '';
title4 '';
title5 'MODEL 1:  AR(0)  =   yld       lnsize       Lpct_inst       spread       log_hilo     ';
title6 '			   DRIP  yld_DRIP  lnsize_DRIP  Lpct_inst_DRIP  spread_DRIP  log_hilo_DRIP';
title7 '';
title8 't-stats based on std errors of t.s means of Fama-MacBeth qtrly coefficients';
proc means data=para_AR mean t prt n;
var intercept
		   yld       lnsize       Lpct_inst       spread       log_hilo
	 DRIP  yld_DRIP  lnsize_DRIP  Lpct_inst_DRIP  spread_DRIP  log_hilo_DRIP
		 dot1  AR_EDF     AR_RSQ     AR_ADJRSQ;
output out=AR_FM_results_DRIP_vs_NonDRIP
mean=intercept
		   yld       lnsize       Lpct_inst       spread       log_hilo
	 DRIP  yld_DRIP  lnsize_DRIP  Lpct_inst_DRIP  spread_DRIP  log_hilo_DRIP
	     dot1  AR_EDF     AR_RSQ     AR_ADJRSQ
t=	t_intercept
		   t_yld       t_lnsize       t_Lpct_inst       t_spread       t_log_hilo
   t_DRIP  t_yld_DRIP  t_lnsize_DRIP  t_Lpct_inst_DRIP  t_spread_DRIP  t_log_hilo_DRIP
	   t_dot1  t_AR_EDF     t_AR_RSQ     t_AR_ADJRSQ
;
run;



*************************************************************************;
*		Alternative STEP2:  get
*		Fama-MacBeth mean parameter estimates,  obtained using regression;
*		Using Newey-West adj std errors for t.s. mean of qtrly F-M coeffs;
*************************************************************************;
*Dep Var:  AR(0)  =  DRIP PART DRIP*PART  lnsize spread log_hilo yld;


*1.b	t.s. mean of qtrly c.s. OLS coefficients for - drip;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		DRIP = b0*constant;
		fit DRIP /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.b.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - DRIP    ';
		run;

*1.c	t.s. mean of qtrly c.s. OLS coefficients for - yld;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		yld_DRIP    = b0*constant;
		fit yld_DRIP    /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.c.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1 ';
		title6 '';
		title7 'This run gets mean OLS coeff for - yld_DRIP';
		run;

*1.d	t.s. mean of qtrly c.s. OLS coefficients for - lnsize;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		lnsize_DRIP = b0*constant;
		fit lnsize_DRIP /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.d.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1    ';
		title6 '';
		title7 'This run gets mean OLS coeff for - lnsize_DRIP';
		run;

*1.e	t.s. mean of qtrly c.s. OLS coefficients for - Lpct_inst;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		Lpct_inst_DRIP = b0*constant;
		fit Lpct_inst_DRIP /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE - Fama-MacBeth mean ols coefficients';
		title2 '1.e.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1       ';
		title6 '';
		title7 'This run gets mean OLS coeff for - Lpct_inst_DRIP';
		run;

*1.f	t.s. mean of qtrly c.s. OLS coefficients for - spread;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		spread_DRIP   = b0*constant;
		fit spread_DRIP   /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.f.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1    ';
		title6 '';
		title7 'This run gets mean OLS coeff for - spread_DRIP';
		run;

*1.g	t.s. mean of qtrly c.s. OLS coefficients for - log_hilo;
		proc model data=para_ar;
		parms b0;
		instruments constant;
		log_hilo_DRIP = b0*constant;
		fit log_hilo_DRIP /gmm kernel = (bart,2,0);
*		by DRIP;
		title 'Table 4 - RIGHT SIDE -  Fama-MacBeth mean ols coefficients';
		title2 '1.g.  Dep. Variable:  AR(0)                        ';
		title3 'Model: AR(0) =  DRIP  yld  lnsize  Lpct_inst  spread  log_hilo';
		title4 '';
		title5 'Newey-West adjusted std errors, with L = 1      ';
		title6 '';
		title7 'This run gets mean OLS coeff for - log_hilo_DRIP';
		run;


***   DONE WITH FAMA-MACBETH for AR -- MODEL 1   ***;
****************************************************;


quit;
