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

SAAADMS as
(
  SELECT
      SARADAP_PIDM,
      SARADAP_TERM_CODE_ENTRY,
      SARADAP_APPL_NO,
      SARADAP_LEVL_CODE,
      SARADAP_APPL_DATE,
      SARADAP_APST_CODE,
      SARADAP_APST_DATE,
      SARADAP_MAINT_IND,
      SARADAP_ADMT_CODE,
      SARADAP_STYP_CODE,
      SARADAP_CAMP_CODE,
      SARADAP_COLL_CODE_1,
      SARADAP_DEGC_CODE_1,
      SARADAP_MAJR_CODE_1,
      SARADAP_RESD_CODE,
      SARADAP_ACTIVITY_DATE,
      SARADAP_DEPT_CODE,
      SARADAP_PROGRAM_1,
      SARADAP_TERM_CODE_CTLG_1,
      SARADAP_WEB_TRANS_NO,
      SARADAP_WEB_AMOUNT,
      SARADAP_WEB_RECEIPT_NUMBER,
      SARADAP_SURROGATE_ID,
      SARADAP_VERSION,
      f_get_desc_fnc('STVLEVL', SARADAP_LEVL_CODE, 30) as SARADAP_LEVL_DESC,
      f_get_desc_fnc('STVAPST', SARADAP_APST_CODE, 30) as SARADAP_APST_DESC,
      f_get_desc_fnc('STVADMT', SARADAP_ADMT_CODE, 30) as SARADAP_ADMT_DESC,
      f_get_desc_fnc('STVAPST', SARADAP_STYP_CODE, 30) as SARADAP_STYP_DESC,
      f_get_desc_fnc('STVCAMP', SARADAP_CAMP_CODE, 30) as SARADAP_CAMP_DESC,
      f_get_desc_fnc('STVAPST', SARADAP_COLL_CODE_1, 30) as SARADAP_COLL_DESC,
      f_get_desc_fnc('STVDEGC', SARADAP_DEGC_CODE_1, 30) as SARADAP_DEGC_DESC,
      f_get_desc_fnc('STVMAJR', SARADAP_MAJR_CODE_1, 30) as SARADAP_MAJR_DESC,
      f_get_desc_fnc('STVRESD', SARADAP_RESD_CODE, 30) as SARADAP_RESD_DESC,
      f_get_desc_fnc('STVDEPT', SARADAP_DEPT_CODE, 30) as SARADAP_DEPT_DESC

    FROM
      SARADAP SARADAP

    WHERE
      SARADAP.SARADAP_APPL_NO = (SELECT MAX(SARADAP_APPL_NO)
                                FROM    SARADAP ADAP
                                WHERE   ADAP.SARADAP_PIDM = SARADAP.SARADAP_PIDM
                                AND     ADAP.SARADAP_TERM_CODE_ENTRY = SARADAP.SARADAP_TERM_CODE_ENTRY)
    ),

ROASTAT as
(
  SELECT
      RORSTAT.RORSTAT_AIDY_CODE,
      RORSTAT.RORSTAT_PIDM,
      RORSTAT.RORSTAT_LOCK_IND,
      RORSTAT.RORSTAT_PGRP_LOCK_IND,
      RORSTAT.RORSTAT_BGRP_PROC_IND,
      RORSTAT.RORSTAT_PGRP_PROC_IND,
      RORSTAT.RORSTAT_TGRP_PROC_IND,
      RORSTAT.RORSTAT_PCKG_FUND_PROC_IND,
      RORSTAT.RORSTAT_VER_COMPLETE,
      RORSTAT.RORSTAT_USER_ID,
      RORSTAT.RORSTAT_ACTIVITY_DATE,
      RORSTAT.RORSTAT_VER_PAY_IND,
      RORSTAT.RORSTAT_BGRP_CODE,
      RORSTAT.RORSTAT_APRD_CODE,
      RORSTAT.RORSTAT_PGRP_CODE,
      RORSTAT.RORSTAT_TGRP_CODE,
      RORSTAT.RORSTAT_RECALC_NA_IND,
      RORSTAT.RORSTAT_APPL_RCVD_DATE,
      RORSTAT.RORSTAT_PCKG_FUND_DATE,
      RORSTAT.RORSTAT_PCKG_COMP_DATE,
      RORSTAT.RORSTAT_ALL_REQ_COMP_DATE,
      RORSTAT.RORSTAT_MEMO_REQ_COMP_DATE,
      RORSTAT.RORSTAT_PCKG_REQ_COMP_DATE,
      RORSTAT.RORSTAT_DISB_REQ_COMP_DATE,
      RORSTAT.RORSTAT_PELL_SCHED_AWD,
      RORSTAT.RORSTAT_PRI_SAR_PGI,
      RORSTAT.RORSTAT_SAR_TRAN_NO,
      RORSTAT.RORSTAT_SAR_SSN,
      RORSTAT.RORSTAT_SAR_INIT,
      RORSTAT.RORSTAT_CM_SC_LOCK_IND,
      RORSTAT.RORSTAT_CM_PC_LOCK_IND,
      RORSTAT.RORSTAT_CM_TFC_LOCK_IND,
      RORSTAT.RORSTAT_PGI_LOCK_IND,
      RORSTAT.RORSTAT_INST_SC_LOCK_IND,
      RORSTAT.RORSTAT_INST_PC_LOCK_IND,
      RORSTAT.RORSTAT_AWD_LTR_IND,
      RORSTAT.RORSTAT_TRK_LTR_IND,
      RORSTAT.RORSTAT_IM_LOCK,
      RORSTAT.RORSTAT_FM_BATCH_LOCK,
      RORSTAT.RORSTAT_IM_BATCH_LOCK,
      RORSTAT.RORSTAT_FORMER_HEAL_IND,
      RORSTAT.RORSTAT_PELL_LT_HALF_COA,
      RORSTAT.RORSTAT_PELL_ORIG_IND,
      RORSTAT.RORSTAT_PELL_DISB_LOCK_IND,
      RORSTAT.RORSTAT_PELL_ATTEND_COST,
      RORSTAT.RORSTAT_TGRP_CODE_LOCK_IND,
      RORSTAT.RORSTAT_BGRP_CODE_LOCK_IND,
      RORSTAT.RORSTAT_PGRP_CODE_LOCK_IND,
      RORSTAT.RORSTAT_TURN_OFF_PELL_IND,
      RORSTAT.RORSTAT_VER_USER_ID,
      RORSTAT.RORSTAT_VER_DATE,
      RORSTAT.RORSTAT_DATA_ORIGIN,
      RORSTAT.RORSTAT_PREP_OR_TEACH_IND,
      RORSTAT.RORSTAT_ACG_DISB_LOCK_IND,
      RORSTAT.RORSTAT_SMART_DISB_LOCK_IND,
      RORSTAT.RORSTAT_ADDL_PELL_ELIG_IND,
      RORSTAT.RORSTAT_DEP_NO_PAR_DATA,
      RORSTAT.RORSTAT_POST_911_PELL_ELIG,
      RORSTAT.RORSTAT_PBUD_INFO_ACCESS_IND,
      RORSTAT.RORSTAT_HIGH_PELL_LEU_FLAG,
      RORSTAT.RORSTAT_SS_INFO_ACCESS_IND,
      RORSTAT.RORSTAT_XES,
      RORSTAT.RORSTAT_XES_LOCK_IND,
      RORSTAT.RORSTAT_RECALC_IM_IND,
      RORSTAT.RORSTAT_SURROGATE_ID,
      RORSTAT.RORSTAT_VERSION,
      RORSTAT.RORSTAT_CFH_IND

  FROM
      RORSTAT RORSTAT
  ),

RBAABUD as
(
  SELECT
      RBBABUD_AIDY_CODE,
      RBBABUD_PIDM,
      RBBABUD_TFC_IND,
      RBBABUD_BTYP_CODE,
      RBBABUD_USER_ID,
      RBBABUD_SYS_IND,
      RBBABUD_ACTIVITY_DATE,
      RBBABUD_INFO_ACCESS_IND,
      RBRACMP_AIDY_CODE,
      RBRACMP_PIDM,
      RBRACMP_BTYP_CODE,
      RBRACMP_COMP_CODE,
      RBRACMP_AMT,
      RBRACMP_USER_ID,
      RBRACMP_SYS_IND,
      RBRACMP_ACTIVITY_DATE,
      RBRACMP_DATA_ORIGIN,
      RBRACMP_SURROGATE_ID,
      RBRACMP_VERSION,
      (SELECT SUM(RBRACMP_AMT)
      FROM RBRACMP R1
      WHERE R1.RBRACMP_PIDM = RBBABUD.RBBABUD_PIDM
      AND R1.RBRACMP_AIDY_CODE = RBBABUD_AIDY_CODE
      AND R1.RBRACMP_BTYP_CODE = RBBABUD_BTYP_CODE
      )
      as RBRACMP_DISPSUM_BUDJET,

      -- EFC
      RNVAND0_AIDY_CODE,
      RNVAND0_PIDM,
      RNVAND0_BUDGET_AMOUNT,
      RNVAND0_RESOURCE_AMOUNT,
      RNVAND0_REPLACE_EFC_AMT,
      RNVAND0_REDUCE_NEED_AMT,
      RNVAND0_EFC_IND,
      RNVAND0_FM_BUDGET_AMT,
      RNVAND0_EFC_AMT,
      RNVAND0_GROSS_NEED,
      RNVAND0_UNMET_NEED,
      RNVAND0_OFFER_AMT,
      RNVAND0_PELL_AWARD

    FROM
      RBBABUD RBBABUD
      LEFT OUTER JOIN RBRACMP RBRACMP ON RBRACMP.RBRACMP_PIDM = RBBABUD.RBBABUD_PIDM
      LEFT OUTER JOIN RNVAND0 RNVAND0 ON RNVAND0.RNVAND0_PIDM = RBBABUD.RBBABUD_PIDM

    WHERE
      RBBABUD_BTYP_CODE = 'CAMP'
      AND RBRACMP_BTYP_CODE = 'CAMP'
  ),

