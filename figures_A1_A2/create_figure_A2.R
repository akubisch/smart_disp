### DDE FUNCTIONS

LENGTHI <- 100

dde_tae <- function(para) {
  c <- seq(0,2,len=LENGTHI)
  d <- 1.0 - para[1] * (1.0 - para[2])/(c - para[1] * para[2])
  d[c<para[1]] <- 0
  d[d<0] <- 0
  d[d>1] <- 1
  
  d[d<0] <- 0
  d[d>1] <- 1
  
  return(d)
}

dde_s <- function(para) {
  c <- seq(0,2,len=LENGTHI)
  d <- para[3]/(1.0+exp(-para[1]*(c-para[2])))
  
  d[d<0] <- 0
  d[d>1] <- 1
  
  return(d)
}

dde_sm <- function(para) {
  c <- seq(0,2,len=LENGTHI)
  d <- 1.0/(1.0+exp(-para[1]*(c-para[2])))-para[3]
  
  d[d<0] <- 0
  d[d>1] <- 1
  
  return(d)
}


### PLOT

x11(width=7,height=3.5)
par(mar=c(1,1,1,1),oma=c(5,8,5,0),mfrow=c(1,3),bty="l",cex.lab=1.75,cex.axis=2.25,lwd=2.5)

### standard sigmoid

#I = 0.2

S <- as.matrix(read.table("sig25_i02_S/populations/pop_5.in"))
Sm <- as.matrix(read.table("sig25_i02_Sm/populations/pop_5.in"))
TAe <- as.matrix(read.table("sig25_i02_Sm/populations/pop_4.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

ta <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")

s <- dde_sm(apply(Sm,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dashed")

#I = 0.5

S <- as.matrix(read.table("sig25_i05_S/populations/pop_5.in"))
Sm <- as.matrix(read.table("sig25_i05_Sm/populations/pop_5.in"))
TAe <- as.matrix(read.table("sig25_i05_Sm/populations/pop_4.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
#axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

ta <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")

s <- dde_sm(apply(Sm,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dashed")

#I = 0.8

S <- as.matrix(read.table("sig25_i08_S/populations/pop_5.in"))
Sm <- as.matrix(read.table("sig25_i08_Sm/populations/pop_5.in"))
TAe <- as.matrix(read.table("sig25_i08_Sm/populations/pop_4.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
#axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

ta <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")

s <- dde_sm(apply(Sm,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dashed")


mtext(side=2,outer=T,line=4.5,cex=1.75,expression(paste("Mean emigration")))
mtext(side=2,outer=T,line=1.75,cex=1.75,expression(paste("probability ",italic(d))))
mtext(side=3,at=0.175,line=2,cex=2,outer=T,expression(paste(italic(I)==0.2)))
mtext(side=3,at=0.5,line=2,cex=2,outer=T,expression(paste(italic(I)==0.5)))
mtext(side=3,at=0.825,line=2,cex=2,outer=T,expression(paste(italic(I)==0.8)))
mtext(side=1,outer=T,line=3.5,cex=1.75,expression(paste("Normalized population density ",italic(N)[i]/bar(italic(K)))))

dev.copy2eps(file="figure_A2.eps",title="Poethke et al. | Figure A2")






