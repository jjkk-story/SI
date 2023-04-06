---------------------#2023.02.09 김정경
---<용도지역> 시각화 데이터 생성
---원본데이터: 서울시 용도지역(도시지역) 공간정보

--컬럼 설명(코멘트) 입력
comment on column public.bnd_prps_area.present_sn is '현황도형 관리번호';
comment on column public.bnd_prps_area.lclas_cl is '도형 대분류코드';
comment on column public.bnd_prps_area.mlsfc_cl is '도형 중분류코드';
comment on column public.bnd_prps_area.sclas_cl is '도형 소분류코드';
comment on column public.bnd_prps_area.atrb_se is '도형 속성코드';
comment on column public.bnd_prps_area.wtnnc_sn is '도형 조서관리 코드';
comment on column public.bnd_prps_area.ntfc_sn is '결정고시관리 코드';
comment on column public.bnd_prps_area.dgm_nm is '라벨명';
comment on column public.bnd_prps_area.dgm_ar is '면적';
comment on column public.bnd_prps_area.dgm_lt is '길이';
comment on column public.bnd_prps_area.signgu_se is '시군구코드';
comment on column public.bnd_prps_area.drawing_no is '도면번호';
comment on column public.bnd_prps_area.create_dat is '현황도형 생성일시';
comment on column public.bnd_prps_area.shape_area is '면적(도형)';
comment on column public.bnd_prps_area.shape_len is '길이(도형)';

select *
from bnd_prps_area
limit 100


---repair geometry
update bnd_prps_area set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
--UPDATE 40


-- dgm_nm_org 필드 생성
ALTER TABLE IF EXISTS public.bnd_prps_area
    ADD COLUMN dgm_nm_org character varying(20);


-- dgm_nm 값이 상이하여 데이터 확인 후, 업데이트 (기존 원본 데이터는 dgm_nm_org 필드 생성하여 보존)
update bnd_prps_area set dgm_nm_org = dgm_nm;
-- UPDATE 7552


-- dgm_nm 업데이트
update bnd_prps_area as b
	set dgm_nm = p.dgm_nm
	from bnd_prps as p
	where b.atrb_se = p.atrb_se
-- UPDATE 7550


-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 용도지역(bnd_prps_area)
create view bnd_prps_area_dsv as
select atrb_se, dgm_nm, st_union(geom)
from bnd_prps_area
group by atrb_se, dgm_nm;

select * from bnd_prps_area_dsv
order by dgm_nm;

drop view bnd_prps_area_dsv;


-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_prps_area_dsv as
select atrb_se, dgm_nm, st_union(geom)
from bnd_prps_area
group by atrb_se, dgm_nm;

