--#2022.10.27 최선희
--작업내용 : bnd_landuse 2020년 기준으로 update
------ 자치구 코드 참고
create view tmp_gu as (select gu_nm, gu_cd from bnd_landuse where year = '2015' group by gu_nm, gu_cd);

------ 데이터 확인(테스트)
COLUMN geom TYPE geometry(MultiPoint,4326) USING ST_Transform(ST_SetSRID(geom,5179), 4326);
select ST_ASText(ST_Transform(ST_SetSRID(geom,5174), 4326)) from biotope_map2020 limit 100;

------ 2020년 데이터 추가 (biotope_map2020  -> bnd_landuse )
insert into bnd_landuse (select '2020', ST_Transform(ST_SetSRID(geom,5174), 4326), "고유번호","면적","토지이용","이용범례","자치구", '' from biotope_map2020);
------ 39,862건

------ 구 코드 추가
--join 해서 update
update bnd_landuse AS t1
set gu_cd = b.gu_cd from (select * from tmp_gu) AS b where t1.year = '2020' and t1.gu_nm = b.gu_nm ;

------ 자치구 코드 참조 뷰 삭제
drop view tmp_gu ;

------ repair geomery 실행 전 확인
SELECT year, count(*) FROM public.bnd_landuse where st_isvalid(geom) = 'f' group by year;
------ 실행결과:
"2005"	75
"2010"	80
"2015"	64
"2020"	66

