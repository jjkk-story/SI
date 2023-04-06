# -*- coding: utf-8 -*-
# # 교통 - 교통수단(traffic_mode)

# 서울 교통수단 시각화 코드

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

data <- read.csv("traffic_mode_data.csv", fileEncoding = 'UTF-8', stringsAsFactors = F)

str(data)

# 데이터를 보면 총 200개의 행과 5개의 열로 이루어져 있는 것을 확인할 수 있습니다.

# -----------------

# ## 2. 서울시 교통수단 분담률

# * 공간: 서울, 경기, 인천 중 서울 데이터 추출(sgis_si = 서울)
# * 시간: 1996년 - 2020년
# * 필요한 칼럼만 남기기(year, trsp_md, trip_volume, shr_usg)

trfc_md_shr_seoul_bar <- data %>% filter(sgis_si == "서울") %>%
  select(-sgis_si)

# 분담률의 합이 100%가 아닌 연도가 존재해서 분담률을 재계산해주었다.

# 연도별로 통행량을 합계
t <- trfc_md_shr_seoul_bar %>% group_by(year) %>%
  summarise(trip_volume_tot = sum(trip_volume))
#
# 데이터프레임 형태로 변경
t <- as.data.frame(t)
#
# 연도별 통행량 합 값을 각각 5번씩 반복
tt <- rep(t[,2], each = 5)
#
# 2개의 데이터셋을 열 방향으로 결합
trfc_md_shr_seoul_bar <- cbind(trfc_md_shr_seoul_bar, trip_volume_tot = tt)

# * 연도별 교통수단별 통행량과 연도별 통행량 합을 이용하여 분담률 계산
# * 필요한 칼럼만 남기기(year, trsp_md, shr_usg) 

trfc_md_shr_seoul_bar <- trfc_md_shr_seoul_bar %>% select(-shr_usg) %>%
  mutate(shr_usg = trip_volume / trip_volume_tot * 100) %>%
  select(-c(trip_volume, trip_volume_tot))

# 시각화 자료가 버스, 지하철, 승용차, 택시, 기타 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_md_shr_seoul_bar$trsp_md <- ifelse(trfc_md_shr_seoul_bar$trsp_md == '버스', '1.버스',
                                        ifelse(trfc_md_shr_seoul_bar$trsp_md == '지하철철도', '2.지하철',
                                               ifelse(trfc_md_shr_seoul_bar$trsp_md == '승용차', '3.승용차',
                                                      ifelse(trfc_md_shr_seoul_bar$trsp_md == '택시', '4.택시', '5.기타'))))

# ### 시각화

colorset <- c("#6C584C", "#A98467", "#ADC178", "#DDE5B6", "#F0EAD2")

sibar0(output.name="trfc_md_shr_seoul_bar", df=trfc_md_shr_seoul_bar, main.title="서울시 교통수단별 수단분담률", 
       chart.colorset=colorset, is.stack=TRUE, axis.lab="(%)", 
       bar.width="50%", bar.type="v", region1.max=100)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')

# -----------------

# ## 3. 경기도 교통수단 분담률

# * 공간: 서울, 경기, 인천 중 경기 데이터 추출(sgis_si = 경기)
# * 시간: 2002년 - 2020년
# * 필요한 칼럼만 남기기(year, trsp_md, trip_volume, shr_usg)

trfc_md_shr_ggd_bar <- data %>% filter(sgis_si == "경기") %>%
  select(-sgis_si)

# 분담률의 합이 100%가 아닌 연도가 존재해서 분담률을 재계산해주었다.

# 연도별로 통행량을 합계
t <- trfc_md_shr_ggd_bar %>% group_by(year) %>%
  summarise(trip_volume_tot = sum(trip_volume))
#
# 데이터프레임 형태로 변경
t <- as.data.frame(t)
#
# 연도별 통행량 합 값을 각각 5번씩 반복
tt <- rep(t[,2], each = 5)
#
# 2개의 데이터셋을 열 방향으로 결합
trfc_md_shr_ggd_bar <- cbind(trfc_md_shr_ggd_bar, trip_volume_tot = tt)

