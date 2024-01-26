SELECT DISTINCT * FROM (
     select DISTINCT a.spriden_id as BannerID, a.spriden_last_name as Last_Name, a.spriden_first_name as First_Name,
       CASE when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else ' ' end as Pref_Name,
       d.gobtpac_external_user as ESFiD,
       b1.goradid_additional_id as SUID,
       b2.goradid_additional_id as SU_NETID,
       case when b2.goradid_pidm is not null then concat(b2.goradid_additional_id,'@syr.edu') else e.goremal_email_address end as SU_EMAIL,
       pe.goremal_email_address as PERS_EMAIL,
       SUBSTR(TO_CHAR(p.spbpers_birth_date,'MM/DD/YYYY'),7,4) as BIRTH_DATE,
       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as Cat,
       ts.sgbstdn_styp_code AS Student_Type,
       ts.sgbstdn_stst_code as Student_Status,
       ts.sgbstdn_term_code_admit as Admit_Term,
       CASE WHEN ap2.sarappd_pidm is null THEN 'EN' ELSE ap2.sarappd_apdc_code END as Deccd,
--       CASE WHEN ap2.sarappd_pidm is null THEN SYSDATE ELSE ap2.sarappd_apdc_date END as Dec_Date,
       ap2.sarappd_apdc_date as Dec_Date,
       concat(concat(sgbstdn_degc_code_1,': '),pg.smrprle_program_desc) as program,
       ts.sgbstdn_camp_code as Campus,
       ph.sprtele_intl_access as c_intl_access,
       concat(ph.sprtele_phone_area,ph.sprtele_phone_number) as c_phone,
       case when reg.sfrstcr_pidm is null THEN 'No' else 'Yes' end as Registered,
       av.PRIMARY_ADVR_NAME as Advisor,
       TO_DATE(to_char(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf,
       ad.*
       from spriden a
       INNER JOIN sgbstdn ts on (ts.sgbstdn_pidm=a.spriden_pidm)
       INNER JOIN spbpers p on (a.spriden_pidm=spbpers_pidm)
       LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
       LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
       LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
       LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
       LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
       LEFT OUTER JOIN sprtele ph on (a.spriden_pidm=ph.sprtele_pidm and ph.sprtele_tele_code='PC' and ph.sprtele_status_ind is null)
       LEFT OUTER JOIN GOREMAL e on (a.spriden_pidm=e.goremal_pidm and e.goremal_emal_code='SU')
       LEFT OUTER JOIN GOREMAL pe on (a.spriden_pidm=pe.goremal_pidm and pe.goremal_emal_code='PERS' AND pe.goremal_status_ind = 'A' and INSTR(pe.goremal_email_address,'@syr.edu') = 0)
       LEFT OUTER JOIN SFRSTCR reg on (a.spriden_pidm=reg.sfrstcr_pidm and reg.sfrstcr_term_code >= :MinTerm.CODE and reg.sfrstcr_term_code <= :MaxTerm.CODE and reg.sfrstcr_rsts_code = 'RE')
       LEFT OUTER JOIN SPRADDR ad on (a.spriden_pidm=ad.spraddr_pidm and ad.spraddr_status_ind is null and concat(ad.spraddr_atyp_code,to_char(ad.spraddr_seqno,'009')) = (select max(CONCAT(ad2.spraddr_atyp_code,TO_CHAR(ad2.spraddr_seqno,'009'))) as maxcode from spraddr ad2 where ad2.spraddr_pidm=ad.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('PR','PA','MA')))
       LEFT OUTER JOIN AGG_STUDENT_ADVISOR av ON (a.spriden_pidm=av.PIDM and av.TERM_CODE=:MaxTerm.CODE)

--       LEFT OUTER JOIN SPRADDR ad on (a.spriden_pidm=ad.spraddr_pidm and ad.spraddr_status_ind is null and ad.spraddr_atyp_code = (select max(ad2.spraddr_atyp_code) as maxcode from spraddr ad2 where ad2.spraddr_pidm=ad.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('PR','PA','MA')))
       --       left outer join spriden s2 on (a.spriden_pidm=s2.spriden_pidm and s2.spriden_ntyp_code='LGCY')
       left outer join sarappd ap2 on (a.spriden_pidm=ap2.sarappd_pidm and ts.sgbstdn_term_code_eff=ap2.sarappd_term_code_entry and ap2.sarappd_seq_no= (select max(ap3.sarappd_seq_no) as maxseq from sarappd ap3 where a.spriden_pidm=ap3.sarappd_pidm and ts.sgbstdn_term_code_eff=ap3.sarappd_term_code_entry and ap3.sarappd_term_code_entry >= :MinTerm.CODE and ap3.sarappd_term_code_entry <= :MaxTerm.CODE))
        where
          a.spriden_change_ind is null
          and ts.sgbstdn_stst_code = 'AS'
          and ts.sgbstdn_camp_code <> CASE WHEN :chkOL = 1 then 'OL' else '??' end
          and ts.sgbstdn_styp_code IN ('T','F','C','U','N','D','G','R','X')                                 --:selSTYP.STYP_CODE
          and ts.sgbstdn_coll_code_1 <> 'SU'
--          and not ESF in HS
          and ts.sgbstdn_term_code_eff =
          (select MAX(g.sgbstdn_term_code_eff) AS MAXTERM from sgbstdn g where g.sgbstdn_pidm=ts.sgbstdn_pidm and g.sgbstdn_term_code_eff <= :MaxTerm.CODE)
order by a.spriden_last_name, a.spriden_first_name, a.spriden_id
) WHERE
DECCD IN ('AP','CF','CP','EN')
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