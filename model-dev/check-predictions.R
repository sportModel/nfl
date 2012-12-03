## Read/format data and prior
nfl.par <- setDefaultPar(2009)
nfl <- formatData()
Y <- matrix(nfl$y,ncol=2,byrow=TRUE)
P <- matrix(NA,nrow=nrow(Y),ncol=ncol(Y))
pr <- numeric(nrow(Y))
for (i in 1:17)
  {
    load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(nfl$schedule$Week==i)
    P[ind,] <- ms[ind,]
    pr[ind] <- prH$prH[ind]
  }

examine <- function(x,y,...)
  {
    fit <- lm(y~x)
    print(summary(fit))
    fit0 <- lm(y~0+x)
    print(summary(fit0))
    ##par(mfrow=c(2,2))
    plot(x,y,pch=16,cex=0.7,col=rgb(0,0,0,alpha=0.5),...)
    abline(0,1)
    abline(coef=coef(fit),col="red")
    ##hist(fit$residuals)
    ##plot(fit$fitted,fit$residuals)
    ##fit <- lowess(y~x)
    ##lines(fit,col="blue")
  }
examine(P[,1],Y[,1])
examine(P[,2],Y[,2])
examine(P[,2]-P[,1],Y[,2]-Y[,1])
s <- sign(P[,2]-P[,1])
examine(s*(P[,2]-P[,1]),s*(Y[,2]-Y[,1]))
par(mfrow=c(2,2))
plot(lm(s*(Y[,2]-Y[,1])~s*(P[,2]-P[,1])))

svg("pred-vs-actual-margin.svg")
examine(s*(P[,2]-P[,1]),s*(Y[,2]-Y[,1]),xlab="Predicted margin of victory",ylab="Actual margin of victory")
dev.off()
system("eog pred-vs-actual-margin.svg")

## Predictive accuracy
s1 <- sign(P[,2]-P[,1])
s2 <- sign(Y[,2]-Y[,1])
table(s1,s2)
sum(diag(prop.table(table(s1,s2))))
fit <- glm((s2+1)/2~pr,family="binomial")
source.dir("~/Dropbox/visreg/visreg/R")
visreg(fit,"pr",scale="response")
abline(0,1,col="red")
predict(fit,newdata=data.frame(pr=.8),type="response")
f <- function(X){sum(diag(prop.table(table(X[,1],X[,2]))))}
conf <- ceiling((abs(pr-0.5)+0.5)*10)
## ERROR
## Needs to be factors 
by(cbind(s1,s2),conf,f)


## Gamma
sig <- 0.2
mu <- 30;x <- rgamma(10000,shape=1/sig,scale=mu*sig)
mu <- 20;y <- rgamma(10000,shape=1/sig,scale=mu*sig)
par(mfrow=c(2,1))
hist(x,xlim=c(0,80),breaks=seq(0,1000,5))
hist(y,xlim=c(0,80),breaks=seq(0,1000,5))
median(x-y)

## Lognormal
v <- .15
mu <- 30;x <- rlnorm(10000,log(mu)-v/2,sqrt(v))
mu <- 20;y <- rlnorm(10000,log(mu)-v/2,sqrt(v))
par(mfrow=c(2,1))
hist(x,xlim=c(0,80),breaks=seq(0,1000,5))
hist(y,xlim=c(0,80),breaks=seq(0,1000,5))
median(x-y)

## InvGauss
require(statmod)
l <- 200
x <- rinvgauss(10000,30,l)
y <- rinvgauss(10000,20,l)
par(mfrow=c(2,1))
hist(x,xlim=c(0,80),breaks=seq(0,1000,5))
hist(y,xlim=c(0,80),breaks=seq(0,1000,5))
median(x-y)
