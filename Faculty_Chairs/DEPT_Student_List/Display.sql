SELECT DISTINCT * FROM (
     select DISTINCT a.spriden_id as BannerID, a.spriden_last_name as Last_Name,
--a.spriden_first_name as First_Name,
       CASE when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else a.spriden_first_name end as First_Name,
       pprn.gtvpprn_pprn_desc as PersPronouns,
       d.gobtpac_external_user as ESFiD,
       esf.goremal_email_address as ESF_EMAIL,
--       xsuni.goradid_pidm as xsuni_pidm,
--       case when xsuni.goradid_pidm is not null then (select x.spriden_id from spriden x where x.spriden_pidm=xsuni.goradid_pidm and x.spriden_change_ind is null) else null end as Conflict,
--       case when xsuni.goradid_pidm is null then null else (select distinct hrvyemp_pidm from hrvyemp where hrvyemp_pidm = xsuni.goradid_pidm) end as hrvyemp_pidm,
       b1.goradid_additional_id as SUID,
       b2.goradid_additional_id as SU_NETID,
       case when b2.goradid_pidm is not null then concat(trim(b2.goradid_additional_id),'@syr.edu') else e.goremal_email_address end as SU_EMAIL,
       pe.goremal_email_address as PERS_EMAIL,
       SUBSTR(TO_CHAR(p.spbpers_birth_date,'MM/DD/YYYY'),7,4) as BIRTH_DATE,
       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as Cat,
       ts.sgbstdn_styp_code AS Student_Type,
       ts.sgbstdn_stst_code as Student_Status,
       ts.sgbstdn_term_code_admit as Admit_Term,
       CASE WHEN ap2.sarappd_pidm is null THEN 'EN' ELSE ap2.sarappd_apdc_code END as Deccd,
--       CASE WHEN ap2.sarappd_pidm is null THEN SYSDATE ELSE ap2.sarappd_apdc_date END as Dec_Date,
       ap2.sarappd_apdc_date as Dec_Date,
       ts.sgbstdn_degc_code_1 as Degree,
       concat(concat(ts.sgbstdn_majr_code_1,': '),pg.smrprle_program_desc) as program,
       ts.sgbstdn_dept_code as Dept,
       ts.sgbstdn_camp_code as Campus,
--       ph.sprtele_intl_access as c_intl_access,
--       concat(ph.sprtele_phone_area,ph.sprtele_phone_number) as c_phone,
       SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :selTerm.CODE) as Class_Standing,
       case when reg.sfrstcr_pidm is null THEN 'No' else 'Yes' end as Registered,
       TO_DATE(to_char(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf
--       ad.*
       from spriden a
       INNER JOIN sgbstdn ts on (ts.sgbstdn_pidm=a.spriden_pidm)
       INNER JOIN spbpers p on (a.spriden_pidm=spbpers_pidm)
       LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
       LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
       LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
       LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
       LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
       LEFT OUTER JOIN goradid xsuni on (d.gobtpac_external_user=xsuni.goradid_additional_id and xsuni.goradid_adid_code='SUNI' and xsuni.goradid_pidm <> a.spriden_pidm)
       left outer join gtvpprn pprn on (p.spbpers_pprn_code=pprn.gtvpprn_pprn_code)

--       LEFT OUTER JOIN sprtele ph on (a.spriden_pidm=ph.sprtele_pidm and ph.sprtele_tele_code='PC' and ph.sprtele_status_ind is null)
       LEFT OUTER JOIN GOREMAL e on (a.spriden_pidm=e.goremal_pidm and e.goremal_emal_code='SU' and e.goremal_status_ind='A' and INSTR(e.goremal_email_address,'@syr.edu') > 0)
       LEFT OUTER JOIN GOREMAL pe on (a.spriden_pidm=pe.goremal_pidm and pe.goremal_emal_code='PERS' AND pe.goremal_status_ind = 'A' and INSTR(pe.goremal_email_address,'@syr.edu') = 0)
       LEFT OUTER JOIN GOREMAL esf on (a.spriden_pidm=esf.goremal_pidm and esf.goremal_emal_code='ESF' AND esf.goremal_status_ind = 'A' and INSTR(esf.goremal_email_address,'@esf.edu') > 0)
       LEFT OUTER JOIN SFRSTCR reg on (a.spriden_pidm=reg.sfrstcr_pidm and reg.sfrstcr_term_code >= :MinTerm.CODE and reg.sfrstcr_term_code <= :MaxTerm.CODE and reg.sfrstcr_rsts_code = 'RE' and reg.sfrstcr_crn <> 90012)
--       LEFT OUTER JOIN SPRADDR ad on (a.spriden_pidm=ad.spraddr_pidm and ad.spraddr_status_ind is null and ad.spraddr_atyp_code = (select max(ad2.spraddr_atyp_code) as maxcode from spraddr ad2 where ad2.spraddr_pidm=ad.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('PR','PA','MA')))
       --       left outer join spriden s2 on (a.spriden_pidm=s2.spriden_pidm and s2.spriden_ntyp_code='LGCY')
       left outer join sarappd ap2 on (a.spriden_pidm=ap2.sarappd_pidm and ts.sgbstdn_term_code_eff=ap2.sarappd_term_code_entry and ap2.sarappd_seq_no= (select max(ap3.sarappd_seq_no) as maxseq from sarappd ap3 where a.spriden_pidm=ap3.sarappd_pidm and ts.sgbstdn_term_code_eff=ap3.sarappd_term_code_entry and ap3.sarappd_term_code_entry >= :MinTerm.CODE and ap3.sarappd_term_code_entry <= :MaxTerm.CODE))
        where
          a.spriden_change_ind is null
          and ts.sgbstdn_stst_code = 'AS'
          and ts.sgbstdn_camp_code <> CASE WHEN :chkOL = 1 then 'OL' else '??' end
          and ts.sgbstdn_styp_code IN ('T','F','C','U','N','D','G','R','X')                                 --:selSTYP.STYP_CODE
          and ts.sgbstdn_coll_code_1 <> 'SU'
          and ts.sgbstdn_majr_code_1 <> 'EHS'
          and ts.sgbstdn_term_code_eff =
          (select MAX(g.sgbstdn_term_code_eff) AS MAXTERM from sgbstdn g where g.sgbstdn_pidm=ts.sgbstdn_pidm and g.sgbstdn_term_code_eff <= :MaxTerm.CODE)
order by a.spriden_last_name, a.spriden_first_name, a.spriden_id
) WHERE
:chkView=1
AND
DECCD = :selDECCD.APDC        --IN ('AC','AP','CF','CP','EN')
AND
(CASE WHEN DEPT=:selDept.DEPT THEN 1 ELSE 0 END)=1
AND
(
(:chkI_Grad_R = 1 and Cat = 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
OR
(:chkI_Grad_U = 1 and Cat = 'Grad' and Deccd <> 'EN' AND Registered = 'No')
OR
(:chkI_UGrad_R = 1 and Cat <> 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
OR
(:chkI_UGrad_U = 1 and Cat <> 'Grad' and Deccd <> 'EN' AND Registered = 'No')
OR
(:chkC_Grad_R = 1 and Cat = 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
OR
(:chkC_Grad_U = 1 and Cat = 'Grad' and Deccd = 'EN' AND Registered = 'No')
OR
(:chkC_UGrad_R = 1 and Cat <> 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
OR
(:chkC_UGrad_U = 1 and Cat <> 'Grad' and Deccd = 'EN' AND Registered = 'No')
)