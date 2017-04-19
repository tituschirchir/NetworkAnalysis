#Set working directory to this file location
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
CompileCCode<-function()
{
  #system("chmod +x * -R")
  system("chmod +x GenerateData.sh")
  system("./CompileCCode.sh")
}
library(igraph) # Load the igraph package
LoadData <- function(type,
           M = 100,
           xlab = type,
           p = 0.2,
           gamma = 0.05,
           theta = 0.2,
           assets = 1000,
           failFactor = 0.75,
           N = 25) {
    cat("Prob=",p)
  params <- paste("./GenerateData.sh", "Analysis", p, gamma, theta, assets, failFactor, N, type, M)
  system(params)
}
PlotMC <- function(type, xlab=type, isLossPlot=F) {
  example <- read.csv(paste0("mcfiles/mcSimulation",type,".csv"))
  x<-example$Value
  xlabels<-c("G"=expression(gamma), "T"=expression(theta), "P"="Interconnectedness", "N"="No. Of Banks" )
  if(isLossPlot){
    y<- example$Loss
    ylab <- "Value Lost"
  } else{
    y<- example$Defaults
    ylab<-"No. of Defaults"
  }
  xlab <- xlabels[type]
  titles<-paste("Impact of",xlab, "on",ylab)
  plot(
    x,
    y,
    col = 'blue',
    xlab = xlab,
    ylab = ylab,
    cex=0.3,
    main = titles
  )
  lines(smooth.spline(x, y), col='red')
}
PlotSpecific <- function(type, xlab) {
  #old.par <- par(mfrow = c(1, 2))
  loadAndPlot(
    type = type,
    xlab = xlab,
    M = 1000,
    isLossPlot = F
  )
  loadAndPlot(
    type = type,
    xlab = xlab,
    M = 1000,
    isLossPlot = T)
}

#Graph Simulation -----

GenerateSimulationData<-function(N=5, p=0.2, theta=0.3, gamma=0.03, assets=10000)
{
  params <- paste("./GenerateData.sh", "Graph", p, gamma, theta, assets, 1, N)
  system(params)
}
dosimulate<-function()
{
  adjMat <- as.matrix(read.csv("csvfiles/adjMat.csv"))
  metadata <- as.matrix(read.csv("csvfiles/metaData.csv"))
  gg<-graph_from_adjacency_matrix(adjMat, mode="directed")
  for(i in 0:GetIterations()){
    pointsD <-  as.matrix(read.csv(paste0("csvfiles/bankData",i,".csv")))
    if(i==0)
      maxS = 10/max(as.numeric(pointsD[,"c"]))
    gg<-updateGraph(gg, pointsD, maxS)
    Sys.sleep(0)
  }
}
GetIterations<-function()
{
  metadata<-as.matrix(read.csv("csvfiles/metaData.csv"))
  as.numeric(metadata[1,"index"])-1
}

simulateforbanki <- function(i) {
  adjMat <- as.matrix(read.csv("csvfiles/adjMat.csv"))
  metadata <- as.matrix(read.csv("csvfiles/metaData.csv"))
  gg<-graph_from_adjacency_matrix(adjMat, mode="directed")
  pointsD <- as.matrix(read.csv(paste0("csvfiles/bankData", i, ".csv")))
  maxS = 10 / max(as.numeric(pointsD[, "c"]))
  updateGraph(gg, pointsD, maxS)
  gg
}
updateGraph <- function(bankNetwork, pointsD, maxS) {
  V(bankNetwork)$e <- as.numeric(pointsD[,"e"])
  V(bankNetwork)$c <- as.numeric(pointsD[,"c"])
  V(bankNetwork)$d <- as.numeric(pointsD[,"d"])
  V(bankNetwork)$b <- as.numeric(pointsD[,"b"])
  V(bankNetwork)$i <- as.numeric(pointsD[,"i"])
  V(bankNetwork)$L <- as.numeric(pointsD[,"liabilities"])
  V(bankNetwork)$A <- as.numeric(pointsD[,"assets"])
  V(bankNetwork)$affected <- pointsD[,"affected"]
  V(bankNetwork)$color='green'
  V(bankNetwork)[affected=='Y']$color='orange'
  V(bankNetwork)[c==0]$color='red'
  nn <-
    paste0(
      V(bankNetwork)$name,
      "(Cap/I-B Lty: ",
      round(V(bankNetwork)$c,2),"/",round(V(bankNetwork)$b,2),
      ")\n",
      "Asset/Liab: ",
      round(V(bankNetwork)$A, 2),"/",round(V(bankNetwork)$L, 2)
    )

  scale <- maxS
  l <- layout.kamada.kawai(bankNetwork)
  plot(bankNetwork, layout=l,
       edge.arrow.size = 0.5,
       vertex.size = ifelse(V(bankNetwork)$c==0,8/scale,V(bankNetwork)$c)*scale,
       vertex.label=nn,
       vertex.frame.color = "gray",
       vertex.label.color = "blue",
       vertex.label.cex = 0.8,
       vertex.label.dist = 0.4,
       edge.curved = 0.2
       )
  bankNetwork
}

CompileCCode()
