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
    X <- data.frame(Predicted = apply(round(ms[ind, 1:2, drop=FALSE]),1,paste,collapse="-"),
                    PrHome = round(100*prH[ind]),
                    PrWin = round(100*pmax(prH[ind],1-prH[ind])),
                    MedDiff = paste(Winner, "by", round(abs(apply(ms[ind,,drop=FALSE],1,diff)))))
    rownames(X) <- names(prH)[ind]
    print(htmlc(htmlText(paste("<h3>", nfl.par@Title[i], "</h3>")),
                htmlTable(X, class="'sortable ctable'", digits=0),
                htmlText("<b>Predicted</b>: Posterior mean final score for each team", align="left"),
                htmlText("<b>PrHome</b>: Posterior probability that the home team will win", align="left"),
                htmlText("<b>PrWin</b>: Posterior probability that the favorite will win (i.e.,<br> must be above 50%).  Try sorting by PrWin to order <br>games from 'locks' to 'tossups'.", align="left")),
          file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,".html",sep=""))
  }
}
