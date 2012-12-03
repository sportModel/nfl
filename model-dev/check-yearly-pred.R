year <- 2005:2011
##p <- numeric(length(year))
pp <- matrix(NA,nrow=length(year),ncol=17)
pct.corr <- function(X){sum(diag(prop.table(table(X[,1],X[,2]))))}
for (j in 1:length(year))
  {
    nfl.par <- setDefaultPar(year[j])
    nfl <- formatData()
    Y <- matrix(nfl$y,ncol=2,byrow=TRUE)
    P <- matrix(NA,nrow=nrow(Y),ncol=ncol(Y))
    pr <- numeric(nrow(Y))
    most.recent.week <- nfl$schedule$Week[nrow(nfl$X)/2]
    for (i in 1:most.recent.week)
      {
        load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
        ind <- which(nfl$schedule$Week==i)
        P[ind,] <- ms[ind,]
        pr[ind] <- prH[ind]
      }
    s1 <- sign(P[,2]-P[,1])
    s2 <- sign(Y[,2]-Y[,1])
    ind <- which(s2!=0)
    pp[j,1:most.recent.week] <- as.numeric(by(cbind(s1,s2)[ind,],nfl$schedule$Week[ind],pct.corr))
  }
plot(year,apply(pp,1,mean,na.rm=TRUE)*100,"o",pch=16,ylim=c(50,80),ylab="Percent correct",xlab="Year")
plot(1:17,apply(pp,2,mean,na.rm=TRUE)*100,"o",pch=16,ylim=c(50,80),ylab="Percent correct",xlab="Week")