RPAAWRD as
(
  SELECT
      RPRAWRD.RPRAWRD_AIDY_CODE,
      RPRAWRD.RPRAWRD_PIDM,
      RPRAWRD.RPRAWRD_FUND_CODE,
      RPRAWRD.RPRAWRD_AWST_CODE,
      RPRAWRD.RPRAWRD_AWST_DATE,
      RPRAWRD.RPRAWRD_SYS_IND,
      RPRAWRD.RPRAWRD_ACTIVITY_DATE,
      RPRAWRD.RPRAWRD_LOCK_IND,
      RPRAWRD.RPRAWRD_UNMET_NEED_OVRDE_IND,
      RPRAWRD.RPRAWRD_REPLACE_TFC_OVRDE_IND,
      RPRAWRD.RPRAWRD_TREQ_OVRDE_IND,
      RPRAWRD.RPRAWRD_FED_LIMIT_OVRDE_IND,
      RPRAWRD.RPRAWRD_FUND_LIMIT_OVRDE_IND,
      RPRAWRD.RPRAWRD_OFFER_EXP_DATE,
      RPRAWRD.RPRAWRD_ACCEPT_AMT,
      RPRAWRD.RPRAWRD_ACCEPT_DATE,
      RPRAWRD.RPRAWRD_PAID_AMT,
      RPRAWRD.RPRAWRD_PAID_DATE,
      RPRAWRD.RPRAWRD_ORIG_OFFER_AMT,
      RPRAWRD.RPRAWRD_ORIG_OFFER_DATE,
      RPRAWRD.RPRAWRD_OFFER_AMT,
      RPRAWRD.RPRAWRD_OFFER_DATE,
      RPRAWRD.RPRAWRD_DECLINE_AMT,
      RPRAWRD.RPRAWRD_DECLINE_DATE,
      RPRAWRD.RPRAWRD_CANCEL_AMT,
      RPRAWRD.RPRAWRD_CANCEL_DATE,
      RPRAWRD.RPRAWRD_INFO_ACCESS_IND,
      RPRAWRD.RPRAWRD_LAST_WEB_UPDATE,
      RPRAWRD.RPRAWRD_USER_ID,
      RPRAWRD.RPRAWRD_OVERRIDE_YR_IN_COLL,
      RPRAWRD.RPRAWRD_DATA_ORIGIN,
      RPRAWRD.RPRAWRD_OVERRIDE_NO_PELL,
      RPRAWRD.RPRAWRD_OVERRIDE_FUND_RULE,
      RPRAWRD.RPRAWRD_SURROGATE_ID,
      RPRAWRD.RPRAWRD_VERSION,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_AWST_CODE in ('A', 'O')
      ) as RPRAWRD_DISPSUM_OFFER_AMT,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_FUND_CODE = 'NTS'
      AND R1.RPRAWRD_AWST_CODE in ('A', 'O')
      ) as RPRAWRD_DISPSUM_NTS_OFFERED,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_FUND_CODE = 'PSA'
      AND R1.RPRAWRD_AWST_CODE in ('A', 'O')
      ) as RPRAWRD_DISPSUM_PSA_OFFERED,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_FUND_CODE = 'CHA'
      AND R1.RPRAWRD_AWST_CODE in ('A', 'O')
      ) as RPRAWRD_DISPSUM_CHA_OFFERED,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_FUND_CODE = 'CAG'
      AND R1.RPRAWRD_AWST_CODE in ('A', 'O')
      ) as RPRAWRD_DISPSUM_CAG_OFFERED,

      (SELECT SUM(RPRAWRD_ORIG_OFFER_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_AWST_CODE in ('A')
      ) as RPRAWRD_DISPSUM_ACCEPTED_AMT,
      (SELECT SUM(RPRAWRD_PAID_AMT)
      FROM RPRAWRD R1
      WHERE R1.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
      AND R1.RPRAWRD_AIDY_CODE = RPRAWRD.RPRAWRD_AIDY_CODE
      AND R1.RPRAWRD_AWST_CODE in ('A')
      ) as RPRAWRD_DISPSUM_PAID_AMT

  FROM
      RPRAWRD RPRAWRD
      LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = 202420

  WHERE
      RPRAWRD_AIDY_CODE = STVTERM_FA_PROC_YR
      AND RPRAWRD_SURROGATE_ID = (SELECT MAX(RPRAWRD_SURROGATE_ID)
                                 FROM    RPRAWRD RPRA
                                 WHERE   RPRA.RPRAWRD_PIDM = RPRAWRD.RPRAWRD_PIDM
                                 AND     RPRA.RPRAWRD_AIDY_CODE <= STVTERM_FA_PROC_YR
                                 AND     RPRA.RPRAWRD_AWST_CODE IN ('A', 'O'))
  ),

