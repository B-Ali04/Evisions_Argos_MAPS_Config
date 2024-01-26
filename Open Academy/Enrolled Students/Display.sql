select r.pidm,
    case
       when spbpers.spbpers_pref_first_name is not null and spbpers.spbpers_pref_first_name <> spriden.spriden_first_name
          then spriden.spriden_last_name || ', ' || spriden.spriden_first_name || ' (' || spbpers.spbpers_pref_first_name || ')'
       else
           f_format_name(SPRIDEN.SPRIDEN_PIDM,'LF')
       end as "Student",
    spriden_id banner_id,
    suid.goradid_additional_id as SUID,
    GOREMAL.GOREMAL_email_address as "Email",
    SPBPERS.SPBPERS_sex as "Gender",
    STVCLAS.STVCLAS_DESC "Class",
    SGBSTDN.SGBSTDN_DEGC_CODE_1 "DegProg",
    sgbstdn_degc_code_1 degree_code,
    stvdegc_desc degree_desc,
    sgbstdn_majr_code_1 major_code,
    stvmajr_desc majr_desc,
    STVMAJR.STVMAJR_DESC "ProgramOfStudy",
    stvdept.stvdept_code as "DPT",
    r.STYP_DESC as "RegType",
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE as "ExpGradDate",
    case
        when SGRADVR.advr_PIDM is null then ''
        else f_format_name(SGRADVR.advr_PIDM,'LF30')
    end as "Advisor",
    SGBSTDN.SGBSTDN_RESD_CODE as "Residency"

from
    rel_student r
    left outer join spriden spriden on spriden.spriden_pidm = r.pidm and spriden.spriden_id like 'F%'
    and SPRIDEN_CHANGE_IND is null
    left outer join GORADID suid on suid.goradid_pidm = SPRIDEN.SPRIDEN_PIDM and suid.goradid_adid_code = 'SUID'
    left outer join rel_student_advisor SGRADVR on
         sgradvr.pidm = SPRIDEN.SPRIDEN_PIDM
         and sgradvr.term_code = r.term_code
         and sgradvr.primary_ind = 1
         and SGRADVR.PIDM like '%'
    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = (select max(SGBSTDN_TERM_CODE_EFF)
            from SGBSTDN s2
            where s2.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM)

    left outer join GOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
    left outer join STVDEGC STVDEGC on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
    left outer join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SPRIDEN.SPRIDEN_PIDM,r.LEVL_CODE, r.TERM_CODE)
    left outer join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM

where
    r.TERM_CODE = :ddSemester.STVTERM_CODE
    and STVMAJR_CODE not in ('SUS','EHS')
    and exists
        (select * from sfrstcr
        where spriden_pidm = sfrstcr_pidm
          and sfrstcr_term_code = r.TERM_CODE and sfrstcr_rsts_code = 'RE')
    and sgbstdn.sgbstdn_majr_code_1 = :lbPOS.STVMAJR_CODE
    and stvclas.stvclas_code = :ListBox1.STVCLAS_CODE
    --$addfilter
--$beginorder
order by
    SPRIDEN.Spriden_Search_Last_Name, SPRIDEN.Spriden_Search_First_Name
--$endorder