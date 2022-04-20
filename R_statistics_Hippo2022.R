#Load packages
library(psych)
library(lme4)
library(lmerTest)
library(MuMIn)
library(ggplot2)
library(parameters)

#####################Demographics check##############################
#Import data
demographics_MCP <- read.csv("", header=TRUE) #insert demographics csv
describe(demographics_MCP)

SumValues_MCP <- read.csv("", header=TRUE) #insert raw brain values
describe(SumValues_MCP)

#####################Linear mixed effects models#####################
#Import data
data_MCP <- read.csv("", header=TRUE) #insert main dataframe

#Set factors
data_MCP$Brain = data_MCP$XXX #change to appropriate brain region
data_MCP$Subject = factor(data_MCP$XXX) #insert participant factor
data_MCP$Time = factor(data_MCP$XXX) #insert time factor
data_MCP$Est = data_MCP$XXX #insert estradiol factor
data_MCP$Prog = data_MCP$XXX #insert progesterone factor
str(data_MCP)

#1 Intercept model
intercept_lmm <- lmer(Brain ~ (1|Subject), data = data_MCP, REML = FALSE)

#2 Hormone models
estradiol_lmm <- lmer(Brain ~ Est + (1|Subject), data = data_MCP, REML = FALSE) #CSF & pASL control model
progesterone_lmm <- lmer(Brain ~ Prog + (1|Subject), data = data_MCP, REML = FALSE) #CSF & pASL control model
hormones_lmm <- lmer(Brain ~ Est + Prog + (1|Subject), data=data_MCP, REML = FALSE) #full brain volume model

#3 Interaction model
interaction_lmm <- lmer(Brain ~ Est*Prog + (1|Subject), data = data_MCP, REML = FALSE)

#4 Reporting stats
anova(hormones_lmm, interaction_lmm)
###if not significant
model_parameters(estradiol_lmm, summary = TRUE, digits = 3) #CSF & pASL control model
model_parameters(progesterone_lmm, summary = TRUE, digits = 3) #CSF & pASL control model
model_parameters(hormones_lmm, summary = TRUE, digits = 3) #full brain volume model
###if significant 
model_parameters(interaction_lmm, summary = TRUE, digits = 3)

#5 Assessing changes across cycle phase time-points
data_MCP$Brain = data_MCP$XXX #change to appropriate brain region
intercept_lmm <- lmer(Brain ~ (1|Subject), data = data_MCP, REML = FALSE)
day_lmm <- lmer(Brain ~ Time + (1|Subject), data = data_MCP, REML = FALSE)
model_parameters(day_lmm, summary = TRUE, digits = 3)
difflsmeans(day_lmm, test.effs = Time)