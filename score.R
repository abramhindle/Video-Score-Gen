library(zoo)
v<-read.csv("video.csv",header=TRUE,sep=",")




ourRoll <- function(z,n,align="center") {
  v <- rollmean(z, na.pad=1, n, align=align)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

ourRollMax <- function(z,n,align="center") {
  v <- rollmax(z, n, na.pad=1, align=align)
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


cs4 <- function(instr,when,dur,p4) {
  write(sprintf("i%s %f %f %f", as.character(instr), when,dur,p4),file="")
}

cs5 <- function(instr,when,dur,p4,p5) {
  write(sprintf("i%s %f %f %f %f", as.character(instr), when,dur,p4,p5),file="")
}

#cs4(1,2,3,4)

# play SIFT
jt <- function(t) {
  t+rnorm(1,mean=0,sd=0.01)[1]
}

originalScore <- function() {
  x <- c()
  x$roll15red1     <- ourScale( ourRollMax( v$red1,15 ) )
  x$roll50Hu <- ourScale( ourRoll( v$hu0,50 ) )
  x$hu       <- ourScale( v$hu0 )
  x$central6 <- ourScale(v$central6)
  x$roll50Central <- ourRoll( x$central6, 50)
                                        #x$features  <- v$nsift
  x$frame     <- v$frame
  x$time      <- x$frame / 30
  len <- length(x$time)
  
  fps = 1/30.0
  
  
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
}

fmScore <- function() {

  x <- c()
  x$frame <- v$frame
  x$time      <- x$frame / 30
  len <- length(x$time)
  x$m <- v$mean
  x$md <- v$meandiff
  x$mds <- ourScale(x$md)
  x$s <- v$std
  x$sd <- v$stddiff
  x$sds <- ourScale(x$sd)
  x$scale <- lowess(.1 + 0.9*ourScale(ourRoll(x$md,180,align="left")),f=1/3)$y
  x$pitch <- lowess(ourScale(ourRollMax(v$central6,100)),f=1/10)$y
  x$roll50Hu <- ourScale( ourRoll( v$hu0,50 ) )
  x$rollMax50Hu <- ourScale( ourRollMax( v$hu0,50 ) )
  
  x$hus       <- ourScale( v$hu0 )
  x$sinePitch <- 20+1000*(1-x$sds)#x$rollMax50Hu
  x$sineAmp <- 800*x$mds + 100
  
  for (t in c(1:len)) {
    cs4("\"Scale\"",x$time[t],0,x$scale[t])
  }
  for (t in c(1:len)) {
    cs4("\"Pitch\"",x$time[t],0,x$pitch[t])
  }
  for (t in c(1:len)) {
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], x$sinePitch[t])
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], 1.1*x$sinePitch[t])
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], 0.95*x$sinePitch[t])

  }

}
fmScore()
