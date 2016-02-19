x11(width=10,height=10)

axcex <- 2.25
par(mfrow=c(3,3),oma=c(5,10,6,1),mar=c(4,.5,.5,2))

#sig0, i02
data <- read.table("sig0_i02/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
axis(side=2,at=c(0,0.25,0.5,0.75,1),labels=c("0","","0.5","","1"),cex.axis=axcex)
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")

#sig0, i05
data <- read.table("sig0_i05/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")



#sig0, i08
data <- read.table("sig0_i08/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")


#sig125, i02
data <- read.table("sig125_i02/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
axis(side=2,at=c(0,0.25,0.5,0.75,1),labels=c("0","","0.5","","1"),cex.axis=axcex)
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")


#sig125, i05
data <- read.table("sig125_i05/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")



#sig125, i08
data <- read.table("sig125_i08/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")



#sig25, i02
data <- read.table("sig25_i02/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
axis(side=2,at=c(0,0.25,0.5,0.75,1),labels=c("0","","0.5","","1"),cex.axis=axcex)
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")

text(1,-0.15,expression(paste(T[A])),srt=90,xpd=T,cex=2.5)
text(2,-0.15,expression(paste(T[AE])),srt=90,xpd=T,cex=2.5)
text(3,-0.15,expression(paste(T[L])),srt=90,xpd=T,cex=2.5)
text(4,-0.15,expression(paste(S)),srt=90,xpd=T,cex=2.5)


#sig25, i05
data <- read.table("sig25_i05/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")

text(1,-0.15,expression(paste(T[A])),srt=90,xpd=T,cex=2.5)
text(2,-0.15,expression(paste(T[AE])),srt=90,xpd=T,cex=2.5)
text(3,-0.15,expression(paste(T[L])),srt=90,xpd=T,cex=2.5)
text(4,-0.15,expression(paste(S)),srt=90,xpd=T,cex=2.5)


#sig25, i08
data <- read.table("sig25_i08/data/output.txt",header=T)
x <- data$frac_s1
y <- data$frac_draw

# in the following we calculate the total fraction of won competitions (*1/3, because every strategy participated in 3 competitions)
wins_TL  <- 1/3 * ( sum(x[1:3]) )
wins_TA  <- 1/3 * ( 1-x[1]-y[1] + sum(x[4:5]) )
wins_TAE <- 1/3 * ( 1-x[2]-y[2] + 1-x[4]-y[4] + x[6] )
wins_S   <- 1/3 * ( 1-x[3]-y[3] + 1-x[5]-y[5] + 1-x[6]-y[6] )

draws_TL  <- 1/3 * ( y[1] + y[2] + y[3] )
draws_TA  <- 1/3 * ( y[1] + y[4] + y[5] )
draws_TAE <- 1/3 * ( y[2] + y[4] + y[6] )
draws_S   <- 1/3 * ( y[3] + y[5] + y[6] )

xses_win <- 1:4
plot(1,1,type="n",bty="l",ylim=c(0.038,1),
     xlim=c(0.5,4.5),xlab="",ylab="",xaxt="n",xaxs="i",
     cex.axis=axcex,yaxt="n")
#segments(xses_win,rep(-1,4),xses_win,c(wins_TL,wins_TA,wins_TAE,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,rep(-1,4),xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),lend=1,lwd=20,col="grey25")
segments(xses_win,c(wins_TA,wins_TAE,wins_TL,wins_S),xses_win,c(wins_TA+draws_TA,wins_TAE+draws_TAE,wins_TL+draws_TL,wins_S+draws_S),lend=1,lwd=20,col="grey75")

text(1,-0.15,expression(paste(T[A])),srt=90,xpd=T,cex=2.5)
text(2,-0.15,expression(paste(T[AE])),srt=90,xpd=T,cex=2.5)
text(3,-0.15,expression(paste(T[L])),srt=90,xpd=T,cex=2.5)
text(4,-0.15,expression(paste(S)),srt=90,xpd=T,cex=2.5)

mtext(at=0.5,side=1,line=2,outer=T,cex=2,"Decision rule")
mtext(at=0.2,side=2,line=6.5,outer=T,cex=2,expression(sigma==25))
mtext(at=0.55,side=2,line=6.5,outer=T,cex=2,expression(sigma==12.5))
mtext(at=0.875,side=2,line=6.5,outer=T,cex=2,expression(sigma==0))
mtext(at=0.55,side=2,line=3,outer=T,cex=2,"Fraction won/draw")
mtext(at=0.485,side=3,line=2,outer=T,"I = 0.5",cex=2)
mtext(at=0.825,side=3,line=2,outer=T,"I = 0.8",cex=2)
mtext(at=0.15,side=3,line=2,outer=T,"I = 0.2",cex=2)

dev.copy2eps(file="figure_3.eps",title="Poethke et al. | Figure 3")
