WITH SPAIDEN as
(
  SELECT
      SPRIDEN.SPRIDEN_PIDM,
      SPRIDEN.SPRIDEN_ID,
      SPRIDEN.SPRIDEN_LAST_NAME,
      SPRIDEN.SPRIDEN_FIRST_NAME,
      SPRIDEN.SPRIDEN_MI,
      SPRIDEN.SPRIDEN_CHANGE_IND,
      SPRIDEN.SPRIDEN_ENTITY_IND,
      SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME,
      SPRIDEN.SPRIDEN_SEARCH_MI,
      SPRIDEN.SPRIDEN_SURROGATE_ID,
      SPRIDEN.SPRIDEN_VERSION,
      f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME

  FROM
      SPRIDEN SPRIDEN

  WHERE
      SPRIDEN.SPRIDEN_NTYP_CODE is NULL
      AND SPRIDEN.SPRIDEN_CHANGE_IND is NULL
  ),

TUIADDR as
(
  SELECT
      SPRADDR.SPRADDR_PIDM,
      SPRADDR.SPRADDR_ATYP_CODE,
      SPRADDR.SPRADDR_SEQNO,
      SPRADDR.SPRADDR_FROM_DATE,
      SPRADDR.SPRADDR_TO_DATE,
      SPRADDR.SPRADDR_STREET_LINE1,
      SPRADDR.SPRADDR_STREET_LINE2,
      SPRADDR.SPRADDR_STREET_LINE3,
      SPRADDR.SPRADDR_CITY,
      SPRADDR.SPRADDR_STAT_CODE,
      SPRADDR.SPRADDR_ZIP,
      SPRADDR.SPRADDR_CNTY_CODE,
      f_get_desc_fnc('STVATYP', SPRADDR.SPRADDR_ATYP_CODE, 30) as SPRADDR_ATYP_DESC,
      f_get_desc_fnc('STVCNTY', SPRADDR.SPRADDR_CNTY_CODE, 30) as SPRADDR_CNTY_DESC

  FROM
      SPRADDR SPRADDR

  WHERE
      SPRADDR.SPRADDR_ATYP_CODE IN ('MA','PA','PR')
      AND SPRADDR.SPRADDR_STATUS_IND IS NULL
      AND SPRADDR.SPRADDR_VERSION = (SELECT MAX(SPRADDR_VERSION)
                                    FROM   SPRADDR ADDR
                                    WHERE  ADDR.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                    AND    ADDR.SPRADDR_ATYP_CODE IN ('MA','PA','PR')
                                    AND    ADDR.SPRADDR_STATUS_IND IS NULL)
      AND SPRADDR.SPRADDR_SURROGATE_ID = (SELECT MAX(SPRADDR_SURROGATE_ID)
                                         FROM    SPRADDR ADDR
                                         WHERE   ADDR.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                         AND     ADDR.SPRADDR_ATYP_CODE IN ('MA','PA','PR')
                                         AND     ADDR.SPRADDR_STATUS_IND IS NULL)
  ),

SPATELE as
(
  SELECT
      SPRTELE.SPRTELE_PIDM,
      SPRTELE.SPRTELE_TELE_CODE,
      SPRTELE.SPRTELE_PHONE_AREA,
      SPRTELE.SPRTELE_PHONE_NUMBER,
      SPRTELE.SPRTELE_SURROGATE_ID,
      SPRTELE.SPRTELE_VERSION,
      f_get_desc_fnc('STVTELE', SPRTELE.SPRTELE_TELE_CODE, 30) as SPRTELE_TELE_DESC

  FROM
      SPRTELE SPRTELE

  WHERE
      SPRTELE.SPRTELE_SURROGATE_ID = (SELECT MAX(SPRTELE_SURROGATE_ID)
                                     FROM    SPRTELE TELE
                                     WHERE   TELE.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
                                     AND     TELE.SPRTELE_STATUS_IND IS NULL)
  ),

SPAEMRG AS
(
  SELECT
      SPREMRG.SPREMRG_PIDM,
      SPREMRG.SPREMRG_PRIORITY,
      SPREMRG.SPREMRG_LAST_NAME,
      SPREMRG.SPREMRG_FIRST_NAME,
      SPREMRG.SPREMRG_MI,
      SPREMRG.SPREMRG_STREET_LINE1,
      SPREMRG.SPREMRG_STREET_LINE2,
      SPREMRG.SPREMRG_STREET_LINE3,
      SPREMRG.SPREMRG_CITY,
      SPREMRG.SPREMRG_STAT_CODE,
      SPREMRG.SPREMRG_NATN_CODE,
      SPREMRG.SPREMRG_ZIP,
      SPREMRG.SPREMRG_PHONE_AREA,
      SPREMRG.SPREMRG_PHONE_NUMBER,
      SPREMRG.SPREMRG_PHONE_EXT,
      SPREMRG.SPREMRG_RELT_CODE,
      SPREMRG.SPREMRG_ACTIVITY_DATE,
      SPREMRG.SPREMRG_ATYP_CODE,
      SPREMRG.SPREMRG_HOUSE_NUMBER,
      SPREMRG.SPREMRG_STREET_LINE4,
      SPREMRG.SPREMRG_SURROGATE_ID,
      SPREMRG.SPREMRG_VERSION,
      f_get_desc_fnc('STVRELT', SPREMRG.SPREMRG_RELT_CODE, 30) as SPREMRG_RELT_DESC

  FROM
      SPREMRG SPREMRG
  ),

SPAPERS as
(
  SELECT
      SPBPERS.SPBPERS_PIDM,
      SPBPERS.SPBPERS_SSN,
      SPBPERS.SPBPERS_BIRTH_DATE,
      SPBPERS.SPBPERS_SEX,
      SPBPERS.SPBPERS_CONFID_IND,
      SPBPERS.SPBPERS_PREF_FIRST_NAME,
      SPBPERS.SPBPERS_CITZ_CODE,
      SPBPERS.SPBPERS_ETHN_CDE,
      SPBPERS.SPBPERS_SURROGATE_ID,
      SPBPERS.SPBPERS_VERSION,
      SPBPERS.SPBPERS_GNDR_CODE,
      GOBINTL.GOBINTL_PIDM,
      GOBINTL.GOBINTL_SPOUSE_IND,
      GOBINTL.GOBINTL_SIGNATURE_IND,
      GOBINTL.GOBINTL_NATN_CODE_BIRTH,
      GOBINTL.GOBINTL_SURROGATE_ID,
      GOBINTL.GOBINTL_VERSION,
      CASE
        WHEN SPBPERS_ETHN_CDE IN (2,3,4,5,6,7,9,10) THEN 'Y'
          ELSE 'N'
            END AS SPBPERS_SICAS_HISP_ORIGIN,
      CASE
        WHEN SPBPERS.SPBPERS_CITZ_CODE = 'Y' THEN 'United States'
          ELSE (SELECT STVNATN_NATION
               FROM    STVNATN
               WHERE   STVNATN_CODE = NVL(GOBINTL.GOBINTL_NATN_CODE_LEGAL, GOBINTL.GOBINTL_NATN_CODE_BIRTH))
                 END AS SPBPERS_CITZ_COUNTRY,
      F_GET_DESC_FNC('STVETHN', SPBPERS_ETHN_CDE, 30) as SPBPERS_ETHN_DESC,
      F_GET_DESC_FNC('STVNATN', GOBINTL_NATN_CODE_BIRTH, 30) as GOBINTL_BIRTH_NATN,
      ROUND(((SYSDATE - SPBPERS_BIRTH_DATE)/365), 0) as SPBPERS_AGE

    FROM
        SPBPERS SPBPERS
        LEFT OUTER JOIN GOBINTL GOBINTL ON GOBINTL.GOBINTL_PIDM = SPBPERS.SPBPERS_PIDM
    ),

GOARACE as
(
  SELECT
      GORPRAC.GORPRAC_PIDM AS GORPRAC_PIDM,
      (LISTAGG(GORPRAC.GORPRAC_RACE_CDE,', ') WITHIN GROUP (ORDER BY GORPRAC.GORPRAC_RACE_CDE)) AS GORRACE_RACE_CDE,
      (LISTAGG(GORRACE.GORRACE_DESC,', ') WITHIN GROUP (ORDER BY GORRACE.GORRACE_DESC)) AS GORRACE_DESC

  FROM
      GORPRAC GORPRAC
      LEFT OUTER JOIN GORRACE GORRACE ON GORRACE.GORRACE_RACE_CDE = GORPRAC.GORPRAC_RACE_CDE

  GROUP BY
      GORPRAC.GORPRAC_PIDM
  ),

SOREMAL as
(
  SELECT
      GOREMAL.GOREMAL_PIDM,
      GOREMAL.GOREMAL_EMAL_CODE,
      GOREMAL.GOREMAL_EMAIL_ADDRESS,
      GOREMAL.GOREMAL_STATUS_IND,
      GOREMAL.GOREMAL_PREFERRED_IND,
      GOREMAL.GOREMAL_ACTIVITY_DATE,
      GOREMAL.GOREMAL_SURROGATE_ID,
      GOREMAL.GOREMAL_VERSION,
      GORADID.GORADID_PIDM,
      GORADID.GORADID_ADDITIONAL_ID,
      GORADID.GORADID_ADID_CODE,
      GORADID.GORADID_SURROGATE_ID,
      GORADID.GORADID_VERSION,
      GOBTPAC.GOBTPAC_PIDM,
      GOBTPAC.GOBTPAC_PIN_DISABLED_IND,
      GOBTPAC.GOBTPAC_USAGE_ACCEPT_IND,
      GOBTPAC.GOBTPAC_PIN,
      GOBTPAC.GOBTPAC_PIN_EXP_DATE,
      GOBTPAC.GOBTPAC_SURROGATE_ID,
      GOBTPAC.GOBTPAC_VERSION,
      GOBTPAC.GOBTPAC_EXTERNAL_USER --esfid

  FROM
      GOREMAL GOREMAL
      LEFT OUTER JOIN GORADID GORADID ON GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
           AND GORADID.GORADID_ADID_CODE = 'SUID'
      LEFT OUTER JOIN GOBUMAP GOBUMAP ON GOBUMAP.GOBUMAP_PIDM = GOREMAL.GOREMAL_PIDM
      LEFT OUTER JOIN GOBTPAC GOBTPAC ON GOBTPAC.GOBTPAC_PIDM = GOREMAL.GOREMAL_PIDM

  WHERE
      GOREMAL.GOREMAL_STATUS_IND = 'A'
      AND GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
      AND GOREMAL.GOREMAL_EMAL_CODE IN ('ESF', 'SU', 'AD', 'PERS')
  ),

SGASTDN as
(
  SELECT
      SGBSTDN.SGBSTDN_PIDM,
      SGBSTDN.SGBSTDN_TERM_CODE_EFF,
      SGBSTDN.SGBSTDN_STST_CODE,
      SGBSTDN.SGBSTDN_LEVL_CODE,
      SGBSTDN.SGBSTDN_STYP_CODE,
      SGBSTDN.SGBSTDN_TERM_CODE_MATRIC,
      SGBSTDN.SGBSTDN_TERM_CODE_ADMIT,
      SGBSTDN.SGBSTDN_EXP_GRAD_DATE,
      SGBSTDN.SGBSTDN_CAMP_CODE,
      SGBSTDN.SGBSTDN_COLL_CODE_1,
      SGBSTDN.SGBSTDN_DEGC_CODE_1,
      SGBSTDN.SGBSTDN_MAJR_CODE_1,
      SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1,
      SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2,
      SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1,
      SGBSTDN.SGBSTDN_RESD_CODE,
      SGBSTDN.SGBSTDN_ADMT_CODE,
      SGBSTDN.SGBSTDN_DEPT_CODE,
      SGBSTDN.SGBSTDN_PROGRAM_1,
      SGBSTDN.SGBSTDN_TERM_CODE_GRAD,
      SGBSTDN.SGBSTDN_ACTIVITY_DATE,
      SFRTHST.SFRTHST_PIDM,
      SFRTHST.SFRTHST_TERM_CODE,
      SFRTHST.SFRTHST_TMST_CODE,
      SFRTHST.SFRTHST_TMST_DATE,
      SFRTHST.SFRTHST_SURROGATE_ID,
      SFRTHST.SFRTHST_VERSION,
      CASE
        WHEN SFRTHST_TMST_CODE IS NULL THEN NULL
          ELSE f_Get_desc_fnc('STVTMST', SFRTHST.SFRTHST_TMST_CODE, 30)
            END as SFRTHST_TMST_DESC,
      f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE) as SGBSTDN_CLAS_CODE,
      f_get_desc_fnc('STVTERM',SGBSTDN.SGBSTDN_TERM_CODE_EFF, 30) as SGBSTDN_TERM_EFF_DESC,
      f_get_desc_fnc('STVSTST',SGBSTDN.SGBSTDN_STST_CODE, 30) as SGBSTDN_STST_DESC,
      f_get_desc_fnc('STVLEVL', SGBSTDN.SGBSTDN_LEVL_CODE, 30) as SGBSTDN_LEVL_DESC,
      f_get_desc_fnc('STVSTYP', SGBSTDN.SGBSTDN_STYP_CODE, 30) as SGBSTDN_STYP_DESC,
      f_get_desc_fnc('STVDEGC', SGBSTDN.SGBSTDN_DEGC_CODE_1, 30) as SGBSTDN_DEGC_DESC,
      f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as SGBSTDN_MAJR_DESC,
      f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1, 30) as SGBSTDN_MINR_1_DESC,
      f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2, 30) as SGBSTDN_MINR_1_2_DESC,
      f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1, 30) as SGBSTDN_CONC_DESC,
      f_get_desc_fnc('STVRESD', SGBSTDN.SGBSTDN_RESD_CODE, 30) as SGBSTDN_RESD_DESC,
      f_get_desc_fnc('STVADMT', SGBSTDN.SGBSTDN_ADMT_CODE, 30) as SGBSTDN_ADMT_DESC,
      f_get_desc_fnc('STVDEPT', SGBSTDN.SGBSTDN_DEPT_CODE, 30) as SGBSTDN_DEPT_DESC,
      f_get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_MATRIC, 30) as SGBSTDN_MATRIC_TERM_DESC,
      f_get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_GRAD, 30) as SGBSTDN_GRAD_TERM_DESC,
      f_get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE), 30) as SGBSTDN_CLAS_DESC

  FROM
      SGBSTDN SGBSTDN
      LEFT OUTER JOIN SFRTHST SFRTHST ON SFRTHST.SFRTHST_PIDM = SGBSTDN.SGBSTDN_PIDM
           AND SFRTHST_SURROGATE_ID = (SELECT MAX(SFRTHST_SURROGATE_ID)
                                      FROM   SFRTHST TMST
                                      WHERE  TMST.SFRTHST_PIDM = SGBSTDN.SGBSTDN_PIDM
                                      AND    TMST.SFRTHST_TERM_CODE = SGBSTDN.SGBSTDN_TERM_CODE_EFF)
  ),

