-- Term Selection
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

-- decision code
select
distinct SARAPPD_APDC_CODE as SAAADMS_APDC_CODE,
f_get_desc_fnc('STVAPDC', SARAPPD_APDC_CODE, 30) as APDC_DESC,
f_get_desc_fnc('STVAPDC', SARAPPD_APDC_CODE, 30) || ' (' ||  SARAPPD_APDC_CODE || ')' as APDC_CODE_DESC

from
SARAPPD

order by
SARAPPD_APDC_CODE