## Setup
nfl.par <- setDefaultPar(2016)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

week <- as.numeric(nfl$schedule$Week[length(nfl$y)/2])
for (i in 0:week) {
  ## Fitting
  if (i==0) {
    output <- gibbs(nfl$X[NULL,], NULL, prior=prior, N=10000)
  } else {
    ind <- 1:(2*max(which(nfl$schedule$Week <= i)))
    if (max(ind) > length(nfl$y)) ind <- 1:length(nfl$y)
    output <- gibbs(nfl$X[ind,], nfl$y[ind], prior=prior, N=10000)
  }
  fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
  save(fit, file=paste("data/", nfl.par@year, "/fit", i, ".RData",sep=""))

  ## Prediction & summarization
  teamPar(i)
  predictGames(i, rbind(nfl$X, nfl$XX))
}

## Web
updateWebsite(nfl)
