makeRecap <- function(last.week) {
  results <- matrix(nfl$y, nrow=length(nfl$y)/2, ncol=2, byrow=TRUE)
  results <- data.frame(Week=nfl$schedule$Week[1:nrow(results)], Away=results[,1], Home=results[,2])
  X <- nfl$X
  n.g <- nrow(results)
  a <- apply(X[2*(1:n.g)-1,], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  h <- apply(X[2*(1:n.g),], 1, function(x) {a <- colnames(X)[which(x==1)]; a[grep("Off",a)]})
  Game <- gsub(".Off", "", paste(a, h, sep=" @ "), fixed=TRUE)
  correct.cum <- c(0,0)

  for (i in 1:last.week) {
    load(paste("data/",nfl.par@year,"/pred",i-1,".RData",sep=""))
    ind <- which(results$Week==i)
    id1 <- paste("Week", i, names(prH), sep="")
    id2 <- paste("Week", results$Week, Game, sep="")
    res <- results[match(id1[ind], id2), ]
    wl <- cbind(prH[ind]>.5, res[,3] > res[,2])
    correct <- apply(wl, 1, function(x) x[1]==x[2])
    correct[res[,3] == res[,2]] <- NA
    correct.i <- c(sum(correct, na.rm=TRUE), sum(!correct, na.rm=TRUE))
    correct.cum <- correct.cum + correct.i
    Winner <- character(length(ind))
    Home <- splitright(names(prH), " @ ")[ind]
    Away <- splitleft(names(prH), " @ ")[ind]
    Winner[prH[ind] > .5] <- Home[prH[ind] > .5]
    Winner[prH[ind] < .5] <- Away[prH[ind] < .5]
    X1 <- data.frame(Actual=apply(res[,2:3],1,paste,collapse="-"),
                     Predicted=apply(round(ms[ind, 1:2, drop=FALSE]),1,paste,collapse="-"),
                     PrHome = round(100*prH[ind]),
                     PrWin = round(100*pmax(prH[ind],1-prH[ind])),
                     MedDiff = paste(Winner, "by", round(abs(apply(ms[ind,, drop=FALSE],1,diff)))),
                     Correct=c("No","Yes")[correct+1],
                     dMargin=abs(apply(res[,2:3, drop=FALSE],1,diff)-apply(ms[ind,1:2, drop=FALSE],1,diff)),
                     dOverUnder=abs(apply(res[,2:3, drop=FALSE],1,sum)-apply(ms[ind,1:2, drop=FALSE],1,sum)))
    rownames(X1) <- names(prH)[ind]

    ## By team
    load(paste("data/",nfl.par@year,"/par",i-1,".RData",sep=""))
    Xold <- X
    load(paste("data/",nfl.par@year,"/par",i,".RData",sep=""))
    Xnew <- X
    X2 <- Xnew-Xold
    a <- 2*(min(ind)-1) + 1
    active <- extractTeams(rbind(nfl$X[a:nrow(nfl$X),], nfl$XX))
    X2 <- X2[rownames(X2) %in% active, ]

    ## Display
    print(htmlc(htmlText(paste("<h3>", nfl.par@Title[i], "</h3>")),
                htmlText(paste("This week: ", correct.i[1], "-", correct.i[2], "(", round(correct.i[1]/sum(correct.i)*100, 1), "%)<br>Year to date: ", correct.cum[1], "-", correct.cum[2], "(", round(correct.cum[1]/sum(correct.cum)*100, 1), "%)", sep="")),
                htmlTable(X1[order(!correct, X1$dMargin, decreasing=TRUE),], class="'sortable ctable'", digits=0),
                htmlText("<b>dMargin</b>: Absolute difference between predicted margin of victory and actual margin of victory.  For example, <br>if the model predicted that the home team would win by 5, and then the home team lost by 5, <b>dMargin</b> <br>would equal 10.", align="left"),
                htmlText("<b>dOverUnder</b>: Same as <b>dMargin</b>, but for the total number of points scored in the game.", align="left"),
                htmlText("<br><br>Change in parameter estimates as a result of this week's games:"),
                htmlTable(X2[order(X2$Diff, decreasing=TRUE),], class="'sortable ctable'", digits=1)),
          file=paste(nfl.par@website.location,"/",nfl.par@year,"_Week",i,".html",sep=""))
  }
}
