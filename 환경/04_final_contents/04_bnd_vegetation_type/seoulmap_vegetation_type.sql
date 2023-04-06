---------------------#2022.11.01 김정경
---<현존식생> 시각화 데이터 생성  : vegetation_type (year, 면적, 현존식생, 식생범례, 자치구)

create table bnd_vegetation_type as (select '2000' as year, geom, cast("고유번호" as character varying) as id, "면적" as area, "현존식생" as vegetation_cd, "우점종식생" as dominant_vegetation_cd, "식생범례" as vegetation_nm, '' as gu_nm, '' as gu_cd from biotope_map2000) ;
-- 27007

insert into bnd_vegetation_type (select '2005', geom,"고유번호","면적","현존식생","우점종식생","식생범례",'','' from biotope_map2005) ;
-- 37094

insert into bnd_vegetation_type (select '2010', geom,"고유번호","면적","현존식생","우점종식생","식생범례",'','' from biotope_map2010) ;
-- 38170

insert into bnd_vegetation_type (select '2015', geom,"고유번호","면적","현존식생","우점종식생","식생범례","자치구",'' from biotope_map2015) ;
-- 39418

insert into bnd_vegetation_type (select '2020', ST_Transform(ST_SetSRID(geom,5174), 4326),"고유번호","면적","현존식생","우점종식생","식생범례","자치구",'' from biotope_map2020) ;
-- 39862

---repair geometry
update bnd_vegetation_type set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
-- UPDATE 285


---gu_nm update
update bnd_vegetation_type as b
	set gu_nm = g.gu_nm
	from bnd_gu as g
	where left(b.id, 5) = g.id_left and b.gu_nm='';
-- UPDATE 102271


---다른방법
--update bnd_vegetation_type as b
--set gu_nm = g.gu_nm
--from bnd_gu as g
--where year in ('2005', '2010') and left(b.id, 5) = g.id_left;


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_vegetation_type
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---gu_cd update
update bnd_vegetation_type as b
	set gu_cd = g.gu_cd
	from bnd_gu as g
	where b.gu_nm = g.gu_nm;
-- UPDATE 181551


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_vegetation_type
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


select year, vegetation_cd, dominant_vegetation_cd, vegetation_nm, count(1)
from bnd_vegetation_type
group by year, vegetation_cd, dominant_vegetation_cd, vegetation_nm
order by vegetation_cd;


-- vegetation_nm_org 필드 생성
ALTER TABLE IF EXISTS public.bnd_vegetation_type
    ADD COLUMN vegetation_nm_org character varying(20);

-- vegetation_nm 값이 상이하여, 데이터 확인 후, 업데이트 (기존 원본 데이터는 vegetation_nm_org 필드 생성하여 보존)
update bnd_vegetation_type set vegetation_nm_org = vegetation_nm;
-- UPDATE 181551


-- vegetation_nm 업데이트
update bnd_vegetation_type set vegetation_nm = '시가화지역'
where year = '2005' and "dominant_vegetation_cd" = 'A1' and "vegetation_nm" = '도로';
--2

update bnd_vegetation_type set vegetation_nm = '도로'
where year = '2005' and "dominant_vegetation_cd" = 'A2' and "vegetation_nm" = '시가화지역' and id = '12537608087115';
--1

update bnd_vegetation_type set vegetation_nm = '시가화지역'
where year = '2015' and "vegetation_cd" = 'A1' and "dominant_vegetation_cd" = 'A2' and "vegetation_nm" = '도로';
--1

update bnd_vegetation_type set vegetation_nm = '시가화지역'
where year = '2015' and "vegetation_cd" = 'A1' and "dominant_vegetation_cd" = 'B' and "vegetation_nm" = '조경수목식재지';
--1

update bnd_vegetation_type set vegetation_nm = '도로'
where year = '2015' and "vegetation_cd" = 'A2' and "dominant_vegetation_cd" = 'A1' and "vegetation_nm" = '시가화지역';
--1

update bnd_vegetation_type set vegetation_nm = '조경수목식재지'
where year = '2005' and "vegetation_cd" = 'B3' and "dominant_vegetation_cd" = 'V' and "vegetation_nm" = '기타산림';
--1

update bnd_vegetation_type set vegetation_nm = '조경수목식재지'
where year = '2015' and "vegetation_cd" = 'B3' and "dominant_vegetation_cd" = 'ZF' and "vegetation_nm" = '기타산림';
--1

update bnd_vegetation_type set vegetation_nm = '조경수목식재지'
where year = '2005' and "vegetation_cd" = 'B5' and "dominant_vegetation_cd" = 'V' and "vegetation_nm" = '기타산림';
--1

update bnd_vegetation_type set vegetation_nm = '조경수목식재지'
where year = '2005' and "vegetation_cd" = 'C7' and "dominant_vegetation_cd" = 'C' and "vegetation_nm" = '수면';
--2

update bnd_vegetation_type set vegetation_nm = '수면'
where year = '2000' and "vegetation_cd" = 'C7' and "dominant_vegetation_cd" = 'C7' and "vegetation_nm" = '하천및호소';
--478

update bnd_vegetation_type set vegetation_nm = '나지'
where year = '2000' and "vegetation_cd" = 'C8' and "dominant_vegetation_cd" = 'C' and "vegetation_nm" = '초지';
--434

update bnd_vegetation_type set vegetation_nm = '나지'
where year = '2000' and "vegetation_cd" = 'C8' and "dominant_vegetation_cd" = 'C' and "vegetation_nm" = '초지';
--434

