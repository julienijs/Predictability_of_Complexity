setwd("./Datasets")

library(readxl)
library(ggplot2)
library(matrixStats)
library(effects)
library(lmtest)
library(reshape2)
library(dplyr)
library(CADFtest)

#### morphology ####

# read data
morph_data <- read_xlsx("zipped_morphology_CLMET.xlsx", col_names = TRUE)
zipped <- read_xlsx("CLMET_Zipped_Sizes.xlsx", col_names = TRUE)
metadata <- read_xlsx("CLMET_Metadata.xlsx", col_names = TRUE)

# merge data
morph_total <- merge(zipped, morph_data, by="...1")

names(morph_total)[names(morph_total) == '0'] <- 'file'

morph_total <- merge(morph_total, metadata, by="file")

# make all numbers negative
morph_total[,5:104] <- morph_total[,5:104]*(-1)
# divide by full zipped size to get complexity ratio
morph_total[,5:104] <- morph_total[,5:104]/morph_total[,4]
# get means for each row = get mean complexity ratio
morph_means <- rowMeans(morph_total[,5:104])
# add mean complexity ratios to data frame
morph_total$morph_means <- morph_means
# get standard deviations
morph_std = rowSds(as.matrix(morph_total[,5:104]))


# linear model
morph_model <- lm(morph_means ~ year, data=morph_total)
morph_model <- lm(morph_means ~ genre, data=morph_total)
morph_model <- lm(morph_means ~ year*genre, data=morph_total)
summary(morph_model)
plot(allEffects(morph_model))

# make plots

mp <- ggplot(morph_total, 
             aes(x = year, y = morph_means))+
  ggtitle("Morphological complexity ratio over time") +
  xlab("Year")+
  ylab("Mean morphological complexity ratio") +
  geom_point()
mp

ml <- ggplot(morph_total, 
             aes(x = year, y = morph_means))+
  ggtitle("Morphological complexity ratio over time") +
  xlab("Year")+
  ylab("Mean morphological complexity ratio")+
  geom_point()+
  geom_smooth()
ml


#### Syntax ####

# read data
synt_data <- read_xlsx("zipped_syntax_CLMET.xlsx", col_names = TRUE)
# merge data
synt_total <- merge(zipped, synt_data, by="...1")

names(synt_total)[names(synt_total) == '0'] <- 'file'

synt_total <- merge(synt_total, metadata, by="file")


# divide by full zipped size to get complexity ratio
synt_total[,5:104] <- synt_total[,5:104]/synt_total[,4]
# get means for each row = get mean complexity ratio
synt_means <- rowMeans(synt_total[,5:104])
# add mean complexity ratios to data frame
synt_total$synt_means <- synt_means
# get standard deviations
synt_std = rowSds(as.matrix(synt_total[,5:104]))


# linear model
synt_model <- lm(synt_means ~ year, data=synt_total)
synt_model <- lm(synt_means ~ genre, data=synt_total)
synt_model <- lm(synt_means ~ genre*year, data=synt_total)
summary(synt_model)
plot(allEffects(synt_model))

# make plots

sp <- ggplot(synt_total, 
             aes(x = year, y = synt_means))+
  ggtitle("Syntactic complexity ratio over time") +
  xlab("Year")+
  ylab("Mean syntactic complexity ratio")+
  geom_point()
sp

sl <- ggplot(synt_total, 
             aes(x = year, y = synt_means))+
  ggtitle("Syntactic complexity ratio over time") +
  xlab("Year")+
  ylab("Mean syntactic complexity ratio")+
  geom_point()+
  geom_smooth()
sl


#### Morphology vs syntax ####

morph_and_synt <- data.frame("Morphology" = morph_total$morph_means,
                             "filename" = synt_total$filename,
                             "Syntax" = synt_total$synt_means,
                             "year" = synt_total$year)

morph_and_synt_model <- lm(morph_means ~ synt_means, data=morph_and_synt)
summary(morph_and_synt_model)
plot(allEffects(morph_and_synt_model))

scp <- ggplot(morph_and_synt,
              aes(x = synt_means, y = morph_means))+
  xlab("Mean word order rigidity ratio")+
  ylab("Mean morphological complexity ratio")+
  geom_point()
scp


#### Time series analysis ####

morph_and_synt$decade <- morph_and_synt$year - morph_and_synt$year %% 10 # calculate decades

# make time series for morphology means
morph_ts <- ts((morph_and_synt %>% 
                  group_by(decade) %>% 
                  summarise(Morphology = mean(Morphology)))[,2])

CADFtest(morph_ts) # significant
plot(morph_ts)

morph_diff_ts <- diff(morph_ts) # detrending

# make time series for syntax means
synt_ts <- ts((morph_and_synt %>% 
                 group_by(decade) %>% 
                 summarise(Syntax = mean(Syntax)))[,2])

CADFtest(synt_ts) # not significant: no unit root
plot(synt_ts)

synt_diff_ts <- diff(synt_ts) # detrending

# granger causality test
grangertest(synt_ts ~ morph_ts, order = 1)
grangertest(morph_ts ~ synt_ts, order = 1)

grangertest(synt_diff_ts ~ morph_diff_ts, order = 6)
grangertest(morph_diff_ts ~ synt_diff_ts, order = 6)

# Visualization:

library(latticeExtra)

tsDF <- data.frame(Decade = seq(from = 1710, to = 1920, by = 10),
                   "syntax" = synt_ts,
                   "morphology" = morph_ts)

m <- xyplot(Morphology ~ Decade, tsDF, type = "l" , lwd=2)
s <- xyplot(Syntax ~ Decade, tsDF, type = "l", lwd=2)
doubleYScale(m, s, add.ylab2 = TRUE, use.style=TRUE)


# Z-scored plot

# Z-score the time series
z_scored_morph <- scale(morph_ts)
z_scored_synt <- scale(synt_ts)

# Create a plot with the first z-scored time series
plot(z_scored_morph, type = "l", lty = 1, ylim = c(-3, 3), 
     ylab = "Z-Scored Values", 
     xlab = "Time",
     xaxt = "n")

# Add the second z-scored time series to the plot with a different line type
lines(z_scored_synt, lty = 2)

# Add a legend
legend("topright", legend = c("Morphological complexity", "Word order rigidity"), lty = c(1, 2))

# Add years to the plot
years <- seq(1710, 1890, by = 10)
# Calculate the positions of the ticks
tick_positions <- seq(1, length(z_scored_morph), length.out = length(years))
axis(1, at = tick_positions, labels = years)

