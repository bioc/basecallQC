processDemultiplex <- function(demuxStatsXML){

  if(file.exists(demuxStatsXML)){

  demuxStatsXMLparse <- xmlTreeParse(demuxStatsXML)
  demuxStatsXML_root <- xmlRoot(demuxStatsXMLparse)
  Projects <- demuxStatsXML_root[[1]]
  flowcellID <- xmlAttrs(Projects)
  Projects_Info <- list()
  for(p in seq_along(Projects)){
    Project <- Projects[[p]]
    Project_Name <- xmlAttrs(Project)
    Project_Sample_Info <- list()
    for(s in seq_along(Project)){
      Sample <- Project[[s]]
      Sample_Name <- xmlAttrs(Sample)
      Sample_BarcodeExpected <- Sample[[1]]
      Sample_BarcodeExpected_Name <- xmlAttrs(Sample[[1]])
      Project_Sample_BarcodeExpected_Lane_Info <- list()
      for(b in seq_along(Sample_BarcodeExpected)){
        Lane <- Sample_BarcodeExpected[[b]]
        Lane_Name <- xmlAttrs(Lane)
        Lane_BarcodeCount <- as.integer(xmlValue(Lane[["BarcodeCount"]]))
        Lane_PerfectBarcodeCount <- as.integer(xmlValue(Lane[["PerfectBarcodeCount"]]))
        Project_Sample_BarcodeExpected_Lane_Info[[b]] <- data.frame(BarcodeCount = Lane_BarcodeCount,
                                                                    PerfectBarcodeCount = Lane_PerfectBarcodeCount)
        names(Project_Sample_BarcodeExpected_Lane_Info)[b] <- paste0("Lane",xmlAttrs(Lane))

      }
      psbeliMat <- sapply(Project_Sample_BarcodeExpected_Lane_Info,function(x)x)
      psbeliMatDF <- data.frame(BarcodeStat=rownames(psbeliMat),psbeliMat)
      psbeliMatDF <- tidyr::gather(psbeliMatDF,Lane,Count,-BarcodeStat)

      Project_Sample_Info[[s]] <- data.frame(Barcode = rep(Sample_BarcodeExpected_Name,nrow(psbeliMatDF)),
                                             psbeliMatDF)
      names(Project_Sample_Info)[s] <- Sample_Name

    }
    psiMat <- do.call(rbind,Project_Sample_Info)
    psiMatDF <- data.frame(Sample=gsub("\\..*","",rownames(psiMat)),psiMat)
    Projects_Info[[p]] <- data.frame(Project = rep(Project_Name,nrow(psiMat)),
                                     psiMatDF)
    names(Projects_Info)[p] <- Project_Name

  }
  Projects_DF2 <- do.call(rbind,Projects_Info)
  rownames(Projects_DF2) <- NULL
  return(Projects_DF2)
  }
  return(NULL)
}