------ buffer(0)을 통해 간단한 geometry 오류 해결
update public.bnd_landuse set geom = st_multi(st_buffer(geom, 0.0)) where st_isvalid(geom) = 'f';
------ 실행 결과:
알림:  Ring Self-intersection at or near point 127.0810817825361 37.548094431951981
알림:  Ring Self-intersection at or near point 127.02914373165238 37.685121183072233
알림:  Ring Self-intersection at or near point 127.02914373198143 37.685121183553548
알림:  Ring Self-intersection at or near point 127.0110616971803 37.683251081758328
알림:  Ring Self-intersection at or near point 127.04074878759965 37.677718425834819
알림:  Ring Self-intersection at or near point 127.02914373165238 37.685121183072233
알림:  Ring Self-intersection at or near point 126.97088816749782 37.610294486878367
알림:  Ring Self-intersection at or near point 126.98510062897421 37.579228735836693
알림:  Ring Self-intersection at or near point 126.98951429475829 37.592620693097153
알림:  Ring Self-intersection at or near point 126.94327166997503 37.549194256038383
알림:  Ring Self-intersection at or near point 127.03599834918248 37.563760092402681
알림:  Ring Self-intersection at or near point 126.90332202866566 37.481611614653815
알림:  Ring Self-intersection at or near point 126.97953778812837 37.473442163708611
알림:  Ring Self-intersection at or near point 127.08108178309978 37.548094432510126
알림:  Ring Self-intersection at or near point 126.80885073339157 37.569294967512121
알림:  Ring Self-intersection at or near point 126.85302688576662 37.548141145304903
알림:  Ring Self-intersection at or near point 127.09549829373221 37.48647614485165
알림:  Ring Self-intersection at or near point 126.91130354767256 37.48422138595744
알림:  Ring Self-intersection at or near point 127.1523930212054 37.496902354782478
알림:  Ring Self-intersection at or near point 126.97869268168893 37.545431694286997
알림:  Ring Self-intersection at or near point 126.99787310819957 37.539748840958026
알림:  Ring Self-intersection at or near point 126.96890660940768 37.522652248534193
알림:  Ring Self-intersection at or near point 126.9921835127741 37.555272141458914
알림:  Ring Self-intersection at or near point 126.9861828415797 37.557340215341604
알림:  Ring Self-intersection at or near point 127.03938380932648 37.579802025539941
알림:  Ring Self-intersection at or near point 127.05937753537805 37.566358680140446
알림:  Ring Self-intersection at or near point 127.06398079004128 37.574737682407253
알림:  Ring Self-intersection at or near point 127.0084350303066 37.63373500814216
알림:  Ring Self-intersection at or near point 127.04393187904731 37.623038764382372
알림:  Ring Self-intersection at or near point 127.02729298111537 37.59452804380976
알림:  Ring Self-intersection at or near point 127.03615459676556 37.679713465976725
알림:  Ring Self-intersection at or near point 126.91127311071781 37.593370438214599
알림:  Ring Self-intersection at or near point 126.93251555529085 37.639421347498875
알림:  Ring Self-intersection at or near point 126.97875347897072 37.612599788739146
알림:  Ring Self-intersection at or near point 126.91040477935708 37.562048156568395
알림:  Ring Self-intersection at or near point 126.93314043969167 37.544004629062734
알림:  Ring Self-intersection at or near point 126.9528109946209 37.549577100796775
알림:  Ring Self-intersection at or near point 126.87928930843577 37.565308842822631
알림:  Ring Self-intersection at or near point 127.02932574448235 37.554175006395162
알림:  Ring Self-intersection at or near point 127.03953215702492 37.541102623566118
알림:  Ring Self-intersection at or near point 127.10037665857335 37.547713060487908
알림:  Ring Self-intersection at or near point 127.15123844619143 37.531515355185256
알림:  Ring Self-intersection at or near point 127.07288067255065 37.518345774495145
알림:  Ring Self-intersection at or near point 127.1523930212054 37.496902354782456
알림:  Ring Self-intersection at or near point 127.13229342209148 37.489669982930472
알림:  Ring Self-intersection at or near point 127.09966674659174 37.461592084902961
알림:  Ring Self-intersection at or near point 127.03550358106125 37.533783280946459
알림:  Ring Self-intersection at or near point 127.05441954444997 37.524340377684545
알림:  Ring Self-intersection at or near point 127.06479205609608 37.477131063525391
알림:  Ring Self-intersection at or near point 126.92894812773181 37.504087992637693
알림:  Ring Self-intersection at or near point 126.96867420893767 37.494049684440213
알림:  Ring Self-intersection at or near point 126.99094498377501 37.493819290919959
알림:  Ring Self-intersection at or near point 127.03761144076542 37.449759169164402
알림:  Ring Self-intersection at or near point 126.9951177291518 37.487374070429155
알림:  Ring Self-intersection at or near point 127.06871890125213 37.465799640264727
알림:  Ring Self-intersection at or near point 127.0522280183424 37.465113907289663
알림:  Ring Self-intersection at or near point 127.04019915525113 37.453663937557678
알림:  Ring Self-intersection at or near point 126.89113474495616 37.532415246931564
알림:  Ring Self-intersection at or near point 126.93211785739305 37.522710886558251
알림:  Ring Self-intersection at or near point 126.92811207880064 37.539179742882133
알림:  Ring Self-intersection at or near point 126.96386075712986 37.471284529852916
알림:  Ring Self-intersection at or near point 126.9195237235145 37.457291445098647
알림:  Ring Self-intersection at or near point 126.90927799927479 37.474679093179461
알림:  Ring Self-intersection at or near point 126.89302344978574 37.498036064318555
알림:  Ring Self-intersection at or near point 126.87769557197063 37.487398097888637
알림:  Ring Self-intersection at or near point 126.84170738011275 37.506499737841438
알림:  Ring Self-intersection at or near point 126.79917007565675 37.572169908281161
알림:  Ring Self-intersection at or near point 126.85379213803168 37.542457457851647
알림:  Ring Self-intersection at or near point 126.81655487803312 37.583486124320942
알림:  Ring Self-intersection at or near point 126.93211785739305 37.522710886558244
알림:  Ring Self-intersection at or near point 126.89113474495619 37.532415246931556
알림:  Ring Self-intersection at or near point 126.92811207880064 37.539179742882133
알림:  Ring Self-intersection at or near point 127.03550358114661 37.53378328135738
알림:  Ring Self-intersection at or near point 127.10998092191693 37.468651800767702
알림:  Ring Self-intersection at or near point 127.05987001994507 37.471993812825779
알림:  Ring Self-intersection at or near point 127.05441954444994 37.52434037768451
알림:  Ring Self-intersection at or near point 127.15123844608569 37.531515355495095
알림:  Ring Self-intersection at or near point 127.15597218805912 37.566499419792137
알림:  Ring Self-intersection at or near point 126.79917007565675 37.572169908281147
알림:  Ring Self-intersection at or near point 126.80885073339157 37.569294967512121
알림:  Ring Self-intersection at or near point 126.85997078907648 37.565429910866854
알림:  Ring Self-intersection at or near point 126.85302688576664 37.548141145304861
알림:  Ring Self-intersection at or near point 126.85379213803168 37.542457457851611
알림:  Ring Self-intersection at or near point 126.91130354767256 37.484221385957433
알림:  Ring Self-intersection at or near point 126.90332202866566 37.481611614653815
알림:  Ring Self-intersection at or near point 126.94789232237504 37.467161179676687
알림:  Ring Self-intersection at or near point 126.91370598422874 37.474012523029621
알림:  Ring Self-intersection at or near point 126.91281409131545 37.467377849839238
알림:  Ring Self-intersection at or near point 126.96386075712986 37.471284529852916
알림:  Ring Self-intersection at or near point 126.968107952388 37.468655505239411
알림:  Ring Self-intersection at or near point 126.84788398682899 37.508380376274559
알림:  Ring Self-intersection at or near point 126.89302344978574 37.498036064318555
알림:  Ring Self-intersection at or near point 126.87769557197063 37.487398097888637
알림:  Ring Self-intersection at or near point 126.9289481278248 37.504087993113075
알림:  Ring Self-intersection at or near point 126.96403918440308 37.501252258346057
알림:  Ring Self-intersection at or near point 126.96867420893764 37.49404968444022
알림:  Ring Self-intersection at or near point 126.96742424563659 37.489000931344343
알림:  Ring Self-intersection at or near point 127.07288067255065 37.518345774495145
알림:  Ring Self-intersection at or near point 127.08481860513785 37.500707662527788
알림:  Ring Self-intersection at or near point 127.1523930212054 37.496902354782478
알림:  Ring Self-intersection at or near point 127.13229342209145 37.489669982930472
알림:  Ring Self-intersection at or near point 126.84170738011275 37.506499737841452
알림:  Ring Self-intersection at or near point 126.99094498377498 37.493819290919959
알림:  Ring Self-intersection at or near point 127.03761144076542 37.449759169164402
알림:  Ring Self-intersection at or near point 126.99511772915177 37.487374070429155
알림:  Ring Self-intersection at or near point 127.03185727861188 37.48208840652979
알림:  Ring Self-intersection at or near point 127.06871890125213 37.465799640264734
알림:  Ring Self-intersection at or near point 127.05058116314616 37.45081965945699
알림:  Ring Self-intersection at or near point 127.05222801834235 37.465113907289634
알림:  Ring Self-intersection at or near point 127.02285700297712 37.457846950376272
알림:  Ring Self-intersection at or near point 127.04019915525113 37.453663937557678
알림:  Ring Self-intersection at or near point 126.90763571232775 37.447123346655282
알림:  Ring Self-intersection at or near point 126.90927799908893 37.474679093915562
알림:  Ring Self-intersection at or near point 127.06479205496775 37.477131062745407
알림:  Ring Self-intersection at or near point 126.99218351290057 37.555272141534466
알림:  Ring Self-intersection at or near point 127.02932574444482 37.554175006080563
알림:  Ring Self-intersection at or near point 127.00108268692355 37.545861542532016
알림:  Ring Self-intersection at or near point 127.03953215702495 37.541102623566118
알림:  Ring Self-intersection at or near point 126.99787310785976 37.539748840866395
알림:  Ring Self-intersection at or near point 127.04504272149165 37.556652929552087
알림:  Ring Self-intersection at or near point 126.97869268168893 37.545431694286982
알림:  Ring Self-intersection at or near point 126.96890660940768 37.522652248534179
알림:  Ring Self-intersection at or near point 127.02932734463511 37.551306994844602
알림:  Ring Self-intersection at or near point 126.9861828416678 37.557340215867448
알림:  Ring Self-intersection at or near point 127.04582815562516 37.610614165646247
알림:  Ring Self-intersection at or near point 126.98951429475829 37.592620693097153
알림:  Ring Self-intersection at or near point 127.01043462949717 37.600296444732997
알림:  Ring Self-intersection at or near point 127.08260969290689 37.546986821636843
알림:  Ring Self-intersection at or near point 127.10564760268147 37.642454116277491
알림:  Ring Self-intersection at or near point 126.99734563462656 37.5936024733411
알림:  Ring Self-intersection at or near point 126.98985180536633 37.592513769506652
알림:  Ring Self-intersection at or near point 127.02729298111537 37.594528043809731
알림:  Ring Self-intersection at or near point 127.06398078896733 37.574737682079203
알림:  Ring Self-intersection at or near point 127.04406792788942 37.592965296462708
알림:  Ring Self-intersection at or near point 127.04393187904731 37.623038764382372
알림:  Ring Self-intersection at or near point 127.00843503054601 37.633735007578544
알림:  Ring Self-intersection at or near point 127.10037665857335 37.547713060487908
알림:  Ring Self-intersection at or near point 127.02301566691423 37.677710139368102
알림:  Ring Self-intersection at or near point 127.02715424842494 37.653433323215118
알림:  Ring Self-intersection at or near point 127.09217293963447 37.617714438139451
알림:  Ring Self-intersection at or near point 127.03615459557972 37.679713465183241
알림:  Ring Self-intersection at or near point 126.91040477791708 37.562048155645044
알림:  Ring Self-intersection at or near point 126.91127311062579 37.593370438004889
알림:  Ring Self-intersection at or near point 126.94327166946034 37.549194256202384
알림:  Ring Self-intersection at or near point 126.93251555386966 37.639421346647836
알림:  Ring Self-intersection at or near point 126.94046951455755 37.635982612686441
알림:  Ring Self-intersection at or near point 126.96606023079035 37.613976878245737
알림:  Ring Self-intersection at or near point 126.89113474495619 37.532415246931556
알림:  Ring Self-intersection at or near point 126.98812111395723 37.466432546318551
알림:  Ring Self-intersection at or near point 127.03761144076542 37.449759169164402
알림:  Ring Self-intersection at or near point 126.85997078907648 37.565429910866854
알림:  Ring Self-intersection at or near point 127.15597218805912 37.566499419792137
알림:  Ring Self-intersection at or near point 127.17591687539412 37.556012159140643
알림:  Ring Self-intersection at or near point 126.85302688576664 37.548141145304861
알림:  Ring Self-intersection at or near point 126.85379213803168 37.542457457851611
알림:  Ring Self-intersection at or near point 126.99218351290057 37.555272141534466
알림:  Ring Self-intersection at or near point 126.92811207880064 37.539179742882119
알림:  Ring Self-intersection at or near point 126.84788398682899 37.508380376274559
알림:  Ring Self-intersection at or near point 126.91130354767256 37.484221385957433
알림:  Ring Self-intersection at or near point 126.93211785739305 37.522710886558244
알림:  Ring Self-intersection at or near point 127.12432386125477 37.519107694451435
알림:  Ring Self-intersection at or near point 126.91415638520355 37.519389310398218
알림:  Ring Self-intersection at or near point 127.07288067255065 37.518345774495145
알림:  Ring Self-intersection at or near point 126.84170738011275 37.506499737841452
알림:  Ring Self-intersection at or near point 126.9289481278248 37.504087993113075
알림:  Ring Self-intersection at or near point 127.02932574444482 37.554175006080563
알림:  Ring Self-intersection at or near point 126.83689535917944 37.49617953002798
알림:  Ring Self-intersection at or near point 126.89302344978574 37.498036064318555
알림:  Ring Self-intersection at or near point 126.96867420893764 37.49404968444022
알림:  Ring Self-intersection at or near point 127.08481860513785 37.500707662527788
알림:  Ring Self-intersection at or near point 126.87724964877093 37.487507996254905
알림:  Ring Self-intersection at or near point 126.90332202866566 37.481611614653815
알림:  Ring Self-intersection at or near point 127.03185727861188 37.48208840652979
알림:  Ring Self-intersection at or near point 126.94789232237504 37.467161179676687
알림:  Ring Self-intersection at or near point 127.05222801834235 37.465113907289634
알림:  Ring Self-intersection at or near point 126.91370598422874 37.474012523029621
알림:  Ring Self-intersection at or near point 127.05987001994507 37.471993812825779
알림:  Ring Self-intersection at or near point 126.91281409131545 37.467377849839238
알림:  Ring Self-intersection at or near point 126.96386075712986 37.471284529852916
알림:  Ring Self-intersection at or near point 127.06871890125213 37.465799640264734
알림:  Ring Self-intersection at or near point 127.04019915525113 37.453663937557678
알림:  Ring Self-intersection at or near point 126.968107952388 37.468655505239404
알림:  Ring Self-intersection at or near point 127.10998092191693 37.468651800767702
알림:  Ring Self-intersection at or near point 127.02285700297712 37.457846950376272
알림:  Ring Self-intersection at or near point 127.05058116314616 37.45081965945699
알림:  Ring Self-intersection at or near point 127.05441954444994 37.52434037768451
알림:  Ring Self-intersection at or near point 127.00108268692355 37.545861542532016
알림:  Ring Self-intersection at or near point 126.91040477791708 37.562048155645044
알림:  Ring Self-intersection at or near point 126.91127311062579 37.593370438004889
알림:  Ring Self-intersection at or near point 126.94327166946034 37.549194256202384
알림:  Ring Self-intersection at or near point 126.94046951455755 37.635982612686441
알림:  Ring Self-intersection at or near point 126.93251555386966 37.63942134664785
알림:  Ring Self-intersection at or near point 126.96890660940768 37.522652248534179
알림:  Ring Self-intersection at or near point 127.0450427201761 37.556652929778522
알림:  Ring Self-intersection at or near point 126.97869268168893 37.545431694286982
알림:  Ring Self-intersection at or near point 126.99787310785976 37.539748840866395
알림:  Ring Self-intersection at or near point 127.02932734463511 37.551306994844602
알림:  Ring Self-intersection at or near point 126.88236890143914 37.584954037002518
알림:  Ring Self-intersection at or near point 126.92670308872187 37.550788482310139
알림:  Ring Self-intersection at or near point 126.98618284166777 37.557340215867448
알림:  Ring Self-intersection at or near point 127.04582815562516 37.610614165646247
알림:  Ring Self-intersection at or near point 127.01329250057172 37.601844198406397
알림:  Ring Self-intersection at or near point 127.105647602852 37.642454116134218
알림:  Ring Self-intersection at or near point 127.0810817825361 37.548094431952002
알림:  Ring Self-intersection at or near point 127.08260969290689 37.546986821636843
알림:  Ring Self-intersection at or near point 127.0688081036012 37.52973859530713
알림:  Ring Self-intersection at or near point 126.99734563462656 37.5936024733411
알림:  Ring Self-intersection at or near point 126.98985180536633 37.592513769506652
알림:  Ring Self-intersection at or near point 127.02729298111537 37.594528043809731
알림:  Ring Self-intersection at or near point 127.06398078896733 37.574737682079203
알림:  Ring Self-intersection at or near point 127.04406792788942 37.592965296462708
알림:  Ring Self-intersection at or near point 127.04393187824998 37.623038763871584
알림:  Ring Self-intersection at or near point 127.00843503054601 37.633735007578544
알림:  Ring Self-intersection at or near point 127.10037665737683 37.54771306042214
알림:  Ring Self-intersection at or near point 127.02301566691423 37.677710139368102
알림:  Ring Self-intersection at or near point 127.02715424842494 37.653433323215118
알림:  Ring Self-intersection at or near point 127.03718200900414 37.679643319442725
알림:  Ring Self-intersection at or near point 127.09217293963447 37.617714438139451
알림:  Ring Self-intersection at or near point 126.96606023079035 37.613976878245737
알림:  Ring Self-intersection at or near point 127.08111226266008 37.548160900674823
알림:  Ring Self-intersection at or near point 126.97872240173459 37.545499362402744
알림:  Ring Self-intersection at or near point 126.99790285485433 37.539816247089874
알림:  Ring Self-intersection at or near point 126.96893583502262 37.522719895680765
알림:  Ring Self-intersection at or near point 126.99221351075033 37.555339708625702
알림:  Ring Self-intersection at or near point 126.9862128366761 37.557407866215392
알림:  Ring Self-intersection at or near point 127.0394145943398 37.579869179869
알림:  Ring Self-intersection at or near point 127.05940820690924 37.566425516079754
알림:  Ring Self-intersection at or near point 127.06401165053862 37.574804514124935
알림:  Ring Self-intersection at or near point 127.00846661259331 37.633802854560585
알림:  Ring Self-intersection at or near point 127.008675549014 37.663830187193007
알림:  Ring Self-intersection at or near point 127.04396350672616 37.623106124931617
알림:  Ring Self-intersection at or near point 127.02732395846964 37.594595430367562
알림:  Ring Self-intersection at or near point 127.01109422791879 37.683319194809805
알림:  Ring Self-intersection at or near point 127.04078142031315 37.677786153118568
알림:  Ring Self-intersection at or near point 127.02917642302396 37.68518909267209
알림:  Ring Self-intersection at or near point 127.03618723511406 37.679781259810625
알림:  Ring Self-intersection at or near point 126.91130326096362 37.593439195348843
알림:  Ring Self-intersection at or near point 126.9325467171484 37.639490129488287
알림:  Ring Self-intersection at or near point 126.9709190492696 37.610362638078996
알림:  Ring Self-intersection at or near point 126.97878445859527 37.612667860424132
알림:  Ring Self-intersection at or near point 126.98513102678673 37.579296531327401
알림:  Ring Self-intersection at or near point 126.91043433652075 37.562116735512951
알림:  Ring Self-intersection at or near point 126.94330121464834 37.549262367391627
알림:  Ring Self-intersection at or near point 126.93316981681983 37.544072829461413
알림:  Ring Self-intersection at or near point 126.95284061269325 37.549645101190769
알림:  Ring Self-intersection at or near point 126.87931871040226 37.565377810775807
알림:  Ring Self-intersection at or near point 127.029355979443 37.554242125878275
알림:  Ring Self-intersection at or near point 127.03602881001054 37.563827190356172
알림:  Ring Self-intersection at or near point 127.03956221781732 37.541169543113298
알림:  Ring Self-intersection at or near point 127.10040726454778 37.547779297169292
알림:  Ring Self-intersection at or near point 127.15126910049091 37.531580890084989
알림:  Ring Self-intersection at or near point 127.0729105381573 37.518412160877183
알림:  Ring Self-intersection at or near point 127.15242303538676 37.496967667385107
알림:  Ring Self-intersection at or near point 127.13232316200413 37.489735490738965
알림:  Ring Self-intersection at or near point 127.095527719427 37.486542070531208
알림:  Ring Self-intersection at or near point 127.09969573573633 37.461657811070303
알림:  Ring Self-intersection at or near point 127.03553347685197 37.533850204257007
알림:  Ring Self-intersection at or near point 127.05444939445835 37.524407019453889
알림:  Ring Self-intersection at or near point 127.06482109449898 37.477197297638234
알림:  Ring Self-intersection at or near point 126.92897672861088 37.504156002445676
알림:  Ring Self-intersection at or near point 126.9687028977315 37.494117162063205
알림:  Ring Self-intersection at or near point 126.99097382271162 37.493886502681072
알림:  Ring Self-intersection at or near point 127.03763977927731 37.449825561149311
알림:  Ring Self-intersection at or near point 126.99514647646288 37.48744119380364
알림:  Ring Self-intersection at or near point 126.98441511669202 37.47026440245817
알림:  Ring Self-intersection at or near point 127.06874775494518 37.465865759434152
알림:  Ring Self-intersection at or near point 127.05225674506224 37.465180218212645
알림:  Ring Self-intersection at or near point 127.04022758465587 37.453730322343901
알림:  Ring Self-intersection at or near point 126.89116361327032 37.532483876264294
알림:  Ring Self-intersection at or near point 126.93214682875852 37.522778970884907
알림:  Ring Self-intersection at or near point 126.92814133065797 37.539247973933449
알림:  Ring Self-intersection at or near point 126.91133165447451 37.484289485602005
알림:  Ring Self-intersection at or near point 126.90335003124198 37.481679793343375
알림:  Ring Self-intersection at or near point 126.91955138403895 37.45735928489237
알림:  Ring Self-intersection at or near point 126.96388898683793 37.47135192747816
알림:  Ring Self-intersection at or near point 126.90930591361679 37.474747159389707
알림:  Ring Self-intersection at or near point 126.89305168794802 37.498104464210151
알림:  Ring Self-intersection at or near point 126.87772350469336 37.487466615685662
알림:  Ring Self-intersection at or near point 126.84173541984015 37.50656879790111
알림:  Ring Self-intersection at or near point 126.80887971988437 37.569364795531669
알림:  Ring Self-intersection at or near point 126.85305578353676 37.548210321682362
알림:  Ring Self-intersection at or near point 126.85382093470585 37.542526590934806
알림:  Ring Self-intersection at or near point 126.81658418406451 37.583555946284513
알림:  Ring Self-intersection at or near point 126.98483404737328 37.469806374445483
알림:  Ring Self-intersection at or near point 127.09611992861635 37.614506239635659
------ UPDATE 285

