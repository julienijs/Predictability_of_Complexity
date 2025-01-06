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
morph_data <- read_xlsx("CLMET_Morph_Zipped.xlsx", col_names = TRUE)
zipped <- read_xlsx("CLMET_Zipped_Sizes.xlsx", col_names = TRUE)

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


# linear model
morph_model <- lm(morph_means ~ year, data=morph_total)
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
synt_data <- read_xlsx("CLMET_Synt_Zipped.xlsx", col_names = TRUE)
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


# linear model
synt_model <- lm(synt_means ~ year, data=synt_total)
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

# make time series for morphology means
morph_ts <- ts(morph_and_synt$Morphology)

CADFtest(morph_ts) # significant
plot(morph_ts)

morph_diff_ts <- diff(morph_ts) # detrending

# make time series for syntax means
synt_ts <- ts(morph_and_synt$Syntax)

CADFtest(synt_ts) # not significant: no unit root
plot(synt_ts)

synt_diff_ts <- diff(synt_ts) # detrending

# granger causality test
for (x in 1:5) {
  print(grangertest(morph_ts ~ synt_ts, order = x))
}

for (x in 1:5) {
  print(grangertest(synt_ts ~ morph_ts, order = x))
}

for (x in 1:5) {
  print(grangertest(morph_diff_ts ~ synt_diff_ts, order = x))
}

for (x in 1:5) {
  print(grangertest(synt_diff_ts ~ morph_diff_ts, order = x))
}

# Visualization:

library(latticeExtra)

tsDF <- data.frame(Decade = seq(from = 1710, to = 1920, by = 10),
                   "syntax" = synt_ts,
                   "morphology" = morph_ts)

m <- xyplot(morphology ~ Decade, tsDF, type = "l" , lwd=2)
s <- xyplot(syntax ~ Decade, tsDF, type = "l", lwd=2)
doubleYScale(m, s, add.ylab2 = TRUE, use.style=TRUE)

# Z-scored plot

# Z-score the time series
z_scored_morph <- scale(morph_ts)
z_scored_synt <- scale(synt_ts)

# Define y-axis range for consistency
y_range <- c(-3, 3)  # Assuming this range based on your plot limits

# Adjust margins to allow space below the plot for the legend
par(mar = c(8, 4, 2, 2))  # Increase the bottom margin to 8

# Create a plot with the first z-scored time series
plot(z_scored_morph, type = "l", lty = 1, ylim = y_range, 
     ylab = "Z-Scored Values", 
     xlab = "Time",
     xaxt = "n",
     yaxt = "n")

# Add the second z-scored time series to the plot with a different line type
lines(z_scored_synt, lty = 2)

# Add years to the plot
years <- seq(1710, 1890, by = 10)
# Calculate the positions of the ticks
tick_positions <- seq(1, length(z_scored_morph), length.out = length(years))
axis(1, at = tick_positions, labels = years)

# Custom y-axis labels with proper minus sign
y_ticks <- seq(floor(min(y_range)), ceiling(max(y_range)), by = 1)  # Define y-tick positions
y_labels <- gsub("-", "−", as.character(y_ticks))  # Replace hyphen with minus sign
axis(2, at = y_ticks, labels = y_labels)  # Add y-axis with custom labels

# Add a legend
legend("bottom", legend = c("Morphological complexity", "Word order rigidity"), 
       lty = c(1, 2), cex = 0.8, inset = c(0, -0.35), xpd = TRUE, horiz = TRUE)
