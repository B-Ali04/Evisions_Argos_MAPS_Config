SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
AND SFRSTCR_RSTS_CODE = 'RE'
AND SGBSTDN_LEVL_CODE = 'GR'
AND SFRSTCR_GRDE_CODE IN ('D')

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI