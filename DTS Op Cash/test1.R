print('DATA SCIENCE HOME ASSIGNMENT')
data= matrix(c(35,'Sourjadip Pramanik',
               50, 'Vaibhav Kadam',
               53, 'Vijay Kumar Singh',
               55, 'Vishal Gurudassani',
               56, 'Vishal Phonde'), ncol=2,nrow =5,byrow = TRUE)

colnames(data) = c('Rol No.','Name')
rownames(data) <- c(1:5)

group_memebers=as.table(data)
group_memebers

library(readr)
d1 <- read_csv("DTS_OpCash.csv")
spec(d1)
summary(d1)
#View(d1)
#df2 <-as.data.frame(t(d1))
#df2
#print(df2)

### DATA CLEANING AND PRE PROCESSING ###
# Removing irrelevant columns 
#df_ = subset(df, select = -c(df$Table Number))
#df_
#install.packages(“dplyr”)
head(d1)
d1$`Table Name` <- NULL
select(d1, -T)
#df <- subset (df, select = -`Table Name`)
summary(d1)