
R version 3.0.2 (2013-09-25) -- "Frisbee Sailing"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: x86_64-unknown-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

Loading required package: xtable
Loading required package: MASS
Loading required package: graphics
Loading required package: mvtnorm
Loading required package: XML

Attaching package: ‘XML’

The following object is masked from ‘package:breheny’:

    addNode

Loading required package: html
Loading required package: visreg
> ## Setup
> nfl.par <- setDefaultPar(2013)
> nfl <- formatData()
> load(file=paste("data/",nfl.par@year,"/prior.RData",sep=""))
> 
> ## Fit
> output <- Gibbs(nfl$X, nfl$y, prior=prior, N=10000)
Loading required package: R2jags
Loading required package: rjags
Loading required package: coda
Linked to JAGS 3.1.0
Loaded modules: basemod,bugs

Attaching package: ‘R2jags’

The following object is masked from ‘package:coda’:

    traceplot

module glm loaded
Compiling model graph
   Resolving undeclared variables
   Allocating nodes
   Graph Size: 39895

Initializing model

> fit <- list(mu=apply(output,2,mean), sigma=cov(output), n=nrow(nfl$X))
> week <- nfl$schedule$Week[length(nfl$y)/2]
> save(fit, file=paste("data/", nfl.par@year, "/fit", week, ".RData",sep=""))
> 
> ## Prediction and summarization
> teamPar(week)
> predictGames(week, rbind(nfl$X, nfl$XX))
> 
> ## Update website
> updateWebsite(nfl)
> 
> proc.time()
   user  system elapsed 
 19.069   0.080  19.159 
