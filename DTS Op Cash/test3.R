library(readr)
df <- read_csv("DTS_OpCashBal_20170531_20220531.csv")
df
summary(df)
head(df)

df_Name = df$`Table Name`[1]
df_Name
df_No = df$`Table Number`[1]
df_sub_Name = df$`Sub Table Name`[1]

df[df==""] <- NA
sum(is.na(df))

str(df)

## Deleting Rows and Columns ... , Deleting the unneccesary Tables 
##write.csv(df2, file="somedf.csv")
library(dplyr)

df$`Table Name` <- NULL
df$`Table Number`<-NULL
df$`Sub Table Name`<-NULL
df$`Source Line Number`<-NULL

#df_CB <- subset(df, `Type of Account` != "Treasury General Account (TGA) Closing Balance")
df_Dp <- subset(df, `Type of Account` != "Total TGA Deposits (Table II)")
df_with <- subset(df_Dp, `Type of Account` != "Total TGA Withdrawals (Table II) (-)")
df_sfp <- subset(df_Dp, `Type of Account` != "Supplementary Financing Program Account")
df_GA <- subset(df_sfp, `Type of Account` != "Short-Term Cash Investments (Table V)")
df_GA <- subset(df_GA,df_GA$`Type of Account`!="Total TGA Withdrawals (Table II) (-)")

str(df_GA)

df_GA$`Closing Balance Today` <- as.numeric(df_GA$`Closing Balance Today`)
df_GA$`Record Date` <- as.Date(df_GA$`Record Date`[1:nrow(df_GA)])
df_GA$`Fiscal Quarter Number` <- as.factor(df_GA$`Fiscal Quarter Number`)
df_GA$`Calendar Quarter Number` <- as.factor(df_GA$`Calendar Quarter Number`)

str(df_GA)

summary(df_GA)
df_GA$`Closing Balance Today`
sum(is.na(df_GA$`Closing Balance Today`))

dn= diff(df_GA$`Opening Balance Today`)
dn
dif <- c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61)#,63,
         #65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127)
d_obt = dn[dif]
d_obt
for (x in 1:61){
  if (x %% 2 ==1) {
    db <- (dn[c(x)])
    #y <- append(db)
    print(db)
  }
}
df_GA <- subset(df, `Type of Account` != "Treasury General Account (TGA) Closing Balance")

df_ = df_GA[1:31,4,drop = FALSE]
df_
dnew = df_ + d_obt
dnew

#df["group_b"][df["group_b"] == 11] <- 77
for (x in 1:nrow(dnew)){
  df_GA$`Opening Balance Today`[x] <- dnew$`Opening Balance Today`[x]
  df_GA$`Type of Account`[x] <- "Treasury General Account (TGA)"
  df_GA$`Closing Balance Today`[x+1] <- dnew$`Opening Balance Today`[x]
  for (y in nrow(dnew):nrow(df_GA)){
    df_GA <- subset(df_GA, `Type of Account` != "Total TGA Deposits (Table II)")
    df_GA <- subset(df_GA, `Type of Account` != "Total TGA Withdrawals (Table II) (-)")
    df_GA <- subset(df_GA, `Type of Account` != "Supplementary Financing Program Account")
    df_GA <- subset(df_GA, `Type of Account` != "Short-Term Cash Investments (Table V)")
    df_GA <- subset(df_GA,df_GA$`Type of Account`!="Total TGA Withdrawals (Table II) (-)")
  }
}
#for(v in 1:1000){
#df_GA <- subset(df_GA, `Type of Account` != "Total TGA Deposits (Table II)")
#df_GA <- subset(df_GA, `Type of Account` != "Total TGA Withdrawals (Table II) (-)")
#df_GA <- subset(df_GA, `Type of Account` != "Supplementary Financing Program Account")
#df_GA <- subset(df_GA, `Type of Account` != "Short-Term Cash Investments (Table V)")
#df_GA <- subset(df_GA,df_GA$`Type of Account`!="Total TGA Withdrawals (Table II) (-)")
#}

df_GA$`Closing Balance Today`[2] <-df_GA$`Opening Balance Today`[1]

df_GA$`Closing Balance Today` <- as.numeric(df_GA$`Closing Balance Today`)
#df_GA$`Record Date` <- as.Date(df_GA$`Record Date`[1:nrow(df_GA)])
df_GA$`Fiscal Quarter Number` <- as.factor(df_GA$`Fiscal Quarter Number`)
df_GA$`Calendar Quarter Number` <- as.factor(df_GA$`Calendar Quarter Number`)
df_GA$`Calendar Year` <- as.factor(df_GA$`Calendar Year`)
df$`Fiscal Year` <- as.factor(df$`Fiscal Year`)
df_GA
#abs((df_GA$`Closing_Balance_Today`))
#abs((df_GA$`Opening Balance Today`))


library(lubridate)
df_GA$`Record Date` <- dmy(df_GA$`Record Date`)
typeof(df_GA$`Record Date`)

# New Column name 
colnames(df_GA) <- c('Record_Date','Type_of_Account','Closing_Balance_Today','Opening_Balance_Today','Opening_Balance_This_Month',
                     'Opening_Balance_This_Fiscal_Year','Fiscal_Year','Fiscal_Quarter_Number','Calender_Year','Calender_Quarter_Number',
                     'Calender_Month_Number','Calender_Day_Number')

str(df_GA)
#df_GA
#df_GA$`Closing Balance Today`
sum(is.na(df_GA))

library(VIM)
data1 <- kNN(df_GA,variable = c("Closing_Balance_Today"), k = 1)
data1
summary(data1)
#write.csv(df_GA, file="tes.csv")
data1 <- subset(data1, select = Record_Date:Calender_Day_Number)
summary(data1)
#write.csv(data1,file="pca.csv")

### Outliers ( IN a Time Series ) ####
#from scipy.stats import norm
#Print the probabilities of each demand observation
#m =df_GA
#print(pnorm(df.values, m, s).round(2))
#limit_high = norm.ppf(0.99,m,s)
#limit_low = norm.ppf(0.01,m,s)
#df = df.clip(lower=limit_low, upper=limit_high)

