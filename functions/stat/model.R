model <- function() {
  ## Likelihood
  for (i in 1:n) {
    y[i] ~ dt(eta[i], tau, 25)
    #y[i] ~ dnorm(eta[i], tau)
    eta[i] <- inprod(X[i,], b[])
  }
  
  ## Prior on beta
  bb ~ dmnorm(mu.b, Omega.b)
#   for (j in 1:66) {
#     bb[j] ~ dnorm(mu.b[j], Omega.b[j,j])
#   }
  
  ## Centering
  b[1] <- bb[1] + mean(bb[2:33]) + mean(bb[34:65])
  for (j1 in 2:33) {
    b[j1] <- bb[j1] - mean(bb[2:33])
  }
  for (j2 in 34:65) {
    b[j2] <- bb[j2] - mean(bb[34:65])
  }
  b[66] <- bb[66]
  
  ## Prior on tau
  ## s = Prior RSS
  ## v = Prior sample size
  tau <- t/s
  t ~ dchisqr(v)
}
