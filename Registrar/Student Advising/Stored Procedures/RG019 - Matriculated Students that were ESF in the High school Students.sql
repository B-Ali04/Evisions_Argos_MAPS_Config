EXISTS(SELECT *
      FROM SGBSTDN SGBSTDN
      WHERE SGBSTDN.SGBSTDN_PIDM = SPRIDEN_PIDM
      AND SGBSTDN.SGBSTDN_TERM_CODE_EFF < FY_SGBSTDN_EFF_TERM(SPRIDEN_PIDM, :select_term_Code.STVTERM_CODE)
      AND SGBSTDN.SGBSTDN_MAJR_CODE_1 IN ('EHS')
      )

AND f_registered_this_term(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE) = 'Y'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI
