ORDER BY
    SHRDGMR_DEGC_CODE,
    f_get_desc_FNC('STVMAJR', SHRDGMR.SHRDGMR_CODE_MAJR_CODE_1, 30),
    f_get_desc_FNC('STVMAJR', SHRDGMR.SHRDGMR_CODE_MAJR_CODE_MINR_1, 30),
    f_get_desc_FNC('STVMAJR', SHRDGMR.SHRDGMR_CODE_MAJR_CODE_MINR_2, 30),
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME