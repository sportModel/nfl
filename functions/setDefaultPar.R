setClass("NFLpar",representation(team="character",
                                 team.long="character",
                                 divisions="list",
                                 w1="numeric",
                                 w2="numeric",
                                 year="numeric",
                                 website.location="character",
                                 Title="character"))

setDefaultPar <- function(year) {
    team <- c("ARI","ATL","BAL","BUF","CAR","CHI","CIN","CLE","DAL","DEN","DET","GB","HOU","IND","JAC","KC","MIA","MIN","NE","NO","NYG","NYJ","OAK","PHI","PIT","SD","SEA","SF","STL","TB","TEN","WAS")
    team.long <- c("Arizona Cardinals","Atlanta Falcons","Baltimore Ravens","Buffalo Bills","Carolina Panthers","Chicago Bears","Cincinnati Bengals","Cleveland Browns","Dallas Cowboys","Denver Broncos","Detroit Lions","Green Bay Packers","Houston Texans","Indianapolis Colts","Jacksonville Jaguars","Kansas City Chiefs","Miami Dolphins","Minnesota Vikings","New England Patriots","New Orleans Saints","New York Giants","New York Jets","Oakland Raiders","Philadelphia Eagles","Pittsburgh Steelers","San Diego Chargers","Seattle Seahawks","San Francisco 49ers","St. Louis Rams","Tampa Bay Buccaneers","Tennessee Titans","Washington Redskins")
    divisions <- list(c("BUF","MIA","NE","NYJ"),c("BAL","CIN","CLE","PIT"),c("HOU","IND","JAC","TEN"),c("DEN","KC","OAK","SD"),c("DAL","NYG","PHI","WAS"),c("CHI","DET","GB","MIN"),c("ATL","CAR","NO","TB"),c("ARI","SEA","SF","STL"))
    names(divisions) <- c("AFC East","AFC North","AFC South","AFC West","NFC East","NFC North","NFC South","NFC West")
    w1 <- 5
    w2 <- 5
    website.location <- "../web/football"
    Title <- paste("Week", 1:17)
    Title <- c(Title, "Playoffs: Wild Card", "Playoffs: Divisional", "Playoffs: Conference", "Playoffs: Super Bowl")
    val <- new("NFLpar",
               team=team,
               team.long=team.long,
               divisions=divisions,
               w1=w1,
               w2=w2,
               year=year,
               website.location=website.location,
               Title=Title)
    val
  }
