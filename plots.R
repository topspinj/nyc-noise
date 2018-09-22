library(tidyverse)

noise_by_borough <- read.csv("shiny/data_by_month.csv")
# month_created,borough,count,month

borough_plot <- ggplot(noise_by_borough, aes(x=borough, y=count)) +
  geom_bar(stat="identity", fill="purple") +
  theme_bw()

ggsave("imgs/borough_plot.png", plot=borough_plot)
