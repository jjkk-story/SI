-- 2022.11.10 박현주
-- 참고자료 p:\SeoulMap2020\인턴공유\99_GIS\[PostGIS] Solution Guide V0.95.pdf (52페이지 ST_Union)

-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 토지이용(bnd_landuse)
create view bnd_landuse_dsv as
select year, gu_nm, landuse_nm, sum(area), st_union(geom)
from bnd_landuse
group by year, gu_nm, landuse_nm;

select * from bnd_landuse_dsv
order by year, gu_nm, landuse_nm;

drop view bnd_landuse_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_landuse_dsv as
select year, gu_nm, landuse_nm, sum(area), st_union(geom)
from bnd_landuse
group by year, gu_nm, landuse_nm;



-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 비오톱유형(bnd_biotope_type)
create view bnd_biotope_type_dsv as
select year, gu_nm, biotope_nm, sum(area), st_union(geom)
from bnd_biotope_type
group by year, gu_nm, biotope_nm;

select * from bnd_biotope_type_dsv
order by year, gu_nm, biotope_nm;

drop view bnd_biotope_type_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_biotope_type_dsv as
select year, gu_nm, biotope_nm, sum(area), st_union(geom)
from bnd_biotope_type
group by year, gu_nm, biotope_nm;



-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 비오톱유형평가(bnd_biotope_assessments)
create view bnd_biotope_assessments_dsv as
select year, gu_nm, assessments_nm, sum(area), st_union(geom)
from bnd_biotope_assessments
group by year, gu_nm, assessments_nm;

select * from bnd_biotope_assessments_dsv
order by year, gu_nm, assessments_nm;

drop view bnd_biotope_assessments_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_biotope_assessments_dsv as
select year, gu_nm, assessments_nm, sum(area), st_union(geom)
from bnd_biotope_assessments
group by year, gu_nm, assessments_nm;



-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 개별비오톱평가(bnd_biotope_individual)
create view bnd_biotope_individual_dsv as
select year, gu_nm, individual_nm, sum(area), st_union(geom)
from bnd_biotope_individual
group by year, gu_nm, individual_nm;

select * from bnd_biotope_individual_dsv
order by year, gu_nm, individual_nm;

drop view bnd_biotope_individual_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_biotope_individual_dsv as
select year, gu_nm, individual_nm, sum(area), st_union(geom)
from bnd_biotope_individual
group by year, gu_nm, individual_nm;



-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 현존식생(bnd_vegetation_type)
create view bnd_vegetation_type_dsv as
select year, gu_nm, vegetation_nm, sum(area), st_union(geom)
from bnd_vegetation_type
group by year, gu_nm, vegetation_nm;

select * from bnd_vegetation_type_dsv
order by year, gu_nm, vegetation_nm;

drop view bnd_vegetation_type_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_vegetation_type_dsv as
select year, gu_nm, vegetation_nm, sum(area), st_union(geom)
from bnd_vegetation_type
group by year, gu_nm, vegetation_nm;



-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 불투수토양포장(bnd_impervious_land)
create view bnd_impervious_land_dsv as
select year, gu_nm, impervious_nm, sum(area), st_union(geom)
from bnd_impervious_land
group by year, gu_nm, impervious_nm;

select * from bnd_impervious_land_dsv
order by year, gu_nm, impervious_nm;

drop view bnd_impervious_land_dsv;

-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_impervious_land_dsv as
select year, gu_nm, impervious_nm, sum(area), st_union(geom)
from bnd_impervious_land
group by year, gu_nm, impervious_nm;


