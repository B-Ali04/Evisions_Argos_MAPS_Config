GOREMAL_EMAL_CODE = 'SU'
AND SGBSTDN_MAJR_CODE_1 NOT IN ('SUS', 'EHS', 'VIS')
AND SGBSTDN_STST_CODE = 'AS'
AND (
    SGBSTDN_STYP_CODE ='C'
    OR (
       SGBSTDN_STYP_CODE ='T'
       AND 'Y' = f_registered_this_term(SPRIDEN_PIDM, STVTERM_CODE)))
AND EXISTS(SELECT *
           FROM    SGBSTDN STDN
           WHERE   STDN.SGBSTDN_PIDM = SPRIDEN_PIDM
           AND     STDN.SGBSTDN_TERM_CODE_EFF <= STVTERM_CODE
           AND     STDN.SGBSTDN_STST_CODE = 'AS'
           AND     STDN.SGBSTDN_STYP_CODE = 'T')

ORDER BY
    STVCLAS_SURROGATTE-ID,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI