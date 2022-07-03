#df <- read_csv("DTS_OpCash.csv")
library(readr)
df <- read_csv("DTS_OpCashBal_20170531_20220531.csv")
df
summary(df)

## Data cleaning process 
df_Name = df$`Table Name`[1]
df_No = df$`Table Number`[1]
df_sub_Name = df$`Sub Table Name`[1]
# Using it for future labels

#dephl and other libraries are present but...
df[df==""] <- NA
sum(is.na(df))


## Deleting Rows and Columns ... , Deleting the unneccesary Tables 
##write.csv(df2, file="somedf.csv")
df$`Table Name` <- NULL
df$`Table Number`<-NULL
df$`Sub Table Name`<-NULL
df$`Source Line Number`<-NULL

#summary(df)
#df[c(1:77), ] # dataframe containing first, third and sixth rows
df2 = df[,c(2,1,3:ncol(df))]
df3 = df2
summary(df2)

#df3 <- df2[-c(df2$`Type of Account`[`Supplementary Financing Program Account`,`Short-Term Cash Investments (Table V)`]),]
#df2$`Type of Account`[`Supplementary Financing Program Account`] <- NULL
#library(psych)
#describe(df3)

library(dplyr)
df_supplementry_aid = subset(df2, `Type of Account` != "Supplementary Financing Program Account")
df5 = subset(df_supplementry_aid, `Type of Account` != "Short-Term Cash Investments (Table V)")
#spec(df2)
df_TGA_deposit = subset(df5, `Type of Account` != "Total TGA Deposits (Table II)")

df_TGA = subset(df_TGA_deposit, `Type of Account` != "Total TGA Withdrawals (Table II) (-)")


df_TGA$`Closing Balance Today` <- as.numeric(df_TGA$`Closing Balance Today`)
summary(df_TGA)
df_TGA$`Closing Balance Today` 
sum(is.na(df_TGA$`Closing Balance Today`))

#####
df_TGA$`Opening Balance Today`
#for (x in 1:31) {
  #for (y in 0:30){
  #  x1 =as.array((diff(df_TGA$`Opening Balance Today`[x+y:x+1+y])))
 # }
#}
df_FRA <- subset(df_TGA, `Type of Account` != "Treasury General Account (TGA) Closing Balance")
df_FRA <- subset(df_TGA, `Type of Account` != "Total TGA Deposits (Table II)")
df_FRA <- subset(df_TGA, `Type of Account` != "Total TGA Withdrawals (Table II) (-)")
df_FRA <- subset(df_TGA, `Type of Account` != "Supplementary Financing Program Account")
df_FRA <- subset(df_TGA, `Type of Account` != "Short-Term Cash Investments (Table V)")

#x1
dn= diff(df_TGA$`Opening Balance Today`)
dn
dif <- c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61)
d_obt = dn[dif]
d_obt
for (x in 1:61){
  if (x %% 2 ==1) {
    db <- (dn[c(x)])
    #y <- append(db)
    print(db)
  }
}

#diff(df_TGA$`Opening Balance Today`[dif])
#df_TGA$`Type of Account`[`Treasury General Account (TGA) Opening Balance`]
#data<-replace(df_TGA$`Type of Account`,df_TGA$`Type of Account`=="Treasury General Account (TGA) Opening Balance","Treasury General Account (TGA)")
#print(data)
#db

#d = as.data.frame(data)
#df_TGA$`Type of Account`<- d
#colnames(df_TGA)[colnames(df_TGA) == "Type of Account"] <- "Type of Account"
#df_TGA  

summary(df_TGA)
#colnames(df_TGA)


#df_FRA <- subset(df_TGA, `Type of Account` != "Treasury General Account (TGA) Closing Balance")

df_ = df_FRA[1:31,4,drop = FALSE]
df_
dnew = df_ + d_obt
dnew

#df["group_b"][df["group_b"] == 11] <- 77
for (x in 1:nrow(dnew)){
  df_FRA$`Opening Balance Today`[x] <- dnew$`Opening Balance Today`[x]
  df_FRA$`Type of Account`[x] <- "Treasury General Account (TGA)"
  df_FRA$`Closing Balance Today`[x+1] <- dnew$`Opening Balance Today`[x]
  }
#df_TGA$`Type of Account`

# Changing columns again
df_FRA <- df[,c(1,2,3:ncol(df_FRA))]
#library(lubridate)
df_FRA$`Record Date` <- as.Date(df_FRA$`Record Date`[1:nrow(df_FRA)])
#class(df_FRA$`Record Date`)
str(df_FRA)
df_FRA$`Closing Balance Today` <- as.numeric(df_FRA$`Closing Balance Today`)
#summary(df_FRA)
write.csv(df_FRA, file="test_dataset12.csv")

