
#Setting up the environment
library(tidyverse)
library(dplyr)
library(janitor)
library(lubridate)
library(ggplot2)



#Load all the data
t21_Apr <- read_csv("../data/202104-divvy-tripdata.csv")
t21_May <- read_csv("../data/202105-divvy-tripdata.csv")
t21_Jun <- read_csv("../data/202106-divvy-tripdata.csv")
t21_Jul <- read_csv("../data/202107-divvy-tripdata.csv")
t21_Aug <- read_csv("../data/202108-divvy-tripdata.csv")
t21_Sep <- read_csv("../data/202109-divvy-tripdata.csv")
t21_Oct <- read_csv("../data/202110-divvy-tripdata.csv")
t21_Nov <- read_csv("../data/202111-divvy-tripdata.csv")
t21_Dec <- read_csv("../data/202112-divvy-tripdata.csv")
t22_Jan <- read_csv("../data/202201-divvy-tripdata.csv")
t22_Fed <- read_csv("../data/202202-divvy-tripdata.csv")
t22_Mar <- read_csv("../data/202203-divvy-tripdata.csv")




#Combine all dataset into a single data frame
trip_data <- rbind(t21_Apr, t21_May, t21_Jun, t21_Jul, t21_Aug, t21_Sep, t21_Oct, t21_Nov, t21_Dec, t22_Jan, t22_Fed, t22_Mar)

# View newly created dataset
view(trip_data)




#remove all the irrelevent columns that won't be used for analysis
trip_data <- trip_data %>% 
  select(-c(start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng))

trip_data <- remove_empty(trip_data, which = c("rows", "cols"), quiet = FALSE)




#Review of the data and its parameters
head(trip_data)
colnames(trip_data)
nrow(trip_data)
dim(trip_data)
str(trip_data)
summary(trip_data)




#Create additional columns for date and time.
trip_data$started_at <- ymd_hms(trip_data$started_at)
trip_data$ended_at <- ymd_hms(trip_data$ended_at)
trip_data$day_of_week <- format(as.Date(trip_data$started_at), "%A")
trip_data$month <- format(as.Date(trip_data$started_at), "%m")




#calculate the each ride length
trip_data$ride_length <- (as.double(difftime(trip_data$ended_at, trip_data$started_at))) / 60

trip_data <- trip_data[!(trip_data$ride_length <0),]




#structure and summary of new dataset
str(trip_data)
summary(trip_data$ride_length)




#Calculating the mean, max, min - figures to determine statisical spead of membership type
aggregate(trip_data$ride_length ~ trip_data$member_casual, FUN = mean)
aggregate(trip_data$ride_length ~ trip_data$member_casual, FUN = min)
aggregate(trip_data$ride_length ~ trip_data$member_casual, FUN = max)




#Create a weekday field as well as view column specifics
trip_data %>% 
  mutate(day_weeks = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, day_weeks) %>% 
  summarise(num_of_rides = n())





#Data Visualization
#total rides broken down by weekday
trip_data %>% 
  mutate(days_week = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, days_week) %>% 
  summarise(num_of_rides = n()) %>% 
  ggplot(aes(x=days_week, y=num_of_rides, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x="Days of Week", y="Total number of Rides", title = "Rides per day of Week", fill='Type of membership') +
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000, 500000, 600000), labels = c("100K", "200K", "300K", "400K", "500K", "600K"))




#total rides broken down by monthly
trip_data %>% 
  mutate(month = month(started_at, label = TRUE)) %>% 
  group_by(member_casual, month) %>% 
  summarise(num_of_rides = n()) %>% 
  ggplot(aes(x=month, y=num_of_rides, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x="Month", y="Total number of Rides", title = "Rides per Month", fill='Type of membership') +
  scale_y_continuous(breaks = c(100000, 200000, 300000, 400000, 500000, 600000), labels = c("100K", "200K", "300K", "400K", "500K", "600K"))




#broken down by bike types rented
trip_data %>% 
  ggplot(aes(x= rideable_type, fill = member_casual)) + geom_bar(position = "dodge") + 
  labs(x = "Type of Bikes", y="Number of Rentals", title = "Which Bike is most favourite", fill="Type of membership") + 
  scale_y_continuous(breaks = c(500000, 1000000, 1500000, 2000000), labels = c("500K", "1Mil", "1.5Mil", "2Mil"))




#Find the average time spent riding by each membership type in individual day
trip_data %>% 
  mutate(days_week = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, days_week) %>% 
  summarise(average_duration = mean(ride_length)) %>% 
  ggplot(aes(x=days_week, y=average_duration, fill = member_casual)) + geom_col(position = "dodge") + 
  labs(x="Days of Week", y="Average Duration (Hrs)", title = "Average Ride Time per Week", fill='Type of membership')


