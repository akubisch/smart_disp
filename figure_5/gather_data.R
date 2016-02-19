info_sig0 <- numeric()
info_sig12.5 <- numeric()
info_sig25 <- numeric()

trade <- seq(0,0.1,len=51)
reps <- 5


for (i in 1:length(trade)) {

  i_T <- 0
  ct <- 0
  cs <- 0
  mn <- 0
  for (j in 1:reps) {
    sig0 <- read.table(paste("TAe_sig0/results/output_",i,"_rep",j,".txt",sep=""),header=T)
    i_T <- i_T + sig0$mean_info[sig0$t==max(sig0$t)]
    ct <- ct + sig0$tr1[sig0$t==max(sig0$t)]
    cs <- cs + sig0$tr2[sig0$t==max(sig0$t)]
    mn <- mn + sig0$meta_n[sig0$t==max(sig0$t)]
  }
  info_sig0[i] <- i_T / reps

  i_T <- 0
  ct <- 0
  cs <- 0
  mn <- 0
  for (j in 1:reps) {
    sig12.5 <- read.table(paste("TAe_sig12.5/results/output_",i,"_rep",j,".txt",sep=""),header=T)
    i_T <- i_T + sig12.5$mean_info[sig12.5$t==max(sig12.5$t)]
    ct <- ct + sig12.5$tr1[sig12.5$t==max(sig12.5$t)]
    cs <- cs + sig12.5$tr2[sig12.5$t==max(sig12.5$t)]
    mn <- mn + sig12.5$meta_n[sig12.5$t==max(sig12.5$t)]
  }
  info_sig12.5[i] <- i_T / reps

  i_T <- 0
  ct <- 0
  cs <- 0
  mn <- 0
  for (j in 1:reps) {
    sig25 <- read.table(paste("TAe_sig25/results/output_",i,"_rep",j,".txt",sep=""),header=T)
    i_T <- i_T + sig25$mean_info[sig25$t==max(sig25$t)]
    ct <- ct + sig25$tr1[sig25$t==max(sig25$t)]
    cs <- cs + sig25$tr2[sig25$t==max(sig25$t)]
    mn <- mn + sig25$meta_n[sig25$t==max(sig25$t)]
  }
  info_sig25[i] <- i_T / reps

}

info <- matrix(ncol=3,nrow=length(info_sig0))

info[,1] <- info_sig0
info[,2] <- info_sig12.5
info[,3] <- info_sig25

save(info,file="info_data.RData")
