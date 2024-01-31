SELECT DISTINCT * FROM (
     select
       :ForTerm.CODE as ForTerm,
       a.spriden_id as BannerID,
       b1.goradid_additional_id as SUID,
       a.spriden_last_name as LastName,
       CASE when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else a.spriden_first_name end as FirstName,
       ts.sgbstdn_degc_code_1 as DegreeSought,
       pg.smrprle_program_desc as Major,
       ts.sgbstdn_majr_code_minr_1 as Minor,
       ts.sgbstdn_levl_code as LevelCode,
       CASE WHEN gpa1.shrtgpa_pidm is not null then gpa1.shrtgpa_hours_attempted else (select sum(x.sfrstcr_credit_hr) from sfrstcr x where x.sfrstcr_pidm=a.spriden_pidm and x.sfrstcr_rsts_code='RE' and x.sfrstcr_term_code=:ForTerm.CODE) end as cur_hours_attempted,
       gpa1.shrtgpa_hours_passed as cur_hours_earned,
--       agg1.hrs_earned as cum_hrs_earned,
--       (select agg2.hrs_earned from agg_student_level_gpa agg2 where a.spriden_pidm=agg2.PIDM and agg2.GPA_TYPE='T' AND agg2.LEVL_CODE=ts.sgbstdn_levl_code) AS other_hrs_earned,
       (select sum(agg2.shrtgpa_hours_passed) from shrtgpa agg2 where a.spriden_pidm=agg2.shrtgpa_pidm and agg2.shrtgpa_levl_code=ts.sgbstdn_levl_code and agg2.shrtgpa_gpa_type_ind='I' and agg2.shrtgpa_term_code <= :ForTerm.CODE) AS cum_hrs_earned,
       (select sum(agg3.shrtgpa_hours_passed) from shrtgpa agg3 where a.spriden_pidm=agg3.shrtgpa_pidm and agg3.shrtgpa_levl_code=ts.sgbstdn_levl_code and agg3.shrtgpa_gpa_type_ind <>'I' and agg3.shrtgpa_term_code <= :ForTerm.CODE) AS other_hrs_earned,
       SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :ForTerm.CODE) as ClassStanding,
       CASE WHEN SFRTHST_PIDM IS NULL THEN 'Unknown' ELSE STVTMST_DESC END AS EnrollmentStatus,
       ts.sgbstdn_resd_code as Residency,
       ts.sgbstdn_styp_code as StudentType,
       ts.sgbstdn_term_code_admit as Admit_Term,
       p.spbpers_city_birth as BornIn,
