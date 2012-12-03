updateWebsite <- function(nfl)
  {
    if (length(nfl$y)==0) last.week <- 0
    else last.week <- nfl$schedule$Week[length(nfl$y)/2]
    
    makeIndex()
    makeTeamPar(last.week)
    makePredictions(nfl$schedule,last.week)
    makeTeams(nfl)
    makeTeamPages(last.week)
  }
