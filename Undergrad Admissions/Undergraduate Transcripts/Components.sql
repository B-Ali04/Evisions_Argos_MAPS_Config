-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 548
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

-- student type
select
STVSTYP_CODE,
STVSTYP_DESC,
STVSTYP_DESC || ' (' ||  STVSTYP_CODE || ')' as STYP_DESC

from
STVSTYP

where
STVSTYP_CODE not in ('N', 'G', 'D', 'R')

order by
STVSTYP_SURROGATE_ID, STVSTYP_DESC

-- transcript type
select
distinct SORPCOL_ADMR_CODE,
f_get_desc_fnc('STVADMR', SORPCOL_ADMR_CODE, 30) as ADMR_DESC,
--f_get_desc_fnc('STVADMR', SORPCOL_ADMR_CODE, 30) || ' (' ||  SORPCOL_ADMR_CODE || ')' as ADMR_CODE_DESC
case
  when SORPCOL_ADMR_CODE is null then 'No Transcript Found'
    else f_get_desc_fnc('STVADMR', SORPCOL_ADMR_CODE, 30) || ' (' ||  SORPCOL_ADMR_CODE || ')'
      end as ADMR_CODE_DESC
from
SORPCOL SORPCOL
/*
where
SORPCOL_ADMR_CODE is not null
*/
order by
SORPCOL_ADMR_CODE

-- transfer score
select
distinct SHRTRCE.SHRTRCE_GRDE_CODE as GRDE_CODE

from SHRTRCE SHRTRCE

where
SHRTRCE.SHRTRCE_GRDE_CODE in ('TR', 'TI')