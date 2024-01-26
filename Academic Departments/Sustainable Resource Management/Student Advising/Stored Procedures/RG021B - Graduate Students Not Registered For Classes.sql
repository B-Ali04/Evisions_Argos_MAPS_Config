NOT EXISTS(SELECT *
              FROM    SFRSTCR SFRSTCR
              WHERE   SFRSTCR_PIDM = SPRIDEN_PIDM
              AND     SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
              AND     SFRSTCR_RSTS_CODE IN ('RE','RW')
    )

AND SGBSTDN_LEVL_CODE = 'GR'
AND f_registered_this_term(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE) = 'Y'