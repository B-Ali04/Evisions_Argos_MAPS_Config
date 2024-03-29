SELECT
    SIRASGN.SIRASGN_PIDM,
    RII.LFMI_NAME AS INSTR_NAME,
    F_GET_DESC_FNC('STVDEPT', SCBCRSE_DEPT_CODE, 30) AS INTSR_DEPT,
    f_get_desc_fnc('STVTERM',SFRSTCR.SFRSTCR_TERM_CODE, 30) Term,
    SCBCRSE.SCBCRSE_TITLE TITLE,
    SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID || ': ' || SCBCRSE.SCBCRSE_TITLE Title,
    SSBSECT.SSBSECT_SUBJ_CODE PREFIX,
    SSBSECT.SSBSECT_CRSE_NUMB COURSE,
    SSBSECT.SSBSECT_SEQ_NUMB SECTION,
    SCBCRSE.SCBCRSE_TITLE TITLE,
    SGBSTDN.SGBSTDN_LEVL_CODE LEVEL_CODE,
    --(COUNT(SGBSTDN.SGBSTDN_LEVL_CODE)) AS COUNT,
    SFRSTCR.SFRSTCR_CREDIT_HR CRED_HR
    --(COUNT(SGBSTDN.SGBSTDN_LEVL_CODE)) * (SFRSTCR.SFRSTCR_CREDIT_HR) TOTAL_CRED_HR

     FROM REL_IDENTITY_INSTRUCTOR RII

     LEFT OUTER JOIN SIRASGN SIRASGN ON SIRASGN.SIRASGN_PIDM = RII.PIDM

     LEFT OUTER JOIN SSBSECT SSBSECT ON SSBSECT.SSBSECT_TERM_CODE = SIRASGN.SIRASGN_TERM_CODE
          AND SSBSECT.SSBSECT_CRN = SIRASGN.SIRASGN_CRN

     JOIN SCBCRSE SCBCRSE ON SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
          AND SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
          AND SCBCRSE.SCBCRSE_EFF_TERM = (SELECT MAX(SCBCRSE.SCBCRSE_EFF_TERM)
                                         FROM SCBCRSE SCBCRSEX
                                         WHERE SCBCRSEX.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
                                         AND SCBCRSEX.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
                                         AND SCBCRSEX.SCBCRSE_EFF_TERM <= SSBSECT.SSBSECT_TERM_CODE
                                   )

    LEFT OUTER JOIN SFRSTCR SFRSTCR ON SFRSTCR.SFRSTCR_TERM_CODE = SIRASGN.SIRASGN_TERM_CODE
          AND SFRSTCR.SFRSTCR_CRN = SIRASGN.SIRASGN_CRN
          AND SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE', 'RW')

     LEFT OUTER JOIN SGBSTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SFRSTCR_PIDM
          AND SGBSTDN.SGBSTDN_TERM_CODE_EFF = FY_SGBSTDN_EFF_TERM(SGBSTDN.SGBSTDN_PIDM, SFRSTCR.SFRSTCR_TERM_CODE)
          AND SGBSTDN.SGBSTDN_LEVL_CODE IN ('UG', 'GR')

WHERE
      SIRASGN.SIRASGN_TERM_CODE = :PARM_TERM_CODE_SELECT.STVTERM_CODE
      AND F_GET_DESC_FNC('STVDEPT', SCBCRSE_DEPT_CODE, 30) = :parm_dept_desc_select.DEPT
      AND SIRASGN.SIRASGN_PRIMARY_IND = 'Y'
      AND SFRSTCR.SFRSTCR_PIDM IS NOT NULL
/*
GROUP BY
    SGBSTDN.SGBSTDN_LEVL_CODE,
    SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID,
    SSBSECT.SSBSECT_SUBJ_CODE,
    SSBSECT.SSBSECT_CRSE_NUMB,
    SSBSECT.SSBSECT_SEQ_NUMB,
    SCBCRSE.SCBCRSE_TITLE,
    SIRASGN.SIRASGN_PIDM,
    RII.LFMI_NAME,
    f_get_desc_fnc('STVTERM',SFRSTCR.SFRSTCR_TERM_CODE, 30),
    F_GET_DESC_FNC('STVDEPT', SCBCRSE_DEPT_CODE, 30),
    SFRSTCR.SFRSTCR_CREDIT_HR
*/
ORDER BY
      LFMI_NAME,
      SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID,
      SGBSTDN.SGBSTDN_LEVL_CODE