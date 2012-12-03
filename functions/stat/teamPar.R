teamPar <- function(week)
  {
    load(paste("data/",nfl.par@year,"/fit",week,".RData",sep=""))
    n.t <- (length(fit$mu)-2)/2
    mean.y <- fit$mu["Intercept"]
    Off <- mean.y + fit$mu[2:(n.t+1)]
    Def <- mean.y + fit$mu[(n.t+2):(2*n.t+1)]
    Diff <- Off-Def
    X <- data.frame(Off=Off,Def=Def,Diff=Diff)
    rownames(X) <- matrix(unlist(strsplit(names(Off),".",fixed=T)),ncol=2,byrow=T)[,1]
    save(X,file=paste("data/",nfl.par@year,"/par",week,".RData",sep=""))
  }
