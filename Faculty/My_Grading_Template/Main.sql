select SFRSTCR_TERM_CODE AS Term_Code, sfrstcr_crn AS CRN,
concat(concat(spriden_last_name,', '),case when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else spriden_first_name end) as Full_Name,
spriden_id as Student_ID,
'No' as Rolled,
'No' as Confidential,
ssbsect_subj_code as Course,
sfrstcr_grde_code as Final_Grade,
sfrstcr_last_attend as Last_Attended_Date,
sfrstcr_grde_code_incmp_final as Incomplete_Final_Grade,
sfrstcr_incomplete_ext_date as Extension_Date,
'' as ExtensionDateConstraints,
-- Course and Reg Info
concat(concat(concat(ssbsect_subj_code, ssbsect_crse_numb),'-'),ssbsect_seq_numb) as Course_Section,
case when ssbsect_crse_title is null then c.scbcrse_title else ssbsect_crse_title end as Course_Title,
ssbsect_camp_code as Course_Campus,
ssbsect_insm_code as Instruction,
sfrstcr_rsts_code as Reg_Status,
sfrstcr_rsts_date as Reg_AsOf,
sfrstcr_grde_code_mid as MidTerm_Grade,
sfrstcr_grde_date as Grade_Date,
-- Student Info
spriden_id as Banner_ID,
suid.goradid_additional_id as SUID,
spriden_last_name as Last_Name,
case when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else spriden_first_name end as First_Name,
case when p.spbpers_gndr_code is null then case when p.spbpers_sex = 'M' then 'MALE' when P.SPBPERS_SEX='F' THEN 'FEM' WHEN p.spbpers_sex ='N' THEN 'NA' end else p.spbpers_gndr_code end as Gender,
gtvpprn_pprn_desc as Pers_Pronouns,
case when rg.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when rg.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as CareerLevel,
SGKCLAS.F_CLASS_CODE(rg.sgbstdn_pidm, rg.sgbstdn_levl_code, :selTerm.CODE) as ClassStanding,
rg.sgbstdn_degc_code_1 as DegreeSought,
pg.smrprle_program_desc as Major,
av.PRIMARY_ADVR_NAME as MajorAdvisor,
rg.sgbstdn_camp_code as Student_Campus,
tzkutil.fz_get_email(sfrstcr_pidm,'ESF') ESF_email,
tzkutil.fz_get_email(sfrstcr_pidm,'SU') SU_email,
--e_esf.goremal_email_address as ESF_email,
--e_su.goremal_email_address as SU_email,
:selUser.Username as For_User

from sfrstcr
inner join spriden on (sfrstcr_pidm=spriden_pidm and spriden_change_ind is null)
left outer join goradid suid on (sfrstcr_pidm=suid.goradid_pidm and suid.goradid_adid_code='SUID')
--left outer join goremal e_esf on (sfrstcr_pidm=e_esf.goremal_pidm and e_esf.goremal_emal_code='ESF' and e_esf.goremal_status_ind='A')
--left outer join goremal e_su on (sfrstcr_pidm=e_su.goremal_pidm and e_su.goremal_emal_code='SU' and e_su.goremal_status_ind='A')
left outer join spbpers p on (sfrstcr_pidm=spbpers_pidm)
left outer join ssbsect on (sfrstcr_term_code=ssbsect_term_code and sfrstcr_crn=ssbsect_crn)
left outer join scbcrse c on (ssbsect_subj_code=c.scbcrse_subj_code and ssbsect_crse_numb=c.scbcrse_crse_numb and c.scbcrse_eff_term = (select max(cb.scbcrse_eff_term) from scbcrse cb where cb.scbcrse_subj_code=c.scbcrse_subj_code and cb.scbcrse_crse_numb=c.scbcrse_crse_numb and cb.scbcrse_eff_term <= :selTerm.CODE))
left outer join gtvpprn pprn on (p.spbpers_pprn_code=gtvpprn_pprn_code)
left outer join sgbstdn rg on (sfrstcr_pidm=rg.sgbstdn_pidm and rg.sgbstdn_term_code_eff = (select max(b.sgbstdn_term_code_eff) as maxterm from sgbstdn b where b.sgbstdn_pidm= rg.sgbstdn_pidm and b.sgbstdn_term_code_eff <= :selTerm.CODE))
LEFT OUTER JOIN smrprle pg on (rg.sgbstdn_program_1=pg.smrprle_program)
LEFT OUTER JOIN AGG_STUDENT_ADVISOR av ON (spriden_pidm=av.PIDM and av.TERM_CODE=:selTerm.CODE)

where sfrstcr_term_code=:selTerm.CODE and
sfrstcr_crn in
   (select distinct sirasgn_crn from sirasgn where sirasgn_term_code=:selTerm.CODE and sirasgn_pidm=:selUser.PIDM and
   (case when :optClass.Main ='All Class Assignments' then 1
         when sirasgn_crn = :selClasses.CRN then 1 else 0 end )=1)
order by sfrstcr_crn, Last_Name, First_Name