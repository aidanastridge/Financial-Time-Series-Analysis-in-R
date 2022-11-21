#Packages
library(tidyverse)
library(fpp2)

#Import data
hpi = read_csv('/hpi.csv')
indexts <-ts(hpi$Montreal_Index, start = c(1990, 7), end=c(2017, 2), frequency = 12)
pairts<-ts(hpi$Pair_Count, start = c(1990, 7), end=c(2017, 2), frequency = 12)
stl <- stl(indexts, t.window=12, s.window="periodic",robust=TRUE)

#Time Series Graph
source("https://gist.githubusercontent.com/ellisp/4002241def4e2b360189e58c3f461b4a/raw/e959562be9e7a4d919a9c454d8b1b70cde904ab0/dualplot.R") 
dualplot(x1 = time(pairts), y1 = hpi$Pair_Count,
         x2 = time(indexts), y2 = hpi$Montreal_Index, 
         ylab1 = "", ylab2 = "",legx= NULL, lwd = c(1,2))

hpi$Pair_Count2=hpi$Pair_Count^2
q = lm(Montreal_Index ~ Pair_Count+Pair_Count2, data = hpi)
summary(q)
pacf(resid(q))
checkresiduals(q)

auto.arima(q$residuals)
checkresiduals(Arima(indexts, order=c(2,2,3), seasonal=c(2,0,0), include.constant = FALSE, lambda=0))

#First-order Difference
Diff1<- diff(indexts)
acf(Diff1)
pacf(Diff1)
checkresiduals(Diff1)

#Second-order Difference
Diff2<- diff(Diff1)
acf(Diff2)
pacf(Diff2)
checkresiduals(Diff2)

#Second-order Difference + Log-Transform
lh1<-log(indexts)
dh1<-diff(lh1)
dh2<-diff(dh1)

acf(dh2)
pacf(dh2)

#ARIMA
auto.arima(dh2, trace=TRUE) #ARIMA(2,0,3)(2,0,0)[12]
arima<-Arima(dh2, order=c(2,0,3), seasonal=c(2,0,0), method = "ML",include.constant = FALSE)
checkresiduals(arima)
pacf(arima$residuals)
qqnorm(arima$residuals, col = "blue")
qqline(arima$residuals, col = "red")
tsdiag(arima)

#Regression with ARIMA errors
lp1<-log(pairts)
dp1<-diff(lp1)
dp2<-diff(dp1)

lni = lm(dh2 ~ -1+dp2)
auto.arima(lni$residuals, trace=TRUE) #ARIMA (3,0,1)

rare <- Arima(dh2, xreg=dp2, order=c(3,0,1), method = "ML", include.constant = FALSE)
checkresiduals(rare)
pacf(rare$residuals)
qqnorm(rare$residuals, col = "blue")
qqline(rare$residuals, col = "red")
tsdiag(rare)

#Accuracy
f<-head(indexts,-5)
#ARIMA(2,2,3)(2,0,0)[12] and lambda=0 accounts for the 2 differences plus log-transform, we wont to have to use initial values and inverse logs to get forecasts
arimaf <- Arima(f, order=c(2,2,3), seasonal=c(2,0,0), method = "ML", include.constant = FALSE, lambda=0)
f5 <-forecast(arimaf, h=5)


#Forecast plots
f5t <- tibble(forecast=f5$mean)
f5t$Date <- c("Oct 2016","Nov 2016","Dec 2016","Jan 2017","Feb 2017")
f5t2<-tibble(forecast=arimaf[["fitted"]][285:315],Date=hpi$Time[285:315])
f5t <-rbind(f5t2,f5t)
ftf2<-tibble(forecast=hpi$Montreal_Index[285:320],Date=hpi$Time[285:320])
fts2<-ts(ftf2$forecast, start = c(2014, 3), end=c(2017, 2), frequency = 12)
fts <-ts(f5t$forecast, start = c(2014, 3), end=c(2017, 2), frequency = 12)
ts.plot(fts,fts2,f5ts3, gpars=list(xlab="Year", ylab="Index", lty=c(2:1)),col=rep(c("Black","Black","Blue")))

boxplot(f5$mean,indexts[316:320])
plot(f5)

ftf3 <- tibble(Date=hpi$Time[285:315], forecast=NA)
f5t3 <-rbind(ftf3,f5t)
f5ts3<-ts(f5t3$forecast, start = c(2014, 3), end=c(2017, 2), frequency = 12)

citation("tidyverse")
citation("fpp2")
