select s.ssbsect_term_code,
       stvterm_desc term_desc,
       s.ssbsect_subj_code || ' ' || s.ssbsect_crse_numb as Course,
       s.ssbsect_seq_numb as CrsSection,
       case
         when s.ssbsect_crse_title is not null then
          s.ssbsect_crse_title
         else
          (select c.scbcrse_title
             from scbcrse c
            where c.scbcrse_subj_code = s.ssbsect_subj_code
              and c.scbcrse_crse_numb = s.ssbsect_crse_numb
              and c.scbcrse_eff_term = (
                  select
                      max(d.scbcrse_eff_term)
                  from
                      scbcrse d
                  where
                      d.scbcrse_subj_code = s.ssbsect_subj_code
                  and d.scbcrse_crse_numb = s.ssbsect_crse_numb))
       end as CrsTitle,
       ci.lfmi_name as PrimaryInstrName,
       (select count(distinct r.sfrstcr_pidm)
          from sfrstcr r
         where r.sfrstcr_term_code = s.ssbsect_term_code
           and r.sfrstcr_crn = s.ssbsect_crn
           and r.sfrstcr_rsts_code = 'RE') as CrsEnrollment,
       s.ssbsect_crn as CRN
  from ssbsect s
  left outer join rel_course_instructors ci
    on ci.term_code = s.ssbsect_term_code
   and ci.crn = s.ssbsect_crn
   and ci.primary_ind = 'Y'
  inner join stvterm on stvterm_code = ssbsect_term_code
 where s.ssbsect_term_code = :main_LB_term.STVTERM_CODE
   and ('-All-' = :main_LB_prefix.CODE
         or ('-All-' <> :main_LB_prefix.CODE
            and s.ssbsect_subj_code = :main_LB_prefix.CODE))

order by
    s.ssbsect_term_code desc,
    s.ssbsect_subj_code,
    s.ssbsect_crse_numb,
    s.ssbsect_seq_numb
