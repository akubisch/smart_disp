no_exp    <- 20
reps     <- 1

K          <- rep(25,no_exp)
lambda_0   <- rep(2,no_exp)
sigma      <- rep(12.5,no_exp)
disp_mort  <- rep(0.1,no_exp)
ext_prob   <- rep(0,no_exp)
mut_prob   <- rep(0.01,no_exp)
tmax       <- rep(10000,no_exp)
info       <- seq(0,1,len=no_exp)
repli      <- rep(1,no_exp)
strategy      <- rep(4,no_exp)

para.in <- "data/para.in"
program <- "./smart_disp"

if (!file.exists("results/")) {file.create("results/")}

write("simulation package initiated...", file="progress.sim", append=F)

for (e in 1:no_exp) {
  write(paste(" -> starting experiment no.",e,sep=" "),file="progress.sim",append=T)

  for (r in 1:reps) {

    # creating the parameter infile

    write("# K", file=para.in, append=F)
    write(K[e], file=para.in, append=T)

    write("# lambda_0", file=para.in, append=T)
    write(lambda_0[e], file=para.in, append=T)

    write("# sigma", file=para.in, append=T)
    write(sigma[e], file=para.in, append=T)

    write("# disp_mort", file=para.in, append=T)
    write(disp_mort[e], file=para.in, append=T)

    write("# ext", file=para.in, append=T)
    write(ext_prob[e], file=para.in, append=T)

    write("# mut", file=para.in, append=T)
    write(mut_prob[e], file=para.in, append=T)

    write("# tmax", file=para.in, append=T)
    write(tmax[e], file=para.in, append=T)

    write("# info", file=para.in, append=T)
    write(info[e], file=para.in, append=T)

    write("# repli", file=para.in, append=T)
    write(repli[e], file=para.in, append=T)

    write("# strategy", file=para.in, append=T)
    write(strategy[e], file=para.in, append=T)

    # starting the simulation

    write(paste("      replication #",r,sep=" "),file="progress.sim",append=T)

    system(program)

    res_file  <- "data/output.txt"
    new_loc   <- paste("results/output_",e,"_rep",r,".txt",sep="")
    file.copy(res_file,new_loc,overwrite=T)

  }
}

write("done.",file="progress.sim",append=T)
