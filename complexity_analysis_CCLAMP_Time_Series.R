setwd("./Datasets")

library(readxl)
library(ggplot2)
library(matrixStats)
library(effects)
library(dplyr)
library(lmtest)
library(reshape2)
library(CADFtest)

#### Morphology ####

# read data
morph_data <- read_xlsx("zipped_morphology_CCLAMP.xlsx", col_names = TRUE)
zipped <- read_xlsx("CCLAMP_Zipped_Sizes.xlsx", col_names = TRUE)

# merge data
morph_total <- merge(zipped, morph_data, by="...1")

# make all numbers negative
morph_total[,7:106] <- morph_total[,7:106]*(-1)
# divide by full zipped size to get complexity ratio
morph_total[,7:106] <- morph_total[,7:106]/morph_total[,5]
# get means for each row = get mean complexity ratio
morph_means <- rowMeans(morph_total[,7:106])
# add mean complexity ratios to data frame
morph_total$morph_means <- morph_means
# get standard deviations
morph_std = rowSds(as.matrix(morph_total[,7:106]))

#### Syntax ####

# read data
synt_data <- read_xlsx("zipped_syntax_CCLAMP.xlsx", col_names = TRUE)
# merge data
synt_total <- merge(zipped, synt_data, by="...1")

# divide by full zipped size to get complexity ratio
synt_total[,7:106] <- synt_total[,7:106]/synt_total[,5]
# get means for each row = get mean complexity ratio
synt_means <- rowMeans(synt_total[,7:106])
# add mean complexity ratios to data frame
synt_total$synt_means <- synt_means
# get standard deviations
synt_std = rowSds(as.matrix(synt_total[,7:106]))

#### Morphology vs syntax ####

morph_and_synt <- data.frame("Morphology" = morph_total$morph_means,
                             "filename" = synt_total$filename,
                             "Syntax" = synt_total$synt_means,
                             "year" = synt_total$year)

morph_and_synt_model <- lm(morph_means ~ synt_means, data=morph_and_synt)
summary(morph_and_synt_model)
plot(allEffects(morph_and_synt_model))

x <- ggplot(morph_and_synt, aes(x = synt_means, y = morph_means))+
  xlab("Mean word order rigidity ratio")+
  ylab("Mean morphological complexity ratio")+
  geom_point()
x

#### Time series analysis ####

morph_and_synt$decade <- morph_and_synt$year - morph_and_synt$year %% 10 # calculate decades

# make time series for morphology means
morph_ts <- ts((morph_and_synt %>% 
                  group_by(decade) %>% 
                  summarise(Morphology = mean(Morphology)))[,2])

plot(morph_ts)
CADFtest(morph_ts) # not significant: no unit root

# morph_diff_ts <- diff(morph_ts) # detrending

# make time series for syntax means
synt_ts <- ts((morph_and_synt %>% 
                 group_by(decade) %>% 
                 summarise(Syntax = mean(Syntax)))[,2])

plot(synt_ts)
CADFtest(synt_ts) # not significant: no unit root

# synt_diff_ts <- diff(synt_ts) # detrending

# granger causality test
grangertest(synt_ts ~ morph_ts, order = 1)
grangertest(morph_ts ~ synt_ts, order = 1)


# add cities

# read metadata file
metadata <- read.delim("C-CLAMP_metadata.txt", header = FALSE, sep = "\t", fill = FALSE)

names(metadata)[names(metadata) == 'V1'] <- 'filename'
names(metadata)[names(metadata) == 'V6'] <- 'CITY'
metadata$CITY<-toupper(metadata$CITY) 
names(morph_and_synt)[names(morph_and_synt) == 'synt_total.filename'] <- 'filename'

# merge data

morph_and_synt <- merge(metadata, morph_and_synt, by="filename")

# read city data file
citydata <- read.csv("StedenBelgiëNederland19eEn20eEeuw.csv", header = TRUE)

# merge data

morph_and_synt <- merge(citydata, morph_and_synt, by="CITY")
names(morph_and_synt)[names(morph_and_synt) == 'BAIy1850'] <- 'Population'

# make time series of cities

city_ts <- ts((morph_and_synt %>% 
                 group_by(decade) %>% 
                 summarise(Population = mean(Population)))[,2])

plot(city_ts)

CADFtest(city_ts) # not significant: no unit root

grangertest(city_ts ~ morph_ts, order = 1)
grangertest(morph_ts ~ city_ts, order = 1)

grangertest(city_ts ~ synt_ts, order = 4)
grangertest(synt_ts ~ city_ts, order = 4)


# Visualization:

library(latticeExtra)

tsDF <- data.frame(Decade = seq(from = 1840, to = 1990, by = 10),
                   "syntax" = synt_ts,
                   "morphology" = morph_ts,
                   "population" = city_ts)

m <- xyplot(Morphology ~ Decade, tsDF, type = "l" , lwd=2)
s <- xyplot(Syntax ~ Decade, tsDF, type = "l", lwd=2)
p <- xyplot(Population ~ Decade, tsDF, type = "l", lwd=2)
doubleYScale(m, s, add.ylab2 = TRUE, use.style=TRUE)
doubleYScale(m, p, add.ylab2 = TRUE, use.style=TRUE)
doubleYScale(s, p, add.ylab2 = TRUE, use.style=TRUE)

y <- ggplot(morph_and_synt, aes(x = Population, y = Morphology))+
  xlab("Population size")+
  ylab("Mean morphological complexity ratio")+
  geom_point()
y


