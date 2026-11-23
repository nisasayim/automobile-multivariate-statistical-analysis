/* SPSS .sav dosyasını SAS'e aktarma */
proc import datafile="/home/u64415764/filtrelenmis_proje.sav"
    out=proje_verisi
    dbms=sav
    replace;
run;

/* VERİYİ STANDARTLAŞTIRMA (Z-SCORE) */
proc stdize data=proje_verisi out=std_verisi method=std;
   var price horsepower citympg curbweight compressionratio;
run;

/*Hiyerarşik Kümeleme Analizi*/
proc cluster data=std_verisi method=ward outtree=ward ;
  VAR price horsepower citympg curbweight compressionratio; /*Analize girecek değişkenlerin adları*/
run;

/* Dendrogramı çizdirme */
proc tree data=ward;
title 'Hiyerarşik Kümeleme Dendrogramı';
run;

/*K-MEANS KÜMELEME ANALİZİ*/
proc fastclus data=std_verisi maxiter=20 maxclusters=3 list distance out=clust; 
    var price horsepower citympg curbweight compressionratio;
run;

/*Değişkenlerin kümelemede anlamlı olup olmadığını görmek için glm komutu kullanılıyor */
proc glm data=clust; 
    class cluster;
    model price=cluster;
    title 'ANOVA Testi: Fiyat';
run;

proc glm data=clust; 
    class cluster;
    model horsepower=cluster;
    title 'ANOVA Testi: Beygir Gücü';
run;

proc glm data=clust; 
    class cluster;
    model citympg=cluster;
    title 'ANOVA Testi: Yakıt Tüketimi';
run;

proc glm data=clust; 
    class cluster;
    model curbweight=cluster;
    title 'ANOVA Testi: Araç Ağırlığı';
run;

proc glm data=clust; 
    class cluster;
    model compressionratio=cluster;
    title 'ANOVA Testi: Sıkıştırma Oranı';
run;



