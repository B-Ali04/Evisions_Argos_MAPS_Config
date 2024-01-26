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
      SPRADDR.SPRADDR_SURROGATE_ID,
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
/*
      AND SPRADDR.SPRADDR_SURROGATE_ID = (SELECT MAX(SPRADDR_SURROGATE_ID)
                                         FROM    SPRADDR ADDR
                                         WHERE   ADDR.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                         AND     ADDR.SPRADDR_ATYP_CODE IN ('MA','PA','PR')
                                         AND     ADDR.SPRADDR_STATUS_IND IS NULL)
*/
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
      f_get_desc_fnc('STVTERM',SGBSTDN.SGBSTDN_TERM_CODE_EFF, 30) as SGBSTDN_EFF_TERM_DESC,
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
      (SELECT GOREMAL_EMAIL_ADDRESS
      FROM    GOREMAL
      WHERE   GOREMAL_PIDM = SGRADVR.SGRADVR_ADVR_PIDM
      AND     GOREMAL_EMAL_CODE = 'SU') as SGRADVR_ADVR_EMAIL,
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
                                          AND     ADVR.SGRADVR_PRIM_IND = 'Y'
                                          AND     ADVR.SGRADVR_TERM_CODE_EFF <= :select_term_code.STVTERM_CODE)
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
                                  AND     TTRM.SHRTTRM_TERM_CODE < :select_term_code.STVTERM_CODE)
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
                                      AND     TGPA.SHRTGPA_TERM_CODE <= :select_term_code.STVTERM_CODE)
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

STUDENT_LIST_DEMO as
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
        WHEN SGBSTDN_MAJR_CODE_1 IS NULL THEN 0
          ELSE 1
            END as POS_Measure,
      CASE
        WHEN SGBSTDN_DEGC_CODE_1 IS NULL THEN 0
          ELSE 1
            END as DEGC_Measure,
      CASE
        WHEN SGBSTDN_STYP_CODE IS NULL THEN 0
          ELSE 1
            END as STYP_Measure,
      CASE
        WHEN SGBSTDN_LEVL_CODE IS NULL THEN 0
          ELSE 1
            END as LEVL_Measure,
      CASE
        WHEN SGBSTDN_CLAS_CODE IS NULL THEN 0
          ELSE 1
            END as CLAS_Measure,
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
      SFRTHST_TMST_CODE,
      SFRTHST_TMST_DESC,
      SGBSTDN_TERM_CODE_EFF,
      SGBSTDN_STST_CODE,
      SGBSTDN_STYP_CODE,
      SGBSTDN_LEVL_CODE,
      SGBSTDN_CLAS_CODE,
      SGBSTDN_DEPT_CODE,
      SGBSTDN_PROGRAM_1,
      SGBSTDN_MAJR_CODE_1,
      SGBSTDN_MAJR_CODE_MINR_1,
      SGBSTDN_MAJR_CODE_MINR_1_2,
      SGBSTDN_MAJR_CODE_CONC_1,
      SGBSTDN_DEGC_CODE_1,
      SGBSTDN_RESD_CODE,
      SGBSTDN_EXP_GRAD_DATE,
      SGBSTDN_EFF_TERM_DESC,
      SGBSTDN_STYP_DESC,
      SGBSTDN_LEVL_DESC,
      SGBSTDN_CLAS_DESC,
      SGBSTDN_DEPT_DESC,
      SGBSTDN_MAJR_DESC,
      SGBSTDN_MINR_1_DESC,
      SGBSTDN_MINR_1_2_DESC,
      SGBSTDN_CONC_DESC,
      SGBSTDN_DEGC_DESC,
      SGBSTDN_RESD_DESC,
      STVCLAS_SURROGATE_ID

  FROM
      SPAIDEN SPRIDEN

      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SGASTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN STVCLAS STVCLAS ON STVCLAS.STVCLAS_CODE = SGBSTDN_CLAS_CODE

  WHERE
      SGBSTDN_TERM_CODE_EFF = FY_SGBSTDN_EFF_TERM(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE)
  ),

STUDENT_ADRTELE as
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
      SFRTHST_TMST_CODE,
      SFRTHST_TMST_DESC,
      SGBSTDN_TERM_CODE_EFF,
      SGBSTDN_STST_CODE,
      SGBSTDN_STYP_CODE,
      SGBSTDN_LEVL_CODE,
      SGBSTDN_CLAS_CODE,
      SGBSTDN_DEPT_CODE,
      SGBSTDN_PROGRAM_1,
      SGBSTDN_MAJR_CODE_1,
      SGBSTDN_MAJR_CODE_MINR_1,
      SGBSTDN_MAJR_CODE_MINR_1_2,
      SGBSTDN_MAJR_CODE_CONC_1,
      SGBSTDN_DEGC_CODE_1,
      SGBSTDN_RESD_CODE,
      SGBSTDN_EXP_GRAD_DATE,
      SGBSTDN_EFF_TERM_DESC,
      SGBSTDN_STYP_DESC,
      SGBSTDN_LEVL_DESC,
      SGBSTDN_CLAS_DESC,
      SGBSTDN_DEPT_DESC,
      SGBSTDN_MAJR_DESC,
      SGBSTDN_MINR_1_DESC,
      SGBSTDN_MINR_1_2_DESC,
      SGBSTDN_CONC_DESC,
      SGBSTDN_DEGC_DESC,
      SGBSTDN_RESD_DESC,
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
      SPRADDR_SURROGATE_ID,
      SPRTELE_PIDM,
      SPRTELE_TELE_CODE,
      SPRTELE_TELE_DESC,
      SPRTELE_PHONE_AREA,
      SPRTELE_PHONE_NUMBER,
      SPRTELE_SURROGATE_ID,
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
      SPREMRG_HOUSE_NUMBER,
      SPREMRG_SURROGATE_ID

  FROM
      STUDENT_LIST_DEMO A

      LEFT OUTER JOIN TUIADDR SPRADDR ON SPRADDR.SPRADDR_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPATELE SPRTELE ON SPRTELE.SPRTELE_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPAEMRG SPREMRG ON SPREMRG.SPREMRG_PIDM = SPRIDEN_PIDM

  WHERE
      (SPREMRG_PRIORITY <= 1 OR SPREMRG_PRIORITY IS NULL)
  ),

