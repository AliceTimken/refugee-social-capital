# Annaul Refugee Survey R script


#### NOTE: Reorganize so regressions come after variable creation

# install and use ggplot2 graphing library
# install.packages("ggplot2")
library(ggplot2)
library(scales)

# install and use variable and value editing libraries
#install.packages("Hmisc")
library(Hmisc)
#install.packages("expss")
library(expss)
#install.packages("dplyr")
library(dplyr)

# install.packages("sjPlot")
library(sjPlot)
# install.packages("sjmisc")
library(sjmisc)
theme_set(theme_sjplot() + legend_style(inside=TRUE))

# Import ACS data
# file name and location may change
# ACS 2017 data from IPUMS USA
# N= 3,190,040; 36 variables
rawdata <- read.csv("~/Desktop/usa_00003.csv",
                   header = TRUE)
#Describe the variable Birthplace (BPLD)
describe(rawdata$BPLD)

# Calculate co-national/co-state population IN EACH STATE
rawdata <- rawdata %>% add_count(STATEICP, BPLD)
var_lab(rawdata$n) = "Co-national (or co-US state) Population"

# Remove only US-born respondents
# BPLD Codes here: https://usa.ipums.org/usa-action/variables/BPLD#codes_section
# N= 840,365 ; 28 variables ; 13.24% of total ACS resopndents
# immdata <- subset(rawdata, BPLD>=100 & AGE>= 18)

# Remove all US-born respondents, under 18 yrs, and immigrants who have been in the country over 10 years
# BPLD Codes here: https://usa.ipums.org/usa-action/variables/BPLD#codes_section
# N= 83,858; 36 variables
mydata <- subset(rawdata, BPLD>5600 & AGE>=16 & HHINCOME<=500000)

# Original dataset holds 5079 Obs, 253 variables
head(rawdata)
summary(rawdata)
sapply(rawdata, class)

# Unemployment rates
StateUnemp <- read.csv("~/Desktop/BLS State Unemployment rates 2016.csv",
                    header = TRUE)

###################### Label/prep data ##################


## Sample/Literature variables
var_lab(mydata$BPLD) = "Birthplace" #Country of Origin
var_lab(mydata$YRIMMIG) = "Year Immigrated"
var_lab(mydata$YRSUSA1) = "Years in the US"
var_lab(mydata$MIGPLAC1) = "Place of residence 1 year ago"
var_lab(mydata$EDUC) = "Educational attainment"
var_lab(mydata$REGION) = "Region"
var_lab(mydata$STATEICP) = "State"
# age of arrival (Age - Years in the US)


## Control variables
var_lab(mydata$SEX) = "Gender"
var_lab(mydata$AGE) = "Age"

## Integration variables
#### Linguistic Integration
# English ability: https://usa.ipums.org/usa-action/variables/SPEAKENG#description_section
var_lab(mydata$SPEAKENG) = "English Ability"

#### Navigational Integration
# Binary Insurace variable: https://usa.ipums.org/usa-action/variables/HCOVANY#description_section
var_lab(mydata$HCOVANY) = "Has health insurance"
# Access to the Internet: https://usa.ipums.org/usa-action/variables/CINETHH#description_section
var_lab(mydata$CINETHH) = "Has internet access"

#### Economic Integration
# Employment 
var_lab(mydata$EMPSTAT) = "Employment Status" #Employed, Unemployed, Not in Workforce
# Family income: https://usa.ipums.org/usa-action/variables/FTOTINC#description_section
var_lab(mydata$FTOTINC) = "Family Income" #Scaled 7-pt scale
# Household income: https://usa.ipums.org/usa-action/variables/HHINCOME#codes_section
var_lab(mydata$HHINCOME) = "Household Income" #Scaled 7-pt scale


### Explanatory Variables
# Co-national network size, by state
# State unemployment rate at arrival


# Plots: https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html



## Control Variables

# Gender; Male 1, Female 2
describe(mydata$SEX)
# Create Male Dummy
mydata$Male[mydata$SEX==1]<-1
mydata$Male[mydata$SEX==2]<-0
describe(mydata$Male)

# Age
describe(mydata$AGE)

# Age at arrival
mydata$AGEARRIV <- mydata$AGE - mydata$YRSUSA1
var_lab(mydata$EMPSTAT) = "Age at arrival"
describe(mydata$AGEARRIV)
hist(mydata$AGEARRIV)


