with SPAIDEN as
(
    select
        SPRIDEN.SPRIDEN_ID as SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM as SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME as SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME as SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI as SPRIDEN_MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME as SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME as SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI as SPRIDEN_SEARCH_MI

    from
        SPRIDEN SPRIDEN

    where
        SPRIDEN.SPRIDEN_NTYP_CODE is null
        and SPRIDEN.SPRIDEN_CHANGE_IND is null
    ),

SPAPERS as
(
    select
        SPBPERS.SPBPERS_PIDM as SPBPERS_PIDM,
        SPBPERS.SPBPERS_SSN as SPBPERS_SSN,
        SPBPERS.SPBPERS_BIRTH_DATE as SBPERS_BIRTH_DATE,
        SPBPERS.SPBPERS_SEX as SPBPERS_SEX,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_FIRST_NAME,
        SPBPERS.SPBPERS_CITZ_CODE as SPBPERS_CITZ_CODE,
        case
            when SPBPERS.SPBPERS_CITZ_CODE = 'Y' then 'United States'
            else (select STVNATN_NATION
                 from STVNATN
                 where STVNATN_CODE = nvl(GOBINTL.GOBINTL_NATN_CODE_LEGAL, GOBINTL.GOBINTL_NATN_CODE_BIRTH))
            end as SPBPERS_CITZ_COUNTRY,
        SPBPERS.SPBPERS_GNDR_CODE as SPBPERS_GNDR_CODE


   from
        SPBPERS SPBPERS

        left outer join GOBINTL GOBINTL on GOBINTL.GOBINTL_PIDM = SPBPERS.SPBPERS_PIDM
   ),

SOREMAL as
(
    select
        GOREMAL.GOREMAL_PIDM as GOREMAL_PIDM,
        GOREMAL.GOREMAL_EMAL_CODE as GOREMAL_EMAL_CODE,
        GOREMAL.GOREMAL_EMAIL_ADDRESS as GOREMAL_EMAIL_ADDRESS,
        GOREMAL.GOREMAL_STATUS_IND as GOREMAL_STATUS_IND,
        GOREMAL.GOREMAL_PREFERRED_IND as GOREMAL_PREFFERED_IND,
        GORADID.GORADID_PIDM as GORADID_PIDM,
        GORADID.GORADID_ADDITIONAL_ID as GORADID_ADDITIONAL_ID,
        GORADID.GORADID_ADID_CODE as GORADID_ADID_CODE,
        GOBTPAC_EXTERNAL_USER as GOBTPAC_EXTERNAL_USER --esfid

    from
        GOREMAL GOREMAL

        left outer join GORADID GORADID on GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
             and GORADID.GORADID_ADID_CODE = 'SUID'
        left outer join GOBUMAP GOBUMAP on GOBUMAP.GOBUMAP_PIDM = GOREMAL.GOREMAL_PIDM
        left outer join GOBTPAC GOBTPAC on GOBTPAC.GOBTPAC_PIDM = GOREMAL.GOREMAL_PIDM

    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
        and GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        and GORADID.GORADID_ADID_CODE = 'SUID'
    ),

