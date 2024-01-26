-- campus selection
select distinct
       stvsbgi_code,
       stvsbgi_desc
from stvsbgi
where stvsbgi_type_ind = 'C'
--and   upper(stvsbgi_desc) like '%SUNY%'
order by 1

-- term
select stvterm_code AS "Code",
       stvterm_desc AS "Desc"
from   stvterm
where  stvterm_start_date < sysdate+365
and    stvterm_end_date < sysdate+365
order by 1 desc
