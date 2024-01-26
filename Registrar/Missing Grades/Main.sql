select * from sfrstcr cr
inner join rel_identity i on cr.sfrstcr_pidm = i.pidm
inner join rel_course_sections cs on cs.crn = cr.sfrstcr_crn and cs.term_code = cr.sfrstcr_term_code
left outer join rel_course_instructors ci on ci.crn = cs.crn and cs.term_code = ci.term_code and ci.primary_ind = 'Y'
inner join goradid suid on suid.goradid_pidm = i.pidm and suid.goradid_adid_code = 'SUID'
where cr.sfrstcr_term_code = :ddSemester.STVTERM_CODE
and cr.sfrstcr_grde_code is null
and cr.sfrstcr_rsts_code = 'RE'
--$addfilter
--$beginorder
order by cs.subj_code, cs.crse_numb, cs.seq_numb
--$endorder