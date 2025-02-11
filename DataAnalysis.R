library(readr)
library(dplyr)
library(knitr)

data104 <- read_csv("data104.csv")
data107 <- read_csv("data107.csv")

#篩選出大學畢業者的薪資資料
graduate104<-data104[,c("年度","大職業別","大學-薪資","大學-女/男")]
graduate107<-data107[,c("年度","大職業別","大學-薪資","大學-女/男")]

#將大學-薪資、大學-女/男的值轉換成數字
graduate104$`大學-薪資`<-gsub("—|…","",graduate104$`大學-薪資`)
graduate104$`大學-薪資`<-as.numeric(graduate104$`大學-薪資`)
graduate104$`大學-女/男`<-gsub("—|…","",graduate104$`大學-女/男`)
graduate104$`大學-女/男`<-as.numeric(graduate104$`大學-女/男`)
graduate107$`大學-薪資`<-gsub("—|…","",graduate107$`大學-薪資`)
graduate107$`大學-薪資`<-as.numeric(graduate107$`大學-薪資`)
graduate107$`大學-女/男`<-gsub("—|…","",graduate107$`大學-女/男`)
graduate107$`大學-女/男`<-as.numeric(graduate107$`大學-女/男`)

#b. 整理、統一大職業別的名稱
graduate104$大職業別<-gsub("部門","",graduate104$大職業別)
graduate104$大職業別<-gsub("營造業","營建工程",graduate104$大職業別)
graduate107$大職業別<-gsub("_","、",graduate107$大職業別)
graduate107$大職業別<-gsub("教育業","教育服務業",graduate107$大職業別)
graduate107$大職業別<-gsub("醫療保健業","醫療保健服務業",graduate107$大職業別)
graduate107$大職業別<-gsub("出版、影音製作、傳播及資通訊服務業","資訊及通訊傳播業",graduate107$大職業別)

#a. Join 104和107年度表格，變成新表格graduateDF
graduateDF<-merge(graduate107,graduate104,by=c("大職業別"),all=T)

#107年度薪資較104年度薪資高的職業
morethan104<-graduateDF
morethan104<-subset(morethan104,`大學-薪資.x`>`大學-薪資.y`)

#c. 新增欄位：107年度大學畢業薪資 / 104年度大學畢業薪資
morethan104$兩年度薪資比例<-morethan104$`大學-薪資.x`/morethan104$`大學-薪資.y`

#d. 排序，並呈現前十名的資料
morethan104[order(morethan104$兩年度薪資比例,decreasing=T),]%>%
  head(10)

#e. 篩選兩年度薪資比例 >1.05的欄位
morethan104_1.05<-subset(morethan104,兩年度薪資比例>1.05)
morethan104_1.05$大職業別

#f. 字串處理，取出大職業別中"-" 前面的字串，並分析出現次數
strsplit(morethan104_1.05$大職業別,'-')%>%
  lapply("[",1)%>%
  unlist()%>%
  table()

library(readr)
library(dplyr)

#篩選出大學畢業者的薪資資料
gender104<-data104
gender107<-data107

##將大學-女/男的值轉換成數字
gender104$`大學-女/男`<-gsub("—|…","",gender104$`大學-女/男`)
gender104$`大學-女/男`<-as.numeric(gender104$`大學-女/男`)
gender107$`大學-女/男`<-gsub("—|…","",gender107$`大學-女/男`)
gender107$`大學-女/男`<-as.numeric(gender107$`大學-女/男`)

#請問哪些行業男生薪資比女生薪資多?
#a. 將104和107年度大學畢業男女薪資比例由小到大排序 (分年做)
gender104[order(gender104$`大學-女/男`,decreasing=F),]%>%
  head(10)
gender107[order(gender107$`大學-女/男`,decreasing=F),]%>%
  head(10)

#請問那些行業女生薪資比男生薪資多? 
#b. 將104和107年度大學畢業男女薪資比例由大到小排序 (分年做)
gender104[order(gender104$`大學-女/男`,decreasing=T),]%>%
  head(10)
gender107[order(gender107$`大學-女/男`,decreasing=T),]%>%
  head(10)

library(readr)
library(dplyr)

#a. 取出大學薪資欄位與研究所薪資欄位
master_graduate<-data107[,c("年度","大職業別","大學-薪資","研究所-薪資")]

#將大學-薪資、研究所-薪資的值轉換成數字
master_graduate$`大學-薪資`<-gsub("—|…","",master_graduate$`大學-薪資`)
master_graduate$`大學-薪資`<-as.numeric(master_graduate$`大學-薪資`)
master_graduate$`研究所-薪資`<-gsub("—|…","",master_graduate$`研究所-薪資`)
master_graduate$`研究所-薪資`<-as.numeric(master_graduate$`研究所-薪資`)

#b. 計算研究所薪資 / 大學薪資，並用此值在表格中新增一個欄位
master_graduate$研究所與大學薪資比例<-master_graduate$`研究所-薪資`/master_graduate$`大學-薪資`

#c. 排序，並呈現前十名的資料
master_graduate[order(master_graduate$研究所與大學薪資比例,decreasing=T),]%>%
  head(10)


library(readr)
library(dplyr)

#篩選薪資資料，並列出自己有興趣的職業別
interested107<-data107[,c("年度","大職業別","大學-薪資","研究所-薪資")]%>%
  filter(大職業別%in%c("金融及保險業-技術員及助理專業人員",
                   "專業_科學及技術服務業-專業人員",
                   "專業_科學及技術服務業-技術員及助理專業人員",
                   "出版、影音製作、傳播及資通訊服務業-專業人員",
                   "出版、影音製作、傳播及資通訊服務業-技術員及助理專業人員"))

#將大學-薪資、研究所-薪資的值轉換成數字
interested107$`大學-薪資`<-gsub("—|…","",interested107$`大學-薪資`)
interested107$`大學-薪資`<-as.numeric(interested107$`大學-薪資`)
interested107$`研究所-薪資`<-gsub("—|…","",interested107$`研究所-薪資`)
interested107$`研究所-薪資`<-as.numeric(interested107$`研究所-薪資`)

#新增欄位：研究所薪資與大學薪資差多少
interested107$研究所比大學的薪資多出<-interested107$`研究所-薪資`-interested107$`大學-薪資`