# Reads raw html file and returns:
##   X
##   y
##   week (current week; i.e. week = 7 implies that all week 6 games are over
##   schedule (the entire schedule for all weeks)
formatData <- function() {
  filename <- paste("data/",nfl.par@year,"/nfl.html",sep="")
  raw <- readLines(filename,warn=F)
  
  warn <- getOption("warn")
  options(warn=-1)
  start.table.lines <- grep("<table",raw,fixed=T)
  end.table.lines <- grep("/table>",raw,fixed=T)
  options(warn=warn)
  start.data.table.lines <- grep("data-table1",raw[start.table.lines])
  week.lines <- cbind(start.table.lines,end.table.lines)[start.data.table.lines,]
  n.weeks <- nrow(week.lines)
  
  schedule <- NULL
  y <- NULL
  for (i in 1:n.weeks) {
    raw.i <- raw[week.lines[i,1]:week.lines[i,2]]
    raw.i <- gsub("\t","",raw.i)
    raw.i <- gsub("\\<a[^\\>]*\\>","",raw.i,perl=T)
    raw.i <- gsub("\\</a\\>","",raw.i,perl=T)
    raw.i <- gsub("\\</td\\>","",raw.i,perl=T)
    raw.i <- gsub("\\</tr\\>","",raw.i,perl=T)
    raw.i <- raw.i[!raw.i==""]
    raw.i <- raw.i[-grep("table",raw.i)]
    raw.i <- raw.i[min(grep("td",raw.i)):max(grep("td",raw.i))]
    raw.i <- gsub("\\<td[^\\>]*\\>","AAXXXXXAA",raw.i,perl=T)
    raw.i <- unlist(strsplit(paste(raw.i,collapse=""),"AAXXXXXAA"))
    raw.i <- raw.i[-grep("<tr class",raw.i,fixed=T)]
    if (gsub(" ","",raw.i[6])=="Final") {
      raw.i <- matrix(raw.i,ncol=4,byrow=T)
      raw.i <- raw.i[grep("@",raw.i,fixed=T),]
      raw.i <- raw.i[,1]
      raw.i <- unlist(strsplit(unlist(strsplit(raw.i,"@"))," "))
      raw.i <- raw.i[raw.i!=""]
      results.i <- matrix(raw.i,ncol=4,byrow=T)
      schedule.i <- cbind(i,results.i[,c(1,3)])
      y <- c(y,t(results.i[,c(2,4)]))
    } else {
      blanks <- which(raw.i=="")
      raw.i <- raw.i[-c(blanks,blanks+1,blanks+2)]
      raw.i <- matrix(raw.i,ncol=7,byrow=T)
      raw.i <- raw.i[grep("@",raw.i,fixed=T),]
      raw.i <- raw.i[,1]
      raw.i <- gsub(" ","",raw.i)
      schedule.i <- cbind(i,matrix(unlist(strsplit(raw.i,"@")),ncol=2,byrow=T))
    }
    colnames(schedule.i) <- c("Week","Away","Home")
    schedule <- rbind(schedule,schedule.i)          
  }
  
  y <- as.numeric(y)
  X <- makeX(schedule)
  schedule <- as.data.frame(schedule)
  schedule$Week <- as.numeric(schedule$Week)
  
  return(list(X=X[1:length(y),,drop=F],
              y=y,
              schedule=schedule))
}
