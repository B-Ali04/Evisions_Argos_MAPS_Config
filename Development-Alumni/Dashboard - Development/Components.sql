-- search results
select SPRIDEN.SPRIDEN_PIDM "PIDM",
       SPRIDEN.SPRIDEN_ID "SUid",
       SPRIDEN.SPRIDEN_LAST_NAME "Last_Name",
       SPRIDEN.SPRIDEN_FIRST_NAME "First_Name",
       SPRIDEN.SPRIDEN_MI "Middle_Name",
       spbpers.spbpers_birth_date "DOB",
       GOBTPAC.GOBTPAC_EXTERNAL_USER "User_Name"
  from SATURN.SPRIDEN SPRIDEN,
       SATURN.SPBPERS SPBPERS,
       GENERAL.GOBTPAC GOBTPAC
 where ( SPRIDEN.SPRIDEN_PIDM = SPBPERS.SPBPERS_PIDM (+)
         and SPRIDEN.SPRIDEN_PIDM = GOBTPAC.GOBTPAC_PIDM (+) )
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

-- curriculum
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
   AND sgvccur_stdn_term_code_end > :sql_CurrentTerm.TERM
   AND sgvccur_active_ind = 'Y'
   AND sovcfos_lcur_seqno = sgvccur_seqno
   AND sovcfos_pidm = :f1_SearchResult.PIDM
   AND stvcoll_code = sgvccur_coll_code
   AND stvdegc_code = sgvccur_degc_code
   AND stvmajr_code = sovcfos_majr_code
   AND stvdept_code = sovcfos_dept_code
   AND stvlevl_code = sgvccur_levl_code

-- addresses
SELECT spraddr_atyp_code,
       spraddr_seqno,
       spraddr_street_line1,
       spraddr_street_line2,
       spraddr_city,
       spraddr_stat_code,
       spraddr_zip,
       TRUNC(spraddr_from_date)         AS spraddr_from_date,
       TRUNC(spraddr_to_date)           AS spraddr_to_date
  FROM spraddr
 WHERE spraddr_status_ind is null
   AND trunc(sysdate) > = spraddr_FROM_date
   AND (trunc(sysdate) < = spraddr_to_date
    OR spraddr_to_date is null)
   AND spraddr_pidm = :f1_SearchResult.PIDM

--additional ID
SELECT goradid_adid_code,
       gtvadid_desc,
       goradid_additional_id
  FROM goradid, gtvadid
 WHERE goradid_adid_code = gtvadid_code
   AND goradid_pidm = :f1_SearchResult.PIDM