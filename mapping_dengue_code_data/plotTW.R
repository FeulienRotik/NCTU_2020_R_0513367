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
path = "/home/ndk/Downloads/beo/plotTW.csv"
df <- fread(path, h=T)
df <-data.frame(df)
distill_data <- df
kable(distill_data)
summary(distill_data)

######################
taiwan.map <- st_read("/home/ndk/Downloads/beo/gadm36_TWN_shp/gadm36_TWN_2.shp")
head(taiwan.map)
print(taiwan.map, n = 22)
plot(taiwan.map[1])
plot(taiwan.map[2:13], max.plot = 12)
plot(st_geometry(taiwan.map))
plot(taiwan.map["NL_NAME_2"], axes = TRUE)
st_geometry(taiwan.map)

ggplot(data = taiwan.map) +
  geom_sf(aes(fill = NL_NAME_2)) +
  scale_fill_manual(name = "縣市區",
                    values = colorRampPalette(brewer.pal(8, "Accent"))(22)) +
  labs(title = "台灣地圖") 

print(taiwan.map$NAME_2)
print(distill_data$ID)
distill_data$ID <- as.character(distill_data$ID)
print(distill_data$ID)
my.taiwan.map <- taiwan.map[c("NAME_2", "geometry")]
my.taiwan.map$NAME_2 <- as.character(my.taiwan.map$NAME_2)
print(my.taiwan.map$NAME_2)
head(my.taiwan.map)
my.taiwan.map.data <- left_join(my.taiwan.map, distill_data,
                                c("NAME_2" = "ID"))

head(my.taiwan.map.data)
dim(my.taiwan.map.data)

my.taiwan.map.data$Dengue2 <- cut(my.taiwan.map.data$Dengue,breaks = c(-Inf, 61, 501, 1001, Inf),right = FALSE)

ggplot(data = my.taiwan.map.data) +
  geom_sf(aes(fill = Dengue2)) +
  #scale_fill_distiller(name="Count", palette = "RdYlGn")
  #scale_fill_distiller(palette = "Spectral", name = "Dengue Cases") +
  
  scale_fill_manual(breaks=c("[-Inf,61)", "[61, 501)", "[501,1001)", 
                             "[1001,Inf)"),
                    name = "Dengue Cases",
                    values = c("lightyellow", "yellow","orange", "red"),
  #p + scale_fill_manual(values=c("0-60" = "lightyellow", "61-500" = "yellow", "501-1000" = "orange", ">1001" = "red"))
                    labels = c("0-60","61-500","501-1000",">1001"))

  #scale_color_manual(name = "Dengue Cases",
  #                   values = c("(-Inf,5]" = "yellow",
   #                             "(6,60]" = "yellow",
   #                             "(61,1000]" = "orange",
    #                            "(1001, Inf]" = "red"))      scale_fill_manual(breaks=c("\[-Inf,-3)", "\[-3,-2)", "\[-2,-1)", 
#"\[-1,0)", "\[0,1)", "\[1,2)", 
#"\[2,3)", "\[3, Inf)"),
#values = c("white", "darkblue", "blue",
#           "lightblue", "lightgreen", "green",
#           "darkgreen", "white"))
                     #labels = c("0 - 5", "6 - 50", "51 - 500", "> 501"))
  
  #scale_fill_gradientn(colours = brewer.pal(1,"Reds"), name = "Dengue Cases")
  #scale_color_gradient(low = "green", high = "red", name = "Dengue Cases")
  #scale_fill_gradientn(colours = tim.colors(22), name = "Dengue Cases") 


