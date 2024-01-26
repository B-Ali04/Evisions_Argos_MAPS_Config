select e.email,
       'RS' as cat
from rel_email e
where e.emal_code = 'SU'
and e.pidm in
    ( select distinct r.sfrstcr_pidm from sfrstcr r
      inner join sgbstdn s on s.sgbstdn_pidm = r.sfrstcr_pidm
         and s.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(r.sfrstcr_pidm, r.sfrstcr_term_code)
         and s.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS') and s.SGBSTDN_STST_CODE = 'AS'
         and not exists
            (select 1 from shrdgmr deg where deg.shrdgmr_levl_code = s.sgbstdn_levl_code
                    and deg.shrdgmr_pidm = s.sgbstdn_pidm and deg.shrdgmr_degs_code = 'GR'
                    and deg.shrdgmr_majr_code_1 = s.sgbstdn_majr_code_1)
         where r.sfrstcr_term_code = :sqlListSem.LISTSEM and r.sfrstcr_rsts_code = 'RE')

 --$newfilter

--$beginorder
--$endorder
