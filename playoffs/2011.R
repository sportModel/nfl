nfl.par <- setDefaultPar(2011)

## Wild-card
##schedule <- rbind(c(18,"CIN","HOU"),
##                  c(18,"PIT","DEN"),
##                  c(18,"DET","NO"),
##                  c(18,"ATL","NYG"))
##pred <- predictGames(17,schedule,out="return")
##makeIndex()
##sink(paste(nfl.par@website.location,"/2011_Week18Predictions.html",sep=""))
##cat(htmlReport(schedule,pred$ms,pred$prH))
##sink()

## Divisional
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))
nfl <- formatData()
nfl$X <- rbind(nfl$X,matrix(0,nrow=8,ncol=66));nfl$y <- c(nfl$y,rep(0,8))
nfl$X[513:520,1] <- 1
nfl$X[513,c("CIN.Off","HOU.Def","Home")] <- c(1,1,-1);nfl$y[513] <- 10
nfl$X[514,c("CIN.Def","HOU.Off","Home")] <- c(1,1,1);nfl$y[514] <- 31
nfl$X[515,c("DET.Off","NO.Def","Home")] <- c(1,1,-1);nfl$y[515] <- 28
nfl$X[516,c("DET.Def","NO.Off","Home")] <- c(1,1,1);nfl$y[516] <- 45
nfl$X[517,c("ATL.Off","NYG.Def","Home")] <- c(1,1,-1);nfl$y[517] <- 2
nfl$X[518,c("ATL.Def","NYG.Off","Home")] <- c(1,1,1);nfl$y[518] <- 24
nfl$X[519,c("PIT.Off","DEN.Def","Home")] <- c(1,1,-1);nfl$y[519] <- 23
nfl$X[520,c("PIT.Def","DEN.Off","Home")] <- c(1,1,1);nfl$y[520] <- 29
##output <- gibbs(nfl$X,nfl$y,prior=prior,N=10000)
##fit <- list(mu=apply(output,2,mean),sigma=cov(output))
##save(fit,file="data/2011/fit18.RData")

##teamPar(18)
##makeTeamPar(18)
##schedule <- rbind(c(19,"NO","SF"),
##                  c(19,"DEN","NE"),
##                  c(19,"HOU","BAL"),
##                  c(19,"NYG","GB"))
##pred <- predictGames(18,schedule,out="return")
##makeIndex()
##sink(paste(nfl.par@website.location,"/2011_Week19Predictions.html",sep=""))
##cat(htmlReport(schedule,pred$ms,pred$prH))
##sink()

## Conference
nfl$X <- rbind(nfl$X,matrix(0,nrow=8,ncol=66));nfl$y <- c(nfl$y,rep(0,8))
nfl$X[521:528,1] <- 1
nfl$X[521,c("NO.Off","SF.Def","Home")] <- c(1,1,-1);nfl$y[521] <- 32
nfl$X[522,c("NO.Def","SF.Off","Home")] <- c(1,1,1);nfl$y[522] <- 36
nfl$X[523,c("DEN.Off","NE.Def","Home")] <- c(1,1,-1);nfl$y[523] <- 10
nfl$X[524,c("DEN.Def","NE.Off","Home")] <- c(1,1,1);nfl$y[524] <- 45
nfl$X[525,c("HOU.Off","BAL.Def","Home")] <- c(1,1,-1);nfl$y[525] <- 13
nfl$X[526,c("HOU.Def","BAL.Off","Home")] <- c(1,1,1);nfl$y[526] <- 20
nfl$X[527,c("NYG.Off","GB.Def","Home")] <- c(1,1,-1);nfl$y[527] <- 37
nfl$X[528,c("NYG.Def","GB.Off","Home")] <- c(1,1,1);nfl$y[528] <- 20
##output <- gibbs(nfl$X,nfl$y,prior=prior,N=10000)
##fit <- list(mu=apply(output,2,mean),sigma=cov(output))
##save(fit,file="data/2011/fit19.RData")

##teamPar(19)
##makeTeamPar(19)
##schedule <- rbind(c(20,"BAL","NE"),
##                  c(20,"NYG","SF"))
##pred <- predictGames(19,schedule,out="return")
##makeIndex()
##sink(paste(nfl.par@website.location,"/2011_Week20Predictions.html",sep=""))
##cat(htmlReport(schedule,pred$ms,pred$prH))
##sink()

## Super Bowl
nfl$X <- rbind(nfl$X,matrix(0,nrow=4,ncol=66));nfl$y <- c(nfl$y,rep(0,4))
nfl$X[529:532,1] <- 1
nfl$X[529,c("BAL.Off","NE.Def","Home")] <- c(1,1,-1);nfl$y[529] <- 20
nfl$X[530,c("BAL.Def","NE.Off","Home")] <- c(1,1,1);nfl$y[530] <- 23
nfl$X[531,c("NYG.Off","SF.Def","Home")] <- c(1,1,-1);nfl$y[531] <- 20
nfl$X[532,c("NYG.Off","SF.Def","Home")] <- c(1,1,-1);nfl$y[532] <- 17
output <- gibbs(nfl$X,nfl$y,prior=prior,N=10000)
fit <- list(mu=apply(output,2,mean),sigma=cov(output))
save(fit,file="data/2011/fit20.RData")

teamPar(20)
makeTeamPar(20)
schedule <- matrix(c(21,"NYG","NE"),nrow=1)
pred <- predictGames(20,schedule,out="return",neutral=TRUE)
makeIndex()
sink(paste(nfl.par@website.location,"/2011_Week21Predictions.html",sep=""))
cat(htmlReport(schedule,pred$ms,pred$prH))
sink()
