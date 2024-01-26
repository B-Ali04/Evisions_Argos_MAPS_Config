SELECT :selAIDY.AIDY AS AIDY,
       SPRIDEN_PIDM AS PIDM,
       CASE WHEN RORSTAT_APPL_RCVD_DATE IS NULL THEN 'NO' ELSE 'YES' END AS FAFSA_FILED,
       SPRIDEN_ID AS BANNERID,
       SPRIDEN_FIRST_NAME AS FIRST_NAME,
       SPRIDEN_LAST_NAME AS LAST_NAME,
       SPBPERS_PREF_FIRST_NAME AS PREF_NAME,
       CASE WHEN pers.goremal_pidm is not null THEN pers.goremal_email_address ELSE '' END as pers_email,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_STREET_LINE1
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_STREET_LINE1
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_STREET_LINE1 ELSE '' END END END AS ADDR1,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_STREET_LINE2
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_STREET_LINE2
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_STREET_LINE2 ELSE '' END END END AS ADDR2,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_STREET_LINE3
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_STREET_LINE3
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_STREET_LINE3 ELSE '' END END END AS ADDR3,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_CITY
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_CITY
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_CITY ELSE '' END END END AS CITY,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_STAT_CODE
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_STAT_CODE
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_STAT_CODE ELSE '' END END END AS STATE,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_ZIP
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_ZIP
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_ZIP ELSE '' END END END AS ZIP,
       CASE WHEN ma.SPRADDR_PIDM is not null THEN ma.SPRADDR_NATN_CODE
            ELSE CASE WHEN pr.SPRADDR_PIDM is not null THEN pr.SPRADDR_NATN_CODE
            ELSE CASE WHEN bi.SPRADDR_PIDM is not null THEN bi.SPRADDR_NATN_CODE ELSE '' END END END AS COUNTRY,
       CONCAT(SPRTELE_PHONE_AREA,SPRTELE_PHONE_NUMBER) AS CELLPHONE,
       ap1.saradap_admt_code as EARLY_DECISION,
       ap1.saradap_RESD_CODE AS RESID,
       ap1.saradap_STYP_CODE AS STYP,
       SGKCLAS.F_CLASS_CODE(ap1.saradap_pidm, ap1.saradap_levl_code, :selTerm.CODE) as ClassLevel,
       ap1.SARADAP_DEGC_CODE_1 AS DEGREE,
       ap1.SARADAP_MAJR_CODE_1 AS PROG_CODE,
       pg.smrprle_program_desc as PROGRAM,
       hs.sorhsch_gpa as HS_GPA,
       tg.sordegr_gpa_transferred as TR_GPA,
--       th.shrlgpa_gpa as TR_GPA,
       sat.SORTEST_TEST_SCORE AS SAT_COMP,
       act.SORTEST_TEST_SCORE AS ACT_COMP,
       ap2.sarappd_apdc_code as DECCD,
       ap2.sarappd_apdc_date as DECDT,
       th.SHRLGPA_HOURS_EARNED AS TR_CH,
       esf.SHRLGPA_HOURS_EARNED AS ESF_CH,
       FY_SFRSTCR_CREDIT_HR(SPRIDEN_PIDM,:selTerm.CODE) AS CUR_CH,
       ap1.saradap_CAMP_CODE AS CAMPUS,
       RCRAPP1_ORIG_COMP_DATE AS FAFSA_PROC_DT,
       RNVAND0_BUDGET_AMOUNT AS COST_OF_ATT,
       RNVAND0_EFC_AMT AS EFC_AMT,
       RORSTAT_PRI_SAR_PGI AS PELL_EFC,
--       RCRAPP2_PELL_PGI AS PELL_EFC,
--       RNVAND0_GROSS_NEED AS GROSS_NEED,
--       RNVAND0_UNMET_NEED AS UNMET_NEED,
--       RNVAND0_PELL_AWARD AS PELL_AWARD,
--       SHKSELS.F_SHRLGPA_VALUE(SPRIDEN_PIDM,SGBSTDN_LEVL_CODE,'GPA','I','V',NULL,NULL) AS CUM_GPA,
--       FY_SFRSTCR_CREDIT_HR(SPRIDEN_PIDM,:selMaxTerm.CODE) AS CUR_CH_M_OL,
--       ap1.saradap_STST_CODE AS STST,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('PSA')) AS PSA_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('PSA')) AS PSA_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('PSA')) AS PSA_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('PSA')) AS PSA_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('PSA')) AS PSA_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('NTS')) AS NTS_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('NTS')) AS NTS_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('NTS')) AS NTS_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('NTS')) AS NTS_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('NTS')) AS NTS_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('ASI')) AS ASI_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('ASI')) AS ASI_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('ASI')) AS ASI_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('ASI')) AS ASI_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('ASI')) AS ASI_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CHA')) AS CHA_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CHA')) AS CHA_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CHA')) AS CHA_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CHA')) AS CHA_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CHA')) AS CHA_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CAG')) AS CAG_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CAG')) AS CAG_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CAG')) AS CAG_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CAG')) AS CAG_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('CAG')) AS CAG_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('TMS')) AS TMS_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('TMS')) AS TMS_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('TMS')) AS TMS_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('TMS')) AS TMS_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('TMS')) AS TMS_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('191')) AS F191_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('191')) AS F191_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('191')) AS F191_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('191')) AS F191_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RPRAWRD_FUND_CODE IN ('191')) AS F191_PAID,
       (SELECT SUM(RPRAWRD_OFFER_AMT) FROM RPRAWRD INNER JOIN RFRFCAT ON (RFRFCAT_FUND_CODE=RPRAWRD_FUND_CODE) WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RFRFCAT_FCAT_CODE IN ('ENDOW')) AS ENDOW_OFFERED,
       (SELECT SUM(RPRAWRD_ACCEPT_AMT) FROM RPRAWRD INNER JOIN RFRFCAT ON (RFRFCAT_FUND_CODE=RPRAWRD_FUND_CODE) WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RFRFCAT_FCAT_CODE IN ('ENDOW')) AS ENDOW_ACCEPTED,
       (SELECT SUM(RPRAWRD_DECLINE_AMT) FROM RPRAWRD INNER JOIN RFRFCAT ON (RFRFCAT_FUND_CODE=RPRAWRD_FUND_CODE) WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RFRFCAT_FCAT_CODE IN ('ENDOW')) AS ENDOW_DECLINE,
       (SELECT SUM(RPRAWRD_CANCEL_AMT) FROM RPRAWRD INNER JOIN RFRFCAT ON (RFRFCAT_FUND_CODE=RPRAWRD_FUND_CODE) WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RFRFCAT_FCAT_CODE IN ('ENDOW')) AS ENDOW_CANCEL,
       (SELECT SUM(RPRAWRD_PAID_AMT) FROM RPRAWRD INNER JOIN RFRFCAT ON (RFRFCAT_FUND_CODE=RPRAWRD_FUND_CODE) WHERE RPRAWRD_PIDM=SPRIDEN_PIDM AND RPRAWRD_AIDY_CODE=:selAIDY.AIDY AND RFRFCAT_FCAT_CODE IN ('ENDOW')) AS ENDOW_PAID

       FROM saradap ap1
