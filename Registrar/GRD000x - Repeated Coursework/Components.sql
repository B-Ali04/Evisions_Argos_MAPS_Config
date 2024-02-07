-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

 -- grade code
 select 'All (Including blank)' gradeCode,
       1 orderSeq
from dual
union
select distinct SHRTCKG.SHRTCKG_GRDE_CODE_FINAL,
       2
  from SATURN.SHRTCKG SHRTCKG
 order by 2,1