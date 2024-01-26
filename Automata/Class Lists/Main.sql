with SSASECT as
(
    SELECT
      SSBSECT.SSBSECT_TERM_CODE,
      SSBSECT.SSBSECT_CRN,
      SSBSECT.SSBSECT_PTRM_CODE,
      SSBSECT.SSBSECT_SUBJ_CODE,
      SSBSECT.SSBSECT_CRSE_NUMB,
      SSBSECT.SSBSECT_SEQ_NUMB,
      SSBSECT.SSBSECT_SSTS_CODE,
      SSBSECT.SSBSECT_SCHD_CODE,
      SSBSECT.SSBSECT_CAMP_CODE,
      SSBSECT.SSBSECT_CREDIT_HRS,
      SSBSECT.SSBSECT_BILL_HRS,
      SSBSECT.SSBSECT_GMOD_CODE,
      SSBSECT.SSBSECT_REG_ONEUP,
      SSBSECT.SSBSECT_PRIOR_ENRL,
      SSBSECT.SSBSECT_PROJ_ENRL,
      SSBSECT.SSBSECT_MAX_ENRL,
      SSBSECT.SSBSECT_ENRL,
      SSBSECT.SSBSECT_SEATS_AVAIL,
      SSBSECT.SSBSECT_TOT_CREDIT_HRS,
      SSBSECT.SSBSECT_CENSUS_ENRL,
      SSBSECT.SSBSECT_CENSUS_ENRL_DATE,
      SSBSECT.SSBSECT_ACTIVITY_DATE,
      SSBSECT.SSBSECT_PTRM_START_DATE,
      SSBSECT.SSBSECT_PTRM_END_DATE,
      SSBSECT.SSBSECT_PTRM_WEEKS,
      SSBSECT.SSBSECT_WAIT_CAPACITY,
      SSBSECT.SSBSECT_WAIT_COUNT,
      SSBSECT.SSBSECT_WAIT_AVAIL,
      SSBSECT.SSBSECT_INSM_CODE,
      SSBSECT.SSBSECT_SURROGATE_ID,
      SSBSECT.SSBSECT_VERSION,
      SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID,
      SSBSECT.SSBSECT_SICAS_CAMP_SECTION_ID,
      SCBCRSE.SCBCRSE_SUBJ_CODE,
      SCBCRSE.SCBCRSE_CRSE_NUMB,
      SCBCRSE.SCBCRSE_EFF_TERM,
      SCBCRSE.SCBCRSE_COLL_CODE,
      SCBCRSE.SCBCRSE_DIVS_CODE,
      SCBCRSE.SCBCRSE_DEPT_CODE,
      SCBCRSE.SCBCRSE_CSTA_CODE,
      SCBCRSE.SCBCRSE_TITLE,
      SCBCRSE.SCBCRSE_CIPC_CODE,
      SCBCRSE.SCBCRSE_CREDIT_HR_IND,
      SCBCRSE.SCBCRSE_CREDIT_HR_LOW,
      SCBCRSE.SCBCRSE_CREDIT_HR_HIGH,
      SCBCRSE.SCBCRSE_LEC_HR_IND,
      SCBCRSE.SCBCRSE_LEC_HR_LOW,
      SCBCRSE.SCBCRSE_LEC_HR_HIGH,
      SCBCRSE.SCBCRSE_BILL_HR_IND,
      SCBCRSE.SCBCRSE_BILL_HR_LOW,
      SCBCRSE.SCBCRSE_BILL_HR_HIGH,
      SCBCRSE.SCBCRSE_ACTIVITY_DATE,
      SCBCRSE.SCBCRSE_CONT_HR_LOW,
      SCBCRSE.SCBCRSE_CONT_HR_IND,
      SCBCRSE.SCBCRSE_CONT_HR_HIGH,
      SCBCRSE.SCBCRSE_REPS_CODE,
      SCBCRSE.SCBCRSE_MAX_RPT_UNITS,
      SCBCRSE.SCBCRSE_SURROGATE_ID,
      SCBCRSE.SCBCRSE_VERSION,
      SCBCRSE.SCBCRSE_VPDI_CODE,
      SCBCRSE.SCBCRSE_SICAS_SUNY_ID,
      F_GET_DESC_FNC('STVSSTS', SSBSECT.SSBSECT_SSTS_CODE, 30) as SSBSECT_SSTS_DESC,
      F_GET_DESC_FNC('STVSCHD', SSBSECT.SSBSECT_SCHD_CODE, 30) as SSBSECT_SCHD_DESC,
      F_GET_DESC_FNC('STVCSTA', SCBCRSE.SCBCRSE_CSTA_CODE, 30) as SCBCRSE_CSTA_DESC,
      F_GET_DESC_FNC('STVREPS', SCBCRSE.SCBCRSE_REPS_CODE, 30) as SCBCRSE_REPS_DESC

  FROM
      SSBSECT SSBSECT

      LEFT OUTER JOIN SCBCRSE SCBCRSE ON SSBSECT.SSBSECT_SUBJ_CODE = SCBCRSE.SCBCRSE_SUBJ_CODE
           AND SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB

  WHERE
      SSBSECT.SSBSECT_TERM_CODE = :ddSemester.STVTERM_CODE
      AND SCBCRSE.SCBCRSE_EFF_TERM = (SELECT MAX(SCBCRSE_EFF_TERM)
                                    FROM     SCBCRSE CRSE
                                    WHERE    CRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
                                    AND      CRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
                                    AND      CRSE.SCBCRSE_EFF_TERM <= SSBSECT.SSBSECT_TERM_CODE)
  ORDER BY
      SSBSECT.SSBSECT_SICAS_CAMP_SECTION_ID
  ),

SIRASGQ as
(
 SELECT
      SIRASGN.SIRASGN_TERM_CODE,
      SIRASGN.SIRASGN_CRN,
      SIRASGN.SIRASGN_PIDM,
      SIRASGN.SIRASGN_CATEGORY,
      SIRASGN.SIRASGN_PRIMARY_IND,
      SIRASGN.SIRASGN_ACTIVITY_DATE,
      SIRASGN.SIRASGN_SURROGATE_ID,
      SIRASGN.SIRASGN_VERSION,
      SIRDPCL.SIRDPCL_PIDM,
      SIRDPCL.SIRDPCL_TERM_CODE_EFF,
      SIRDPCL.SIRDPCL_COLL_CODE,
      SIRDPCL.SIRDPCL_DEPT_CODE,
      SIRDPCL.SIRDPCL_ACTIVITY_DATE,
      SIRDPCL.SIRDPCL_SURROGATE_ID,
      SIRDPCL.SIRDPCL_VERSION,
      f_format_name(SIRDPCL.SIRDPCL_PIDM, 'LF30') as SIRDPCL_INSTR_NAME,
      CASE
        WHEN SIRDPCL_DEPT_CODE IS NULL THEN 'DEPT UNAVAILABLE'
          ELSE F_GET_DESC_FNC('STVDEPT', SIRDPCL.SIRDPCL_DEPT_CODE, 30)
            END as SIRDPCL_DEPT_DESC,
      (SELECT GOREMAL_EMAIL_ADDRESS
      FROM    GOREMAL
      WHERE   GOREMAL_PIDM = SIRDPCL_PIDM
      AND     GOREMAL_EMAL_CODE = 'ESF'
      AND     GOREMAL_STATUS_IND = 'A'
      AND     GOREMAL_PREFERRED_IND = 'Y'
      AND     SIRASGN_PRIMARY_IND = 'Y') as SIRDPCL_INSTR_EMAIL

  FROM
      SIRASGN SIRASGN
      LEFT OUTER JOIN SIRDPCL SIRDPCL ON SIRDPCL.SIRDPCL_PIDM = SIRASGN.SIRASGN_PIDM

  WHERE
      SIRASGN.SIRASGN_PRIMARY_IND = 'Y'
      AND SIRASGN.SIRASGN_TERM_CODE = (SELECT MAX(SIRASGN_TERM_CODE)
                                      FROM    SIRASGN ASGN
                                      WHERE   ASGN.SIRASGN_PIDM = SIRASGN.SIRASGN_PIDM
                                      AND     ASGN.SIRASGN_TERM_CODE <= :ddSemester.STVTERM_CODE)
      AND SIRDPCL.SIRDPCL_TERM_CODE_EFF = (SELECT MAX(SIRDPCL_TERM_CODE_EFF)
                                          FROM    SIRDPCL DPCL
                                          WHERE   DPCL.SIRDPCL_PIDM = SIRDPCL.SIRDPCL_PIDM
                                          AND     DPCL.SIRDPCL_TERM_CODE_EFF <= :ddSemester.STVTERM_CODE)
      AND SIRDPCL.SIRDPCL_SURROGATE_ID = (SELECT MAX(SIRDPCL_SURROGATE_ID)
                                         FROM    SIRDPCL DPCL
                                         WHERE   DPCL.SIRDPCL_PIDM = SIRDPCL.SIRDPCL_PIDM
                                         AND     DPCL.SIRDPCL_TERM_CODE_EFF <= :ddSemester.STVTERM_CODE)
  )

select s.spriden_id as id,
       s.spriden_last_name || ', ' || coalesce(p.spbpers_pref_first_name, s.spriden_first_name) || ' ' || s.spriden_mi  as StudentName,
       p.spbpers_pref_first_name as pref_fname,
       s.spriden_first_name as fname,
       s.spriden_mi as mname,
       s.spriden_last_name as lname,
       e.goremal_email_address as email,

-- registration status
       reg.sfrstcr_credit_hr as sfrstcr_credit_hr,
       reg.sfrstcr_rsts_code as sfrstcr_rsts_code,

-- course section info
       cs.ssbsect_crn as crn,
       cs.ssbsect_subj_code as subj_code,
       cs.ssbsect_crse_numb as crse_numb,
       cs.ssbsect_seq_numb as seq_numb,
       cs.scbcrse_title as crse_title,
       cs.scbcrse_dept_code as course_dept,

-- instructor info
       ci.sirdpcl_instr_name as PrimaryInstrName

 from ssasect cs

 left outer join sirasgq ci on ci.sirasgn_term_code = ssbsect_term_code
         and cs.ssbsect_crn = ci.sirasgn_crn
         and ci.sirasgn_primary_ind = 'Y'
 inner join sfrstcr reg
   on reg.sfrstcr_term_code = ssbsect_term_code
   and ssbsect_crn = reg.sfrstcr_crn
 inner join spriden s
    on spriden_pidm = reg.sfrstcr_pidm
    and spriden_change_ind is null
    and spriden_ntyp_code is null
 left outer join spbpers p on p.spbpers_pidm = spriden_pidm
 left outer join goremal e
   on e.goremal_pidm = spriden_pidm
   and e.goremal_emal_code = 'SU'
   and e.goremal_status_ind = 'A'
   and e.goremal_preferred_ind = 'Y'

 where cs.ssbsect_term_code = :ddSemester.STVTERM_CODE
   and reg.sfrstcr_rsts_code = 'RE'
   and cs.scbcrse_dept_Code = :ddDept.STVDEPT_CODE
 order by cs.ssbsect_subj_code, cs.ssbsect_crse_numb, cs.ssbsect_seq_numb, lname, fname

