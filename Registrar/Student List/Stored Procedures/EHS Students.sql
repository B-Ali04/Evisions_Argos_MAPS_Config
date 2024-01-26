SGBSTDN_MAJR_CODE_1 = 'EHS'
AND SGBSTDN_STST_CODE = 'AS'
AND EXISTS (SELECT * FROM SFRSTCR WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE IN ('RE', 'RW'))

ORDER BY
    SGBSTDN_STST_CODE DESC,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI