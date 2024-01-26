select * from (
select DISTINCT spriden_id as BannerID,
spriden_last_name as last_name,
case when spbpers_pref_first_name is null then spriden_first_name else spbpers_pref_first_name end as first_name,
--case when hrvyemp_teach_fac_ind=1 then 'Y' else '' end as faculty,
x.ssbsect_term_code as Term_Code,
x.ssbsect_ptrm_code as PTRM,
x.ssbsect_crn as CRN,
x.ssbsect_subj_code as SUBJ,
x.ssbsect_crse_numb as NUMB,
x.ssbsect_seq_numb as SECT,
case when x.ssbsect_crse_title is null then c.scbcrse_title else x.ssbsect_crse_title end as title,
x.ssbsect_enrl as enrolled,
--x.ssbsect_seats_avail as seats_avail,
c.scbcrse_credit_hr_low as min_credits,
case when c.scbcrse_credit_hr_high is null then c.scbcrse_credit_hr_low else c.scbcrse_credit_hr_high end as max_credits,
insm.gtvinsm_desc as INS_MODE,
x.ssbsect_camp_code as campus,
CASE when :chkLOC = 1 THEN m.ssrmeet_bldg_code else '' end as BLDG,
CASE when :chkLOC = 1 THEN m.ssrmeet_room_code else '' end as ROOM,
CASE when :chkLOC = 1 THEN concat(concat(concat(concat(concat(m.ssrmeet_mon_day,m.ssrmeet_tue_day),m.ssrmeet_wed_day),m.ssrmeet_thu_day),m.ssrmeet_fri_day),m.ssrmeet_sat_day) else '' end as DAYS,
CASE when :chkLOC = 1 THEN m.ssrmeet_begin_time else '' end as BEGINS,
CASE when :chkLOC = 1 THEN m.ssrmeet_end_time else '' end as ENDS,
CASE WHEN substr(hrvyemp_last_name,1,9)='DUPLICATE' THEN ''
     WHEN hrvyemp_dept_campus_id = 'SRS' then 'FTC'
     WHEN hrvyemp_dept_campus_id = 'LAA' then 'LA'
     WHEN hrvyemp_dept_campus_id = 'CE' then 'PBE'
     WHEN hrvyemp_dept_campus_id IN ('ENS','IGS') then 'ES'
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
               WHEN c.scbcrse_dept_code is not null then c.scbcrse_dept_code
               ELSE 'XOT' END END AS ACAD_DEPT,
hrvyemp_dept_campus_id as HR_DEPT,
c.scbcrse_dept_code as SUBJ_DEPT
--hrvyemp_pidm as PIDM
from
SSBSECT x
left outer join SCBCRSE c ON (x.ssbsect_subj_code=c.scbcrse_subj_code and x.ssbsect_crse_numb=c.scbcrse_crse_numb and c.scbcrse_eff_term = (select max(b.scbcrse_eff_term) as maxterm from scbcrse b where b.scbcrse_subj_code=c.scbcrse_subj_code and b.scbcrse_crse_numb=c.scbcrse_crse_numb))
left outer join gtvinsm insm ON (x.ssbsect_insm_code=insm.gtvinsm_code)
LEFT OUTER JOIN SSRMEET m ON (x.ssbsect_term_code=m.ssrmeet_term_code and x.ssbsect_crn=m.ssrmeet_crn)
left outer join sirasgn z on (z.sirasgn_term_code=x.ssbsect_term_code and z.sirasgn_crn=x.ssbsect_crn)
left outer join hrvyemp on (z.sirasgn_pidm=hrvyemp_pidm and hrvyemp_primary_ind = 1)
LEFT OUTER join spriden on (hrvyemp_pidm=spriden_pidm and spriden_change_ind is null)
LEFT OUTER join spbpers on (spriden_pidm=spbpers_pidm)
--left outer join sibinst f on (hr.pidm=f.sibinst_pidm and f.sibinst_term_code_eff=(select max(b.sibinst_term_code_eff) as maxterm from sibinst b where b.sibinst_pidm=f.sibinst_pidm))

where c.scbcrse_coll_code <> 'SU'
AND x.ssbsect_term_code = :selTerm.CODE
--and hrvyemp_primary_ind=1 and hrvyemp_status_code='A'
and (CASE WHEN :optCoursework='All Assigned Instructors' then 1
          else CASE when hrvyemp_pidm=:selInstructors.PIDM then 1 else 0 end
          end)=1
and (CASE WHEN :chkOL1 = 1 then
          CASE WHEN x.ssbsect_insm_code <> 'NT' THEN 1 ELSE 0 END
     ELSE 1 END)=1
and (CASE WHEN :chkOL2 = 1 then
          CASE WHEN x.ssbsect_camp_code = 'OL' THEN 1 ELSE 0 END
     ELSE 1 END)=1
and (CASE WHEN :chkENRL = 1 then
          CASE WHEN x.ssbsect_enrl > 0 THEN 1 ELSE 0 END
     ELSE 1 END)=1
) sect
where (ACAD_DEPT is not null and ACAD_DEPT = :selDEPT.DEPT)
or (CASE WHEN :chkSUBJ = 1 THEN CASE WHEN SUBJ_DEPT is not null and SUBJ_DEPT = :selDEPT.DEPT THEN 1 ELSE 0 END ELSE 0 END)=1
ORDER BY LAST_NAME, FIRST_NAME, SUBJ, NUMB, SECT