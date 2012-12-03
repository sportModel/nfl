# Requires 1 argument: year
/home/pbreheny/sports/nfl/scripts/nflget.sh 2010
R CMD BATCH --no-save --no-restore /home/pbreheny/sports/nfl/predict-current-week.R
cd /home/pbreheny/sports/web/football
R CMD BATCH --no-save --no-restore src/x.R
mv x.Rout .log.Rout
cp src/style.css compiled/style.css
echo "\$ footballupload" | ftp -i 
