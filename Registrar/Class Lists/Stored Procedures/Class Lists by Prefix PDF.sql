('-All-' = :select_subj_code.SUBJ_CODE
       or ('-All-' <> :select_subj_code.SUBJ_CODE
          and SFRSTCR.SSBSECT_SUBJ_CODE = :select_subj_code.SUBJ_CODE))

ORDER BY
    SSBSECT_SUBJ_CODE,
    SSBSECT_SICAS_CAMP_COURSE_ID,
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME,
    SPRIDEN_SEARCH_MI