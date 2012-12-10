makePrior <- function(year) {
  priorYear <- year-1
  maxWeek <- 17 ## Improve in future: scan for max week
  load(paste("data/", priorYear, "/fit", maxWeek, ".RData", sep=""))
  if (is.null(fit$n)) fit$n <- 512
  prior <- list(beta=fit$mu[1:66],
                H=ginv(fit$sigma[1:66,1:66]),
                v=fit$n,
                s2=fit$n/fit$mu[67])
  save(prior, file=paste("data/", year, "/prior.RData", sep=""))
}
