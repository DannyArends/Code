#
# gnet.R
#
# copyright (c) 2010-2012 - GBIC/Johannes Lab: Pariya Behrouzi, Danny Arends
# last modified Oct, 2012
# first written Oct, 2012
# 
# gnet
#

gnet = function(y,n.rho=10,em.iter=10,gibbs.iter=1000){
  begTime <- Sys.time()
  cat("Starting\n")
  p = ncol(y)
  rho = seq(0.01,.9,length=n.rho)
  cutoffs = calculate.cutoffs(y)
  lower.upper = calculate.lower.upper(y,cutoffs)
  cat("Cut-offs calculated\n")
  results = list(Theta=list(),loglik=NULL,rho=rho, begTime=begTime, endTime=NULL, runTime=NULL )
  
  for (i in 1:n.rho){ #PARRALEL  20 x NODES
    cat("Starting Rho", i,"\n")
    sigma.ini = diag(rep(1,p))
    for (j in 1:em.iter){
      cat("Start of itteration ",j,"\n")
      if(j==1) load("")
      R = calculate.R(y,sigma.ini,lower.upper,gibbs.iter)
      R.gl = glasso(R,rho[i],penalize.diagonal=FALSE)
      sigma.ini = R.gl$w
      save(sigma.ini)
      cat("Itteration ",j," completed\n")
    }
    results$Theta[[i]] = Matrix(R.gl$wi)
    results$loglik = c(results$loglik,R.gl$loglik)
    results$endTime= Sys.time()
    results$runTime= results$endTime - begTime    
    cat("Rho ",i," completed\n")
  }
  return(results)
}