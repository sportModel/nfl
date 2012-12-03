predictGames <- function(week,schedule,N=10000,out=c("save","return"),neutral=FALSE)
  {
    load(paste("data/",nfl.par@year,"/fit",week,".RData",sep=""))
    X <- makeX(schedule)
    if (neutral) X[,"Home"] <- 0
    n.g <- nrow(X)/2
    ind <- match(colnames(X),names(fit$mu))

    ## Mean scores
    ms <- X%*%fit$mu[ind]
    home <- ms[2*(1:n.g)]
    away <- ms[2*(1:n.g)-1]
    ms <- cbind(away,home)

    ## Pr(Home win)
    p <- length(fit$mu)
    posterior <- rmvnorm(N,fit$mu,fit$sigma,method="svd")
    prH <- prHome(schedule,posterior)

    if (out=="save") save(prH,ms,file=paste("data/",nfl.par@year,"/pred",week,".RData",sep=""))
    if (out=="return") return(list(prH=prH,ms=ms))
  }
