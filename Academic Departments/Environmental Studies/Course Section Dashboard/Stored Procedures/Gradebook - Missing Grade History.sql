SFRSTCR_TERM_CODE <= :select_term_code.STVTERM_CODE
and(
    SFRSTCR_GRDE_CODE is null
    or SFRSTCR_GRDE_CODE in ('NR')
    or SHRTCKG_GRDE_CODE_FINAL is null
)


ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI
