makePredictions <- function(schedule, last.week) {
  max.week <- max(schedule$Week)
  if (last.week == max.week) return()
  load(paste("data/",nfl.par@year,"/pred",last.week,".RData",sep=""))
  for (i in (last.week+1):max.week) {
    ind <- which(schedule$Week==i)
    Winner <- character(length(ind))
    Home <- splitright(names(prH), " @ ")[ind]
    Away <- splitleft(names(prH), " @ ")[ind]
    Winner[prH[ind] > .5] <- Home[prH[ind] > .5]
    Winner[prH[ind] < .5] <- Away[prH[ind] < .5]
    X <- data.frame(Predicted = apply(round(ms[ind, 1:2]),1,paste,collapse="-"),
                    PrHome = round(100*prH[ind]),
                    PrWin = round(100*pmax(prH[ind],1-prH[ind])),
                    MedDiff = paste(Winner, "by", round(abs(apply(ms[ind,],1,diff)))))
    rownames(X) <- names(prH)[ind]
    print(htmlc(htmlText(paste("<h3>Week", schedule[ind,]$Week[1], "</h3>")),
                htmlTable(X, class="'sortable ctable'", digits=0)),
          file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,".html",sep=""))
  }
}
