EXISTS(SELECT *
      FROM SGRSATT
      WHERE SGRSATT_PIDM = SPRIDEN_PIDM
      AND SGRSATT_TERM_CODE_EFF <= :select_term_code.STVTERM_CODE
      AND SGRSATT_ATTS_CODE IN ('EOP')
      AND SGRSATT_END_TERM_ETHOS = 999999)
AND SGBSTDN_STST_CODE = 'AS'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI