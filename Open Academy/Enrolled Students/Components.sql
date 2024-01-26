-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

 --pos selection
  select stvmajr_code, stvmajr_desc, stvmajr_desc || ' (' || stvmajr_code || ')' as MajrDesc from stvmajr
where stvmajr_valid_major_ind = 'Y'
 order by majrdesc

 --level
 select stvclas_code, stvclas_desc
from stvclas
