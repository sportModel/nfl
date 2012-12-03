Off <- NULL
Def <- NULL
Diff <- NULL
for (i in 0:17)
  {
    load(paste("data/2010/par",i,".RData",sep=""))
    Off <- cbind(Off,X[,"Off"])
    Def <- cbind(Def,X[,"Def"])
    Diff <- cbind(Diff,X[,"Diff"])
  }
rownames(Off) <- rownames(Def) <- rownames(Diff) <- gsub("\\..*","",rownames(X))
png("../web/football/compiled/logo.png",height=270,width=270)
par(mar=c(5,4,2,2))
teamplot("DET",Diff,ylab="Differential")
dev.off()
