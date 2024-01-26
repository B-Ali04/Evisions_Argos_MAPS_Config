select distinct
    a.sgbstdn_term_code_eff min_sgastdn_term,
    spriden_id bannerid,
    spriden_last_name lname,
    spriden_first_name fname,
    spriden_mi middle,
    a.sgbstdn_styp_code
from
    sgbstdn a,
    spriden
where
    a.sgbstdn_term_code_eff = (
    select
        MIN(b.sgbstdn_term_code_eff)
    from
        sgbstdn b
    where
        b.sgbstdn_pidm = a.sgbstdn_pidm)
and a.sgbstdn_styp_code IN ('F','X')
and exists (
    select
        c.sgbstdn_pidm
    from
        sgbstdn c
    where
        c.sgbstdn_term_code_eff <> a.sgbstdn_term_code_eff
    and
        c.sgbstdn_pidm = a.sgbstdn_pidm
    and c.sgbstdn_styp_code = 'T')
and a.sgbstdn_term_code_eff >= :main_DD_minterm.STVTERM_CODE
and spriden_pidm = a.sgbstdn_pidm
and spriden_change_ind is null
order by 1