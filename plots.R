library(tidyverse)
library(viridis)
library(chron)

noise_by_borough <- read.csv("data/data_by_month.csv")
noise_by_borough$month <- factor(noise_by_borough$month, levels = month.abb)
# month_created,borough,count,month
noise_by_borough$month
borough_plot <- ggplot(noise_by_borough, aes(x=borough, y=count)) +
  geom_bar(stat="identity", aes(fill=borough)) +
  theme_bw() +
  scale_fill_viridis(discrete=TRUE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none",
        plot.title = element_text(size=14, face="bold")) +
  ggtitle("Noise complaints by borough")

ggsave("imgs/borough_plot.png", plot=borough_plot)

borough_only <- noise_by_borough %>% 
  filter(borough != "Average")
month_plot <- ggplot(borough_only, aes(x=month, y=count)) +
  geom_bar(stat="identity", aes(fill=borough)) +
  theme_bw() +
  scale_fill_viridis(discrete=TRUE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        plot.title = element_text(size=14, face="bold")) +
  ggtitle("Noise complaints by month") +
  scale_x_discrete(limits = month.abb)
ggsave("imgs/month_plot.png", plot=month_plot)


data <- read_csv("data/data_wrangled.csv")
head(data)
hour_created_plot <- ggplot(data, aes(x=hour_created)) +
  geom_bar(fill=viridis(1))+
  theme_bw() +
  xlab("time of day")
data$date <- as.Date(data$created_date, format="%m%d%Y")

counts <- data %>% 
  group_by(date) %>% 
  summarise(
    count = n()
  ) %>% 
  arrange(desc(count)) %>% 
  mutate(weekend = is.weekend(date))

count_ts_plot <- ggplot(counts, aes(x=date, y=count)) +
  geom_point(aes(color=weekend), size=1, alpha=0.9) +
  geom_line(alpha=0.6) +
  theme_bw() +
  scale_color_manual(values=c('transparent', viridis(24)[12]))
ggsave("imgs/count_ts_plot.png",count_ts_plot)