SGBSTDN_MAJR_CODE_1 = 'EHS'
AND EXISTS (SELECT * FROM SFAREGS WHERE SFRSTCR_PIDM = SPRIDEN_PIDM AND SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE AND SFRSTCR_RSTS_CODE IN (SELECT STVRSTS_CODE FROM STVRSTS))