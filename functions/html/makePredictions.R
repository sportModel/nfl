makePredictions <- function(schedule, last.week) {
  max.week <- max(schedule$Week)
  for (i in 1:last.week) {
    load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(schedule$Week==i)
    filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,"Predictions.html",sep="")
    sink(filename)
    htmlReport(schedule[ind,],ms[ind,],prH[ind])
    sink()
  }
  load(paste("data/",nfl.par@year,"/pred",last.week,".RData",sep=""))
  if (last.week!=max.week) {
    for (i in (last.week+1):(max(schedule$Week))) {
      filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,"Predictions.html",sep="")
      ind <- which(schedule$Week==i)
      sink(filename)
      htmlReport(schedule[ind,],ms[ind,],prH[ind])
      sink()        
    }
  }
}
