---------------------#2022.11.03 김정경
---<고유번호, 자치구> 데이터 생성 : gu (고유번호, 자치구, 자치구코드)

create table bnd_gu (
	id_left text,
	gu_nm varchar(10),
	gu_cd text
);

--- bnd_gu.csv import (option - header 표시하기)