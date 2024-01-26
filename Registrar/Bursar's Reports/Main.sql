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

GOAEMAL as
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

SOAHOLD as
(
  SELECT
      SPRHOLD.SPRHOLD_PIDM,
      SPRHOLD.SPRHOLD_HLDD_CODE,
      SPRHOLD.SPRHOLD_USER,
      SPRHOLD.SPRHOLD_FROM_DATE,
      SPRHOLD.SPRHOLD_TO_DATE,
      SPRHOLD.SPRHOLD_RELEASE_IND,
      SPRHOLD.SPRHOLD_REASON,
      SPRHOLD.SPRHOLD_ACTIVITY_DATE,
      SPRHOLD.SPRHOLD_DATA_ORIGIN,
      SPRHOLD.SPRHOLD_SURROGATE_ID,
      SPRHOLD.SPRHOLD_VERSION,
      SPRHOLD.SPRHOLD_USER_ID,
      SPRHOLD.SPRHOLD_SEQUENCE_NO,
      f_get_desc_fnc('STVHLDD', SPRHOLD.SPRHOLD_HLDD_CODE, 30) as SPRHOLD_HLDD_DESC

  FROM
      SPRHOLD SPRHOLD
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
      LEFT OUTER JOIN GOAEMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
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

BURSAR_HOLD as
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
      SPRHOLD_HLDD_CODE,
      SPRHOLD_HLDD_DESC,
      SPRHOLD_USER,
      SPRHOLD_FROM_DATE,
      SPRHOLD_TO_DATE,
      SPRHOLD_RELEASE_IND,
      SPRHOLD_REASON,
      SPRHOLD_ACTIVITY_DATE

  FROM
      SPAIDEN SPRIDEN
      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOAEMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOAHOLD SPRHOLD ON SPRHOLD.SPRHOLD_PIDM = SPRIDEN_PIDM

  WHERE
      SPRHOLD_FROM_DATE >= :select_start_date
      AND SPRHOLD_TO_DATE <= :select_end_date
  )

SELECT
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

-- Account Holdings
    SPRHOLD_HLDD_CODE as Hold_Code,
    SPRHOLD_HLDD_DESC as Hold_Desc,
    SPRHOLD_USER as Hold_User,
    SPRHOLD_FROM_DATE as Hold_From_Date,
    SPRHOLD_TO_DATE as Hold_To_Date,
    SPRHOLD_RELEASE_IND as Hold_Realse_Ind,
    SPRHOLD_REASON as Hold_Reason,
    SPRHOLD_ACTIVITY_DATE as Hold_Activity_Date

/*
    SPRIDEN.SPRIDEN_ID as Banner_ID,
    SPRIDEN.SPRIDEN_LAST_NAME as Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME as First_Name,
    SGBSTDN.SGBSTDN_STYP_CODE as SGBSTDN_STYP_CODE,
    f_get_desc_fnc('STVSTYP',SGBSTDN.SGBSTDN_STYP_CODE, 30) as Reg_Type,
    SGBSTDN.SGBSTDN_STST_CODE as SGBSTDN_STST_CODE,
    f_get_desc_fnc('STVSTST', SGBSTDN.SGBSTDN_STST_CODE, 30) as STST_CODE,
    SPRHOLD_HLDD_CODE as Hold_Code,
    f_get_desc_fnc('STVHLDD', SPRHOLD.SPRHOLD_HLDD_CODE, 30) as Hold_Desc,
    SPRHOLD.SPRHOLD_USER as User_NAME,
    SPRHOLD.SPRHOLD_FROM_DATE as From_Date,
    SPRHOLD.SPRHOLD_TO_DATE as To_Date,
    SPRHOLD.SPRHOLD_RELEASE_IND as Release_Ind,
    SPRHOLD.SPRHOLD_REASON as Reason,
    SPRHOLD.SPRHOLD_ACTIVITY_DATE as Recent_Activity,
    SPRHOLD.SPRHOLD_DATA_ORIGIN as Origin,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME
*/

FROM
    BURSAR_HOLD B
    LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE IS NOT NULL

WHERE
    NULL IS NULL
    AND STVTERM.STVTERM_CODE = (SELECT MAX(STVTERM_CODE)
                               FROM    STVTERM TERM
                               WHERE   TERM.STVTERM_CODE IS NOT NULL
                               AND     TERM.STVTERM_START_DATE <= SYSDATE)

ORDER BY
    SPRHOLD_FROM_DATE,
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_LAST_NAME
