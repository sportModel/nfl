makeTeamPar <- function(week) {
  load(paste("data/",nfl.par@year,"/par",week-1,".RData",sep=""))
  Xold <- X
  load(paste("data/",nfl.par@year,"/par",week,".RData",sep=""))
  ua <- floor(pmax(0,X[,3]-Xold[,3]))
  da <- floor(pmax(0,Xold[,3]-X[,3]))
  Trend <- character(nrow(X))
  Trend[ua==1] <- "&uarr;"
  Trend[ua==2] <- "&uarr;&uarr;"
  Trend[ua==3] <- "&uarr;&uarr;&uarr;"
  Trend[ua>=4] <- "&uarr;&uarr;&uarr;&uarr;"
  Trend[da==1] <- "&darr;"
  Trend[da==2] <- "&darr;&darr;"
  Trend[da==3] <- "&darr;&darr;&darr;"
  Trend[da>=4] <- "&darr;&darr;&darr;&darr;"
  X <- cbind(Trend,X)
  
  display.digits <- c(0,0,1,1,1)
  ind <- order(X[,"Diff"],decreasing=T)
  
  display <- xtable(X[ind,],digits=display.digits)
  align(display) <- rep("c",length(align(display)))
  align(display)[1] <- "l"
  
  filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_TeamPar.html",sep="")
  sink(filename)
  print(display,type="html",html.table.attributes="class=\"sortable ctable\"")
  sink()
  cleanTable(filename)
}
