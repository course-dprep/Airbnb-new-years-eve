##INPUT
library(broom)
library(tidyr)
library(ggplot2)
library(readr)
library(data.table)
library(dplyr)
library(tidyverse)
library(stargazer)

#create directory 
dir.create('../../src/analysis/analyze.R') 

#import the data 
cities <- c("rome", "paris", "ams", "london")

for (city in cities) {
  file_name <- paste0("complete_data_", city, ".csv")
  assign(paste0("complete_data_", city), read.csv(file_name))
}

#loop for view the complete data
for (city in cities) {
  view(get(paste0("complete_data_", city)))
}

##TRANSFORMATION

##complete model booked: logistic regression
model_booked <- glm(booked ~ newyearseve, data = complete_data, family = binomial)
summary(model_booked)

##complete model price: linear regression 
model_price <- lm(price ~ newyearseve, data = complete_data)
summary(model_price)

##Model per city booked: logistic regression
#Loop through each city and generate the model and summary for booked (logistic regression)
models_booked <- lapply(cities, function(city) {
  # Generate the model
  model_booked <- glm(booked ~ newyearseve, family = binomial, data = get(paste0("complete_data_", city)))
  
  # Print the summary
  cat("Summary for", toupper(city), "\n")
  print(summary(model_booked))
  return(list(city=city, model_booked=model_booked))
})

##Model per city price: linear regression
# Loop through each city and generate the model and summary for price
models_price <- lapply(cities, function(city) {
  # Generate the model
  model_price <- lm(price ~ newyearseve, data = get(paste0("complete_data_", city)))
  
  # Print the summary
  cat("Summary for", toupper(city), "\n")
  print(summary(model_price))
  return(list(city=city, model_price=model_price))
})

##OUTPUT
save(model_booked, model_price, models_price, models_booked, file='../../src/analysis/model_results.RData') 

