select suid.goradid_additional_id as Emplid,
    i.spriden_last_name || ', ' || i.spriden_first_name || ' ' || i.spriden_mi as NameLFM,
    :sql_getSUGradeSem.SUGRADETERM as TermCd, -- CHANGE EVERY TERM.
    case
        when stu.sgbstdn_program_1 = 'ND-SUUG' then 'UGRD'
        else 'GRAD'
    end as AcadCareer,
    'FSTY' as ClassCampus,
    n.shrtckn_crn as ClassNumber,
    n.shrtckn_subj_code as Subject,
    n.shrtckn_crse_numb as CatalogNbr,
    'M0' || n.shrtckn_seq_numb as SectNbr,
    g.shrtckg_grde_code_final as CourseGradeImport
from shrtckg g
inner join shrtckn n on n.shrtckn_seq_no = g.shrtckg_tckn_seq_no and n.shrtckn_pidm = g.shrtckg_pidm and n.shrtckn_term_code = g.shrtckg_term_code
inner join goradid suid on suid.goradid_pidm = g.shrtckg_pidm and suid.goradid_adid_code = 'SUID'
inner join sgbstdn stu on stu.sgbstdn_pidm = g.shrtckg_pidm and stu.sgbstdn_term_code_eff = (select max(SGBSTDN_TERM_CODE_EFF)
            from SGBSTDN s2
            where s2.SGBSTDN_PIDM = g.shrtckg_pidm)
    and stu.sgbstdn_majr_code_1 like 'SU%' and stu.sgbstdn_degc_code_1 = 'ND'
inner join spriden i on i.spriden_pidm = g.shrtckg_pidm and i.spriden_id like 'F%'
where g.shrtckg_term_code = :sql_getESFGradeSem.MCGRADESEM
order by n.shrtckn_crn