# * 연도별 교통수단별 통행량과 연도별 통행량 합을 이용하여 분담률 계산
# * 필요한 칼럼만 남기기(year, trsp_md, shr_usg) 

trfc_md_shr_ggd_bar <- trfc_md_shr_ggd_bar %>% select(-shr_usg) %>%
  mutate(shr_usg = trip_volume / trip_volume_tot * 100) %>%
  select(-c(trip_volume, trip_volume_tot))

# 시각화 자료가 버스, 지하철, 승용차, 택시, 기타 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_md_shr_ggd_bar$trsp_md <- ifelse(trfc_md_shr_ggd_bar$trsp_md == '버스', '1.버스',
                                      ifelse(trfc_md_shr_ggd_bar$trsp_md == '지하철', '2.지하철',
                                             ifelse(trfc_md_shr_ggd_bar$trsp_md == '승용차', '3.승용차',
                                                    ifelse(trfc_md_shr_ggd_bar$trsp_md == '택시', '4.택시', '5.기타'))))

# ### 시각화

colorset <- c("#6C584C", "#A98467", "#ADC178", "#DDE5B6", "#F0EAD2")

sibar0(output.name="trfc_md_shr_ggd_bar", df=trfc_md_shr_ggd_bar, main.title="서울시 교통수단별 수단분담률", 
       chart.colorset=colorset, is.stack=TRUE, axis.lab="(%)", 
       bar.width="50%", bar.type="v", region1.max=100)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')

# -----------------

# ## 4. 인천광역시 교통수단 분담률

# * 공간: 서울, 경기, 인천 중 인천 데이터 추출(sgis_si = 인천)
# * 시간: 2012년 - 2020년
# * 필요한 칼럼만 남기기(year, trsp_md, trip_volume, shr_usg)

trfc_md_shr_icn_bar <- data %>% filter(sgis_si == "인천") %>%
  select(-sgis_si)

# 분담률의 합이 100%가 아닌 연도가 존재해서 분담률을 재계산해주었다.

# 연도별로 통행량을 합계
t <- trfc_md_shr_icn_bar %>% group_by(year) %>%
  summarise(trip_volume_tot = sum(trip_volume))
#
# 데이터프레임 형태로 변경
t <- as.data.frame(t)
#
# 연도별 통행량 합 값을 각각 5번씩 반복
tt <- rep(t[,2], each = 5)
#
# 2개의 데이터셋을 열 방향으로 결합
trfc_md_shr_icn_bar <- cbind(trfc_md_shr_icn_bar, trip_volume_tot = tt)

# * 연도별 교통수단별 통행량과 연도별 통행량 합을 이용하여 분담률 계산
# * 필요한 칼럼만 남기기(year, trsp_md, shr_usg) 

trfc_md_shr_icn_bar <- trfc_md_shr_icn_bar %>% select(-shr_usg) %>%
  mutate(shr_usg = trip_volume / trip_volume_tot * 100) %>%
  select(-c(trip_volume, trip_volume_tot))

# 시각화 자료가 버스, 지하철, 승용차, 택시, 기타 순으로 올 수 있도록 라벨을 붙여줍니다.

trfc_md_shr_icn_bar$trsp_md <- ifelse(trfc_md_shr_icn_bar$trsp_md == '버스', '1.버스',
                                      ifelse(trfc_md_shr_icn_bar$trsp_md == '지하철', '2.지하철',
                                             ifelse(trfc_md_shr_icn_bar$trsp_md == '승용차', '3.승용차',
                                                    ifelse(trfc_md_shr_icn_bar$trsp_md == '택시', '4.택시', '5.기타'))))

# ### 시각화
colorset <- c("#6C584C", "#A98467", "#ADC178", "#DDE5B6", "#F0EAD2")

sibar0(output.name="trfc_md_shr_icn_bar", df=trfc_md_shr_icn_bar, main.title="서울시 교통수단별 수단분담률", 
       chart.colorset=colorset, is.stack=TRUE, axis.lab="(%)", 
       bar.width="50%", bar.type="v", region1.max=100)

display_html('<iframe width="100%" height="600" src="trfc_vlm_type_line.html"></iframe>')