------ 명칭 변경처리
------ 데이터 확인
select year, landuse_cd,landuse_nm from bnd_landuse group by year, landuse_cd, landuse_nm order by landuse_nm;
------ 확인결과 2000~2015년 : 혼합지(AB) , 2020년 : 주거 및 상업혼합지(AB)
------ '혼합지' --> '주거 및 상업혼합지'로 일괄 변경

------ 변경 적용
update bnd_landuse set landuse_nm = '주거 및 상업혼합지' where year in ('2000', '2005', '2010', '2015') and landuse_cd = 'AB' ;
------ 결과 : UPDATE 7898


--#2022.11.03 김정경
select year, landuse_cd, landuse_nm, count(1)
from bnd_landuse
group by year, landuse_cd, landuse_nm
order by landuse_cd;

-- landuse_nm_org 필드 생성
ALTER TABLE IF EXISTS public.bnd_landuse
    ADD COLUMN landuse_nm_org character varying(20);

-- landuse_cd 와 landuse_nm 값이 상이(54건)하여, 데이터 확인 후, 업데이트 (기존 원본 데이터는 landuse_nm_org 필드 생성하여 보존)
update bnd_landuse set landuse_nm_org = landuse_nm;
-- UPDATE 181551


-- landuse_nm 업데이트
update bnd_landuse set landuse_nm = '주택지'
where year = '2005' and "landuse_cd" = 'A1' and "landuse_nm" = '도시부양시설지';
--2

