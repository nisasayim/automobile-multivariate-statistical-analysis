/* SPSS .sav dosyasını SAS'e aktarma */
proc import datafile="/home/u64415764/filtrelenmis_proje.sav"
    out=proje_verisi
    dbms=sav
    replace;
run;

/* Grupları Birleştirme ve Temizleme */
data lda_verisi;
    set proje_verisi;
    length yeni_carbody $ 15;
if carbody = 'hatchback' then yeni_carbody = 'Hatchback';
    else if carbody = 'sedan' then yeni_carbody = 'Sedan';
    else yeni_carbody = 'Digerleri';
run;

/* Veri Dağılımı Kontrolü */
/* Hatchback, Sedan ve Diğerleri kaçar tane? */
proc freq data=lda_verisi;
    tables yeni_carbody;
run;


/* Çoklu Bağlantı (Multicollinearity) Kontrolü */
proc corr data=lda_verisi spearman; 
    var price horsepower curbweight citympg carwidth;
run;

/* Normallik Testi (Histogramlar ile) */
proc univariate data=lda_verisi normal;
    var price horsepower curbweight citympg carwidth; 
    histogram / normal; /* Görsel kontrol için histogram */
run;

/* Diskriminant Analizi */
proc discrim data=lda_verisi 
    simple
    pool=test       /* Box's M Test (Varyans Homojenliği) */
    can             /* Canonical: LD1 ve LD2 katsayılarını verir */
    list            /* Her bir aracın tahmin sonucunu listeler */
    crossvalidate;  /* Modeli test eder ve gerçek başarı oranını verir. */
    
    class yeni_carbody;  
    var price horsepower curbweight citympg carwidth; 
    priors proportional; 
run;

/* Adımsal Diskriminant Analizi */
proc stepdisc method=stepwise data=lda_verisi;
    class yeni_carbody;
    var price horsepower curbweight citympg carwidth;
run;


/* Çoklu Diskriminant Analizi  */
proc discrim data=lda_verisi 
    can       /* Canonical: LD1 ve LD2 fonksiyonlarını ve katsayılarını hesaplar */
    simple    /* Basit istatistikler */
    pool=test /* Box's M (Varyans homojenliği testi) */
    list      /* Her bir aracın hangi gruba atandığını listeler */
    crossvalidate; /* Modeli doğrular ve hata oranını verir  */

    class yeni_carbody; 
    var price horsepower curbweight citympg carwidth; 
    priors proportional; /* Grupların orjinal büyüklüklerine göre öncelik ver */
run;



/* 2. Adımsal Diskriminant Analizi (Stepwise) */
proc stepdisc method=stepwise data=lda_verisi;
    class yeni_carbody; 
    var price horsepower curbweight citympg carwidth; 
run;





