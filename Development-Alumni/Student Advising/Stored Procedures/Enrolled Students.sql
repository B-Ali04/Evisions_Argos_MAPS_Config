SGBSTDN_STYP_CODE <> 'X'
AND EXISTS (SELECT * FROM SFRSTCR WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE IN (SELECT STVRSTS_CODE FROM STVRSTS))

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI