updateWebsite <- function(nfl) {
  week <- if (length(nfl$y)==0) 0 else nfl$schedule$Week[length(nfl$y)/2]  
  makeTeamPar(week)
  makePredictions(nfl$schedule, week)
  if (week!=0) makeRecap(week)
  makeTeams(nfl)
  makeTeamPages(week)
}
