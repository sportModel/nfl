## Setup
nfl.par <- setDefaultPar(2013)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

## Fit
output <- Gibbs(nfl$X, nfl$y, prior=prior, N=10000)
fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
week <- nfl$schedule$Week[length(nfl$y)/2]
save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Prediction and summarization
teamPar(week)
predictGames(week, rbind(nfl$X, nfl$XX))

## Update website
updateWebsite(nfl)
