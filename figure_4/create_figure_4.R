# gather data

emi <- matrix(nrow=20,ncol=3)
cth <- matrix(nrow=20,ncol=3)
gamma <- matrix(nrow=20,ncol=3)

path <- "sigma_0/results/output_"
thresh_t <- 8000
for (i in 1:20) {
  res <- read.table(paste(path,i,"_rep1.txt",sep=""),header=T)
  emi[i,1] <- mean(res$emi[res$t>thresh_t])
  cth[i,1] <- mean(res$mean_cth[res$t>thresh_t])
  gamma[i,1] <- mean(res$mean_gamma[res$t>thresh_t])
}

path <- "sigma_125/results/output_"
thresh_t <- 8000
for (i in 1:20) {
  res <- read.table(paste(path,i,"_rep1.txt",sep=""),header=T)
  emi[i,2] <- mean(res$emi[res$t>thresh_t])
  cth[i,2] <- mean(res$mean_cth[res$t>thresh_t])
  gamma[i,2] <- mean(res$mean_gamma[res$t>thresh_t])
}

path <- "sigma_25/results/output_"
thresh_t <- 8000
for (i in 1:20) {
  res <- read.table(paste(path,i,"_rep1.txt",sep=""),header=T)
  emi[i,3] <- mean(res$emi[res$t>thresh_t])
  cth[i,3] <- mean(res$mean_cth[res$t>thresh_t])
  gamma[i,3] <- mean(res$mean_gamma[res$t>thresh_t])
}

load("emi.RData"); load("cth.RData"); load("gamma.RData")
info <- seq(0.05,1,0.05)

x11(width=5.5,height=9)

axcex <- 2.4
cexi <- 2
lwdi <- 2
dfs <- 5
labcex <- 1.35
pchi <- 1

par(mfrow=c(3,1),mar=c(2,2,2.5,.5),oma=c(5,5,0,0))
plot(emi[2:20,1]~info[2:20],bty="l",cex.axis=axcex,xlab="",ylab="",xaxt="n",cex=cexi,pch=15,ylim=c(0,0.41),col="grey75")
lines(smooth.spline(emi[2:20,1]~info[2:20],df=dfs),lwd=lwdi,col="grey75")
points(emi[2:20,2]~info[2:20],cex=cexi,col="grey60",pch=17)
lines(smooth.spline(emi[2:20,2]~info[2:20],df=dfs),lwd=lwdi,col="grey60")
points(emi[2:20,3]~info[2:20],cex=cexi,pch=16)
lines(smooth.spline(emi[2:20,3]~info[2:20],df=dfs),lwd=lwdi)
mtext(side=3,at=0.1,line=0.5,"(a)",cex=1.25)

plot(cth[2:20,1]~info[2:20],bty="l",cex.axis=axcex,xlab="",ylab="",xaxt="n",cex=cexi,pch=15,ylim=c(0,1.2),col="grey75")
lines(smooth.spline(cth[2:20,1]~info[2:20],df=dfs),lwd=lwdi,col="grey75")
points(cth[2:20,2]~info[2:20],cex=cexi,col="grey60",pch=17)
lines(smooth.spline(cth[2:20,2]~info[2:20],df=dfs),lwd=lwdi,col="grey60")
points(cth[2:20,3]~info[2:20],cex=cexi,pch=16)
lines(smooth.spline(cth[2:20,3]~info[2:20],df=dfs),lwd=lwdi)
mtext(side=3,at=0.1,line=0.5,"(b)",cex=1.25)

plot(gamma[2:20,1]~info[2:20],bty="l",cex.axis=axcex,xlab="",ylab="",xaxt="n",cex=cexi,pch=15,ylim=c(0,1),col="grey75",yaxt="n")
axis(side=2,cex.axis=axcex,at=c(0,.25,.5,.75,1))
lines(smooth.spline(gamma[2:20,1]~info[2:20],df=dfs),lwd=lwdi,col="grey75")
points(gamma[2:20,2]~info[2:20],cex=cexi,col="grey60",pch=17)
lines(smooth.spline(gamma[2:20,2]~info[2:20],df=dfs),lwd=lwdi,col="grey60")
points(gamma[2:20,3]~info[2:20],cex=cexi,pch=16)
lines(smooth.spline(gamma[2:20,3]~info[2:20],df=dfs),lwd=lwdi)
mtext(side=3,at=0.1,line=0.5,"(c)",cex=1.25)

legend("topright",pch=c(15,17,16),lwd=lwdi,col=c("grey75","grey60","black"),c(expression(sigma==0),
                                                                         expression(sigma==12.5),
                                                                         expression(sigma==25)),bty="n",cex=1.75)

axis(side=1,cex.axis=axcex)

mtext(side=1,at=0.5,expression(paste("Information accuracy ",italic(I)[italic(j)])),cex=labcex,outer=T,line=2.5)
mtext(side=2,at=0.825,expression(paste("Emigration probability ", italic(d)[TAE])),cex=labcex,outer=T,line=1.5)
mtext(side=2,at=0.5,expression(paste("Threshold density ",italic(C)[T])),cex=labcex,outer=T,line=1.5)
mtext(side=2,at=0.15,expression(paste("Scaling parameter ",italic(gamma))),cex=labcex,outer=T,line=1.5)

dev.copy2eps(file="figure_4.eps", title="Poethke et al. | Figure 4")