update bnd_landuse set landuse_nm = '주택지'
where year = '2005' and "landuse_cd" = 'A2' and "landuse_nm" = '공공용도지';
--1

update bnd_landuse set landuse_nm = '상업 및 업무시설지'
where year = '2015' and "landuse_cd" = 'B' and "landuse_nm" = '주택지';
--1

update bnd_landuse set landuse_nm = '공공용도지'
where "landuse_cd" = 'D1' and "landuse_nm" = '녹지 및 오픈스페이스';
--1

update bnd_landuse set landuse_nm = '공공용도지'
where "landuse_cd" = 'D2' and "landuse_nm" = '나지';
--1

update bnd_landuse set landuse_nm = '교통시설지'
where "landuse_cd" = 'E1' and "landuse_nm" = '녹지 및 오픈스페이스';
--1

update bnd_landuse set landuse_nm = '교통시설지'
where "landuse_cd" = 'E2' and "landuse_nm" = '녹지 및 오픈스페이스';
--1

update bnd_landuse set landuse_nm = '도시부양시설지'
where "landuse_cd" = 'F1' and "landuse_nm" = '공공용도지';
--1

update bnd_landuse set landuse_nm = '도시부양시설지'
where "landuse_cd" = 'F7' and "landuse_nm" = '공공용도지';
--1

