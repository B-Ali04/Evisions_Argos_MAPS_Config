SELECT SPRIDEN_ID AS BANNERID, SPRIDEN_LAST_NAME AS LAST_NAME, SPRIDEN_FIRST_NAME AS FIRST_NAME,
       ts.sgbstdn_resd_code as Residency,
       case when SPBPERS_SEX IN ('M','F') THEN SPBPERS_SEX ELSE 'X' END AS GENDER,
       SPBPERS_BIRTH_DATE AS DOB,
       case when spbpers_ethn_cde = '1' then 'Not Hispanic or Latino'
             when spbpers_ethn_cde = '2' then 'Hispanic or Latino'
             else '' end as Ethnicity,
       aggr.Race_Desc as Race,
       aggr.Race_Code as Race_Codes,
       aggr.RRAC_Code as RRac_Codes,
       ts.sgbstdn_levl_code as Deg_Level,
       ts.sgbstdn_degc_code_1 as Degree,
       pg.smrprle_program_desc as Program,
       SGKCLAS.F_CLASS_CODE(ts.sgbstdn_pidm, ts.sgbstdn_levl_code, :MaxTerm.M_Term) as Class_Yr,
       ts.sgbstdn_exp_grad_date as ExpDegCmplDt,
       SHKSELS.F_SHRLGPA_VALUE(ts.sgbstdn_PIDM,ts.sgbstdn_levl_code,'GPA','I','V',NULL,NULL) AS CUM_GPA,
       (case when et.SFBETRM_TERM_CODE IS NOT NULL THEN et.SFBETRM_ESTS_CODE ELSE ts.SGBSTDN_STST_CODE END) AS Enr_Status,
       (case when dg.SHRDGMR_TERM_CODE_GRAD IS NOT NULL THEN dg.SHRDGMR_TERM_CODE_GRAD WHEN et.SFBETRM_TERM_CODE IS NOT NULL THEN et.SFBETRM_TERM_CODE ELSE ts.SGBSTDN_TERM_CODE_EFF END) AS Status_AsOf,
--       et.SFBETRM_TERM_CODE AS Status_AsOf,
       dg.shrdgmr_degs_code as Deg_Status,
       PCFP_DATE, PCFP_AMOUNT,
       PCA2_DATE, PCA2_AMOUNT, PCA3_DATE, PCA3_AMOUNT,
       TUIT_DATE, TUIT_AMOUNT,
       (SELECT SUM(SFRSTCR_CREDIT_HR) FROM SFRSTCR WHERE SFRSTCR_PIDM=SPRIDEN_PIDM AND SFRSTCR_RSTS_CODE='RE' AND SFRSTCR_TERM_CODE IN (:MinTerm.RS_Term,:MinTerm.M_Term)) AS SPR_CR_HRS,
       (SELECT SUM(SFRSTCR_CREDIT_HR) FROM SFRSTCR WHERE SFRSTCR_PIDM=SPRIDEN_PIDM AND SFRSTCR_RSTS_CODE='RE' AND SFRSTCR_TERM_CODE IN (:MaxTerm.RS_Term,:MaxTerm.M_Term)) AS FAL_CR_HRS,
--     EducationBudget,
--     TotalFamilyContribution,
--     FinancialNeed,
       RNVAND0_AIDY_CODE AS AIDY,
       RNVAND0_BUDGET_AMOUNT AS COST_OF_ATT,
       RNVAND0_EFC_AMT AS EFC_AMT,
       RNVAND0_GROSS_NEED AS GROSS_NEED,
       RNVAND0_UNMET_NEED AS UNMET_NEED,
----       RNVAND0_PELL_AWARD AS PELL_AWARD,
       RCRAPP2_PELL_PGI AS PELL_EFC,
       (SELECT SUM(TBRACCD_AMOUNT) FROM TBRACCD WHERE TBRACCD_PIDM=SPRIDEN_PIDM AND TBRACCD_DETAIL_CODE='ZPEL' AND TBRACCD_TRANS_DATE >= TO_DATE(TO_CHAR(:DateFrom,'MM/DD/YYYY'),'MM/DD/YYYY') AND TBRACCD_TRANS_DATE < TO_DATE(TO_CHAR(:DateUpto,'MM/DD/YYYY'),'MM/DD/YYYY')) AS PELL_AMT,
       (case WHEN dg.shrdgmr_degs_code = 'GR' THEN 2 WHEN et.SFBETRM_ESTS_CODE = 'WS' THEN 4 ELSE 3 END) AS COL,
       1 AS CTR,
       '' as levl_cat,
       '' as pell_cat,
       '' as FTPT_cat,
       '' as Race_cat,
       '' as gender_cat,
       '' as age_cat,
       TO_CHAR(:DateUpto-1,'MM/DD/YYYY') AS AS_OF,
       CASE WHEN SPBPERS_BIRTH_DATE IS NULL THEN 0 ELSE ROUND((:DateUpto-SPBPERS_BIRTH_DATE)/365,2) END AS AGE,
       spriden_PIDM as PIDM

       FROM (
       SELECT PIDM,
       MAX(PCFP_DATE) AS PCFP_DATE, SUM(PCFP_AMOUNT) AS PCFP_AMOUNT,
       MAX(PCA2_DATE) AS PCA2_DATE, SUM(PCA2_AMOUNT) AS PCA2_AMOUNT,
       MAX(PCA3_DATE) AS PCA3_DATE, SUM(PCA3_AMOUNT) AS PCA3_AMOUNT,
       MAX(TUIT_DATE) AS TUIT_DATE, SUM(TUIT_AMOUNT) AS TUIT_AMOUNT
       FROM (
       SELECT
       PIDM,
       CASE WHEN CODE='PCFP' THEN TRANS_DATE ELSE '' END AS PCFP_DATE,
       CASE WHEN CODE='PCFP' THEN AMOUNT ELSE 0 END AS PCFP_AMOUNT,
       CASE WHEN CODE='PCA2' THEN TRANS_DATE ELSE '' END AS PCA2_DATE,
       CASE WHEN CODE='PCA2' THEN AMOUNT ELSE 0 END AS PCA2_AMOUNT,
       CASE WHEN CODE='PCA3' THEN TRANS_DATE ELSE '' END AS PCA3_DATE,
       CASE WHEN CODE='PCA3' THEN AMOUNT ELSE 0 END AS PCA3_AMOUNT,
       CASE WHEN CODE IN ('TUIT','XXXX','YYYY') THEN TRANS_DATE ELSE '' END AS TUIT_DATE,
       CASE WHEN CODE IN ('TUIT','XXXX','YYYY') THEN AMOUNT ELSE 0 END AS TUIT_AMOUNT
       FROM
       (SELECT
       TBRACCD_PIDM AS PIDM,
       TBRACCD_DETAIL_CODE AS CODE,
       TO_CHAR(MAX(TBRACCD_TRANS_DATE),'MM/DD/YYYY') AS TRANS_DATE,
       SUM(TBRACCD_AMOUNT) AS AMOUNT
       FROM TBRACCD
       WHERE
      (CASE WHEN :chkPopulate = 1 then --AND :chkAllStudents = 1 then
            case when TBRACCD_DETAIL_CODE IN ('TUIT','XXXX','YYYY') AND TBRACCD_TERM_CODE >= :MinTerm.RS_TERM and TBRACCD_TERM_CODE <= :MaxTerm.M_Term THEN 1
                 when TBRACCD_DETAIL_CODE IN ('PCFP','PCA2','PCA3') AND TBRACCD_TRANS_DATE >= TO_DATE(TO_CHAR(:DateFrom,'MM/DD/YYYY'),'MM/DD/YYYY') AND TBRACCD_TRANS_DATE < TO_DATE(TO_CHAR(:DateUpto,'MM/DD/YYYY'),'MM/DD/YYYY') THEN 1
                 ELSE 0
                 END
   --         WHEN :chkPopulate = 1 AND :chkAllStudents <> 1 then
   --              CASE when TBRACCD_DETAIL_CODE IN ('PCFP','PCA2','PCA3') AND TBRACCD_TRANS_DATE >= TO_DATE(TO_CHAR(:DateFrom,'MM/DD/YYYY'),'MM/DD/YYYY') AND TBRACCD_TRANS_DATE < TO_DATE(TO_CHAR(:DateUpto,'MM/DD/YYYY'),'MM/DD/YYYY') THEN 1
   --              ELSE 0
   --              END
            ELSE 0
            END)=1
       GROUP BY TBRACCD_PIDM, TBRACCD_DETAIL_CODE
       ORDER BY TBRACCD_PIDM, TBRACCD_DETAIL_CODE))
       GROUP BY PIDM )
       INNER JOIN SPRIDEN ON (PIDM=SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL)
       INNER JOIN SPBPERS ON (PIDM=SPBPERS_PIDM)
       INNER JOIN SGBSTDN ts on (SPRIDEN_PIDM=ts.SGBSTDN_PIDM and ts.SGBSTDN_TERM_CODE_EFF=(SELECT Max(b.SGBSTDN_TERM_CODE_EFF) FROM SGBSTDN b WHERE ts.SGBSTDN_PIDM=b.SGBSTDN_PIDM AND b.SGBSTDN_TERM_CODE_EFF <= :MaxTerm.M_Term))
       LEFT OUTER JOIN SFBETRM et on (SPRIDEN_PIDM=et.SFBETRM_PIDM and et.SFBETRM_TERM_CODE=(SELECT Max(b.SFBETRM_TERM_CODE) FROM SFBETRM b WHERE et.SFBETRM_PIDM=b.SFBETRM_PIDM AND b.SFBETRM_TERM_CODE <= :MaxTerm.M_Term))
       LEFT OUTER JOIN agg_race aggr on (SPRIDEN_pidm=aggr.PIDM)
       LEFT OUTER JOIN smrprle pg on (ts.sgbstdn_program_1=pg.smrprle_program)
       LEFT OUTER JOIN RNVAND0 ON (spriden_PIDM=RNVAND0_PIDM AND RNVAND0_AIDY_CODE=(select max(b.RNVAND0_AIDY_CODE) FROM RNVAND0 b where spriden_pidm=b.RNVAND0_PIDM AND b.RNVAND0_AIDY_CODE >= :MinTerm.AIDY and b.RNVAND0_AIDY_CODE <= :MaxTerm.AIDY and b.RNVAND0_BUDGET_AMOUNT > 0))
       LEFT OUTER JOIN RORSTAT ON (RNVAND0_PIDM=RORSTAT_PIDM AND RNVAND0_AIDY_CODE=RORSTAT_AIDY_CODE)
       left outer JOIN RCRAPP1 ON (RNVAND0_PIDM=RCRAPP1_PIDM AND RCRAPP1_CURR_REC_IND='Y' AND RCRAPP1_AIDY_CODE=RNVAND0_AIDY_CODE)
       left outer join rcrapp2 on (RNVAND0_PIDM=RCRAPP2_PIDM AND RCRAPP1_SEQ_NO=RCRAPP2_SEQ_NO AND RCRAPP1_INFC_CODE=RCRAPP2_INFC_CODE and RCRAPP1_AIDY_CODE=RCRAPP2_AIDY_CODE)
       LEFT OUTER JOIN SHRDGMR dg on (spriden_pidm=dg.shrdgmr_pidm and dg.shrdgmr_degs_code='GR' and dg.shrdgmr_term_code_grad >= :MinTerm.RS_Term and dg.shrdgmr_term_code_grad <= :MaxTerm.M_Term)
       WHERE (CASE WHEN PCFP_AMOUNT > 0 THEN 1 WHEN PCA2_AMOUNT > 0 THEN 1 WHEN PCA3_AMOUNT > 0 THEN 1
                   ELSE CASE WHEN :chkAllStudents=1 THEN CASE WHEN TUIT_DATE IS NOT NULL AND SGBSTDN_STYP_CODE <> 'X' AND SGBSTDN_LEVL_CODE IN ('UG','GR') THEN 1 ELSE 0 END
                   ELSE 0 END END)=1