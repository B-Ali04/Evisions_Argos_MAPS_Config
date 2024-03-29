-- term selection
select STVTERM_CODE AS CODE, STVTERM_DESC AS DESCR
FROM STVTERM
WHERE STVTERM_START_DATE > SYSDATE -120 AND STVTERM_START_DATE < SYSDATE + 150
and substr(stvterm_code,5,1) in ('1','3')
ORDER BY STVTERM_CODE DESC

select STVTERM_CODE AS CODE, STVTERM_DESC AS DESCR
FROM STVTERM
WHERE STVTERM_START_DATE > SYSDATE -120 AND STVTERM_START_DATE < SYSDATE + 150
and substr(stvterm_code,5,1) in ('2','4')
and STVTERM_CODE > :MinTerm.CODE
ORDER BY STVTERM_CODE DESC