SGASTDN as
(
    select
        SGBSTDN.SGBSTDN_PIDM as SGBSTDN_PIDM,
        SGBSTDN.SGBSTDN_TERM_CODE_EFF as SGBSTDN_TERM_CODE_EFF,
        SGBSTDN.SGBSTDN_STST_CODE as SGBSTDN_STST_CODE,
        SGBSTDN.SGBSTDN_LEVL_CODE as SGBSTDN_LEVL_CODE,
        SGBSTDN.SGBSTDN_STYP_CODE as SGBSTDN_STYP_CODE,
        SGBSTDN.SGBSTDN_TERM_CODE_MATRIC as SGBSTDN_TERM_CODE_MATRIC,
        SGBSTDN.SGBSTDN_TERM_CODE_ADMIT as SGBSTDN_TERM_CODE_ADMIT,
        SGBSTDN.SGBSTDN_EXP_GRAD_DATE as SGBSTDN_EXP_GRAD_DATE,
        SGBSTDN.SGBSTDN_CAMP_CODE as SGBSTDN_CAMP_CODE,
        SGBSTDN.SGBSTDN_COLL_CODE_1 as SGBSTDN_COLL_CODE_1,
        SGBSTDN.SGBSTDN_DEGC_CODE_1 as SGBSTDN_DEGC_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_1 as SGBSTDN_MAJR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 as SGBSTDN_MAJR_CODE_MINR_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 as SGBSTDN_MAJR_CODE_MINR_1_2,
        SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1 as SGBSTDN_MAJR_CODE_CONC_1,
        SGBSTDN.SGBSTDN_RESD_CODE as SGBSTDN_RESD_CODE,
        SGBSTDN.SGBSTDN_ADMT_CODE as SGBSTDN_ADMT_CODE,
        SGBSTDN.SGBSTDN_DEPT_CODE as SGBSTDN_DEPT_CODE,
        SGBSTDN.SGBSTDN_PROGRAM_1 as SGBSTDN_PROGRAM_1,
        SGBSTDN.SGBSTDN_TERM_CODE_GRAD as SGBSTDN_TERM_CODE_GRAD,
        SGBSTDN.SGBSTDN_ACTIVITY_DATE as SGBSTDN_ACTIVITY_DATE,
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE) as SGBSTDN_CLAS_CODE,
        f_Get_desc_fnc('STVSTST',SGBSTDN.SGBSTDN_STST_CODE, 30) as SGBSTDN_STST_DESC,
        f_Get_desc_fnc('STVLEVL', SGBSTDN.SGBSTDN_LEVL_CODE, 30) as SGBSTDN_LEVL_DESC,
        f_Get_desc_fnc('STVSTYP', SGBSTDN.SGBSTDN_STYP_CODE, 30) as SGBSTDN_STYP_DESC,
        f_Get_desc_fnc('STVDEGC', SGBSTDN.SGBSTDN_DEGC_CODE_1, 30) as SGBSTDN_DEGC_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as SGBSTDN_MAJR_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1, 30) as SGBSTDN_MINR_1_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2, 30) as SGBSTDN_MINR_1_2_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1, 30) as SGBSTDN_CONC_DESC,
        f_Get_desc_fnc('STVRESD', SGBSTDN.SGBSTDN_RESD_CODE, 30) as SGBSTDN_RESD_DESC,
        f_Get_desc_fnc('STVADMT', SGBSTDN.SGBSTDN_ADMT_CODE, 30) as SGBSTDN_ADMT_DESC,
        f_Get_desc_fnc('STVDEPT', SGBSTDN.SGBSTDN_DEPT_CODE, 30) as SGBSTDN_DEPT_DESC,
        f_Get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_MATRIC, 30) as SGBSTDN_MATRIC_TERM_DESC,
        f_Get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_GRAD, 30) as SGBSTDN_GRAD_TERM_DESC,
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE), 30) as SGBSTDN_CLAS_DESC

   from
        SGBSTDN SGBSTDN
   ),

SHAGPAR as
(
    select
        case
            when SFRTHST.SFRTHST_TMST_CODE is not null then SFRTHST.SFRTHST_TMST_CODE
            when SHRTGPA.SHRTGPA_HOURS_ATTEMPTED >= 12 then 'FT'
              else 'PT'
                end as SFRTHST_ENROLLEMENT,
        SFRTHST.SFRTHST_TERM_CODE as SFRTHST_TERM_CODE,
        SHRTGPA.SHRTGPA_PIDM as SHRTGPA_PIDM,
        SHRTGPA.SHRTGPA_LEVL_CODE as SHRTGPA_LEVL_CODE,
        SHRTGPA.SHRTGPA_GPA_TYPE_IND as SHRTGPA_GPA_TYPE_IND,
        SHRTGPA.SHRTGPA_TERM_CODE as SHRTGPA_TERM_CODE,
        SHRTGPA.SHRTGPA_HOURS_ATTEMPTED as SHRTGPA_HOURS_ATTEMPTED,
        SHRTGPA.SHRTGPA_HOURS_EARNED as SHRTGPA_HOURS_EARNED,
        SHRTGPA.SHRTGPA_GPA_HOURS as SHRTGPA_GPA_HOURS,
        SHRTGPA.SHRTGPA_GPA as SHRTGPA_GPA,
        SHRTGPA.SHRTGPA_QUALITY_POINTS as SHRTGPA_QUALITY_POINTS,
        SHRTGPA.SHRTGPA_HOURS_PASSED as SHRTGPA_HOURS_PASSED,
        SHRLGPA.SHRLGPA_PIDM as SHRLGPA_PIDM,
        SHRLGPA.SHRLGPA_LEVL_CODE as SHRLGPA_LEVL_CODE,
        SHRLGPA.SHRLGPA_GPA_TYPE_IND as SHRLGPA_GPA_TYPE_IND,
        SHRLGPA.SHRLGPA_HOURS_ATTEMPTED as SHRLGPA_HOURS_ATTEMPTED,
        SHRLGPA.SHRLGPA_HOURS_EARNED as SHRLGPA_HOURS_EARNED,
        SHRLGPA.SHRLGPA_GPA_HOURS as SHRLGPA_GPA_HOURS,
        SHRLGPA.SHRLGPA_GPA as SHRLGPA_GPA,
        SHRLGPA.SHRLGPA_QUALITY_POINTS as SHRLGPA_QUALITY_POINTS,
        trunc(SHRTGPA.SHRTGPA_GPA,3) as SHRTGPA_SEMESTER_GPA,
        trunc(SHRLGPA.SHRLGPA_GPA,3) as SHRLGPA_CUMULATIVE_GPA

    from
        SHRTGPA SHRTGPA

        left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
            and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
            and SHRLGPA.SHRLGPA_LEVL_CODE = SHRTGPA.SHRTGPA_LEVL_CODE
        left outer join SFRTHST SFRTHST on SFRTHST.SFRTHST_PIDM = SHRTGPA.SHRTGPA_PIDM
            and SFRTHST.SFRTHST_TERM_CODE = SHRTGPA.SHRTGPA_TERM_CODE
            and SFRTHST.SFRTHST_SURROGATE_ID = (select max(SFRTHST_SURROGATE_ID)
                                               from SFRTHST SFRTHSTX
                                               where SFRTHSTX.SFRTHST_PIDM = SFRTHST.SFRTHST_PIDM
                                               and SFRTHSTX.SFRTHST_TERM_CODE = SFRTHST.SFRTHST_TERM_CODE)

    where
        SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'
    )

