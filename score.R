library(zoo)
library(corrplot)
v<-read.csv("video.csv",header=TRUE,sep=",")

myCorPlot <- function(v,order="PCA",method="spearman") {
  corrr <- cor(v,method=method)
  corrr[!is.finite(corrr)] <- 0
  corrplot(corrr,order=order)
}



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

cs11 <- function(instr,when,dur,p4,p5,p6,p7,p8,p9,p10,p11) {
  write(sprintf("i%s %f %f %f %f %f %f %f %f %f %f", as.character(instr), when,dur,p4,p5,p6,p7,p8,p9,p10,p11),file="")
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
  x$ss <- ourScale(v$std)

  x$sd <- v$stddiff
  x$sds <- ourScale(x$sd)
  x$scale <- 1-lowess(.1 + 0.9*ourScale(ourRoll(x$md,180,align="left")),f=1/3)$y
  x$pitch <- 1-lowess(ourScale(ourRollMax(v$central6,100)),f=1/10)$y - 0.1*x$ss
  x$roll50Hu <- ourScale( ourRoll( v$hu0,50 ) )
  x$rollMax50Hu <- ourScale( ourRollMax( v$hu0,50 ) )
  
  x$hus       <- ourScale( v$hu0 )
  x$sinePitch <- 20+1000*(1-x$sds)#x$rollMax50Hu
  x$sineAmp <- 800*x$mds + 100
 
  x$contSineAmp <- 4000*lowess(ourScale(v$stddiff),f=2/3)$y
  x$contSineFreq <- 40+200*lowess(ourScale(v$central5+v$central6),f=1/10)$y
  x$fmAmp <- 500*ourScale(lowess(v$red7+v$green7+v$blue7,f=1/10)$y)

  ourColorScale <- function(x) {
    1 - ourScale(x)
  }
  x$scaleRed0 <- ourColorScale(v$red0)
  x$scaleRed1 <- ourColorScale(v$red1)
  x$scaleRed2 <- ourColorScale(v$red2)
  x$scaleRed3 <- ourColorScale(v$red3)
  x$scaleRed4 <- ourColorScale(v$red4)
  x$scaleRed5 <- ourColorScale(v$red5)
  x$scaleRed6 <- ourColorScale(v$red6)
  x$scaleRed7 <- ourColorScale(v$red7)

  x$scaleBlue0 <- ourColorScale(v$blue0)
  x$scaleBlue1 <- ourColorScale(v$blue1)
  x$scaleBlue2 <- ourColorScale(v$blue2)
  x$scaleBlue3 <- ourColorScale(v$blue3)
  x$scaleBlue4 <- ourColorScale(v$blue4)
  x$scaleBlue5 <- ourColorScale(v$blue5)
  x$scaleBlue6 <- ourColorScale(v$blue6)
  x$scaleBlue7 <- ourColorScale(v$blue7)

  x$scaleGreen0 <- ourColorScale(v$green0)
  x$scaleGreen1 <- ourColorScale(v$green1)
  x$scaleGreen2 <- ourColorScale(v$green2)
  x$scaleGreen3 <- ourColorScale(v$green3)
  x$scaleGreen4 <- ourColorScale(v$green4)
  x$scaleGreen5 <- ourColorScale(v$green5)
  x$scaleGreen6 <- ourColorScale(v$green6)
  x$scaleGreen7 <- ourColorScale(v$green7)

  

  
  for (t in c(1:len)) {
    
    cs4("\"Scale\"",x$time[t],0,x$scale[t])
    cs4("\"Pitch\"",x$time[t],0,x$pitch[t] )
    cs4("\"FMAmp\"",x$time[t],0,x$fmAmp[t] )
    #
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], x$sinePitch[t])
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], 1.1*x$sinePitch[t])
    cs5("\"Sine\"",jt(x$time[t]),2/30.0,x$sineAmp[t], 0.95*x$sinePitch[t])
    #
    cs4("\"ContSineFreq\"",x$time[t],0,x$contSineFreq[t])
    cs4("\"ContSineAmp\"" ,x$time[t],0,x$contSineAmp[t])

    cs11("\"RedSet\"",x$time[t],0,
         x$scaleRed0[t],
         x$scaleRed1[t],
         x$scaleRed2[t],
         x$scaleRed3[t],
         x$scaleRed4[t],
         x$scaleRed5[t],
         x$scaleRed6[t],
         x$scaleRed7[t])
    cs11("\"BlueSet\"",x$time[t],0,
         x$scaleBlue0[t],
         x$scaleBlue1[t],
         x$scaleBlue2[t],
         x$scaleBlue3[t],
         x$scaleBlue4[t],
         x$scaleBlue5[t],
         x$scaleBlue6[t],
         x$scaleBlue7[t])
    cs11("\"GreenSet\"",x$time[t],0,
         x$scaleGreen0[t],
         x$scaleGreen1[t],
         x$scaleGreen2[t],
         x$scaleGreen3[t],
         x$scaleGreen4[t],
         x$scaleGreen5[t],
         x$scaleGreen6[t],
         x$scaleGreen7[t])
    
  }
}
fmScore()
