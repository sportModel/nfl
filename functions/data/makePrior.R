makePrior <- function(year) {
  priorYear <- year-1
  
  ## Scan for maxWeek
  priorFiles <- list.files(paste("data/", priorYear, sep=""))
  priorFiles <- priorFiles[grep("fit", priorFiles)]
  priorFiles <- gsub("fit", "", priorFiles)
  priorFiles <- gsub(".RData", "", priorFiles, fixed=TRUE)
  maxWeek <- max(as.numeric(priorFiles)) ## Improve in future: scan for max week
  
  ## Make prior
  load(paste("data/", priorYear, "/fit", maxWeek, ".RData", sep=""))
  if (is.null(fit$n)) fit$n <- 512
  prior <- list(beta=fit$mu[1:66],
                H=ginv(fit$sigma[1:66,1:66]),
                v=fit$n,
                s2=fit$n/fit$mu[67])
  save(prior, file=paste("data/", year, "/prior.RData", sep=""))
}