FA_BUDGET_MEASURE as
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
      SARADAP_PIDM,
      SARADAP_TERM_CODE_ENTRY,
      SARADAP_APPL_NO,
      SARADAP_LEVL_CODE,
      SARADAP_APPL_DATE,
      SARADAP_APST_CODE,
      SARADAP_APST_DATE,
      SARADAP_MAINT_IND,
      SARADAP_ADMT_CODE,
      SARADAP_STYP_CODE,
      SARADAP_CAMP_CODE,
      SARADAP_COLL_CODE_1,
      SARADAP_DEGC_CODE_1,
      SARADAP_MAJR_CODE_1,
      SARADAP_RESD_CODE,
      SARADAP_ACTIVITY_DATE,
      SARADAP_DEPT_CODE,
      SARADAP_PROGRAM_1,
      SARADAP_TERM_CODE_CTLG_1,
      SARADAP_WEB_TRANS_NO,
      SARADAP_WEB_AMOUNT,
      SARADAP_WEB_RECEIPT_NUMBER,
      SARADAP_SURROGATE_ID,
      SARADAP_VERSION,
      SARADAP_LEVL_DESC,
      SARADAP_APST_DESC,
      SARADAP_ADMT_DESC,
      SARADAP_STYP_DESC,
      SARADAP_CAMP_DESC,
      SARADAP_COLL_DESC,
      SARADAP_DEGC_DESC,
      SARADAP_MAJR_DESC,
      SARADAP_RESD_DESC,
      SARADAP_DEPT_DESC,

    -- TUITION & BUDGEt

      RBBABUD_AIDY_CODE,
      RBBABUD_PIDM,
      RBBABUD_TFC_IND,
      RBBABUD_BTYP_CODE,
      RBBABUD_USER_ID,
      RBBABUD_SYS_IND,
      RBBABUD_ACTIVITY_DATE,
      RBBABUD_INFO_ACCESS_IND,

      RBRACMP_AIDY_CODE,
      RBRACMP_PIDM,
      RBRACMP_BTYP_CODE,
      RBRACMP_COMP_CODE,
      RBRACMP_AMT,
      RBRACMP_USER_ID,
      RBRACMP_SYS_IND,
      RBRACMP_ACTIVITY_DATE,
      RBRACMP_DATA_ORIGIN,
      RBRACMP_SURROGATE_ID,
      RBRACMP_VERSION,
      RBRACMP_DISPSUM_BUDJET,

      -- LOAN
      RORSTAT_AIDY_CODE,
      RORSTAT_PIDM,
      RORSTAT_LOCK_IND,
      RORSTAT_PGRP_LOCK_IND,
      RORSTAT_BGRP_PROC_IND,
      RORSTAT_PGRP_PROC_IND,
      RORSTAT_TGRP_PROC_IND,
      RORSTAT_PCKG_FUND_PROC_IND,
      RORSTAT_VER_COMPLETE,
      RORSTAT_USER_ID,
      RORSTAT_ACTIVITY_DATE,
      RORSTAT_VER_PAY_IND,
      RORSTAT_BGRP_CODE,
      RORSTAT_APRD_CODE,
      RORSTAT_PGRP_CODE,
      RORSTAT_TGRP_CODE,
      RORSTAT_RECALC_NA_IND,
      RORSTAT_APPL_RCVD_DATE,
      RORSTAT_PCKG_FUND_DATE,
      RORSTAT_PCKG_COMP_DATE,
      RORSTAT_ALL_REQ_COMP_DATE,
      RORSTAT_MEMO_REQ_COMP_DATE,
      RORSTAT_PCKG_REQ_COMP_DATE,
      RORSTAT_DISB_REQ_COMP_DATE,
      RORSTAT_PELL_SCHED_AWD,
      RORSTAT_PRI_SAR_PGI,
      RORSTAT_SAR_TRAN_NO,
      RORSTAT_SAR_SSN,
      RORSTAT_SAR_INIT,
      RORSTAT_CM_SC_LOCK_IND,
      RORSTAT_CM_PC_LOCK_IND,
      RORSTAT_CM_TFC_LOCK_IND,
      RORSTAT_PGI_LOCK_IND,
      RORSTAT_INST_SC_LOCK_IND,
      RORSTAT_INST_PC_LOCK_IND,
      RORSTAT_AWD_LTR_IND,
      RORSTAT_TRK_LTR_IND,
      RORSTAT_IM_LOCK,
      RORSTAT_FM_BATCH_LOCK,
      RORSTAT_IM_BATCH_LOCK,
      RORSTAT_FORMER_HEAL_IND,
      RORSTAT_PELL_LT_HALF_COA,
      RORSTAT_PELL_ORIG_IND,
      RORSTAT_PELL_DISB_LOCK_IND,
      RORSTAT_PELL_ATTEND_COST,
      RORSTAT_TGRP_CODE_LOCK_IND,
      RORSTAT_BGRP_CODE_LOCK_IND,
      RORSTAT_PGRP_CODE_LOCK_IND,
      RORSTAT_TURN_OFF_PELL_IND,
      RORSTAT_VER_USER_ID,
      RORSTAT_VER_DATE,
      RORSTAT_DATA_ORIGIN,
      RORSTAT_PREP_OR_TEACH_IND,
      RORSTAT_ACG_DISB_LOCK_IND,
      RORSTAT_SMART_DISB_LOCK_IND,
      RORSTAT_ADDL_PELL_ELIG_IND,
      RORSTAT_DEP_NO_PAR_DATA,
      RORSTAT_POST_911_PELL_ELIG,
      RORSTAT_PBUD_INFO_ACCESS_IND,
      RORSTAT_HIGH_PELL_LEU_FLAG,
      RORSTAT_SS_INFO_ACCESS_IND,
      RORSTAT_XES,
      RORSTAT_XES_LOCK_IND,
      RORSTAT_RECALC_IM_IND,
      RORSTAT_SURROGATE_ID,
      RORSTAT_VERSION,
      RORSTAT_CFH_IND,

      -- AWARDED AID
      RPRAWRD_AIDY_CODE,
      RPRAWRD_PIDM,
      RPRAWRD_FUND_CODE,
      RPRAWRD_AWST_CODE,
      RPRAWRD_AWST_DATE,
      RPRAWRD_SYS_IND,
      RPRAWRD_ACTIVITY_DATE,
      RPRAWRD_LOCK_IND,
      RPRAWRD_UNMET_NEED_OVRDE_IND,
      RPRAWRD_REPLACE_TFC_OVRDE_IND,
      RPRAWRD_TREQ_OVRDE_IND,
      RPRAWRD_FED_LIMIT_OVRDE_IND,
      RPRAWRD_FUND_LIMIT_OVRDE_IND,
      RPRAWRD_OFFER_EXP_DATE,
      RPRAWRD_ACCEPT_AMT,
      RPRAWRD_ACCEPT_DATE,
      RPRAWRD_PAID_AMT,
      RPRAWRD_PAID_DATE,
      RPRAWRD_ORIG_OFFER_AMT,
      RPRAWRD_ORIG_OFFER_DATE,
      RPRAWRD_OFFER_AMT,
      RPRAWRD_OFFER_DATE,
      RPRAWRD_DECLINE_AMT,
      RPRAWRD_DECLINE_DATE,
      RPRAWRD_CANCEL_AMT,
      RPRAWRD_CANCEL_DATE,
      RPRAWRD_INFO_ACCESS_IND,
      RPRAWRD_LAST_WEB_UPDATE,
      RPRAWRD_USER_ID,
      RPRAWRD_OVERRIDE_YR_IN_COLL,
      RPRAWRD_DATA_ORIGIN,
      RPRAWRD_OVERRIDE_NO_PELL,
      RPRAWRD_OVERRIDE_FUND_RULE,
      RPRAWRD_SURROGATE_ID,
      RPRAWRD_VERSION,
      RPRAWRD_DISPSUM_OFFER_AMT,
      RPRAWRD_DISPSUM_ACCEPTED_AMT,
      RPRAWRD_DISPSUM_PAID_AMT,
      RPRAWRD_DISPSUM_NTS_OFFERED,
      RPRAWRD_DISPSUM_PSA_OFFERED,
      RPRAWRD_DISPSUM_CHA_OFFERED,
      RPRAWRD_DISPSUM_CAG_OFFERED,

      -- EFC
      RNVAND0_AIDY_CODE,
      RNVAND0_PIDM,
      RNVAND0_BUDGET_AMOUNT,
      RNVAND0_RESOURCE_AMOUNT,
      RNVAND0_REPLACE_EFC_AMT,
      RNVAND0_REDUCE_NEED_AMT,
      RNVAND0_EFC_IND,
      RNVAND0_FM_BUDGET_AMT,
      RNVAND0_EFC_AMT,
      RNVAND0_GROSS_NEED,
      RNVAND0_UNMET_NEED,
      RNVAND0_OFFER_AMT,
      RNVAND0_PELL_AWARD

  FROM
      SPAIDEN SPRIDEN
      LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE
      LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN GOARACE GORPRAC ON GORPRAC.GORPRAC_PIDM = SPRIDEN_PIDM
      LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN_PIDM
           AND GOREMAL_EMAL_CODE = 'SU'
      LEFT OUTER JOIN SAAADMS SARADAP ON SARADAP.SARADAP_PIDM = SPRIDEN_PIDM
           AND SARADAP_TERM_CODE_ENTRY = STVTERM_CODE
      LEFT OUTER JOIN ROASTAT RORSTAT ON RORSTAT.RORSTAT_PIDM = SPRIDEN_PIDM
           AND RORSTAT_AIDY_CODE = STVTERM_FA_PROC_YR

      LEFT OUTER JOIN RBAABUD RBBABUD ON RBBABUD.RBBABUD_PIDM = SPRIDEN_PIDM
           AND RBBABUD_AIDY_CODE = STVTERM_FA_PROC_YR
           AND RBRACMP_AIDY_CODE = STVTERM_FA_PROC_YR
           AND RNVAND0_AIDY_CODE = STVTERM_FA_PROC_YR
           AND RBRACMP_COMP_CODE = 'TUIT'

      LEFT OUTER JOIN RPAAWRD RPRAWRD ON RPRAWRD.RPRAWRD_PIDM = SPRIDEN_PIDM

  )

