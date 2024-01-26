WITH main_1 AS(
select *
  from (select fa.sovlfos_pidm as sPidm,
                fa.*,
                case
                  when i.pref_fname is not null and i.pref_fname <> i.fname then
                   i.lname || ', ' || i.fname || ' (' || i.pref_fname || ')'
                  else
                   f_format_name(i.pidm, 'LF')
                end as StudentName,
                i.*,
                su.goradid_additional_id as SUID,
                (select stvmajr_desc
                   from stvmajr
                  where stvmajr_code = fa.sovlfos_majr_code) as Minor,
                b.sgbstdn_exp_grad_date as Exp_Grad_Date
           from sovlfos fa
          inner join rel_identity_student i
             on i.pidm = fa.sovlfos_pidm
           left outer join goradid su
             on su.goradid_pidm = fa.sovlfos_pidm
            and su.goradid_adid_code = 'SUID'
          left outer join sgbstdn b on b.sgbstdn_pidm = fa.sovlfos_pidm
               and b.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(b.sgbstdn_pidm, :ddMinTerm.STVTERM_CODE)
               and b.sgbstdn_majr_code_1 not in ('0000', 'EHS', 'SUS', 'VIS')
               and b.sgbstdn_stst_code = 'AS'
          where fa.sovlfos_lfst_code = 'MINOR'
            and fa.sovlfos_majr_code = :ddMinor.STVMAJR_CODE
            and fa.sovlfos_current_ind = 'Y'
            and fa.sovlfos_csts_code = 'AWARDED'
            and fa.sovlfos_cact_code = 'ACTIVE'
            and fa.sovlfos_lcur_seqno =
                (select max(fa2.sovlfos_lcur_seqno)
                   from sovlfos fa2
                  where fa2.sovlfos_pidm = fa.sovlfos_pidm)
            and exists
          (select *
                   from sfbetrm e
                  where e.sfbetrm_pidm = fa.sovlfos_pidm
                    and e.sfbetrm_term_code >= :ddMinTerm.STVTERM_CODE
                    and e.sfbetrm_term_code <= :ddMaxTerm.STVTERM_CODE
                    and e.sfbetrm_ests_code = 'EL')
         union
         select fi.sovlfos_pidm as sPidm,
                fi.*,
                case
                  when i.pref_fname is not null and i.pref_fname <> i.fname then
                   i.lname || ', ' || i.fname || ' (' || i.pref_fname || ')'
                  else
                   f_format_name(i.pidm, 'LF')
                end as StudentName,
                i.*,
                su.goradid_additional_id as SUID,
                (select stvmajr_desc
                   from stvmajr
                  where stvmajr_code = fi.sovlfos_majr_code) as Minor,
                b.sgbstdn_exp_grad_date as Exp_Grad_Date
           from sovlfos fi
          inner join rel_identity_student i
             on i.pidm = fi.sovlfos_pidm
           left outer join goradid su
             on su.goradid_pidm = fi.sovlfos_pidm
            and su.goradid_adid_code = 'SUID'
          left outer join sgbstdn b on b.sgbstdn_pidm = fi.sovlfos_pidm
               and b.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(b.sgbstdn_pidm, :ddMinTerm.STVTERM_CODE)
               and b.sgbstdn_majr_code_1 not in ('0000', 'EHS', 'SUS', 'VIS')
               and b.sgbstdn_stst_code = 'AS'
          where sovlfos_lfst_code = 'MINOR'
            and fi.sovlfos_majr_code = :ddMinor.STVMAJR_CODE
            and fi.sovlfos_csts_code = 'INPROGRESS'
            and fi.sovlfos_cact_code = 'ACTIVE'
            and fi.sovlfos_current_ind = 'Y'
            and fi.sovlfos_pidm not in
                (select f2.sovlfos_pidm
                   from sovlfos f2
                  where sovlfos_lfst_code = 'MINOR'
                    and f2.sovlfos_majr_code = fi.sovlfos_majr_code
                    and f2.sovlfos_csts_code = 'AWARDED')
            and fi.sovlfos_lcur_seqno =
                (select max(fi2.sovlfos_lcur_seqno)
                   from sovlfos fi2
                  where fi2.sovlfos_pidm = fi.sovlfos_pidm
                       --IEG---added the following lines as it was leaving out some students as per Beth's email on 6/7/2022
                   and fi2.sovlfos_lfst_code = 'MINOR'
                   and fi2.sovlfos_majr_code = :ddMinor.STVMAJR_CODE
                   and fi2.sovlfos_current_ind = 'Y'
                   and fi2.sovlfos_csts_code = 'INPROGRESS'
                   and fi2.sovlfos_cact_code = 'ACTIVE')
              --------end revision
           and exists
         (select *
                  from sfbetrm e
                 where e.sfbetrm_pidm = fi.sovlfos_pidm
                   and e.sfbetrm_term_code >= :ddMinTerm.STVTERM_CODE
                   and e.sfbetrm_term_code <= :ddMaxTerm.STVTERM_CODE
                   and e.sfbetrm_ests_code = 'EL'))
--$addfilter
--$beginorder
 order by upper(StudentName)
--$endorder
)

,majr AS(
SELECT
    a.sgbstdn_pidm pidm,
    a.sgbstdn_majr_code_1 majr_code,
    stvmajr_desc majr
FROM
    sgbstdn a,
    main_1,
    stvmajr
WHERE
    a.rowid = f_get_sgbstdn_rowid(main_1.spidm,:ddMaxTerm.STVTERM_CODE)
AND stvmajr_code = a.sgbstdn_majr_code_1)


select
    majr.majr,
    m.*
from
    main_1 m,
    majr
where
    majr.pidm = m.pidm