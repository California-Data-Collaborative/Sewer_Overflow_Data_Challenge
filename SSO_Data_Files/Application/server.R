library(ggmap)
library(plotly)
library(leaflet)
library(shiny)
library(stringr)
library(reshape2)
#setwd("F:/Scrap/Waterchallenge/Sewer_Overflow_Data_Challenge/SSO_Data_Files")


#Reading and summarizing data
sso<-read.csv("No_spill.csv")
org_info<-read.csv("PRA.csv")
org_info<-org_info[,c("WDID","Status",
                      "Region","Agency","Collection.System",        
                      "County","LRO","Street","City","Zip")]


sso_req<-read.csv("SSO.csv")
sso_req<-sso_req[,c("WDID","STATUS","SPILL.TYPE","SPILL.VOL.REACH.LAND","SPILL.VOL",                    
                    "SPILL.VOL.RECOVER","SPILL.VOL.REACH.SURF", "SPILL.LOC.NAME",         
                    "LATTITUDE.DECIMAL.DEGREES","LONGITUDE.DECIMAL.DEGREES",    
                    "COUNTY","REGIONAL.BOARD","APPEAR.PT","SPILL.CAUSE","MATERIAL.SEWER_PIPE",
                    "AGE_SEWER_PIPE","FINAL.SPILL.DEST","SPILL.CREATED.DT")]

sso_req<-sso_req[(sso_req$STATUS=="Active"),]
sso<-sso[(sso$Status=="Active"),]
org_info<-org_info[(org_info$Status=='Active'),]

sso_req<-merge(sso_req,org_info[,c("WDID","Agency","Collection.System","City","County")],by.x="WDID",by.y="WDID")
sso_req$Collection.System<-factor(sso_req$Collection.System)
sso_req$LONGITUDE.DECIMAL.DEGREES<- -abs(sso_req$LONGITUDE.DECIMAL.DEGREES)


sso<-sso[,c(1:300)]
wdid<-data.frame(factor(sso[,c("WDID")]))
sso<-subset(sso,select=-c(X))
fi<-sso[ , grepl( "SSO." , colnames( sso ) ) ]
patterns <- unique(substr(colnames(fi), 8, 9))
new <- sapply(patterns, function(xx) rowSums(fi[,grep(str_c(xx,"$"), colnames(fi)), drop=FALSE]))
colnames(new) <-paste(c("2009","2010","2011","2012","2013","2014","2015","2016","2017"))
new<-cbind(setNames(data.frame(wdid),c("wdid")),new)
new$wdid<-as.character(new$wdid)

fir<-sso[ , grepl( "No.Spill." , names( sso ) ) ]
wdid1<-sso[,c('WDID')]
wdid1<-factor(wdid1)
#changing factor to numeric(no=1,yes=1)
sec<-data.frame(lapply(fir, function(x) abs(as.numeric(x)-2)))
#binding columns with respective WDID
sec<-cbind(wdid1,sec)
thir<-rowSums(sec[-1])
fou<-cbind(sec,thir)