--       adh.
--       (case when p.spbpers_sex = 'M' then 'Male' when p.spbpers_sex = 'F' then 'Female' else '' end) as Sex,
--       r.gorrace_desc as Race,
--       aggr.race_desc as Race,
--       e.stvethn_Desc as Ethnicity,
--       (select stvterm_desc from stvterm where stvterm_code = (Select max(sfrstcr_term_code) from sfrstcr where sfrstcr_pidm=a.spriden_pidm and sfrstcr_rsts_code='RE')) as CurrentTermEnrolled,
--       gpa1.shrtgpa_gpa as CurrentTermGPA,
--       (select stvterm_desc from stvterm where stvterm_code = (Select max(r1.sfrstcr_term_code) from sfrstcr r1 where r1.sfrstcr_pidm=a.spriden_pidm and r1.sfrstcr_rsts_code='RE' and r1.sfrstcr_term_code < (Select max(r2.sfrstcr_term_code) as maxt2 from sfrstcr r2 where r2.sfrstcr_pidm=a.spriden_pidm and r2.sfrstcr_rsts_code='RE'))) as PreviousTermEnrolled,
--       gpa2.shrtgpa_gpa as PreviousTermGPA,
--       agg1.HRS_Earned as CreditHoursEarned,
--       ts.sgbstdn_exp_grad_date as AnticipatedDateOfGraduation,
--       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as CareerLevel,
--       SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) as ClassStanding,
--       (select stvdept_desc from stvdept where stvdept_code = ts.sgbstdn_dept_code) as PrimarySchoolOfEnrollment,
--       '' as PrimarySchoolOfEnrollment,
--       sgbstdn_degc_code_1 as DegreeSought,
--       pg.smrprle_program_desc as Major,
--       ts.sgbstdn_majr_code_minr_1, -- as Minor
--       av.PRIMARY_ADVR_NAME as MajorAdvisor,
--      concat(concat(spv.spriden_First_name,' '), spv.spriden_Last_name) as MajorAdvisor,
--       concat(concat(s2p.spriden_First_name,' '), s2p.spriden_Last_name) as OtherAdvisor,
--       CASE WHEN ts.SGBSTDN_CAMP_CODE = 'OL' THEN 'On-Line' WHEN ts.SGBSTDN_CAMP_CODE = 'RS' THEN 'Ranger School' ELSE CASE WHEN ch.SLRRASG_PIDM is null then 'Off-Campus' else 'On-Campus' end END as LocalResidencyStatus,
--       CASE WHEN ch.SLRRASG_PIDM is null then '' else 'Centennial Hall' end as HousingFacility,
--       case when ts.sgbstdn_resd_code='F' THEN 'TRUE' when p.spbpers_citz_code = 'N' THEN 'TRUE' ELSE 'FALSE' END as International,
--       case when ts.sgbstdn_styp_code in ('T','G') THEN 'TRUE' ELSE 'FALSE' END AS Transfer,
--       adh.spraddr_ctry_code_phone as HomePhoneCountryCode,
--       concat(adh.spraddr_phone_area,adh.spraddr_phone_number) as HomePhone,
--       adh.spraddr_phone_ext as HomePhoneExtension,
--       adh.spraddr_street_line1 as HomeStreet1,
--       adh.spraddr_street_line2 as HomeStreet2,
--       adh.spraddr_street_line3 as HomeStreet3,
       adh.spraddr_city as HomeCity,
       adh.spraddr_stat_code as HomeStateProvince,
--       adh.spraddr_zip as HomePostalCode,
       adh.spraddr_natn_code as HomeCountry,
--       p.spbpers_gndr_code as GNDR,
--       p.spbpers_pprn_code as PPRN,
--      (select stvnatn_nation from stvnatn where stvnatn_code=i.gobintl_natn_code_birth) as BIRTH_COUNTRY,
--       v.gorvisa_vtyp_code as VISA_TYPE,
--       v.gorvisa_natn_code as ISSUED_BY,
--       p.spbpers_citz_code as US_CITZ,
--       (select stvnatn_nation from stvnatn where stvnatn_code=i.gobintl_natn_code_legal) as CITIZENSHIP,
--       ts.sgbstdn_styp_code AS Student_Type,
--       ts.sgbstdn_stst_code as Student_Status,
--       CASE WHEN ap2.sarappd_pidm is null THEN 'EN' ELSE ap2.sarappd_apdc_code END as Deccd,
--       CASE WHEN ap2.sarappd_pidm is null THEN SYSDATE ELSE ap2.sarappd_apdc_date END as Dec_Date,
--       ap2.sarappd_apdc_date as Dec_Date,
--       concat(concat(sgbstdn_degc_code_1,': '),pg.smrprle_program_desc) as program,
--       ts.sgbstdn_camp_code as Campus,
--       ph.sprtele_intl_access as c_intl_access,
--       concat(ph.sprtele_phone_area,ph.sprtele_phone_number) as c_phone,
--       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as Cat,
--       ts.sgbstdn_term_code_admit as Admit_Term,
       case when reg.sfrstcr_pidm is null THEN 'No' else 'Yes' end as Enrolled,
       a.spriden_pidm as PIDM,
