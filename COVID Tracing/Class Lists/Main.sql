select s.id, s.lname || ', ' || coalesce(s.pref_fname, s.fname) || ' ' || s.mname as StudentName,
s.pref_fname, s.fname, s.mname, s.lname, e.email, reg.sfrstcr_credit_hr, reg.sfrstcr_rsts_code, cs.crn, cs.subj_code, cs.crse_numb, cs.seq_numb, cs.crse_title, ci.lfmi_name as PrimaryInstrName
from rel_course_sections cs
left outer join rel_course_instructors ci on ci.term_code = cs.term_code and ci.crn = cs.crn and ci.primary_ind = 'Y'
inner join sfrstcr reg on reg.sfrstcr_term_code = cs.term_code and cs.crn = reg.sfrstcr_crn
inner join rel_identity_student s on s.pidm = reg.sfrstcr_pidm
left outer join rel_email e on e.pidm = s.pidm and e.emal_code = 'SU'
 where cs.term_code = :ddSemester.STVTERM_CODE and reg.sfrstcr_rsts_code = 'RE'
 and cs.subj_code = upper(:txtSubj)
 and cs.crse_numb = :txtNumb
 order by cs.subj_code, cs.crse_numb, cs.seq_numb, s.lname, s.fname