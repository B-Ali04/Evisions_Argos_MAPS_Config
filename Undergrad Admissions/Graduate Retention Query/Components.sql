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

--student type
select
STVSTYP_CODE,
STVSTYP_DESC,
STVSTYP_DESC || ' (' ||  STVSTYP_CODE || ')' as STYP_DESC

from
STVSTYP
/*
where
STVSTYP_CODE not in ('N', 'G', 'D', 'R')
*/
order by
STVSTYP_SURROGATE_ID, STVSTYP_DESC