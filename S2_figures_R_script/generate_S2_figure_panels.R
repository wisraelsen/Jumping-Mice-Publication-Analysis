##############################################################################
# This R script generates panels for Figures S2A - S2F from Brem et al. 2021.
# It uses ggplot and simulates the data underlying the histograms when needed.
# The figures are saved in PDF format.
#
# Input files are included in the current directory:
#	gest_length_bounds.txt
#	litter-size.txt
#	litter-size_all-M-or-F.txt
#
# This script will take a long time to run (~26 min on a laptop) because generating
# and saving the histograms of 10 million simulated litters is resource intensive.
# If you get this - "Error: vector memory exhausted (limit reached?)"
# add "R_MAX_VSIZE=100Gb" to first line of .Renviron and restart R.
# 
#
##############################################################################

library(ggplot2)
library(scales) # need scales to get commas in axis labels


### FIGURE S2A - Histogram of possible gestation lengths

print("Working on S2A...")

# load data into R; this is the possible bounds of gestation lengths
gest_max_min <- read.table("gest_length_bounds.txt", header=TRUE)

# make data frame, note this is too wide, but non-issue for what I want to do
x <- data.frame(matrix(ncol = 39, nrow = 37))

# fill in numbers of possible days for each range, pad with NA's at end
for (i in 1:nrow(gest_max_min)) {x[i,] <- c(seq(gest_max_min$Min[i],gest_max_min$Max[i]),rep(NA,39-length(seq(gest_max_min$Min[i],gest_max_min$Max[i]))))}

# make list from data frame for use as histogram input, use "na.omit" to get rid of NAs 
S2A_data <- na.omit(as.data.frame(unlist(x)))

# rename column
colnames(S2A_data) <- "days"

## make figure using ggplot and save to disk

# I am using plum1 & lightblue colors to better show overlap
# of the possible min and max bounds of the gestation lengths
# (note ticks by twos seems like best looking option)

figS2A_revised <- ggplot() + geom_histogram(data=S2A_data, aes(x = days), binwidth=1, color = "white") + theme_classic() + labs(title = "Histogram of Possible Gestation Lengths", x = "Possible Days Gestation", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(seq(from = 0, to = 40, by = 2))) + geom_histogram(data=gest_max_min, aes(x = Max), binwidth=1, fill = alpha("plum1", 0.7), color = "white") + geom_histogram(data=gest_max_min, aes(x = Min), binwidth=1, fill = alpha("lightblue", 0.6), color = "white") + scale_y_continuous(breaks=c(seq(0,40,2)))

ggsave(plot = figS2A_revised, width = 6, height = 5, dpi = 1200, filename = "Fig_S2A_revised.pdf")



### FIGURE S2B-F - Simulated Data Histograms and Histogram of Sizes of Single-Sex Litters


## FIGURE S2B:

print("Working on S2B...")

# read in litter sizes
litter_size <- as.data.frame(read.table("litter-size.txt"))

# simulate 10 million sets of 32 litters with my litter size distribution, ratio = 0.5
size <- as.vector(litter_size$V1)  # make vector of litter_sizes
matrix_out <-matrix(ncol=10000000,nrow=32)
for (i in 1:32) {matrix_out[i,] <- rbinom(10000000,size[i],0.5)}  # takes about 19 seconds on my laptop

# now need to divide by litter size to get fraction male
matrix_out_fraction <- matrix_out / size  

# max(matrix_out_fraction)   #manual check to make sure max equals 1

# use "matrix_out_fraction" -- this simulated data set underlies the histograms of fraction male in Fig S2
# convert to single column in data frame for use in ggplot histogram,  c() will convert matrix to vector, this was fast
sim_frac_male_0.5 <- as.data.frame(c(matrix_out_fraction))

# manual check of structure - looks good
# str(sim_frac_male_0.5)

# rename column in data frame
colnames(sim_frac_male_0.5) <- "fracmale0.5"

# plot with smaller binwidth and more tick marks on the x axis, save 
figS2B <- ggplot() + geom_histogram(data=sim_frac_male_0.5, aes(x = fracmale0.5), binwidth=0.05, color = "white") + theme_classic() + labs(title = "Histogram of 10 Million Simulated Sets of 32 Litters\np=0.5 of Male", x = "Fraction Male, n = 10M * 32 Litters", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1))

ggsave(plot = figS2B, width = 6, height = 5, dpi = 1200, filename = "Fig_S2B_revised.pdf") # takes about 370 seconds on my laptop



## Figure S2C, using observed (0.6615385 sex ratio)

print("Working on S2C...")

# repeat simulation of 10 million sets of 32 litters using observed ratio
matrix_out_066 <-matrix(ncol=10000000,nrow=32)
for (i in 1:32) {matrix_out_066[i,] <- rbinom(10000000,size[i],0.6615385)} # takes about 19 seconds on my laptop

