with SPAIDEN as (

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

SOREMAL as (

    select
        GOREMAL.GOREMAL_PIDM as GOREMAL_PIDM,
        GOREMAL.GOREMAL_EMAL_CODE as GOREMAL_EMAL_CODE,
        GOREMAL.GOREMAL_EMAIL_ADDRESS as GOREMAL_EMAIL_ADDRESS,
        GOREMAL.GOREMAL_STATUS_IND as GOREMAL_STATUS_IND,
        GOREMAL.GOREMAL_PREFERRED_IND as GOREMAL_PREFFERED_IND,
        GORADID.GORADID_PIDM,
        GORADID.GORADID_ADDITIONAL_ID as GORADID_ADDITIONAL_ID,
        GORADID.GORADID_ADID_CODE

    from
        GOREMAL GOREMAL

        left outer join GORADID GORADID on GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
            and GORADID.GORADID_ADID_CODE = 'SUID'
    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'),

SPAPERS as (

    select
        SPBPERS.SPBPERS_PIDM as SPBPERS_PIDM,
        SPBPERS.SPBPERS_SSN as SPBPERS_SSN,
        SPBPERS.SPBPERS_BIRTH_DATE as SBPERS_BIRTH_DATE,
        SPBPERS.SPBPERS_SEX as SPBPERS_SEX,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_FIRST_NAME,
        SPBPERS.SPBPERS_CITZ_CODE as SPBPERS_CITZ_CODE,
        SPBPERS.SPBPERS_GNDR_CODE as SPBPERS_GNDR_CODE,
        GOBINTL.GOBINTL_PIDM as GOBINTL_PIDM,
        case
            when SPBPERS.SPBPERS_CITZ_CODE = 'Y' then 'United States'
            else (select STVNATN_NATION
                 from STVNATN
                 where STVNATN_CODE = nvl(GOBINTL.GOBINTL_NATN_CODE_LEGAL, GOBINTL.GOBINTL_NATN_CODE_BIRTH))
            end as SPBPERS_CITZ_COUNTRY

   from
        SPBPERS SPBPERS

        left outer join GOBINTL GOBINTL on GOBINTL.GOBINTL_PIDM = SPBPERS.SPBPERS_PIDM
             ),

SGASTDN as (

    select
        SGBSTDN.SGBSTDN_PIDM,
        SGBSTDN.SGBSTDN_TERM_CODE_EFF,
        SGBSTDN.SGBSTDN_STST_CODE,
        SGBSTDN.SGBSTDN_LEVL_CODE,
        SGBSTDN.SGBSTDN_STYP_CODE,
        SGBSTDN.SGBSTDN_TERM_CODE_MATRIC,
        SGBSTDN.SGBSTDN_EXP_GRAD_DATE,
        SGBSTDN.SGBSTDN_DEGC_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 as SGBSTDN_MINR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 as SGBSTDN_MINR_CODE_2,
        SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1 as SGBSTDN_CONC_CODE_1,
        SGBSTDN.SGBSTDN_RESD_CODE,
        SGBSTDN.SGBSTDN_ADMT_CODE,
        SGBSTDN.SGBSTDN_DEPT_CODE,
        SGBSTDN.SGBSTDN_PROGRAM_1,
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE) as SGBSTDN_CLASS_CODE,
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
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE), 30) as SGBSTDN_CLASS_DESC

   from
        SGBSTDN SGBSTDN
   ),

SGAADVR as (

    select
        SGRADVR.SGRADVR_PIDM as SGRADVR_PIDM,
        f_format_name(SGRADVR.SGRADVR_ADVR_PIDM, 'LF30') as SGRADVR_ADVR_NAME,
        SGRADVR.SGRADVR_TERM_CODE_EFF as SGRADVR_TERM_CODE_EFF,
        SGRADVR.SGRADVR_ADVR_PIDM as SGRADVR_ADVR_PIDM,
        SGRADVR.SGRADVR_ADVR_CODE as SGRADVR_ADVR_CODE,
        f_get_desc_fnc('STVADVR', SGRADVR_ADVR_CODE , 30) as SGRADVR_ADVR_DESC,
        SGRADVR.SGRADVR_PRIM_IND as SGRADVR_PRIM_IND,
        SGRADVR.SGRADVR_ACTIVITY_DATE as SGRADVR_ACTIVITY_DATE,
        SGRADVR.SGRADVR_SURROGATE_ID as SGRADVR_SURROGATE_ID

    from
        SGRADVR SGRADVR
        left outer join SIRDPCL SIRDPCL on SIRDPCL.SIRDPCL_PIDM = SGRADVR.SGRADVR_ADVR_PIDM

    where
        SGRADVR.SGRADVR_PRIM_IND = 'Y'
        and SGRADVR.SGRADVR_TERM_CODE_EFF = (select max(SGRADVR_TERM_CODE_EFF)
                                            from SGRADVR SGRADVRX
                                            where SGRADVRX.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
                                            and SGRADVRX.SGRADVR_SURROGATE_ID = SGRADVR.SGRADVR_SURROGATE_ID)
        and SGRADVR.SGRADVR_SURROGATE_ID = (select max(SGRADVR_SURROGATE_ID)
                                           from SGRADVR SGRADVRX
                                           where SGRADVRX.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
                                           and SGRADVRX.SGRADVR_TERM_CODE_EFF = SGRADVR.SGRADVR_TERM_CODE_EFF)

    ),
