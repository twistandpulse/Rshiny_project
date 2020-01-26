library(shiny)
library(shinydashboard)
library(DT)
library(googleVis)
library(dplyr)
library(plotly)
library(data.table)
#read, name files and check classification
totalsale=read.csv('salesbycategory.csv',stringsAsFactors = F)
ttlsales=read.csv('totalsale.csv',stringsAsFactors = F)
ttlsales
store.sales=read.csv('storesale_bystate.csv', stringsAsFactors = F)
online.sales=read.csv('onlinesales_bystate.csv', stringsAsFactors = F)
class(ttlsales$display_sale)
class(ttlsales$social_imp)

#get the quarter with max gross sales
sales.quarter = ttlsales %>% 
  select(.,search_sale,display_sale,social_sale, cal_quarter) %>% 
  group_by(., cal_quarter) %>% 
  summarise(.,allchannel_sale=sum(search_sale)+sum(display_sale)+sum(social_sale)) %>% 
  filter(.,allchannel_sale==max(allchannel_sale))

#get the quarter with max spend
spend.quarter=ttlsales %>% 
  select(., search_spend, display_spend, social_spend, cal_quarter) %>% 
  group_by(., cal_quarter) %>% 
  summarise(., allchannel_spend=sum(search_spend)+sum(display_spend)+sum(social_spend)) %>% 
  filter(., allchannel_spend==max(allchannel_spend))
#get the quarter with highest roi
roi.quarter=ttlsales %>% 
  select(.,search_sale,display_sale,social_sale, search_spend, display_spend, social_spend, cal_quarter) %>% 
  group_by(., cal_quarter) %>% 
  summarise(.,roi=sum(search_sale+display_spend+social_sale)/sum(search_spend+display_spend+social_spend)) %>% 
  filter(.,roi==max(roi))


# pie chart

ttlsales

sales.category <- totalsale %>% 
  select(., cal_quarter, category, sales) %>% 
  group_by(., cal_quarter, category) %>% 
  summarise(.,sales=sum(sales))
  
  

# sales.category$'2018 Q1' <- ifelse(sales.category$cal_quarter=='2018 Q1', sales.category$totalsale, NA)
# sales.category$'2018 Q2' <- ifelse(sales.category$cal_quarter=='2018 Q2', sales.category$totalsale, NA)
# sales.category$'2018 Q3' <- ifelse(sales.category$cal_quarter=='2018 Q3', sales.category$totalsale, NA)
# sales.category$'2018 Q4' <- ifelse(sales.category$cal_quarter=='2018 Q4', sales.category$totalsale, NA)
# sales.category$'2019 Q1' <- ifelse(sales.category$cal_quarter=='2019 Q1', sales.category$totalsale, NA)
# sales.category$'2019 Q2' <- ifelse(sales.category$cal_quarter=='2019 Q2', sales.category$totalsale, NA)
# sales.category$'2019 Q3' <- ifelse(sales.category$cal_quarter=='2019 Q3', sales.category$totalsale, NA)
# sales.category$'2019 Q4' <- ifelse(sales.category$cal_quarter=='2019 Q4', sales.category$totalsale, NA)
# 
# sales.category$cal_quarter=NULL
# sales.category$totalsale=NULL

# choose input for 'Overview' tab
choices=unique(totalsale$cal_quarter)
choices

class(choices)

# colnames(sales.category)
# 
# sales.category


#ROI by channel chart

#CPM by channel chart
cpm.channel <- ttlsales %>% 
  select(., search_spend, display_spend, social_spend, search_imp, display_imp, social_imp, cal_quarter) %>% 
  group_by(., cal_quarter) %>% 
  summarise(., search_cpm=sum(search_spend)*1000/sum(search_imp), display_cpm=sum(display_spend)*1000/sum(display_imp), social_cpm=sum(social_spend)*1000/sum(social_imp))

colnames(cpm.channel)= c('Quarter','Search', 'Display', 'Social')
channel_list <- colnames(cpm.channel)[-1]


cpm.stack <- data.frame(cpm.channel[1], stack(cpm.channel[2:ncol(cpm.channel)]))
colnames(cpm.stack) = c('Quarter', 'CPM', 'Channel')

cpm.stack %>% 
  filter(Channel=='Search') %>% 
  ggplot(aes(x=Quarter,y = CPM))+geom_bar(stat = 'identity')

class(cpm.stack$CPM)

#optimization chart
optimization.channel <- ttlsales %>% 
  select(date,Search=search_spend, Display=display_spend,Social=social_spend,search_sale,display_sale,social_sale)

optimization.channel <- data.frame(optimization.channel[1], stack(optimization.channel[2:4]), stack(optimization.channel[5:7])) 
colnames(optimization.channel)<- c('Date','Spend','Type','Sales','Sales_type')
optimization.channel$Sales_type=NULL    

#store sales chart
store.state <- store.sales %>% 
  group_by(., cal_quarter) %>% 
  select(., state, store_sales)

store.state$store_sales=as.numeric(gsub(',','',store.state$store_sales))
class(store.state$store_sales) 

#online sales chart

online.state <- online.sales %>% 
  group_by(., cal_quarter) %>% 
  select(., state=state_adjusted, online_sales=total_sale)

online.state$online_sales=as.numeric(gsub(',','',online.state$online_sales))
class(online.state$online_sales) 
 

