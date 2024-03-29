-- Min Term Selection
select STVTERM_CODE AS CODE, STVTERM_DESC AS DESCR
FROM STVTERM
WHERE STVTERM_START_DATE > SYSDATE -180 AND STVTERM_START_DATE < SYSDATE + 240
and substr(stvterm_code,5,1) in ('2','4','5')
ORDER BY STVTERM_CODE DESC

-- Max Term Selection
select STVTERM_CODE AS CODE, STVTERM_DESC AS DESCR
FROM STVTERM
WHERE STVTERM_START_DATE > SYSDATE -180 AND STVTERM_START_DATE < SYSDATE + 240
and substr(stvterm_code,5,1) in ('2','4','5')
ORDER BY STVTERM_CODE DESC