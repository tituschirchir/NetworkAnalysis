#Set working directory to this file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
CompileCCode<-function()
{
  system("./CompileCCode.sh")
}
library(igraph) # Load the igraph package
loadAndPlot <- function(type, M, xlab=type, isLossPlot=T, p=0.2, gamma=0.05, theta=0.2, assets=1000, failFactor=0.75, N=25) {
  params <- paste("./GenerateData.sh", "Analysis", p, gamma, theta, assets, failFactor, N, type, M)
  system(params)
  example <- read.csv(paste0("mcfiles/mcSimulation",type,".csv"))
  x<-example$Value
  if(isLossPlot){
    y<- example$Loss
    ylab <- "Value Lost"
  } else{
    y<- example$Defaults
    ylab<-"No. of Defaults"
  }
  plot(
    x,
    y,
    col = 'blue',
    xlab = xlab,
    ylab = ylab,
    cex=0.3
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
dosimulate<-function(N=5, p=0.2)
{
  params <- paste("./GenerateData.sh", "Graph", p, 0.03, 0.3, 100000, 1, N)
  system(params)
  adjMat <- as.matrix(read.csv("csvfiles/adjMat.csv"))
  metadata <- as.matrix(read.csv("csvfiles/metaData.csv"))
  gg<-graph_from_adjacency_matrix(adjMat, mode="directed")
  for(i in 0:(as.numeric(metadata[1,"index"])-1)){
    pointsD <-  as.matrix(read.csv(paste0("csvfiles/bankData",i,".csv")))
    if(i==0)
      maxS = 10/max(as.numeric(pointsD[,"c"]))
    gg<-updateGraph(gg, pointsD, maxS)
    Sys.sleep(.7)
  }
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
#Compile C++ Code (in case of any changes) ----
CompileCCode()
#Test ----
dosimulate(N=40,p=.6)

#loadAndPlot(type = "P", M = 10000, isLossPlot = F)
loadAndPlot(type = "T", xlab=expression(theta),M = 100, isLossPlot = F)
loadAndPlot(type = "G", xlab= expression(gamma), M = 100, isLossPlot = F)
#loadAndPlot(type = "N", xlab = "No. of Banks", M = 1000, isLossPlot = F)