update bnd_landuse set landuse_nm = '나지'
where "landuse_cd" = 'G1' and "landuse_nm" = '교통시설지';
--28

update bnd_landuse set landuse_nm = '나지'
where "landuse_cd" = 'G1' and "landuse_nm" = '도시부양시설지';
--1

update bnd_landuse set landuse_nm = '나지'
where "landuse_cd" = 'G2' and "landuse_nm" = '교통시설지';
--1

update bnd_landuse set landuse_nm = '나지'
where "landuse_cd" = 'G2' and "landuse_nm" = '녹지 및 오픈스페이스';
--1

update bnd_landuse set landuse_nm = '녹지 및 오픈스페이스'
where "landuse_cd" = 'I1' and "landuse_nm" = '교통시설지';
--1

update bnd_landuse set landuse_nm = '녹지 및 오픈스페이스'
where "landuse_cd" = 'I3' and "landuse_nm" = '주택지';
--1

update bnd_landuse set landuse_nm = '녹지 및 오픈스페이스'
where "landuse_cd" = 'I7' and "landuse_nm" = '공공용도지';
--7

update bnd_landuse set landuse_nm = '녹지 및 오픈스페이스'
where "landuse_cd" = 'I7' and "landuse_nm" = '하천 및 호소';
--1

update bnd_landuse set landuse_nm = '하천 및 호소'
where "landuse_cd" = 'J1' and "landuse_nm" = '녹지 및 오픈스페이스';
--3


-- 확인작업
select count(*) from bnd_landuse
where "landuse_nm" != "landuse_nm_org";


select year, landuse_cd, landuse_nm, count(1)
from bnd_landuse
group by year, landuse_cd, landuse_nm
order by landuse_cd;


select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_landuse
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


-- gu_cd 업데이트
update bnd_landuse as l
	set gu_cd = g.gu_cd
	from bnd_gu as g
	where l.gu_nm = g.gu_nm;
--181551


-- 확인작업
select year, left(id,5), gu_nm, gu_cd, count(1)
from bnd_landuse
group by year, left(id,5), gu_nm, gu_cd
order by left(id,5), year;


-- 확인작업
select landuse_cd, landuse_nm, count(1)-count(landuse_nm)
from bnd_landuse
group by landuse_cd, landuse_nm
order by landuse_cd;


select gu_cd, gu_nm, count(1)-count(gu_nm)
from bnd_landuse
group by gu_cd, gu_nm
order by gu_cd;

