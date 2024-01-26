select s.ssbsect_term_code, s.ssbsect_crn, s.ssbsect_subj_code, s.ssbsect_crse_numb, s.ssbsect_seq_numb as Sect, c.scbcrse_title as BaseTitle,
       s.ssbsect_crse_title
from ssbsect s
inner join scbcrse c on c.scbcrse_subj_code = s.ssbsect_subj_code and c.scbcrse_crse_numb = s.ssbsect_crse_numb
where s.ssbsect_term_code = :ddSemester.STVTERM_CODE and c.scbcrse_coll_code = 'SU'
