SGBSTDN_MAJR_CODE_1 not in ('SUS','EHS')
AND EXISTS
(SELECT * FROM SFRSTCR
WHERE SPRIDEN_PIDM = SFRSTCR_PIDM
AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE = 'RE')
AND NOT EXISTS
(SELECT * FROM SFRSTCR
WHERE SPRIDEN_PIDM = SFRSTCR_PIDM
AND SFRSTCR_TERM_CODE = (SELECT MIN(STVTERM_CODE) FROM STVTERM WHERE STVTERM_CODE > :select_term_code.STVTERM_CODE AND (STVTERM_CODE LIKE '%%%%20' OR STVTERM_CODE LIKE '%%%%40'))
AND SFRSTCR_RSTS_CODE = 'RE')
AND SGBSTDN_STYP_CODE <> 'X'
AND NOT EXISTS(SELECT * FROM SHRDGMR WHERE SHRDGMR_PIDM = SPRIDEN_PIDM AND SHRDGMR_ACYR_CODE_BULLETIN = STVTERM_ACYR_CODE)

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI