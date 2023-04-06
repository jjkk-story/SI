library(ggplot2)
library(dplyr)

## 1. 데이터 로드

data <- read.csv("대기오염_측정소별_월별.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)
str(data)

data1 <- read.csv("대기오염_월별.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)
str(data1)

names(data)[3] <- "이산화질소"
names(data)[4] <- "오존"
names(data)[5] <- "일산화탄소"
names(data)[6] <- "아황산가스"
names(data)[7] <- "미세먼지"
names(data)[8] <- "초미세먼지"


# no2
arp_vlm_no2_ym_line <- data1 %>% filter(airpol_nm == "이산화질소")
arp_vlm_no2_ym_line$측정월 <- as.factor(arp_vlm_no2_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data$측정월), y=data$이산화질소, group=data$측정소명, col=data$측정소명)) +
  geom_line(aes(x=arp_vlm_no2_ym_line$측정월, y=arp_vlm_no2_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="NO2",title = "NO2_2000,2010,2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))


# o3
arp_vlm_o3_ym_line <- data1 %>% filter(airpol_nm == "오존")
arp_vlm_o3_ym_line$측정월 <- as.factor(arp_vlm_o3_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data$측정월), y=data$오존, group=data$측정소명, col=data$측정소명)) +
  geom_line(aes(x=arp_vlm_o3_ym_line$측정월, y=arp_vlm_o3_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="O3",title = "O3_2000,2010,2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))


# co
arp_vlm_co_ym_line <- data1 %>% filter(airpol_nm == "일산화탄소")
arp_vlm_co_ym_line$측정월 <- as.factor(arp_vlm_co_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data$측정월), y=data$일산화탄소, group=data$측정소명, col=data$측정소명)) +
  geom_line(aes(x=arp_vlm_co_ym_line$측정월, y=arp_vlm_co_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="CO",title = "CO_2000,2010,2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))


# so2
arp_vlm_so2_ym_line <- data1 %>% filter(airpol_nm == "아황산가스")
arp_vlm_so2_ym_line$측정월 <- as.factor(arp_vlm_so2_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data$측정월), y=data$아황산가스, group=data$측정소명, col=data$측정소명)) +
  geom_line(aes(x=arp_vlm_so2_ym_line$측정월, y=arp_vlm_so2_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="SO2",title = "SO2_2000,2010,2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))


# pm10
arp_vlm_pm10_ym_line <- data1 %>% filter(airpol_nm == "미세먼지")
arp_vlm_pm10_ym_line$측정월 <- as.factor(arp_vlm_pm10_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data$측정월), y=data$미세먼지, group=data$측정소명, col=data$측정소명)) +
  geom_line(aes(x=arp_vlm_pm10_ym_line$측정월, y=arp_vlm_pm10_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="PM10",title = "PM10_2000,2010,2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))


data_pm2.5 <- data %>% filter(측정월 >= 201901)

# pm2.5
arp_vlm_pm2.5_ym_line <- data1 %>% filter(airpol_nm == "초미세먼지" & 측정월 >= 201901)
arp_vlm_pm2.5_ym_line$측정월 <- as.factor(arp_vlm_pm2.5_ym_line$측정월)

ggplot() +
  geom_line(aes(x=as.factor(data_pm2.5$측정월), y=data_pm2.5$초미세먼지, group=data_pm2.5$측정소명, col=data_pm2.5$측정소명)) +
  geom_line(aes(x=arp_vlm_pm2.5_ym_line$측정월, y=arp_vlm_pm2.5_ym_line$volume, group=1), size=1) +
  labs(x="측정월", y="PM2.5",title = "PM2.5_2019,2020,2021", color="측정소명") +
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.title = element_text(family = "serif", face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 90),
        legend.title = element_text(family = "serif", face = "bold", hjust = 0.5))

