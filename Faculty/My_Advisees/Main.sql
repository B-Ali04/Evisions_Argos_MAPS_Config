select * from (
select DISTINCT :selTerm.CODE AS For_Term,
(case when a.sgradvr_prim_ind = 'Y' then 'Primary' else stvadvr_desc end) as Advisor_Role,
av.PRIMARY_ADVR_NAME as Primary_Advisor,
av.PRIMARY_ADVR_ID as Prim_Advisor_ID,
spriden_last_name as Last_Name,
case when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else s.spriden_first_name end as First_Name,
pprn.gtvpprn_pprn_desc as Pers_Pronouns,
rg.sfbetrm_term_code as Last_Registered,
case when lr.sgbstdn_term_code_eff > rg.sfbetrm_term_code then case when gr.shrdgmr_degs_code='GR' then 'Graduated' when lr.sgbstdn_stst_code in ('WD','IR','IS') then 'Inactive' when lr.sgbstdn_stst_code='IG' then 'Graduated' else 'Unregistered' end else stvtmst_desc end as Last_Status,
spriden_id as BannerID,
suid.goradid_additional_id as SUID,
e_esf.goremal_email_address as ESF_email,
e_su.goremal_email_address as SU_email,
ts.sgbstdn_term_code_admit as Term_Admit,
ts.sgbstdn_camp_code as Student_Campus,
ts.sgbstdn_dept_code as Department,
--rg.sfbetrm_ests_code as Last_Status,
ts.sgbstdn_levl_code as Deg_Level,
ts.sgbstdn_degc_code_1 as Deg_Sought,
pg.smrprle_program_desc as Major,
a_gpa.gpa as GPA,
a_gpa.hrs_earned as Hrs_Earned,
SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :selTerm.CODE) as Class_Standing,
ts.sgbstdn_exp_grad_date as Est_Grad_Date,
gr.shrdgmr_grad_date as Grad_Date,
gr.shrdgmr_degc_code as Deg_Award,
:selUser.Username as For_User
,a.sgradvr_term_code_eff as Term_Assigned
--,s.spriden_pidm

from sgradvr a
inner join spriden s on (s.spriden_pidm=a.sgradvr_pidm and s.spriden_change_ind is null)
inner join spbpers p on (s.spriden_pidm=p.spbpers_pidm)
left outer join stvadvr on (a.sgradvr_advr_code=stvadvr_code)
left outer join gtvpprn pprn on (p.spbpers_pprn_code=pprn.gtvpprn_pprn_code)
left outer join goradid suid on (s.spriden_pidm=suid.goradid_pidm and suid.goradid_adid_code='SUID')
left outer join sfbetrm rg on (s.spriden_pidm=rg.sfbetrm_pidm and rg.sfbetrm_term_code=(select max(b.sfbetrm_term_code) as maxterm from sfbetrm b where rg.sfbetrm_pidm=b.sfbetrm_pidm and b.sfbetrm_term_code <= :selTerm.CODE))
left outer join sgbstdn ts on (s.spriden_pidm=ts.sgbstdn_pidm and ts.sgbstdn_term_code_eff=(select max(b.sgbstdn_term_code_eff) as maxterm from sgbstdn b where s.spriden_pidm=b.sgbstdn_pidm and b.sgbstdn_term_code_eff <= :selTerm.CODE and b.sgbstdn_stst_code='AS'))
left outer join sgbstdn lr on (s.spriden_pidm=lr.sgbstdn_pidm and lr.sgbstdn_term_code_eff=(select max(b.sgbstdn_term_code_eff) as maxterm from sgbstdn b where s.spriden_pidm=b.sgbstdn_pidm and b.sgbstdn_term_code_eff <= :selTerm.CODE ))
--left outer join sfrstcr reg on (s.spriden_pidm=reg.sfrstcr_pidm and reg.sfrstcr_rsts_code = 'RE' and reg.sfrstcr_term_code= (select max(b.sfrstcr_term_code) as maxterm from sfrstcr b where reg.sfrstcr_pidm=b.sfrstcr_pidm and reg.sfrstcr_rsts_code='RE'))
left outer join sfrthst on (sfrthst_pidm=s.spriden_pidm and sfrthst_term_code=rg.sfbetrm_term_code and CONCAT(to_char(sfrthst_activity_date,'YYYYMMDD'),to_char(sfrthst_surrogate_id,'999999999')) = (select max(CONCAT(TO_CHAR(b.sfrthst_activity_date,'YYYYMMDD'),TO_CHAR(b.sfrthst_surrogate_id,'999999999'))) from sfrthst b where b.sfrthst_pidm = s.spriden_pidm and b.sfrthst_term_code=rg.sfbetrm_term_code))
left outer join stvtmst on (sfrthst_tmst_code = stvtmst_code)
left outer join shrdgmr gr on (s.spriden_pidm=gr.shrdgmr_pidm and gr.shrdgmr_term_code_grad is not null and gr.shrdgmr_term_code_grad = rg.sfbetrm_term_code and gr.shrdgmr_degs_code='GR')
LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
left outer join goremal e_esf on (s.spriden_pidm=e_esf.goremal_pidm and e_esf.goremal_emal_code='ESF' and e_esf.goremal_status_ind='A' and instr(e_esf.goremal_email_address,'@esf.edu')>0)
left outer join goremal e_su on (s.spriden_pidm=e_su.goremal_pidm and e_su.goremal_emal_code='SU' and e_su.goremal_status_ind='A' and instr(e_su.goremal_email_address,'@syr.edu')>0)
left outer join agg_student_level_gpa a_gpa on (s.spriden_pidm=a_gpa.pidm and a_gpa.levl_code=ts.sgbstdn_levl_code and a_gpa.gpa_type='I')
LEFT OUTER JOIN AGG_STUDENT_ADVISOR av ON (s.spriden_pidm=av.PIDM and av.TERM_CODE=:selTerm.CODE)


where a.sgradvr_advr_pidm = :selUser.PIDM
and (case when :chkInclSecondary=1 then 1 else case when a.sgradvr_prim_ind is null or a.sgradvr_prim_ind <> 'Y' then 0 else 1 end end)=1
and a.sgradvr_term_code_eff = (select max(b.sgradvr_term_code_eff) as maxterm from sgradvr b where b.sgradvr_pidm =a.sgradvr_pidm and b.sgradvr_advr_pidm=:selUser.PIDM and b.sgradvr_term_code_eff <= :selTerm.CODE)
and a.sgradvr_term_code_eff <= :selTerm.CODE
and a.sgradvr_pidm not in (select distinct b.sgradvr_pidm from sgradvr b where b.sgradvr_pidm = a.sgradvr_pidm AND b.sgradvr_term_code_eff > a.sgradvr_term_code_eff and b.sgradvr_term_code_eff <= :selTerm.CODE and (b.sgradvr_advr_pidm is null or (b.sgradvr_advr_pidm <> :selUser.PIDM and b.sgradvr_prim_ind = 'Y')))
)
where
-- New, Continuing, Unregistered, Inactive, Graduates
   (case when :chkInclSecondary = 1 then 1 when Advisor_Role='Primary' then 1 else 0 end)=1
and (
     (case when :chkInclNew = 1 then case when Term_Admit = For_Term then 1 else 0 end else 0 end) =1
OR   (case when :chkInclContinuing = 1 then case when Deg_Award is not null or Last_Status in ('Graduated','Inactive','Withdrawn') then 0 when Term_Admit = For_Term then 0 when Last_Registered is null then 0 else 1 end else 0 end)=1
--OR   (case when :chkInclUnregistered = 1 then case when Last_Registered is null and Advisor_Since = For_Term then 1 when Last_Registered is null then 0 when Last_Registered=For_Term then 0 else 1 end else 0 end)=1
OR   (case when :chkInclInactive = 1 then case when Last_Status is null or Last_Status in ('Inactive','Withdrawn') then 1 when (Last_Registered is null and Term_Admit <> For_Term and Last_Status <> 'Graduated') then 1 else 0 end else 0 end)=1
OR   (case when :chkInclGraduates = 1 then case when Deg_Award is not null or Last_Status='Graduated' then 1 else 0 end else 0 end)=1
)
ORDER BY Last_Name, First_Name