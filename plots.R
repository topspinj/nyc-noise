library(tidyverse)
library(viridis)

noise_by_borough <- read.csv("shiny/data_by_month.csv")
noise_by_borough$borough <- gsub('\\s+', '', noise_by_borough$borough)
noise_by_borough$month <- factor(noise_by_borough$month, levels = month.abb)
# month_created,borough,count,month

borough_plot <- ggplot(noise_by_borough, aes(x=borough, y=count)) +
  geom_bar(stat="identity", aes(fill=borough)) +
  theme_bw() +
  scale_fill_viridis(discrete=TRUE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none") +
  ggtitle("Noise complaints by borough")

ggsave("imgs/borough_plot.png", plot=borough_plot)


month_plot <- ggplot(noise_by_borough, aes(x=month, y=count)) +
  geom_bar(stat="identity", aes(fill=month)) +
  theme_bw() +
  scale_fill_viridis(discrete=TRUE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none") +
  ggtitle("Noise complaints by month") +
  scale_x_discrete(limits = month.abb)

ggsave("imgs/month_plot.png", plot=month_plot)
