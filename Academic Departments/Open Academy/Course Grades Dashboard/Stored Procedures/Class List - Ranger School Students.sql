SGBSTDN_DEPT_CODE = 'FTC'
AND EXISTS (SELECT * FROM SFAREGS WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE IN (SELECT STVRSTS_CODE FROM STVRSTS))

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI
