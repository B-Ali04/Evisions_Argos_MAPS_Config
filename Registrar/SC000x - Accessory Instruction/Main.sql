with SPAIDEN as
(
    select
        SPRIDEN.SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI,
        SPRIDEN.SPRIDEN_NTYP_CODE,
        SPRIDEN.SPRIDEN_CHANGE_IND,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME

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
        SPBPERS.SPBPERS_BIRTH_DATE as BIRTH_DATE,
        SPBPERS.SPBPERS_SEX as SPBPERS_SEX,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_FIRST_NAME,
        SPBPERS.SPBPERS_GNDR_CODE as SPBPERS_GNDR_CODE,
        SPBPERS.SPBPERS_PPRN_CODE as SPBPERS_PPRN_CODE,
        SPBPERS.SPBPERS_BIRTH_DATE as SPBPERS_BIRTH_DATE,
        SPBPERS.SPBPERS_ETHN_CDE as SPBPERS_ETHN_CDE,
        SUBSTR(TO_CHAR(SPBPERS.SPBPERS_BIRTH_DATE,'MM/DD/YYYY'),7,4) as SPBPERS_BIRTH_YEAR,
        case
            when SPBPERS.SPBPERS_CITZ_CODE = 'Y' then 'United States'
            else (select STVNATN_NATION
                 from STVNATN
                 where STVNATN_CODE = nvl(GOBINTL.GOBINTL_NATN_CODE_LEGAL, GOBINTL.GOBINTL_NATN_CODE_BIRTH))
            end as SPBPERS_CITZ_COUNTRY,
        SPBPERS.SPBPERS_CITZ_CODE as SPBPERS_CITZ_CODE,
        SPBPERS.SPBPERS_ETHN_CODE as SPBPERS_ETHN_CODE,
        SPBPERS.SPBPERS_ARMED_SERV_MED_VET_IND as SPBPERS_ARMED_SERV_MED_VET_IND,
        SPBPERS.SPBPERS_VERA_IND as SPBPERS_VERA_IND

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
        GOBTPAC_EXTERNAL_USER as ESFiD

    from
        GOREMAL GOREMAL

        left outer join GORADID GORADID on GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
             and GORADID.GORADID_ADID_CODE = 'SUID'
        left outer join GOBUMAP GOBUMAP on GOBUMAP.GOBUMAP_PIDM = GOREMAL.GOREMAL_PIDM
        left outer join GOBTPAC GOBTPAC on GOBTPAC.GOBTPAC_PIDM = GOREMAL.GOREMAL_PIDM

    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
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
        SGBSTDN.SGBSTDN_EXP_GRAD_DATE as SGBSTDN_EXP_GRAD_DATE,
        SGBSTDN.SGBSTDN_DEGC_CODE_1 as SGBSTDN_DEGC_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_1 as SGBSTDN_MAJR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 as SGBSTDN_MAJR_CODE_MINR_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 as SGBSTDN_MAJR_CODE_MINR_1_2,
        SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1 as SGBSTDN_MAJR_CODE_CONC_1,
        SGBSTDN.SGBSTDN_RESD_CODE as SGBSTDN_RESD_CODE,
        SGBSTDN.SGBSTDN_ADMT_CODE as SGBSTDN_ADMT_CODE,
        SGBSTDN.SGBSTDN_DEPT_CODE as SGBSTDN_DEPT_CODE,
        SGBSTDN.SGBSTDN_PROGRAM_1 as SGBSTDN_PROGRAM_1,
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE) as SGBSTDN_CLAS_CODE,
        f_Get_desc_fnc('STVSTST', SGBSTDN.SGBSTDN_STST_CODE, 30) as SGBSTDN_STST_DESC,
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
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE), 30) as SGBSTDN_CLAS_DESC

   from
        SGBSTDN SGBSTDN

   where
       SGBSTDN.SGBSTDN_STST_CODE = 'AS'
    ),

