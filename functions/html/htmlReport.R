htmlReport <- function(schedule,ms,prH)
  {
    cat("Week",schedule[1,1],"<br><br><br>\n")
    md <- ms[,2]-ms[,1]
    ms <- round(ms,1)
    for (i in 1:length(prH))
      {
        away <- schedule[i,2]
        home <- schedule[i,3]
        game <- paste(away,"@", home)
        cat("<b>",game,"</b><br><br>\n")
        cat("Probability of ",away,": ",round(1-prH[i],3),"<br>\n",sep="")
        cat("Probability of ",home,": ",round(prH[i],3),"<br>\n",sep="")
        if (md[i] > 0) cat("Mean score: ", home, " ",ms[i,2],", ",away," ",ms[i,1],"<br>\n",sep="")
        if (md[i] < 0) cat("Mean score: ", away, " ",ms[i,1],", ",home," ",ms[i,2],"<br>\n",sep="")
        if (md[i]>0) cat("Median differential: ", home, " by ", round(md[i],digits=0),"<br>\n",sep="")
        if (md[i]<0) cat("Median differential: ", away, " by ", round(-md[i],digits=0),"<br>\n",sep="")
        cat("<br><br>\n")
      }
  }
