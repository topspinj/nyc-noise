library(tidyverse)
library(lubridate)
library(forcats)

data <- read_csv('data/data.csv')

data <- data %>% 
  select('Unique Key', 'Created Date', 'Agency', 'Complaint Type', 'Location Type', 'Borough', 'Incident Address', 'Latitude', 'Longitude')
colnames(data) <- c('id', 'created_date', 'agency', 'complaint_type', 'location_type', 'borough', 'incident_address', 'lat', 'long')

data$created_date <- parse_date_time(data$created_date, "%m/%d/%Y %I:%M:%S %p", tz = "EST5EDT")
data$borough <- data$borough %>%
  fct_recode("Brooklyn" = "BROOKLYN", "Queens" = "QUEENS", "Manhattan" = "MANHATTAN", "Staten Island" = "STATEN ISLAND", "Bronx" = "BRONX")

data <- data %>% 
  filter(borough != 'Unspecified')
data$borough <- as.factor(data$borough)
data$borough <- gsub('\\s+', '', data$borough)
data$month_created <- month(data$created_date)
data$year_created <- year(data$created_date)
data$day_created <- day(data$created_date)
data$hour_created <- hour(data$created_date)
data$weekday <- weekdays(data$created_date)

data$weekday <- as.factor(data$weekday) %>%
  fct_recode("1" = "Monday", "2" = "Tuesday", "3" = "Wednesday", "4" = "Thursday", "5" = "Friday", "6" = "Saturday", "7" = "Sunday")
head(data)
write_csv(data, "data/data_wrangled.csv")
write_csv(data, "shiny/data_wrangled.csv")


# create dataframe that shows complaint counts by month by borough
by_month <- data %>% 
  group_by(month_created, borough) %>% 
  summarise(
    count = n()
  )

average <- by_month %>% 
  ungroup() %>% 
  group_by(month_created) %>% 
  summarise(
    count = sum(count)/5
  )
average$borough <- rep("Average", 12)


avg_df <- data.frame(average$month_created, average$borough, average$count)
colnames(avg_df) <- c("month_created", "borough", "count")
month_df <- data.frame(by_month$month_created, by_month$borough, by_month$count)
colnames(month_df) <- c("month_created", "borough", "count")

df <- rbind(avg_df, month_df)

df$month <- as.factor(df$month_created) %>%
  fct_recode("Jan" = "1", "Feb" = "2", "Mar" = "3", "Apr" = "4", "May" = "5", "Jun" = "6", "Jul" = "7", "Aug" = "8", "Sep" = "9", "Oct" = "10", "Nov" = "11", "Dec" = "12")
df$borough <- as.factor(df$borough) %>% 
  fct_recode("StatenIsland" = "Staten Island")

head(df)
write_csv(df, "data/data_by_month.csv")
