
#code at***https://www.kaggle.com/lefeulien/notebook0f66b16139

library(tidyverse) # metapackage of all tidyverse packages
list.files(path = "../input")
library(caret)
install.packages("geojsonio")

library("geojsonio")
require("dplyr")
require("stringr")
require("data.table")
require("ggplot2")
require("maptools")
require("knitr")
require("kableExtra")
require("mapproj")
require("sf")
require("RColorBrewer")

path = "../input/data-deng-bi/plotTW.csv"
df <- read.csv(path, h=T)
df <-data.frame(df)
distill_data <- df
kable(distill_data)
summary(distill_data)

taiwan.map <- st_read("../input/tw-map-shp/gadm36_TWN_2.shp")
print(taiwan.map, n = 22)

plot(taiwan.map[1])
#plot(taiwan.map[2:13], max.plot = 12)
plot(st_geometry(taiwan.map))
#plot(taiwan.map["NAME_2"], axes = TRUE)
st_geometry(taiwan.map)

ggplot(data = taiwan.map) +
  geom_sf(aes(fill = NAME_2)) +
  scale_fill_manual(name = "?????????",
                    values = colorRampPalette(brewer.pal(8, "Accent"))(22)) +
  labs(title = "Taiwan map") 

print(distill_data$ID)

distill_data$ID <- as.character(distill_data$ID)
head(distill_data)

tmp <- (min(distill_data$Dengue) - max(distill_data$Dengue))
tmp

distill_data$Dengue_Nornalize <- (distill_data$Dengue - min(distill_data$Dengue)) / (max(distill_data$Dengue) - min(distill_data$Dengue))

distill_data

my.taiwan.map <- taiwan.map[c("NAME_2", "geometry")]
my.taiwan.map$NAME_2 <- as.character(my.taiwan.map$NAME_2)
head(my.taiwan.map)

my.taiwan.map.data <- left_join(my.taiwan.map, distill_data,
                                c("NAME_2" = "ID"))

dim(my.taiwan.map.data)



ggplot(data = my.taiwan.map.data) +
  geom_sf(aes(fill = Dengue_Nornalize)) +
  # scale_fill_distiller(name="Count", palette = "RdYlGn")
  scale_fill_distiller(palette = "Spectral", name = "Dengue Cases")

my.taiwan.map.data$Dengue3 <- cut(my.taiwan.map.data$Dengue,breaks = c(-Inf, 61, 501, 1001, Inf),right = FALSE)# divide into 4 section for clearly revealization

ggplot(data = my.taiwan.map.data) +
  geom_sf(aes(fill = Dengue3)) +
  #scale_fill_distiller(name="Count", palette = "RdYlGn")
  #scale_fill_distiller(palette = "Spectral", name = "????????????Denguge Cases") +
  
  scale_fill_manual(breaks=c("[-Inf,61)", "[61,501)", "[501,1e+03)","[1e+03, Inf)"),
                    name = "Dengue Cases",
                    values = c("lightyellow", "yellow","orange", "red"),
                    labels = c("0-60","61-500","501-1000",">1001"))

my.taiwan.map.data$BI3 <- cut(my.taiwan.map.data$BI,breaks = c(-Inf, 1, 2, 3, Inf),right = FALSE)# divide into 4 section for clearly revealization

#BI is Mosquito larva density parameter
ggplot(data = my.taiwan.map.data) +
  geom_sf(aes(fill = BI)) +
  # scale_fill_distiller(name="Count", palette = "RdYlGn")
  scale_fill_distiller(palette = "Spectral", name = "Mosquito larva density distribution")


ggplot(data = my.taiwan.map.data) +
  geom_sf(aes(fill = BI3)) +
  scale_fill_manual(breaks=c("[-Inf,1)", "[1,2)", "[2,3)","[3, Inf)"),
                    name = "Mosquito larva density distribution",
                    values = c("lightyellow", "yellow","orange", "red"),
                    labels = c("0-1","1-2","2-3","3-4"))
