library(zoo)
v<-read.csv("video.csv",header=TRUE,sep=",")

x <- c()

ourRoll <- function(z,n,align="center") {
  v <- rollmean(z, na.pad=1, n, align=align)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

ourRollMax <- function(z,n) {
  v <- rollmax(z, na.pad=1, n)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

ourRollApply <- function(f,z,n) {
  v <- rollapply(z, n, f, na.pad=1)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

ourScale <- function(x) {
  mmin  <- min(x)
  mmax  <- max(x)
  (x - mmin)/(mmax-mmin)
}

x$roll15red1     <- ourScale( ourRollMax( v$red1,15 ) )
x$roll50Hu <- ourScale( ourRoll( v$hu0,50 ) )
x$hu       <- ourScale( v$hu0 )
x$central6 <- ourScale(v$central6)
x$roll50Central <- ourRoll( x$central6, 50)
x$features  <- v$nsift
x$frame     <- v$frame
x$time      <- x$frame / 30

fps = 1/30.0

cs4 <- function(instr,when,dur,p4) {
  write(sprintf("i%d %f %f %f", instr, when,dur,p4),file="")
}

cs5 <- function(instr,when,dur,p4,p5) {
  write(sprintf("i%d %f %f %f %f", instr, when,dur,p4,p5),file="")
}

#cs4(1,2,3,4)

# play SIFT
len <- length(x$time)
jt <- function(t) {
  t+rnorm(1,mean=0,sd=0.01)[1]
}

for(i in sample(c(1:len),round(.3*len))) {
  cs5(1,t(x$time[i]),3*fps,1000,20+200*x$roll50Central[i])
  cs5(1,t(x$time[i]),3*fps,1000,20+210*x$roll50Central[i])
  cs5(1,t(x$time[i]),3*fps,1000,20+220*x$roll50Central[i])
  cs5(1,t(x$time[i]),3*fps,1000,20+230*x$roll50Central[i])
  cs5(1,t(x$time[i]),3*fps,1000,20+240*x$roll50Central[i])
}
for(i in sample(c(1:len),round(.5*len))) {
  cs5(2,t(x$time[i]),fps,1000,20+200*x$hu[i])
}
for(i in c(1:len)) {
  cs5(3,t(x$time[i]),fps,500,20+200*x$roll50hu[i])
}
times <- c(1:len)
for(i in c(1:floor(len/15))) {
  cs5(2,x$time[i*15],15*fps,500,20+20*x$roll15red1[i*15])
}
