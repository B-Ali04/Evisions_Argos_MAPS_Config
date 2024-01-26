-- Term Selection
select TRIM(STVTERM_CODE) AS CODE, STVTERM_DESC AS TERM_DESCRIPTION
FROM STVTERM
WHERE STVTERM_CODE >= '202110' AND STVTERM_START_DATE < SYSDATE + 90
--and substr(stvterm_code,5,1) in ('1','2','3','4')
ORDER BY STVTERM_CODE DESC

-- dept selection
select distinct DEPT, DEPT_DESCRIPTION FROM
(select distinct STVDEPT_CODE AS DEPT, STVDEPT_DESC AS DEPT_DESCRIPTION
, hr.hrvyemp_dept_campus_id as hr_dept,
CASE WHEN substr(hrvyemp_last_name,1,9)='DUPLICATE' THEN ''
     WHEN hrvyemp_dept_campus_id = 'SRS' then 'FTC'
     WHEN hrvyemp_dept_campus_id = 'LAA' then 'LA'
     WHEN hrvyemp_dept_campus_id = 'CE' then 'PBE'
     WHEN hrvyemp_dept_campus_id in ('ENS') then 'ES'
     WHEN hrvyemp_dept_campus_id IN ('ENW','MOO') then 'IDP'
     WHEN hrvyemp_dept_campus_id = 'SRM' then 'FRM'
     WHEN hrvyemp_dept_campus_id IN ('EFB','CHE','ESC','ERE') THEN hrvyemp_dept_campus_id
     else CASE WHEN Instr(hrvyemp_DEPT_DESC,'Open Acad')> 0 THEN 'OA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Interdisciplin') > 0 THEN 'IDP'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Studies') > 0 THEN 'ES'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Science') > 0 THEN 'ESC'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Biology') > 0 THEN 'EFB'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Resources') > 0 THEN 'ERE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Chemistry') > 0 THEN 'CHE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Sustain') > 0 THEN 'FRM'
               WHEN Instr(hrvyemp_DEPT_DESC,'Forest Tech') > 0 THEN 'FTC'
               WHEN Instr(hrvyemp_DEPT_DESC,'Landscape A') > 0 THEN 'LA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Open A') > 0 THEN 'OA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Engin') > 0 THEN 'PBE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Research') > 0 THEN 'REP'
--               WHEN f.sibinst_schd_ind = 'Y' then 'IDP'
--               WHEN hrvyemp_pidm=186267 THEN 'IDP'
               ELSE 'XXX' END END AS ACAD_DEPT
from stvdept
left outer join hrvyemp hr on (hr.HRVYEMP_pidm=:selUser.PIDM)
WHERE STVDEPT_CODE NOT IN ('0000','BIOC','CHEM','ENSC','LIB','SU')
and :seluser.PIDM is not null
and hrvyemp_primary_ind = 1 --spvsr_pidm is not null and hrvyemp_spvsr_pidm > 0
AND STVDEPT_DESC <> 'DO NOT USE')
where (case when acad_dept = 'XXX' THEN 1 ELSE case when ACAD_DEPT=DEPT then 1 else 0 end
      end)=1
union
select 'XOT' AS DEPT, 'All Other' AS DEPT_DESCRIPTION from dual
UNION
SELECT 'REP' AS DEPT, 'Research Programs' as DEPT_DESCRIPTION from dual

ORDER BY DEPT

-- instructor selection
select spriden_id as BannerID,
--f.sibinst_schd_ind as Faculty,
spriden_last_name as last_name,
case when spbpers_pref_first_name is null then spriden_first_name else spbpers_pref_first_name end as first_name,
hr.*

