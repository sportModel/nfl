makeTeams <- function(nfl) {
  ## Calculate wins, losses
  w <- l <- numeric(length(nfl.par@team))
  for (i in 1:length(nfl.par@team)) {
    off.ind <- which(nfl$X[,paste(nfl.par@team[i],".Off",sep="")]==1)
    def.ind <- which(nfl$X[,paste(nfl.par@team[i],".Def",sep="")]==1)
    w[i] <- sum(nfl$y[off.ind] > nfl$y[def.ind])
    l[i] <- sum(nfl$y[off.ind] < nfl$y[def.ind])
  }
  
  ## create list of matrices
  n.d <- length(nfl.par@divisions)
  X <- D <- vector("list",n.d)
  for (d in 1:length(nfl.par@divisions)) {
    teams <- nfl.par@divisions[[d]]
    ind <- match(teams,nfl.par@team)
    X[[d]] <- matrix("",nrow=length(teams),ncol=4)
    X[[d]][,1] <- teams
    X[[d]][,2] <- nfl.par@team.long[ind]
    X[[d]][,3] <- w[ind]
    X[[d]][,4] <- l[ind]
    X[[d]] <- X[[d]][order(w[ind]/(w[ind]+l[ind]),decreasing=TRUE),]
    
    ## Format for printing
    link <- character(length(teams))
    for (i in 1:length(teams)) {
      link[i] <- paste("@@lt@@A href=@@quote@@",nfl.par@year,"_",X[[d]][i,1],".html@@quote@@ @@gt@@ ",X[[d]][i,2],"@@lt@@/a@@gt@@",sep="")
    }
    X[[d]] <- cbind(link,X[[d]][,3:4])
    colnames(X[[d]]) <- c("Team","W","L")
    D[[d]] <- xtable(X[[d]])
    align(D[[d]]) <- c("l","l","r","r")
  }
  
  ## display
  filename <- paste(nfl.par@website.location,"/",nfl.par@year,"_Teams.html",sep="")
  sink(filename)
  cat("<TABLE class=\"container\">\n")
  for (i in 1:4)
  {
    cat("<TR><TD align=\"center\">",names(nfl.par@divisions)[i],"</TD><TD align=\"center\">",names(nfl.par@divisions)[i+4],"</TD></TR>\n<TR><TD>")
    print(D[[i]],type="html",include.rownames=FALSE,html.table.attributes="class=\"sortable ctable\" width=100%")
    cat("</TD>\n<TD>")
    print(D[[i+4]],type="html",include.rownames=FALSE,html.table.attributes="class=\"sortable ctable\" width=100%")
    cat("</TD></TR>\n")
  }
  cat("</TABLE>\n")
  sink()
  cleanTable(filename)
}
