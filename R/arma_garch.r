################ code for question 1(a)
library(tseries)
library(fGarch)
merck <- read.table("m-mrk4608.txt",header=T)
log.merck <- log(merck[,2]+1) ## simple return to log return
plot(log.merck,type="l")
acf(log.merck)
Box.test(log.merck,type="Ljung",lag=12)
pacf(log.merck)
source("EACF.r")
EACF(log.merck,p=13,q=13)
fit1 <- arima(log.merck,order=c(0,0,8),fixed=c(NA,0,0,NA,0,0,0,NA,NA))
acf(fit1$residual)
pacf(fit1$residual)
Box.test(fit1$residual,type="Ljung",fitdf=3,lag=12)

################ code for question 1(b)
residual.squared <- fit1$residual^2
Box.test(residual.squared,lag=6,type="Ljung",fitdf=3)
Box.test(residual.squared,lag=12,type="Ljung",fitdf=3)
################ code for question 1(c)
pacf(residual.squared)
m1 = garchFit(~arma(3,4)+garch(3,0),data=log.merck,trace=F)
m1
m1t = garchFit(~arma(3,4)+garch(3,0),data=log.merck,cond.dist="std",trace=F)
m1t
m2 = garchFit(~arma(1,3)+garch(3,0),data=log.merck,cond.dist="norm",trace=F)
m2
summary(m2)
