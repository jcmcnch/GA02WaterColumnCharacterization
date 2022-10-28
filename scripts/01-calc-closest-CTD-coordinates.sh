#!/bin/bash
mkdir -p 01-closest-CTD-profiles
./scripts/01-calc-closest-CTD-coordinates.py 00-input-lat-long/time-lat-long.tsv input/Table_3_bioGEOTRACES.sorted.clean.metadata.GA02.tsv | sort -gr | uniq > 01-closest-CTD-profiles/corresponding.ctd.profiles.tsv