SHADEGR as
(
  SELECT
      SHRDGMR.SHRDGMR_PIDM,
      SHRDGMR.SHRDGMR_SEQ_NO,
      SHRDGMR.SHRDGMR_DEGC_CODE,
      SHRDGMR.SHRDGMR_DEGS_CODE,
      SHRDGMR.SHRDGMR_LEVL_CODE,
      SHRDGMR.SHRDGMR_COLL_CODE_1,
      SHRDGMR.SHRDGMR_MAJR_CODE_1,
      SHRDGMR.SHRDGMR_MAJR_CODE_MINR_1,
      SHRDGMR.SHRDGMR_MAJR_CODE_CONC_1,
      SHRDGMR.SHRDGMR_APPL_DATE,
      SHRDGMR.SHRDGMR_GRAD_DATE,
      SHRDGMR.SHRDGMR_ACYR_CODE_BULLETIN,
      SHRDGMR.SHRDGMR_CAMP_CODE,
      SHRDGMR.SHRDGMR_TERM_CODE_GRAD,
      SHRDGMR.SHRDGMR_ACYR_CODE,
      SHRDGMR.SHRDGMR_TERM_CODE_STUREC,
      SHRDGMR.SHRDGMR_ACTIVITY_DATE,
      SHRDGMR.SHRDGMR_GRST_CODE,
      SHRDGMR.SHRDGMR_TERM_CODE_COMPLETED,
      SHRDGMR.SHRDGMR_DEPT_CODE,
      SHRDGMR.SHRDGMR_PROGRAM,
      SHRDGMR.SHRDGMR_SURROGATE_ID,
      SHRDGMR.SHRDGMR_VERSION,
      SHRDGIH.SHRDGIH_PIDM,
      SHRDGIH.SHRDGIH_DGMR_SEQ_NO,
      SHRDGIH.SHRDGIH_HONR_CODE,
      SHRDGIH.SHRDGIH_ACTIVITY_DATE,
      SHRDGIH.SHRDGIH_TRANSC_PRT_IND,
      SHRDGIH.SHRDGIH_COMMENCE_PRT_IND,
      SHRDGIH.SHRDGIH_EDI_DEFAULT,
      SHRDGIH.SHRDGIH_SURROGATE_ID,
      SHRDGIH.SHRDGIH_VERSION,
      CASE
        WHEN SHRDGIH.SHRDGIH_HONR_CODE IS NULL THEN NULL
          ELSE f_get_desc_fnc('STVHONR', SHRDGIH.SHRDGIH_HONR_CODE, 30)
            END as SHRDGIH_HONR_DESC,
      f_get_desc_fnc('STVDEGS', SHRDGMR.SHRDGMR_DEGS_CODE, 30) as SHRDGMR_DEGS_DESC,
      f_get_desc_fnc('STVDEGC', SHRDGMR.SHRDGMR_DEGC_CODE, 30) as SHRDGMR_DEGC_DESC,
      f_get_desc_fnc('STVLEVL', SHRDGMR.SHRDGMR_LEVL_CODE, 30) as SHRDGMR_LEVL_DESC,
      f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_MAJR_CODE_1, 30) as SHRDGMR_MAJR_DESC,
      f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_COLL_CODE_1, 30) as SHRDGMR_COLL_DESC,
      f_get_desc_fnc('STVGRST', SHRDGMR.SHRDGMR_GRST_CODE, 30) as SHRDGMR_GRST_DESC

  FROM
      SHRDGMR SHRDGMR
      LEFT OUTER JOIN SHRDGIH SHRDGIH ON SHRDGIH.SHRDGIH_PIDM = SHRDGMR.SHRDGMR_PIDM
           AND SHRDGIH.SHRDGIH_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO

  WHERE
      SHRDGMR.SHRDGMR_TERM_CODE_GRAD = (SELECT MAX(SHRDGMR_TERM_CODE_GRAD)
                                       FROM    SHRDGMR DGMR
                                       WHERE   DGMR.SHRDGMR_PIDM = SHRDGMR.SHRDGMR_PIDM
                                       AND     DGMR.SHRDGMR_GRAD_DATE >= :select_start_date
                                       AND     DGMR.SHRDGMR_GRAD_DATE <= :select_end_date)
  ),

SFAWDRL as
(
  SELECT
      SFRWDRL.SFRWDRL_PIDM,
      SFRWDRL.SFRWDRL_TERM_CODE,
      SFRWDRL.SFRWDRL_SEQ_NO,
      SFRWDRL.SFRWDRL_WDRL_CODE,
      SFRWDRL.SFRWDRL_EFF_WDRL_DATE,
      SFRWDRL.SFRWDRL_ESTS_CODE,
      SFRWDRL.SFRWDRL_ESTS_DATE,
      SFRWDRL.SFRWDRL_TIV_IND,
      SFRWDRL.SFRWDRL_PROCESSED_IND,
      SFRWDRL.SFRWDRL_ENRL_START_DATE,
      SFRWDRL.SFRWDRL_ENRL_END_DATE,
      SFRWDRL.SFRWDRL_ENRL_DAYS,
      SFRWDRL.SFRWDRL_ATTEND_DAYS,
      SFRWDRL.SFRWDRL_PERCENT_ATTEND,
      SFRWDRL.SFRWDRL_ORIGINAL_CHARGES,
      SFRWDRL.SFRWDRL_ACTIVITY_DATE,
      SFRWDRL.SFRWDRL_SURROGATE_ID,
      SFRWDRL.SFRWDRL_VERSION,
      f_get_desc_fnc('STVESTS', SFRWDRL.SFRWDRL_ESTS_CODE, 30) as SFRWDRL_ESTS_DESC

  FROM
      SFRWDRL SFRWDRL

  WHERE
      SFRWDRL.SFRWDRL_TERM_CODE = (SELECT MAX(SFRWDRL_TERM_CODE)
                                  FROM    SFRWDRL WDRL
                                  WHERE   WDRL.SFRWDRL_PIDM = SFRWDRL_PIDM
                                  AND     WDRL.SFRWDRL_EFF_WDRL_DATE >= :select_start_date
                                  AND     WDRL.SFRWDRL_EFF_WDRL_DATE <= :select_end_date)
  ),

