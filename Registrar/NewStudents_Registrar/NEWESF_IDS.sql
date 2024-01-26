SELECT DISTINCT SUID, LASTNAME, FIRSTNAME, SU_EMAIL, STATUS, PERS_EMAIL
 FROM (
select   spriden_id as BannerID, spriden_pidm AS PIDM
       ,(case when dc.sarappd_apdc_code is null THEN 'AX' ELSE dc.sarappd_apdc_code END) as APDC
       ,(case when dc.sarappd_pidm is null then SYSDATE ELSE dc.sarappd_apdc_date END) as APDC_DATE
       ,TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf
       ,SUBSTR(TO_CHAR(t.STVTERM_START_DATE,'YYYYMMDD'),1,6) AS ENTRYDT
,s.spriden_last_name AS LASTNAME, s.spriden_first_name AS FIRSTNAME, s.spriden_mi AS MIDDLENAME, p.spbpers_name_suffix AS NAME_SUFFIX
,p.spbpers_pref_first_name as Pref_First_Name
,CONCAT(trim(net.goradid_additional_id),'@syr.edu') as SU_EMAIL
,st.sgbstdn_stst_code as STST
,st.sgbstdn_styp_code as STYP
,CASE WHEN st.sgbstdn_levl_code = 'GR' THEN 'New Graduate'
      WHEN st.sgbstdn_levl_code = 'UG' THEN 'New Undergraduate'
      ELSE 'New'
      END AS STATUS
,st.sgbstdn_resd_code as resd_code
,su.goradid_additional_id as SUID
,e.goremal_email_address as pers_email
,d.gobtpac_external_user as ESFiD
--,CASE WHEN a.spraddr_pidm is not null then 'PR' else case when a2.spraddr_pidm is not null then 'MA' else null end end as atyp_code
--,case when a.spraddr_pidm is not null then a.spraddr_seqno ELSE case when a2.spraddr_pidm is not null then a2.spraddr_seqno else null end end as atyp_seq
--,CASE WHEN a.spraddr_pidm is not null then a.spraddr_natn_code ELSE a2.spraddr_natn_code END as atyp_natn
--,CONCAT(ph.sprtele_phone_area,ph.sprtele_phone_number) as phone
,st.sgbstdn_levl_code as su_level
,st.sgbstdn_term_code_eff, st.sgbstdn_term_code_admit
,st.sgbstdn_degc_code_1 AS Degree
,st.sgbstdn_majr_code_1 as Major
,CASE WHEN st.sgbstdn_levl_code = 'GR' THEN
      CASE WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='M' THEN 'M'
           WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='P' THEN 'D'
           WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='C' THEN 'C'
           ELSE 'M' END
      ELSE '' END AS GR_SUFFIX

from sgbstdn st
inner join spriden s on (st.sgbstdn_pidm=s.spriden_pidm and s.spriden_change_ind is null)
inner join spbpers p on (s.spriden_pidm=p.spbpers_pidm)
inner join stvterm t on (st.sgbstdn_term_code_eff=t.stvterm_code)
left outer join goradid su on (s.spriden_pidm=su.goradid_pidm and su.goradid_adid_code='SUID')
left outer join goradid net on (s.spriden_pidm=net.goradid_pidm and net.goradid_adid_code='SUNI')
left outer join goradid x on (s.spriden_pidm=x.goradid_pidm and x.goradid_adid_code=:selADID.Missing)
LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=s.spriden_pidm)
LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=s.spriden_pidm)
LEFT OUTER JOIN SARADAP ap on (s.spriden_pidm=ap.saradap_pidm and st.sgbstdn_term_code_admit=ap.saradap_term_code_entry)
left outer join sarappd dc on (ap.saradap_pidm=dc.sarappd_pidm and ap.saradap_appl_no=dc.sarappd_appl_no and dc.sarappd_seq_no= (select max(b.sarappd_seq_no) as maxseq from sarappd b where ap.saradap_pidm=b.sarappd_pidm and ap.saradap_appl_no=b.sarappd_appl_no))
LEFT OUTER JOIN GOREMAL e on (s.spriden_pidm=e.goremal_pidm and e.goremal_emal_code='PERS' and e.goremal_status_ind='A')

where
st.sgbstdn_term_code_eff=(select max(b.sgbstdn_term_code_eff) from sgbstdn b where b.sgbstdn_pidm=st.sgbstdn_pidm)
--and st.sgbstdn_term_code_eff=st.sgbstdn_term_code_admit
and st.sgbstdn_term_code_eff >= :selMinTerm.CODE
and st.sgbstdn_term_code_eff <= :selMaxTerm.CODE
--and ap.saradap_term_code_entry >= :selMinTerm.CODE
--and ap.saradap_term_code_entry <= :selMaxTerm.CODE
--and sysdate < t.stvterm_end_date
--and sysdate + 90 > t.stvterm_start_date
and st.sgbstdn_stst_code in ('AS')
and st.sgbstdn_coll_code_1 <> 'SU'
and st.sgbstdn_majr_code_1 <> 'EHS'
AND st.sgbstdn_styp_code = :selSTYP.STYP
and x.goradid_adid_code is null
--AND EXISTS (SELECT * FROM GORIROL WHERE GORIROL_PIDM=st.SGBSTDN_PIDM AND GORIROL_ROLE='STUDENT')
)
WHERE APDC = :selAPDC.APDC
order BY LASTNAME, FIRSTNAME