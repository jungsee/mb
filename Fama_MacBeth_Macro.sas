****************************************************************************
Fama-MacBeth regressions
* Macro summarizes regression results over a number of groups               
* Provides mean estimate, #positive, mean t-stat, #sig., mean n and adj. r2,
*  also Z1, Z2, and Fama-MacBeth t-statistic
* prnt1 prints coefficient estimates, prnt2 prints r2's and sample sizes,
*   just set it to 'yes' to print them, anything else doesn't
* minobs allows you to require a minimum # of obs per regression
****************************************************************************;

%macro regby(dset=,byvar=,yvar=,xvars=,minobs=0,print_est=yes,print_r2=yes,indformat=);

%if &indformat ne
   %then %let prntfmt = format &indformat indfmt.;
   %else %let prntfmt = ;
    
proc sort data=&dset out=xdset;
    by &byvar;
    run;

ods listing close;
ods output ParameterEstimates = xpe(drop=DF Dependent Model);
ods output FitStatistics = xr2;
ods output ANOVA = xanova;
proc reg data=xdset;
    by &byvar;
    model &yvar = &xvars;
    run;
ods output close;
ods listing;

data xpeprint;
    set xpe;
    where substr(Variable,1,3) not in ('Int', 'dy_', 'di_');
    run;

proc sort data=xpeprint;
    by Variable &byvar;
    run;
    
%if &print_est = 'yes' %then %do;
    proc print data=xpeprint;
        &prntfmt;
        run;
%end;

data xanova;
    set xanova;
    where Source = 'Corrected Total';
    nobs = DF + 1;
    keep &byvar nobs;
    run;

data xpe (drop = &byvar nobs);
    merge xanova xpe (drop = Probt StdErr);
    by &byvar;
    if nobs ge &minobs;
    z1temp = tValue / sqrt((nobs-1)/(nobs-3));
    run;

proc sort data=xpe;
    by Variable;
    run;

proc means data=xpe(keep = Variable z1temp) noprint;
    by Variable;
    output out=xmeans1(drop=_:) sum=;
    run;

proc means data=xpe noprint;
    by Variable;
    var Estimate tValue;
    output out=xmeans2(drop=_type_ rename=(_freq_=n))
           mean   =meanEst   meant
           median =medianEst mediant
           stddev =stdEst    stdt;
    run;

data xpe;
    set xpe (rename = (Estimate = estPos tValue = tSigPos));
    tSigNeg = tSigPos;
    if estPos  <  0.00 then estPos  = .;
    if tSigPos <  1.65 then tSigPos = .;
    if tSigNeg > -1.65 then tSigNeg = .;
    drop z1temp;
    run;

proc means data=xpe noprint;
    by Variable;
    output out=xmeans3 n=;
    run;

data xr2;
    set xr2(rename=(nValue2=adjr2));
    where Label2 = 'Adj R-Sq';
    keep &byvar adjr2;
    run;

data xother;
    merge xanova xr2;
    by &byvar;
    run;

%if &print_r2 = 'yes' %then %do;
    proc print data=xother;
        &prntfmt;
        run;
%end;

proc means data=xother noprint;
    var nobs adjr2;
    output out=xmeans4(drop=_:) mean=;
    run;

proc transpose data=xmeans4 out=xmeans4(rename=(_name_=Variable COL1=meanEst));
    run;

data xout;
    merge xmeans1 xmeans2 xmeans3;
    by Variable;
    run;

data xout;
    set xout xmeans4;
    fmt = meanEst * sqrt(n-1) / stdEst;
    z1 = z1temp / sqrt(n);
    z2 = meant * sqrt(n-1) / stdt;
    estNeg = n - estPos;
    run;

proc print data=xout noobs round;
    var Variable n meanEst medianEst estPos estNeg meant mediant tSigPos tSigNeg fmt z1 z2;
    run;

%mend;