SAAADMS as
(
  SELECT
        SARADAP.SARADAP_PIDM,
        SARADAP.SARADAP_TERM_CODE_ENTRY,
        SARADAP.SARADAP_APPL_NO,
        SARADAP.SARADAP_LEVL_CODE,
        SARADAP.SARADAP_APPL_DATE,
        SARADAP.SARADAP_APST_CODE,
        SARADAP.SARADAP_APST_DATE,
        SARADAP.SARADAP_MAINT_IND,
        SARADAP.SARADAP_ADMT_CODE,
        SARADAP.SARADAP_STYP_CODE,
        SARADAP.SARADAP_CAMP_CODE,
        SARADAP.SARADAP_COLL_CODE_1,
        SARADAP.SARADAP_DEGC_CODE_1,
        SARADAP.SARADAP_MAJR_CODE_1,
        SARADAP.SARADAP_RESD_CODE,
        SARADAP.SARADAP_ACTIVITY_DATE,
        SARADAP.SARADAP_DEPT_CODE,
        SARADAP.SARADAP_PROGRAM_1,
        SARADAP.SARADAP_TERM_CODE_CTLG_1,
        SARADAP.SARADAP_WEB_TRANS_NO,
        SARADAP.SARADAP_WEB_AMOUNT,
        SARADAP.SARADAP_WEB_RECEIPT_NUMBER,
        SARADAP.SARADAP_SURROGATE_ID,
        SARADAP.SARADAP_VERSION,
        SARAPPD.SARAPPD_PIDM,
        SARAPPD.SARAPPD_TERM_CODE_ENTRY,
        SARAPPD.SARAPPD_APPL_NO,
        SARAPPD.SARAPPD_SEQ_NO,
        SARAPPD.SARAPPD_APDC_DATE,
        SARAPPD.SARAPPD_APDC_CODE,
        SARAPPD.SARAPPD_MAINT_IND,
        SARAPPD.SARAPPD_ACTIVITY_DATE,
        SARAPPD.SARAPPD_USER,
        SARAPPD.SARAPPD_DATA_ORIGIN,
        SARAPPD.SARAPPD_SURROGATE_ID,
        SARAPPD.SARAPPD_VERSION,
        SARAPPD.SARAPPD_USER_ID,
        SARAPPD.SARAPPD_VPDI_CODE,
        SARAPPD.SARAPPD_GUID,
        SARAPPD.SARAPPD_DFE_ADMN_DECN_GUID,
        f_get_desc_fnc('STVLEVL', SARADAP.SARADAP_LEVL_CODE, 30) as SARADAP_LEVL_DESC,
        f_get_desc_fnc('STVAPST', SARADAP.SARADAP_APST_CODE, 30) as SARADAP_APST_DESC,
        f_get_desc_fnc('STVADMT', SARADAP.SARADAP_ADMT_CODE, 30) as SARADAP_ADMT_DESC,
        f_get_desc_fnc('STVAPST', SARADAP.SARADAP_STYP_CODE, 30) as SARADAP_STYP_DESC,
        f_get_desc_fnc('STVCAMP', SARADAP.SARADAP_CAMP_CODE, 30) as SARADAP_CAMP_DESC,
        f_get_desc_fnc('STVAPST', SARADAP.SARADAP_COLL_CODE_1, 30) as SARADAP_COLL_DESC,
        f_get_desc_fnc('STVDEGC', SARADAP.SARADAP_DEGC_CODE_1, 30) as SARADAP_DEGC_DESC,
        f_get_desc_fnc('STVMAJR', SARADAP.SARADAP_MAJR_CODE_1, 30) as SARADAP_MAJR_DESC,
        f_get_desc_fnc('STVRESD', SARADAP.SARADAP_RESD_CODE, 30) as SARADAP_RESD_DESC,
        f_get_desc_fnc('STVDEPT', SARADAP.SARADAP_DEPT_CODE, 30) as SARADAP_DEPT_DESC,
        f_get_desc_fnc('STVAPDC', SARAPPD.SARAPPD_APDC_CODE, 30) as SARAPPD_APDC_DESC

    FROM
        SARADAP SARADAP
        LEFT OUTER JOIN SARAPPD SARAPPD ON SARAPPD.SARAPPD_PIDM = SARADAP.SARADAP_PIDM
             AND SARAPPD.SARAPPD_TERM_CODE_ENTRY = SARADAP.SARADAP_TERM_CODE_ENTRY
             AND SARAPPD.SARAPPD_APPL_NO = SARADAP.SARADAP_APPL_NO

    WHERE
        SARADAP.SARADAP_APPL_NO = (SELECT MAX(SARADAP_APPL_NO)
                                  FROM    SARADAP ADAP
                                  WHERE   ADAP.SARADAP_PIDM = SARADAP.SARADAP_PIDM)
        AND SARAPPD.SARAPPD_SEQ_NO = (SELECT MAX(SARAPPD_SEQ_NO)
                                     FROM    SARAPPD APPD
                                     WHERE   APPD.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM
                                     AND     APPD.SARAPPD_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY
                                     AND     APPD.SARAPPD_APPL_NO = SARAPPD.SARAPPD_APPL_NO)
        AND SARAPPD.SARAPPD_APPL_NO = (SELECT MAX(SARAPPD_APPL_NO)
                                      FROM    SARAPPD APPD
                                      WHERE   APPD.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM
                                      AND     APPD.SARAPPD_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY
                                      AND     APPD.SARAPPD_APPL_NO = SARAPPD.SARAPPD_APPL_NO)
    ),

