-- term selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where --stvterm_start_date < sysdate + 365
        --and
        STVTERM.STVTERM_CODE not in (000000, 190001, 999999)
 order by STVTERM.STVTERM_CODE desc