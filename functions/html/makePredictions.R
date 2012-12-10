makePredictions <- function(schedule, last.week) {
  max.week <- max(schedule$Week)
  sched <- schedule
  sched$Home <- nfl.par@team[match(schedule$Home, nfl.par@team.long)]
  sched$Away <- nfl.par@team[match(schedule$Away, nfl.par@team.long)]  
  for (i in 1:max.week) {
    if (i <= (last.week+1)) load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(sched$Week==i)
    Winner <- character(length(ind))
    Winner[prH[ind] > .5] <- sched[ind[prH[ind] > .5], 3]
    Winner[prH[ind] < .5] <- sched[ind[prH[ind] < .5], 2]
    X <- data.frame(Predicted = apply(round(ms[ind, 1:2]),1,paste,collapse="-"),
                    PrHome = round(100*prH[ind]),
                    PrWin = round(100*pmax(prH[ind],1-prH[ind])),
                    MedDiff = paste(Winner, "by", round(abs(apply(ms[ind,],1,diff)))))
    rownames(X) <- apply(sched[ind,2:3],1,paste,collapse=" @ ")
    print(htmlc(htmlText(paste("Week", schedule[ind,]$Week[1])),
                htmlTable(X, class="'sortable ctable'", digits=0)),
          file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,"Predictions.html",sep=""))
  }
}
