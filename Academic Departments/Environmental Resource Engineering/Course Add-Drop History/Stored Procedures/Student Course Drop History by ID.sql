SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
and SFRSTCR.SFRSTCR_RSTS_CODE = 'DC'
and :search_UID is not null
and SPRIDEN_ID = :search_UID

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME
