nfl.par <- setDefaultPar(2012)
nfl <- formatData()

# load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))
most.recent.week <- nfl$schedule$Week[nrow(nfl$X)/2]

## Fit
ind <- 1:(2*max(which(nfl$schedule$Week <= most.recent.week)))
output <- gibbs(nfl$X[ind,],nfl$y[ind],prior=prior,N=10000)
fit <- list(mu=apply(output,2,mean),sigma=cov(output))
save(fit,file=paste("data/",nfl.par@year,"/fit",most.recent.week,".RData",sep=""))

## Prediction & summarization
teamPar(most.recent.week)
predictGames(most.recent.week,nfl$schedule)

updateWebsite(nfl)
