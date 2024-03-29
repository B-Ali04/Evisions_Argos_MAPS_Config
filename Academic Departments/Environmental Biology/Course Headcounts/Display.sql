select stvclas_code, stvclas_surrogate_id, sgbstdn_majr_code_1, sgbstdn_dept_code, sfrstcr.*, ssbsect.*

     from SFRSTCR SFRSTCR

     left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR_CRN and SSBSECT_TERM_CODE = SFRSTCR_TERM_CODE

     left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SFRSTCR.SFRSTCR_PIDM,SFRSTCR.SFRSTCR_LEVL_CODE, SFRSTCR_TERM_CODE)

     left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SFRSTCR_PIDM and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, SFRSTCR.SFRSTCR_TERM_CODE)

where
     SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
     and SFRSTCR.SFRSTCR_TERM_CODE = :select_term_code.STVTERM_CODE
     and SSBSECT_TOT_CREDIT_HRS > 0
     and SGBSTDN_DEPT_CODE = 'EFB'
     and SGBSTDN_STST_CODE = 'AS'

order by
     SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID, STVCLAS.STVCLAS_SURROGATE_ID