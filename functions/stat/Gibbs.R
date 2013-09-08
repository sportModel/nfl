Gibbs <- function(X, y, prior, N) {
  require(R2jags)
  invisible(runif(1))
  nfl.data <- list(X = X,
                   y = y,
                   n = length(y),
                   mu.b = prior$beta,
                   Omega.b = diag(diag(prior$H))/nfl.par@w1,
                   ##Omega.b = prior$H/nfl.par@w1,
                   v = prior$v/nfl.par@w2,
                   s = prior$s2/nfl.par@w2)
  nfl.parm <- c("b", "tau")
  
  ## Fit
  fit <- jags(nfl.data, init=NULL, nfl.parm, model=model, n.chains=1, n.iter=N, n.burn=0, DIC=FALSE)
  val <- fit$BUGSoutput$sims.matrix
  colnames(val) <- c(colnames(X), "h")
  val
}
