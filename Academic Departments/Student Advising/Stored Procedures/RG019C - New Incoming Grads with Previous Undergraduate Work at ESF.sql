SGBSTDN_STYP_CODE IN ('N')
AND EXISTS(SELECT *
          FROM    SGBSTDN SGBSTDN
          WHERE   SGBSTDN_PIDM = SPRIDEN_PIDM
          AND     SGBSTDN_TERM_CODE_EFF < :select_term_code.STVTERM_CODE
          AND     SGBSTDN_MAJR_CODE_1 NOT IN ('0000', 'EHS', 'SUS', 'VIS')
--          AND     SGBSTDN_STST_CODE = 'AS'
          AND     SGBSTDN_LEVL_CODE = 'UG'
          AND     SGBSTDN_COLL_CODE_1 = 'EF'
          AND     SGBSTDN_STYP_CODE NOT IN ('N')
    )

--AND f_registered_this_term(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE) = 'Y'