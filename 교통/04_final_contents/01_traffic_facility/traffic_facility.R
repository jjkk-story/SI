# -*- coding: utf-8 -*-
# # 교통 - 도로시설(traffic_facility)

# 서울 도로시설 시각화 코드

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

data <- read.csv("traffic_facility_data.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)

str(data)

# 데이터를 보면 총 1829개의 행과 7개의 열로 이루어져 있는 것을 확인할 수 있습니다.
# 또한 value 값인 road_area의 값이 chr 형태이므로 숫자로 변환해줍니다.
#
# 이때 이상값들이 NA로 변환되고, NA를 모두 0으로 바꿔줍니다. 

data$road_len <- data$road_len / 1000 # m -> km 변환

data$road_area <- as.numeric(data$road_area) # '-'가 NA로 변환
data$road_area[is.na(data$road_area)] <- 0 # NA를 0으로 변환
data$road_area <- data$road_area / 1000000 # m² -> km² 변환

# -----------------

# ## 2. 서울시 도로 총연장

# ### 데이터 가공

# * 공간: 서울의 시 단위 데이터 추출(sgis_gu = 소계)
# * 시간: 1979년 - 2021년
# * 도로 포장 상태: 미포장(road_stts = 미포장), 포장(road_stts = 포장)인 데이터 추출
# * 필요한 칼럼만 남기기(year, road_stts, road_len)

trfc_road_len_bar <- data %>% filter(sgis_gu == "소계") %>%
  filter(road_stts != "계") %>%
  select(c(year, road_stts, road_len))

# 시각화 자료가 포장도로, 비포장도로 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_road_len_bar$road_stts <- ifelse(trfc_road_len_bar$road_stts == '미포장','2.비포장도로','1.포장도로')

# 연도 별로 도로 포장 상태(1,2)가 존재하지 않으면 시각화가 불가능합니다.
# 그러므로 연도 별로 존재하지 않는 도로 포장 상태가 있는지 확인하고 넣어줍니다.

# 2008년도부터 2021년도까지 2.비포장도로 데이터가 존재하지 않음
trfc_road_len_bar %>%
  filter(year %in% c(2008:2021)) %>%
  distinct(road_stts)

# 2008년도부터 2021년도까지 연도 셋 준비
trfc_road_len_bar %>%
  filter(year %in% c(2008:2021)) %>%
  distinct(year) -> tt
#
tt <- as.data.frame(tt)

# 연도별 2.비포장도로 셋 생성
tt$road_stts <- rep('2.비포장도로', nrow(tt))
tt$road_len <- rep(0, 14)
#
# 행 합치기
trfc_road_len_bar <- rbind(trfc_road_len_bar, tt)

# ### 시각화

colorset <- c("#BFC882", "#b08968")

sibar0(output.name="trfc_road_len_bar", df=trfc_road_len_bar, main.title="서울시 도로 총연장", 
       chart.colorset=colorset, is.stack=TRUE, axis.lab="(km)", 
       bar.width="60%", bar.type="v", region1.max=10000)

display_html('<iframe width="100%" height="600" src="trfc_road_len_bar.html"></iframe>')

# -------------------

# ## 3. 서울시 구별 도로율

# ### 데이터 가공

# * 공간: 서울의 시군구 단위 데이터 추출(sgis_gu != 소계)
# * 시간: 2004년 - 2021년
# * 도로 포장 상태: 계(road_stts = 계)인 데이터 추출
# * 필요한 칼럼만 남기기(year, sgis_gu, road_rt)

trfc_gu_road_rt_time_map <- data %>% filter(sgis_gu != "소계" & road_stts == "계" & year >= 2004) %>%
  select(c(year, sgis_gu, road_rt))

# ### 시각화

colorset <- c("#BFC882", "#b08968")

simap(output.name="trfc_gu_road_rt_time_map", df=trfc_gu_road_rt_time_map,
      main.title="서울시 구별 도로율변화", chart.colorset=colorset,
      chart.grades = seq(16, 28, 2), axis.lab="%") # min : 16.09, max : 28.83

display_html('<iframe width="100%" height="600" src="trfc_gu_road_rt_time_map.html"></iframe>')

# -------------------

# ## 4. 서울시 구별 도로 연장

# ### 데이터 가공

# * 공간: 서울의 시군구 단위 데이터 추출(sgis_gu != 소계)
# * 시간: 1993년 - 2021년
# * 도로 포장 상태: 계(road_stts = 계)인 데이터 추출
# * 필요한 칼럼만 남기기(year, sgis_gu, road_len)

trfc_gu_road_len_time_bar <- data %>% filter(year >= 1993 & sgis_gu != "소계" & road_stts == "계") %>%
  select(c(year, sgis_gu, road_len))

# 연장 데이터임을 나타내는 칼럼 추가
trfc_gu_road_len_time_bar <- cbind(trfc_gu_road_len_time_bar, c3 = rep("연장", nrow(trfc_gu_road_len_time_bar)))
#
# 칼럼 순서 변경
trfc_gu_road_len_time_bar <- trfc_gu_road_len_time_bar[c(1,2,4,3)]

# ### 시각화

colorset <- c("#BFC882")

sibar(output.name="trfc_gu_road_len_time_bar", df=trfc_gu_road_len_time_bar, main.title="서울시 구별 연장변화",
      chart.colorset=colorset, is.stack=TRUE, axis.lab="(km)",
      bar.width="90%", bar.type="v", region1.max=10000, region2.max = 800)

display_html('<iframe width="100%" height="600" src="trfc_gu_road_len_time_bar.html"></iframe>')

# -------------------

# ## 5. 서울시 구별 도로 면적

# ### 데이터 가공

# * 공간: 서울의 시군구 단위 데이터 추출(sgis_gu != 소계)
# * 시간: 2000년 - 2021년
# * 도로 포장 상태: 계(road_stts = 계)인 데이터 추출
# * 필요한 칼럼만 남기기(year, sgis_gu, road_area)

trfc_gu_road_area_time_bar <- data %>% filter(year >= 2000 & sgis_gu != "소계" & road_stts == "계") %>%
  select(c(year, sgis_gu, road_area))

# 면적 데이터임을 나타내는 칼럼 추가
trfc_gu_road_area_time_bar <- cbind(trfc_gu_road_area_time_bar, c3 = rep("면적", nrow(trfc_gu_road_area_time_bar)))
#
# 칼럼 순서 변경
trfc_gu_road_area_time_bar <- trfc_gu_road_area_time_bar[c(1,2,4,3)]

# ### 시각화

colorset <- c("#b08968")

sibar(output.name="trfc_gu_road_area_time_bar", df=trfc_gu_road_area_time_bar, main.title="서울시 구별 면적변화",
      chart.colorset=colorset, is.stack=TRUE, axis.lab="(km²)",
      bar.width="90%", bar.type="v", region1.max=100, region2.max = 8)

display_html('<iframe width="100%" height="600" src="trfc_gu_road_area_time_bar.html"></iframe>')