SHATCKN as
(
    select
        SHRTCKN.SHRTCKN_PIDM,
        SHRTCKN.SHRTCKN_TERM_CODE,
        SHRTCKN.SHRTCKN_SEQ_NO,
        SHRTCKN.SHRTCKN_CRN,
        SHRTCKN.SHRTCKN_SUBJ_CODE,
        SHRTCKN.SHRTCKN_CRSE_NUMB,
        SHRTCKN.SHRTCKN_ACTIVITY_DATE,
        SHRTCKL.SHRTCKL_LEVL_CODE,
        SHRTCKG.SHRTCKG_GRDE_CODE_FINAL,
        SHRTCKG_CREDIT_HOURS,
        SHRGRDE.SHRGRDE_QUALITY_POINTS,
        decode(SHRGRDE.SHRGRDE_COMPLETED_IND,'Y',1,0) as COURSE_COMPLETE_IND,
        decode(SHRGRDE.SHRGRDE_PASSED_IND,'Y',1,0) as COURSE_PASSED_IND,
        decode(SHRGRDE.SHRGRDE_GPA_IND,'Y',1,0) as COURSE_GPA_IND,
        SHRGRDE.SHRGRDE_NUMERIC_VALUE

   from
        SHRTCKN SHRTCKN

        left outer join SHRTCKL SHRTCKL on SHRTCKL.SHRTCKL_PIDM = SHRTCKN.SHRTCKN_PIDM

        left outer join SHRTCKG SHRTCKG on SHRTCKG.SHRTCKG_PIDM = SHRTCKN.SHRTCKN_PIDM
        left outer join SHRGRDE SHRGRDE on SHRGRDE.SHRGRDE_CODE = SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
             and SHRGRDE.SHRGRDE_LEVL_CODE = SHRTCKL.SHRTCKL_LEVL_CODE
             and SHRGRDE.SHRGRDE_TERM_CODE_EFFECTIVE is null
             and SHRGRDE.SHRGRDE_TERM_CODE_EFFECTIVE is null
             OR SHRGRDE.SHRGRDE_TERM_CODE_EFFECTIVE = (select max(SHRGRDE_TERM_CODE_EFFECTIVE)
                                                     from SHRGRDE SHRGRDEX
                                                     where SHRGRDEX.SHRGRDE_CODE = SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                     and SHRGRDEX.SHRGRDE_LEVL_CODE = SHRTCKL.SHRTCKL_LEVL_CODE
                                                     and SHRGRDEX.SHRGRDE_TERM_CODE_EFFECTIVE <= SHRTCKN.SHRTCKN_TERM_CODE)

    where
        SHRTCKL.SHRTCKL_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
        and SHRTCKL.SHRTCKL_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
        and SHRTCKG.SHRTCKG_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
        and SHRTCKG.SHRTCKG_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
        and SHRTCKG.SHRTCKG_SEQ_NO = (select max(SHRTCKG_SEQ_NO)
                                     from SHRTCKG
                                     where SHRTCKG_PIDM = SHRTCKN.SHRTCKN_PIDM
                                     and SHRTCKG_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                     and SHRTCKG_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO)

        and (SHRGRDE.SHRGRDE_TERM_CODE_EFFECTIVE is null
        or SHRGRDE.SHRGRDE_TERM_CODE_EFFECTIVE = (select max(SHRGRDE_TERM_CODE_EFFECTIVE)
                                                 from SHRGRDE SHRGRDEX
                                                 where SHRGRDEX.SHRGRDE_CODE = SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                 and SHRGRDEX.SHRGRDE_LEVL_CODE = SHRTCKL.SHRTCKL_LEVL_CODE
                                                 and SHRGRDEX.SHRGRDE_TERM_CODE_EFFECTIVE <= SHRTCKN.SHRTCKN_TERM_CODE))
        and SHRGRDE.SHRGRDE_CODE = SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
        and SHRGRDE.SHRGRDE_LEVL_CODE = SHRTCKL.SHRTCKL_LEVL_CODE
   )

select
    STVTERM_DESC as Term,
    SSBSECT_SICAS_CAMP_COURSE_ID as  Course_Key,
    SSBSECT_SEQ_NUMB as Seq_No,
    SSBSECT_CRN as Ref_No,
    SSBSECT_CAMP_CODE as Campus,
    SCBCRSE_TITLE as Course_Title,
    SFRSTCR_CREDIT_HR as Credit_Hours,
    SGBSTDN_DEPT_CODE as Dept_Code,
    SGBSTDN_PROGRAM_1 as Stdn_Program,
    SPRIDEN_ID as BANNER_ID,
    SPRIDEN_LEGAL_NAME as Student_Name,
    GORADID_ADDITIONAL_ID as SUID,
    SGBSTDN_CLAS_CODE as Student_Class,
    SGBSTDN_MAJR_DESC as Program_of_Study,
    SGBSTDN_MAJR_CODE_MINR_1 as Major_Conc,
    SGBSTDN_MINR_1_DESC as Major_Conc_Desc,
    SHRTCKG_GRDE_CODE_FINAL as Final_Grade,
    SHRTCKN_ACTIVITY_DATE as Activity_Date

from

    STVTERM STVTERM

    left outer join SPAIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null

    left outer join SOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM

    inner join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
    inner join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
    inner join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
        and SSBSECT.SSBSECT_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
    left outer join SIRDPCL SIRDPCL on SIRDPCL.SIRDPCL_PIDM = SFRSTCR.SFRSTCR_PIDM
    left outer join SCBCRSE SCBCRSE on SSBSECT.SSBSECT_SUBJ_CODE = SCBCRSE.SCBCRSE_SUBJ_CODE
        and SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB

    left outer join SHATCKN SHRTCKN on SHRTCKN.SHRTCKN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SHRTCKN.SHRTCKN_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
        and SHRTCKN.SHRTCKN_CRN = SFRSTCR.SFRSTCR_CRN

    left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = SGBSTDN.SGBSTDN_CLAS_CODE

where
    STVTERM_CODE = :select_term_code.STVTERM_CODE
    and SPRIDEN_NTYP_CODE is null
    and SPRIDEN_CHANGE_IND is null
    and SFRSTCR_PIDM = SPRIDEN_PIDM
    and 'Y' = f_registered_this_term(SPRIDEN_PIDM, STVTERM_CODE)
    and SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SPRIDEN_PIDM, STVTERM_CODE)
    and SFRSTCR_RSTS_CODE in ( 'RE', 'RW')
    and SCBCRSE.SCBCRSE_EFF_TERM = (select max(SCBCRSE_EFF_TERM)
                            from   SCBCRSE SCBCRSEX
                            where  SCBCRSEX.SCBCRSE_SUBJ_CODE = SSBSECT_SUBJ_CODE
                            and    SCBCRSEX.SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB
                            and    SCBCRSEX.SCBCRSE_EFF_TERM <= STVTERM.STVTERM_CODE)

--$addfilter
--$beginorder
--$endorder