## LOCATION DATA ##
# https://usa.ipums.org/usa-action/variables/BPL#description_section
# Code Birthplace data (BPL)
class(mydata$BPLD)
var_lab(mydata$BPLD) = "Birthplace"
val_lab(mydata$BPLD) = num_lab("
                               100	Alabama
                               200	Alaska
                               400	Arizona
                               500	Arkansas
                               600	California
                               800	Colorado
                               900	Connecticut
                               1000	Delaware
                               1100	District of Columbia
                               1200	Florida
                               1300	Georgia
                               1500	Hawaii
                               1600	Idaho
                               1700	Illinois
                               1800	Indiana
                               1900	Iowa
                               2000	Kansas
                               2100	Kentucky
                               2200	Louisiana
                               2300	Maine
                               2400	Maryland
                               2500	Massachusetts
                               2600	Michigan
                               2700	Minnesota
                               2800	Mississippi
                               2900	Missouri
                               3000	Montana
                               3100	Nebraska
                               3200	Nevada
                               3300	New Hampshire
                               3400	New Jersey
                               3500	New Mexico
                               3600	New York
                               3700	North Carolina
                               3800	North Dakota
                               3900	Ohio
                               4000	Oklahoma
                               4100	Oregon
                               4200	Pennsylvania
                               4400	Rhode Island
                               4500	South Carolina
                               4600	South Dakota
                               4700	Tennessee
                               4800	Texas
                               4900	Utah
                               5000	Vermont
                               5100	Virginia
                               5300	Washington
                               5400	West Virginia
                               5500	Wisconsin
                               5600	Wyoming
                               10000	American Samoa
                               10010	Samoa, 1940-1950
                               10500	Guam
                               11000	Puerto Rico
                               11500	U.S. Virgin Islands
                               15000	Canada
                               16010	Bermuda
                               16020	Cape Verde
                               20000	Mexico
                               21010	Belize/British Honduras
                               21020	Costa Rica
                               21030	El Salvador
                               21040	Guatemala
                               21050	Honduras
                               21060	Nicaragua
                               21070	Panama
                               25000	Cuba
                               26010	Dominican Republic
                               26020	Haiti
                               26030	Jamaica
                               26042	Antigua-Barbuda
                               26043	Bahamas
                               26044	Barbados
                               26054	Dominica
                               26055	Grenada
                               26057	St. Kitts-Nevis
                               26058	St. Lucia
                               26059	St. Vincent
                               26060	Trinidad and Tobago
                               26091	Caribbean, n.s. / n.e.c.
                               26094	West Indies, n.s.
                               29900	Americas, n.s.
                               30005	Argentina
                               30010	Bolivia
                               30015	Brazil
                               30020	Chile
                               30025	Colombia
                               30030	Ecuador
                               30040	Guyana/British Guiana
                               30045	Paraguay
                               30050	Peru
                               30060	Uruguay
                               30065	Venezuela
                               30090	South America, n.s.
                               40000	Denmark
                               40100	Finland
                               40200	Iceland
                               40400	Norway
                               40500	Sweden
                               41000	England
                               41100	Scotland
                               41300	United Kingdom, n.s./n.e.c.
                               41400	Ireland
                               41410	Northern Ireland
                               42000	Belgium
                               42100	France
                               42500	Netherlands
                               42600	Switzerland
                               43000	Albania
                               43300	Greece
                               43330	Macedonia
                               43400	Italy
                               43600	Portugal
                               43610	Azores
                               43800	Spain
                               45000	Austria
                               45100	Bulgaria
                               45200	Czechoslovakia
                               45212	Slovakia
                               45213	Czech Republic
                               45300	Germany
                               45400	Hungary
                               45500	Poland
                               45600	Romania
                               45700	Yugoslavia
                               45710	Croatia
                               45720	Montenegro
                               45730	Serbia
                               45740	Bosnia
                               45790	Kosovo
                               46100	Latvia
                               46200	Lithuania
                               46500	Other USSR/Russia
                               46510	Byelorussia
                               46520	Moldavia
                               46530	Ukraine
                               46540	Armenia
                               46541	Azerbaijan
                               46542	Republic of Georgia
                               46543	Kazakhstan
                               46544	Kirghizia
                               46547	Uzbekistan
                               46590	USSR, n.s./n.e.c.
                               49900	Europe, n.s.
                               50000	China
                               50010	Hong Kong
                               50030	Mongolia
                               50040	Taiwan
                               50100	Japan
                               50200	Korea
                               51100	Cambodia (Kampuchea)
                               51200	Indonesia
                               51300	Laos
                               51400	Malaysia
                               51500	Philippines
                               51600	Singapore
                               51700	Thailand
                               51800	Vietnam
                               52000	Afghanistan
                               52100	India
                               52110	Bangladesh
                               52120	Bhutan
                               52130	Burma (Myanmar)
                               52140	Pakistan
                               52150	Sri Lanka (Ceylon)
                               52200	Iran
                               52400	Nepal
                               53200	Iraq
                               53400	Israel/Palestine
                               53500	Jordan
                               53600	Kuwait
                               53700	Lebanon
                               54000	Saudi Arabia
                               54100	Syria
                               54200	Turkey
                               54300	United Arab Emirates
                               54400	Yemen Arab Republic (North)
                               59900	Asia, n.e.c./n.s.
                               60011	Algeria
                               60012	Egypt/United Arab Rep.
                               60013	Libya
                               60014	Morocco
                               60015	Sudan
                               60016	Tunisia
                               60022	Gambia
                               60023	Ghana
                               60024	Guinea
                               60026	Ivory Coast
                               60027	Liberia
                               60031	Nigeria
                               60032	Senegal
                               60033	Sierra Leone
                               60034	Togo
                               60038	Western Africa, n.s.
                               60044	Ethiopia
                               60045	Kenya
                               60051	Rwanda
                               60053	Somalia
                               60054	Tanzania
                               60055	Uganda
                               60056	Zambia
                               60057	Zimbabwe
                               60064	Eastern Africa, n.e.c./n.s.
                               60065	Eritrea
                               60066	South Sudan
                               60072	Cameroon
                               60075	Congo
                               60079	Zaire
                               60094	South Africa (Union of)
                               60099	Africa, n.s./n.e.c.
                               70010	Australia
                               70020	New Zealand
                               71015	Fiji
                               71023	Tonga
                               71041	Marshall Islands
                               71042	Micronesia
                               71047	Northern Mariana Islands
                               95000	Other n.e.c.
                      ")
## Continue labeling countries
drop_var_labs(mydata$BPLD)
describe(mydata$BPLD)
hist(mydata$BPLD, col ='skyblue3', breaks = 120)


# Describe state
describe(rawdata$STATEICP)
hist(rawdata$STATEICP, col ='skyblue3', breaks = 98)

# Code State data
# Codes here https://usa.ipums.org/usa-action/variables/STATEICP#codes_section
class(mydata$STATEICP)
var_lab(mydata$STATEICP) = "State"
val_lab(mydata$STATEICP) = num_lab("
1 CT
2 ME
3 MA    
4 NH
5 RI
6 VT
11 DE
12 NJ
13 NY
14 PA
21 IL
22 IN
23 MI
24 OH
25 WI
31 IA
32 KS
33 MN
34 MO
35 NE
36 ND
37 SD
40 VA
41 AL
42 AR
43 FL
44 GA
45 LA
46 MS
47 NC
48 SC
49 TX
51 KY
52 MD
53 OK
54 TN
56 WV
61 AZ
62 CO
63 ID
64 MT
65 NV
66 NM
67 UT
68 WY
71 CA
72 OR
73 WA
81 AK
82 HI
98 DC
     ")
drop_var_labs(mydata$STATEICP)
use_labels(mydata, table(STATEICP, BPLD))
summary(mydata$STATEICP)
describe(mydata$STATEICP)
hist(mydata$STATEICP, col ='skyblue3', breaks = 98)

# State Unemployment Rate 2016
# Dataframe: StateUnemp
# From US BLS: https://www.bls.gov/lau/lastrk16.htm
mydata$STATEUNEMP <- StateUnemp$STATEUNEMP[match(mydata$STATEICP, StateUnemp$STATEICP)]
mydata$STATEEMP <- 100-(mydata$STATEUNEMP)
describe(mydata$STATEUNEMP)
describe(mydata$STATEEMP)
UnempStates <- hist(StateUnemp$STATEUNEMP, breaks = 28)
ImmUnempPop <- hist(mydata$STATEUNEMP, breaks = 28)
plot(UnempStates, col = 'skyblue')
plot(ImmUnempPop, col = 'red')

# Region data
describe(mydata$REGION)
hist(mydata$REGION, breaks = 43)
# create dummy variable for Northeast
mydata$Northeast[mydata$REGION==11]<-1
mydata$Northeast[mydata$REGION==12]<-1
mydata$Northeast[mydata$REGION>=13]<-0
# create dummy variable for West
mydata$West[mydata$REGION==41]<-1
mydata$West[mydata$REGION==42]<-1
mydata$West[mydata$REGION<=40]<-0
# create dummy for Midwest
mydata$Midwest[mydata$REGION==21]<-1
mydata$Midwest[mydata$REGION==22]<-1
mydata$Midwest[mydata$REGION<=20]<-0
mydata$Midwest[mydata$REGION>=23]<-0
# create dummy for South
mydata$South[mydata$REGION==31]<-1
mydata$South[mydata$REGION==32]<-1
mydata$South[mydata$REGION==33]<-1
mydata$South[mydata$REGION<=30]<-0
mydata$South[mydata$REGION>=34]<-0



#### English Liguistic Integration variable
class(mydata$SPEAKENG)
val_lab(mydata$SPEAKENG) = num_lab("
1 Does not speak English
3 Yes, speaks only English    
4 Yes, speaks very well
5 Yes, speaks well
6 yes, but not well
     ")
drop_var_labs(mydata$SPEAKENG)
describe(mydata$SPEAKENG)
hist(mydata$SPEAKENG)

# Recode english variable
mydata$SPEAKENGrecode[mydata$SPEAKENG==1]<-1
mydata$SPEAKENGrecode[mydata$SPEAKENG==6]<-2
mydata$SPEAKENGrecode[mydata$SPEAKENG==5]<-3
mydata$SPEAKENGrecode[mydata$SPEAKENG==4]<-4
mydata$SPEAKENGrecode[mydata$SPEAKENG==3]<-5
val_lab(mydata$SPEAKENG) = num_lab("
1 Does not speak English
2 Yes, but not well
3 Yes, speaks well
4 Yes, speaks very well
5 Yes, speaks only English  
     ")
hist(mydata$SPEAKENGrecode)
# Create IPL Linguistic Integration Score
mydata$IPLLING <- mydata$SPEAKENGrecode*2
hist(mydata$IPLLING)

use_labels(mydata, table(SPEAKENG, BPLD))

## HH Income
describe(mydata$HHINCOME)
## Recode as new variable
mydata$HHINCOMErecode<-mydata$HHINCOME
mydata$HHINCOMErecode[mydata$HHINCOME==9999999]<-NA
describe(mydata$HHINCOMErecode)
hist(mydata$HHINCOMErecode, col ='skyblue3', breaks = 100)
# mydata[order(-mydata$HHINCOMErecode),]

## HH Income Category (Integration, from Harder)
#  Use country’s gross median equivalized household (gmeh) income is then used to create 5 categories: 
# – [0, gmeh/3] (1)
# – ((gmeh/3), (gmeh/1.5)] (2)
# – ((gmeh/1.5), gmeh] (3)
# – (gmeh, gmeh + (gmeh/3)] (4) 
# – > gmeh + (gmeh/3) (5)
# 2018 median income was <<    $63,179  >>
# From https://www.census.gov/library/stories/2019/09/us-median-household-income-not-significantly-different-from-2017.html
cat1 <- 63179/3
cat2 <- 63179/1.5
cat3 <- 63179
cat4 <- (63179+ 63179/3)
describe(cat4)
# mutate(mydata$INCCAT = case_when(HHINCOMErecode <= cat1 ~ 1,
 #                                                     HHINCOMErecode > cat1 & HHINCOMErecode <= cat2 ~ 2,
  #                                                    HHINCOMErecode > cat2 & HHINCOMErecode <= cat3 ~ 3,
   #                                                   HHINCOMErecode > cat3 & HHINCOMErecode <= cat4 ~ 4,
    #                                                  HHINCOMErecode > cat4 ~ 5))
mydata$INCCAT[mydata$HHINCOMErecode <= cat1] <- 1
mydata$INCCAT[mydata$HHINCOMErecode > cat1 & mydata$HHINCOMErecode <= cat2 ] = 2
mydata$INCCAT[mydata$HHINCOMErecode > cat2 & mydata$HHINCOMErecode <= cat3 ] = 3
mydata$INCCAT[mydata$HHINCOMErecode > cat3 & mydata$HHINCOMErecode <= cat4 ] = 4
mydata$INCCAT[mydata$HHINCOMErecode > cat4 ] = 5
describe(mydata$INCCAT)


## Employment Status
describe(mydata$EMPSTAT)
# Recode EMPSTAT
mydata$EMPSTATrecode[mydata$EMPSTAT==1]<-5
mydata$EMPSTATrecode[mydata$EMPSTAT==2]<-1
mydata$EMPSTATrecode[mydata$EMPSTAT==3]<-3
val_lab(mydata$EMPSTATrecode) = num_lab("
5 Employed
3 Not in labor force
1 unemployed
     ")
hist(mydata$EMPSTATrecode)

# IPL Economic Integration score
mydata$IPLECON <- mydata$EMPSTATrecode + mydata$INCCAT
hist(mydata$IPLECON)

# Recode EDUC
describe(mydata$EDUC)
hist(mydata$EDUC)
mydata$EDUC[mydata$EDUC==10]<-9
mydata$EDUC[mydata$EDUC==11]<-10
# 00	N/A or no schooling ; 01	Nursery school to grade 4	; 02	Grade 5, 6, 7, 8
# 03	Grade 9 ;04	Grade 10	; 05	Grade 11	; 06	Grade 12	; 07	1 year of college
# 08	2 years of college ; 9	4 years of college; 10	5+ years of college
hist(mydata$EDUC)
val_lab(mydata$EDUC) = num_lab("
0 No Schooling or NA
1 Nursery to grade 4
2 Grade 5, 6, 7
3 Grade 9
4 Grade 10
5 Grade 11
6 Grade 12
7 1 year of college
8 2 years of college
9 4 years of college
10 5+ years of college
     ")

# Navigational

# Recode internet access measure
# CINETHH reports whether any member of the household accesses the Internet.
# https://usa.ipums.org/usa-action/variables/CINETHH#description_section
# 0	N/A (GQ)
# 1 Yes, with a subscription to an Internet Service 
# 2	Yes, without a subscription to an Internet Service
# 3	No Internet access at this house, apartment, or mobile home
describe(mydata$CINETHH)
# Recode EMPSTAT
mydata$CINETHHrecode[mydata$CINETHH==1]<-5
mydata$CINETHHrecode[mydata$CINETHH==3]<-1
mydata$CINETHHrecode[mydata$CINETHH==2]<-3
val_lab(mydata$CINETHHrecode) = num_lab("
                                        5 Yes, access through subscription
                                        3 Yes, without a subscription
                                        1 No Internet access
                                        ")
hist(mydata$CINETHHrecode)

# Healthcare coverage / HCOVANY
# https://usa.ipums.org/usa-action/variables/HCOVANY#description_section
# 1	No health insurance coverage
# 2	With health insurance coverage
describe(mydata$HCOVANY)
# Recode EMPSTAT
mydata$HCOVANYdummy[mydata$HCOVANY==1]<-0
mydata$HCOVANYdummy[mydata$HCOVANY==2]<-1
val_lab(mydata$HCOVANYdummy) = num_lab("
                                        1 Yes, health insurance coverage
                                        0 No coverage
                                        ")
hist(mydata$HCOVANYdummy)

# Different weight for healthcare
mydata$HCOVANYdummy2[mydata$HCOVANY==1]<-1
mydata$HCOVANYdummy2[mydata$HCOVANY==2]<-5
val_lab(mydata$HCOVANYdummy2) = num_lab("
                                        1 Yes, health insurance coverage
                                       0 No coverage
                                       ")
hist(mydata$HCOVANYdummy2)

#Make composite IPL navigation score
mydata$IPLNAV <- mydata$CINETHHrecode + mydata$HCOVANYdummy
hist(mydata$CINETHHrecode)
hist(mydata$IPLNAV)

# New weight IPLNAV
mydata$IPLNAV2 <- mydata$CINETHHrecode + mydata$HCOVANYdummy2
hist(mydata$IPLNAV2)


# Co-national population
# ****** FREQUENCY IS WRONG ********
StateBPLDtable <- table(rawdata$STATEICP,rawdata$BPLD) # A will be rows, B will be columns
StateBPLDtable
prop.table(StateBPLDtable, 2) #print table with frquencies
# Create dataset for frequency of co-nationals
#bplnew2 <- rawdata %>% add_count(STATEICP, BPL)
#bplnew <- group_by(rawdata, BPL)
#bplnew2 <- group_vars(bplnew)

StateBPLDData <- as.data.frame(StateBPLDtable)
var_lab(StateBPLDData$Var1) = "State"
var_lab(StateBPLDData$Var2) = "Birthplace"
write.csv(StateBPLDData,'StateBPLData 11.19.csv')
# StateBPLDData$BPLDsum <- sum(StateBPLDData$Var2(1,50))
# Create dataset of total populations
BPLDTotals <- aggregate(StateBPLDData$Freq, by=list(BPLD=StateBPLDData$Var2), FUN=sum)
BPLDTotals
# Produce excel of BPLD Totals
var_lab(BPLDTotals$x) = "Total from BPLD location in US"
mydata$CONATtot <- BPLDTotals$x[match(mydata$BPLD, BPLDTotals$BPLD)]
mydata$CONATprop <- (mydata$n/mydata$CONATtot)
describe(mydata$CONATprop)

# Make co-national prop quintile categories
quantile(mydata$CONATprop, probs = seq(0, 1, 1/5))
# Quintiles 0% // 20%  40%  60%  80% 100% 
# 3.32513134268804e-05 // 0.0203498038172508, 0.0543347017628592, 0.172519866700846, 0.375291375291375, 0.820645161290323
mydata$CONATQUIN[mydata$CONATprop < 0.0203498038172508] <- 1
mydata$CONATQUIN[mydata$CONATprop >= 0.0203498038172508 & mydata$CONATprop < 0.0543347017628592 ] = 2
mydata$CONATQUIN[mydata$CONATprop >= 0.0543347017628592 & mydata$CONATprop < 0.172519866700846 ] = 3
mydata$CONATQUIN[mydata$CONATprop >= 0.172519866700846 & mydata$CONATprop < 0.375291375291375 ] = 4
mydata$CONATQUIN[mydata$CONATprop >= 0.375291375291375 ] = 5
hist(mydata$CONATQUIN)

# Subset of data for arrival since 2008
rawdata200817 <- subset(rawdata, YRIMMIG>=2008)
# **** ^ yay
StateBPLDtable200817 <- table(rawdata200817$STATEICP,rawdata200817$BPLD) # A will be rows, B will be columns
prop.table(StateBPLDtable, 2) #print table with frquencies
# Create dataset for frequency of co-nationals


# State data for determining refugee likelihoods
StateBPLDData200817 <- as.data.frame(StateBPLDtable200817)
var_lab(StateBPLDData200817$Var1) = "State"
var_lab(StateBPLDData200817$Var2) = "Birthplace"
# StateBPLDData$BPLDsum <- sum(StateBPLDData$Var2(1,50))
# Create dataset of total populations
BPLDTotals200817 <- aggregate(StateBPLDData200817$Freq, by=list(BPLD=StateBPLDData200817$Var2), FUN=sum)
BPLDTotals200817
write.csv(BPLDTotals200817,'BPLD Totals 2008-2017.csv')


# Proportion of total co-national population (US) contained in that state

# StateBPLDData$CONATPROP <- (StateBPLDData$Freq/StateBPLDData$CONATTOT)
# var_lab(StateBPLDData$CONATPROP) = "Co-national population proportion (absolute)"
# summary(StateBPLDData$CONATPROP)
# describe(StateBPLDData$CONATPROP)
#hist(StateBPLDData$CONATPROP)

# Proportion of total co-national population (US) contained in that state
#StateBPLDData$CONATPROP <- (StateBPLDData$Freq/StateBPLDData$CONATTOT)*10
#var_lab(StateBPLDData$CONATPROP) = "Co-national population proportion (absolute)"
#summary(StateBPLDData$CONATPROP)
# Add State Co-national Proportion to mydata
# Dataframe: StateBPLDData
# From rawdata dataset, ACS [Year]
# mydata$CONATPROP <- StateBPLDData$CONATPROP[match(mydata$STATEICP, StateBPLDData$Var1) & match(mydata$BPLD, StateBPLDData$Var2)]
# summary(mydata$CONATPROP)
# describe(mydata$CONATPROP)
# hist(mydata$CONATPROP)



# Create Interactive Variable - CONTINUOUS
mydata$CONATint <- mydata$CONATprop * mydata$STATEEMP
hist(mydata$CONATint)
# Create Iteractive Variable - QUINTILE
mydata$CONATQUINint <- mydata$CONATQUIN * mydata$STATEEMP
hist(mydata$CONATQUINint)



################# Data Subsets ####################

# Create refugee data subset
# Only for 
# 52120	Bhutan
# 52130	Burma (Myanmar)
# 60075	Congo
# 60065	Eritrea
# 53200	Iraq
# 60066	South Sudan
# 60053	Somalia
# 60015	Sudan
# 54100	Syria
refugeedata <- subset(mydata, YRIMMIG>=2008 & (BPLD==52120 | BPLD==52130 | BPLD==60075 | BPLD==60065 | BPLD==53200 | BPLD==60066 | BPLD==60053 | BPLD==60015 | BPLD==54100))
# Create nonrefugee data subset (mydata minus refugee subset)
nonrefugeedata <- subset(mydata, YRIMMIG>=2008 & (BPLD!=52120 | BPLD!=52130 | BPLD!=60075 | BPLD!=60065 | BPLD!=53200 | BPLD!=60066 | BPLD!=60053 | BPLD!=60015 | BPLD!=54100))
# Create all data pre-internet subset (not used in final regression)
preinternetdata <- subset(mydata, YRIMMIG<=1994)



########################## REGRESSIONS ##########################


########### Economic Integration ##############
# Refugee Econ Only
reg50 <- lm(IPLECON ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg50)
reg60 <- lm(IPLECON ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg60)
############## Non refugees
reg51 <- lm(IPLECON ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg51)
reg61 <- lm(IPLECON ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg61)
##############  Pre internet
reg40 <- lm(IPLECON ~ CONATint + STATEEMP + CONATprop + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=preinternetdata)
summary(reg40)
### Quintile all data
reg53 <- lm(IPLECON ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg53)
reg63 <- lm(IPLECON ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg63)
# Interactive Plots for Economic Integration
p1 <- plot_model(reg60, type = "int") # ALSO: type=pred, terms = c("STATEEMP", "CONATQUIN [1,2,3,4]"))
p1 + labs(title = "Predicted Values of Economic Integration", subtitle = "Refugee Data (2008-17)", x="State Employment Rate", y="Linguistic Integration") # + theme(legend.title = element_text("Co-national Quintile"))
p2 <- plot_model(reg61, type = "int")
p2 + labs(title = "Predicted Values of Economic Integration", subtitle = "Non-refugee Data (2008-17)", x="State Employment Rate", y="Linguistic Integration") # + theme(legend.title = element_text("Co-national Quintile"))
p3 <- plot_model(reg63, type = "int")
p3 + labs(title = "Predicted Values of Economic Integration", subtitle = "All Immigrant Data ( -2017)", x="State Employment Rate", y="Linguistic Integration") # + theme(legend.title = element_text("Co-national Quintile"))



################# Linguistic Integration ########################
# All Immigrants - Linguistic Integration
reg56 <- lm(SPEAKENGrecode ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg56)
# Refugee only data - Linguistic Integration
reg54 <- lm(SPEAKENGrecode ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg54)
# non refugee data - Linguistic Integration
reg55 <- lm(SPEAKENGrecode ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg55)

# Linguistic integration interactive effect regressions (STATEEMP*CONATQUIN)
# refugee
reg64 <- lm(SPEAKENGrecode ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg64)
# nonrefugee
reg65 <- lm(SPEAKENGrecode ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg65)
# all immigrants
reg66 <- lm(SPEAKENGrecode ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg66)
# Linguistic Integration Interactive Plots
p4 <- plot_model(reg64, type = "int") #type = "pred", terms = c("STATEEMP", "CONATQUIN [1,2,3,4]"))
p4 + labs(title = "Predicted Values of Linguistic Integration", subtitle = "Refugee Data (2008-17)", x="State Employment Rate", y="Linguistic Integration") # + theme(legend.title = element_text("Co-national Quintile"))
p5 <- plot_model(reg65, type = "int")
p5 + labs(title = "Predicted Values of Linguistic Integration", subtitle = "Non-refugee Data (2008-17)", x="State Employment Rate", y="Linguistic Integration")
p6 <- plot_model(reg66, type = "int")
p6 + labs(title = "Predicted Values of Linguistic Integration", subtitle = "All Immigrant Data ( -2017)", x="State Employment Rate", y="Linguistic Integration")

#
#

##################### Navigational Integration ####################################

# Navigational integration REFUGEE ONLY restricted
reg57 <- lm(IPLNAV2 ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg57) ####
reg67 <- lm(IPLNAV2 ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=refugeedata)
summary(reg67)
# Navigational integration NONREFUGEE DATA restricted
reg58 <- lm(IPLNAV2 ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg58)
reg68 <- lm(IPLNAV2 ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=nonrefugeedata)
summary(reg68) 
# Navigational integration ALL DATA restricted using state employment rate
reg59 <- lm(IPLNAV2 ~ CONATQUINint + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg59)
reg69 <- lm(IPLNAV2 ~ (STATEEMP*CONATQUIN) + STATEEMP + CONATQUIN + AGE + Male + EDUC + YRSUSA1 + Northeast + Midwest + South, data=mydata)
summary(reg69)

# Nagivational integration interactive plots
p7 <- plot_model(reg67, type = "int")
p7 + labs(title = "Predicted Values of Navigational Integration", subtitle = "Refugee Data (2008-17)", x="State Employment Rate", y="Navigational Integration") # + theme(legend.title = element_text("Co-national Quintile"))
p8 <- plot_model(reg68, type = "int")
p8 + labs(title = "Predicted Values of Navigational Integration", subtitle = "Non-refugee Data (2008-17)", x="State Employment Rate", y="Navigational Integration") # + theme(legend.title = element_text("Co-national Quintile"))
p9 <- plot_model(reg69, type = "int")
p9 + labs(title = "Predicted Values of Navigational Integration", subtitle = "All Immigrant Data ( -2017)", x="State Employment Rate", y="Navigational Integration") # + theme(legend.title = element_text("Co-national Quintile"))

#
#
#

# Descriptive Statistics
############## Descriptive Statistics - Refugee Data
describe(refugeedata$IPLECON)
sd(refugeedata$IPLECON)
describe(refugeedata$SPEAKENGrecode)
sd(refugeedata$SPEAKENGrecode)
summary(refugeedata$IPLNAV2)
describe(refugeedata$IPLNAV2)
sd(refugeedata$IPLNAV2)
describe(refugeedata$CONATint)
sd(refugeedata$CONATint)
describe(refugeedata$CONATQUINint)
sd(refugeedata$CONATQUINint)
describe(refugeedata$CONATprop)
sd(refugeedata$CONATprop)
describe(refugeedata$STATEEMP)
sd(refugeedata$STATEEMP)
describe(refugeedata$AGE)
sd(refugeedata$AGE)
describe(refugeedata$Male)
sd(refugeedata$Male)
describe(refugeedata$EDUC)
sd(refugeedata$EDUC)
describe(refugeedata$YRSUSA1)
sd(refugeedata$YRSUSA1)

############# Descriptive Statistics - Non-Refugee Data
describe(nonrefugeedata$IPLECON)
sd(nonrefugeedata$IPLECON)
describe(nonrefugeedata$SPEAKENGrecode)
sd(nonrefugeedata$SPEAKENGrecode)
summary(nonrefugeedata$IPLNAV2)
describe(nonrefugeedata$IPLNAV2)
sd(nonrefugeedata$IPLNAV2)
describe(nonrefugeedata$CONATint)
sd(nonrefugeedata$CONATint)
describe(nonrefugeedata$CONATQUINint)
sd(nonrefugeedata$CONATQUINint)
describe(nonrefugeedata$CONATprop)
sd(nonrefugeedata$CONATprop)
describe(nonrefugeedata$STATEEMP)
sd(nonrefugeedata$STATEEMP)
describe(nonrefugeedata$AGE)
sd(nonrefugeedata$AGE)
describe(nonrefugeedata$Male)
sd(nonrefugeedata$Male)
describe(nonrefugeedata$EDUC)
sd(nonrefugeedata$EDUC)
describe(nonrefugeedata$YRSUSA1)
sd(nonrefugeedata$YRSUSA1)

################ Final regressions ###############
# Economic Integration
summary(reg50)
summary(reg51)
summary(reg53)
# Linguistic Integration 
summary(reg54)
summary(reg55)
summary(reg56)
# Navigational Integration 
summary(reg57)
summary(reg58)
summary(reg59)

#
#
#

########### Appendix - Histograms ##############
# Economic Integration Histograms
hg1.1 <- hist(refugeedata$IPLECON, freq = FALSE, ylim = c(0, 0.6), main = "Refugee Economic Integration (2008-17)", xlab = "Integration Score [2, 10]")
hg1.2 <- hist(nonrefugeedata$IPLECON,freq = FALSE, ylim = c(0, 0.6), main = "Nonrefugee Economic Integration (2008-17)", xlab = "Integration Score  [2, 10]")
hg1.3 <- hist(mydata$IPLECON,freq = FALSE, ylim = c(0, 0.6), main = "Economic Integration for All Immigrants", xlab = "Integration Score  [2, 10]")
# Linguistic Integration Historgrams
hg2.1 <- hist(refugeedata$SPEAKENGrecode,freq = FALSE, ylim = c(0, 2), main = "Refugee Linguistic Integration (2008-17)", xlab = "Integration Score [1, 5]")
hg2.2 <- hist(nonrefugeedata$SPEAKENGrecode,freq = FALSE, ylim = c(0, 2), main = "Nonrefugee Linguistic Integration (2008-17)", xlab = "Integration Score [1, 5]")
hg2.3 <- hist(mydata$SPEAKENGrecode,freq = FALSE, ylim = c(0, 2), main = "Linguistic Integration for All Immigrants", xlab = "Integration Score [1, 5]")
# Navigational Integration Histograms
hg3.1 <- hist(refugeedata$IPLNAV2, freq = FALSE, ylim = c(0, 1.75), main = "Refugee Navigational Integration (2008-17)", xlab = "Integration Score [2, 10]")
hg3.2 <- hist(nonrefugeedata$IPLNAV2, freq = FALSE, ylim = c(0, 1.75), main = "Nonrefugee Navigational Integration (2008-17)", xlab = "Integration Score [2, 10]")
hg3.3 <- hist(mydata$IPLNAV2, freq = FALSE, ylim = c(0, 1.75), main = "Navigational Integration for All Immigrants", xlab = "Integration Score [2, 10]")

#
#
#


#
#
#
#







#
#
#
#
#

