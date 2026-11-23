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

proc princomp data=proje_verisi 
              n=2
              plots=(scree);
   var wheelbase carlength carwidth curbweight enginesize horsepower citympg price;
run;     

/* FAKTÖR */
proc factor data=proje_verisi  
     corr                         
     method=principal                 
                                    
     nfactors=2                    
     maxiter=25                     
     rotate=varimax                
     reorder                        
     msa                           
     plots=(scree eigen initloadings loading);
     var wheelbase carlength carwidth curbweight enginesize horsepower citympg price; 
run;
