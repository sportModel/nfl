## DEFUNCT
htmlReport <- function(schedule, ms, prH) {
  sched <- schedule
  sched$Home <- nfl.par@team[match(schedule$Home, nfl.par@team.long)]
  sched$Away <- nfl.par@team[match(schedule$Away, nfl.par@team.long)]
  Winner <- character(nrow(sched))
  Winner[prH > .5] <- sched[prH > .5, 3]
  Winner[prH < .5] <- sched[prH < .5, 2]
  X <- data.frame(Predicted = apply(round(ms[,1:2]),1,paste,collapse="-"),
                  PrHome = round(100*prH),
                  PrWin = round(100*pmax(prH,1-prH)),
                  MedDiff = paste(Winner, "by", round(abs(apply(ms,1,diff)))))
  print(htmlc(htmlText(paste("Week", schedule$Week[1])),
              htmlTable(X, class="'sortable ctable'")),
        file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,"Predictions.html",sep=""))
}
