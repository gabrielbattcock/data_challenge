## Meeting Brief 2023-01-03T1115z

Influenza from diff data source, 

### q1: pre covid vs covid 

a1: gp cons, swabbing data, hosp, excess morts, ukhsa has those data linked

but not sure which ones are a good signal for the other

gp is importnat, but ppl don't come to doctors that much for flu anymore

post covid some clinical coding has changed

online gp cons is still part of the data, but people don't get tested, just autolly being classified as ILI

a lot less ppl being diagnosed as ILI and more Covid-like-illness

### q2 other data sources?

excess mortality

hosp - SARI dated to 2018, if you need more i can get access

getting data out of pdf

FluNet - swabbing data since 2016

### q3 geographical granularity

adapted to whatever level the data is given, most England only.

### q4 intended use of the results

fact finding mission

inform current models running

the main one I have is vaccine coverage / cost-ef

### q5 temporal granularity

pre pand | pandemic | current season

2017 - 2020 for `pre` make more sense

suggest just getting the data combined. Then if we have time to stratify it.

flu season starts ISO week 40 ~ week 20 y+1

### q6 format of output

presentation

### q7 model? 

not specified

### q8 lit review scope

cdc modelling papers, predictive

stats models try to capture seasonal outbreak

send links later

mainly use UKHSA data. can be complemented by US data

### q9 different flu subtype

H3N2 (main one in the UK), 

H1N1 (elderly, more resistant), 

<del>B (comes every two three yrs, can be massive, almost certainly won't have any data post pandemic)</del>

### q10 age

FluNet and hosp data are already stratified.

just broad categories would be enough - children, young adults, adults, elderly.

### q11 update frequency diff

assume linear . but most of the uptake data will be months before the actual flu



### q12 what's most important to you in the production

good understanding of methods

divided vaccine by paediatric vaccine, elderly, and ?? clinical risk group

if we can do predictions would be beneficial 

### misc.

it's expect children would fall first

its probably related to total hospital burden

vaccine ✅ in addition to the other required data source

NB that vaccine programme has changed post pandemic in terms of age coverage

now the fluNET data is a bit loose cuz people got swabbed for covid like illness as well

 ==we are slightly less interested in what actually happened to flu DURING the pandemic== 

### q13 describe temporal relationship

mainly delay between the two peak. 

amplitude (before and after the pandemic comparison), 

correlation

no need to assume MNAR

for swab data, don't forget the total number of swabs take

RCGP data only covers 10% of practices (not always the same) and there are DNRs

original hypothesis GP data to slightly lead the hosp data, at least for the beginning of season

H3N2 → impact 45-65yo adults mainly 

length of season

...

don't think there's good data on incubation period, not gonna be a problem so we can assume the same

purely academic output is fine. no need for executive summary. mainly just statistical interpretation

