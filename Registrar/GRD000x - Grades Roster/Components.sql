-- Term Selection
select --* FROM STVTERM
       (select to_char(SYSDATE, 'HH12:MI:SS') from dual) as CURRENT_TIME,
       (select to_char(SYSDATE, 'DD Month YYYY') from dual) as CURRENT_DATE,
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

from
    SATURN.STVTERM STVTERM
where
    stvterm_start_date < sysdate + 366
    and stvterm_end_date >= sysdate - 365
    and STVTERM.STVTERM_CODE not in (000000, 190001)
    and STVTERM.STVTERM_ACYR_CODE > 2019

order by
    STVTERM.STVTERM_CODE desc