SFAREGS as
(

    select
        SFRSTCR.SFRSTCR_TERM_CODE as SFRSTCR_TERM_CODE,
        SFRSTCR.SFRSTCR_PIDM as SFRSTCR_PIDM,
        SFRSTCR.SFRSTCR_CRN as SFRSTCR_CRN,
        SFRSTCR.SFRSTCR_RSTS_CODE as SFRSTCR_RSTS_CODE,
        SFRSTCR.SFRSTCR_RSTS_DATE as SFRSTCR_RSTS_DATE,
        SFRSTCR.SFRSTCR_GRDE_CODE as SFRSTCR_GRDE_CODE,
        SFRSTCR.SFRSTCR_GRDE_DATE as SFRSTCR_GRDE_DATE,
        SFRSTCR.SFRSTCR_LEVL_CODE as SFRSTCR_LEVL_CODE,
        SFRSTCR.SFRSTCR_CREDIT_HR as SFRSTCR_CREDIT_HR,
        SFRSTCR_SURROGATE_ID as SFRSTCR_SURROGATE_ID,
        SSBSECT_TERM_CODE as SSBSECT_TERM_CODE,
        SSBSECT_CRN as SSBSECT_CRN,
        SSBSECT_PTRM_CODE as SSBSECT_PTRM_CODE,
        SSBSECT_SUBJ_CODE as SSBSECT_SUBJ_CODE,
        SSBSECT_CRSE_NUMB as SSBSECT_CRSE_NUMB,
        SSBSECT_SEQ_NUMB as SSBSECT_SEQ_NUMB,
        SSBSECT_CAMP_CODE as SSBSECT_CAMP_CODE,
        SSBSECT_GMOD_CODE as SSBSECT_GMOD_CODE,
        SSBSECT_SICAS_CAMP_COURSE_ID as SSBSECT_SICAS_CAMP_COURSE_ID,
        SIRDPCL.SIRDPCL_PIDM,
        case
          when SIRDPCL.SIRDPCL_PIDM is not null then F_FORMAT_NAME(SIRDPCL.SIRDPCL_PIDM, 'LF30')
            else ''
              end as SIRDPCL_INSTR_NAME, --Primary_Instr_Name,
        SIRDPCL.SIRDPCL_SURROGATE_ID

   from
        SFRSTCR SFRSTCR

        left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
             and SSBSECT.SSBSECT_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE

        left outer join SIRASGN SIRASGN on SIRASGN.SIRASGN_CRN = SFRSTCR.SFRSTCR_CRN
             and SIRASGN.SIRASGN_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
             and SIRASGN.SIRASGN_CATEGORY = 01

        left outer join SIRDPCL SIRDPCL on SIRDPCL.SIRDPCL_PIDM = SIRASGN.SIRASGN_PIDM

   where
        SFRSTCR.SFRSTCR_RSTS_CODE in ('RW', 'RE')
        and SIRDPCL.SIRDPCL_SURROGATE_ID = (select max(SIRDPCL_SURROGATE_ID)
                                           from SIRDPCL SIRDPCLx
                                           where SIRDPCLX.SIRDPCL_PIDM = SIRDPCL.SIRDPCL_PIDM)
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
    STVTERM.STVTERM_DESC as TERM_DESC,
    SPRIDEN_ID as Banner_ID,
    SPRIDEN.SPRIDEN_LEGAL_NAME as Student_Name,
    SPBPERS.SPBPERS_PREF_FIRST_NAME Pref_Fname,
    SGBSTDN.SGBSTDN_CLASS_CODE as Class,
    SGBSTDN.SGBSTDN_MAJR_DESC as Program_Of_Study,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 as Degree,
    SFRSTCR.SFRSTCR_RSTS_CODE as RSTS,
    SFRSTCR.SSBSECT_SICAS_CAMP_COURSE_ID as Course_Key,
    SFRSTCR.SSBSECT_CRN as CRN,
    SFRSTCR.SIRDPCL_INSTR_NAME as Primary_Instr,
    SFRSTCR.SSBSECT_CAMP_CODE as Campus,
    --SFRSTCR.SCBCRSE_TITLE as Title,
    SFRSTCR.SFRSTCR_CREDIT_HR as Credit_Hours,
    SFRSTCR.SSBSECT_SUBJ_CODE as Subj_Code,
    SFRSTCR.SSBSECT_CRSE_NUMB as Crse_Numb,
    SSBSECT_SEQ_NUMB as Seq_Numb,
    GOREMAL.GORADID_ADDITIONAL_ID as SUID,
    GOREMAL.GOREMAL_EMAIL_ADDRESS as SU_EMAIL,
    SGRADVR.SGRADVR_ADVR_NAME as Advisor_Name

from
    STVTERM STVTERM

    left outer join SPAIDEN SPRIDEN on f_registered_this_term(SPRIDEN.SPRIDEN_PIDM, STVTERM.STVTERM_CODE) = 'Y'
    left outer join SOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SGAADVR SGRADVR on SGRADVR.SGRADVR_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SFAREGS SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
    left outer join SHATCKN SHRTCKN on SHRTCKN.SHRTCKN_PIDM = SPRIDEN.SPRIDEN_PIDM

where
    STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE
    and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
    and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
    and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
    and SHRTCKN.SHRTCKN_TERM_CODE = STVTERM.STVTERM_CODE
    and SHRTCKN.SHRTCKN_CRN = SFRSTCR.SFRSTCR_CRN
    and SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
    and sgradvr_surrogate_id = (select max(sgradvr_surrogate_id)
                               from sgradvr sgradvrx
                               where sgradvrx.sgradvr_pidm = sgradvr.sgradvr_pidm)
    /*
    and SCBCRSE_EFF_TERM = (select max(SCBCRSE_EFF_TERM)
                           from   SCBCRSE SCBCRSEX
                           where  SCBCRSEX.SCBCRSE_SUBJ_CODE = SFRSTCR.SSBSECT_SUBJ_CODE
                           and    SCBCRSEX.SCBCRSE_CRSE_NUMB = SFRSTCR.SSBSECT_CRSE_NUMB
                           and    SCBCRSEX.SCBCRSE_EFF_TERM <= STVTERM.STVTERM_CODE)
                           */
                           /*
and
    not exists(
        select * from sfrstca
        left outer join ssbsect ssbsect on ssbsect_crn = sfrstca_crn
        where sfrstca_pidm = spriden_pidm
        and sfrstca_crn = ssbsect_crn
        and ssbsect_subj_code = :select_subj_code.SUBJ_CODE
        and ssbsect_crse_numb = :select_crse_numb.CRSE_NUMB
        and ssbsect_term_Code <= stvterm_code
    )
*/
/*
and
    ((
    exists(
        select * from sfrstca
        left outer join ssbsect ssbsect on ssbsect_crn = sfrstca_crn
        where sfrstca_pidm = spriden_pidm
        and sfrstca_crn = ssbsect_crn
        and ssbsect_subj_code = :select_subj_code.SUBJ_CODE
        and ssbsect_crse_numb = :select_crse_numb.CRSE_NUMB
        and ssbsect_term_Code = stvterm_code
    )
    or exists(
        select * from sfrstca
        left outer join ssbsect ssbsect on ssbsect_crn = sfrstca_crn
        where sfrstca_pidm = spriden_pidm
        and sfrstca_crn = ssbsect_crn
        and ssbsect_crn = :select_crn.CRN
        and ssbsect_term_Code = stvterm_code
    )))
*/
/*
    and ssbsect_subj_code = '&sj'
    and ssbsect_crse_numb = '&cn'
*/
/*
    and
    not exists(
        select * from SFRSTCA
        left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCA_CRN
        where SFRSTCA_PIDM = SPRIDEN.SPRIDEN_PIDM
        and ssbsect_subj_code = :select_subj_code.SUBJ_CODE
        and ssbsect_crse_numb = :select_crse_numb.CRSE_NUMB
        and SSBSECT.SSBSECT_TERM_CODE < STVTERM.STVTERM_CODE
    )
*/
--$addfilter

--$beginorder

order by
    SFRSTCR.SSBSECT_SUBJ_CODE,
    SFRSTCR.SSBSECT_SICAS_CAMP_COURSE_ID,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME

--$endorder

--select unique sfrstcr_crn from sfrstcr where sfrstcr_term_code = 202340
