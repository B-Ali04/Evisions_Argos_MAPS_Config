SGBSTDN_LEVL_CODE = 'GR'
AND EXISTS (SELECT * FROM SFAREGS WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE IN (SELECT STVRSTS_CODE FROM STVRSTS))

ORDER BY
    SSBSECT_SUBJ_CODE,
    SSBSECT_CRSE_NUMB,
    SSBSECT_SEQ_NUMB,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI