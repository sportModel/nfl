makeTeamPages <- function(last.week) {
  Off <- NULL
  Def <- NULL
  Diff <- NULL
  for (i in 0:last.week) {
    load(paste("data/",nfl.par@year,"/par",i,".RData",sep=""))
    Off <- cbind(Off,X[,"Off"])
    Def <- cbind(Def,X[,"Def"])
    Diff <- cbind(Diff,X[,"Diff"])
  }
  ##rownames(Off) <- rownames(Def) <- rownames(Diff) <- nfl.par@team
  rownames(Off) <- rownames(Def) <- rownames(Diff) <- gsub("\\..*","",rownames(X))
  load(paste("data/",nfl.par@year,"/pred",last.week,".RData",sep=""))
  for (team in nfl.par@team) {
    sched <- nfl$schedule
    sched$Home <- nfl.par@team[match(nfl$schedule$Home, nfl.par@team.long)]
    sched$Away <- nfl.par@team[match(nfl$schedule$Away, nfl.par@team.long)]
    ind.h <- which(team==sched$Home & sched$Week > last.week)
    ind.a <- which(team==sched$Away & sched$Week > last.week)
    prW <- c(prH[ind.h],1-prH[ind.a])
    off.ind <- which(nfl$X[,paste(team,".Off",sep="")]==1)
    def.ind <- which(nfl$X[,paste(team,".Def",sep="")]==1)
    w <- sum(nfl$y[off.ind] > nfl$y[def.ind])
    makeTeam(team,Off,Def,Diff,prW,w)
  }
}
