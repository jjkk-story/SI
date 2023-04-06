# -*- coding: utf-8 -*-
# # 교통 - 통행(traffic_trip)

# 서울 통행 시각화 코드

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

data <- read.csv("traffic_trip_data.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)

str(data)

# 데이터를 보면 총 240개의 행과 5개의 열로 이루어져 있는 것을 확인할 수 있습니다.

data$trip_volume <- data$trip_volume / 1000 # 대 -> 천 대 변환

# -----------------

# ## 2. 수도권 목적통행량

# * 공간: 수도권
# * 시간: 2016년 - 2020년
# * key1(통행량 기준): 목적인 데이터 추출
# * 필요한 칼럼만 남기기(year, key2, trip, trip_volume)

trfc_prps_vlm_time_bar <- data %>% filter(key1 == "목적") %>% select(-key1)

# 시각화 자료가 귀가, 출근, 등교, 학교, 업무, 쇼핑, 여가, 배웅, 귀사, 기타 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_prps_vlm_time_bar$key2 <- ifelse(trfc_prps_vlm_time_bar$key2 == '귀가', '1.귀가', 
                                      ifelse(trfc_prps_vlm_time_bar$key2 == '출근', '2.출근', 
                                             ifelse(trfc_prps_vlm_time_bar$key2 == '등교', '3.등교', 
                                                    ifelse(trfc_prps_vlm_time_bar$key2 == '학원', '4.학원', 
                                                           ifelse(trfc_prps_vlm_time_bar$key2 == '업무', '5.업무', 
                                                                  ifelse(trfc_prps_vlm_time_bar$key2 == '쇼핑', '6.쇼핑',
                                                                         ifelse(trfc_prps_vlm_time_bar$key2 == '여가', '7.여가',
                                                                                ifelse(trfc_prps_vlm_time_bar$key2 == '배웅', '8.배웅',
                                                                                       ifelse(trfc_prps_vlm_time_bar$key2 == '귀사', '9.귀사', '기타')))))))))

# 시각화 자료가 서울-서울, 서울-비서울, 비서울-서울 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_prps_vlm_time_bar$trip <- ifelse(trfc_prps_vlm_time_bar$trip == '서울-서울', '1.서울-서울', 
                                      ifelse(trfc_prps_vlm_time_bar$trip == '서울-비서울', '2.서울-비서울', '3.비서울-서울'))

# ### 시각화

colorset <- c("BFC882","F0EAD2", "b08968")

sibar(output.name="trfc_prps_vlm_time_bar", df=trfc_prps_vlm_time_bar, main.title="수도권 목적통행량", 
      chart.colorset=colorset, is.stack=TRUE, axis.lab="(천 통행/일)", 
      bar.width="90%", bar.type="v", region1.max=35000, region2.max = 14000)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')

# -------------------

# ## 3. 수도권 수단통행량

# * 공간: 수도권
# * 시간: 2016년 - 2020년
# * key1(통행량 기준): 수단인 데이터 추출
# * 필요한 칼럼만 남기기(year, key2, trip, trip_volume)

trfc_md_vlm_time_bar <- data %>% filter(key1 == "수단") %>% select(-key1)

# 시각화 자료가 승용차, 버스, 지하철·철도(환승 미포함), 택시, 도보, 오토바이/기타 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_md_vlm_time_bar$key2 <- ifelse(trfc_md_vlm_time_bar$key2 == '승용차', '1.승용차', 
                                    ifelse(trfc_md_vlm_time_bar$key2 == '버스', '2.버스', 
                                           ifelse(trfc_md_vlm_time_bar$key2 == '지하철·철도(환승 미포함)', '3.지하철·철도(환승 미포함)', 
                                                  ifelse(trfc_md_vlm_time_bar$key2 == '택시', '4.택시', 
                                                         ifelse(trfc_md_vlm_time_bar$key2 == '도보', '5.도보', '6.오토바이/기타')))))

# 시각화 자료가 서울-서울, 서울-비서울, 비서울-서울 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_md_vlm_time_bar$trip <- ifelse(trfc_md_vlm_time_bar$trip == '서울-서울', '1.서울-서울', 
                                    ifelse(trfc_md_vlm_time_bar$trip == '서울-비서울', '2.서울-비서울', '3.비서울-서울'))

# ### 시각화

colorset <- c("BFC882","F0EAD2", "b08968")

sibar(output.name="trfc_md_vlm_time_bar", df=trfc_md_vlm_time_bar, main.title="수도권 수단통행량", 
      chart.colorset=colorset, is.stack=TRUE, axis.lab="(천 통행/일)", 
      bar.width="90%", bar.type="v", region1.max=38000, region2.max = 10000)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')