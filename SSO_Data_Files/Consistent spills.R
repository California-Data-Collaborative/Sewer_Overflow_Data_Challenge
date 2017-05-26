library(plotly)
library(ggplot2)
library(reshape2)
library(plyr)
setwd("F:/Scrap/Waterchallenge/Sewer_Overflow_Data_Challenge/SSO_Data_Files")

sso<-read.csv("No_spill.csv")
sso<-sso[(sso$Status=="Active"),]
sso<-sso[,1:300]
sso<-subset(sso,select=-c(X))
org_info<-read.csv("PRA.csv")
org_info<-org_info[,c("WDID","Status",
                      "Region","Agency","Collection.System",        
                      "County","LRO","Street","City","Zip")]
org_info<-org_info[(org_info$Status=="Active"),]

#Segragating the No.Spill Column
fi<-sso[ , grepl( "No.Spill." , names( sso ) ) ]
fir<-sso[,grepl("SSO.",names(sso))]

wdid<-sso[,c('WDID')]
wdid<-factor(wdid)

#changing factor to numeric(no=1,yes=1)
sec<-data.frame(lapply(fi, function(x) abs(as.numeric(x)-2)))
#summary(wdid)
#summary(sec$No.Spill.01.09)

#binding columns with respective WDID
sec<-cbind(wdid,sec)
seco<-cbind(wdid,fir)
#write.csv(sec,file='ab.csv')
Num_Req_months<-rowSums(sec[-1])
No_Of_Req<-rowSums(seco[-1])
#colnames(sec)
fou<-cbind(sec,Num_Req_months)
four<-cbind(seco,No_Of_Req)
ah=0
#am=0

for(i in 0:99){
ah[i+1]=nrow(fou[fou$Num_Req_months==i,])
#am[i+1]<-fou[fou$Num_Req_months==i,]
}

p<-plot_ly(x=c(0:99),y=ah,type="bar",marker=list(color="#5E88FC"),
           name="Distribution Of WDID with respect to spill")%>%
  layout(yaxis=list(title="Number Of WDID"),
         xaxis=list(title="Number Of Months with NoSpill"))

fou1<-fou[(fou$Num_Req_months==99),]
fou1<-fou1[,c("wdid","Num_Req_months")]
fou1<-merge(fou1,org_info,by.x="wdid",by.y="WDID")
write.csv(fou1,file="Top_consistently_Spilling_CS.csv")


four<-four[,c("wdid","No_Of_Req")]
four<-merge(four,org_info,by.x="wdid",by.y="WDID")
four<- four[order(-four$No_Of_Req),] 


l<-plot_ly(x=four[(1:20),c("wdid")],y=four[(1:20),c("No_Of_Req")],type="scatter",mode="markers+text",
           marker=list(color="#5E88FC"),text=four[(1:20),c("No_Of_Req")],textposition="top",
           name="Distribution Of WDID with respect to no spill")%>%
  layout(yaxis=list(title="Number Of WDID"),
         xaxis=list(title="Number Of request",categoryorder="trace"))
l
write.csv(head(four,20),file="Top_20_CS_By_No._Of_Requests.csv")
export(l,file="Top_20_CS_By_No._Of_Requests.png")


































