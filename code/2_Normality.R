library(tidyverse)

data <- read_csv('data/data_surface.csv')


hist(log(data$CO2_mean))
hist(data$DO_Percent)

hist(log(data$DO_Percent))
