/*select c.scbcrse_subj_code,
       c.scbcrse_crse_numb,
       c.scbcrse_title,
       d.scbdesc_text_narrative,
       c.scbcrse_credit_hr_low,
       c.scbcrse_credit_hr_high,
       c.scbcrse_credit_hr_ind,
       c.scbcrse_eff_term
from scbcrse c
inner join scbdesc d on d.scbdesc_subj_code = c.scbcrse_subj_code and d.scbdesc_crse_numb = c.scbcrse_crse_numb and d.scbdesc_term_code_eff = c.scbcrse_eff_term
where c.scbcrse_coll_code = 'EF' and c.scbcrse_csta_code = 'A'
     and d.scbdesc_text_narrative is not null
order by c.scbcrse_subj_code, c.scbcrse_crse_numb */

select c.scbcrse_subj_code,
       c.scbcrse_crse_numb,
       c.scbcrse_title,
       d.scbdesc_text_narrative,
       c.scbcrse_credit_hr_low,
       c.scbcrse_credit_hr_high,
       c.scbcrse_credit_hr_ind,
       c.scbcrse_eff_term
from scbcrse c
left outer join scbdesc d on d.scbdesc_subj_code = c.scbcrse_subj_code and d.scbdesc_crse_numb = c.scbcrse_crse_numb and d.scbdesc_term_code_eff = c.scbcrse_eff_term
where c.scbcrse_coll_code in ('EF','SU') and c.scbcrse_csta_code = 'A'
     --and d.scbdesc_text_narrative is not null
     and c.scbcrse_eff_term = (select max(c2.scbcrse_eff_term) from scbcrse c2 where c2.scbcrse_subj_code = c.scbcrse_subj_code and c2.scbcrse_crse_numb = c.scbcrse_crse_numb)
order by c.scbcrse_subj_code, c.scbcrse_crse_numb