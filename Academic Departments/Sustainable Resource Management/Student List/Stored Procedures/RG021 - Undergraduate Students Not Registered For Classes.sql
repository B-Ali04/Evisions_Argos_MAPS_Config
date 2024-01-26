NOT EXISTS(SELECT *
              FROM    SFRSTCR SFRSTCR
              WHERE   SFRSTCR_PIDM = SPRIDEN_PIDM
              AND     SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
              AND     SFRSTCR_RSTS_CODE IN ('RE','RW')
    )

AND SGBSTDN_LEVL_CODE = 'UG'
AND f_registered_this_term(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE) = 'Y'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI
