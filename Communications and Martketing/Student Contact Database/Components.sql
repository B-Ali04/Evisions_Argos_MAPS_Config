-- ID RESULTS PANE
select SPRIDEN.SPRIDEN_PIDM "PIDM",
       SPRIDEN.SPRIDEN_ID "Banner_ID",
       SPRIDEN.SPRIDEN_LAST_NAME "Last_Name",
       SPRIDEN.SPRIDEN_FIRST_NAME "First_Name",
       SPRIDEN.SPRIDEN_MI "Middle_Name",
       spbpers.spbpers_birth_date "DOB",
       GOBTPAC.GOBTPAC_EXTERNAL_USER "User_Name",
       goradid.goradid_additional_id "SU_ID",
       (Select distinct 'Y' from hrvyemp
where hrvyemp_active_ind = '1'
and hrvyemp_primary_ind = '1'
and hrvyemp_role_type_code in ('STEMP','AUXIL','RFEMP')
and hrvyemp_pidm = spriden_pidm) emp_ind

  from SATURN.SPRIDEN SPRIDEN,
       SATURN.SPBPERS SPBPERS,
       GENERAL.GOBTPAC GOBTPAC,
       GORADID
 where ( SPRIDEN.SPRIDEN_PIDM = SPBPERS.SPBPERS_PIDM (+)
         and SPRIDEN.SPRIDEN_PIDM = GOBTPAC.GOBTPAC_PIDM (+) )
         and (GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM and GORADID.GORADID_ADID_CODE = 'SUID')
   and ( SPRIDEN.SPRIDEN_CHANGE_IND IS NULL
         and :f1_Button_Search is not null
         and (:f1_LastName IS NOT NULL
           or :f1_FirstName IS NOT NULL
           or :f1_SUid IS NOT NULL
           or :f1_User IS NOT NULL)
         and ( ( LOWER(SPRIDEN.SPRIDEN_LAST_NAME) LIKE(LOWER(:f1_LastName))
             or :f1_LastName IS NULL )
           and ( LOWER(SPRIDEN.SPRIDEN_FIRST_NAME) LIKE(LOWER(:f1_FirstName))
             or  (:f1_FirstName) LIKE(SPBPERS.SPBPERS_PREF_FIRST_NAME)
             or :f1_FirstName IS NULL )
           and ( SPRIDEN.SPRIDEN_ID = :f1_SUid
             or :f1_SUid IS NULL )
           and ( LOWER(GOBTPAC.GOBTPAC_EXTERNAL_USER) = LOWER(:f1_User)
             or :f1_User IS NULL ) ) )
 order by SPRIDEN.SPRIDEN_LAST_NAME,
          SPRIDEN.SPRIDEN_FIRST_NAME,
          SPRIDEN.SPRIDEN_ID

-- EMERGENCY CONTACT
SELECT spremrg_last_name,
       spremrg_first_name,
       spremrg_mi,
       spremrg_phone_area,
       spremrg_phone_number,
       rel.stvrelt_desc,
       spremrg_street_line1,
       spremrg_street_line2,
       spremrg_city,
       spremrg_stat_code,
       spremrg_zip
  FROM spremrg e
  left outer join stvrelt rel on rel.stvrelt_code = e.spremrg_relt_code
 WHERE spremrg_pidm = :f1_SearchResult.PIDM

-- CURRICULUM
SELECT sgvccur_term_code                         AS TERM_CODE,
       stvlevl_desc                              AS STU_LEVEL,
       sgvccur_priority_no                       AS PRIORITY_NUM,
       stvcoll_desc                              AS SCHOOL,
       stvdegc_desc                              AS DEGREE,
       sgvccur_program                           AS PROGRAM_CODE,
       sovcfos_lfst_code || '-' || stvmajr_desc  AS MAJOR_MINOR_CONC,
       stvdept_desc                              AS DEPARTMENT
  FROM sgvccur, sovcfos, stvcoll, stvdegc, stvmajr, stvdept, stvlevl,
       (SELECT b.sgvccur_pidm             AS pidm,
               MAX(b.sgvccur_term_code)   AS term_code,
               b.sgvccur_priority_no      AS priority_no
          FROM sgvccur b
         WHERE b.sgvccur_pidm = sgvccur_pidm
           AND b.sgvccur_order > 0
           --AND b.sgvccur_stst_code = 'AS'
      GROUP BY b.sgvccur_pidm,
               b.sgvccur_priority_no) vtable_max_priority
 WHERE sgvccur_pidm = :f1_SearchResult.PIDM
   AND sgvccur_term_code = vtable_max_priority.term_code
   AND sgvccur_priority_no = vtable_max_priority.priority_no
   AND sgvccur_pidm = vtable_max_priority.pidm
   AND sgvccur_lmod_code = 'LEARNER'
   AND sgvccur_order > 0
   --AND sgvccur_stdn_term_code_end > :sql_CurrentTerm.TERM
   AND sgvccur_active_ind = 'Y'
   AND sovcfos_lcur_seqno = sgvccur_seqno
   AND sovcfos_pidm = :f1_SearchResult.PIDM
   AND stvcoll_code = sgvccur_coll_code
   AND stvdegc_code = sgvccur_degc_code
   AND stvmajr_code = sovcfos_majr_code
   AND stvdept_code = sovcfos_dept_code
   AND stvlevl_code = sgvccur_levl_code

-- ADDRESSES
SELECT stvatyp_desc,
       spraddr_seqno,
       spraddr_street_line1,
       spraddr_street_line2,
       spraddr_city,
       spraddr_stat_code,
       spraddr_zip,
       TRUNC(spraddr_from_date)         AS spraddr_from_date,
       TRUNC(spraddr_to_date)           AS spraddr_to_date
  FROM spraddr a
  inner join stvatyp on stvatyp_code = spraddr_atyp_code
 WHERE  spraddr_status_ind is null
   AND trunc(sysdate) > = spraddr_FROM_date
   AND (trunc(sysdate) < = spraddr_to_date
    OR spraddr_to_date is null)
   AND spraddr_pidm = :f1_SearchResult.PIDM

-- ADDITIONAL INFO
SELECT goradid_adid_code,
       gtvadid_desc,
       goradid_additional_id
  FROM goradid, gtvadid
 WHERE goradid_adid_code = gtvadid_code
   AND goradid_pidm = :f1_SearchResult.PIDM

-- EMIAL ADDRESSES
SELECT gtvemal_desc,
       goremal_email_address,
       goremal_preferred_ind
  FROM goremal
  inner join gtvemal on gtvemal_code = goremal_emal_code
 WHERE goremal_pidm = :f1_SearchResult.PIDM

-- PHONE NUMBERS
SELECT stvtele_desc,--sprtele_tele_code,
       sprtele_phone_area,
       sprtele_phone_number
  FROM sprtele
  inner join stvtele on stvtele_code = sprtele_tele_code
 WHERE sprtele_pidm = :f1_SearchResult.PIDM