SELECT
    SPRIDEN_PIDM as Remove_From_Dashboard,
    STVTERM.STVTERM_DESC as TERM_DESC,
    SPRIDEN_ID as Banner_ID,
    SPRIDEN_LEGAL_NAME as Student_Name,
    SPRIDEN_LAST_NAME as Last_Name,
    SPRIDEN_FIRST_NAME as First_Name,
    SPRIDEN_MI as MI,
    SPBPERS_PREF_FIRST_NAME asPref_Fname,
    GOBTPAC_EXTERNAL_USER as ESF_NetID,
    GORADID_ADDITIONAL_ID as SUID,

-- Email, Telephone, & Address
    GOREMAL_EMAIL_ADDRESS as SU_Email_Address,
    GOREMAL_EMAL_CODE as Email_Code,
    (SELECT GOREMAL_EMAIL_ADDRESS
    FROM GOREMAL G
    WHERE G.GOREMAL_PIDM = SPRIDEN_PIDM
    AND G.GOREMAL_STATUS_IND = 'A'
    AND GOREMAL_EMAL_CODE = 'ESF'
    AND GOREMAL_SURROGATE_ID = (SELECT MAX (GOREMAL_SURROGATE_ID)
                               FROM GOREMAL EMAL1
                               WHERE EMAL1.GOREMAL_PIDM = SPRIDEN_PIDM
                               AND EMAL1.GOREMAL_EMAL_CODE = 'ESF')) as ESF_Email_Address,
