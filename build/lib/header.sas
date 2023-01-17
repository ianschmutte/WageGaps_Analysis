/*Repository location*/
%let trunk = /work/imslab/WageGaps_Analysis;

/*input data path*/
%let irais_path = &trunk./data/IRAIS-research;
*%let idx_path = /data/CleanData/RAIS/v2019March;

/*externals*/
%let external_path = &trunk./build/external;

/*working path*/
%let wrk_path = &trunk./data/interwrk;

/*output paths*/
%let dataout_path = &trunk./data/out;

******************************
**Libraries
******************************;
LIBNAME IRAIS     ("&irais_path.", "&idx_path.");
LIBNAME EXTERNAL "&external_path.";
LIBNAME INTERWRK  "&wrk_path.";
LIBNAME DBOUT     "&dataout_path.";

******************************
**Options
******************************;
options obs=MAX fullstimer symbolgen mprint LRECL=600 linesize=120;

