SFRSTCR.PREV_TERM_CODE != SFRSTCR.SFRSTCR_TERM_CODE
and SFRSTCR.SUBJ_CODE = SFRSTCR.SSBSECT_SUBJ_CODE
and SFRSTCR.CRSE_NUMB = SFRSTCR.SSBSECT_CRSE_NUMB
and PASSED_IND = 0
and COMPLETE_IND = 0

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI