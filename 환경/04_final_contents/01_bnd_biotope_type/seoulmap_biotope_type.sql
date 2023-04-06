---------------------#2022.11.01 김정경
---<비오톱 유형> 시각화 데이터 생성  : biotope_type (year, 면적, 비오톱유형, 비오톱범례, 자치구)

create table bnd_biotope_type as (select '2005' as year, geom, "고유번호" as id, "면적" as area, "비오톱유형" as biotope_cd, '' as biotope_nm, '' as gu_nm, '' as gu_cd from biotope_map2005) ;
-- 37094

insert into bnd_biotope_type (select '2010', geom,"고유번호","면적","비오톱유형",'','','' from biotope_map2010) ;
-- 38170

insert into bnd_biotope_type (select '2015', geom,"고유번호","면적","비오톱유형","비오톱범례","자치구",'' from biotope_map2015) ;
--39418

insert into bnd_biotope_type (select '2020', ST_Transform(ST_SetSRID(geom,5174), 4326),"고유번호","면적","비오톱유형","비오톱범례","자치구",'' from biotope_map2020) ;
--39862

---repair geometry
update bnd_biotope_type set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
--UPDATE 285


select year, biotope_cd, biotope_nm, count(1)
from bnd_biotope_type
group by year, biotope_cd, biotope_nm
order by biotope_cd;


-- biotope_nm_org 필드 생성
ALTER TABLE IF EXISTS public.bnd_biotope_type
    ADD COLUMN biotope_nm_org character varying(20);


-- biotope_cd 와 biotope_nm 값이 상이하여, 데이터 확인 후, 업데이트 (기존 원본 데이터는 biotope_nm_org 필드 생성하여 보존)
update bnd_biotope_type set biotope_nm_org = biotope_nm;
-- UPDATE 154544


---biotope_nm 업데이트
with t as (select "비오톱유형", "비오톱범례", count(1)
	from biotope_map2020
	group by "비오톱유형", "비오톱범례"
	order by "비오톱유형")

update public.bnd_biotope_type as b
	set biotope_nm=t.비오톱범례
	from t
	where b.biotope_cd=t.비오톱유형;
-- UPDATE 154544


-- 확인작업
select count(*) from bnd_biotope_type
where "biotope_nm" != "biotope_nm_org";
-- 75271

select biotope_nm_org, count(*) from bnd_biotope_type
group by biotope_nm_org;
-- ''인 거 75264 & 잘못된 거 7

select year, biotope_cd, biotope_nm, count(1)
from bnd_biotope_type
group by year, biotope_cd, biotope_nm
order by biotope_cd;


---gu_nm update
update bnd_biotope_type as b
	set gu_nm = g.gu_nm
	from bnd_gu as g
	where left(b.id, 5) = g.id_left and b.gu_nm='';
-- UPDATE 75264


---다른방법
--update bnd_biotope_type as b
--set gu_nm = g.gu_nm
--from bnd_gu as g
--where year in ('2005', '2010') and left(b.id, 5) = g.id_left;


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_biotope_type
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---gu_cd update
update bnd_biotope_type as b
	set gu_cd = g.gu_cd
	from bnd_gu as g
	where b.gu_nm = g.gu_nm;
-- UPDATE 154544


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_biotope_type
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---확인작업
select biotope_cd, biotope_nm, count(1)-count(biotope_nm)
from bnd_biotope_type
group by biotope_cd, biotope_nm
order by biotope_cd;


select gu_cd, gu_nm, count(1)-count(gu_nm)
from bnd_biotope_type
group by gu_cd, gu_nm
order by gu_cd;

