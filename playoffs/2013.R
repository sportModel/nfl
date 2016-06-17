## Setup
nfl.par <- setDefaultPar(2013)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

## Wild-card
nfl$schedule <- rbind(nfl$schedule,
                      c(18, "Kansas City Chiefs", "Indianapolis Colts"),
                      c(18, "New Orleans Saints", "Philadelphia Eagles"),
                      c(18, "San Diego Chargers", "Cincinnati Bengals"),
                      c(18, "San Francisco 49ers", "Green Bay Packers"))
nfl$y <- c(nfl$y, 44, 45, 26, 24, 27, 10, 23, 20)
# nfl$X <- makeX(nfl$schedule)
# week <- 18
# nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
# output <- Gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Divisional round
nfl$schedule <- rbind(nfl$schedule,
                      c(19, "New Orleans Saints", "Seattle Seahawks"),
                      c(19, "Indianapolis Colts", "New England Patriots"),
                      c(19, "San Francisco 49ers", "Carolina Panthers"),
                      c(19, "San Diego Chargers", "Denver Broncos"))
nfl$y <- c(nfl$y, 15, 23, 22, 43, 23, 10, 17, 24)
## nfl$X <- makeX(nfl$schedule)
## week <- 19
## nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
## output <- Gibbs(nfl$X, nfl$y, prior=prior, N=10000)
## fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
## save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Conference championships
nfl$schedule <- rbind(nfl$schedule,
                      c(20, "New England Patriots", "Denver Broncos"),
                      c(20, "San Francisco 49ers", "Seattle Seahawks"))
nfl$y <- c(nfl$y, 16, 26, 17, 23)
nfl$X <- makeX(nfl$schedule)
week <- 20
nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
output <- Gibbs(nfl$X, nfl$y, prior=prior, N=10000)
fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Super Bowl
nfl$schedule <- rbind(nfl$schedule,
                      c(21, "Denver Broncos", "Seattle Seahawks"))

## Update web
nfl$XX <- tail(makeX(nfl$schedule), 2) ## 2/4/8
nfl$XX[,"Home"] <- 0 ## Neutral field for Super Bowl
teamPar(week)
predictGames(week, rbind(nfl$X, nfl$XX))
makeIndex()
makeTeamPar(week)
makePredictions(nfl$schedule, week)
makeRecap(week)
makeTeams(nfl)
makeTeamPages(week)
## SB needs manual editing to account for neutral game
