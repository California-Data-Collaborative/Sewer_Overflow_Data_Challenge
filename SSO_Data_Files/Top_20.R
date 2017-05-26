library(plyr)
library(reshape2)
library(plotly)
setwd("F:/Scrap/Waterchallenge/Sewer_Overflow_Data_Challenge/SSO_Data_Files")
org_info<-read.csv("PRA.csv")
org_info<-org_info[,c("WDID","Status",
                      "Region","Agency","Collection.System",        
                      "County","LRO","Street","City","Zip")]
org_info<-org_info[(org_info$Status=="Active"),]

sso_req<-read.csv("SSO.csv")
sso_req<-sso_req[(sso_req$STATUS=="Active"),]
sso_req1<-merge(sso_req,org_info,by.x="WDID",by.y="WDID")
sso_req1<-subset(sso_req1,select=-c(Unnamed..64))


max_spill<-ddply(sso_req,.(WDID),summarise,spill_volume=sum(SPILL.VOL))
max_spill<-merge(max_spill,org_info,by.x="WDID",by.y="WDID")
max_spill<-max_spill[order(-max_spill$spill),]
max_spill$ID <- seq.int(nrow(max_spill))

write.csv(head(max_spill,20),file="Top_20_CS_by_spill_volume.csv")
j<-plot_ly(head(max_spill,20),x=~Collection.System,y=~spill_volume,
           type="scatter",mode="markers+text",text=~ID,marker=list(color="red"),
           textposition = 'top')%>%
  layout(xaxis=list(categoryorder="trace"))

export(j, file = "Top_20_CS_by_spill_volume.csv.png")


max_surf<-ddply(sso_req,.(WDID),summarise,spill_Surf_volume=sum(SPILL.VOL.REACH.SURF))
max_surf<-merge(max_surf,org_info,by.x="WDID",by.y="WDID")
max_surf<-max_surf[order(-max_surf$spill),]
max_surf$ID <- seq.int(nrow(max_surf))
write.csv(head(max_surf,20),file="Top_20_CS_by_spill_volume_reaching_Surf.csv")
j<-plot_ly(head(max_surf,20),x=~Collection.System,y=~spill_Surf_volume,
           type="scatter",mode="markers+text",text=~ID,
           textposition = 'top')%>%
          layout(xaxis=list(categoryorder="trace"))
export(j, file = "Top_20_CS_by_spill_volume_reaching_Surf.png")

max_land<-ddply(sso_req,.(WDID),summarise,spill_land_volume=sum(SPILL.VOL.REACH.LAND))
max_land<-merge(max_land,org_info,by.x="WDID",by.y="WDID")
max_land<-max_land[order(-max_land$spill),]
max_land$ID <- seq.int(nrow(max_land))

write.csv(head(max_land,20),file="Top_20_CS_by_spill_volume_reaching_land.csv")
j<-plot_ly(head(max_land,20),x=~Collection.System,y=~spill_land_volume,
           type="scatter",mode="markers+text",text=~ID,marker=list(color="green"),
           textposition = 'top')%>%
  layout(xaxis=list(categoryorder="trace"))
export(j, file = "Top_20_CS_by_spill_volume_reaching_land.png")




max_imp<-ddply(sso_req,.(WDID),summarise,spill_impact=sum(SPILL.VOL-SPILL.VOL.RECOVER))
max_imp<-merge(max_imp,org_info,by.x="WDID",by.y="WDID")
max_imp<-max_imp[order(-max_imp$spill),]
max_imp$ID <- seq.int(nrow(max_imp))

write.csv(head(max_imp,20),file="Top_20_CS_by_Maximum_Impact.csv")
j<-plot_ly(head(max_imp,20),x=~Collection.System,y=~spill_impact,
           type="scatter",mode="markers+text",text=~ID,marker=list(color="brown"),
           textposition = 'top')%>%
  layout(xaxis=list(categoryorder="trace"))
export(j, file = "Top_20_CS_by_Maximum_Impact.png")