--       ch.*,
       TO_DATE(to_char(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf
--       ad.*
       from spriden a
       INNER JOIN sgbstdn ts on (ts.sgbstdn_pidm=a.spriden_pidm)
       INNER JOIN spbpers p on (a.spriden_pidm=spbpers_pidm)
       LEFT OUTER JOIN agg_student_level_gpa agg1 ON (a.spriden_pidm=agg1.PIDM and agg1.GPA_TYPE='I' AND agg1.LEVL_CODE=ts.sgbstdn_levl_code)
--       LEFT OUTER JOIN agg_race aggr on (a.spriden_pidm=aggr.PIDM)
       LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
       LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
--       LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
--       LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
--       LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
--       LEFT OUTER JOIN gobintl i on (a.spriden_pidm=i.gobintl_pidm)
--       left OUTER JOIN gorvisa v on (a.spriden_pidm=v.gorvisa_pidm)
--       LEFT OUTER JOIN sprtele ph on (a.spriden_pidm=ph.sprtele_pidm and ph.sprtele_tele_code='PC' and ph.sprtele_status_ind is null and ph.sprtele_seqno = (select max(ph2.sprtele_seqno) from sprtele ph2 where a.spriden_pidm=ph2.sprtele_pidm and ph2.sprtele_tele_code='PC' and ph2.sprtele_status_ind is null))
--       LEFT OUTER JOIN GOREMAL e on (a.spriden_pidm=e.goremal_pidm and e.goremal_emal_code='SU')
--       LEFT OUTER JOIN GOREMAL pe on (a.spriden_pidm=pe.goremal_pidm and pe.goremal_emal_code='PERS' AND pe.goremal_status_ind = 'A' and INSTR(pe.goremal_email_address,'@syr.edu') = 0)
--       LEFT OUTER JOIN AGG_STUDENT_ADVISOR av ON (a.spriden_pidm=av.PIDM and av.TERM_CODE=:MaxTerm.CODE)
--       LEFT OUTER JOIN SGRADVR av on (a.spriden_pidm=av.sgradvr_pidm and av.sgradvr_prim_ind='Y' and av.sgradvr_term_code_eff = (select max(av1.sgradvr_term_code_eff) as maxterm from sgradvr av1 where av1.sgradvr_pidm=a.spriden_pidm))
--       LEFT OUTER JOIN SPRIDEN spv on (av.sgradvr_advr_pidm=spv.spriden_pidm and spv.spriden_change_ind is null)
--       LEFT OUTER JOIN SGRADVR a2v on (a.spriden_pidm=a2v.sgradvr_pidm and a2v.sgradvr_prim_ind<>'Y' and a2v.sgradvr_term_code_eff = (select max(av2.sgradvr_term_code_eff) as maxterm from sgradvr av2 where av2.sgradvr_pidm=a.spriden_pidm))
--       LEFT OUTER JOIN SPRIDEN s2p on (a2v.sgradvr_advr_pidm=s2p.spriden_pidm and s2p.spriden_change_ind is null)
--       LEFT OUTER JOIN STVETHN e on (p.spbpers_ethn_cde = e.stvethn_code)
--       LEFT OUTER JOIN GORPRAC prac on (a.spriden_pidm=prac.gorprac_pidm)
--       LEFT OUTER JOIN GORRACE r on (prac.gorprac_race_cde=r.gorrace_race_cde)
       LEFT OUTER JOIN SFRSTCR reg on (a.spriden_pidm=reg.sfrstcr_pidm and reg.sfrstcr_term_code = :ForTerm.CODE and reg.sfrstcr_crn <> 90009)
       left outer join sfrthst on (sfrthst_pidm=a.spriden_pidm and sfrthst_term_code = :ForTerm.CODE and sfrthst_SURROGATE_ID= (select max(b.sfrthst_SURROGATE_ID) from sfrthst b where b.sfrthst_pidm = a.spriden_pidm and b.sfrthst_term_code = :ForTerm.CODE ))
       left outer join stvtmst on (sfrthst_tmst_code = stvtmst_code)
       left outer join shrtgpa gpa1 on (a.spriden_pidm=gpa1.shrtgpa_pidm and gpa1.shrtgpa_gpa_type_ind = 'I' and gpa1.shrtgpa_levl_code=ts.sgbstdn_levl_code and gpa1.shrtgpa_term_code = :ForTerm.CODE)
       --left outer join shrtgpa gpa2 on (a.spriden_pidm=gpa2.shrtgpa_pidm and gpa2.shrtgpa_gpa_type_ind = 'I' and gpa2.shrtgpa_levl_code=ts.sgbstdn_levl_code and gpa2.shrtgpa_term_code = (select max(gpax.shrtgpa_term_code) as maxterm from shrtgpa gpax where gpax.shrtgpa_pidm=a.spriden_pidm and gpax.shrtgpa_term_code < (Select max(sfrstcr_term_code) from sfrstcr where sfrstcr_pidm=a.spriden_pidm and sfrstcr_rsts_code='RE')))
       --LEFT OUTER JOIN SPRADDR adl on (a.spriden_pidm=adl.spraddr_pidm and adl.spraddr_status_ind is null and concat(adl.spraddr_atyp_code,to_char(adl.spraddr_seqno,'009')) = (select max(CONCAT(ad2.spraddr_atyp_code,TO_CHAR(ad2.spraddr_seqno,'009'))) as maxcode from spraddr ad2 where ad2.spraddr_pidm=adl.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('MA')))
       LEFT OUTER JOIN SPRADDR adh on (a.spriden_pidm=adh.spraddr_pidm and adh.spraddr_status_ind is null and concat(adh.spraddr_atyp_code,to_char(adh.spraddr_seqno,'009')) = (select max(CONCAT(ad2.spraddr_atyp_code,TO_CHAR(ad2.spraddr_seqno,'009'))) as maxcode from spraddr ad2 where ad2.spraddr_pidm=adh.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('PR')))
       --left outer join sarappd ap2 on (a.spriden_pidm=ap2.sarappd_pidm and ts.sgbstdn_term_code_eff=ap2.sarappd_term_code_entry and ap2.sarappd_seq_no= (select max(ap3.sarappd_seq_no) as maxseq from sarappd ap3 where a.spriden_pidm=ap3.sarappd_pidm and ts.sgbstdn_term_code_eff=ap3.sarappd_term_code_entry and ap3.sarappd_term_code_entry >= :MinTerm.CODE and ap3.sarappd_term_code_entry <= :MaxTerm.CODE))
       --left outer join slrrasg ch on (a.spriden_pidm=ch.slrrasg_pidm and slrrasg_term_code=:MaxTerm.CODE and ch.slrrasg_ascd_code = 'AC')
        where
          a.spriden_change_ind is null
          and b1.goradid_pidm is not null
          and ts.sgbstdn_stst_code in ('AS','IR')
--          and ts.sgbstdn_camp_code <> CASE WHEN :chkOL = 1 then 'OL' else '??' end
--          and (ts.sgbstdn_resd_code = 'F' OR p.spbpers_citz_code = 'N')
          and ts.sgbstdn_styp_code IN ('T','F','C','U','N','D','G','R')                                 --:selSTYP.STYP_CODE
          and ts.sgbstdn_coll_code_1 <> 'SU'
          and ts.sgbstdn_majr_code_1 <> 'EHS'
--          and not ESF in HS
          and ts.sgbstdn_term_code_eff =
          (select MAX(g.sgbstdn_term_code_eff) AS MAXTERM from sgbstdn g where g.sgbstdn_pidm=ts.sgbstdn_pidm and g.sgbstdn_term_code_eff <= :ForTerm.CODE)
order by a.spriden_last_name, a.spriden_first_name, a.spriden_id
) WHERE
Enrolled = 'Yes'
--DECCD IN ('EN')
--AND
--(
--(:chkI_Grad_R = 1 and CareerLevel = 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
--OR
--(:chkI_Grad_U = 1 and CareerLevel = 'Grad' and Deccd <> 'EN' AND Registered = 'No')
--OR
--(:chkI_UGrad_R = 1 and CareerLevel <> 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
--OR
--(:chkI_UGrad_U = 1 and CareerLevel <> 'Grad' and Deccd <> 'EN' AND Registered = 'No')
--OR
--(:chkC_Grad_R = 1 and CareerLevel = 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
--OR
--(:chkC_Grad_U = 1 and CareerLevel = 'Grad' and Deccd = 'EN' AND Registered = 'No')
--OR
--(:chkC_UGrad_R = 1 and CareerLevel <> 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
--OR
--(:chkC_UGrad_U = 1 and CareerLevel <> 'Grad' and Deccd = 'EN' AND Registered = 'No')
--)
ORDER BY LastName, FirstName, BannerID
