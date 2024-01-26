-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

 --student type
  select stvstyp_code, stvstyp_desc, stvstyp_desc || ' (' || stvstyp_code || ')' as TypeDesc
 from stvstyp
 order by TypeDesc

