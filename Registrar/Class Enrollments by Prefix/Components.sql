-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

 -- prefix selection
 select
    stvsubj_code as code,
    stvsubj_desc as display
from
    stvsubj
where
    stvsubj_disp_web_ind = 'Y'
UNION
select
    '-All-',
    '-All-'
from
    dual
order by 1