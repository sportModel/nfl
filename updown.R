load("data/2011/par9.RData")
Xold <- X
load("data/2011/par10.RData")
Xnew <- X
up <- which(Xnew[,3]-Xold[,3] > 1)
dn <- which(Xnew[,3]-Xold[,3] < -1)
Xnew[up,]
Xnew[dn,]
maxup <- which.max(Xnew[,3]-Xold[,3])
maxdn <- which.max(Xold[,3]-Xnew[,3])
Xnew[maxup,]
Xnew[maxdn,]