processConvStats <- function(ConvStatsXML){

  if(file.exists(ConvStatsXML)){
  convStatsXMLparse <- xmlTreeParse(ConvStatsXML)
  convStatsXML_root <- xmlRoot(convStatsXMLparse)
  Projects <- convStatsXML_root[[1]]
  flowcellID <- xmlAttrs(Projects)

  Projects <- Projects[names(Projects) == "Project"]
  Projects_Info <- list()
  for(p in seq_along(Projects)){
    Project <- Projects[[p]]
    Project_Name <- xmlAttrs(Project)
    Project_Sample_Info <- list()
    for(s in seq_along(Project)){
      Sample <- Project[[s]]
      Sample_Name <- xmlAttrs(Sample)
      Sample_BarcodeExpected <- Sample[[1]]
      Sample_BarcodeExpected_Name <- xmlAttrs(Sample[[1]])
      Project_Sample_BarcodeExpected_Lane_Info <- list()
      Lane_Info <- list()
      for(b in seq_along(Sample_BarcodeExpected)){
        Lane <- Sample_BarcodeExpected[[b]]
        Lane_Name <- xmlAttrs(Lane)
        Tile_Info <- list()
        for(t in seq_along(Lane)){
          Tile <- Lane[[t]]
          Tile_Name <- xmlAttrs(Tile)
          FilterState_Info <- list()
          for(f in seq_along(Tile)){
            FilterState <- Tile[[f]]
            FilterState_Name <- xmlName(FilterState)
            FilterState_ClusterCount <- as.integer(xmlValue(FilterState[["ClusterCount"]]))
            ReadNumber_Info <- list()
            for(r in seq_along(FilterState)[-1]){

              Read <-  FilterState[[r]]
              ReadNumber <-  xmlAttrs(Read)
              ReadNumber_Yield <- as.integer(xmlValue(Read[["Yield"]]))
              ReadNumber_YieldQ30 <- as.integer(xmlValue(Read[["YieldQ30"]]))
              ReadNumber_QualityScoreSum <- as.numeric(xmlValue(Read[["QualityScoreSum"]]))
              ReadNumber_Info[[r-1]] <- data.frame(Yield = ReadNumber_Yield,
                                                   Yield30 = ReadNumber_YieldQ30,
                                                   QualityScoreSum = ReadNumber_QualityScoreSum,
                                                   ClusterCount = FilterState_ClusterCount
                                                   
              )

              names(ReadNumber_Info)[r-1] <- paste0("Read_",ReadNumber)

            }
            rniMat <- do.call(rbind,ReadNumber_Info)
            rniMatDF <- data.frame(ReadNumber=rownames(rniMat),rniMat)
            FilterState_Info[[f]] <- data.frame(Filter = rep(FilterState_Name,nrow(rniMatDF)),
                                                rniMatDF)
            names(FilterState_Info)[f] <- FilterState_Name

          }
          fsiMat <- do.call(rbind,FilterState_Info)
          fsiMatDF <- data.frame(fsiMat)
          Tile_Info[[t]] <- data.frame(Tile = rep(Tile_Name,nrow(fsiMatDF)),
                                       fsiMatDF)
          names(Tile_Info)[t] <- paste0("Tile_",Tile_Name)

        }
        tiMat <- do.call(rbind,Tile_Info)
        tiMatDF <- data.frame(tiMat)
        Lane_Info[[b]] <- data.frame(Lane = rep(Lane_Name,nrow(tiMatDF)),
                                     tiMatDF)
        names(Lane_Info)[b] <- paste0("Lane_",Lane_Name)
      }
      liMat <- do.call(rbind,Lane_Info)
      liMatDF <- data.frame(liMat)
      Project_Sample_Info[[s]] <- data.frame(Sample = rep(Sample_Name,nrow(liMatDF)),
                                             liMatDF)
      names(Project_Sample_Info)[s] <- paste0(Sample_Name)

    }
    psi2Mat <- do.call(rbind,Project_Sample_Info)
    psi2MatDF <- data.frame(psi2Mat)
    Projects_Info[[p]] <- data.frame(Project = rep(Project_Name,nrow(psi2MatDF)),
                                     psi2MatDF)
    names(Projects_Info)[p] <- paste0(Project_Name)

  }
  Projects_DF <- do.call(rbind,Projects_Info)
  rownames(Projects_DF) <- NULL
  return(Projects_DF)
  }
  return(NULL)
}

