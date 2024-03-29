INFC_CODE = 'ISIR'
AND EXISTS (SELECT * FROM SFRSTCR WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_RSTS_CODE IN ('RE','RW') AND SFRSTCR_TERM_CODE <= (:select_term_code.STVTERM_CODE)
AND SFRSTCR_TERM_CODE >= (:select_term_code.STVTERM_CODE - 50))

ORDER BY
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME