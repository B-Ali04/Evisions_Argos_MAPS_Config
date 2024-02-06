select sirasgn_term_code as Term_Code, sirasgn_crn as CRN, concat(concat(concat(ssbsect_subj_code,ssbsect_crse_numb),'-'),ssbsect_seq_numb) as Course_Section,
case when ssbsect_crse_title is null then c.scbcrse_title else ssbsect_crse_title end as Course_Title,
ssbsect_camp_code as Campus

from sirasgn
left outer join ssbsect on (sirasgn_term_code=ssbsect_term_code and sirasgn_crn=ssbsect_crn)
left outer join scbcrse c on (ssbsect_subj_code=c.scbcrse_subj_code and ssbsect_crse_numb=c.scbcrse_crse_numb and c.scbcrse_eff_term = (select max(cb.scbcrse_eff_term) from scbcrse cb where cb.scbcrse_subj_code=c.scbcrse_subj_code and cb.scbcrse_crse_numb=c.scbcrse_crse_numb and cb.scbcrse_eff_term <= :selTerm))

where sirasgn_term_code=:selTerm and sirasgn_pidm=:selUser.PIDM