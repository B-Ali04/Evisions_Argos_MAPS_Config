SELECT
      F_FORMAT_NAME(SPRIDEN.SPRIDEN_PIDM, 'LF30') FULL_NAME,
      SARAPPD.SARAPPD_PIDM AS SARAPPD_PIDM,
      SARADAP.SARADAP_TERM_CODE_ENTRY AS SARADAP_ENTRY_TERM,
      SARADAP.SARADAP_APPL_NO AS SARARAP_APPL_NUMB,
      SARADAP.SARADAP_LEVL_CODE AS SARADAP_LEVL_CODE,
      SARAPPD1.SARAPPD_APDC_CODE AS PREVIOUS_DECISION,
      SARAPPD1.SARAPPD_APDC_DATE AS PREVIOUS_DATE,
      SARAPPD.SARAPPD_APDC_CODE AS NEW_DECICION_CODE,
      SARAPPD.SARAPPD_APDC_DATE AS NEW_DECICION_DATE

-- DATA SOURCES

FROM
      --ADMISSIONS DATA
      SARAPPD SARAPPD

      --APPLICATION DATA
      LEFT OUTER JOIN SARADAP SARADAP ON SARADAP.SARADAP_PIDM = SARAPPD.SARAPPD_PIDM
          AND SARADAP.SARADAP_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY

      LEFT OUTER JOIN SARAPPD SARAPPD1 ON SARAPPD1.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM
          AND SARAPPD1.SARAPPD_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY
          AND SARAPPD1.SARAPPD_APPL_NO = SARAPPD.SARAPPD_APPL_NO

      --IDENTIFICATION
      LEFT OUTER JOIN SPRIDEN SPRIDEN ON SPRIDEN.SPRIDEN_PIDM = SARAPPD.SARAPPD_PIDM
           AND SPRIDEN.SPRIDEN_NTYP_CODE IS NULL
           AND SPRIDEN.SPRIDEN_CHANGE_IND IS NULL

    LEFT OUTER JOIN SPRADDR SPRADDR ON SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
         AND SPRADDR.SPRADDR_STATUS_IND IS NULL
         AND SPRADDR.SPRADDR_VERSION = (SELECT MAX(SPRADDR_VERSION)
                                    FROM SPRADDR SPRADDRX
                                    WHERE SPRADDRX.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                    AND SPRADDRX.SPRADDR_STATUS_IND IS NULL)
        AND SPRADDR.SPRADDR_SURROGATE_ID = (SELECT MAX(SPRADDR_SURROGATE_ID)
                                    FROM SPRADDR SPRADDRX
                                    WHERE SPRADDRX.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                    AND SPRADDRX.SPRADDR_STATUS_IND IS NULL)

WHERE
     SARAPPD.SARAPPD_TERM_CODE_ENTRY = :parm_term_code_select.STVTERM_CODE
     AND SARAPPD1.SARAPPD_SEQ_NO IS NOT NULL
     AND SARAPPD1.SARAPPD_SEQ_NO = (SARAPPD.SARAPPD_SEQ_NO - 1)
     AND SARAPPD.SARAPPD_APDC_CODE in ('AP', 'AC')

ORDER BY SARAPPD.SARAPPD_APDC_DATE, FULL_NAME, SARAPPD.SARAPPD_SEQ_NO