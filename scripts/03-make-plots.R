#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(oce)
d <- read.csv(args[1], sep='\t')
#remove null values
d[d==-999] <- NA

d_bottle <- read.csv(args[2], sep='\t')
#remove null values
d_bottle[d_bottle==-999] <- NA

#order by depth
d_bottle <- d_bottle[order(d_bottle[["PRESSURE..dbar."]], decreasing = TRUE),]
#get CTD basics
salinity <- d[["CTDSAL..pss.78."]]
temperature <- d[["CTDTMP..deg.C."]]
pressure <- d[["CTDPRS..dbar."]]
#additional data
chlfluor <- d[["Fluorescence.Chl.a..mg.m..3."]]
ctdoxy <- d[["CTDOXY..umol.kg."]]
beamatt <- d[["Transmissometer.Beam.Attenuation..1.m."]]
#make CTD object
ctd <- as.ctd(salinity, temperature, pressure)
#add additional data to CTD object
ctd <- oceSetData(ctd, 'Chlorophyll (mg/m^3)', value=chlfluor)
ctd <- oceSetData(ctd, 'CTD Oxygen (µM)', value=ctdoxy)
ctd <- oceSetData(ctd, 'Beam Attenuation (1/m)', value=beamatt)
#transform bottle data into another CTD object so R-oce can understand how to plot it
salinity.bottle <- d_bottle[["CTDSAL"]]
temperature.bottle <- d_bottle[["CTDTMP..deg.C."]]
pressure.bottle <- d_bottle[["PRESSURE..dbar."]]
bottle.data <- as.ctd(salinity.bottle, temperature.bottle, pressure.bottle)
dissolvedNO3=d_bottle[["NITRATE_D_CONC_BOTTLE..umol.kg."]]
bottle.data <- oceSetData(bottle.data, 'Dissolved Nitrate (µm/kg)', value=dissolvedNO3)

#make plot
pdf(args[3], width=9,height=7)
#multiple columns
par(mfrow=c(1,5), mar=c(0,0,0,0))
#plot templerature profile
plotProfile(ctd, xtype="temperature", ylim=c(300, 0), xlim=c(0,25))
temperature <- ctd[["temperature"]]
pressure <- ctd[["pressure"]]
#define MLD with two different methods and plot as line
for (criterion in c(0.1, 0.5)) {
    inMLD <- abs(temperature[1]-temperature) < criterion
    MLDindex <- which.min(inMLD)
    MLDpressure <- pressure[MLDindex]
    abline(h=pressure[MLDindex], lwd=2, lty="dashed")
}
#plot other data sources
plotProfile(ctd, xtype="Chlorophyll (mg/m^3)", ylim=c(300, 0), col="darkgreen")
plotProfile(ctd, xtype="CTD Oxygen (µM)", ylim=c(300, 0), col="darkblue")
plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(300, 0), col="red")
plotProfile(bottle.data, xtype="Dissolved Nitrate (µm/kg)", ylim=c(300, 0), col="orange", type="b")
dev.off()