update bnd_vegetation_type set vegetation_nm = '나지'
where year = '2015' and "vegetation_cd" = 'C8' and "dominant_vegetation_cd" = 'C' and "vegetation_nm" = '초지';
--7

update bnd_vegetation_type set vegetation_nm = '호안블럭'
where year = '2015' and "vegetation_cd" = 'C9' and "dominant_vegetation_cd" = 'C' and "vegetation_nm" = '초지';
--1

update bnd_vegetation_type set vegetation_nm = '경작지'
where year = '2005' and "vegetation_cd" = 'D2' and "dominant_vegetation_cd" = 'Q' and "vegetation_nm" = '참나무림';
--1

update bnd_vegetation_type set vegetation_nm = '벌채지 및 암석노출지'
where year = '2000' and "vegetation_cd" = 'E1' and "dominant_vegetation_cd" = 'E1' and "vegetation_nm" = '벌채지및암석노출지';
--8

update bnd_vegetation_type set vegetation_nm = '벌채지 및 암석노출지'
where year = '2015' and "vegetation_cd" = 'E1' and "dominant_vegetation_cd" = 'E1' and "vegetation_nm" = '벌채지 및 나지';
--2

update bnd_vegetation_type set vegetation_nm = '벌채지 및 암석노출지'
where year = '2000' and "vegetation_cd" = 'E2' and "dominant_vegetation_cd" = 'E2' and "vegetation_nm" = '벌채지및암석노출지';
--50

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2005' and "vegetation_cd" = 'I0' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--40

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2010' and "vegetation_cd" = 'I0' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--40

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2015' and "vegetation_cd" = 'I0' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--40

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2015' and "vegetation_cd" = 'I000' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--5

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2015' and "vegetation_cd" = 'I002' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--2

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2015' and "vegetation_cd" = 'I010' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--3

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2005' and "vegetation_cd" = 'I1' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--6

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2010' and "vegetation_cd" = 'I1' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--7

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2015' and "vegetation_cd" = 'I1' and "dominant_vegetation_cd" = 'I' and "vegetation_nm" = '일본잎갈나무';
--9

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where "vegetation_nm" = '일본잎갈나무';
--121

update bnd_vegetation_type set vegetation_nm = '일본잎갈나무림'
where year = '2005' and "vegetation_cd" = 'I12' and "dominant_vegetation_cd" = 'H' and "vegetation_nm" = '현사시나무림';
--1

update bnd_vegetation_type set vegetation_nm = '밤나무림'
where year = '2005' and "vegetation_cd" = 'JF22' and "dominant_vegetation_cd" = 'F' and "vegetation_nm" = '아까시나무림';
--1

update bnd_vegetation_type set vegetation_nm = '리기다소나무림'
where year = '2005' and "vegetation_cd" = 'K02' and "dominant_vegetation_cd" = 'M' and "vegetation_nm" = '소나무림';
--1

update bnd_vegetation_type set vegetation_nm = '리기다소나무림'
where year = '2005' and "vegetation_cd" = 'KM22' and "dominant_vegetation_cd" = 'N' and "vegetation_nm" = '참나무림';
--1

update bnd_vegetation_type set vegetation_nm = '소나무림'
where year = '2005' and "vegetation_cd" = 'MK22' and "dominant_vegetation_cd" = 'K' and "vegetation_nm" = '리기다소나무림';
--1

update bnd_vegetation_type set vegetation_nm = '참나무림'
where year = '2005' and "vegetation_cd" = 'NK02' and "dominant_vegetation_cd" = 'K' and "vegetation_nm" = '리기다소나무림';
--1

update bnd_vegetation_type set vegetation_nm = '참나무림'
where year = '2005' and "vegetation_cd" = 'NR00' and "dominant_vegetation_cd" = 'M' and "vegetation_nm" = '소나무림';
--1

update bnd_vegetation_type set vegetation_nm = '참나무림'
where year = '2000' and "vegetation_cd" = 'R0' and "dominant_vegetation_cd" = 'F' and "vegetation_nm" = '아까시나무림';
--1

update bnd_vegetation_type set vegetation_nm = '참나무림'
where year = '2005' and "vegetation_cd" = 'R0' and "dominant_vegetation_cd" = 'F' and "vegetation_nm" = '아까시나무림';
--1

update bnd_vegetation_type set vegetation_nm = '참나무림'
where year = '2010' and "vegetation_cd" = 'R1' and "dominant_vegetation_cd" = 'R' and "vegetation_nm" = '아까시나무림';
--1

update bnd_vegetation_type set vegetation_nm = '가중나무림'
where "vegetation_nm" = '가중나무';
--47

update bnd_vegetation_type set vegetation_nm = '기타산림'
where year = '2005' and "vegetation_cd" = 'ZeMP0' and "dominant_vegetation_cd" = 'M' and "vegetation_nm" = '소나무림';
--1

update bnd_vegetation_type set vegetation_nm = '기타산림'
where year = '2015' and "vegetation_cd" = 'ZI111' and "dominant_vegetation_cd" = 'ZI' and "vegetation_nm" = '소나무림';
--1



select year, vegetation_cd, dominant_vegetation_cd, vegetation_nm, count(1)
from bnd_vegetation_type
group by year, vegetation_cd, dominant_vegetation_cd, vegetation_nm
order by vegetation_cd;

