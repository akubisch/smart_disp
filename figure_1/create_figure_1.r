disp_prob <- function(C,Cth,gamma) { # defines the dispersal function
  d <- rep(0,length(C))
  d[C>Cth] <- 1 - (Cth*(1-gamma))/(C[C>Cth]-Cth*gamma)
  return(d)
}

densx <- seq(0,3,len=100) # a vector of population densities
Cth <- 1.1 # defining a threshold density value

x11()
par(mar=c(.5,.5,.5,.5),oma=c(5,5,1,1),lwd=2.5)
plot(1,1,type="n",bty="l",xlab="",xaxt="n",yaxt="n",
     ylab="",cex.lab=1.75,cex.axis=1.75,xlim=c(0,3),ylim=c(0,1),xaxs="i",yaxs="i")
mtext(side=1,at=1.5,line=4,cex=1.75,expression(paste("Estimated population density ",N[i]^E/bar(K))))
mtext(side=2,at=0.5,line=3,expression(paste("Emigration probability ",d[TAE],sep="")),cex=1.75)
axis(side=1,at=c(0,1,2,3),cex.axis=1.75)
axis(side=2,at=c(0.2,0.4,0.6,0.8,1),cex.axis=1.75)
#curve(disp_prob(x,1.1,0),add=T,lwd=2)
lines(disp_prob(densx,Cth,0)~densx,lty="dashed"); text(2.5,0.475,expression(gamma==0),cex=1.5)
lines(disp_prob(densx,Cth,0.5)~densx); text(2.25,0.6,expression(gamma==0.5),cex=1.5)
lines(disp_prob(densx,Cth,0.9)~densx); text(1.85,0.8,expression(gamma==0.9),cex=1.5)
lines(disp_prob(densx,Cth,0.99)~densx); text(1.5,0.9,expression(gamma==0.99),cex=1.5)

dev.copy2eps(file="figure_1.eps",title="Poethke et al. | Figure 1")
