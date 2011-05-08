library(zoo)
v<-read.csv("love",header=TRUE,sep=",")

x <- c()

ourRoll <- function(z,n) {
  v <- rollmean(z, na.pad=1, n)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

ourScale <- function(x) {
  mmin  <- min(x)
  mmax  <- max(x)
  (x - mmin)/(mmax-mmin)
}

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
for(i in c(1:length(x$time))) {
  cs5(1,x$time[i],fps,1000,x$features[i])
}