select
        STVTERM_DESC as Semester,
        SPRIDEN_ID as BannerID,
        f_format_name(SPRIDEN_PIDM, 'LFMI') Full_Name,
        GORADID_ADDITIONAL_ID SU_ID,
        SHRLGPA_GPA_HOURS Cumulative_HP,
        trunc(SHRLGPA_GPA,3) Cumulative_GPA,
        SGBSTDN_DEGC_DESC as Degree_Program,
        SGBSTDN_MAJR_DESC as Program_of_Study,
        SGBSTDN_MINR_1_DESC as Minor_Desc,
        SGBSTDN_MINR_1_2_DESC as Minor_Desc_2,
        SGBSTDN_CONC_DESC as Conc_Desc,F_GET_DESC_FNC('STVSTST', SGBSTDN_STST_CODE, 30) as Enrollment,
        SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN_SEARCH_FIRST_NAME

from
        STVTERM STVTERM
        LEFT OUTER JOIN SPAIDEN SPRIDEN ON SPRIDEN.SPRIDEN_PIDM IS NOT NULL
        LEFT OUTER JOIN SPAPERS SPBPERS ON SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
        LEFT OUTER JOIN SOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        LEFT OUTER JOIN SGASTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        LEFT OUTER JOIN STVCLAS STVCLAS ON STVCLAS.STVCLAS_CODE = SGBSTDN.SGBSTDN_CLAS_CODE

        LEFT OUTER JOIN SHAGPAR SHRTGPA ON SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
             and SHRTGPA_TERM_CODE = STVTERM_CODE
             and SHRTGPA_LEVL_CODE = SGBSTDN_LEVL_CODE
             and SHRTGPA_GPA_TYPE_IND = 'I'


where
        STVTERM_CODE = :select_term_code.STVTERM_CODE
        and SGBSTDN_DEPT_CODE = 'EFB'
        and SGBSTDN_LEVL_CODE = 'UG'
        and SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN_PIDM, STVTERM_CODE)
        and(
            (
             SGBSTDN.SGBSTDN_EXP_GRAD_DATE >= :select_min_date
             and SGBSTDN.SGBSTDN_EXP_GRAD_DATE <= :select_max_date
             )
        or(
          EXISTS (
                 SELECT * FROM SHRDGMR
                 WHERE SHRDGMR_PIDM = SPRIDEN_PIDM
                 AND SHRDGMR_GRAD_DATE >= :select_min_date
                 AND SHRDGMR_GRAD_DATE <= :select_max_date
                 AND SHRDGMR_DEGS_CODE = 'GR'
                 )
               )
              )
--        and sgbstdn_majr_Code_1 not in ('SUS')



--$addfilter

--$beginorder
order by
        --SGBSTDN_DEPT_CODE, SGBSTDN_DEGC_CODE_1 DESC,
        SHRLGPA_GPA,
        SHRTGPA_GPA,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME
--$endorder