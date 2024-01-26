SELECT PIDM, SPRIDEN_ID AS BANNERID, SPRIDEN_LAST_NAME AS LAST_NAME, SPRIDEN_FIRST_NAME AS FIRST_NAME,
       SPBPERS_PREF_FIRST_NAME AS PREF_NAME,
       FUND_CODE, RFRBASE_FUND_TITLE AS FUND_TITLE,
       RFRBASE_XREF_VALUE AS ACCOUNT,
       FALL_AMT, SPRING_AMT, SUMMER_AMT, TOTAL_AMT,
       GOREMAL_EMAIL_ADDRESS AS SU_EMAIL
FROM
(SELECT PIDM, FUND_CODE, SUM(FALL_AMT) AS FALL_AMT, SUM(SPRING_AMT) AS SPRING_AMT, SUM(SUMMER_AMT) AS SUMMER_AMT, AVG(TOTAL_AMT) AS TOTAL_AMT
FROM
(SELECT RPRATRM_PIDM AS PIDM,
       RFRBASE_FUND_CODE AS FUND_CODE,
       case WHEN substr(rpratrm_period,5,2) in ('10','20') THEN RPRATRM_PAID_AMT ELSE 0 END AS FALL_AMT,
       case WHEN substr(rpratrm_period,5,2) in ('30','40') THEN RPRATRM_PAID_AMT ELSE 0 END AS SPRING_AMT,
       case WHEN substr(rpratrm_period,5,2) in ('50') THEN RPRATRM_PAID_AMT ELSE 0 END AS SUMMER_AMT,
       RPRAWRD_PAID_AMT AS TOTAL_AMT
       FROM   RPRAWRD
       INNER JOIN RFRBASE ON (RPRAWRD_FUND_CODE=RFRBASE_FUND_CODE)
       INNER JOIN RFRFCAT ON (RFRBASE_FUND_CODE=RFRFCAT_FUND_CODE)
       INNER JOIN RPRATRM ON (RPRATRM_PIDM=RPRAWRD_PIDM AND RPRATRM_AIDY_CODE=RPRAWRD_AIDY_CODE AND RFRBASE_FUND_CODE=RPRATRM_FUND_CODE)
       WHERE RPRAWRD_AIDY_CODE=:selAidY.CODE
       and RFRFCAT_FCAT_CODE=:selCategory.FCAT
       AND RPRAWRD_PAID_AMT <> 0)
GROUP BY PIDM, FUND_CODE)
INNER JOIN SPRIDEN ON (PIDM=SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL)
INNER JOIN RFRBASE ON (FUND_CODE=RFRBASE_FUND_CODE)
INNER JOIN SPBPERS ON (PIDM=SPBPERS_PIDM)
LEFT OUTER JOIN GOREMAL ON (PIDM=GOREMAL_PIDM AND GOREMAL_EMAL_CODE='SU')
ORDER BY FUND_CODE, LAST_NAME, FIRST_NAME, BANNERID