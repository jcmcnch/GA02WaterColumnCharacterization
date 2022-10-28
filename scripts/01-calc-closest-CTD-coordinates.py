#!/usr/bin/env python3

import sys
import csv
#code block below from stackoverflow
#https://stackoverflow.com/questions/41336756/find-the-closest-latitude-and-longitude
from math import cos, asin, sqrt

def distance(lat1, lon1, lat2, lon2):
    p = 0.017453292519943295
    a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p)*cos(lat2*p) * (1-cos((lon2-lon1)*p)) / 2
    return 12742 * asin(sqrt(a))

def closest(data, v):
    return min(data, key=lambda p: distance(v['lat'],v['lon'],p['lat'],p['lon']))

aCoordinateList = []
hashCTDlatlong = {}
for astrLine in csv.reader(open(sys.argv[1]), csv.excel_tab):
    if astrLine[0] != "Cruise":
        hashCTDlatlong[astrLine[1]] = [astrLine[5], astrLine[4]]
        aCoordinateList.append({'lat': float(astrLine[5]),'lon': float(astrLine[4])})


#parse lat long from bioGEOTRACES metadata file
print(*["Station ID", "Closest CTD ID"], sep='\t')
for astrLine in csv.reader(open(sys.argv[2]), csv.excel_tab):
    if astrLine[0] != "Sample name":
        stationID = astrLine[3] + "_" + astrLine[4]
        v = {'lat': float(astrLine[25]), 'lon': float(astrLine[24])}
        closestLatLong = closest(aCoordinateList, v)
        for key, value in hashCTDlatlong.items():
            if float(hashCTDlatlong[key][0]) / closestLatLong['lat'] == 1:
                print(*[stationID, key], sep='\t')

                #print(*[astrLine[4], key, astrLine[25], astrLine[24], closestLatLong['lat'], closestLatLong['lon']], sep='\t') #check to see if script worked by printing two diff lat/long coordinates side by side
