# -*- coding: utf-8 -*-
# # 교통 - 교통량(traffic_volume)

# 서울 교통량 시각화 코드

# Code by. 행정안전부 데이터분석 청년인턴 김정경 (서울연구원)
# 2022-10-20

# ### 라이브러리

## 데이터 가공
library(dplyr)
library(reshape)

## 시각화
library(remotes)
library("SIChart")
library(IRdisplay)

# ## 1. 데이터 로드

data <- read.csv("traffic_volume_data.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)

str(data)

# 데이터를 보면 총 540개의 행과 4개의 열로 이루어져 있는 것을 확인할 수 있습니다.

data$volume <- data$volume / 1000 # 대 -> 천 대 변환

# -----------------

# ## 2. 서울시 주요 지점별 교통량

# * 공간: 서울시
# * 시간: 2018년 - 2021년
# * 도로 유형 : 도심(road_type = 도심), 교량(road_type = 교량), 간선(road_type = 간선), 시계(road_type = 시계), 도시고속(road_type = 도시고속)
# * 연도별 도로 유형별로 교통량을 합계

trfc_vlm_type_line <- data %>% group_by(year, road_type) %>%
  summarise(volume_tot = sum(volume))

# 시각화 자료가 도심, 교량, 간선, 시계, 도시고속 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_vlm_type_line$road_type <- ifelse(trfc_vlm_type_line$road_type == '교량', '2.교량', 
                                       ifelse(trfc_vlm_type_line$road_type == '간선', '3.간선', 
                                              ifelse(trfc_vlm_type_line$road_type == '시계', '4.시계', 
                                                     ifelse(trfc_vlm_type_line$road_type == '도시고속', '5.도시고속', '1.도심'))))

# ### 시각화

colorset <- c("#6C584C", "#A98467", "#ADC178", "#DDE5B6", "#F0EAD2")

siline0(output.name="trfc_vlm_type_line", df=trfc_vlm_type_line, main.title="주요 지점별 교통량", 
        chart.colorset=colorset, axis.lab="(천 대/일)", point.size=10, 
        line.width=4, region1.max=0, region1.min=0)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')