summariseDemuxStats <- function(demuxProcessed){
  #Lane_Stats4 <- Test %>% filter(Sample != "all" & BarcodeStat == "BarcodeCount") %>% group_by(Project,Sample) %>% summarise(Count=sum(as.numeric(Count)))
  #Lane_Stats <- Projects_DF %>% filter(Sample == "all") %>% group_by(Lane,Filter) %>% summarise(sum(Yield))

  if(!is.null(demuxProcessed)){
  temp <- demuxProcessed %>% tbl_df %>% mutate(Count = as.numeric(Count)) %>%
            filter(Sample != "all" & BarcodeStat == "BarcodeCount") %>%
            filter(Project != "default") # Computing percent label text and position for pie chart
  # temp <- temp %>% group_by(Lane) %>% mutate(labelperc=round(Count/sum(Count),2)*100) %>% group_by(Lane) %>% mutate(pos = cumsum(labelperc)- labelperc/2)
  # p1 <- temp %>% filter(Project != "default") %>% ggplot(aes(x=Project,y=Count,fill=Project))+geom_violin(alpha=0.3,scale="width")+geom_jitter(alpha=0.6)+theme(legend.position="bottom")
  # p2 <- ggplot(temp,aes(x=Lane,y=Count,fill=Sample))+geom_bar(stat = "identity")+theme_bw()+theme(legend.position="bottom")
  # p3 <- ggplot(temp,aes(x=Sample,y=Count,fill=Lane))+geom_bar(stat = "identity")+theme_bw()+coord_flip()+theme(legend.position="bottom")
  # if(plot){
  #   print(p1)
  #   print(p2)
  #   print(p3)
  # }
  #return(list(Summary=temp,Boxplot=p1,StackedBar=p2,Bar=p3))
  # Lane_perTileStats <- demuxProcessed %>% group_by(Lane,Tile,Filter) %>% filter(Sample != "all") %>% summarise(Yield=sum(as.numeric(Yield)))
  # LaneSample_perTileStats <- demuxProcessed %>% group_by(Lane,Sample,Tile,Filter) %>% filter(Sample != "all") %>% summarise(Yield=sum(as.numeric(Yield)))
  #Sample_Stats <- demuxProcessed %>% filter(Sample != "all") %>% group_by(Sample) %>% summarise(Yield=sum(as.numeric(Yield)))
  #Lane_Stats <- demuxProcessed %>% filter(Sample != "all") %>% group_by(Lane) %>% summarise(Yield=sum(as.numeric(Yield)))

  return(list(Summary=temp))
  }
  return(NULL)
}

summariseConvStats <- function(convStatsProcessed){
  #Lane_Stats4 <- Test %>% filter(Sample != "all" & BarcodeStat == "BarcodeCount") %>% group_by(Project,Sample) %>% summarise(Count=sum(as.numeric(Count)))
  #Lane_Stats <- Projects_DF %>% filter(Sample == "all") %>% group_by(Lane,Filter) %>% summarise(sum(Yield))
  if(!is.null(convStatsProcessed)){
  Lane_perTileStats <- convStatsProcessed %>% group_by(Lane,Tile,Filter) %>% filter(Sample != "all") %>% summarise(Yield=sum(as.numeric(Yield)))
  LaneSample_perTileStats <- convStatsProcessed %>% group_by(Lane,Sample,Tile,Filter) %>% filter(Sample != "all") %>% summarise(Yield=sum(as.numeric(Yield)))
  Sample_Stats <- convStatsProcessed %>% filter(Sample != "all") %>% group_by(Sample,Filter) %>% summarise(Yield=sum(as.numeric(Yield)))
  Lane_Stats <- convStatsProcessed %>% filter(Sample != "all") %>% group_by(Lane,Filter) %>% summarise(Yield=sum(as.numeric(Yield)))
  #Lane_Stats <- Projects_DF %>% filter(Sample == "all") %>% group_by(Lane,Filter) %>% summarise(sum(Yield))
  #p3 <- ggplot(data=Lane_perTileStats,aes(x=Lane,y=Yield))+geom_violin()
  #ggplot(data=Sample_Stats,aes(x=Sample,y=Yield,fill=Filter))+geom_boxplot()
  # if(plot){
  #   print(p3)
  # }
  return(list(Lane_perTileStats=Lane_perTileStats,
              LaneSample_perTileStats=LaneSample_perTileStats,
              Sample_Stats=Sample_Stats,
              Lane_Stats=Lane_Stats))
  }
  return(NULL)
}


runParameters <- function(runParameters = NULL){

  xmlFromRunParameters <- xmlParse(runParameters)
  currentRunParameters <- xmlToDataFrame(xmlFromRunParameters)
  currentRunParameters <- currentRunParameters[!is.na(currentRunParameters$ExperimentName),,drop=FALSE]
  currentRunParameters %>% tbl_df
}


