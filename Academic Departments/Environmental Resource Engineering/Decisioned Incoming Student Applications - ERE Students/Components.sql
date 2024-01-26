-- term selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate +  548
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

 -- decision code
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate +  548
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

 -- student type
select
STVSTYP_CODE as SGASTDN_STYP_CODE,
STVSTYP_DESC,
STVSTYP_DESC || ' (' ||  STVSTYP_CODE || ')' as STYP_DESC

from
STVSTYP

order by
STVSTYP_DESC

 -- student major
 select
STVMAJR_CODE as SGASTDN_MAJR_CODE,
STVMAJR_DESC,
STVMAJR_DESC || ' (' ||  STVMAJR_CODE || ')' as PROG_DESC

from
STVMAJR

where
STVMAJR_VALID_MAJOR_IND = 'Y'
AND STVMAJR_CODE NOT IN ('VIS', 'TNT', 'EHS')
order by
STVMAJR_DESC