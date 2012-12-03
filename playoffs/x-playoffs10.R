source("setup.R")
nfl.par <- setDefaultPar(2009)
nfl <- formatData()

## Wild Card
nfl$X <- rbind(nfl$X,matrix(0,nrow=8,ncol=66));nfl$y <- c(nfl$y,rep(0,8))
nfl$X[513:520,1] <- 1
nfl$X[513,c("NYJ.Off","CIN.Def","Home")] <- c(1,1,-1);nfl$y[513] <- 24
nfl$X[514,c("NYJ.Def","CIN.Off","Home")] <- c(1,1,1);nfl$y[514] <- 14
nfl$X[515,c("PHI.Off","DAL.Def","Home")] <- c(1,1,-1);nfl$y[515] <- 14
nfl$X[516,c("PHI.Def","DAL.Off","Home")] <- c(1,1,1);nfl$y[516] <- 34
nfl$X[517,c("BAL.Off","NE.Def","Home")] <- c(1,1,-1);nfl$y[517] <- 33
nfl$X[518,c("BAL.Def","NE.Off","Home")] <- c(1,1,1);nfl$y[518] <- 14
nfl$X[519,c("GB.Off","ARI.Def","Home")] <- c(1,1,-1);nfl$y[519] <- 45
nfl$X[520,c("GB.Def","ARI.Off","Home")] <- c(1,1,1);nfl$y[520] <- 51

## Divisional
nfl$X <- rbind(nfl$X,matrix(0,nrow=8,ncol=66));nfl$y <- c(nfl$y,rep(0,8))
nfl$X[521:528,1] <- 1
nfl$X[521,c("ARI.Off","NO.Def","Home")] <- c(1,1,-1);nfl$y[521] <- 14
nfl$X[522,c("ARI.Def","NO.Off","Home")] <- c(1,1,1);nfl$y[522] <- 45
nfl$X[523,c("BAL.Off","IND.Def","Home")] <- c(1,1,-1);nfl$y[523] <- 3
nfl$X[524,c("BAL.Def","IND.Off","Home")] <- c(1,1,1);nfl$y[524] <- 20
nfl$X[525,c("DAL.Off","MIN.Def","Home")] <- c(1,1,-1);nfl$y[525] <- 3
nfl$X[526,c("DAL.Def","MIN.Off","Home")] <- c(1,1,1);nfl$y[526] <- 34
nfl$X[527,c("NYJ.Off","SD.Def","Home")] <- c(1,1,-1);nfl$y[527] <- 17
nfl$X[528,c("NYJ.Def","SD.Off","Home")] <- c(1,1,1);nfl$y[528] <- 14

## Sampler
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))
output <- gibbs(nfl$X,nfl$y,prior=prior,N=10000)
save(output,file=paste("data/",nfl.par@year,"/output.RData",sep=""))

## Update Team Par
loc <- nfl.par@website.location
makeTeamPar(output,loc)
mergeHTML(paste(nfl.par@year,"_TeamPar",sep=""),loc)

## Schedule
## Divisional
schedule <- rbind(c(19,"ARI","NO"),
                  c(19,"BAL","IND"),
                  c(19,"DAL","MIN"),
                  c(19,"NYJ","SD"))
htmlReport(schedule,output) ## Paste to index

## Conference
schedule <- rbind(c(19,"NYJ","IND"),
                  c(19,"MIN","NO"))
htmlReport(schedule,output) ## Paste to index

mergeHTML("index",loc)
