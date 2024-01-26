-- term selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 1865
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

 -- deperatment
 select distinct f_get_desc_fnc('STVDEPT', SCBCRSE_DEPT_CODE, 30) AS DEPT from scbcrse scbcrse order by dept