makeRecap <- function(last.week) {
  sched <- nfl$schedule
  sched$Home <- nfl.par@team[match(nfl$schedule$Home, nfl.par@team.long)]
  sched$Away <- nfl.par@team[match(nfl$schedule$Away, nfl.par@team.long)]
  results <- matrix(nfl$y, nrow=length(nfl$y)/2, ncol=2, byrow=TRUE)
  results <- data.frame(Week=sched$Week[1:nrow(results)], Away=results[,1], Home=results[,2])
  correct.cum <- c(0,0)
  for (i in 1:last.week) {
    load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(sched$Week==i)
    wl <- cbind(prH[ind]>.5, results[ind,3] > results[ind,2])
    correct <- apply(wl, 1, function(x) x[1]==x[2])
    correct[results[ind,3] == results[ind,2]] <- NA
    X1 <- data.frame(Actual=apply(results[ind,2:3],1,paste,collapse="-"),
                     Predicted=apply(round(ms[ind,1:2]),1,paste,collapse="-"),
                     PrHome = round(100*prH[ind]),
                     PrWin = round(100*pmax(prH[ind],1-prH[ind])),
                     Correct=c("No","Yes")[correct+1],
                     dMargin=abs(apply(results[ind,2:3],1,diff)-apply(ms[ind,1:2],1,diff)),
                     dOverUnder=abs(apply(results[ind,2:3],1,sum)-apply(ms[ind,1:2],1,sum)))
    rownames(X1) <- apply(sched[ind,2:3],1,paste,collapse=" @ ")
    correct.i <- c(sum(correct, na.rm=TRUE), sum(!correct, na.rm=TRUE))
    correct.cum <- correct.cum + correct.i
    
    ## By team
    load(paste("data/",nfl.par@year,"/par",i-1,".RData",sep=""))
    Xold <- X
    load(paste("data/",nfl.par@year,"/par",i,".RData",sep=""))
    Xnew <- X
    X2 <- Xnew-Xold
    
    ## Display
    print(htmlc(htmlText(paste("This week: ", correct.i[1], "-", correct.i[2], "(", round(correct.i[1]/sum(correct.i)*100, 1), "%)<br>Year to date: ", correct.cum[1], "-", correct.cum[2], "(", round(correct.cum[1]/sum(correct.cum)*100, 1), "%)", sep="")),
                htmlTable(X1[order(!correct, X1$dMargin, decreasing=TRUE),], class="'sortable ctable'", digits=0),
                htmlTable(X2[order(X2$Diff, decreasing=TRUE),], class="'sortable ctable'", digits=1)),
          file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,"Recap.html",sep=""))
  }
}
