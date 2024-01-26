select
       case
        when i.pref_fname is not null and i.pref_fname <> i.fname
          then i.lname || ', ' || i.fname || ' (' || i.pref_fname || ')'
        else
           i.lfmi_name
       end as "Student",
       i.id as BannerID,
       suid.goradid_additional_id as SUID,
       s.sgbstdn_exp_grad_date,
       coalesce((select max(sfrstcr_term_code) from sfrstcr r
        where s.sgbstdn_pidm = r.sfrstcr_pidm and r.sfrstcr_rsts_code not in ('DD','DC')),(select max(shrtckn_term_code) from shrtckn h where h.shrtckn_pidm = s.sgbstdn_pidm))  as LastRegTerm,
       s.sgbstdn_levl_code
from sgbstdn s
inner join rel_identity_student i on i.pidm = s.sgbstdn_pidm
left outer join GORADID suid on suid.goradid_pidm = i.PIDM and suid.goradid_adid_code = 'SUID'
where
     s.sgbstdn_exp_grad_date = :lbGradDate.SGBSTDN_EXP_GRAD_DATE
and not exists
    (select * from rel_student_degree d where d.pidm = s.sgbstdn_pidm and d.levl_code = s.sgbstdn_levl_code)
and s.sgbstdn_term_code_eff = (select max(sgbstdn_term_code_eff) from sgbstdn s2 where s2.sgbstdn_pidm = s.sgbstdn_pidm and s2.sgbstdn_levl_code = s.sgbstdn_levl_code)
and s.sgbstdn_stst_code = 'AS'
and s.sgbstdn_exp_grad_date <> to_date('01011900','MMDDYYYY')
and s.sgbstdn_levl_code <> 'ND'
and s.sgbstdn_degc_code_1 = :lbDegLvl.DEGC_CODE
    --$addfilter
--$beginorder
order by sgbstdn_exp_grad_date desc,  i.lname
--$endorder