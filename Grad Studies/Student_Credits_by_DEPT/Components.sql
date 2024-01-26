-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 365

 order by STVTERM.STVTERM_CODE desc

-- department selection
SELECT
    stvdept_code AS dept_code,
    stvdept_desc AS dept_desc,
    stvdept_code||'-'||stvdept_desc AS display
FROM
    stvdept
WHERE
    stvdept_code <> 'ART'

UNION

SELECT
    'None' AS dept_code,
    '' AS dept_desc,
    'None Assigned' AS display
FROM
    dual
ORDER BY 3