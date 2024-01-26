-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

 -- subject code
select distinct
    shrtckn_subj_code as code,
    shrtckn_subj_code||'-'||stvsubj_desc as display
from
    stvsubj,
    shrtckn
where
    stvsubj_code = shrtckn_subj_code
UNION
select
    '-All-',
    '-All-'
from
    dual
order by 1

 --course number
select distinct
    shrtckn_crse_numb as code
from
    shrtckn
where
    shrtckn_subj_code = :main_LB_subj.CODE
UNION
select
    '-All-'
from
    dual
order by 1