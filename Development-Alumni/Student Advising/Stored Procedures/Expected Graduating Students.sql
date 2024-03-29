STVTERM_ACYR_CODE = (EXTRACT(YEAR FROM SGBSTDN_EXP_GRAD_DATE))
AND SGBSTDN_STYP_CODE <> 'X'
AND NOT EXISTS( SELECT *
                FROM   SHRDGMR DGMR
                WHERE  DGMR.SHRDGMR_PIDM = SPRIDEN_PIDM
                AND    (DGMR.SHRDGMR_ACYR_CODE_BULLETIN = STVTERM_ACYR_CODE
                       OR DGMR.SHRDGMR_ACYR_CODE = STVTERM_ACYR_CODE))
AND SGBSTDN_STST_CODE = 'AS'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI