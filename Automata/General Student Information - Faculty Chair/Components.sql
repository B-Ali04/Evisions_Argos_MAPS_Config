-- term selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where --stvterm_start_date < sysdate + 365
        --and
        STVTERM.STVTERM_CODE not in (000000, 190001, 999999)
 order by STVTERM.STVTERM_CODE desc

 -- deperatment
select stvdept_code, stvdept_desc
from stvdept
where stvdept_desc  <> 'DO NOT USE' and stvdept_code not in ('SU','0000')
order by stvdept_desc