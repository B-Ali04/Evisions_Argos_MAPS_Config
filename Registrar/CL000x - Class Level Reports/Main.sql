-- REPORT DETAILS AND FORMAT
Select

    -- ESF/SU ID  DETAILS
    SPRIDEN.SPRIDEN_ID BANNER_ID,
    SPRIDEN.SPRIDEN_LAST_NAME Last_Name,
    SPRIDEN.SPRIDEN_FIRST_NAME First_Name,
    GORADID.GORADID_ADDITIONAL_ID SUID,

    -- ADVISEMENT DETAILS
    f_get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE), 30) as Student_Class,
    f_get_desc_fnc('STVSTST', SGBSTDN.SGBSTDN_STST_CODE, 30) as Reg_Status,
    f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as  Program_of_Study,
    f_get_desc_fnc('STVLEVL', SGBSTDN.SGBSTDN_LEVL_CODE, 30) as Class_Levl,
    f_get_desc_fnc('STVSTYP', SGBSTDN.SGBSTDN_STYP_CODE, 30) as Student_Type,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date

-- SOURCES
from
    STVTERM STVTERM

    left outer join SPRIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null

    left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
        and GORADID.GORADID_ADID_CODE = 'SUID'

    -- STUDENT DATA
    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_LEVL_CODE in ('UG','GR')

-- CONDITIONS
where
    STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE
    and SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null

    -- TERM ENROLLMENT CHECK
       -- enrollment function testing required
    and 'Y' = f_registered_this_term(SPRIDEN.SPRIDEN_PIDM, STVTERM.STVTERM_CODE)
/*
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE like 'R%'
    )
*/
--$addfilter

--$beginorder

-- GROUPING/ORDERING
order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

--$endorder
