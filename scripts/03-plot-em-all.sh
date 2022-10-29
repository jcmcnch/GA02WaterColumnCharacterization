#!/bin/bash -i
conda activate r-oce
mkdir -p CTD-plots

        for dir in 02-split-data-tables/*; do

                cruiseStation=`echo $dir | cut -f2 -d\/`

		#there are multiple CTD casts, do it for all of them
		for CTDfile in `ls 02-split-data-tables/$cruiseStation/*CTD*`; do

			CTD=`basename $CTDfile | cut -f2 -d\.`

			latCTD=`tail -n+2 02-split-data-tables/$cruiseStation/$cruiseStation.$CTD.CTD-data.tsv | cut -f6 | sort | uniq`
			lonCTD=`tail -n+2 02-split-data-tables/$cruiseStation/$cruiseStation.$CTD.CTD-data.tsv | cut -f5 | sort | uniq`
			latASV=`tail -n+2 02-split-data-tables/$cruiseStation/$cruiseStation.bottle-data.tsv | cut -f26 | sort | uniq`
			lonASV=`tail -n+2 02-split-data-tables/$cruiseStation/$cruiseStation.bottle-data.tsv | cut -f25 | sort | uniq`

			bottle=`ls 02-split-data-tables/$cruiseStation/*bottle*`
			outname=CTD-plots/$cruiseStation.$CTD.profile.pdf
			./scripts/03-make-plots.R $CTDfile $bottle $outname "CTD Profile for $cruiseStation (ASVlatlong=$latASV, $lonASV; CTDlatlong=$latCTD, $lonCTD)"

		done

	done

