SELECT DISTINCT * FROM (
     select
       b1.goradid_additional_id as Patient_Control_ID,                -- SUID
       a.spriden_id as Other_ID,

       a.spriden_last_name as LastName,
       a.spriden_first_name as FirstName,
       substr(a.spriden_mi,1,1) as Middle_Initial,
       case when p.spbpers_sex = 'M' then 'M' when p.spbpers_sex = 'F' then 'F' else 'N' end as Sex,
       adl.spraddr_street_line1 as Addr1,
       case when adl.spraddr_street_line3 is null then adl.spraddr_street_line2 else CONCAT(CONCAT(adl.spraddr_street_line2,'; '),adl.spraddr_street_line3) end as Addr2,
       adl.spraddr_city as City,
       adl.spraddr_stat_code as State,
       replace(adl.spraddr_zip,'-','') as Zip,
       case when ph.sprtele_intl_access is null then REPLACE(REPLACE(replace(concat(concat(ph.sprtele_phone_area,ph.sprtele_phone_number),ph.sprtele_phone_ext),'-',''),'(',''),')','') else replace(replace(replace(replace(ph.sprtele_intl_access,'+',''),')',''),'(',''),'-','') end as Homephone,
       case when ph.sprtele_intl_access is null then REPLACE(REPLACE(replace(concat(concat(ph.sprtele_phone_area,ph.sprtele_phone_number),ph.sprtele_phone_ext),'-',''),'(',''),')','') else replace(replace(replace(replace(ph.sprtele_intl_access,'+',''),')',''),'(',''),'-','') end as Workphone,
       case when ph.sprtele_intl_access is null then REPLACE(REPLACE(replace(concat(concat(ph.sprtele_phone_area,ph.sprtele_phone_number),ph.sprtele_phone_ext),'-',''),'(',''),')','') else replace(replace(replace(replace(ph.sprtele_intl_access,'+',''),')',''),'(',''),'-','') end as Cellphone,
       case when p.spbpers_birth_date is null then '01/01/1900' else SUBSTR(TO_CHAR(p.spbpers_birth_date,'MM/DD/YYYY'),1,10) end as DateOfBirth,

       case when p.spbpers_mrtl_code='M' THEN 1 when p.spbpers_mrtl_code='S' then 2 ELSE 7 END as Marital,
       7 as Employment,
       '' as Employer_Code,
       case when b3.goradid_pidm is NOT null then concat(trim(b3.goradid_additional_id),'@esf.edu') when esf.goremal_pidm is not null then esf.goremal_email_address else concat(d.gobtpac_external_user,'@esf.edu') end as Email_Address,
       2 as Eligibility,
       0 as Inactive,

       case when sfrthst_tmst_code is not null and sfrthst_tmst_code='FT' THEN 3 when sfrthst_tmst_code is not null and sfrthst_tmst_code='WD' then 1 else 2 end as Student_Status,
       CASE WHEN ts.sgbstdn_camp_code = 'RS' then 'Ranger School' when ts.sgbstdn_camp_code = 'OL' then 'Open Academy' else 'Main Campus' end as School,
       p.spbpers_pref_first_name as Preferred_Name,

       case when ch.SLRRASG_PIDM is null then '' else 'Centennial Hall' end as Campus_Addr,
       case when ch.SLRRASG_PIDM is null then '' else '142 Oakland St; Syracuse, NY  13210' end as Campus_Addr2,
       adh.spraddr_street_line1 as PermStreet1,
       case when adh.spraddr_street_line3 is null then adh.spraddr_street_line2 else concat(concat(adh.spraddr_street_line2,'; '),adh.spraddr_street_line3) end as PermStreet2,
       adh.spraddr_city as PermCity,
       adh.spraddr_stat_code as PermState,
       replace(adh.spraddr_zip,'-','') as PermZip,
       adh.spraddr_natn_code as PermCountry,
       case when adh.spraddr_phone_number is not null then concat(adh.spraddr_phone_area,adh.spraddr_phone_number) else '' end as PermPhone,
       case when ts.sgbstdn_resd_code='F' THEN 1 else 0 END as Foreign_Student,
       case when ts.sgbstdn_resd_code='F' THEN v.gorvisa_vtyp_code ELSE '' END as Visa_Type,
       pg.smrprle_program_desc as Major,

       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGraduate' when ts.sgbstdn_styp_code='X' then 'Continuing Education' else case when SUBSTR(ts.sgbstdn_degc_code_1,1,1) in ('M','P') THEN 'Graduate' else 'PostGraduate' end end as Standing,
       CASE WHEN SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) = 'FR' THEN 1
            WHEN SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) = 'SO' THEN 2
            WHEN SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) = 'JR' THEN 3
            WHEN SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) IN ('SR','S5') THEN 4
            else 5
       end as Class_Lvl,
       stvterm_start_date as Enrollment_Date,
       case when ch.SLRRASG_PIDM is null then 2 else 1 end as Residency,
       0 as Primary_Sport,

       agg1.GPA as gpa,
       av.PRIMARY_ADVR_NAME as Academic_Advisor,
       '' as MealPlan,
       '' as CampusHousingID,                    --placeholder
       '' as CampusHousingFloor,                --placeholder
       ch.SLRRASG_ROOM_NUMBER as CampusHousingRoom,

       case when p.spbpers_ethn_cde is null or p.spbpers_ethn_cde = '1' then
            case when substr(aggr.race_code,1,2)= '40' then ''
                 when substr(aggr.race_code,1,2)= '10' then '1'
                 when substr(aggr.race_code,1,2)= '20' then '2'
                 when substr(aggr.race_code,1,2)= '30' then '4'
                 when substr(aggr.race_code,1,2)= '50' then '3'
                 when substr(aggr.race_code,1,2)= '60' then '2'
                 when substr(aggr.race_code,1,2)= '70' then '5'
                 else '7'
                 end
            else
                ''
            end as Race1,
       case when p.spbpers_ethn_cde is null or p.spbpers_ethn_cde = '1' then
            case when instr(substr(aggr.race_code,3),', ') > 0 then
                 case
                     when substr(aggr.race_code,5,2)= '10' then '1'
                     when substr(aggr.race_code,5,2)= '20' then '2'
                     when substr(aggr.race_code,5,2)= '30' then '4'
                     when substr(aggr.race_code,5,2)= '40' then ''
                     when substr(aggr.race_code,5,2)= '50' then '3'
                     when substr(aggr.race_code,5,2)= '60' then '2'
                     when substr(aggr.race_code,5,2)= '70' then '5'
                     else '7'
                     end
                 else ''
                 end
            else ''
            end as Race2,
       case when p.spbpers_ethn_cde is null or p.spbpers_ethn_cde = '1' then
            case when instr(substr(aggr.race_code,7),', ') > 0 then
                     case
                     when substr(aggr.race_code,9,2)= '10' then '1'
                     when substr(aggr.race_code,9,2)= '20' then '2'
                     when substr(aggr.race_code,9,2)= '30' then '4'
                     when substr(aggr.race_code,9,2)= '40' then ''
                     when substr(aggr.race_code,9,2)= '50' then '3'
                     when substr(aggr.race_code,9,2)= '60' then '2'
                     when substr(aggr.race_code,9,2)= '70' then '5'
                     else '7'
                     end
                 else ''
                 end
            else ''
            end as Race3,
       case when p.spbpers_ethn_cde is null then case when substr(aggr.race_code,1,2)='40' then 2 else 1 end else to_number(p.spbpers_ethn_cde) end as Ethnicity,
       case when em.spremrg_pidm is null then '' else concat(concat(em.spremrg_last_name,', '),em.spremrg_first_name) end as EmerName,
       replace(replace(replace(replace(concat(concat(em.spremrg_phone_area,em.spremrg_phone_number),em.spremrg_phone_ext),'-',''),'+',''),'(',''),')','') as EmerPhone1,
       stvrelt_desc as EmerRelationship,

       '' as GenderIdentity,           -- placeholder
       '' as Pronoun,                  -- placeholder
       '' as sexual_orientation,       -- placeholder
       case when b3.goradid_pidm is NOT null then trim(b3.goradid_additional_id) when esf.goremal_pidm is not null then substr(esf.goremal_email_address,1,instr(esf.goremal_email_address,'@')-1) else d.gobtpac_external_user end as OPSUserName,
       TO_DATE(to_char(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS LastImportDate,

--       CASE when p.spbpers_pref_first_name is not null then p.spbpers_pref_first_name else a.spriden_first_name end as InstitutionProvidedFirstName,
--       p.spbpers_name_suffix as Suffix,
--       case when b2.goradid_pidm is not null then concat(trim(b2.goradid_additional_id),'@syr.edu') else e.goremal_email_address end as CampusEmail,
--       case when b2.goradid_pidm is not null then concat(b2.goradid_additional_id,'@syr.edu') else e.goremal_email_address end as PreferredEmail,
--       pe.goremal_email_address as PreferredEmail,
--       '' as PreferredEmail,
--       p.spbpers_city_birth as Hometown,
--       'Student' as Affiliation,
--       concat(ph.sprtele_phone_area,ph.sprtele_phone_number) as MobilePhone,
--       SUBSTR(TO_CHAR(p.spbpers_birth_date,'MM/DD/YYYY'),1,10) as DateOfBirth,
--       (case when p.spbpers_sex = 'M' then 'Male' when p.spbpers_sex = 'F' then 'Female' else '' end) as Sex,
--       r.gorrace_desc as Race,
--       aggr.race_desc as Race,
--       '' as Ethnicity,
--       e.stvethn_Desc as Ethnicity,
--       CASE WHEN SFRTHST_PIDM IS NULL THEN 'Unknown' ELSE STVTMST_DESC END AS EnrollmentStatus,

--       (select stvterm_desc from stvterm where stvterm_code = (Select max(sfrstcr_term_code) from sfrstcr where sfrstcr_pidm=a.spriden_pidm and sfrstcr_rsts_code='RE')) as CurrentTermEnrolled,
--       gpa1.shrtgpa_gpa as CurrentTermGPA,
--       (select stvterm_desc from stvterm where stvterm_code = (Select max(r1.sfrstcr_term_code) from sfrstcr r1 where r1.sfrstcr_pidm=a.spriden_pidm and r1.sfrstcr_rsts_code='RE' and r1.sfrstcr_term_code < (Select max(r2.sfrstcr_term_code) as maxt2 from sfrstcr r2 where r2.sfrstcr_pidm=a.spriden_pidm and r2.sfrstcr_rsts_code='RE'))) as PreviousTermEnrolled,
--       gpa2.shrtgpa_gpa as PreviousTermGPA,
--       agg1.HRS_Earned as CreditHoursEarned,
--       ts.sgbstdn_exp_grad_date as AnticipatedDateOfGraduation,
--       SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.CODE) as ClassStanding,
--       (select stvdept_desc from stvdept where stvdept_code = ts.sgbstdn_dept_code) as PrimarySchoolOfEnrollment,
--       '' as PrimarySchoolOfEnrollment,
--       sgbstdn_degc_code_1 as DegreeSought,
--       ts.sgbstdn_majr_code_minr_1, -- as Minor
--       av.PRIMARY_ADVR_NAME as MajorAdvisor,
--       concat(concat(spv.spriden_First_name,' '), spv.spriden_Last_name) as MajorAdvisor,
--       concat(concat(s2p.spriden_First_name,' '), s2p.spriden_Last_name) as OtherAdvisor,
--       case when ts.sgbstdn_styp_code in ('T','G') THEN 'TRUE' ELSE 'FALSE' END AS Transfer,
--       '' as Athlete,
--       '' as AthleteParticipation,
--       '' as AbroadPhoneCountryCode,
--       '' as AbroadPhone,
--       '' as AbroadPhoneExtension,
--       '' as AbroadStreet1,
--       '' as AbroadStreet2,
--       '' as AbroadStreet3,
--       '' as AbroadCity,
--       '' as AbroadStateProvince,
--       '' as AbroadPostalCode,
--       '' as AbroadCountry,
--       p.spbpers_gndr_code as GNDR,
--       p.spbpers_pprn_code as PPRN,
--      (select stvnatn_nation from stvnatn where stvnatn_code=i.gobintl_natn_code_birth) as BIRTH_COUNTRY,
--       v.gorvisa_vtyp_code as VISA_TYPE,
--       v.gorvisa_natn_code as ISSUED_BY,
--       p.spbpers_citz_code as US_CITZ,
--       (select stvnatn_nation from stvnatn where stvnatn_code=i.gobintl_natn_code_legal) as CITIZENSHIP,
--       ts.sgbstdn_styp_code AS Student_Type,
--       ts.sgbstdn_stst_code as Student_Status,
--       CASE WHEN ap2.sarappd_pidm is null THEN SYSDATE ELSE ap2.sarappd_apdc_date END as Dec_Date,
--       ap2.sarappd_apdc_date as Dec_Date,
--       concat(concat(sgbstdn_degc_code_1,': '),pg.smrprle_program_desc) as program,
--       ts.sgbstdn_camp_code as Campus,
--       ph.sprtele_intl_access as c_intl_access,
--       concat(ph.sprtele_phone_area,ph.sprtele_phone_number) as c_phone,
--       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as Cat,
--       ts.sgbstdn_term_code_admit as Admit_Term,

        case when reg.sfrstcr_pidm is null THEN 'No' else 'Yes' end as Registered,
       CASE WHEN reg.sfrstcr_pidm is not null THEN 'EN' WHEN ap2.sarappd_pidm is null THEN 'EN' ELSE ap2.sarappd_apdc_code END as Deccd,
       case when ts.sgbstdn_styp_code in ('T','F','C','U') then 'UnderGrad' when ts.sgbstdn_styp_code in ('N','D','G','R') then 'Grad' else 'Other' end as CareerLevel,
--       TO_DATE(to_char(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf
      :radSel.ACTION as Action,
       a.spriden_pidm as PIDM

       from spriden a
       INNER JOIN sgbstdn ts on (ts.sgbstdn_pidm=a.spriden_pidm)
       INNER JOIN spbpers p on (a.spriden_pidm=spbpers_pidm)
       LEFT OUTER JOIN SPREMRG em ON (a.spriden_pidm=em.spremrg_pidm and em.spremrg_priority=(select min(b.spremrg_priority) as minpri from spremrg b where a.spriden_pidm=b.spremrg_pidm) and em.spremrg_surrogate_id=(select min(c.spremrg_surrogate_id) from spremrg c where a.spriden_pidm=c.spremrg_pidm and c.spremrg_priority=em.spremrg_priority))
       LEFT OUTER JOIN STVRELT ON (em.spremrg_relt_code=stvrelt_code)
       LEFT OUTER JOIN agg_student_level_gpa agg1 ON (a.spriden_pidm=agg1.PIDM and agg1.GPA_TYPE='O' AND agg1.LEVL_CODE=ts.sgbstdn_levl_code)
       LEFT OUTER JOIN agg_race aggr on (a.spriden_pidm=aggr.PIDM)
       LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
       LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
       LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
       LEFT OUTER JOIN goradid b3 on (b3.goradid_pidm=a.spriden_pidm and b3.goradid_adid_code='ESFL')
       LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
       LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
       LEFT OUTER JOIN gobintl i on (a.spriden_pidm=i.gobintl_pidm)
       left OUTER JOIN gorvisa v on (a.spriden_pidm=v.gorvisa_pidm)
       LEFT OUTER JOIN sprtele ph on (a.spriden_pidm=ph.sprtele_pidm and ph.sprtele_tele_code='PC' and ph.sprtele_status_ind is null and ph.sprtele_seqno = (select max(ph2.sprtele_seqno) from sprtele ph2 where a.spriden_pidm=ph2.sprtele_pidm and ph2.sprtele_tele_code='PC' and ph2.sprtele_status_ind is null))
       LEFT OUTER JOIN GOREMAL su on (a.spriden_pidm=su.goremal_pidm and su.goremal_emal_code='SU')
       LEFT OUTER JOIN GOREMAL esf on (a.spriden_pidm=esf.goremal_pidm and esf.goremal_emal_code='ESF')
--       LEFT OUTER JOIN GOREMAL pe on (a.spriden_pidm=pe.goremal_pidm and pe.goremal_emal_code='PERS' AND pe.goremal_status_ind = 'A' and INSTR(pe.goremal_email_address,'@syr.edu') = 0)
       LEFT OUTER JOIN AGG_STUDENT_ADVISOR av ON (a.spriden_pidm=av.PIDM and av.TERM_CODE=:MaxTerm.CODE)
--       LEFT OUTER JOIN SGRADVR av on (a.spriden_pidm=av.sgradvr_pidm and av.sgradvr_prim_ind='Y' and av.sgradvr_term_code_eff = (select max(av1.sgradvr_term_code_eff) as maxterm from sgradvr av1 where av1.sgradvr_pidm=a.spriden_pidm))
--       LEFT OUTER JOIN SPRIDEN spv on (av.sgradvr_advr_pidm=spv.spriden_pidm and spv.spriden_change_ind is null)
--       LEFT OUTER JOIN SGRADVR a2v on (a.spriden_pidm=a2v.sgradvr_pidm and a2v.sgradvr_prim_ind<>'Y' and a2v.sgradvr_term_code_eff = (select max(av2.sgradvr_term_code_eff) as maxterm from sgradvr av2 where av2.sgradvr_pidm=a.spriden_pidm))
--       LEFT OUTER JOIN SPRIDEN s2p on (a2v.sgradvr_advr_pidm=s2p.spriden_pidm and s2p.spriden_change_ind is null)
       LEFT OUTER JOIN STVETHN e on (p.spbpers_ethn_cde = e.stvethn_code)
--       LEFT OUTER JOIN GORPRAC prac on (a.spriden_pidm=prac.gorprac_pidm)
--       LEFT OUTER JOIN GORRACE r on (prac.gorprac_race_cde=r.gorrace_race_cde)
       LEFT OUTER JOIN SFRSTCR reg on (a.spriden_pidm=reg.sfrstcr_pidm and reg.sfrstcr_term_code >= :MinTerm.CODE and reg.sfrstcr_term_code <= :MaxTerm.CODE and reg.sfrstcr_rsts_code = 'RE' and reg.sfrstcr_crn <> 90009)
       left outer join sfrthst on (sfrthst_pidm=a.spriden_pidm and sfrthst_term_code >= :MinTerm.CODE and sfrthst_term_code <= :MaxTerm.CODE and sfrthst_SURROGATE_ID= (select max(b.sfrthst_SURROGATE_ID) from sfrthst b where b.sfrthst_pidm = a.spriden_pidm and b.sfrthst_term_code >= :MinTerm.CODE and b.sfrthst_term_code <=:MaxTerm.CODE))
       left outer join stvtmst on (sfrthst_tmst_code = stvtmst_code)
       left outer join shrtgpa gpa1 on (a.spriden_pidm=gpa1.shrtgpa_pidm and gpa1.shrtgpa_gpa_type_ind = 'I' and gpa1.shrtgpa_levl_code=ts.sgbstdn_levl_code and gpa1.shrtgpa_term_code = (Select max(sfrstcr_term_code) from sfrstcr where sfrstcr_pidm=a.spriden_pidm and sfrstcr_rsts_code='RE'))
       left outer join shrtgpa gpa2 on (a.spriden_pidm=gpa2.shrtgpa_pidm and gpa2.shrtgpa_gpa_type_ind = 'I' and gpa2.shrtgpa_levl_code=ts.sgbstdn_levl_code and gpa2.shrtgpa_term_code = (select max(gpax.shrtgpa_term_code) as maxterm from shrtgpa gpax where gpax.shrtgpa_pidm=a.spriden_pidm and gpax.shrtgpa_term_code < (Select max(sfrstcr_term_code) from sfrstcr where sfrstcr_pidm=a.spriden_pidm and sfrstcr_rsts_code='RE')))
       LEFT OUTER JOIN SPRADDR adl on (a.spriden_pidm=adl.spraddr_pidm and adl.spraddr_status_ind is null and concat(adl.spraddr_atyp_code,to_char(adl.spraddr_seqno,'009')) = (select min(CONCAT(ad2.spraddr_atyp_code,TO_CHAR(ad2.spraddr_seqno,'009'))) as maxcode from spraddr ad2 where ad2.spraddr_pidm=adl.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('MA','PR') and (ad2.spraddr_natn_code is null or ad2.spraddr_natn_code='US')))
       LEFT OUTER JOIN SPRADDR adh on (a.spriden_pidm=adh.spraddr_pidm and adh.spraddr_status_ind is null and concat(adh.spraddr_atyp_code,to_char(adh.spraddr_seqno,'009')) = (select max(CONCAT(ad2.spraddr_atyp_code,TO_CHAR(ad2.spraddr_seqno,'009'))) as maxcode from spraddr ad2 where ad2.spraddr_pidm=adh.spraddr_pidm and ad2.spraddr_status_ind is null and ad2.spraddr_atyp_code in ('PR','PA','P2')))
       left outer join sarappd ap2 on (a.spriden_pidm=ap2.sarappd_pidm and ts.sgbstdn_term_code_eff=ap2.sarappd_term_code_entry and ap2.sarappd_seq_no= (select max(ap3.sarappd_seq_no) as maxseq from sarappd ap3 where a.spriden_pidm=ap3.sarappd_pidm and ts.sgbstdn_term_code_eff=ap3.sarappd_term_code_entry and ap3.sarappd_term_code_entry >= :MinTerm.CODE and ap3.sarappd_term_code_entry <= :MaxTerm.CODE))
       left outer join slrrasg ch on (a.spriden_pidm=ch.slrrasg_pidm and slrrasg_term_code=:MaxTerm.CODE and ch.slrrasg_ascd_code = 'AC')
       left outer join stvterm on (ts.sgbstdn_term_code_admit=stvterm_code)
        where
          a.spriden_change_ind is null
          and ts.sgbstdn_stst_code = 'AS'
--          and ts.sgbstdn_camp_code <> CASE WHEN :chkOL = 1 then 'OL' else '??' end
--          and (ts.sgbstdn_resd_code = 'F' OR p.spbpers_citz_code = 'N')
          and ts.sgbstdn_styp_code IN ('T','F','C','U','N','D','G','R','X')                                 --:selSTYP.STYP_CODE
          and ts.sgbstdn_coll_code_1 <> 'SU'                                                                --not SU
          and ts.sgbstdn_majr_code_1 <> 'EHS'                                                               --not ESF in HS
          and ts.sgbstdn_term_code_eff =
          (select MAX(g.sgbstdn_term_code_eff) AS MAXTERM from sgbstdn g where g.sgbstdn_pidm=ts.sgbstdn_pidm and g.sgbstdn_term_code_eff <= :MaxTerm.CODE)
order by a.spriden_last_name, a.spriden_first_name, a.spriden_id
) WHERE
:chkView=1
AND
DECCD IN ('AP','CF','CP','EN')
AND NOT (CareerLevel = 'Other' and Registered = 'No')
AND
Patient_Control_ID IS NOT NULL
AND
(
(:chkI_Grad_R = 1 and CareerLevel = 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
OR
(:chkI_Grad_U = 1 and CareerLevel = 'Grad' and Deccd <> 'EN' AND Registered = 'No')
OR
(:chkI_UGrad_R = 1 and CareerLevel <> 'Grad' and Deccd <> 'EN' AND Registered = 'Yes')
OR
(:chkI_UGrad_U = 1 and CareerLevel <> 'Grad' and Deccd <> 'EN' AND Registered = 'No')
OR
(:chkC_Grad_R = 1 and CareerLevel = 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
OR
(:chkC_Grad_U = 1 and CareerLevel = 'Grad' and Deccd = 'EN' AND Registered = 'No')
OR
(:chkC_UGrad_R = 1 and CareerLevel <> 'Grad' and Deccd = 'EN' AND Registered = 'Yes')
OR
(:chkC_UGrad_U = 1 and CareerLevel <> 'Grad' and Deccd = 'EN' AND Registered = 'No')
)
--ORDER BY LegalLastName, LegalFirstName, SISID