SOAPCOL as
(
    SELECT
        SORPCOL.SORPCOL_PIDM,
        SORPCOL.SORPCOL_SBGI_CODE,
        SORPCOL.SORPCOL_TRANS_RECV_DATE,
        SORPCOL.SORPCOL_TRANS_REV_DATE,
        SORPCOL.SORPCOL_OFFICIAL_TRANS,
        SORPCOL.SORPCOL_ADMR_CODE,
        SORPCOL.SORPCOL_ACTIVITY_DATE,
        SORPCOL.SORPCOL_DATA_ORIGIN,
        SORPCOL.SORPCOL_USER_ID,
        SORPCOL.SORPCOL_SURROGATE_ID,
        SORPCOL.SORPCOL_VERSION,
        SORPCOL.SORPCOL_VPDI_CODE,
        SORPCOL.SORPCOL_GUID,
        SORPCOL.SORPCOL_GPA,
        SORPCOL.SORPCOL_TOTAL_CREDITS,
        SORDEGR.SORDEGR_PIDM,
        SORDEGR.SORDEGR_SBGI_CODE,
        SORDEGR.SORDEGR_DEGC_CODE,
        SORDEGR.SORDEGR_DEGR_SEQ_NO,
        SORDEGR.SORDEGR_ATTEND_FROM,
        SORDEGR.SORDEGR_ATTEND_TO,
        SORDEGR.SORDEGR_HOURS_TRANSFERRED,
        SORDEGR.SORDEGR_GPA_TRANSFERRED,
        SORDEGR.SORDEGR_DEGC_DATE,
        SORDEGR.SORDEGR_ACTIVITY_DATE,
        SORDEGR.SORDEGR_PRIMARY_IND,
        SORDEGR.SORDEGR_SURROGATE_ID,
        SORDEGR.SORDEGR_VERSION,
        CASE
          WHEN SORPCOL.SORPCOL_ADMR_CODE IS NULL THEN ''
            ELSE F_GET_DESC_FNC('STVADMR', SORPCOL.SORPCOL_ADMR_CODE, 30)
              END as SORPCOL_ADMR_DESC,
        f_get_desc_fnc('STVSBGI', SORPCOL.SORPCOL_SBGI_CODE, 30) as SORPCOL_SGBI_DESC,
        f_get_desc_fnc('STVSBGI', SORDEGR.SORDEGR_SBGI_CODE, 30) as SORDEGR_SGBI_DESC

    FROM
        SORPCOL SORPCOL
        LEFT OUTER JOIN SORDEGR SORDEGR ON SORDEGR.SORDEGR_PIDM = SORPCOL.SORPCOL_PIDM
             AND SORDEGR.SORDEGR_SBGI_CODE = SORPCOL.SORPCOL_SBGI_CODE

    WHERE
        SORPCOL.SORPCOL_VERSION = (SELECT MAX(SORPCOL_VERSION)
                                  FROM    SORPCOL PCOL
                                  WHERE   PCOL.SORPCOL_PIDM = SORPCOL.SORPCOL_PIDM)
    ),

SGAADVR as
(
  SELECT
      SGRADVR.SGRADVR_PIDM,
      SGRADVR.SGRADVR_TERM_CODE_EFF,
      SGRADVR.SGRADVR_ADVR_PIDM,
      SGRADVR.SGRADVR_ADVR_CODE,
      SGRADVR.SGRADVR_PRIM_IND,
      SGRADVR.SGRADVR_ACTIVITY_DATE,
      SGRADVR.SGRADVR_SURROGATE_ID,
      CASE
        WHEN SGRADVR_ADVR_PIDM IS NULL THEN NULL
          ELSE f_format_name(SGRADVR.SGRADVR_ADVR_PIDM, 'LF30')
            END as SGRADVR_ADVR_NAME,
      CASE
        WHEN SGRADVR.SGRADVR_PIDM IS NULL THEN NULL
          ELSE f_format_name(SGRADVR.SGRADVR_PIDM, 'LF30')
            END as SGRADVR_NAME,
      CASE
        WHEN SGRADVR_ADVR_CODE IS NULL THEN NULL
          ELSE f_get_desc_fnc('STVADVR', SGRADVR_ADVR_CODE, 30)
            END as SGRADVR_ADVR_DESC

  FROM
      SGRADVR SGRADVR

  WHERE
      SGRADVR.SGRADVR_PRIM_IND = 'Y'
      AND SGRADVR.SGRADVR_TERM_CODE_EFF = (SELECT MAX(SGRADVR_TERM_CODE_EFF)
                                          FROM    SGRADVR ADVR
                                          WHERE   ADVR.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
                                          AND     ADVR.SGRADVR_PRIM_IND = 'Y')
      AND SGRADVR.SGRADVR_SURROGATE_ID = (SELECT MAX(SGRADVR_SURROGATE_ID)
                                         FROM    SGRADVR ADVR
                                         WHERE   ADVR.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
                                         AND     ADVR.SGRADVR_TERM_CODE_EFF = SGRADVR.SGRADVR_TERM_CODE_EFF
                                         AND     ADVR.SGRADVR_PRIM_IND = 'Y')
  ),

SHATERM as
(
  SELECT
      SHRTTRM.SHRTTRM_PIDM,
      SHRTTRM.SHRTTRM_TERM_CODE,
      SHRTTRM.SHRTTRM_UPDATE_SOURCE_IND,
      SHRTTRM.SHRTTRM_PRE_CATALOG_IND,
      SHRTTRM.SHRTTRM_RECORD_STATUS_IND,
      SHRTTRM.SHRTTRM_RECORD_STATUS_DATE,
      SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM,
      SHRTTRM.SHRTTRM_ASTD_DATE_END_OF_TERM,
      SHRTTRM.SHRTTRM_ACTIVITY_DATE,
      SHRTTRM.SHRTTRM_ASTD_CODE_DL,
      SHRTTRM.SHRTTRM_ASTD_DATE_DL,
      SHRTTRM.SHRTTRM_WRSN_CODE,
      SHRTTRM.SHRTTRM_SURROGATE_ID,
      SHRTTRM.SHRTTRM_VERSION,
      CASE
        WHEN SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM IS NULL THEN NULL
          ELSE f_get_desc_fnc('STVASTD', SHRTTRM.SHRTTRM_ASTD_CODE_END_OF_TERM, 30)
            END as SHRTTRM_ASTD_DESC_END_OF_TERM,
      CASE
        WHEN SHRTTRM.SHRTTRM_ASTD_CODE_DL IS NULL THEN NULL
          ELSE f_get_desc_fnc('STVASTD', SHRTTRM.SHRTTRM_ASTD_CODE_DL, 30)
            END as SHRTTRM_ASTD_DESC_DL,
      CASE
        WHEN SHRTTRM.SHRTTRM_WRSN_CODE IS NULL THEN NULL
          ELSE f_get_desc_fnc('STVWRSN', SHRTTRM.SHRTTRM_WRSN_CODE, 30)
            END as SHRTTRM_WRSN_DESC

  FROM
      SHRTTRM SHRTTRM

  WHERE
      SHRTTRM.SHRTTRM_TERM_CODE = (SELECT MAX(SHRTTRM_TERM_CODE)
                                  FROM    SHRTTRM TTRM
                                  WHERE   TTRM.SHRTTRM_PIDM = SHRTTRM.SHRTTRM_PIDM
                                  AND     TTRM.SHRTTRM_ASTD_DATE_END_OF_TERM >= :select_start_date
                                  AND     TTRM.SHRTTRM_ASTD_DATE_END_OF_TERM <= :select_end_date)
  ),

