extractTeams <- function(X) {
  x <- apply(X, 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  x <- gsub(".Off", "", x, fixed=TRUE)
}