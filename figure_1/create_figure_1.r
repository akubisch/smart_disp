library(ggplot2)
library(tikzDevice)

disp_prob = function(C,Cth,gamma) { # defines the dispersal function
  d = rep(0,length(C))
  d[C>Cth] = 1 - (Cth*(1-gamma))/(C[C>Cth]-Cth*gamma)
  return(d)
}

densx = seq(0,3,len=100) # a vector of population densities
Cth = 1.1 # defining a threshold density value
gammas = c(0,0.5,0.9,0.99)

d = numeric()
dens = numeric()
gam = numeric()

for (g in gammas) {
  d = c(d,disp_prob(densx,Cth,g))
  dens = c(dens,densx)
  gam = c(gam,rep(g,length(densx)))
}

res = data.frame(dens=dens,disp=d,gamma=factor(gam))

gamlab = c(paste(expression(gamma==0)),
           paste(expression(gamma==0.5)),
           paste(expression(gamma==0.9)),
           paste(expression(gamma==0.99)))

x11()

ggplot(res,aes(x=dens,y=disp,colour=gamma, group=gamma, linetype=gamma)) + geom_line(size=1.25) +
  theme_bw(base_size=25) +
  scale_color_grey() +
  theme(legend.position="none", text=element_text(size=25),axis.line.x=element_line(color="black"),axis.line.y=element_line(color="black")) +
  ylab(expression(paste("Emigration probability ", italic(d)[TAE]))) +
  xlab(expression(paste("Estimated population density ",italic(N)[i]^E/bar(italic(K))))) +
  annotate("text",x=c(2.5,2.3,1.9,1.55),y=c(0.475,0.6,0.8,0.9),parse=T,label=gamlab, size=7)

dev.copy2eps(file="figure_1.eps",title="Poethke et al. | Figure 1")
