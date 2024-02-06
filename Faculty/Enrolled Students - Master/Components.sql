-- term selection
select --* FROM STVTERM
       STVTERM_FA_PROC_YR,
       STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc,
       case
  when STVTERM_ACYR_CODE = 2019 then 'DO NOT USE'
    else STVTERM.STVTERM_ACYR_CODE
      end as AIDY_CODE,
       ' ' || (STVTERM_ACYR_CODE - 1 )|| ' - '|| STVTERM_ACYR_CODE as Grad_Year --|| ' Academic Year' as Acad_Year

from SATURN.STVTERM STVTERM
where stvterm_start_date < sysdate + 366
and stvterm_end_date >= sysdate - 365
and STVTERM.STVTERM_CODE not in (000000, 190001)
and STVTERM.STVTERM_ACYR_CODE > 2019
--and stvterm_code = (select max(stvterm_code) from stvterm a where a.STVTERM_FA_PROC_YR = STVTERM.STVTERM_FA_PROC_YR)
 order by STVTERM.STVTERM_CODE desc
/*
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc,
       STVTERM.STVTERM_ACYR_CODE as AIDY_CODE

from SATURN.STVTERM STVTERM
where stvterm_start_date < sysdate + 1865
and stvterm_start_date >= sysdate -9999
and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc
*/