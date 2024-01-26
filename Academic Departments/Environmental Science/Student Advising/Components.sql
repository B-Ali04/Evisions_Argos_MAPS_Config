-- term selection
select
(select to_char(SYSDATE, 'HH12:MI:SS') from dual) as CURRENT_TIME,
(select to_char(SYSDATE, 'DD Month YYYY') from dual) as CURRENT_DATE,
STVTERM.STVTERM_CODE,
STVTERM.STVTERM_DESC,
STVTERM.STVTERM_ACYR_CODE,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
from SATURN.STVTERM STVTERM
where stvterm_start_date < sysdate + 1865
and stvterm_start_date >= sysdate -9999
and STVTERM.STVTERM_CODE not in (000000, 190001)
order by STVTERM.STVTERM_CODE desc