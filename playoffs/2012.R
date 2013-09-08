## Setup
nfl.par <- setDefaultPar(2012)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

## Wild-card
nfl$schedule <- rbind(nfl$schedule,
                      c(18, "Cincinnati Bengals", "Houston Texans"),
                      c(18, "Minnesota Vikings", "Green Bay Packers"),
                      c(18, "Indianapolis Colts", "Baltimore Ravens"),
                      c(18, "Seattle Seahawks", "Washington Redskins"))
nfl$y <- c(nfl$y, 13, 19, 10, 24, 9, 24, 24, 14)
# nfl$X <- makeX(nfl$schedule)
# output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Divisional round
nfl$schedule <- rbind(nfl$schedule,
                      c(19, "Baltimore Ravens", "Denver Broncos"),
                      c(19, "Green Bay Packers", "San Francisco 49ers"),
                      c(19, "Seattle Seahawks", "Atlanta Falcons"),
                      c(19, "Houston Texans", "New England Patriots"))
nfl$y <- c(nfl$y, 38, 35, 31, 45, 28, 30, 28, 41)
# nfl$X <- makeX(nfl$schedule)
# output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", 19, ".RData",sep=""))

## Conference championships
nfl$schedule <- rbind(nfl$schedule,
                      c(20, "Baltimore Ravens", "New England Patriots"),
                      c(20, "San Francisco 49ers", "Atlanta Falcons"))
nfl$y <- c(nfl$y, 28, 13, 28, 24)
nfl$X <- makeX(nfl$schedule)
output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
save(fit, file=paste("data/", nfl.par@year, "/fit", 20, ".RData",sep=""))

## Super Bowl
nfl$schedule <- rbind(nfl$schedule,
                      c(21, "Baltimore Ravens", "San Francisco 49ers"))
nfl$XX <- tail(makeX(nfl$schedule), 2)
nfl$XX[,"Home"] <- 0

## Update web
week <- 20
teamPar(week)
predictGames(week, rbind(nfl$X, nfl$XX))
makeIndex()
makeTeamPar(week)
makePredictions(nfl$schedule, week, title="Super Bowl")
makeRecap(week)
makeTeams(nfl)
makeTeamPages(week)
## SB needs manual editing to account for neutral game
