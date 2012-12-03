load("data/2010/fit17.RData")
n <- 512
prior <- list(beta=fit$mu[1:66],
              H=ginv(fit$sigma[1:66,1:66]),
              v=n,
              s2=n/fit$mu[67])
save(prior,file="data/2011/prior.RData")
