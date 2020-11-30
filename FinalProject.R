
library(readxl)
library(tidyverse)

# Step 1
  
covid = read.csv("covid19.txt", header = TRUE)
covid = covid[covid$state %in% c("Arizona", "New Mexico", "Texas"), ]
covid$state = as.character(covid$state)
covid$state[covid$state == "Arizona"] = "AZ"
covid$state[covid$state == "New Mexico"] = "NM"
covid$state[covid$state == "Texas"] = "TX"

covid$date = as.character(covid$date)
covid$date = as.Date(covid$date) - as.Date("2020/1/1")

# Step 2-5

poverty = data.frame(read_excel("PovertyEstimates.xls"))
poverty = poverty[poverty$Stabr %in% c("AZ", "NM", "TX"), ]
poverty = rename(poverty, state = Stabr, county = Area_name)
poverty$county[substr(poverty$county, nchar(poverty$county) - 5, 
                      nchar(poverty$county)) == "County"] = 
          substr(poverty$county[substr(poverty$county, nchar(poverty$county)
          - 5, nchar(poverty$county)) == "County"], 1,
          nchar(poverty$county[substr(poverty$county, nchar(poverty$county)
          - 5, nchar(poverty$county)) == "County"]) - 7)

unemployment = data.frame(read_excel("Unemployment.xls"))
unemployment = unemployment[unemployment$State %in% c("AZ", "NM", "TX"), ]
unemployment = rename(unemployment, state = State, county = Area_name)
unemployment$county[substr(unemployment$county,
                           nchar(unemployment$county) - 9, nchar(unemployment$county) - 4) == "County"] =
                substr(unemployment$county[substr(unemployment$county,
                nchar(unemployment$county) - 9, nchar(unemployment$county) - 4) ==
                "County"], 1, nchar(unemployment$county[substr(unemployment$county,
                nchar(unemployment$county) - 9, nchar(unemployment$county) - 4) ==
                "County"]) - 11)

education = data.frame(read_excel("Education.xls"))
education = education[education$State %in% c("AZ", "NM", "TX"), ]
education = rename(education, state = State, county = Area.name)
education$county[substr(education$county, nchar(education$county) - 5,
                        nchar(education$county)) == "County"] =
            substr(education$county[substr(education$county, nchar(education$county)
            - 5, nchar(education$county)) == "County"], 1,
            nchar(education$county[substr(education$county, nchar(education$county)
            - 5, nchar(education$county)) == "County"]) - 7)

population = data.frame(read_excel("PopulationEstimates.xls"))
population = population[population$State %in% c("AZ", "NM", "TX"), ]
population = rename(population, state = State, county = Area_Name)
population$county[substr(population$county, nchar(population$county) - 5,
                         nchar(population$county)) == "County"] =
              substr(population$county[substr(population$county,
              nchar(population$county) - 5, nchar(population$county)) == "County"], 1,
              nchar(population$county[substr(population$county, nchar(population$county)
              - 5, nchar(population$county)) == "County"]) - 7)

# Step 6

demo0<-read.csv("ArizonaDemographics.csv",header=T)
demo1<-read.csv("NewMexicoDemographics.csv",header=T)
demo2<-read.csv("TexasDemographics.csv",header=T)
demo0<-rbind(demo0,demo1,demo2)
used.col <-
  c('STNAME','CTYNAME','AGEGRP','TOT_POP','TOT_MALE','TOT_FEMALE',
    'WA_MALE','WA_FEMALE','BA_MALE','BA_FEMALE','AA_MALE','AA_FEMALE',
    'H_MALE','H_FEMALE')
demo<- demo0[demo0$YEAR==11,]
demo<- demo[, used.col]
total <- demo[demo$AGEGRP==0,];
Pmale<- total$TOT_MALE/total$TOT_POP
Pwhite<- (total$WA_MALE+total$WA_FEMALE)/total$TOT_POP
Pblack<- (total$BA_MALE+total$BA_FEMALE)/total$TOT_POP
Pasian<- (total$AA_MALE+total$AA_FEMALE)/total$TOT_POP
Phispanic<- (total$H_MALE+total$H_FEMALE)/total$TOT_POP
age<-matrix(demo[, 4], ncol=19,byrow=T)
Page<- as.data.frame(age[,-1]/age[,1]);
colnames(Page)= c(paste0("Page", 1:18))
demoData<-cbind(total[c(1, 2, 4)], Pmale, Pwhite, Pblack, Pasian,
                Phispanic, Page);

demo = demoData
demo = rename(demo, state = STNAME, county = CTYNAME)
demo$county = as.character(demo$county)
demo$state = as.character(demo$state)
demo$county[23] = "Dona Ana County"
demo$county = substr(demo$county, 1, nchar(demo$county) - 7)
demo$state[demo$state == "Arizona"] = "AZ"
demo$state[demo$state == "New Mexico"] = "NM"
demo$state[demo$state == "Texas"] = "TX"

# Step 7

az.max = read.csv("ArizonaMaxTemp.csv", skip = 3, header = TRUE)
az.min = read.csv("ArizonaMinTemp.csv", skip = 3, header = TRUE)
az.prc = read.csv("ArizonaPrecip.csv", skip = 3, header = TRUE)
az = cbind("AZ", as.character(az.max$Location), az.max$Value, az.min$Value, az.prc$Value)
colnames(az) = c("state", "county", "Max Temp", "Min Temp", "Precip")

