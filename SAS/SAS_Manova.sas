/* SPSS .sav dosyasını SAS'e aktarma */
proc import datafile="/home/u64415764/filtrelenmis_proje.sav"
    out=proje_verisi
    dbms=sav
    replace;
run;

/*Değişkenleri kontrol */
proc contents data=proje_verisi;
run;

proc print data=proje_verisi(obs=10);
run;

/*Betimsel*/
proc means data=proje_verisi;
  var price horsepower citympg;
run;

/*Frekans*/
proc freq data=proje_verisi;
  tables carbody drivewheel carbody*drivewheel;
run;

/* Var-cov matrisi homojenliği testi (carbody gruplarına göre) */
proc discrim data=proje_verisi pool=test;
  var price horsepower citympg;
  class carbody;
run;

/*Tek yoklu manova*/
proc glm data=proje_verisi;
  class carbody;
  model price horsepower citympg = carbody / ss3;
  manova h=carbody;
run;
quit;

/*Horsepower (Levene sağlıyor → Tukey)*/
proc glm data=proje_verisi;
  class carbody;
  model horsepower = carbody;
  means carbody / hovtest=levene tukey;
run;
quit;

/* Etkileşimli (çift yönlü) MANOVA: carbody x drivewheel */
proc glm data=proje_verisi;
  class carbody drivewheel;
  model price horsepower citympg = carbody drivewheel carbody*drivewheel / ss3;
  manova h=carbody drivewheel carbody*drivewheel;
  means drivewheel carbody / tukey hovtest=levene;
  lsmeans carbody*drivewheel / adjust=tukey;
run;
quit;

