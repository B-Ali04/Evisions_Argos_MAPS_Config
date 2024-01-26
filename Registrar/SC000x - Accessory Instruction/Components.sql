-- Term Selection
select STVTERM.STVTERM_CODE,
       STVTERM.STVTERM_DESC,
(STVTERM.STVTERM_CODE || ' - ' ||
       STVTERM.STVTERM_DESC) as TermDesc
        from SATURN.STVTERM STVTERM
        where stvterm_start_date < sysdate + 1865
        and stvterm_start_date >= sysdate -9999
        and STVTERM.STVTERM_CODE not in (000000, 190001)
 order by STVTERM.STVTERM_CODE desc

-- course id
select distinct ssbsect_crse_numb , ssbsect_subj_code, ssbsect_sicas_camp_course_id as Course_key
 from ssbsect order by ssbsect_subj_code