nm.max = read.csv("NewMexicoMaxTemp.csv", skip = 3, header = TRUE)
nm.min = read.csv("NewMexicoMinTemp.csv", skip = 3, header = TRUE)
nm.prc = read.csv("NewMexicoPrecip.csv", skip = 3, header = TRUE)
nm = cbind("NM", as.character(nm.max$Location), nm.max$Value, nm.min$Value, nm.prc$Value)
colnames(nm) = c("state", "county", "Max Temp", "Min Temp", "Precip")

tx.max = read.csv("TexasMaxTemp.csv", skip = 3, header = TRUE)
tx.min = read.csv("TexasMinTemp.csv", skip = 3, header = TRUE)
tx.prc = read.csv("TexasPrecip.csv", skip = 3, header = TRUE)
tx = cbind("TX", as.character(tx.max$Location), tx.max$Value, tx.min$Value, tx.prc$Value)
colnames(tx) = c("state", "county", "Max Temp", "Min Temp", "Precip")

weather = data.frame(rbind(az, nm, tx))
weather$state = as.character(weather$state)
weather$county = as.character(weather$county)

weather$county[substr(weather$county, nchar(weather$county) - 5,
                      nchar(weather$county)) == "County"] =
        substr(weather$county[substr(weather$county, nchar(weather$county) - 5,
        nchar(weather$county)) == "County"], 1,
        nchar(weather$county[substr(weather$county, nchar(weather$county) - 5,
        nchar(weather$county)) == "County"]) - 7)

# Merging data by state and county

yourcombineddata = merge(covid, poverty, by = c("state", "county"))
yourcombineddata = merge(yourcombineddata, unemployment, by = c("state", "county"))
yourcombineddata = merge(yourcombineddata, education, by = c("state", "county"))
yourcombineddata = merge(yourcombineddata, population, by = c("state", "county"))
yourcombineddata = merge(yourcombineddata, demo, by = c("state", "county"))
yourcombineddata = merge(yourcombineddata, weather, by = c("state", "county"))
yourcombineddata$Med_HH_Income_2018 = as.numeric(gsub('\\$|,', '',
                                       yourcombineddata$Med_HH_Income_2018))

yourcombineddata$state = as.factor(yourcombineddata$state)
yourcombineddata$Max.Temp = as.numeric(yourcombineddata$Max.Temp)
yourcombineddata$Min.Temp = as.numeric(yourcombineddata$Min.Temp)
yourcombineddata$Precip = as.numeric(yourcombineddata$Precip)

write.csv(x = yourcombineddata, file = "combineddata.csv", row.names = FALSE)

# Analysis

library(lme4)

stdz = function(x) (x - mean(x)) / sd(x) # standardize the predictors

case.model = glmer(cases ~ state + stdz(Page1) + stdz(Page2) + stdz(Page3) +
                     stdz(Page4) + stdz(Page5) + stdz(Page6) + stdz(Page7) + stdz(Page8) +
                     stdz(Page9) + stdz(Page10) + stdz(Page11) + stdz(Page12) + stdz(Page13) +
                     stdz(Page14) + stdz(Page15) + stdz(Page16) + stdz(Page17) + stdz(Pmale) +
                     stdz(Pwhite) + stdz(Pblack) + stdz(Pasian) + stdz(Phispanic) +
                     stdz(Max.Temp) + stdz(Min.Temp) + stdz(Precip) + stdz(PpovertyALL_2018) +
                     stdz(Ppoverty017_2018) + stdz(Unemployment_rate_2018) +
                     stdz(Med_HH_Income_2018) + stdz(Med_HH_Income_vs_Total_2018) +
                     stdz(Pnohighschool1418) + stdz(Phighschool1418) + stdz(Psomecollege1418) +
                     stdz(Pcollege1418) + (1 + stdz(date) | county), nAGQ = 0L, offset =
                     TOT_POP/1000000, data = yourcombineddata, family = poisson)

summary(case.model)

death.model = glmer(deaths ~ state + stdz(Page1) + stdz(Page2) + stdz(Page3) +
                      stdz(Page4) + stdz(Page5) + stdz(Page6) + stdz(Page7) + stdz(Page8) +
                      stdz(Page9) + stdz(Page10) + stdz(Page11) + stdz(Page12) + stdz(Page13) +
                      stdz(Page14) + stdz(Page15) + stdz(Page16) + stdz(Page17) + stdz(Pmale) +
                      stdz(Pwhite) + stdz(Pblack) + stdz(Pasian) + stdz(Phispanic) +
                      stdz(Max.Temp) + stdz(Min.Temp) + stdz(Precip) + stdz(PpovertyALL_2018) +
                      stdz(Ppoverty017_2018) + stdz(Unemployment_rate_2018) +
                      stdz(Med_HH_Income_2018) + stdz(Med_HH_Income_vs_Total_2018) +
                      stdz(Pnohighschool1418) + stdz(Phighschool1418) + stdz(Psomecollege1418) +
                      stdz(Pcollege1418) + (1 + stdz(date) | county), nAGQ = 0L, offset = (cases +
                                                                                             0.5)/1000000, data = yourcombineddata, family = poisson)

summary(death.model)




















