# -*- coding: utf-8 -*-
# # 교통 - 통행속도(traffic_speed)

# 서울 통행속도 시각화 코드

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

data <- read.csv("traffic_speed_data.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)

str(data)

# 데이터를 보면 총 296개의 행과 4개의 열로 이루어져 있는 것을 확인할 수 있습니다.

# -----------------

# ## 2. 서울시 차종 지역별 통행속도

# ### 데이터 가공

# * 공간: 서울시
# * 시간: 1995년 - 2021년
# * key1(통행속도 기준): 차종 지역인 데이터 추출
# * 필요한 칼럼만 남기기(year, key2, speed)

trfc_spd_line <- data %>% filter(key1 == "차종 지역") %>% select(-key1)

# 시각화 자료가 승용차(전체), 승용차(도심), 승용차(외곽), 버스 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_spd_line$key2 <- ifelse(trfc_spd_line$key2 == '승용차(전체)', '1.승용차(전체)',
                             ifelse(trfc_spd_line$key2 == '승용차(도심)', '2.승용차(도심)',
                                    ifelse(trfc_spd_line$key2 == '승용차(외곽)', '3.승용차(외곽)', '4.버스')))

# ### 시각화

colorset <- c("#6C584C", "#B08968", "#EDE0D4", "#ADC178")

siline0(output.name="trfc_spd_line", df=trfc_spd_line, main.title="서울시 차종 지역별 통행속도", 
        chart.colorset=colorset, axis.lab="(km/h)", point.size=8, 
        line.width=3, region1.max=0, region1.min=0)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')

# -------------------

# ## 3. 서울시 승용차의 요일별 통행속도

# ### 데이터 가공

# * 공간: 서울시
# * 시간: 2004년 - 2021년
# * key1(통행속도 기준): 요일별인 데이터 추출
# * 필요한 칼럼만 남기기(year, key2, speed)

trfc_dow_spd_line <- data %>% filter(key1 == "요일별") %>% select(-key1)

# 시각화 자료가 월요일, 화요일, 수요일, 목요일, 금요일, 토요일, 일요일 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_dow_spd_line$key2 <- ifelse(trfc_dow_spd_line$key2 == '월', '1.월요일',
                                 ifelse(trfc_dow_spd_line$key2 == '화', '2.화요일',
                                        ifelse(trfc_dow_spd_line$key2 == '수', '3.수요일',
                                               ifelse(trfc_dow_spd_line$key2 == '목', '4.목요일',
                                                      ifelse(trfc_dow_spd_line$key2 == '금', '5.금요일',
                                                             ifelse(trfc_dow_spd_line$key2 == '토', '6.토요일', '7.일요일'))))))

# ### 시각화

colorset <- c("#A44A3F","#F19C79","#F6F4D2","#CBDFBD","#ADC178","#A98467","#6C584C")

siline0(output.name="trfc_dow_spd_line", df=trfc_dow_spd_line, main.title="서울시 요일별 통행속도", 
        chart.colorset=colorset, axis.lab="(km/h)", point.size=8, 
        line.width=3, region1.max=0, region1.min=0)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')

# -------------------

# ## 4. 서울시 승용차의 시간대별 통행속도

# ### 데이터 가공

# * 공간: 서울시
# * 시간: 1999년 - 2021년
# * key1(통행속도 기준): 시간대별인 데이터 추출
# * 필요한 칼럼만 남기기(year, key2, speed)

trfc_time_spd_line <- data %>% filter(key1 == "시간대별") %>% select(-key1)

# 시각화 자료가 오전, 낮, 오후, 전일 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_time_spd_line$key2 <- ifelse(trfc_time_spd_line$key2 == '오전', '1.오전',
                                  ifelse(trfc_time_spd_line$key2 == '낮', '2.낮',
                                         ifelse(trfc_time_spd_line$key2 == '오후', '3.오후', '4.전일')))

# ### 시각화

colorset <- c("#6C584C", "#B08968", "#EDE0D4", "#ADC178")

siline0(output.name="trfc_time_spd_line", df=trfc_time_spd_line, main.title="서울시 시간대별 통행속도", 
        chart.colorset=colorset, axis.lab="(km/h)", point.size=8, 
        line.width=3, region1.max=0, region1.min=0)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')