#### Correlation ####
######################### Correlation  & Hypothesis Testing ###########
library(ggpubr)
ggscatter(data1, x = "Opening_Balance_Today", y ="Closing_Balance_Today", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Date", ylab = "OBTM")

## Hypothesis test to check the test assumptions
Ho_1 =  "The variables are not  linearly related"

Ha_1 = "The variables are linearly related"

df9<-data1[data1$Opening_Balance_Today<80000 & data1$Closing_Balance_Today<80000, c("Opening_Balance_Today","Closing_Balance_Today")]
df9
nrow(df9)

fit<-lm(df9$Opening_Balance_Today~df9$Closing_Balance_Today,data=df9)
fit
 #as p < significance model reject null hypothesis

################ Hypothesis 2 ######

#Ho_2= "the data are normally distributed"
#Ha_2= "the data are not normally distributed"
# Shapiro-Wilk normality test for mpg
#shapiro.test(my_data$mpg) # => p = 0.1229
# Shapiro-Wilk normality test for wt
#shapiro.test(my_data$wt) # => p = 0.09
######
library(psych)
describe(data1)

##Correlation Matrix
pairs.panels (data1,gap = 0,bg = c("red","green","blue"[data1$Type_of_Account]),
              pch = 21)



#### PCA & Correlation ####
#library(factoextra)

pca_dat <- data1[]
pca_dat$Fiscal_Quarter_Number <- as.numeric(pca_dat$Fiscal_Quarter_Number)
pca_dat$Calender_Year <- as.numeric(pca_dat$Calender_Year)
pca_dat$Calender_Quarter_Number <- as.numeric(pca_dat$Calender_Quarter_Number)

str(pca_dat)

data.pca <- prcomp(pca_dat[,c(3:ncol(pca_dat))],center = TRUE,scale. = TRUE)
attr(data.pca, 'scaled:scale')

#scaled = scale(data.pca,scale = TRUE)
library(factoextra)
summary(data.pca)
str(data.pca)

eig.val <- get_eigenvalue(data.pca)
eig.val
#get_e
# Results for Variables
#data.var <- get_pca_var(data.pca)
#data.var$coord          # Coordinates
#data.var$contrib        # Contributions to the PCs
#data.var$cos2           # Quality of representation 

# Results for individuals
#data.ind <- get_pca_ind(data.pca)
#data.ind$coord          # Coordinates
#data.ind$contrib        # Contributions to the PCs
#data.ind$cos2           # Quality of representation 

#library(factoextra)
fviz_eig(data.pca)

fviz_pca_ind(data.pca,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)


fviz_pca_var(data.pca,
           col.var = "contrib", # Color by contributions to the PC
           gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
            repel = TRUE     # Avoid text overlapping
)
#biplot(data.pca,scale=0, cex=.7)
#fviz_pca_biplot(data.pca, repel = TRUE,
 #            col.var = "#2E9FDF", # Variables color
  #            col.ind = "#696969"  # Individuals color
#)

PC1 <- data.pca$rotation[,1]
PC1_scores <- abs(PC1)
PC1_scores_ordered <- sort(PC1_scores, decreasing = TRUE)
names(PC1_scores_ordered)

#X = iris[,1:4]
nrows = nrow(pca_dat[,c(3:ncol(pca_dat))])
ncols = ncol(pca_dat[,c(3:ncol(pca_dat))])
mu = colMeans(pca_dat[,c(3:ncol(pca_dat))])
#var_sd = apply(pca_dat[,c(3:ncol(pca_dat))], 2, sd)
m = mean(pca_dat$Closing_Balance_Today)
m
var_sd=sd(pca_dat$Closing_Balance_Today)
var_sd
#data.pca$x[,c(1:6)]
#data.pca$scale
#Xpca = prcomp(X)
#scaled_data = (pca_dat[,c(3:ncol(pca_dat))] - rep(mu, each = nrows))/rep(var_sd, each = nrows)
nComp = 6   #Variance 0.935922
#data.pca <- prcomp(pca_dat[,c(3:ncol(pca_dat))], center = FALSE,scale. = FALSE)
#Xhat = (data.pca$x[,1:nComp]) %*% t(data.pca$rotation[,1:nComp])
#Xhat = scale(Xhat, center = -1 * data.pca$center, scale=FALSE)
Xhat = t(t(data.pca$x[,c(1:nComp)]%*% t(data.pca$rotation[,1:nComp])) * data.pca$scale + data.pca$center)
#Xhat = scale(Xhat, center = -mu, scale = 1/data.pca$scale)
#attr(Xhat,'scaled:scale')
#Xhat * attr(Xhat, 'scaled:scale') + attr(Xhat, 'scaled:center')

Xhat[c(1:4),]
#write.csv(Xhat,file="a.csv")

######################### Data Visualization ############

boxplot(data1$Closing_Balance_Today, horizontal = TRUE, 
        main = "Boxplot for Closing Balance Today")
boxplot(data1$Opening_Balance_Today, horizontal = TRUE, 
        main = "Boxplot for Opening Balance Today")
boxplot(data1$Opening_Balance_This_Month, horizontal = TRUE, 
        main = "Boxplot for Opening balance this Month")
boxplot(data1$Opening_Balance_This_Fiscal_Year, horizontal = TRUE, 
        main = "Boxplot for This fiscal Year")


plot(data1$Closing_Balance_Today,data1$Opening_Balance_This_Month,
     xlab ="Closing Balance Today",ylab = "Opening balance this month",
     main = "scatter plot",
     col = c("red","green"))
plot(data1$Opening_Balance_This_Month,data1$Opening_Balance_This_Fiscal_Year,
     xlab ="Closing Balance Today",ylab = "Opening balance this month",
     main = "scatter plot",
     col = c("blue","yellow"))

hist(data1$Closing_Balance_Today, col = "red")               ## Plot 1
hist(data1$Opening_Balance_Today, col = "green", breaks = 25)  ## Plot 2
hist(data1$Opening_Balance_This_Month, col = "yellow", breaks = 25) 
hist(data1$Opening_Balance_This_Fiscal_Year, col = "blue")#, breaks = 25)


library(ggplot2)
library(cowplot)
base_line <-ggplot(data = data1, aes(x = Fiscal_Year , y = Opening_Balance_This_Fiscal_Year)) 
base_line+geom_line(aes(color = Type_of_Account)) + geom_line(aes(color = Type_of_Account))

base_plot <- ggplot(data = data1, aes(x = Calender_Month_Number, y = Opening_Balance_This_Month))
base_plot + geom_point()
#install.packages("hexbin")
library(hexbin)
#base_line+geom_hex()
#geom_point()
#diff(range(data1$))
Opening_Balance = data1$Opening_Balance_This_Month

g <-ggplot(data=data1, aes(x=Record_Date,y=Opening_Balance))#,y = seq(0,2000000)))#, 0.05)))
           # ,Opening_Balance_This_Month ))
h<- g +geom_line(aes(color = Opening_Balance_Today))+
  geom_line(aes(color= Opening_Balance_This_Month))+
  geom_line(aes(color= Opening_Balance_This_Fiscal_Year))
h

m<- g+geom_line(aes(y=Opening_Balance_Today),colour ="red")
m
op_cl <- m+geom_line(aes(y=Closing_Balance_Today),colour ="green")
op_cl

op_cl_obm <- op_cl+geom_line(aes(y=Opening_Balance_This_Month),colour ="blue")
op_cl_obm

op_cl_obm_oby <- op_cl_obm+geom_line(aes(y=Opening_Balance_This_Fiscal_Year),colour ="pink")
op_cl_obm_oby

library(tidyquant)
library(plotly)
#############

fig <- plot_ly(data1, type = 'scatter', mode = 'lines')%>%
  add_trace(x = data1$Record_Date, y = data1$Opening_Balance_Today, name = 'Opening Balance')%>%
  layout(showlegend = F)
options(warn = -1)

fig <- fig %>%
  layout(
    xaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    yaxis = list(zerolinecolor = '#ffff',
                 zerolinewidth = 2,
                 gridcolor = 'ffff'),
    plot_bgcolor='#e5ecf6', width = 900)


fig

######

x <- list(
  title = "date"
)
y <- list(
  title = "value"
)


#colnames(stock) <- append(tickers,'Dates')

ax <- list(
  title = "",
  zeroline = FALSE,
  #showline = FALSE,
  showticklabels = FALSE
)

fig1 <- plot_ly(data1, type = 'scatter', mode = 'lines', fill = 'tonexty')%>%
  add_trace(x = data1$Record_Date, y = data1$Closing_Balance_Today, name = 'Cbt')%>%
  #layout(legend=list(xaxis = ax))
  layout(legend=list(title=list(text='Transaction')), xaxis = ax)
#options(warn = -1)

fig2 <- plot_ly(data1, type = 'scatter', mode = 'lines', fill = 'tonexty')%>%
  add_trace(x = data1$Record_Date, y = data1$Opening_Balance_Today, name = 'OBT')%>%
  layout(legend=list(title=list(text='Transaction')), xaxis = ax)#, yaxis = list(range = c(0.5,2),title = '', showticklabels = FALSE))
 # layout(showlegend = FALSE)
#options(warn = -1)

fig3 <- plot_ly(data1, type = 'scatter', mode = 'lines', fill = 'tonexty')%>%
  add_trace(x = data1$Record_Date, y = data1$Opening_Balance_This_Month, name = 'ObM')%>%
  #layout(legend=list(title=list(text='Transaction')), xaxis = ax, yaxis = list(range = c(0.5,2), title = 'value'))
  layout(showlegend = FALSE)
options(warn = -1)

fig4 <- plot_ly(data1, type = 'scatter', mode = 'lines', fill = 'tonexty')%>%
  add_trace(x = data1$Record_Date, y = data1$Opening_Balance_This_Fiscal_Year, name = 'OBTF')%>%
  #layout(legend=list(title=list(text='company')), xaxis = ax, yaxis = list(range = c(0.5,2),title = '', showticklabels = FALSE, title =''), xaxis = list(title = 'Date'))
  layout(showlegend = FALSE)
options(warn = -1)

final_fig <- subplot(fig1, fig2, fig3, fig4,
               nrows = 2, titleY = TRUE, titleX = TRUE) %>% layout(
                 xaxis = list(zerolinecolor = '#ffff',
                              zerolinewidth = 2,
                              gridcolor = 'ffff'),
                 yaxis = list(zerolinecolor = '#ffff',
                              zerolinewidth = 2,
                              gridcolor = 'ffff'),
                 plot_bgcolor='#e5ecf6')
annotations = list(
  list(
    x = 0.225,
    y = 1.0,
    font = list(size = 10),
    text = "Closing Balance Today",
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    yanchor = "bottom",
    showarrow = FALSE
  ),
  list(
    x = 0.775,
    y = 1,
    font = list(size = 10),
    text = "Opening Balance Today",
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    yanchor = "bottom",
    showarrow = FALSE
  ),
  list(
    x = 0.225,
    y = 0.48,
    font = list(size = 10),
    text = "Opening Balance This Month",
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    yanchor = "bottom",
    showarrow = FALSE
  ),
  list(
    x = 0.775,
    y = 0.48,
    font = list(size = 10),
    text = "Opening Balance This Fiscal Year",
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    yanchor = "bottom",
    showarrow = FALSE
  )
)

final_fig <- final_fig %>%layout(annotations = annotations, width = 900)
options(warn = -1)
final_fig



##############
base_plot+geom_hex()
profit_loss <-data1$Closing_Balance_Today-data1$Opening_Balance_Today

b <- ggplot(data = data1, aes(x= Record_Date, y = profit_loss))
b+geom_line()

datamatrix <- data.matrix(data1)
data_heatmap <- heatmap(datamatrix)#, Rowv=NA, Colv=NA, col = heat.colors(256),scale="column", margins=c(2,10))

## Plot 3
#write.csv(data1, file="test12.csv")

### ARIMA ####
