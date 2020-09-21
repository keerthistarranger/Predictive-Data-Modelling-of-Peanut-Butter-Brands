Title'Group 3'
/* grocery dataset*/
data groc;
infile 'C:\Users\vxa180017\Desktop\peanbutr_groc_1114_1165' firstobs=2 missover;
input IRI_KEY WEEK SY GE VEND ITEM UNITS DOLLARS F $ D PR;
run;
proc print data=groc(obs=6);run;
/product description dataset/
PROC IMPORT DATAFILE='C:\Users\vxa180017\Desktop\prod_peanbutr.xls' OUT =peanbutr DBMS=xls replace;
RUN;
proc print data=peanbutr(obs=6);run;

/* creating new column in grocery data for merging purpose*/
data peanbutr_groc;
set groc;
upc_new=cats(of SY GE VEND ITEM);
run;
/* creating new column in product dataset for merging purpose*/
data peanbutr_prod;
set peanbutr;
upc_new=cats(of SY GE VEND ITEM) ;
run;

/* sorting grocery data*/
proc sort data=peanbutr_groc;
by upc_new;
run;

/* sorting product  data*/
proc sort data=peanbutr_prod;
by upc_new;
run;

/merging grocery and prod data/
data groc_prod;
merge peanbutr_groc(DROP = SY GE VEND ITEM IN=aa) peanbutr_prod(DROP = SY GE VEND ITEM UPC);
by upc_new;
if aa;
run;
proc print data=groc_prod(obs=6);run;

/Location Data/
Data location;
infile "C:\Users\vxa180017\Desktop\Delivery_Stores"  firstobs = 2;
/LENGTH IRI_KEY  Market_Name$ 22 Open 8;/
input IRI_KEY OU$ EST_ACV Market_Name $20-44 Open Clsd MskdName$;
run;
proc print data=location(obs=6);run;
/sorting groc_prod data/
proc sort data=groc_prod;
by Iri_key;
run;
/sorting location data/
proc sort data=location;
by Iri_key;
run;
data groc_prod_location;
merge groc_prod(IN=aa)location;
by IRI_KEY;
if aa;
run;
proc print data=groc_prod_location(obs=20);run;

/Panel Data/
PROC IMPORT DATAFILE='C:\Users\vxa180017\Desktop\Panel_Data.xlsx' OUT =panel DBMS=xlsx replace;
RUN;
proc print data=panel(obs=6);run;

/Panel_demo Data/
PROC IMPORT DATAFILE='C:\Users\vxa180017\Desktop\panel_demo.csv' OUT =panel_demo DBMS=csv replace;
RUN;
proc print data=panel_demo(obs=6);run;

/Sortigand Panel data Using IRIS Key/
proc sort data=panel;
by Panelist_ID;
run;
proc sort data=panel_demo;
by Panelist_ID;
run;


/merging panel and panel_demo data/
data panel_loc;
merge panel(IN=aa DROP = WEEK UNITS OUTLET DOLLARS) panel_demo;
by Panelist_ID;
if aa;
run;
proc print data=panel_location(obs=6);run;