#install.packages("maptools","gdata","RColorBrewer","classInt","maps","ggplot2","ggmap",lib="C:/R-3.6.1/library")
#devtools::install_github("dkahle/ggmap")
#install.packages("googleAuthR")
setwd("C:/Users/95889/gitPythonBase/Yelp_NLP/csv/word_count_label")
#a=read.csv("word_count_label.csv")
#colnames(a)
load(".Rdata")

a$categories<-as.character(a$categories)

library(googleAuthR)
library(mapproj)
library(maptools)
library(gdata)
library(RColorBrewer)
library(classInt)
library(maps)
library(ggplot2)
library(ggmap)
library(MASS)
library(sp)
library(viridis)
library(scales)
library(ggthemes)
require(reshape2)

# save api key
register_google(key = "AIzaSyCxtwY_KMPBdIULl3wtNKSTSPRLppa3J-E")

# check if key is saved
has_google_key()



pop=data.frame(LAT=rep(0,123397),LONG=rep(0,123397))
pop$LAT=a$latitude
pop$LONG=a$longitude

dens <- contourLines(
  kde2d(pop$LONG, pop$LAT, 
        lims=c(expand_range(range(pop$LONG), add=0.5),
               expand_range(range(pop$LAT), add=0.5))))

# this will be the color aesthetic mapping
pop$Density <- 0

# density levels go from lowest to highest, so iterate over the
# list of polygons (which are in level order), figure out which
# points are in that polygon and assign the level to them

for (i in 1:length(dens)) {
  tmp <- point.in.polygon(pop$LONG, pop$LAT, dens[[i]]$x, dens[[i]]$y)
  pop$Density[which(tmp==1)] <- dens[[i]]$level
}

Canada <- get_map(zoom=4, maptype="terrain")


gg <- ggmap(Canada, extent="normal")
gg <- gg + geom_point(data=pop, aes(x=LONG, y=LAT, color=Density))
gg <- gg + scale_color_viridis()
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")
gg

########test 
chisq.test(table(a$stars))
bar1=
ggplot(data=, aes(x=1,y=stars)) +
  geom_bar(stat="identity")

########

kmean1=kmeans(matrix(c(a$longitude,a$latitude),ncol=2,byrow = F),10)
pop$k1=kmean1$cluster
gg <- ggmap(Canada, extent="normal")
gg <- gg + geom_point(data=pop, aes(x=LONG, y=LAT, color=factor(kmean1$cluster)))
gg

########test according to the regions
(contingT=table(a$stars,kmean1$cluster))
chisq.test(contingT)

dfm <- melt(contingT[1:5,],id.vars = 1)

ggplot(dfm,aes(x = Input,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") + 
  scale_y_log10()

specie <- c(rep(1:9,each=5),rep(10,5))
condition <- as.character(rep(1:5,10))
value <- as.vector(contingT)
data <- data.frame(specie,condition,value)

# Grouped
ggplot(data, aes(fill=condition, y=value, x=as.character(specie))) + 
  geom_bar(position="dodge", stat="identity")

########regression
lm1=polr(as.factor(a$stars)~as.factor(kmean1$cluster))
summary(lm1)

lm2=lm(a$stars~as.numeric(a[,1:20]))
lm3=lm(a$stars~as.matrix(a[,1:500],)+factor(a$state))
anova(lm)


################### word counts
a111=data.frame(word=colnames(a)[1:500],number=colSums(a[,1:500]))
wc = wordcloud2(a111,size=0.5)
wc+WCtheme(2)
