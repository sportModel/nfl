# Requires 1 argument: year
~/spt/nfl/scripts/nflget 2012
cd ~/spt/nfl
R CMD BATCH --no-save --no-restore predict-current-week.R .predict-current-week.R
cd ~/spt/web/football
buildHTML -j
cd ../bin
./nfl
