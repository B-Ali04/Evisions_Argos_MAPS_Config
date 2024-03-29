EXISTS(
       SELECT *
       FROM    SAAADMS SARADAP
       WHERE   SARADAP.SARADAP_PIDM = SPRIDEN_PIDM
       AND     SARADAP.SARADAP_TERM_CODE_ENTRY = :select_term_code.STVTERM_CODE
)
AND RPRAWRD_SURROGATE_ID = (SELECT MAX(RPRAWRD_SURROGATE_ID)
                           FROM    RPRAWRD RPRA
                           WHERE   RPRA.RPRAWRD_PIDM = SPRIDEN_PIDM
                           AND   RPRA.RPRAWRD_AIDY_CODE = STVTERM_FA_PROC_YR)
ORDER BY
    SARADAP_STYP_CODE,
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI