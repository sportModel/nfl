makeX <- function(schedule) {
  away <- schedule[,2]
  home <- schedule[,3]
  n.g <- dim(schedule)[1]
  teams <- nfl.par@team.long
  #teams <- sort(unique(c(home,away)))
  n.t <- length(teams)
  X.Off <- matrix(0, ncol=n.t, nrow=2*n.g)
  X.Def <- matrix(0, ncol=n.t, nrow=2*n.g)
  X.h <- matrix(c(-1,1), ncol=1, nrow=2*n.g)
  X.Off[cbind(2*c(1:n.g)-1, match(away,teams))] <- 1
  X.Off[cbind(2*c(1:n.g),match(home,teams))] <- 1
  X.Def[cbind(2*c(1:n.g)-1,match(home,teams))] <- 1
  X.Def[cbind(2*c(1:n.g),match(away,teams))] <- 1
  tm <- nfl.par@team[match(teams, nfl.par@team.long)]
  colnames(X.Off) <- paste(tm,".Off",sep="")
  colnames(X.Def) <- paste(tm,".Def",sep="")
  X <- cbind(1,X.Off,X.Def,X.h)
  colnames(X)[2*n.t+2] <- "Home"
  colnames(X)[1] <- "Intercept"
  return(X)
}
