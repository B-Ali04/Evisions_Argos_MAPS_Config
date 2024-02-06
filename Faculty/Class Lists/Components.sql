-- term selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

 -- department selection
 select stvdept_code, stvdept_desc
from stvdept
where stvdept_code not in ('0000','ART','SU', 'CHEM', 'ENSC') order by stvdept_desc