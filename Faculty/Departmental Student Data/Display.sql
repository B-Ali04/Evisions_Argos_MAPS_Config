Select
    SPRIDEN.SPRIDEN_ID Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') Student_Name,

    STVCLAS.STVCLAS_DESC Student_Class,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Deg_Program,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVDEPT.STVDEPT_DESC Dept_Desc,
    STVSTYP.STVSTYP_DESC Reg_Type,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date

from
    SPRIDEN SPRIDEN

    join STVTERM STVTERM on STVTERM.STVTERM_CODE = :Select_Term_Code.STVTERM_CODE

    join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM,STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
         and SGBSTDN.SGBSTDN_DEPT_CODE = :Select_Dept_Code.STVDEPT_CODE

    join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVDEPT STVDEPT on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and exists (select *
               from SFRSTCR
               where SFRSTCR_PIDM = SPRIDEN_PIDM
               and SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
               and SFRSTCR_RSTS_CODE in ('RE', 'RW'))

order by
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME

/**/

-- Future Addtions
-- Undergraduate/Graduate student population selection
-- Advisor selction
-- Degree filter
--
/**/