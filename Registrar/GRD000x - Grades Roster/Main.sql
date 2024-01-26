with SGAIDEN as
(

    select
        SPRIDEN.SPRIDEN_ID as SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM as SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME as SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME as SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI as SPRIDEN_MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as LEGAL_FULL_NAME,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME as SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME as SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI as SPRIDEN_SEARCH_MI

    from
        SPRIDEN SPRIDEN

    where
        SPRIDEN.SPRIDEN_NTYP_CODE is null
        and SPRIDEN.SPRIDEN_CHANGE_IND is null
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
        GORADID.GORADID_ADID_CODE as GORADID_ADID_CODE

    from
        GOREMAL GOREMAL

        left outer join GORADID GORADID on GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
             and GORADID.GORADID_ADID_CODE = 'SUID'

    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
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
        f_Get_desc_fnc('STVDEPT', SGBSTDN.SGBSTDN_DEPT_CODE, 30) as SGBSTDN_DEPT_DESC

   from
        SGBSTDN SGBSTDN
   where
        SGBSTDN.SGBSTDN_PIDM is not null
        and SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
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

   STVTERM.STVTERM_CODE as Semester,
   STVTERM.STVTERM_DESC,
   SFRSTCR.SFRSTCR_TERM_CODE as Term_Code,
   /*
   SFRSTCR.SHRTCKG_GRDE_CODE_FINAL as Final_Course_Grade,
   SFRSTCR.CRN as Previous_CRN,
   SFRSTCR.PREV_TERM_CODE as Previous_Term,
   SFRSTCR.PREV_GRDE_CODE as Previous_Grade,
   */
   -- specified labels
   SPRIDEN.SPRIDEN_MI as MI,
   SPBPERS.SPBPERS_PREF_FIRST_NAME as Pref_Name,
   GOREMAL.GORADID_ADDITIONAL_ID as ID_No,
   GOREMAL.GORADID_ADID_CODE as ADID_CODE,
   SPRIDEN.*,
   SGBSTDN.*,
   SPBPERS.*,
   SFRSTCR.*,
   SHRTCKN.*,
   SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
   STVCLAS.STVCLAS_SURROGATE_ID

from
   STVTERM STVTERM

   join SGAIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null
   left outer join SOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
   left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
   left outer join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
   left outer join SFAREGS SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
   left outer join SHATCKN SHRTCKN on SHRTCKN.SHRTCKN_PIDM = SPRIDEN.SPRIDEN_PIDM
   -- ADDITIONAL DETAILS
   left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE)

where
   STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE
   and SHRTCKN.SHRTCKN_TERM_CODE = STVTERM.STVTERM_CODE
   and SHRTCKN.SHRTCKN_CRN = SFRSTCR.SFRSTCR_CRN
   and SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN_PIDM, STVTERM_CODE)
   and f_registered_this_term(SPRIDEN.SPRIDEN_PIDM, STVTERM.STVTERM_CODE) = 'Y'
   and SGBSTDN_STST_CODE = 'AS'
        and
        (
            not exists
            (
                       select *
                       from SFRWDRL SFRWDRL
                       where SFRWDRL.SFRWDRL_PIDM = SPRIDEN.SPRIDEN_PIDM
                       and SFRWDRL.SFRWDRL_TERM_CODE = SGBSTDN.SGBSTDN_TERM_CODE_EFF
                           )
                )

/*
passed - 01
SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
and SHRTCKG_GRDE_CODE_FINAL = :select_grade_code.GRADECODE
*/
/*
04
SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE

and(
    SFRSTCR_GRDE_CODE is null
    or SFRSTCR_GRDE_CODE in ('NR')
    or SHRTCKG_GRDE_CODE_FINAL is null
)
*/
/*
05
SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
and(
        SFRSTCR.SHRTCKG_GRDE_CODE_FINAL in(
            select SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
            from SHRTCKG SHRTCKG
            where SHRTCKG.SHRTCKG_PIDM = SPRIDEN.SPRIDEN_PIDM
            and SHRTCKG.SHRTCKG_TERM_CODE = SFRSTCR.SHRTCKN_TERM_CODE
            and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL in ('U', 'I', 'IF', 'IU')
            group by SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
            having count(*)> 1
        )
    )
    and STVCLAS.STVCLAS_CODE in ('AG','BG') -- grads only!

*/
/*
06
SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
and (
    SFRSTCR.SFRSTCR_GRDE_CODE in ('WF','F')
    or SFRSTCR.SHRTCKG_GRDE_CODE_FINAL in ('WF','F')
       )
*/
/*
07
SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
and SFRSTCR.SHRTCKG_GRDE_CODE_FINAL in ('I')
and SFRSTCR.SFRSTCR_RSTS_CODE = 'RE'
--SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
--and SFRSTCR.SHRTCKG_GRDE_CODE_FINAL in ('IF','I')
and SFRSTCR.SIRDPCL_SURROGATE_ID = (select max(SIRDPCL_SURROGATE_ID)
                                   from SIRDPCL SIRDPCLX
                                   where SIRDPCLX.SIRDPCL_PIDM = SFRSTCR.SIRDPCL_PIDM)
*/
/*
08
SFRSTCR.PREV_TERM_CODE != SFRSTCR.SFRSTCR_TERM_CODE
and SFRSTCR.SUBJ_CODE = SFRSTCR.SSBSECT_SUBJ_CODE
and SFRSTCR.CRSE_NUMB = SFRSTCR.SSBSECT_CRSE_NUMB
and SFRSTCR.PASSED_IND = 0
and SFRSTCR.COMPLETE_IND = 0

*/
/*
012
SFRSTCR.PREV_TERM_CODE != SFRSTCR.SFRSTCR_TERM_CODE
and SFRSTCR.SUBJ_CODE = SFRSTCR.SSBSECT_SUBJ_CODE
and SFRSTCR.CRSE_NUMB = SFRSTCR.SSBSECT_CRSE_NUMB
and SFRSTCR.PREV_GRDE_CODE not in ( 'F', 'I', 'IF', 'IU', 'NR', 'U', 'UAU', 'V', 'W', 'WF')
*/
/*
013
SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
and SGBSTDN.SGBSTDN_LEVL_CODE = 'GR'
and (
    SFRSTCR.SFRSTCR_GRDE_CODE = 'D'
    or SHRTCKG_GRDE_CODE_FINAL = 'D'
       )
*/
/*
SFRSTCR.SFRSTCR_GRDE_CODE is not null
and SFRSTCR.SHRTCKG_GRDE_CODE_FINAL is not null
*/
--$addfilter

--$beginorder

order by
   SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
   SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME,
   SFRSTCR.SSBSECT_SICAS_CAMP_COURSE_ID
--$endorder