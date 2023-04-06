---------------------#2022.11.01 김정경
---<불투수토양포장> 시각화 데이터 생성  : impervious_land (year, 면적, 불투토포비, 포장범례, 자치구)

create table bnd_impervious_land as (select '2000' as year, geom, cast("고유번호" as character varying) as id, "면적" as area, "포장범례" as impervious_nm, '' as gu_nm, '' as gu_cd from biotope_map2000) ;
-- 27007
-- 속성 20으로 바꾸기

insert into bnd_impervious_land (select '2005', geom,"고유번호","면적","포장범례",'','' from biotope_map2005) ;
-- 37094

insert into bnd_impervious_land (select '2010', geom,"고유번호","면적","포장범례",'','' from biotope_map2010) ;
-- 38170

insert into bnd_impervious_land (select '2015', geom,"고유번호","면적","포장범례","자치구",'' from biotope_map2015) ;
-- 39418

insert into bnd_impervious_land (select '2020', ST_Transform(ST_SetSRID(geom,5174), 4326),"고유번호","면적","포장범례","자치구",'' from biotope_map2020) ;
-- 39862

---repair geometry
update bnd_impervious_land set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
-- UPDATE 285


---gu_nm update
update bnd_impervious_land as b
	set gu_nm = g.gu_nm
	from bnd_gu as g
	where left(b.id, 5) = g.id_left and b.gu_nm='';
-- UPDATE 102271


---다른방법
--update bnd_impervious_land as b
--set gu_nm = g.gu_nm
--from bnd_gu as g
--where year in ('2005', '2010') and left(b.id, 5) = g.id_left;


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_impervious_land
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


---gu_cd update
update bnd_impervious_land as b
	set gu_cd = g.gu_cd
	from bnd_gu as g
	where b.gu_nm = g.gu_nm;
-- UPDATE 181551


---확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_impervious_land
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


select year, impervious_nm, count(1)
from bnd_impervious_land
group by year, impervious_nm;


-- impervious_nm 업데이트
update bnd_impervious_land set impervious_nm = '10%이상~30%미만'
where "impervious_nm" = '10~30%미만';
--421

update bnd_impervious_land set impervious_nm = '30%이상~50%미만'
where "impervious_nm" = '30~50%미만';
--852

update bnd_impervious_land set impervious_nm = '50%이상~70%미만'
where "impervious_nm" = '50~70%미만';
--493

update bnd_impervious_land set impervious_nm = '70%이상~90%미만'
where "impervious_nm" = '70~90%미만';
--1716