shinyServer(function(input, output) {
  
  output$County <- renderUI({
    
    selectInput(inputId = "County",
                label = "Select County:",
                choices = unique(sso_req$County),
                selected = sample(sso_req$County,1))
    
  })
  
  output$CS <- renderUI({
    selectInput(inputId = "CS",
                label = "Select Collection System:",
                choices = unique(sso_req[(sso_req$County==input$County),]$Collection.System))
  })
  
  output$main_plot3 <- renderLeaflet({
    l=leaflet(data = sso_req) %>% addTiles( attribution = "California Data Collaborative")
    l %>%
      setView(lng = geocode("California")$lon, 
              lat = geocode("California")$lat,zoom=5) %>%
      addCircles(~LONGITUDE.DECIMAL.DEGREES, 
                 ~LATTITUDE.DECIMAL.DEGREES, 
                 radius=~SPILL.VOL*0.01,color="darkslateblue",
                 stroke=FALSE, fillOpacity=0.3, 
                 popup = ~as.character(str_c("Spill Volume=",SPILL.VOL)))
    
  })
  
  
 
  sso_req1<-reactive(sso_req[(sso_req$County==input$County),])
  
  output$main_plot <- renderLeaflet({
    sso_req1<-sso_req1()
    m=leaflet(data = sso_req1) %>% addTiles( attribution = "California Data Collaborative")
    m %>%
      setView(lng = geocode(str_c(input$County," California"))$lon, 
              lat = geocode(str_c(input$County," California"))$lat,zoom=9) %>%
      addCircles(~LONGITUDE.DECIMAL.DEGREES, 
                 ~LATTITUDE.DECIMAL.DEGREES, 
                 radius=~SPILL.VOL*0.01,color="darkslateblue",
                 stroke=FALSE, fillOpacity=0.3, 
                 popup = ~as.character(str_c("Spill Volume=",SPILL.VOL)),group="Spill Volume") %>%
      addCircles(~LONGITUDE.DECIMAL.DEGREES, 
                 ~LATTITUDE.DECIMAL.DEGREES, 
                 radius=~SPILL.VOL.REACH.SURF*0.01,color="brown",
                 stroke=FALSE, fillOpacity=0.3, 
                 popup = ~as.character(str_c("Spill Volume Reaching Surface Water=",
                                             SPILL.VOL.REACH.SURF)),
                 group="Volume Reach Surface Water")%>%
      addLayersControl(
        overlayGroups = c("Spill Volume","Volume Reach Surface Water"),
        options = layersControlOptions(collapsed = FALSE)
      )

   
  })
  
  
  output$main_plot1 <- renderLeaflet({
    sso_req1<-sso_req1()
    sso_req2<-sso_req1[(sso_req1$Collection.System==input$CS),]
    cit<-unique(sso_req2[sso_req2$Collection.System == input$CS,]$City)
    n=leaflet(data = sso_req2) %>% addTiles( attribution = "California Data Collaborative") %>%
      setView(lng = geocode(str_c(cit," California"))$lon, 
              lat = geocode(str_c(cit," California"))$lat,zoom=10) 
    n %>%
      addCircles(~LONGITUDE.DECIMAL.DEGREES, 
                 ~LATTITUDE.DECIMAL.DEGREES, 
                 radius=~SPILL.VOL*0.01,color="darkslateblue",
                 stroke=FALSE, fillOpacity=0.3, 
                 popup = ~as.character(str_c("Spill Volume=",SPILL.VOL)),group="Spill Volume") %>%
      addCircles(~LONGITUDE.DECIMAL.DEGREES, 
                 ~LATTITUDE.DECIMAL.DEGREES, 
                 radius=~SPILL.VOL.REACH.SURF*0.01,color="brown",
                 stroke=FALSE, fillOpacity=0.3, 
                 popup = ~as.character(str_c("Spill Volume Reaching surface water=",
                                             SPILL.VOL.REACH.SURF))
                 ,group="Volume Reach Surface Water") %>% 
      addMarkers(~LONGITUDE.DECIMAL.DEGREES, 
                      ~LATTITUDE.DECIMAL.DEGREES,
                     popup = ~SPILL.LOC.NAME,group="Location")%>%
    addLayersControl(
      overlayGroups = c("Location", "Spill Volume","Volume Reach Surface Water"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% hideGroup("Location")
    
    
    
})
  f <- list(
    family = "Times New Roman",
    size = 18,
    color = "#7f7f7f"
  )


  calplottest <- reactive({
    
    p <- plot_ly(as.data.frame(table(toupper(sso_req$SPILL.CAUSE))),labels =~Var1,values = ~Freq, type = 'pie',
                 showlegend=TRUE,visible = "TRUE", textfont=list(color = "white")) %>%
      layout(title = 'Spill Type Distribution',titlefont = f,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    ah=0
    for(i in 0:99){
      ah[i+1]=nrow(fou[fou$thir==i,])
    }
    
    kk<-plot_ly(x=c(0:99),y=ah,type="bar",
                marker=list(color="slateblue",opacity=0.5),
                name="Distribution Of WDID with respect to spill")%>%
      layout(title="Consistent Spills",titlefont=f,
             yaxis=list(title="Number Of WDID",titlefont =f),
             xaxis=list(title="Number Of Months with Spill",titlefont = f))
    
    req1<-as.data.frame(table(sso_req$County))
    kl<-plot_ly(x=req1$Var1,y=req1$Freq,type="bar",marker=list(color="maroon",opacity="0.7"))%>%
      layout(title="Spill Req. By County",titlefont=f,
             xaxis=list(title="county",titlefont=f),
             yaxis=list(title="No. Of Requests",titlefont = f))
    sso_reqq<-sso_req[,c("County","SPILL.VOL","SPILL.VOL.REACH.SURF",
                       "SPILL.VOL.RECOVER","SPILL.VOL.REACH.LAND")]
    
    totalB <- aggregate(.~County,sso_reqq,sum)
    kmp <- plot_ly(totalB,x = ~County)%>%
      add_trace( y = ~SPILL.VOL, 
                 name = 'Spill Volume', type = 'scatter',mode="markers",marker=list(color="magenta",opacity=0.5,size=10))%>%
      add_trace(y = ~SPILL.VOL.RECOVER, 
                name = 'Spill Recovered',type='scatter', mode = 'markers',marker=list(color="deepskyblue",size=8,opacity=0.5))%>%
      add_trace(y = ~SPILL.VOL.REACH.SURF, 
                name = 'Volume reaching surface water',type='scatter',mode='markers',marker=list(color="sienna",opacity=0.4))%>%
      add_trace(y = ~SPILL.VOL.REACH.LAND, 
                name = 'Volume reaching land',type='scatter',mode='markers',marker=list(color="darkorchid",opacity=0.6))%>%
      layout(title="Spill Vol. by county",titlefont=f,
             xaxis=list(categoryorder="trace",title="Volume",titlefont =f),
             yaxis=list(title="County",titlefont =f))
    
    if( "Distribution by Spill Cause" %in% input$select_graph1) return(p) 
    if( "Consistent Spills" %in% input$select_graph1) return(kk)
    if( "Spill requests by County" %in% input$select_graph1) return(kl)
    if( "Spill Volume by County" %in% input$select_graph1) return(kmp)
  })
  
  output$calplot <- renderPlotly({   
    dataplots = calplottest()
    print(dataplots)
  }) 
  
  countyplottest <- reactive({
    sso_req1<-sso_req1()
    p <- plot_ly(as.data.frame(table(toupper(sso_req1$SPILL.CAUSE))),labels =~Var1,values = ~Freq, type = 'pie',
                 showlegend=TRUE,visible = "TRUE", textfont=list(color = "white")) %>%
      layout(title = 'Spill Type Distribution',titlefont = f,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    req1<-as.data.frame(table(sso_req1$Collection.System))
    req1<-req1[order(-req1$Freq),]
    kl<-plot_ly(x=req1$Var1[1:15],y=req1$Freq[1:15],type="bar",
                marker=list(color="darkorchid",opacity="0.7"))%>%
    layout(title="Top 15 Collection System by spill requests",titlefont=f,
           xaxis=list(categoryorder="trace",title="Collection System",titlefont=f),
           yaxis=list(title="NO. of Spill requests",titlefont=f))
    
    sso_reqq<-sso_req1[,c("Collection.System","SPILL.VOL","SPILL.VOL.REACH.SURF",
                         "SPILL.VOL.RECOVER","SPILL.VOL.REACH.LAND")]
    
    totalB <- aggregate(.~Collection.System,sso_reqq,sum)
    totalB<-totalB[order(-totalB$SPILL.VOL),]
    kmp <- plot_ly(totalB,x = ~Collection.System[1:15])%>%
      add_trace( y = ~SPILL.VOL[1:15], 
                 name = 'Spill Volume', type = 'scatter',mode="markers",marker=list(color="yellow",opacity=0.7,size=10))%>%
      add_trace(y = ~SPILL.VOL.RECOVER[1:15], 
                name = 'Spill Recovered',type='scatter', mode = 'markers',marker=list(color="chartreuse",size=8,opacity=0.7))%>%
      add_trace(y = ~SPILL.VOL.REACH.SURF[1:15], 
                name = 'Volume reaching surface water',type='scatter',mode='markers',marker=list(color="violetred",opacity=0.7))%>%
      add_trace(y = ~SPILL.VOL.REACH.LAND[1:15], 
                name = 'Volume reaching land',type='scatter',mode='markers',marker=list(color="salmon",opacity=0.7))%>%
      layout(title="Top 15 Collection System by spill volume",titlefont=f,
             xaxis=list(categoryorder="trace",title="Collection System",titlefont=f),
             yaxis=list(title="Volume",titlefont=f))
    
    sso_req3<-sso_req1[,c("SPILL.CREATED.DT","SPILL.VOL")]
    sso_req3$SPILL.CREATED.DT<-as.character(sso_req3$SPILL.CREATED.DT)
    sso_req3$SPILL.CREATED.DT<-substr(sso_req3$SPILL.CREATED.DT,8,9)
    totalc <- aggregate(SPILL.VOL~SPILL.CREATED.DT,sso_req3,sum)
    
    ks<-plot_ly(x=totalc$SPILL.CREATED.DT,y=totalc$SPILL.VOL,type="scatter",mode="line+markers",
                marker=list(color="darkgreen",opacity="0.7"))%>%
    layout(title="Spill Volume by Year",titlefont=f,
           xaxis=list(title="Year",titlefont=f),
           yaxis=list(title="Spill Volume",titlefont=f))
    if( "Spill requests by CS" %in% input$select_graph2) return(kl)
    if( "Distribution by Spill Cause" %in% input$select_graph2) return(p)
    if( "Spill Volume by CS" %in% input$select_graph2) return(kmp)
    if( "Spill Volume by Year" %in% input$select_graph2) return(ks)
    
  })
  
  
  output$countyplot <- renderPlotly({   
    dataplots = countyplottest()
    print(dataplots)
  })  
 
  
   
  
 CSplottest <- reactive({
    sso_req1<-sso_req1()
    sso_re<-sso_req1[(sso_req1$Collection.System==input$CS),
                     c("WDID","SPILL.VOL","SPILL.VOL.REACH.SURF",
                       "SPILL.VOL.RECOVER","SPILL.CREATED.DT","SPILL.VOL.REACH.LAND")]
    sso_re1<-sso_req1[(sso_req1$Collection.System==input$CS),
                      c("WDID","SPILL.VOL","SPILL.VOL.REACH.SURF",
                        "SPILL.VOL.RECOVER","SPILL.VOL.REACH.LAND")]
    
    p <- plot_ly(sso_re,x = ~SPILL.CREATED.DT)%>%
      add_trace( y = ~SPILL.VOL, 
                 name = 'Spill Volume', type = 'scatter',mode="markers",marker=list(color="springgreen",opacity=0.5,size=10))%>%
      add_trace(y = ~SPILL.VOL.RECOVER, 
                name = 'Spill Recovered',type='scatter', mode = 'lines',line=list(color="goldenrod"))%>%
      add_trace(y = ~SPILL.VOL.REACH.SURF, 
                name = 'Volume reaching surface water',type='bar',marker=list(color="green",opacity=0.8))%>%
      add_trace(y = ~SPILL.VOL.REACH.LAND, 
                name = 'Volume reaching land',type='scatter',marker=list(color="tomato",opacity=0.6))%>%
      layout(title="Spills By Date",titlefont=f,
             xaxis=list(categoryorder="trace",title="Spills",titlefont=f),
             yaxis=list(title="Date",titlefont=f))
    
    ss<-sso_req1[(sso_req1$Collection.System==input$CS),]
    m <- plot_ly(as.data.frame(table(toupper(ss$SPILL.CAUSE))),labels =~Var1,values = ~Freq, type = 'pie',
                 showlegend=TRUE,visible = "TRUE", textfont=list(color = "white")) %>%
      layout(title = 'Spill Type Distribution',titlefont = f,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    wdid_sso<-unique(sso_req1[(sso_req1$Collection.System==input$CS),]$WDID)
    wdid_sso<-as.character(wdid_sso)
    f<-data.frame(t(new[(new$wdid== wdid_sso),(2:10)]))
    
    names <- rownames(f)
    rownames(f) <- NULL
    dat <- cbind(names,f)
    names(dat)[1:2] <- c("Year","Frequency")
    
    x<-plot_ly(dat,x=dat$Year,y=dat$Frequency,type="scatter",mode="lines+markers",
            marker=list(color="purple" , size=10 , opacity=0.5),line=list(color="plum"))%>%
      layout(title ="Frequency of Spills", titlefont = f,
             xaxis=list(title="Year",titlefont=f),
             yaxis=list(title="No. of requests",titlefont=f))
    
    df.m <- melt(sso_re1, id.vars  = "WDID",na.rm=TRUE)
    j<-plot_ly(y=df.m$value,x=df.m$variable,type="box",color=df.m$variable)%>%
      layout(title = "Analysis of spills",titlefont=f,
             xaxis=list(title="",titlefont=f),
             yaxis=list(title="Spill",titlefont=f))
    
    if ( "Change in number of spills over the years" %in% input$select_graph) return(x)
    if ( "Distribution By Spill Cause" %in% input$select_graph) return(m)
    if( "Spills By Date" %in% input$select_graph) return(p) 
    if( "Analysis of spills" %in% input$select_graph) return(j)
  })
  
  output$CSplot <- renderPlotly({   
    dataplots = CSplottest()
    print(dataplots)
  }) 

  
  output$table <- renderTable({
    sso_req1<-sso_req1()
    sso_req3<-sso_req1[(sso_req1$Collection.System==input$CS),
                       c("WDID","Agency","SPILL.CREATED.DT","SPILL.TYPE","SPILL.VOL","SPILL.VOL.REACH.LAND",                    
                         "SPILL.VOL.REACH.SURF","SPILL.VOL.RECOVER", "SPILL.LOC.NAME",
                                     "APPEAR.PT","SPILL.CAUSE","MATERIAL.SEWER_PIPE",
                                     "AGE_SEWER_PIPE","FINAL.SPILL.DEST"
                         )]
  

  })
  })