INNER JOIN SPRIDEN ON (ap1.saradap_pidm=SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL)
INNER JOIN SPBPERS ON (SPRIDEN_PIDM=SPBPERS_PIDM)
LEFT OUTER JOIN SHRLGPA th ON (SPRIDEN_PIDM=th.SHRLGPA_PIDM and th.SHRLGPA_GPA_TYPE_IND = 'T' and th.SHRLGPA_LEVL_CODE=ap1.saradap_LEVL_CODE)
LEFT OUTER JOIN SORDEGR tg ON (SPRIDEN_PIDM=tg.SORDEGR_PIDM and tg.SORDEGR_SBGI_CODE='000000')
LEFT OUTER JOIN SHRLGPA esf ON (SPRIDEN_PIDM=esf.SHRLGPA_PIDM and esf.SHRLGPA_GPA_TYPE_IND = 'I' and esf.SHRLGPA_LEVL_CODE=ap1.saradap_LEVL_CODE)
LEFT OUTER JOIN SPRTELE ON (SPRIDEN_PIDM=SPRTELE_PIDM AND SPRTELE_TELE_CODE='PC' AND SPRTELE_STATUS_IND IS NULL)
left join smrprle pg on (ap1.saradap_program_1 = pg.smrprle_program)
LEFT OUTER JOIN sarappd ap2 on (ap1.saradap_term_code_entry=ap2.sarappd_term_code_entry and ap1.saradap_pidm=ap2.sarappd_pidm and ap1.saradap_appl_no=ap2.sarappd_appl_no)
LEFT OUTER JOIN SORTEST sat on (ap1.saradap_pidm = sat.SORTEST_PIDM and sat.SORTEST_TESC_CODE='S05')
LEFT OUTER JOIN SORTEST act on (ap1.saradap_pidm = act.SORTEST_PIDM and act.SORTEST_TESC_CODE='A05')
LEFT OUTER JOIN RNVAND0 on (ap1.saradap_pidm=rnvand0_pidm and rnvand0_aidy_code=:selAIDY.AIDY)
left outer JOIN RCRAPP1 ON (RNVAND0_PIDM=RCRAPP1_PIDM AND RNVAND0_AIDY_CODE=RCRAPP1_AIDY_CODE AND RCRAPP1_CURR_REC_IND='Y')
left outer join rcrapp2 on (RNVAND0_PIDM=RCRAPP2_PIDM AND RCRAPP1_SEQ_NO=RCRAPP2_SEQ_NO AND RCRAPP1_INFC_CODE=RCRAPP2_INFC_CODE and RCRAPP1_AIDY_CODE=RCRAPP2_AIDY_CODE)
--inner join rcrapp3 on (RNVAND0_PIDM=RCRAPP3_PIDM AND RCRAPP1_SEQ_NO=RCRAPP3_SEQ_NO AND RCRAPP1_INFC_CODE=RCRAPP3_INFC_CODE and RCRAPP1_AIDY_CODE=RCRAPP3_AIDY_CODE)
--inner join rcrapp4 on (RNVAND0_PIDM=RCRAPP4_PIDM AND RCRAPP1_SEQ_NO=RCRAPP4_SEQ_NO AND RCRAPP1_INFC_CODE=RCRAPP4_INFC_CODE and RCRAPP1_AIDY_CODE=RCRAPP4_AIDY_CODE)
LEFT OUTER JOIN RORSTAT ON (SPRIDEN_PIDM=RORSTAT_PIDM AND RORSTAT_AIDY_CODE = :selAIDY.AIDY)
LEFT OUTER JOIN GOREMAL pers ON (SPRIDEN_PIDM=pers.GOREMAL_PIDM and pers.GOREMAL_EMAL_CODE='PERS' and pers.GOREMAL_STATUS_IND='A')
LEFT OUTER JOIN SPRADDR ma ON (SPRIDEN_PIDM=ma.SPRADDR_PIDM and ma.SPRADDR_ATYP_CODE='MA' AND ma.SPRADDR_SEQNO= (SELECT MAX(m.SPRADDR_SEQNO) AS MAXSEQ FROM SPRADDR m WHERE m.SPRADDR_PIDM=SPRIDEN.SPRIDEN_PIDM and m.SPRADDR_ATYP_CODE='MA' and m.SPRADDR_STATUS_IND IS NULL))
LEFT OUTER JOIN SPRADDR pr ON (SPRIDEN_PIDM=pr.SPRADDR_PIDM and pr.SPRADDR_ATYP_CODE='PR' AND pr.SPRADDR_SEQNO= (SELECT MAX(m.SPRADDR_SEQNO) AS MAXSEQ FROM SPRADDR m WHERE m.SPRADDR_PIDM=SPRIDEN.SPRIDEN_PIDM and m.SPRADDR_ATYP_CODE='PR' and m.SPRADDR_STATUS_IND IS NULL))
LEFT OUTER JOIN SPRADDR bi ON (SPRIDEN_PIDM=bi.SPRADDR_PIDM and bi.SPRADDR_ATYP_CODE='BI' AND bi.SPRADDR_SEQNO= (SELECT MAX(m.SPRADDR_SEQNO) AS MAXSEQ FROM SPRADDR m WHERE m.SPRADDR_PIDM=SPRIDEN.SPRIDEN_PIDM and m.SPRADDR_ATYP_CODE='BI' and m.SPRADDR_STATUS_IND IS NULL))
LEFT OUTER JOIN SORHSCH hs ON (SPRIDEN_PIDM=hs.SORHSCH_PIDM)
WHERE ap1.saradap_term_code_entry = :selTerm.CODE
and (CASE WHEN ap2.sarappd_pidm is null THEN 1
          WHEN ap2.sarappd_seq_no = (select max(b.sarappd_seq_no) from sarappd b where b.sarappd_pidm=ap1.saradap_pidm and b.sarappd_appl_no=ap1.saradap_appl_no and b.sarappd_term_code_entry=ap1.saradap_term_code_entry) THEN 1
          ELSE 0 END) = 1
--and RNVAND0_AIDY_CODE=:selAIDY.AIDY
--AND   RCRAPP1_AIDY_CODE=:selAIDY.AIDY
AND   ap1.saradap_STYP_CODE=:selSTYP.STYP_CODE
--AND   ap1.saradap_STST_CODE=:selSTST.STST_CODE
--AND   SGBSTDN_TERM_CODE_EFF = (SELECT MAX(b.SGBSTDN_TERM_CODE_EFF) AS MAXTERM FROM SGBSTDN b where SGBSTDN.SGBSTDN_PIDM=b.SGBSTDN_PIDM and b.SGBSTDN_TERM_CODE_EFF < :selExclTerm.CODE)