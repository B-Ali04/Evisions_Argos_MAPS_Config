-- term selection
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

-- instructor select
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