ADVISING_LIST_DEMO as
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
        WHEN SGBSTDN_STST_CODE IS NULL THEN 0
          ELSE 1
            END as STST_Measure,
      CASE
        WHEN SGBSTDN_STYP_CODE IS NULL THEN 0
          ELSE 1
            END as STYP_Measure,
      CASE
        WHEN SGBSTDN_LEVL_CODE IS NULL THEN 0
          ELSE 1
            END as LEVL_Measure,
      CASE
        WHEN SGBSTDN_DEGC_CODE_1 IS NULL THEN 0
          ELSE 1
            END as DEGC_Measure,
      CASE
        WHEN SGBSTDN_CLAS_CODE IS NULL THEN 0
          ELSE 1
            END as CLAS_Measure,
      CASE
        WHEN SGBSTDN_DEPT_CODE IS NULL THEN 0
          ELSE 1
            END as DEPT_Measure,
      CASE
        WHEN SGBSTDN_MAJR_CODE_1 IS NULL THEN 0
          ELSE 1
            END as POS_Measure,
      CASE
        WHEN SGBSTDN_RESD_CODE IS NULL THEN 0
          ELSE 1
            END as RESD_Measure,
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
      SFRTHST_TMST_CODE,
      SFRTHST_TMST_DESC,
      SGBSTDN_TERM_CODE_EFF,
      SGBSTDN_STST_CODE,
      SGBSTDN_STYP_CODE,
      SGBSTDN_LEVL_CODE,
      SGBSTDN_CLAS_CODE,
      SGBSTDN_DEPT_CODE,
      SGBSTDN_PROGRAM_1,
      SGBSTDN_MAJR_CODE_1,
      SGBSTDN_MAJR_CODE_MINR_1,
      SGBSTDN_MAJR_CODE_MINR_1_2,
      SGBSTDN_MAJR_CODE_CONC_1,
      SGBSTDN_DEGC_CODE_1,
      SGBSTDN_RESD_CODE,
      SGBSTDN_EXP_GRAD_DATE,
      SGBSTDN_STYP_DESC,
      SGBSTDN_LEVL_DESC,
      SGBSTDN_CLAS_DESC,
      SGBSTDN_DEPT_DESC,
      SGBSTDN_MAJR_DESC,
      SGBSTDN_MINR_1_DESC,
      SGBSTDN_MINR_1_2_DESC,
      SGBSTDN_CONC_DESC,
      SGBSTDN_DEGC_DESC,
      SGBSTDN_RESD_DESC,
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
      SGRADVR_PIDM,
      SGRADVR_ADVR_PIDM,
      SGRADVR_ADVR_NAME,
      SGRADVR_NAME,
      SGRADVR_ADVR_DESC,
      SGRADVR_TERM_CODE_EFF,
      (SELECT GOREMAL_EMAIL_ADDRESS
      FROM    GOREMAL
      WHERE   GOREMAL_PIDM = SGRADVR.SGRADVR_ADVR_PIDM
      AND     GOREMAL_EMAL_CODE = 'SU') as SGRADVR_ADVR_EMAIL

  FROM
      SPAIDEN SPRIDEN

      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SGASTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SPRIDEN_PIDM

      LEFT OUTER JOIN SHAGPAR S1 ON S1.SHRLGPA_PIDM = SPRIDEN_PIDM
           AND S1.SHRTGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
           AND S1.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE

      LEFT OUTER JOIN SHATERM SHRTTRM ON SHRTTRM.SHRTTRM_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SGAADVR SGRADVR ON SGRADVR.SGRADVR_PIDM = SPRIDEN_PIDM
           AND SGRADVR.SGRADVR_PRIM_IND = 'Y'

  WHERE
      SGBSTDN_TERM_CODE_EFF = FY_SGBSTDN_EFF_TERM(SPRIDEN_PIDM, :select_term_code.STVTERM_CODE)
  ),

ADVISING_ADRTELE as
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
      SGRADVR_PIDM,
      SGRADVR_ADVR_PIDM,
      SGRADVR_ADVR_NAME,
      SGRADVR_NAME,
      SGRADVR_ADVR_DESC,
      SGRADVR_TERM_CODE_EFF,
      SGRADVR_ADVR_EMAIL,
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
      ADVISING_LIST_DEMO A

      LEFT OUTER JOIN TUIADDR SPRADDR ON SPRADDR.SPRADDR_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPATELE SPRTELE ON SPRTELE.SPRTELE_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SPAEMRG SPREMRG ON SPREMRG.SPREMRG_PIDM = SPRIDEN_PIDM

  WHERE
      (SPREMRG_PRIORITY <= 1 OR SPREMRG_PRIORITY IS NULL)
  )

SELECT
-- Reporting Use Only
    SPRIDEN_PIDM as Remove_Label_From_Dashboard,
    STVTERM.STVTERM_DESC as TERM_DESC,

-- Systems Info/PII
    SPRIDEN_ID as Banner_ID,
    SPBPERS_PREF_FIRST_NAME Pref_Fname,
    SPRIDEN_LEGAL_NAME as Student_Name,
    SPRIDEN_LAST_NAME as Last_Name,
    SPRIDEN_FIRST_NAME as First_Name,
    SPRIDEN_MI as MI,

