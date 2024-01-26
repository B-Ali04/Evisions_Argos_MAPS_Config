   ('-All-' = :select_subj_code.SUBJ_CODE
       or ('-All-' <> :select_subj_code.SUBJ_CODE
          and SFRSTCR.SSBSECT_SUBJ_CODE = :select_subj_code.SUBJ_CODE))
   and ('-All-' = :select_crse_numb.CRSE_NUMB
       or ('-All-' <> :select_crse_numb.CRSE_NUMB
          and SFRSTCR.SSBSECT_CRSE_NUMB = :select_crse_numb.CRSE_NUMB))

ORDER BY
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME,
    SPRIDEN_SEARCH_MI