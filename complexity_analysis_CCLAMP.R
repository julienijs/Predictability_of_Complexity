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
morph_data <- read_xlsx("zipped_morphology_CCLAMP_by_year.xlsx", col_names = TRUE)
zipped <- read_xlsx("CCLAMP_by_year_Zipped_Sizes.xlsx", col_names = TRUE)

# merge data
morph_total <- merge(zipped, morph_data, by="...1")

# make all numbers negative
morph_total[,6:105] <- morph_total[,6:105]*(-1)
# divide by full zipped size to get complexity ratio
morph_total[,6:105] <- morph_total[,6:105]/morph_total[,4]
# get means for each row = get mean complexity ratio
morph_means <- rowMeans(morph_total[,6:105])
# add mean complexity ratios to data frame
morph_total$morph_means <- morph_means
# get standard deviations
morph_std = rowSds(as.matrix(morph_total[,6:105]))

#### Syntax ####

# read data
synt_data <- read_xlsx("zipped_syntax_CCLAMP_by_year.xlsx", col_names = TRUE)
# merge data
synt_total <- merge(zipped, synt_data, by="...1")

# divide by full zipped size to get complexity ratio
synt_total[,6:105] <- synt_total[,6:105]/synt_total[,4]
# get means for each row = get mean complexity ratio
synt_means <- rowMeans(synt_total[,6:105])
# add mean complexity ratios to data frame
synt_total$synt_means <- synt_means
# get standard deviations
synt_std = rowSds(as.matrix(synt_total[,6:105]))

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

# visualization
ggplot(morph_and_synt, aes(x = year, y = morph_means)) + geom_line()
ggplot(morph_and_synt, aes(x = year, y = synt_means)) + geom_line()


# make time series for morphology means
morph_and_synt$decade <- morph_and_synt$year - morph_and_synt$year %% 10 # calculate decades

morph_dec_ts <- ts((morph_and_synt %>% 
                      group_by(decade) %>% 
                      summarise(Morphology = mean(Morphology)))[,2])

plot(morph_dec_ts)
CADFtest(morph_dec_ts) # not significant: no unit root

morph_ts <- ts(morph_and_synt$Morphology, start = 1837, frequency = 1)
plot(morph_ts)
CADFtest(morph_ts) # not significant: no unit root

# make time series for syntax means
synt_dec_ts <- ts((morph_and_synt %>% 
                     group_by(decade) %>% 
                     summarise(Syntax = mean(Syntax)))[,2])

plot(synt_dec_ts)
CADFtest(synt_dec_ts) # not significant: no unit root

synt_ts <- ts(morph_and_synt$Syntax, start = 1837, frequency = 1)
plot(synt_ts)
CADFtest(synt_ts) # significant

synt_diff_ts <- diff(synt_ts) # detrending
morph_diff_ts <- diff(morph_ts) # detrending

# granger causality tests
grangertest(synt_ts ~ morph_ts, order = 1)
grangertest(morph_ts ~ synt_ts, order = 1)

grangertest(synt_diff_ts ~ morph_diff_ts, order = 1)
grangertest(morph_diff_ts ~ synt_diff_ts, order = 1)

grangertest(synt_dec_ts ~ morph_dec_ts, order = 1)
grangertest(morph_dec_ts ~ synt_dec_ts, order = 1)

# Visualization:

library(latticeExtra)

# Year plot
tsDF <- data.frame(Year = seq(from = 1837, to = 1999, by = 1),
                   "Syntax" = synt_ts,
                   "Morphology" = morph_ts)

m <- xyplot(Morphology ~ Year, tsDF, type = "l", lwd = 2, ylab = "Morphological complexity")
s <- xyplot(Syntax ~ Year, tsDF, type = "l", lwd = 2, ylab = "Word order rigidity")
doubleYScale(m, s, add.ylab2 = TRUE, use.style=TRUE)


# Z-scored plot

# Z-score the time series
z_scored_morph <- scale(morph_ts)
z_scored_synt <- scale(synt_ts)

# Determine the range of y-values
y_range <- range(z_scored_morph, z_scored_synt)

# Create a sequence for the years
years <- seq(1837, 1999, by = 1)

# Create a plot without drawing the x-axis
plot(years, z_scored_morph, type = "l", lty = 1, ylim = y_range, 
     ylab = "Z-Scored Values", 
     xlab = "Year",  # Change x-axis label
     xaxt = "n")    # Suppress drawing of x-axis ticks

# Add the second time series
lines(years, z_scored_synt, type = "l", lty = 2)

# Add x-axis ticks
axis(1, at = seq(1837, 1999, by = 20), labels = seq(1837, 1999, by = 20))

# Add legend
legend("topright", legend = c("Morphological complexity", "Word order rigidity"), lty = c(1, 2), cex = 0.5)