-- APPLIED STUDENTS
    SARADAP_TERM_CODE_ENTRY as Appl_Term_Code,
    SARADAP_APPL_NO as Appl_No,
    SARADAP_LEVL_CODE as Appl_Levl,
    SARADAP_APPL_DATE as Appl_Date,
    SARADAP_APST_CODE as Appl_APST_Code,
    SARADAP_APST_DESC as Appl_APST_Desc,
    SARADAP_APST_DATE as Appl_APST_Date,
    SARADAP_MAINT_IND as Maintenance_Ind,
    SARADAP_ADMT_CODE as Appl_Admit_Code,
    SARADAP_STYP_CODE as Appl_Styp_Code,
    SARADAP_CAMP_CODE as Appl_Camp_Code,
    SARADAP_COLL_CODE_1 as Appl_Coll_Code,
    SARADAP_DEGC_CODE_1 as Appl_Degc_Code,
    SARADAP_MAJR_CODE_1 as Appl_Majr_Code,
    SARADAP_RESD_CODE as Appl_Residency,
    SARADAP_ACTIVITY_DATE as Activity_Date,
    SARADAP_DEPT_CODE as Appl_Dept_Code,
    SARADAP_PROGRAM_1 as Appl_Program,
    SARADAP_TERM_CODE_CTLG_1 as Appl_Term_Code_CTLG,
    SARADAP_WEB_TRANS_NO as Appl_Web_Trans_No,
    SARADAP_WEB_AMOUNT as Appl_Web_Amount,
    SARADAP_WEB_RECEIPT_NUMBER as Appl_Web_Receipt_Number,
    SARADAP_SURROGATE_ID,
    SARADAP_VERSION,
    SARADAP_LEVL_DESC as Appl_Levl_Desc,
    SARADAP_APST_DESC as Appl_APST_Desc,
    SARADAP_ADMT_DESC as Appl_ADMT_Desc,
    SARADAP_STYP_DESC as Appl_STYP_Desc,
    SARADAP_CAMP_DESC as Appl_CAMP_Desc,
    SARADAP_COLL_DESC as Appl_COLL_Desc,
    SARADAP_DEGC_DESC as Appl_DEGC_Desc,
    SARADAP_MAJR_DESC as Appl_MAJR_Desc,
    SARADAP_RESD_DESC as Appl_RESD_Desc,
    SARADAP_DEPT_DESC as Appl_DEPT_Desc,

    -- Student Apllication
    RORSTAT_AIDY_CODE as Applicant_AIDY,
    RORSTAT_PIDM as Applicant_PIDM,
    RORSTAT_LOCK_IND as Applicant_Lock_ind,
    RORSTAT_PGRP_LOCK_IND as PGRP_Lock,
    RORSTAT_BGRP_PROC_IND as BGRP_Lock,
    RORSTAT_PGRP_PROC_IND as PGRP_Lock,
    RORSTAT_TGRP_PROC_IND as TGRP_Lock,
    RORSTAT_PCKG_FUND_PROC_IND as PCKG_Fund_Proc,
    RORSTAT_VER_COMPLETE as Ver_Complete,
    RORSTAT_USER_ID as Applicant_User,
    RORSTAT_ACTIVITY_DATE as Applicant_Activity_Date,
    RORSTAT_VER_PAY_IND as Applicant_Ver_Pay,
    RORSTAT_BGRP_CODE as BGRP_Code,
    RORSTAT_APRD_CODE as APRD_Code,
    RORSTAT_PGRP_CODE as PGRP_Code,
    RORSTAT_TGRP_CODE as TGRP_Code,
    RORSTAT_RECALC_NA_IND as Recalc_NA,
    RORSTAT_APPL_RCVD_DATE as Appliation_Recived_Date,
    RORSTAT_PCKG_FUND_DATE as PCKG_Fund_Date,
    RORSTAT_PCKG_COMP_DATE as PCKG_Comp_Date,
    RORSTAT_ALL_REQ_COMP_DATE as Req_Comp_Date,
    RORSTAT_MEMO_REQ_COMP_DATE as Memo_Req_Comp_Date,
    RORSTAT_PCKG_REQ_COMP_DATE as PCKG_Req_Comp_Date,
    RORSTAT_DISB_REQ_COMP_DATE as DISB_Req_Comp_Date,
    RORSTAT_PELL_SCHED_AWD as Pell_Sched_Award,
    RORSTAT_PRI_SAR_PGI as PRI_SAR_PGI,
    RORSTAT_SAR_TRAN_NO as SAR_Transaction_No,
    RORSTAT_SAR_SSN as SAR_SSN,
    RORSTAT_SAR_INIT as SAR_Init,
    RORSTAT_CM_SC_LOCK_IND as CM_SC_Lock,
    RORSTAT_CM_PC_LOCK_IND as CM_PC_Lock,
    RORSTAT_CM_TFC_LOCK_IND as CM_TFC_Lock,
    RORSTAT_PGI_LOCK_IND as PGI_Lock,
    RORSTAT_INST_SC_LOCK_IND as Inst_SC_Lock,
    RORSTAT_INST_PC_LOCK_IND as Inst_PC_Lock,
    RORSTAT_AWD_LTR_IND as AWD_LTR,
    RORSTAT_TRK_LTR_IND as TRK_LTR,
    RORSTAT_IM_LOCK as IM_Lock,
    RORSTAT_FM_BATCH_LOCK as FM_Batch_Luck,
    RORSTAT_IM_BATCH_LOCK as IM_Batch_Luck,
    RORSTAT_FORMER_HEAL_IND as Former_Heal,
    RORSTAT_PELL_LT_HALF_COA as Pell_LT_Half_COa,
    RORSTAT_PELL_ORIG_IND as Pell_Orig,
    RORSTAT_PELL_DISB_LOCK_IND as Pell_Disb_Lcok,
    RORSTAT_PELL_ATTEND_COST as Pell_Attend_Cost,
    RORSTAT_TGRP_CODE_LOCK_IND as TGRP_Code_Lock,
    RORSTAT_BGRP_CODE_LOCK_IND as BGRP_Code_Lock,
    RORSTAT_PGRP_CODE_LOCK_IND as PGRP_Code_Lock,
    RORSTAT_TURN_OFF_PELL_IND as Turn_Off_Pell_IND,
    RORSTAT_VER_USER_ID as Verify_User_ID,
    RORSTAT_VER_DATE as Verify_Date,
    RORSTAT_DATA_ORIGIN as Data_Origin,
    RORSTAT_PREP_OR_TEACH_IND as Perp_Or_Teach,
    RORSTAT_ACG_DISB_LOCK_IND as ACG_Disb_Lock,
    RORSTAT_SMART_DISB_LOCK_IND as Smart_Disb_Lock,
    RORSTAT_ADDL_PELL_ELIG_IND as Additional_Pell_Eligble,
    RORSTAT_DEP_NO_PAR_DATA as Dep_NO_Par_Data,
    RORSTAT_POST_911_PELL_ELIG as Post_911_Pell_Eligible,
    RORSTAT_PBUD_INFO_ACCESS_IND as PBID_Info_Access,
    RORSTAT_HIGH_PELL_LEU_FLAG as High_Pell_Leu_Flag,
    RORSTAT_SS_INFO_ACCESS_IND as SS_Infro_Access,
    RORSTAT_XES XES,
    RORSTAT_XES_LOCK_IND as XES_Lock,
    RORSTAT_RECALC_IM_IND as Recaldc_IM,
    RORSTAT_SURROGATE_ID,
    RORSTAT_VERSION,
    RORSTAT_CFH_IND as CFH_Ind,
    RPRAWRD_AIDY_CODE as Award_Aidy,
    RPRAWRD_PIDM as Award_Pidm,
    RPRAWRD_FUND_CODE as Award_Fund_Code,
    RPRAWRD_AWST_CODE Award_AWST_Code,
    RPRAWRD_AWST_DATE Award_AWST_Date,
    RPRAWRD_SYS_IND as Award_Sys_Ind,
    RPRAWRD_ACTIVITY_DATE as Award_Activity_Date,
    RPRAWRD_LOCK_IND as Award_Lock,
    RPRAWRD_UNMET_NEED_OVRDE_IND Unmet_Need_Override,
    RPRAWRD_REPLACE_TFC_OVRDE_IND as Replace_TFC_Override,
    RPRAWRD_TREQ_OVRDE_IND as Treq_Override,
    RPRAWRD_FED_LIMIT_OVRDE_IND as Fed_Limit_Override,
    RPRAWRD_FUND_LIMIT_OVRDE_IND as Fund_Limit_Override,
    RPRAWRD_OFFER_EXP_DATE as Award_Offer_Exp_Date,
    RPRAWRD_ACCEPT_AMT as Award_Accept_Amount,
    RPRAWRD_ACCEPT_DATE as Award_Accept_Date,
    RPRAWRD_PAID_AMT as Award_Paid_Amount,
    RPRAWRD_PAID_DATE as Award_Paid_Date,
    RPRAWRD_ORIG_OFFER_AMT as Award_Original_Offer_Amount,
    RPRAWRD_ORIG_OFFER_DATE as Award_Original_Offer_Date,
    RPRAWRD_OFFER_AMT as Award_Offer_Amount,
    RPRAWRD_OFFER_DATE as Award_Offer_Date,
    RPRAWRD_DECLINE_AMT as Award_Decline_Amount,
    RPRAWRD_DECLINE_DATE as Award_Decline_Date,
    RPRAWRD_CANCEL_AMT as Award_Cancel_Amount,
    RPRAWRD_CANCEL_DATE as Award_Cancel_Date,
    RPRAWRD_INFO_ACCESS_IND as Info_Access,
    RPRAWRD_LAST_WEB_UPDATE as Last_Web_update,
    RPRAWRD_USER_ID as Award_User,
    RPRAWRD_OVERRIDE_YR_IN_COLL as Award_Override_Yr_in_College,
    RPRAWRD_DATA_ORIGIN as Award_Data_Origin,
    RPRAWRD_OVERRIDE_NO_PELL as Award_Override_No_Pell,
    RPRAWRD_OVERRIDE_FUND_RULE as Award_Override_Fund_Rule,
    RPRAWRD_SURROGATE_ID,
    RPRAWRD_VERSION,
    RPRAWRD_DISPSUM_OFFER_AMT as Award_Offer_Amount_Sum,
    RPRAWRD_DISPSUM_ACCEPTED_AMT as Award_Accepted_Amount_Sum,
    RPRAWRD_DISPSUM_PAID_AMT as Award_Paid_Amount_Sum,
    RPRAWRD_DISPSUM_NTS_OFFERED as Award_NTS_Offered_Sum,
    RPRAWRD_DISPSUM_PSA_OFFERED as Award_PSA_Offered_Sum,
    RPRAWRD_DISPSUM_CHA_OFFERED as Award_SHA_Offered_Sum,
    RPRAWRD_DISPSUM_CAG_OFFERED as Award_CAG_Offered_Sum,
    RBBABUD_AIDY_CODE as Budget_Aidy,
    RBBABUD_PIDM as Budget_Pidm,
    RBBABUD_TFC_IND as Budget_TFC,
    RBBABUD_BTYP_CODE as Budget_B_TYPE,
    RBBABUD_USER_ID as Budget_User,
    RBRACMP_AIDY_CODE as Campus_AIDY,
    RBRACMP_PIDM as Campus_PIDM,
    RBRACMP_BTYP_CODE as Campus_B_TYP,
    RBRACMP_COMP_CODE as Campus_Comp,
    RBRACMP_AMT as Campus_Amount,
    RBRACMP_USER_ID as Campus_User,
    RBRACMP_SYS_IND as Campus_SYS_IND,
    RBRACMP_ACTIVITY_DATE as Campus_Activity_Date,
    RBRACMP_DATA_ORIGIN as Campus_Data_Origin,
    RBRACMP_SURROGATE_ID,
    RBRACMP_VERSION,
    RBRACMP_DISPSUM_BUDJET as Campus_Budget_Sum

FROM
    FA_BUDGET_MEASURE B
    LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE

WHERE
    NULL IS NULL

      -- APPLICANT CONDITIONS
    AND SARADAP_TERM_CODE_ENTRY = STVTERM_CODE

--$addfilter

--$beginorder

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME
--$endorder

