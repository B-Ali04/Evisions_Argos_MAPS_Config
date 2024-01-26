-- Term Selection
    --starting aidy
select
CONCAT(TO_CHAR(:DateFrom,'YYYY'),'30') as RS_Term,
CONCAT(TO_CHAR(:DateFrom,'YYYY'),'40') as M_Term,
(select stvterm_fa_proc_yr from stvterm where stvterm_code=CONCAT(TO_CHAR(:DateFrom,'YYYY'),'40')) as aidy
from dual
    --ending aidy
select
CONCAT(TO_CHAR(:DateUpTo,'YYYY'),'10') as RS_Term,
CONCAT(TO_CHAR(:DateUpTo,'YYYY'),'20') as M_Term,
(select stvterm_fa_proc_yr from stvterm where stvterm_code=CONCAT(TO_CHAR(:DateUpTo,'YYYY'),'20')) as aidy
from dual

-- detail code selection
select TBBDETC_DETAIL_CODE AS CODE, TBBDETC_DESC AS DESCR from tbbdetc where tbbdetc_dcat_code = 'CSH' AND tbbdetc_type_ind='P'
and (CASE WHEN :RadOption.Main = 'Normal Refund' and :chkNormal=1
              THEN (CASE WHEN TBBDETC_DETAIL_CODE NOT IN ('RCAB','RCA2','RCA3','RCAF','REDC','RINA','RINC','RKDC','RMCK','RPAR') and TBBDETC_DETAIL_CODE NOT LIKE 'V%' THEN 1 ELSE 0 END) -- ,'VCAR','VDLS','VDLU','VINS','VLCK','VOID') THEN 1 ELSE 0 END)
--              ('RALA','RALT','RAMC','RCFD','RCHH','RCON','RCVT','RDAS','RDLG','RDLS','RDLU','REDC','REOP','RESD','RESF','REXC','REXS','RFND','RFUC','RFYF','RGRD','RGSA','RGSE','RINS','RKDB','RLCK','RMBM','RMCK','RNYA','RNYS','ROTH','RPAR','RPEL','RPRK','RPTT','RRFC','RSEO','RSIG','RSUA','RSUS','RTAE','RTAP','RTAS','RUSA','RVTA','RWTC') THEN 1 ELSE 0 END)
--          THEN CASE WHEN TBBDETC_DETAIL_CODE IN ('RFND','RLCK','RKDB','RINA','RINC','ROTH','RPAR') THEN 1 ELSE 0 END
          WHEN :RadOption = 'CARES Act' and :chkNormal=1
              THEN (CASE WHEN TBBDETC_DETAIL_CODE IN ('RCAB','RCA2','RCA3','RCAF') THEN 1 ELSE 0 END)
          WHEN :RadOption = 'CARES Paid' and :chkNormal=1
              THEN (CASE WHEN TBBDETC_DETAIL_CODE IN ('PCFP','PCA2','PCA3') THEN 1 ELSE 0 END)

          ELSE 1 END) = 1
ORDER BY TBBDETC_DETAIL_CODE

-- regsitrations pane
SELECT * FROM SFRSTCR
WHERE SFRSTCR_PIDM=:Report.PIDM AND
      SFRSTCR_TERM_CODE >= :MinTerm.RS_TERM and SFRSTCR_TERM_CODE <= :MaxTerm.M_Term

-- registration detail pane
SELECT * FROM TBRACCD
WHERE TBRACCD_PIDM=:Report.PIDM AND
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