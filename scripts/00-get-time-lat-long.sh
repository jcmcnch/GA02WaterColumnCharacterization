#!/bin/bash
mkdir -p 00-input-lat-long
head -n1 input/GEOTRACES_IDP2017_v1_CTD_Sensor_Data.GA02-grep.tsv | cut -f 1-6 > 00-input-lat-long/time-lat-long.tsv
tail -n+2 input/GEOTRACES_IDP2017_v1_CTD_Sensor_Data.GA02-grep.tsv | cut -f 1-6 | sort | uniq >> 00-input-lat-long/time-lat-long.tsv
