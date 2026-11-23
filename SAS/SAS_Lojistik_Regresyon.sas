/* SPSS .sav dosyasını SAS'e aktarma */
proc import datafile="/home/u64415764/filtrelenmis_proje.sav"
    out=proje_verisi
    dbms=sav
    replace;
run;

/* Binary Lojistik Regresyon*/
proc logistic data=proje_verisi;
model aspiration(ref="std") = horsepower citympg carwidth compressionratio 
          / expb       
            lackfit    /* Hosmer-Lemeshow Uyum İyiliği Testi */
            rsquare;   /* R-Kare Değerleri */
output out=outdata predprobs=(individual);
run;

proc freq data=outdata;
    tables _FROM_ * _INTO_;
    title 'Sınıflandırma Tablosu';
run;  

/* Stepwise Lojistik Regresyon*/
proc logistic data=proje_verisi;
    model aspiration(ref="std") = horsepower citympg carwidth compressionratio 
          / expb 
            lackfit 
            rsquare 
            selection=backward;
    output out=outdata2 predprobs=(individual);
run;  

proc freq data=outdata2;
    tables _FROM_ * _INTO_;
    title 'Sınıflandırma Tablosu (Stepwise Model)';
run;      