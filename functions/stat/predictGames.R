predictGames <- function(week, X, N=10000, out=c("save", "return")) {
  out <- match.arg(out)
  load(paste("data/",nfl.par@year,"/fit",week,".RData",sep=""))
  n.g <- nrow(X)/2
  ind <- match(colnames(X), names(fit$mu))
  a <- apply(X[2*(1:n.g)-1,,drop=FALSE], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  h <- apply(X[2*(1:n.g),,drop=FALSE], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  Game <- gsub(".Off", "", paste(a, h, sep=" @ "), fixed=TRUE)
  
  ## Mean scores
  ms <- X%*%fit$mu[ind]
  home <- ms[2*(1:n.g)]
  away <- ms[2*(1:n.g)-1]
  ms <- cbind(away,home)
  rownames(ms) <- Game
  
  ## Pr(Home win)
  posterior <- rmvnorm(N, fit$mu, fit$sigma, method="svd")
  prH <- prHome(X, posterior)
  names(prH) <- Game
  
  if (out=="save") save(prH,ms,file=paste("data/",nfl.par@year,"/pred",week,".RData",sep=""))
  if (out=="return") return(list(prH=prH,ms=ms))
}
