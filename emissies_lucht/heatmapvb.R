library(gplots)
library(akima)
library(fields)
library(raster)


alle_emissies <- readRDS("/home/gehau/git/shiny-examples/emissies_lucht/data/emissies.rds")
alle_emissies$latitude <- alle_emissies$latitude[emissies$stof=="Arsenicum"]
alle_emissies$longitude <- alle_emissies$longitude[emissies$stof=="Arsenicum"]


x=alle_emissies$longitude[emissies$stof=="Arsenicum"]#rnorm(100)
y=alle_emissies$latitude[emissies$stof=="Arsenicum"]#rnorm(100)

z=alle_emissies$hoeveelheid[emissies$stof=="Arsenicum"]#x+y
i=interp(x,y,z,
         xo=seq(min(x),max(x),length=100),
         yo=seq(min(y),max(y),length=100))
image.plot(i$x,i$y,i$z,col=rich.colors(100))
contour(i,add=T)
points(x,y) 

for(i in sort(unique(emissies$jaar))){
  plot(emissies[,6:7],type="n",xaxt="n",yaxt="n",main=i)
  s.value(emissies[,6:7][(emissies$jaar==i) & (emissies$stof=="Arsenicum"),],
          scalewt(log(emissies[,4])+1)[(emissies$jaar==i) & (emissies$stof=="Arsenicum")],
          cleg=0,add.p=T)
}