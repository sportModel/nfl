## Read/format data and prior
nfl.par <- setDefaultPar(2011)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

most.recent.week <- nfl$schedule$Week[nrow(nfl$X)/2]
for (i in 0:most.recent.week)
  {
    ## Fitting
    if (i==0) output <- gibbs(nfl$X[NULL,],NULL,prior=prior,N=10000)
    else
      {
        ind <- 1:(2*max(which(nfl$schedule$Week <= i)))
        output <- gibbs(nfl$X[ind,],nfl$y[ind],prior=prior,N=10000)
      }
    fit <- list(mu=apply(output,2,mean),sigma=cov(output))
    save(fit,file=paste("data/",nfl.par@year,"/fit",i,".RData",sep=""))

    ## Prediction & summarization
    teamPar(i)
    predictGames(i,nfl$schedule)
  }

## Web
updateWebsite(nfl)
