SARAPPD.SARAPPD_APDC_CODE = :select_apdc_code.SAAADMS_APDC_CODE
and SGBSTDN.SGBSTDN_STYP_CODE = :select_styp_code.SGASTDN_STYP_CODE

ORDER BY
    SARADAP_STYP_CODE,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI