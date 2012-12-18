updateWebsite <- function(nfl) {
  week <- if (length(nfl$y)==0) 0 else nfl$schedule$Week[length(nfl$y)/2]  
  makeIndex()
  makeTeamPar(week)
  makePredictions(nfl$schedule, week)
  makeRecap(week)
  makeTeams(nfl)
  makeTeamPages(week)
}