SHAGPAR as
(
  SELECT
      SHRTGPA.SHRTGPA_PIDM,
      SHRTGPA.SHRTGPA_LEVL_CODE,
      SHRTGPA.SHRTGPA_GPA_TYPE_IND,
      SHRTGPA.SHRTGPA_TERM_CODE,
      SHRTGPA.SHRTGPA_HOURS_ATTEMPTED,
      SHRTGPA.SHRTGPA_HOURS_EARNED,
      SHRTGPA.SHRTGPA_GPA_HOURS,
      SHRTGPA.SHRTGPA_QUALITY_POINTS,
      SHRTGPA.SHRTGPA_HOURS_PASSED,
      SHRTGPA.SHRTGPA_SURROGATE_ID,
      SHRLGPA.SHRLGPA_PIDM,
      SHRLGPA.SHRLGPA_LEVL_CODE,
      SHRLGPA.SHRLGPA_GPA_TYPE_IND,
      SHRLGPA.SHRLGPA_HOURS_ATTEMPTED,
      SHRLGPA.SHRLGPA_HOURS_EARNED,
      SHRLGPA.SHRLGPA_GPA_HOURS,
      SHRLGPA.SHRLGPA_QUALITY_POINTS,
      SHRLGPA.SHRLGPA_SURROGATE_ID,
      trunc(SHRTGPA.SHRTGPA_GPA,3) as SHRTGPA_GPA,
      trunc(SHRLGPA.SHRLGPA_GPA,3) as SHRLGPA_GPA

  FROM
      SHRTGPA SHRTGPA

      LEFT OUTER JOIN SHRLGPA SHRLGPA ON SHRLGPA.SHRLGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
           AND SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
           AND SHRLGPA.SHRLGPA_LEVL_CODE = SHRTGPA.SHRTGPA_LEVL_CODE

  WHERE
      SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'
      AND SHRTGPA.SHRTGPA_TERM_CODE = (SELECT MAX(SHRTGPA_TERM_CODE)
                                      FROM    SHRTGPA TGPA
                                      WHERE   TGPA.SHRTGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
                                      AND     TGPA.SHRTGPA_GPA_TYPE_IND  = SHRTGPA.SHRTGPA_GPA_TYPE_IND
                                      AND     TGPA.SHRTGPA_LEVL_CODE = SHRTGPA.SHRTGPA_LEVL_CODE
                                      AND     TGPA.SHRTGPA_GPA IS NOT NULL)
  ),

PERSONS_LIST_DEMO as
(
  SELECT
      CASE
        WHEN SPBPERS_SEX IS NULL THEN 0
          ELSE 1
            END as SEX_Measure,
      CASE
        WHEN GORRACE_RACE_CDE IS NULL THEN 0
          ELSE 1
            END as RACE_Measure,
      CASE
        WHEN SPBPERS_ETHN_CDE IS NULL THEN 0
          ELSE 1
            END as ETHN_Measure,
      SPRIDEN_PIDM,
      SPRIDEN_ID,
      SPRIDEN_LAST_NAME,
      SPRIDEN_FIRST_NAME,
      SPRIDEN_MI,
      SPRIDEN_LEGAL_NAME,
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME,
      SPRIDEN_SEARCH_MI,
      SPBPERS_PREF_FIRST_NAME,
      SPBPERS_AGE,
      SPBPERS_SEX,
      GORRACE_RACE_CDE,
      GORRACE_DESC,
      SPBPERS_ETHN_CDE,
      SPBPERS_ETHN_DESC,
      SPBPERS_SICAS_HISP_ORIGIN,
      SPBPERS_CITZ_CODE,
      SPBPERS_CITZ_COUNTRY,
      GOBINTL_NATN_CODE_BIRTH,
      GOBINTL_BIRTH_NATN,
      GOBTPAC_EXTERNAL_USER,
      GORADID_ADDITIONAL_ID,
      GOREMAL_EMAIL_ADDRESS,
      GOREMAL_EMAL_CODE

  FROM
      SPAIDEN SPRIDEN

      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
  ),

PERSONS_ADRTELE as
(
  SELECT
      SPRIDEN_PIDM,
      SPRIDEN_ID,
      SPRIDEN_LAST_NAME,
      SPRIDEN_FIRST_NAME,
      SPRIDEN_MI,
      SPRIDEN_LEGAL_NAME,
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME,
      SPRIDEN_SEARCH_MI,
      SPBPERS_PREF_FIRST_NAME,
      SPBPERS_AGE,
      SPBPERS_SEX,
      GORRACE_RACE_CDE,
      GORRACE_DESC,
      SPBPERS_ETHN_CDE,
      SPBPERS_ETHN_DESC,
      SPBPERS_SICAS_HISP_ORIGIN,
      SPBPERS_CITZ_CODE,
      SPBPERS_CITZ_COUNTRY,
      GOBINTL_NATN_CODE_BIRTH,
      GOBINTL_BIRTH_NATN,
      GOBTPAC_EXTERNAL_USER,
      GORADID_ADDITIONAL_ID,
      GOREMAL_EMAIL_ADDRESS,
      GOREMAL_EMAL_CODE,
      SPRADDR_PIDM,
      SPRADDR_ATYP_CODE,
      SPRADDR_ATYP_DESC,
      SPRADDR_FROM_DATE,
      SPRADDR_TO_DATE,
      SPRADDR_STREET_LINE1,
      SPRADDR_STREET_LINE2,
      SPRADDR_STREET_LINE3,
      SPRADDR_CITY,
      SPRADDR_STAT_CODE,
      SPRADDR_ZIP,
      SPRTELE_PIDM,
      SPRTELE_TELE_CODE,
      SPRTELE_TELE_DESC,
      SPRTELE_PHONE_AREA,
      SPRTELE_PHONE_NUMBER,
      SPREMRG_PIDM,
      SPREMRG_LAST_NAME,
      SPREMRG_FIRST_NAME,
      SPREMRG_MI,
      SPREMRG_RELT_CODE,
      SPREMRG_RELT_DESC,
      SPREMRG_PRIORITY,
      SPREMRG_STREET_LINE1,
      SPREMRG_STREET_LINE2,
      SPREMRG_STREET_LINE3,
      SPREMRG_CITY,
      SPREMRG_STAT_CODE,
      SPREMRG_NATN_CODE,
      SPREMRG_ZIP,
      SPREMRG_PHONE_AREA,
      SPREMRG_PHONE_NUMBER,
      SPREMRG_PHONE_EXT,
      SPREMRG_ACTIVITY_DATE,
      SPREMRG_ATYP_CODE,
      SPREMRG_HOUSE_NUMBER

  FROM
      PERSONS_LIST_DEMO A

      LEFT OUTER JOIN TUIADDR SPRADDR ON SPRADDR.SPRADDR_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPATELE SPRTELE ON SPRTELE.SPRTELE_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPAEMRG SPREMRG ON SPREMRG.SPREMRG_PIDM = SPRIDEN_PIDM

  WHERE
      (SPREMRG_PRIORITY <= 1 OR SPREMRG_PRIORITY IS NULL)
  ),

