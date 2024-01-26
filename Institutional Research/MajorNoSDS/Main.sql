select distinct s.subj_code || s.crse_numb || '-' || s.seq_numb as crsesect,
       s.subj_code as Abbreviation,
       s.crse_numb as CrseNmb,
       s.seq_numb as Sect,
       s.crse_title as Title,
       nvl(c.scbcrse_lec_hr_high,c.scbcrse_lec_hr_low) as MaxCredHrs,
       g.goradid_additional_id as EmployeeId,
       '' as JointId,
       0 as assignedInstructor
from rel_course_sections s
inner join rel_course_instructors i
      on i.crn = s.crn and i.term_code = s.term_code
inner join scbcrse c
      on c.scbcrse_eff_term = (select max(ic.scbcrse_eff_term) from scbcrse ic
                               where ic.scbcrse_subj_code = s.subj_code
                                AND    ic.scbcrse_crse_numb = s.crse_numb
                                AND    ic.scbcrse_eff_term <= s.term_code)
      and c.scbcrse_subj_code = s.subj_code and c.scbcrse_crse_numb = s.crse_numb
inner join goradid g
      on g.goradid_pidm = i.pidm and g.goradid_adid_code = 'SUID'
where s.term_code in ('202330','202340')
order by s.subj_code, s.crse_numb, s.seq_numb
