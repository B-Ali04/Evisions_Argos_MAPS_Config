-- Minor
select stvmajr_code, stvmajr_desc, stvmajr_desc || ' (' || stvmajr_code || ')' as majr  from stvmajr where stvmajr_valid_minor_ind = 'Y'

order by stvmajr_desc

-- Min Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

-- Max Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc