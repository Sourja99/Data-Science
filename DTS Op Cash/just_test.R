df_1<- read.csv("pca.csv")

library(factoextra)
df_1$Fiscal_Quarter_Number <- as.numeric(df_1$Fiscal_Quarter_Number)
df_1$Calender_Year <- as.numeric(df_1$Calender_Year)
df_1$Calender_Quarter_Number <- as.numeric(df_1$Calender_Quarter_Number)

#df_9 = df_1(c[1:nrow(df_1)],c[4:ncol(df_1)])
pca_data = as.matrix(df_1)


str(pca_data)

d.pca <- prcomp(pca_data,center = TRUE,scale. = TRUE)

d.pca
summary(d.pca)
d.pca$scale
d.pca$center

d.eigen <- eigen(cov(pca_data))

d.first = (d.pca$x)%*%t(d.eigen$vectors)

d.second <-as.data.frame(d.first)
d.second
d.pca$sdev

d.mean = colMeans(pca_data)
d.mean
d.third <- d.second + d.mean
d.third[1,]
#d.pca$sdev
