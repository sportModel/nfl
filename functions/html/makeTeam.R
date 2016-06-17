makeTeam <- function(team, Off, Def, Diff, prW, w) {
  fn1 <- paste(nfl.par@year,"_",team,"exW.png",sep="")
  fn2 <- paste(nfl.par@year,"_",team,"diff.png",sep="")
  fn3 <- paste(nfl.par@year,"_",team,"off.png",sep="")
  fn4 <- paste(nfl.par@year,"_",team,"def.png",sep="")

  week <- if (length(nfl$y)==0) 0 else nfl$schedule$Week[length(nfl$y)/2]
  if (week < 17) {
    png(paste(nfl.par@website.location,"/img/",fn1,sep=""))
    Wplot(prW,w)
    dev.off()
  }
  png(paste(nfl.par@website.location,"/img/",fn2,sep=""), 8, 6, res=200, units='in')
  teamplot(team,Diff,ylab="Point differential vs. neutral opponent")
  dev.off()
  png(paste(nfl.par@website.location,"/img/",fn3,sep=""), 8, 6, res=200, units='in')
  teamplot(team,Off,ylab="Points scored vs. neutral opponent")
  dev.off()
  png(paste(nfl.par@website.location,"/img/",fn4,sep=""), 8, 6, res=200, units='in')
  teamplot(team,Def,dec=FALSE,ylab="Points allowed vs. neutral opponent")
  dev.off()

  filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_",team,".html",sep="")
  sink(filename)
  if (week < 17) {
    cat("<img src=\"img/",fn1,"\" class=\"center\" height=\"480\" width=\"480\">",sep="")
    cat("\n<br><br><br>\n")
  }
  if (week > 0) {
    cat("<img src=\"img/",fn2,"\" class=\"center\" height=\"480\" width=\"640\">",sep="")
    cat("\n<br><br><br>\n")
    cat("<img src=\"img/",fn3,"\" class=\"center\" height=\"480\" width=\"640\">",sep="")
    cat("\n<br><br><br>\n")
    cat("<img src=\"img/",fn4,"\" class=\"center\" height=\"480\" width=\"640\">",sep="")
    cat("\n<br><br><br>\n")
  }
  sink()
}
