data <- read.csv("./data/data.csv", header=TRUE, sep=" ")

xlab<-"Steps"
ylab<-c("", "", "", "", "", "Total Path Length", "Total Pointer Updates")
ual<-c("No union algorithm", "Union by size", "Union by rank")
ybase<-0
subtract<-FALSE

compute.vector <- function(calg, ualg, n, col=6,sub=subtract){
  maxdim<-0
  mt<-0
  for (t in c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)) {
    it<-1
    for (celem in array(unlist(data[data$comp_alg==calg & data$union_alg==ualg & data$N==n & data$T==t,][col]))){
      if(it > maxdim) {
        maxdim = it
        mt<-t
      }
      it<-it+1
    }
  }
  
  colsum<-array(0,dim=c(maxdim))
  colcnt<-array(0,dim=c(maxdim))
  for (t in c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)) {
    it<-1
    for (celem in array(unlist(data[data$comp_alg==calg & data$union_alg==ualg & data$N==n & data$T==t,][col]))){
      colsum[it]<-colsum[it] + celem
      colcnt[it]<-colcnt[it] + 1
      it<-it+1
    }
  }
  x<-array(unlist(data[data$comp_alg==calg & data$union_alg==ualg & data$N==n & data$T==mt,][5]))
  y<-colsum/colcnt
  
  if(sub){
    tmp<-compute.vector(1,ualg,n,col,FALSE)
    y<-y-tmp$y
  }
  
  return(data.frame("x" = x, "y" = y))
}

draw.plot <- function(calg, ualg, n, col=6, iniplot=true, color){
  for (t in c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)) {
    # lines(data[data$comp_alg==calg & data$union_alg==ualg & data$N==n & data$T==t,][c(5,col)], col=color)
  }
  toplot<-compute.vector(calg, ualg, n, col)
  mx<-max(toplot$x)
  my<-max(toplot$y)
  yl<-ylab[col]
  if(subtract){
    yl<-paste("dif. ", ylab[col])
  }
  tit<-paste(yl, " (", ual[ualg+1], ", N = ", n, ")")
  if(iniplot) plot(c(0,mx), c(ybase, my), xlab=xlab, ylab=yl,main=tit,pch=30)
  lines(toplot, col=color)
}

draw.all.compression.algs <- function(ualg, n, col=6,first=1, order=c(0,2,1,3,4)){
  cols<-c('firebrick1', 'gold', 'chartreuse', 'cyan', 'blue', 'blueviolet')
  draw.plot(order[first], ualg, n, col, TRUE, cols[order[first]+1])
  for(ca in (first+1):5){
    draw.plot(order[ca], ualg, n, col, FALSE, cols[order[ca]+1])
  }
}

full.suite <- function(n){
  par(mfrow=c(2,3))
  ybase <<- 0
  draw.all.compression.algs(2,n,6,2)
  draw.all.compression.algs(1,n,6,2)
  if(n == 1000){
    draw.all.compression.algs(0,n,6,2)
  } else {
    draw.all.compression.algs(0,n,6,2,c(0,4,3,2,1))
  }
  
  if(subtract) ybase <<- - n / 50
  draw.all.compression.algs(2,n,7,2,c(0,2,4,3,1))
  draw.all.compression.algs(1,n,7,2,c(0,2,4,3,1))
  if(subtract) ybase <<- -2.7 * n + 1500
  draw.all.compression.algs(0,n,7,2,c(0,4,2,3,1))
}

full.suite.zero <- function(n){
  par(mfrow=c(2,3))
  ybase <<- 0
  draw.all.compression.algs(2,n,6,1)
  draw.all.compression.algs(1,n,6,1)
  if(n == 1000){
    draw.all.compression.algs(0,n,6,1)
  } else {
    draw.all.compression.algs(0,n,6,1,c(0,4,3,2,1))
  }
  
  if(subtract) ybase <<- - n / 50
  draw.all.compression.algs(2,n,7,1,c(2,4,3,1,0))
  draw.all.compression.algs(1,n,7,1,c(2,4,3,1,0))
  if(subtract) ybase <<- -2.7 * n + 1500
  draw.all.compression.algs(0,n,7,1,c(4,2,3,1,0))
}

subtract<-TRUE
png(file="./plots/dif_n1000.png", width=1500, height=1000)
full.suite(1000)
dev.off()
png(file="./plots/dif_n5000.png", width=1500, height=1000)
full.suite(5000)
dev.off()
png(file="./plots/dif_n10000.png", width=1500, height=1000)
full.suite(10000)
dev.off()

subtract<-FALSE
png(file="./plots/abs_n1000.png", width=1500, height=1000)
full.suite(1000)
dev.off()
png(file="./plots/abs_n5000.png", width=1500, height=1000)
full.suite(5000)
dev.off()
png(file="./plots/abs_n10000.png", width=1500, height=1000)
full.suite(10000)
dev.off()

png(file="./plots/absz_n1000.png", width=1500, height=1000)
full.suite.zero(1000)
dev.off()
png(file="./plots/absz_n5000.png", width=1500, height=1000)
full.suite.zero(5000)
dev.off()
png(file="./plots/absz_n10000.png", width=1500, height=1000)
full.suite.zero(10000)
dev.off()