# now need to divide by litter size to get fraction male
matrix_out_066_fraction <- matrix_out_066 / size  

#max(matrix_out_066_fraction) # manual check

# convert to single column in data frame for use in ggplot histogram,  c() will convert matrix to vector
sim_frac_male_0.66 <- as.data.frame(c(matrix_out_066_fraction))

# manually check structure - looks good
#str(sim_frac_male_0.66)

# rename column in data frame
colnames(sim_frac_male_0.66) <- "fracmale0.66"

# plot figure, saving will be resource intensive and take a few minutes
figS2C <- ggplot() + geom_histogram(data=sim_frac_male_0.66, aes(x = fracmale0.66), binwidth=0.05, color = "white") + theme_classic() + labs(title = "Histogram of 10 Million Simulated Sets of 32 Litters\np=0.6615 of Male", x = "Fraction Male, n = 10M * 32 Litters", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1))

ggsave(plot = figS2C, width = 6, height = 5, dpi = 1200, filename = "Fig_S2C_revised.pdf")  # takes about 370 seconds on my laptop



## FIGURE S2D-E:

print("Working on S2D-E...")

# We want to count across 32 rows to get number of 0 and 1 fraction male
# In other words, we'll count down the 10 M columns to see how many times
# we got all male or all female litters in each simulated set of 32 litters

# do this here for sex ratio = 0.5

test_sim_10M_05_count_zero <- colSums(matrix_out_fraction == "0")  # counting takes about 205 seconds on my laptop
test_sim_10M_05_count_one <- colSums(matrix_out_fraction == "1")  # counting takes about 193 seconds on my laptop
dist_05 <- as.data.frame(test_sim_10M_05_count_zero + test_sim_10M_05_count_one)
colnames(dist_05) <- "x"

# mean(dist_05)  # manual check that this is what is expected

# and again for sex ratio = 0.66...
test_sim_10M_066_count_zero <- colSums(matrix_out_066_fraction == "0")  # counting takes about 218 seconds on my laptop
test_sim_10M_066_count_one <- colSums(matrix_out_066_fraction == "1")  # counting takes about 210 seconds on my laptop
dist_066 <- as.data.frame(test_sim_10M_066_count_zero + test_sim_10M_066_count_one)
colnames(dist_066) <- "x"

# mean(dist_066) # manual check that this is what is expected

# make data frame for placing marker on plots at 19 litters:
x <- 19
y <- 0
dot_at_19 <- data.frame(x,y)

# want commas in axis labels, so use "label=comma" in scale commands below
# set same axes limits on these two panels to make them comparable

figS2D <- ggplot() + geom_histogram(data=dist_05, aes(x = x), binwidth=1, color = "white") + theme_classic() + labs(title = "Number of Single-Sex Litters per 32 Simulated Litters at p=0.5 for Males\nDistribution from 10 Million Simulated Sets of 32 Litters", x = "Number of Single-Sex Litters", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(0:22), limits = c(0,22)) + scale_y_continuous(label=comma, limits = c(0, 2500000)) + geom_point(dot_at_19, mapping = aes(x = x, y = y), color = "red", size = 5)

ggsave(plot = figS2D, width = 8, height = 5, dpi = 1200, filename = "Fig_S2D_revised.pdf")

figS2E <- ggplot() + geom_histogram(data=dist_066, aes(x = x), binwidth=1, color = "white") + theme_classic() + labs(title = "Number of Single-Sex Litters per 32 Simulated Litters at p=0.6615 for Males\nDistribution from 10 Million Simulated Sets of 32 Litters", x = "Number of Single-Sex Litters", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(0:22), limits = c(0,22)) + scale_y_continuous(label=comma, limits = c(0, 2500000)) + geom_point(dot_at_19, mapping = aes(x = x, y = y), color = "red", size = 5)

ggsave(plot = figS2E, width = 8, height = 5, dpi = 1200, filename = "Fig_S2E_revised.pdf")



## FIGURE S2F: plot histogram of actual data 

print("Working on S2F...")

# read into R to plot histogram and get 
litter_size_all_M_or_F <- as.vector(read.table("litter-size_all-M-or-F.txt"))

figS2F <- ggplot() + geom_histogram(data=litter_size_all_M_or_F, aes(x = V1), binwidth=1, color = "white") + theme_classic() + labs(title = "Histogram: Size of Single-Sex Litters", x = "Number of Weaned Pups per Litter, n = 19 Litters", y = "Frequency") + theme(plot.title = element_text(hjust = 0.5)) + scale_x_continuous(breaks = c(0:7), limits = c(0,7)) + scale_y_continuous(breaks = c(0:7))

# save plot
ggsave(plot = figS2F, width = 6, height = 5, dpi = 1200, filename = "Fig_S2F_revised.pdf")