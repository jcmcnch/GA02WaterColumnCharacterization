#!/bin/bash

#clear output folder
rm -rf 02-split-data-tables
#make output folder
mkdir -p 02-split-data-tables
#strip header
rm 01-closest-CTD-profiles/corresponding.ctd.profiles.header-stripped.tsv
tail -n+2 01-closest-CTD-profiles/corresponding.ctd.profiles.tsv > 01-closest-CTD-profiles/corresponding.ctd.profiles.header-stripped.tsv

while read line; do 

	#strings for grepping
	BioGEOTRACES_info=`echo $line | cut -f1 -d" "`
	BioGEOTRACES_grep_string=`echo $BioGEOTRACES_info | sed 's/_/\t/'`
	#convert underscore to tab so can directly grep tsv
	CTD_info=`echo $line | cut -f2 -d" "`
	#remove forward slash for output names
	CTDoutname=`echo $CTD_info | sed 's/\//_/'`	
	
	#setup output files
        outfolder=02-split-data-tables/$BioGEOTRACES_info
	mkdir -p $outfolder
	BottleIn=input/Table_3_bioGEOTRACES.sorted.clean.metadata.GA02.tsv
	BottleOut=$outfolder/$BioGEOTRACES_info.bottle-data.tsv
        CTDin=input/GEOTRACES_IDP2017_v1_CTD_Sensor_Data.GA02-grep.tsv
        CTDout=$outfolder/$BioGEOTRACES_info.$CTDoutname.CTD-data.tsv

	#remove output if exists
	rm -f $CTDout $BottleOut
	head -n1 $CTDin > $CTDout
	grep "$CTD_info	" $CTDin >> $CTDout
	head -n1 $BottleIn > $BottleOut
	grep "$BioGEOTRACES_grep_string	" $BottleIn >> $BottleOut

done < 01-closest-CTD-profiles/corresponding.ctd.profiles.header-stripped.tsv
