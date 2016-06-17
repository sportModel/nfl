drives <- function(Data) {
  Team <- c(Data$Away, Data$Home)
  for (i in 1:2) {
    X <- Data$Drives[[i]]
    n <- nrow(X)
    YPD <- sum(as.numeric(X$Yds))/n
    Points <- 7*(X$Result=='Touchdown') + 3*(X$Result=='Field Goal')
    PPD <- sum(Points)/n
    TO <- 1*(X$Result=='Fumble') + 1*(X$Result=='Interception')
    cat(Team[i], ': \n', sep='')
    cat('Yards per drive:', round(YPD, 1), '\n')
    cat('Points per drive:', round(PPD, 1), '\n')
    cat('Turnovers:', sum(TO), '\n')
  }
}
