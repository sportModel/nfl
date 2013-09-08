makeTeam <- function(team, Off, Def, Diff, prW, w) {
  fn1 <- paste(nfl.par@year,"_",team,"exW.png",sep="")
  fn2 <- paste(nfl.par@year,"_",team,"diff.png",sep="")
  fn3 <- paste(nfl.par@year,"_",team,"off.png",sep="")
  fn4 <- paste(nfl.par@year,"_",team,"def.png",sep="")

  week <- if (length(nfl$y)==0) 0 else nfl$schedule$Week[length(nfl$y)/2]  
  if (week < 17) {
    png(paste(nfl.par@website.location,"/compiled/",fn1,sep=""))
    Wplot(prW,w)
    dev.off()    
  }
  png(paste(nfl.par@website.location,"/compiled/",fn2,sep=""))
  teamplot(team,Diff,ylab="Point differential vs. neutral opponent")
  dev.off()
  png(paste(nfl.par@website.location,"/compiled/",fn3,sep=""))
  teamplot(team,Off,ylab="Points scored vs. neutral opponent")
  dev.off()
  png(paste(nfl.par@website.location,"/compiled/",fn4,sep=""))
  teamplot(team,Def,dec=FALSE,ylab="Points allowed vs. neutral opponent")
  dev.off()
  
  filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_",team,".html",sep="")
  sink(filename)
  if (week < 17) {
    cat("<img src=\"",fn1,"\" class=\"center\" height=\"480\" width=\"480\">",sep="")
    cat("\n<br><br><br>\n")    
  }
  if (week > 0) {
    cat("<img src=\"",fn2,"\" class=\"center\" height=\"480\" width=\"480\">",sep="")
    cat("\n<br><br><br>\n")
    cat("<img src=\"",fn3,"\" class=\"center\" height=\"480\" width=\"480\">",sep="")
    cat("\n<br><br><br>\n")
    cat("<img src=\"",fn4,"\" class=\"center\" height=\"480\" width=\"480\">",sep="")
    cat("\n<br><br><br>\n")    
  }
  sink()
}
