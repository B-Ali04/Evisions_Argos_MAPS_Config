NOT EXISTS (SELECT * FROM rad_class_dtl@dgw13.dgw
            WHERE   SUBSTR(TRIM(RAD_COURSE_KEY), 1,3) = 'EFB'
            AND     SUBSTR(TRIM(RAD_COURSE_KEY), 13, 15) = 202
            --AND SGBSTDN_MAJR_CODE_1 in ('AFSC', 'ENBI', 'CONB', 'EEIN', 'FOHE', 'WLSC')
            AND     SPRIDEN_ID = SUBSTR(RAD_ID, 1, 9))
AND SFRSTCR_CRN = (SELECT MAX (SFRSTCR_CRN)
                  FROM        SFRSTCR STCR
                  WHERE       STCR.SFRSTCR_PIDM = SPRIDEN_PIDM
                  AND         STCR.SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
                  AND         STCR.SFRSTCR_RSTS_CODE = 'RE')
AND SGBSTDN_LEVL_CODE = 'UG'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI