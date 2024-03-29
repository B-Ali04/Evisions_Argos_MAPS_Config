-- Term Selection
select STVTERM_CODE AS CODE, STVTERM_DESC AS DESCR
FROM STVTERM
WHERE STVTERM_CODE >= '202110' AND STVTERM_START_DATE < SYSDATE + 360
--and substr(stvterm_code,5,1) in ('1','3','5')
ORDER BY STVTERM_CODE DESC

-- Student Type
SELECT STVSTYP_CODE AS STYP_CODE, STVSTYP_DESC AS STYP_DESC
FROM STVSTYP
ORDER BY STVSTYP_CODE

--aidy
select STVTERM_CODE AS CODE, TO_CHAR(STVTERM_FA_PROC_YR) AS AIDY
from stvterm where stvterm_code= :selTerm.CODE

