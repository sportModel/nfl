source("setup.R")
nfl.par <- setDefaultPar()
nfl.par@year <- 2007
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))
weeks <- as.numeric(nfl$schedule[,1])

###########################################
## Examination of w1, the prior on       ##
## team offense/defense ability          ##
###########################################
n.w <- 10
RSS <- numeric(n.w)
w1 <- seq(0.1,10,len=n.w)
for (i in 1:n.w)
  {
    for (week in 0:16)
      {
        ind <- which(weeks==week)
        if (length(ind)==0) S <- 0
        else S <- 2*max(which(weeks==week))
        output <- gibbs(nfl$X[0:S,],nfl$y[0:S],prior=prior,N=1000,w1=w1[i])
        ind <- which(weeks==(week+1))
        y.predicted <- as.numeric(t(meanScore(nfl$schedule[ind,],output)))
        s.ind <- ((min(ind)-1)*2+1):(2*max(ind))
        y.obs <- nfl$y[s.ind]-mean(nfl$y[s.ind])
        RSS[i] <- RSS[i] + crossprod(y.predicted-y.obs)
      }
  }
## Conclusion: Optimal prior weight seems to be under 3 weeks

## Further probing:
w1 <- seq(0.5,3,by=0.5)
n.w <- length(w1)
RSS <- numeric(n.w)
for (i in 1:n.w)
  {
    for (week in 0:16)
      {
        ind <- which(weeks==week)
        if (length(ind)==0) S <- 0
        else S <- 2*max(which(weeks==week))
        output <- gibbs(nfl$X[0:S,],nfl$y[0:S],prior=prior,N=1000,w1=w1[i])
        ind <- which(weeks==(week+1))
        y.predicted <- as.numeric(t(meanScore(nfl$schedule[ind,],output)))
        s.ind <- ((min(ind)-1)*2+1):(2*max(ind))
        y.obs <- nfl$y[s.ind]-mean(nfl$y[s.ind])
        RSS[i] <- RSS[i] + crossprod(y.predicted-y.obs)
      }
  }
## Conclusion: Optimal prior weight seems to about 1 week

###########################################
## Examination of w2, the prior on       ##
## score variability                     ##
###########################################
w2 <- c(1,5,10)
n.w <- length(w2)
RSS <- numeric(n.w)
for (i in 1:n.w)
  {
    for (week in 0:16)
      {
        ind <- which(weeks==week)
        if (length(ind)==0) S <- 0
        else S <- 2*max(which(weeks==week))
        output <- gibbs(nfl$X[0:S,],nfl$y[0:S],prior=prior,N=1000,w1=1,w2=w2[i])
        ind <- which(weeks==(week+1))
        y.predicted <- as.numeric(t(meanScore(nfl$schedule[ind,],output)))
        s.ind <- ((min(ind)-1)*2+1):(2*max(ind))
        y.obs <- nfl$y[s.ind]-mean(nfl$y[s.ind])
        RSS[i] <- RSS[i] + crossprod(y.predicted-y.obs)
      }
  }
## Seems to be best around 5

w2 <- 3:7
n.w <- length(w2)
RSS <- numeric(n.w)
for (i in 1:n.w)
  {
    for (week in 0:16)
      {
        ind <- which(weeks==week)
        if (length(ind)==0) S <- 0
        else S <- 2*max(which(weeks==week))
        output <- gibbs(nfl$X[0:S,],nfl$y[0:S],prior=prior,N=1000,w1=1,w2=w2[i])
        ind <- which(weeks==(week+1))
        y.predicted <- as.numeric(t(meanScore(nfl$schedule[ind,],output)))
        s.ind <- ((min(ind)-1)*2+1):(2*max(ind))
        y.obs <- nfl$y[s.ind]-mean(nfl$y[s.ind])
        RSS[i] <- RSS[i] + crossprod(y.predicted-y.obs)
      }
  }
plot(w2,RSS)
## 5 seems optimal