from (
select distinct
case when HRVYEMP_TEACH_FAC_IND=1 THEN 'Y' Else '' end as Faculty,
CASE WHEN substr(hrvyemp_last_name,1,9)='DUPLICATE' THEN ''
     WHEN hrvyemp_dept_campus_id = 'SRS' then 'FTC'
     WHEN hrvyemp_dept_campus_id = 'LAA' then 'LA'
     WHEN hrvyemp_dept_campus_id = 'CE' then 'PBE'
     WHEN hrvyemp_dept_campus_id in ('ENS','IGS') then 'ES'
     WHEN hrvyemp_dept_campus_id IN ('ENW','MOO') then 'IDP'
     WHEN hrvyemp_dept_campus_id = 'SRM' then 'FRM'
     WHEN hrvyemp_dept_campus_id IN ('EFB','CHE','ESC','ERE') THEN hrvyemp_dept_campus_id
     else CASE WHEN Instr(hrvyemp_DEPT_DESC,'Open Acad')> 0 THEN 'OA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Interdisciplin') > 0 THEN 'IDP'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Studies') > 0 THEN 'ES'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Science') > 0 THEN 'ESC'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Biology') > 0 THEN 'EFB'
               WHEN Instr(hrvyemp_DEPT_DESC,'Environmental Resources') > 0 THEN 'ERE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Chemistry') > 0 THEN 'CHE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Sustain') > 0 THEN 'FRM'
               WHEN Instr(hrvyemp_DEPT_DESC,'Forest Tech') > 0 THEN 'FTC'
               WHEN Instr(hrvyemp_DEPT_DESC,'Landscape A') > 0 THEN 'LA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Open A') > 0 THEN 'OA'
               WHEN Instr(hrvyemp_DEPT_DESC,'Engin') > 0 THEN 'PBE'
               WHEN Instr(hrvyemp_DEPT_DESC,'Research') > 0 THEN 'REP'
--               WHEN f.sibinst_schd_ind = 'Y' then 'IDP'
--               WHEN hrvyemp_pidm=186267 THEN 'IDP'
               ELSE 'XOT' END END AS ACAD_DEPT,
hrvyemp_dept_campus_id as HR_DEPT,
hrvyemp_dept_desc as HR_DESC,
hrvyemp_pidm as PIDM
FROM HRVYEMP
--left outer join sibinst f on (hrvyemp_pidm=f.sibinst_pidm and f.sibinst_term_code_eff=(select max(b.sibinst_term_code_eff) as maxterm from sibinst b where b.sibinst_pidm=f.sibinst_pidm))
where hrvyemp_primary_ind = 1
AND hrvyemp_status_code='A'
--AND hrvyemp_active_ind = 1
) hr
inner join spriden on (hr.pidm=spriden_pidm and spriden_change_ind is null)
inner join spbpers on (hr.pidm=spbpers_pidm)
left outer join sibinst f on (hr.pidm=f.sibinst_pidm and f.sibinst_term_code_eff=(select max(b.sibinst_term_code_eff) as maxterm from sibinst b where b.sibinst_pidm=f.sibinst_pidm))
where ACAD_DEPT is not null
and ACAD_DEPT = :selDEPT.DEPT
order by spriden_last_name

-- username display
select x.username, spriden_last_name as Last_Name,
case when spbpers_pref_first_name is null then spriden_first_name else spbpers_pref_first_name end as First_Name,
x.pidm
from (
select u.username,
gobtpac_external_user, gobtpac_pidm,
esfl.goradid_pidm as esfl_pidm,
su.goradid_pidm as su_pidm,
case when esfl.goradid_pidm is not null then esfl.goradid_pidm when ad.goremal_pidm is not null then ad.goremal_pidm when e.goremal_pidm is not null then e.goremal_pidm when su.goradid_pidm is not null then su.goradid_pidm when gobtpac_pidm is not null then gobtpac_pidm else 0 end as pidm
from (
select
case
when :optUser = 'Override' and :edtUserO is not null then
case when Instr(:edtUserO,'@') > 0 then LOWER(substr(:edtUserO,1,Instr(:edtUserO,'@')-1))
     else Lower(:edtUserO) end
else
case when Instr(:edtUser,'@') > 0 then Lower(substr(:edtUser,1,Instr(:edtUser,'@')-1))
     else Lower(:edtUser) end
end as UserName
from dual) u
left join gobtpac on (u.username=gobtpac_external_user)
left join goradid esfl on (u.username=esfl.goradid_additional_id and esfl.goradid_adid_code='ESFL')
left join goradid su on (u.username=su.goradid_additional_id and su.goradid_adid_code='SUNI')
LEFT OUTER JOIN GOREMAL ad on (ad.goremal_emal_code='AD' and u.username=substr(ad.goremal_email_address,1,instr(ad.goremal_email_address,'@')-1))
LEFT OUTER JOIN GOREMAL e on (e.goremal_emal_code='ESF' and u.username=substr(e.goremal_email_address,1,instr(e.goremal_email_address,'@')-1))
) x
left join spriden s on (x.pidm=s.spriden_pidm and s.spriden_change_ind is null)
left join spbpers p on (x.pidm=p.spbpers_pidm)