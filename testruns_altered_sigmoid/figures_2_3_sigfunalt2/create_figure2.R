### DDE FUNCTIONS

LENGTHI <- 100

dde_tl <- function(para) {
  c <- seq(0,2,len=LENGTHI)
  d <- para[2]*c+para[1]
  
  d[d<0] <- 0
  d[d>1] <- 1
  
  return(d)
}

dde_ta <- function(para) {
  c <- seq(0,2,len=LENGTHI)
  d <- 1.0 - para[1]/c
  d[c<para[1]] <- 0
  
  d[d<0] <- 0
  d[d>1] <- 1
  
  return(d)
}

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


### PLOT

x11(width=9,height=9)
par(mar=c(1,1,1,1),oma=c(5,8,5,0),mfrow=c(3,3),bty="l",cex.lab=1.75,cex.axis=2.25,lwd=2.5)


### sigma = 0

#I = 0.2

TL <- as.matrix(read.table("sig0_i02/populations/pop_2.in"))
TA <- as.matrix(read.table("sig0_i02/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig0_i02/populations/pop_4.in"))
S <- as.matrix(read.table("sig0_i02/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")
axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.5

TL <- as.matrix(read.table("sig0_i05/populations/pop_2.in"))
TA <- as.matrix(read.table("sig0_i05/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig0_i05/populations/pop_4.in"))
S <- as.matrix(read.table("sig0_i05/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.8

TL <- as.matrix(read.table("sig0_i08/populations/pop_2.in"))
TA <- as.matrix(read.table("sig0_i08/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig0_i08/populations/pop_4.in"))
S <- as.matrix(read.table("sig0_i08/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")




### sigma = 12.5

#I = 0.2

TL <- as.matrix(read.table("sig125_i02/populations/pop_2.in"))
TA <- as.matrix(read.table("sig125_i02/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig125_i02/populations/pop_4.in"))
S <- as.matrix(read.table("sig125_i02/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")
axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.5

TL <- as.matrix(read.table("sig125_i05/populations/pop_2.in"))
TA <- as.matrix(read.table("sig125_i05/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig125_i05/populations/pop_4.in"))
S <- as.matrix(read.table("sig125_i05/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.8

TL <- as.matrix(read.table("sig125_i08/populations/pop_2.in"))
TA <- as.matrix(read.table("sig125_i08/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig125_i08/populations/pop_4.in"))
S <- as.matrix(read.table("sig125_i08/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),xaxt="n",yaxt="n")

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")






### sigma = 25

#I = 0.2

TL <- as.matrix(read.table("sig25_i02/populations/pop_2.in"))
TA <- as.matrix(read.table("sig25_i02/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig25_i02/populations/pop_4.in"))
S <- as.matrix(read.table("sig25_i02/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
axis(side=2,at=c(0,.25,.5,.75,1),labels=c("0","","0.5","","1"))
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.5

TL <- as.matrix(read.table("sig25_i05/populations/pop_2.in"))
TA <- as.matrix(read.table("sig25_i05/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig25_i05/populations/pop_4.in"))
S <- as.matrix(read.table("sig25_i05/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")



#I = 0.8

TL <- as.matrix(read.table("sig25_i08/populations/pop_2.in"))
TA <- as.matrix(read.table("sig25_i08/populations/pop_3.in"))
TAe <- as.matrix(read.table("sig25_i08/populations/pop_4.in"))
S <- as.matrix(read.table("sig25_i08/populations/pop_5.in"))

plot(1,1,type="n",xlim=c(0,2),ylim=c(0,1),yaxt="n",xaxt="n")
axis(side=1,at=c(0,.5,1,1.5,2),labels=c("0","","1","","2"),padj=0.3)

tl <- dde_tl(apply(TL,2,mean))
lines(seq(0,2,len=LENGTHI),tl,col="black",lty="dashed")

ta <- dde_ta(apply(TA,2,mean))
lines(seq(0,2,len=LENGTHI),ta,col="black",lwd=1)

tae <- dde_tae(apply(TAe,2,mean))
lines(seq(0,2,len=LENGTHI),tae,col="black")

s <- dde_s(apply(S,2,mean))
lines(seq(0,2,len=LENGTHI),s,col="black",lty="dotted")


mtext(side=2,outer=T,line=2.75,cex=1.75,"Mean emigration probability d")
mtext(side=2,outer=T,line=5.5,cex=2,at=0.85,expression(paste(sigma==0)))
mtext(side=2,outer=T,line=5.5,cex=2,at=0.5,expression(paste(sigma==12.5)))
mtext(side=2,outer=T,line=5.5,cex=2,at=0.15,expression(paste(sigma==25)))
mtext(side=3,at=0.175,line=2,cex=2,outer=T,"I=0.2")
mtext(side=3,at=0.5,line=2,cex=2,outer=T,"I=0.5")
mtext(side=3,at=0.825,line=2,cex=2,outer=T,"I=0.8")
mtext(side=1,outer=T,line=3.5,cex=1.75,expression(paste("Normalized population density ",N[i]/bar(K))))

dev.copy2eps(file="figure_2.eps",title="Poethke et al. | Figure 2")






