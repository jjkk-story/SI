---------------------#2023.02.15 김정경
---<용도지구> 시각화 데이터 생성
---원본데이터: 서울시 용도지구 공간정보

--컬럼 설명(코멘트) 입력
comment on column public.bnd_prps_dstrct.present_sn is '현황도형 관리번호';
comment on column public.bnd_prps_dstrct.lclas_cl is '도형 대분류코드';
comment on column public.bnd_prps_dstrct.mlsfc_cl is '도형 중분류코드';
comment on column public.bnd_prps_dstrct.sclas_cl is '도형 소분류코드';
comment on column public.bnd_prps_dstrct.atrb_se is '도형 속성코드';
comment on column public.bnd_prps_dstrct.wtnnc_sn is '도형 조서관리 코드';
comment on column public.bnd_prps_dstrct.ntfc_sn is '결정고시관리 코드';
comment on column public.bnd_prps_dstrct.dgm_nm is '라벨명';
comment on column public.bnd_prps_dstrct.dgm_ar is '면적';
comment on column public.bnd_prps_dstrct.dgm_lt is '길이';
comment on column public.bnd_prps_dstrct.signgu_se is '시군구코드';
comment on column public.bnd_prps_dstrct.drawing_no is '도면번호';
comment on column public.bnd_prps_dstrct.create_dat is '현황도형 생성일시';

select *
from bnd_prps_dstrct
limit 100


---repair geometry
update bnd_prps_dstrct set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
--UPDATE 0


-- dgm_nm_org 필드 생성
ALTER TABLE IF EXISTS public.bnd_prps_dstrct
    ADD COLUMN dgm_nm_org character varying(60);


-- dgm_nm 값이 상이하여 데이터 확인 후, 업데이트 (기존 원본 데이터는 dgm_nm_org 필드 생성하여 보존)
update bnd_prps_dstrct set dgm_nm_org = dgm_nm;
-- UPDATE 398


-- dgm_nm 업데이트
update bnd_prps_dstrct as b
	set dgm_nm = d.dgm_nm
	from bnd_dstrct as d
	where b.atrb_se = d.atrb_se
-- UPDATE 398


-- 뷰테이블 생성하여 ST_Union 잘 되는지 확인해 보기
-- 용도지구(bnd_prps_dstrct)
create view bnd_prps_dstrct_dsv as
select dgm_nm, st_union(geom)
from bnd_prps_dstrct
group by dgm_nm;

select * from bnd_prps_dstrct_dsv
order by dgm_nm;

drop view bnd_prps_dstrct_dsv;


-- 정상 결과 확인 후 물리적 테이블 생성
create table bnd_prps_dstrct_dsv as
select dgm_nm, st_union(geom)
from bnd_prps_dstrct
group by dgm_nm;

