url <- 'http://www.pro-football-reference.com/boxscores/201509130sdg.htm'
Data <- import(url)
bigplays(Data)
bigplays(Data, type='w')

drives(Data)
