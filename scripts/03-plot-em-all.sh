#!/bin/bash -i
conda activate r-oce
mkdir -p CTD-plots

        for dir in 02-split-data-tables/*; do

                cruiseStation=`echo $dir | cut -f2 -d\/`

		#there are multiple CTD casts, do it for all of them
		for CTDfile in `ls 02-split-data-tables/$cruiseStation/*CTD*`; do

			CTD=`basename $CTDfile | cut -f2 -d\.`

			bottle=`ls 02-split-data-tables/$cruiseStation/*bottle*`
			outname=CTD-plots/$cruiseStation.$CTD.profile.pdf
			./scripts/03-make-plots.R $CTDfile $bottle $outname 

		done

	done