-- ID, SUID, EMail
    GORADID_ADDITIONAL_ID as SUID,
    GOBTPAC_EXTERNAL_USER as ESF_Netid,
    GOREMAL_EMAIL_ADDRESS as Email_Address,
    GOREMAL_EMAL_CODE as Email_Code,

-- Matriculation
    SFRTHST_TMST_CODE as TMST_Code,
    SGBSTDN_TERM_CODE_EFF as Stdn_Eff_Term,
    SGBSTDN_STST_CODE as Stdn_STST,
    SGBSTDN_LEVL_CODE as Stdn_Level,
    SGBSTDN_CLAS_CODE as Stdn_Class,
    SGBSTDN_DEPT_CODE as Stdn_Dept,
    SGBSTDN_PROGRAM_1 as Stdn_Program,
    SGBSTDN_RESD_CODE as Stdn_Residency,
    SGBSTDN_EXP_GRAD_DATE as Stdn_Exp_Grad_Date,
    SGBSTDN_STYP_DESC as Stdn_STYP_Desc,
    SGBSTDN_LEVL_DESC as Stdn_Levl_Desc,
    SGBSTDN_CLAS_DESC as Stdn_Class_Desc,
    SGBSTDN_DEPT_DESC as Stdn_Dept_Desc,
    SGBSTDN_MAJR_DESC as Stdn_Major_Desc,
    SGBSTDN_MINR_1_DESC as Stdn_Minor_Desc,
    SGBSTDN_MINR_1_2_DESC as Stdn_Minor_2_Desc,
    SGBSTDN_CONC_DESC as Stdn_Conc_Desc,
    SGBSTDN_DEGC_DESC as Stdn_Degree_Desc,
    SGBSTDN_RESD_DESC as Stdn_Resd_Desc,

-- Email, Telephone, & Address
    GOREMAL_EMAIL_ADDRESS as Email_Address,
    GOREMAL_EMAL_CODE as Email_Code,

    SGRADVR_ADVR_PIDM as Advr_Advising_ID,
    SGRADVR_ADVR_NAME as Advr_Advisor_Name,
    SGRADVR_NAME as Advr_Student_Name,
    SGRADVR_ADVR_DESC as Advr_Advisor_Desc,
    SGRADVR_TERM_CODE_EFF as Advr_Term_Code_Eff,
    SGRADVR_ADVR_EMAIL as Advr_Advisor_Email,
    SHRLGPA_HOURS_ATTEMPTED as Cum_Enrolled_Hours,
    SHRLGPA_HOURS_EARNED as Cum_Earned_Hours,
    SHRLGPA_GPA_HOURS as Cum_GPA_Hours,
    SHRLGPA_QUALITY_POINTS as Cum_Quality_Points,
    SHRLGPA_GPA as Cum_GPA,
    SHRTGPA_HOURS_ATTEMPTED as Term_Enrolled_Hours,
    SHRTGPA_HOURS_EARNED as Term_Earned_Hours,
    SHRTGPA_GPA_HOURS as Term_GPA_Hours,
    SHRTGPA_QUALITY_POINTS as Term_Quality_Points,
    SHRTGPA_GPA as Term_GPA

FROM
    ADVISING_LIST_DEMO B
    LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE

WHERE
    NULL IS NULL

      -- STUDENT CONDITIONS

    AND SGBSTDN_STST_CODE = 'AS'
    AND SGBSTDN_EXP_GRAD_DATE >= :select_start_date

    AND SGBSTDN_EXP_GRAD_DATE <= :select_end_date
    AND NOT EXISTS (SELECT * FROM SHRDGMR DGMR
                   WHERE DGMR.SHRDGMR_PIDM = SPRIDEN_PIDM
                   AND DGMR.SHRDGMR_GRAD_DATE >= :select_start_date
                   AND DGMR.SHRDGMR_GRAD_DATE <= :select_end_date)

--$addfilter

--$beginorder

ORDER BY
    1