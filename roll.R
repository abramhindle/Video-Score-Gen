v<-read.table("moments")
library(zoo)
x <- c()

ourRoll <- function(z,n) {
  v <- rollmean(z, na.pad=1, n)
  for (i in c(1:length(v))[!is.finite(v)]) { v[i] <- z[i] }
  v
}

x$RollV1N50 <- ourRoll(v$V1,50)
x$RollV1N25 <- ourRoll(v$V1,25)
x$RollV1N5 <- ourRoll(v$V1,5)
x$RollV2N50 <- ourRoll(v$V2,50)
x$RollV2N25 <- ourRoll(v$V2,25)
x$RollV2N5 <- ourRoll(v$V2,5)
x$RollV2N50 <- ourRoll(v$V2,50)
x$RollV2N25 <- ourRoll(v$V2,25)
x$RollV2N5 <- ourRoll(v$V2,5)

write.table(v,file="roll")
