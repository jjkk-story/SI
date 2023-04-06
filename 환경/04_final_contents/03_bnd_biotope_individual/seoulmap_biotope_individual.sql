---------------------#2022.11.01 김정경
---<비오톱 개별 평가> 시각화 데이터 생성  : biotope_individual (year, 면적, 개별평가, 자치구)

create table bnd_biotope_individual as (select '2005' as year, geom, "고유번호" as id, "면적" as area, "개별평가" as individual_nm, '' as gu_nm, '' as gu_cd from biotope_map2005) ;
-- 37094

insert into bnd_biotope_individual (select '2010', geom,"고유번호","면적","개별평가",'','' from biotope_map2010) ;
-- 38170

insert into bnd_biotope_individual (select '2015', geom,"고유번호","면적","개별평가","자치구",'' from biotope_map2015) ;
-- 39418

insert into bnd_biotope_individual (select '2020', ST_Transform(ST_SetSRID(geom,5174), 4326),"고유번호","면적","개별평가","자치구",'' from biotope_map2020) ;
-- 39862

---repair geometry
update bnd_biotope_individual set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
-- UPDATE 285


---gu_nm update
update bnd_biotope_individual as b
	set gu_nm = g.gu_nm
	from bnd_gu as g
	where left(b.id, 5) = g.id_left and b.gu_nm='';
-- UPDATE 75264


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_biotope_individual
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---gu_cd update
update bnd_biotope_individual as b
	set gu_cd = g.gu_cd
	from bnd_gu as g
	where b.gu_nm = g.gu_nm;
-- UPDATE 154544


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_biotope_individual
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---확인작업
select gu_cd, gu_nm, count(1)-count(gu_nm)
from bnd_biotope_individual
group by gu_cd, gu_nm
order by gu_cd;