GRADUATED_LIST_DEMO as
(
  SELECT
      CASE
        WHEN SPBPERS_SEX IS NULL THEN 0
          ELSE 1
            END as SEX_Measure,
      CASE
        WHEN GORRACE_RACE_CDE IS NULL THEN 0
          ELSE 1
            END as RACE_Measure,
      CASE
        WHEN SPBPERS_ETHN_CDE IS NULL THEN 0
          ELSE 1
            END as ETHN_Measure,
     CASE
        WHEN SHRDGMR_DEPT_CODE IS NULL THEN 0
          ELSE 1
            END as DEPT_Measure,
     CASE
        WHEN SHRDGMR_MAJR_CODE_1 IS NULL THEN 0
          ELSE 1
            END as POS_Measure,
      CASE
        WHEN SHRDGMR_DEGC_CODE IS NULL THEN 0
          ELSE 1
            END as DEGC_Measure,
      CASE
        WHEN SHRDGMR_DEGS_CODE IS NULL THEN 0
          ELSE 1
            END as DEGS_Measure,
      CASE
        WHEN SHRDGMR_LEVL_CODE IS NULL THEN 0
          ELSE 1
            END as LEVL_Measure,
      CASE
        WHEN SHRDGMR_ACYR_CODE IS NULL THEN 0
          ELSE 1
            END as ACYR_Measure,
      SPRIDEN_PIDM,
      SPRIDEN_ID,
      SPRIDEN_LAST_NAME,
      SPRIDEN_FIRST_NAME,
      SPRIDEN_MI,
      SPRIDEN_LEGAL_NAME,
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME,
      SPRIDEN_SEARCH_MI,
      SPBPERS_PREF_FIRST_NAME,
      SPBPERS_AGE,
      SPBPERS_SEX,
      GORRACE_RACE_CDE,
      GORRACE_DESC,
      SPBPERS_ETHN_CDE,
      SPBPERS_ETHN_DESC,
      SPBPERS_SICAS_HISP_ORIGIN,
      SPBPERS_CITZ_CODE,
      SPBPERS_CITZ_COUNTRY,
      GOBINTL_NATN_CODE_BIRTH,
      GOBINTL_BIRTH_NATN,
      GOBTPAC_EXTERNAL_USER,
      GORADID_ADDITIONAL_ID,
      GOREMAL_EMAIL_ADDRESS,
      GOREMAL_EMAL_CODE,
      SHRDGMR_SEQ_NO,
      SHRDGMR_DEGC_CODE,
      SHRDGMR_DEGS_CODE,
      SHRDGMR_LEVL_CODE,
      SHRDGMR_COLL_CODE_1,
      SHRDGMR_MAJR_CODE_1,
      SHRDGMR_MAJR_CODE_MINR_1,
      SHRDGMR_MAJR_CODE_CONC_1,
      SHRDGMR_APPL_DATE,
      SHRDGMR_GRAD_DATE,
      SHRDGMR_ACYR_CODE_BULLETIN,
      SHRDGMR_CAMP_CODE,
      SHRDGMR_TERM_CODE_GRAD,
      SHRDGMR_ACYR_CODE,
      SHRDGMR_TERM_CODE_STUREC,
      SHRDGMR_ACTIVITY_DATE,
      SHRDGMR_GRST_CODE,
      SHRDGMR_TERM_CODE_COMPLETED,
      SHRDGMR_DEPT_CODE,
      SHRDGMR_PROGRAM,
      SHRDGMR_SURROGATE_ID,
      SHRDGMR_VERSION,
      SHRDGMR_DEGS_DESC,
      SHRDGMR_DEGC_DESC,
      SHRDGMR_LEVL_DESC,
      SHRDGMR_MAJR_DESC,
      SHRDGMR_GRST_DESC,
      S1.SHRTGPA_HOURS_ATTEMPTED,
      S1.SHRTGPA_HOURS_EARNED,
      S1.SHRTGPA_GPA_HOURS,
      S1.SHRTGPA_QUALITY_POINTS,
      S1.SHRTGPA_GPA,
      S1.SHRLGPA_HOURS_ATTEMPTED,
      S1.SHRLGPA_HOURS_EARNED,
      S1.SHRLGPA_GPA_HOURS,
      S1.SHRLGPA_QUALITY_POINTS,
      S1.SHRLGPA_GPA,
      SHRTTRM_TERM_CODE,
      SHRTTRM_RECORD_STATUS_DATE,
      SHRTTRM_ASTD_CODE_END_OF_TERM,
      SHRTTRM_ASTD_DESC_END_OF_TERM,
      SHRTTRM_ASTD_DATE_END_OF_TERM,
      SHRTTRM_ACTIVITY_DATE,
      SHRTTRM_ASTD_CODE_DL,
      SHRTTRM_ASTD_DESC_DL,
      SHRTTRM_ASTD_DATE_DL,
      SHRTTRM_WRSN_CODE,
      SHRTTRM_WRSN_DESC,
      SHRDGIH_DGMR_SEQ_NO,
      SHRDGIH_HONR_CODE,
      SHRDGIH_ACTIVITY_DATE,
      SHRDGIH_TRANSC_PRT_IND,
      SHRDGIH_COMMENCE_PRT_IND,
      SHRDGIH_HONR_DESC,
      SHRDGIH_SURROGATE_ID,
      SHRDGIH_VERSION

  FROM
      SPAIDEN SPRIDEN

      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SHADEGR SHRDGMR ON SHRDGMR.SHRDGMR_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SHAGPAR S1 ON S1.SHRLGPA_PIDM = SPRIDEN_PIDM
           AND SHRTGPA_LEVL_CODE = SHRDGMR_LEVL_CODE
           AND SHRLGPA_LEVL_CODE = SHRDGMR_LEVL_CODE

      LEFT OUTER JOIN SHATERM SHRTTRM ON SHRTTRM.SHRTTRM_PIDM = SPRIDEN_PIDM

  WHERE
      SHRDGMR_GRAD_DATE >= :select_start_date
      AND SHRDGMR_GRAD_DATE <= :select_end_date
  ),

GRADUATED_ADRTELE as
(
  SELECT
      SPRIDEN_PIDM,
      SPRIDEN_ID,
      SPRIDEN_LAST_NAME,
      SPRIDEN_FIRST_NAME,
      SPRIDEN_MI,
      SPRIDEN_LEGAL_NAME,
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME,
      SPRIDEN_SEARCH_MI,
      SPBPERS_PREF_FIRST_NAME,
      SPBPERS_AGE,
      SPBPERS_SEX,
      GORRACE_RACE_CDE,
      GORRACE_DESC,
      SPBPERS_ETHN_CDE,
      SPBPERS_ETHN_DESC,
      SPBPERS_SICAS_HISP_ORIGIN,
      SPBPERS_CITZ_CODE,
      SPBPERS_CITZ_COUNTRY,
      GOBINTL_NATN_CODE_BIRTH,
      GOBINTL_BIRTH_NATN,
      GOBTPAC_EXTERNAL_USER,
      GORADID_ADDITIONAL_ID,
      GOREMAL_EMAIL_ADDRESS,
      GOREMAL_EMAL_CODE,
      SPRADDR_PIDM,
      SPRADDR_ATYP_CODE,
      SPRADDR_ATYP_DESC,
      SPRADDR_FROM_DATE,
      SPRADDR_TO_DATE,
      SPRADDR_STREET_LINE1,
      SPRADDR_STREET_LINE2,
      SPRADDR_STREET_LINE3,
      SPRADDR_CITY,
      SPRADDR_STAT_CODE,
      SPRADDR_ZIP,
      SPRTELE_PIDM,
      SPRTELE_TELE_CODE,
      SPRTELE_TELE_DESC,
      SPRTELE_PHONE_AREA,
      SPRTELE_PHONE_NUMBER,
      SPREMRG_PIDM,
      SPREMRG_LAST_NAME,
      SPREMRG_FIRST_NAME,
      SPREMRG_MI,
      SPREMRG_RELT_CODE,
      SPREMRG_RELT_DESC,
      SPREMRG_PRIORITY,
      SPREMRG_STREET_LINE1,
      SPREMRG_STREET_LINE2,
      SPREMRG_STREET_LINE3,
      SPREMRG_CITY,
      SPREMRG_STAT_CODE,
      SPREMRG_NATN_CODE,
      SPREMRG_ZIP,
      SPREMRG_PHONE_AREA,
      SPREMRG_PHONE_NUMBER,
      SPREMRG_PHONE_EXT,
      SPREMRG_ACTIVITY_DATE,
      SPREMRG_ATYP_CODE,
      SPREMRG_HOUSE_NUMBER

  FROM
      GRADUATED_LIST_DEMO A

      LEFT OUTER JOIN TUIADDR SPRADDR ON SPRADDR.SPRADDR_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPATELE SPRTELE ON SPRTELE.SPRTELE_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPAEMRG SPREMRG ON SPREMRG.SPREMRG_PIDM = SPRIDEN_PIDM

  WHERE
      (SPREMRG_PRIORITY <= 1 OR SPREMRG_PRIORITY IS NULL)
  )

SELECT
-- Reporting Use Only
    SPRIDEN_PIDM as Remove_Label_From_Dashboard,

-- Demographic Measures
    SEX_Measure,
    RACE_Measure,
    ETHN_Measure,
    LEVL_Measure,
    DEGC_Measure,
    DEPT_Measure,
    POS_Measure,
    DEGS_Measure,

-- Systems Info/PII
    SPRIDEN_ID as Banner_ID,
    SPRIDEN_LEGAL_NAME as Student_Name,
    SPRIDEN_LAST_NAME as Last_Name,
    SPRIDEN_FIRST_NAME as First_Name,
    SPRIDEN_MI as MI,
    SPBPERS_PREF_FIRST_NAME Pref_Fname,
    GORADID_ADDITIONAL_ID as SUID,

-- Email, Telephone, & Address
    GOREMAL_EMAIL_ADDRESS as Email_Address,
    GOREMAL_EMAL_CODE as Email_Code,

-- GPA Advising
    SHRLGPA_HOURS_ATTEMPTED as Cum_Enrolled_Hours,
    SHRLGPA_HOURS_EARNED as Cum_Earned_Hours,
    SHRLGPA_GPA_HOURS as Cum_GPA_Hours,
    SHRLGPA_QUALITY_POINTS as Cum_Quality_Points,
    SHRLGPA_GPA as Cum_GPA,
    SHRTGPA_HOURS_ATTEMPTED as Term_Enrolled_Hours,
    SHRTGPA_HOURS_EARNED as Term_Earned_Hours,
    SHRTGPA_GPA_HOURS as Term_GPA_Hours,
    SHRTGPA_QUALITY_POINTS as Term_Quality_Points,
    SHRTGPA_GPA as Term_GPA,

-- Commencement
    SHRDGMR_SEQ_NO as Degr_Seq_No,
    SHRDGMR_DEGC_CODE as Degr_Degree,
    SHRDGMR_DEGS_CODE as Degr_Status,
    SHRDGMR_LEVL_CODE as Degr_Level,
    SHRDGMR_COLL_CODE_1 as Degr_Coll,
    SHRDGMR_MAJR_CODE_1 as Degr_Major,
    SHRDGMR_MAJR_CODE_MINR_1 as Degr_Minor,
    SHRDGMR_MAJR_CODE_CONC_1 as Degr_Conc,
    SHRDGMR_APPL_DATE as Degr_Applied_Date,
    SHRDGMR_GRAD_DATE as Degr_Grad_Date,
    SHRDGMR_ACYR_CODE_BULLETIN as Degr_ACYR_Code_Bulletin,
    SHRDGMR_CAMP_CODE as Degr_Camp_Code,
    SHRDGMR_TERM_CODE_GRAD as Degr_Term_Code_Grad,
    SHRDGMR_ACYR_CODE as Degr_ACYR_Code,
    SHRDGMR_TERM_CODE_STUREC as Degr_Term_Code_Sturec,
    SHRDGMR_ACTIVITY_DATE as Degr_Activity,
    SHRDGMR_GRST_CODE as Degr_GRST_Code,
    SHRDGMR_TERM_CODE_COMPLETED as Degr_Term_Code_Completed,
    SHRDGMR_DEPT_CODE as Degr_Dept,
    SHRDGMR_PROGRAM as Degr_Program,
    SHRDGMR_SURROGATE_ID,
    SHRDGMR_VERSION,
    SHRDGMR_DEGS_DESC as Degr_Status_Desc,
    SHRDGMR_DEGC_DESC as Degr_Degree_Desc,
    SHRDGMR_LEVL_DESC as Degr_Level_Desc,
    SHRDGMR_MAJR_DESC as Degr_Major_Desc,
    SHRDGMR_GRST_DESC as Degr_GRST_Desc,
    SHRDGIH_DGMR_SEQ_NO as Degree_Honr_Seq_No,
    SHRDGIH_HONR_CODE as Degree_Honr_Code,
    SHRDGIH_ACTIVITY_DATE as Degree_Honr_Activity,
    SHRDGIH_TRANSC_PRT_IND as Degree_Honr_Trans_Ind,
    SHRDGIH_COMMENCE_PRT_IND  as Degree_Honr_Commence_Ind,
    SHRDGIH_HONR_DESC as Degree_Honr_Desc

FROM
    GRADUATED_LIST_DEMO B

WHERE
    NULL IS NULL

      -- DEGREE CONDITIONS

    AND SHRDGMR_DEPT_CODE = 'ERE'

--$addfilter

--$beginorder

ORDER BY
    1

--$endorder