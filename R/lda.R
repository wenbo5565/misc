##question 3 of hw5

library(geigen)
library(parallel)
library(MASS)
load("hw3.RData")
train=rbind(train2,train3,train8)
mean=colMeans(train)
train=t(t(train)-mean)
test=rbind(test2,test3,test8)
test=t(t(test)-mean)
trainclass=rep(c(1,2,3),c(nrow(train2),nrow(train3),nrow(train8)))
testclass=rep(c(1,2,3),c(nrow(test2),nrow(test3),nrow(test8)))

tri.cube=function(X1,X2,h=1)
{
  u=sqrt(sum((X1-X2)**2))/h
  return((1-u**3)**3*(u<=1))
}

kernel.matrix=function(kernel,X,h=1)
{
  N=nrow(X)
  res=matrix(0,N, N)
  for(ii in 1:N)
  {
    for(jj in 1:N)
    {
      if(ii>jj) res[ii,jj]=res[jj,ii]
      else	res[ii,jj]=kernel(X[ii,],X[jj,],h)
    }
  }
  return(res)
}

kernel.matrix2=function(kernel,X1,X2,h=1)
{
  N1=nrow(X1)
  N2=nrow(X2)
  res=matrix(0,N1,N2)
  for(ii in 1:N1)
  {
    for(jj in 1:N2)
    {
      res[ii,jj]=kernel(X1[ii,],X2[jj,],h)
    }
  }
  return(res)
}

local.FDA=function(X,y,Xtest,K=NULL,Ktest=NULL,h=1)
{
  class=unique(y)
  Nk=table(y)
  KK=length(class)
  N=length(y)
  if(is.null(K)) K=kernel.matrix(tri.cube,X,h)
  if(is.null(Ktest)) Ktest=kernel.matrix2(tri.cube,X,Xtest,h)
  u_k=aggregate(list(K),list(y),mean)
  u_k$Group.1=NULL
  u_k=as.matrix(t(u_k))
  u=rowMeans(K)
  UKUK=u_k%*%diag(Nk)%*%t(u_k)
  Sigma_w=(K%*%K-UKUK)/(N-KK)
  Sigma_b=(UKUK-N*u%*%t(u))/(N-1)
  Sigma_w=Sigma_w*0.99+0.01*diag(diag(Sigma_w))
  eg=geigen(Sigma_b,Sigma_w)
  p=order(abs(eg$values),decreasing=T)
  v1=eg$vectors[,p[1]]/sqrt(sum(eg$vectors[,p[1]]**2))
  v2=eg$vectors[,p[2]]/sqrt(sum(eg$vectors[,p[2]]**2))
  alpha=cbind(v1,v2)
  loadings=K%*%alpha
  loadingstest=t(Ktest)%*%alpha
  return(list(loadings=loadings,loadingstest=loadingstest))
}

local.LDA=function(FDAres,y)
{
  
  model=lda(FDAres$loadings,y)
  return(predict(model,newdata=FDAres$loadingstest)$class)
}

cv.local.LDA=function(X,y,h)
{
  set.seed(1)
  n=nrow(X)
  folds=split(sample(n),rep(1:5,length=n))
  K=kernel.matrix(tri.cube,X,h)
  summ=0
  for(ii in 1:5)
  {
    FDAres=local.FDA(X[-folds[[ii]],],y[-folds[[ii]]],X[folds[[ii]],],K[-folds[[ii]],-folds[[ii]]],K[-folds[[ii]],folds[[ii]]],h)
    yhat=local.LDA(FDAres,y[-folds[[ii]]])
    summ=summ+sum(yhat!=y[folds[[ii]]])
  }
  return(summ/n)
}

cv.dummy=function(h)
{
  return(cv.local.LDA(train,trainclass,h))
}
hlist=seq(15,23,2)


## cite from Chencheng Cai
cv.error=mcmapply(cv.dummy,h=hlist,mc.cores=1)
h=hlist[which.min(cv.error)]

FDA=local.FDA(train,trainclass,test,h=h)
png("local-FDA.png")
plot(FDA$loadings[,1],FDA$loadings[,2],col=rep(c(4,5,10),c(nrow(train2),nrow(train3),nrow(train8))),xlab='First Score',ylab='Second Score',main="local FDA")
dev.off()
test.error=mean(testclass!=local.LDA(FDA,trainclass))

FDA$loadingstest=FDA$loadings
train.error=mean(trainclass!=local.LDA(FDA,trainclass))