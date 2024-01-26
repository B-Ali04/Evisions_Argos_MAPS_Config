Select
    SPRIDEN_ID as BannerID,
    f_format_name(SPRIDEN_PIDM, 'LFMI') Full_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,

    SHRLGPA.SHRLGPA_GPA_HOURS Cumulative_HP,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    SGBSTDN_PROGRAM_1 as Stdn_Program,
    f_get_desc_fnc('STVDEGC', SGBSTDN.SGBSTDN_DEGC_CODE_1, 30) as Program_Desc,
    f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as Program_of_Study,
    f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1, 30) as Minor_Program,
    f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2, 30) as Minor_Program_2,
    f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1, 30) as Conc_Program,
    SGBSTDN_EXP_GRAD_DATE as GRAD_DATE,
    SGBSTDN_STST_CODE AS STST,
    F_GET_DESC_FNC('STVSTST', SGBSTDN_STST_CODE, 30) as Degree_Status,
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME,
    SGBSTDN_DEPT_CODE as Department

from SPRIDEN SPRIDEN

    left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = (select max(SGBSTDN_TERM_CODE_EFF)
                                     from SGBSTDN x
                                     where x.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM
                                     and x.SGBSTDN_STST_CODE = 'AS')

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'

    left outer join STVTERM STVTERM ON STVTERM_cODE = (SELECT MAX(STVTERM_CODE)
                                                      FROM STVTERM x
                                                      WHERE x.STVTERM_CODE < (
                                                      (SELECT MAX(STVTERM_CODE)
                                                      FROM STVTERM x1
                                                      where x1.STVTERM_START_DATE <= to_date(:select_min_date))))
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SGBSTDN.SGBSTDN_EXP_GRAD_DATE >= to_date(:select_min_date)
    and SGBSTDN.SGBSTDN_EXP_GRAD_DATE <= to_date(:select_max_date)
    and SGBSTDN.SGBSTDN_LEVL_CODE = 'UG'

    --$addfilter


UNION

Select
    SPRIDEN_ID as BannerID,
    f_format_name(SPRIDEN_PIDM, 'LFMI') Full_Name,
    GORADID.GORADID_ADDITIONAL_ID SU_ID,
    SHRLGPA.SHRLGPA_GPA_HOURS Cumulative_HP,
    trunc(SHRLGPA.SHRLGPA_GPA,3) Cumulative_GPA,
    SHRDGMR.SHRDGMR_PROGRAM as Program,
    f_get_desc_fnc('STVDEGC', SHRDGMR.SHRDGMR_DEGC_CODE, 30) as Program_Desc,
    f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_MAJR_CODE_1, 30) as Program_of_Study,
    f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_MAJR_CODE_MINR_1, 30) as Minor_Program,
    f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_MAJR_CODE_MINR_2, 30) as Minor_Program_2,
    f_get_desc_fnc('STVMAJR', SHRDGMR.SHRDGMR_MAJR_CODE_CONC_1, 30) as Conc_Program,
    SHRDGMR_GRAD_DATE AS GRAD_DATE,
    SHRDGMR_DEGS_CODE AS STST,
    F_GET_DESC_FNC('STVDEGS', SHRDGMR_DEGS_CODE, 30) as Degree_Status,
    SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN_SEARCH_FIRST_NAME,
    SHRDGMR_DEPT_CODE as Department

from SPRIDEN SPRIDEN

    left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and sgbstdn_term_code_eff = (select max(sgbstdn_term_code_eff)
                                     from sgbstdn x
                                     where x.sgbstdn_pidm = sgbstdn.sgbstdn_pidm
                                     and x.sgbstdn_stst_code = 'AS')

    left outer join SHRDGMR SHRDGMR on SHRDGMR.SHRDGMR_PIDM = SPRIDEN.SPRIDEN_PIDM

    left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN_LEVL_CODE
         and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'

    left outer join STVTERM STVTERM ON STVTERM_CODE = (SELECT MAX(STVTERM_CODE)
                                                      FROM STVTERM x
                                                      WHERE x.STVTERM_START_DATE < ((SELECT MAX(STVTERM_START_DATE)
                                                                                   FROM STVTERM x1
                                                                                   WHERE x1.stvterm_start_Date < to_date(:select_min_date))))
where
    SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
    and SHRDGMR_GRAD_DATE >= STVTERM_START_DATE
    and SHRDGMR_GRAD_DATE <= to_date(:select_min_date)
    and SHRDGMR_LEVL_CODE = 'UG'

--$addfilter

--$beginorder

order by
      STST,
      PROGRAM_OF_STUDY,
      Cumulative_GPA,
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME
--$endorder
