#### Setup ####
nfl.par <- setDefaultPar(2015)
nfl <- formatData()
load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))

#### Wild-card ####
nfl$schedule <- rbind(nfl$schedule,
                      c(18, "Kansas City Chiefs", "Houston Texans"),
                      c(18, "Pittsburgh Steelers", "Cincinnati Bengals"),
                      c(18, "Seattle Seahawks", "Minnesota Vikings"),
                      c(18, "Green Bay Packers", "Washington Redskins"))
nfl$y <- c(nfl$y, 30, 0, 18, 16, 10, 9, 35, 18)
# nfl$X <- makeX(nfl$schedule)
# nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
# week <- 18
# output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Divisional round
nfl$schedule <- rbind(nfl$schedule,
                      c(19, "Kansas City Chiefs", "New England Patriots"),
                      c(19, "Green Bay Packers", "Arizona Cardinals"),
                      c(19, "Seattle Seahawks", "Carolina Panthers"),
                      c(19, "Pittsburgh Steelers", "Denver Broncos"))
nfl$y <- c(nfl$y, 20, 27, 20, 26, 24, 31, 16, 23)
# nfl$X <- makeX(nfl$schedule)
# week <- 19
# nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
# output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Conference championships
nfl$schedule <- rbind(nfl$schedule,
                      c(20, "New England Patriots", "Denver Broncos"),
                      c(20, "Arizona Cardinals", "Carolina Panthers"))
nfl$y <- c(nfl$y, 18, 20, 15, 49)
# nfl$X <- makeX(nfl$schedule)
# week <- 20
# nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
# output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
# fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
# save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

## Super Bowl
nfl$schedule <- rbind(nfl$schedule,
                      c(21, "Denver Broncos", "Carolina Panthers"))
nfl$y <- c(nfl$y, 24, 10)
nfl$X <- makeX(nfl$schedule)
week <- 21
nfl$schedule$Week <- as.numeric(nfl$schedule$Week)
output <- gibbs(nfl$X, nfl$y, prior=prior, N=10000)
fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))

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
