prHome <- function(X, posterior) {
  N <- dim(posterior)[1]
  n.g <- nrow(X)/2
  val <- matrix(NA, nrow=N, ncol=n.g)
  for (i in 1:N) {
    mean.scores <- X%*%posterior[i, match(colnames(X), colnames(posterior))]
    mean <- mean.scores[2*(1:n.g)] - mean.scores[2*(1:n.g)-1]
    val[i,] <- pnorm(0,mean,sqrt(2/posterior[i,"h"]),low=F)
  }
  apply(val,2,mean)
}
