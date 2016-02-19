load("info_data.RData") # contains a matrix called 'info'-> the columns are sigma=0,12.5,25, respectively
trade <- seq(0,0.1,len=51)

x11(width=6,height=9)

dfs <- 8
cexlab <- 1.75
axcex <- 1.5

par(mfrow=c(2,1),mar=c(.5,5,2,.5),oma=c(4.5,.1,0,0))

plot(1,1,type="n",bty="l",xlab="rel. decrease in growth rate", ylab=expression(paste("Information accuracy ",I[j])), xlim=c(0,0.1),ylim=c(0,1),yaxt="n",cex.lab=cexlab,cex.axis=axcex,xaxt="n")
axis(side=2,at=c(0,0.5,1),labels=c("0","0.5","1"),cex.axis=axcex)
lines(info[,1]~trade,type="p",lwd=2,pch=15,col=gray(0.75))
lines(smooth.spline(info[,1]~trade,df=dfs),lwd=2,,col=gray(0.75),lty="dashed")
lines(info[,2]~trade,type="p",lwd=2,pch=17,col=gray(0.5))
lines(smooth.spline(info[,2]~trade,df=dfs),lwd=2,,col=gray(0.5),lty="dotdash")
lines(info[,3]~trade,type="p",lwd=2,pch=16,col=gray(0))
lines(smooth.spline(info[,3]~trade,df=dfs),lwd=2,,col=gray(0),lty="solid")
text(0,par("usr")[[4]]*1.075,"(a)",cex=1.5,xpd=T)

legend("topright",pch=c(15,17,16),lwd=rep(2,4),
       col=gray(c(.75,.5,0)),
       lty=c("dashed","dotdash","solid"),
       c(expression(sigma==0),expression(sigma==12.5),expression(sigma==25)
       ),bty="n",cex=1.5)


plot(1,1,type="n",bty="l",xlab="", ylab=expression(paste("Investment ",tau %.% I[j])), xlim=c(0,0.1),ylim=c(0,0.012),yaxt="n",cex.lab=cexlab,cex.axis=axcex)
axis(side=2,at=c(0,0.005,0.01),label=c("0","0.005","0.01"),cex.axis=axcex)
lines(info[,1]*trade~trade,type="p",lwd=2,pch=15,col=gray(0.75))
lines(smooth.spline(info[,1]*trade~trade,df=dfs),lwd=2,col=gray(0.75),lty="dashed")
lines(info[,2]*trade~trade,type="p",lwd=2,pch=17,col=gray(0.5))
lines(smooth.spline(info[,2]*trade~trade,df=dfs),lwd=2,col=gray(0.5),lty="dotdash")
lines(info[,3]*trade~trade,type="p",lwd=2,pch=16,col=gray(0))
lines(smooth.spline(info[,3]*trade~trade,df=dfs),lwd=2,col=gray(0),lty="solid")
text(0,par("usr")[[4]]*1.075,"(b)",cex=1.5,xpd=T)

title(xlab=expression(paste("Cost of information ",tau)),outer=T,cex.lab=1.25,cex.lab=cexlab)

dev.copy2eps(file="figure_5.eps",title="Poethke et al. | Figure 5")