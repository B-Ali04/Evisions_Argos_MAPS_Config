--Admissions Datablock
with SGAIDEN as
(

    select
        SPRIDEN.SPRIDEN_ID as SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM as SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME as SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME as SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI as MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME as SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME as SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI as SPRIDEN_SEARCH_MI,
        GORADID.GORADID_PIDM as GORADID_PIDM,
        GORADID.GORADID_ADDITIONAL_ID as GORADID_ADDITIONAL_ID,
        GORADID.GORADID_ADID_CODE as ADID_CODE

    from
        SPRIDEN SPRIDEN

        left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM

    where
        SPRIDEN.SPRIDEN_NTYP_CODE is null
        and SPRIDEN.SPRIDEN_CHANGE_IND is null
    ),

TUIADDR as
(
    select
        SPRADDR.SPRADDR_PIDM as SPRADDR_PIDM,
        SPRADDR.SPRADDR_ATYP_CODE as SPRADDR_ATYP_CODE,
        SPRADDR.SPRADDR_SEQNO as SPRADDR_SEQNO,
        SPRADDR.SPRADDR_FROM_DATE as SPRADDR_FROM_DATE,
        SPRADDR.SPRADDR_TO_DATE as SPRADDR_TO_DATE,
        SPRADDR.SPRADDR_STREET_LINE1 as SPRADDR_STREET_LINE_1,
        SPRADDR.SPRADDR_STREET_LINE2 as SPRADDR_STREET_LINE_2,
        SPRADDR.SPRADDR_STREET_LINE3 as SPRADDR_STREET_LINE_3,
        SPRADDR.SPRADDR_STAT_CODE as SPRADDR_STAT_CODE,
        SPRADDR.SPRADDR_ZIP as SPRADDR_ZIP,
        SPRADDR.SPRADDR_CNTY_CODE as SPRADDR_CNTY_CODE,
        f_get_desc_fnc('STVCNTY', SPRADDR.SPRADDR_ATYP_CODE, 30) as SPRADDR_ATYP_DESC,
        f_get_desc_fnc('STVCNTY', SPRADDR.SPRADDR_CNTY_CODE, 30) as SPRADDR_CNTY_DESC

    from
        SPRADDR SPRADDR

    where
         SPRADDR.SPRADDR_VERSION = (select max(SPRADDR_VERSION)
                                       from SPRADDR SPRADDRX
                                       where SPRADDRX.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                       and SPRADDRX.SPRADDR_STATUS_IND is null)

         and SPRADDR.SPRADDR_SURROGATE_ID = (select max(SPRADDR_SURROGATE_ID)
                                            from SPRADDR SPRADDRX
                                            where SPRADDRX.SPRADDR_PIDM = SPRADDR.SPRADDR_PIDM
                                            and SPRADDRX.SPRADDR_STATUS_IND is null)
    ),

SPATELE as
(

    select
        SPRTELE.SPRTELE_PIDM as SPRTELE_PIDM,
        SPRTELE.SPRTELE_TELE_CODE as SPRTELE_TELE_CODE,
        SPRTELE.SPRTELE_PHONE_AREA as SPRTELE_PHONE_AREA,
        SPRTELE.SPRTELE_PHONE_NUMBER as SPRTELE_PHONE_NUMBER,
        SPRTELE.SPRTELE_SURROGATE_ID as SPRTELE_SURROGATE_ID,
        SPRTELE.SPRTELE_VERSION as SPRTELE_VERSION,
        f_get_desc_fnc('STVTELE', SPRTELE.SPRTELE_TELE_CODE, 30) as SPRTELE_TELE_DESC

    from
        SPRTELE SPRTELE

    where
         SPRTELE.SPRTELE_SURROGATE_ID = (select max(SPRTELE_SURROGATE_ID)
                                            from SPRTELE SPRTELEX
                                            where SPRTELEX.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
                                            and SPRTELEX.SPRTELE_STATUS_IND is null)
    ),

SOREMAL as (

    select
        GOREMAL.GOREMAL_PIDM as GOREMAL_PIDM,
        GOREMAL.GOREMAL_EMAL_CODE as GOREMAL_EMAL_CODE,
        GOREMAL.GOREMAL_EMAIL_ADDRESS as GOREMAL_SU_EMAIL,
        GOREMAL.GOREMAL_PREFERRED_IND as GOREMAL_PREFFERED_IND,
        GOREMAL.GOREMAL_STATUS_IND as GOREMAL_STATUS_IND,
        GOREMAL1.GOREMAL_EMAL_CODE as GOREMAL_PERS_EMAL_CODE,
        GOREMAL1.GOREMAL_EMAIL_ADDRESS as GOREMAL_PERS_EMAIL,
        GOREMAL1.GOREMAL_STATUS_IND as GOREMAL_PERS_STATUS_IND

    from
        GOREMAL GOREMAL

        left outer join GOREMAL GOREMAL1 on GOREMAL1.GOREMAL_PIDM = GOREMAL.GOREMAL_PIDM
             and GOREMAL1.GOREMAL_EMAL_CODE = 'PERS'
             and GOREMAL1.GOREMAL_STATUS_IND = 'A'
             and GOREMAL1.GOREMAL_SURROGATE_ID = (select max(GOREMAL_SURROGATE_ID)
                                            from GOREMAL GOREMALX
                                            where GOREMALX.GOREMAL_PIDM = GOREMAL1.GOREMAL_PIDM)

    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
    ),

SPAPERS as
(

    select
        SPBPERS.SPBPERS_PIDM as SPBPERS_PIDM,
        SPBPERS.SPBPERS_SSN as SPBPERS_SSN,
--        SPBPERS.SPBPERS_BIRTH_DATE as BIRTH_DATE,
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

SGASTDN as (

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
    ),

SAAADMS as(

    select
        SARAPPD.SARAPPD_PIDM as SARAPPD_PIDM,
        SARAPPD.SARAPPD_TERM_CODE_ENTRY as SARAPPD_TERM_CODE_ENTRY,
        SARAPPD.SARAPPD_APPL_NO as SARAPPD_APPL_NO,
        SARAPPD.SARAPPD_SEQ_NO as SARAPPD_SEQ_NO,
        SARAPPD.SARAPPD_APDC_DATE as SARAPPD_APDC_DATE,
        SARAPPD.SARAPPD_APDC_CODE as SARAPPD_APDC_CODE,
        SARAPPD.SARAPPD_MAINT_IND as SARAPPD_MAINT_IND,
        SARAPPD.SARAPPD_ACTIVITY_DATE as SARAPPD_ACTIVITY_DATE,
        SARAPPD.SARAPPD_USER as SARAPPD_USER,
        SARAPPD.SARAPPD_DATA_ORIGIN as SARAPPD_DATA_ORIGIN,
        SARAPPD.SARAPPD_SURROGATE_ID as SARAPPD_SURROGATE_ID,
        SARAPPD.SARAPPD_VERSION as SARAPPD_VERSION,
        SARAPPD.SARAPPD_USER_ID as SARAPPD_USER_ID,
        SARAPPD.SARAPPD_VPDI_CODE as SARAPPD_VPDI_CODE,
        SARAPPD.SARAPPD_GUID as SARAPPD_GUID,
        SARAPPD.SARAPPD_DFE_ADMN_DECN_GUID as SARAPPD_DFE_ADMN_DECN_GUID

    from
        SARAPPD SARAPPD

    where
        SARAPPD.SARAPPD_SEQ_NO = (select max(SARAPPD_SEQ_NO)
                                 from SARAPPD SARAPPDX
                                 where SARAPPDX.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM)
        and SARAPPD.SARAPPD_APPL_NO = (select max(SARAPPD_APPL_NO)
                                 from SARAPPD SARAPPDX
                                 where SARAPPDX.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM)
    ),

ROAHSCH as(

    select

        SORHSCH.SORHSCH_PIDM,
        SORHSCH.SORHSCH_SBGI_CODE as SGBI_CODE,
        SORHSCH.SORHSCH_GRADUATION_DATE as SORHSCH_GRADUATION_DATE,
        SORHSCH.SORHSCH_GPA as SORHSCH_GPA,
        SORHSCH.SORHSCH_TRANS_RECV_DATE as SORHSCH_TRANS_RECV_DATE,
        f_get_desc_fnc('STVSBGI', SORHSCH_SBGI_CODE, 30) as SORHSCH_SGBI_DESC,
        SORHSCH.SORHSCH_SURROGATE_ID

    from
        SORHSCH SORHSCH
    ),

SOAPCOL as (

    select
        SORPCOL.SORPCOL_PIDM as SORPCOL_PIDM,
        SORPCOL.SORPCOL_SBGI_CODE as SORPCOL_SBGI_CODE,
        f_get_desc_fnc('STVSBGI', SORPCOL.SORPCOL_SBGI_CODE, 30) as SORPCOL_SGBI_DESC,
        SORPCOL.SORPCOL_TRANS_RECV_DATE as SORPCOL_TRANS_RECV_DATE,
        SORPCOL.SORPCOL_TRANS_REV_DATE as SORPCOL_TRANS_REV_DATE,
        SORPCOL.SORPCOL_OFFICIAL_TRANS as SORPCOL_OFFICIAL_TRANS,
        SORPCOL.SORPCOL_ADMR_CODE as SORPCOL_ADMR_CODE,
        case
          when SORPCOL.SORPCOL_ADMR_CODE is null then ''
            else f_get_desc_fnc('STVADMR', SORPCOL.SORPCOL_ADMR_CODE, 30)
              end as SORPCOL_ADMR_DESC,
        SORPCOL.SORPCOL_ACTIVITY_DATE as SORPCOL_ACTIVITY_DATE,
        SORPCOL.SORPCOL_DATA_ORIGIN as SORPCOL_DATA_ORIGIN,
        SORPCOL.SORPCOL_USER_ID as SORPCOL_USER_ID,
        SORPCOL.SORPCOL_SURROGATE_ID as SORPCOL_SURROGATE_ID,
        SORPCOL.SORPCOL_VERSION as SORPCOL_VERSION,
        SORPCOL.SORPCOL_VPDI_CODE as SORPCOL_VPDI_CODE,
        SORPCOL.SORPCOL_GUID as SORPCOL_GUID,
        SORPCOL.SORPCOL_GPA as SORPCOL_GPA

    from
        SORPCOL SORPCOL

    where
        SORPCOL.SORPCOL_SURROGATE_ID = (select max(SORPCOL_SURROGATE_ID)
                                       from SORPCOL SORPCOLX
                                       where SORPCOLX.SORPCOL_PIDM = SORPCOL.SORPCOL_PIDM)

   )

select
        STVTERM.STVTERM_CODE,
        STVTERM.STVTERM_DESC,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_NAME,
        SPBPERS.SPBPERS_BIRTH_DATE as BIRTH_DATE,
        SORHSCH.SORHSCH_GRADUATION_DATE as HS_GRADUATION_DATE,
        SORHSCH.SORHSCH_GPA as HS_GPA,
        SORHSCH.SORHSCH_TRANS_RECV_DATE as TRANS_RECV_DATE,
        SORHSCH.SORHSCH_SGBI_DESC as HIGH_SCHOOL,
        SPRIDEN.*,
        SPRTELE.*,
        SPRADDR.*,
        GOREMAL.*,
        SGBSTDN.*,
        SPBPERS.*,
        SARAPPD.*,
        SORPCOL.*,
        SORHSCH.*


from
        STVTERM STVTERM
/*
        join SGAIDEN SPRIDEN on f_registered_this_term(SPRIDEN.SPRIDEN_PIDM, STVTERM.STVTERM_CODE) = 'Y'
        left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join TUIADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SPATELE SPRTELE on SPRTELE.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SAAADMS SARAPPD on SARAPPD.SARAPPD_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join ROAHSCH SORHSCH on SORHSCH.SORHSCH_PIDM = SPRIDEN.SPRIDEN_PIDM
*/
        join SGAIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null
        left outer join TUIADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SPATELE SPRTELE on SPRTELE.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
        left outer join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM

        -- admission request 1 : AP/AC STUDENTS
        left outer join SAAADMS SARAPPD on SARAPPD.SARAPPD_PIDM = SPRIDEN.SPRIDEN_PIDM

        -- admission request 2: HIGH SCHOOL INFORMATION
        left outer join ROAHSCH SORHSCH on SORHSCH.SORHSCH_PIDM = SPRIDEN.SPRIDEN_PIDM

        -- admission request 2: HIGH SCHOOL TRANSCRIPTS
        left outer join SOAPCOL SORPCOL on SORPCOL.SORPCOL_PIDM = SPRIDEN.SPRIDEN_PIDM
             and SORPCOL.SORPCOL_ADMR_CODE = 'HST1'

where
      STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE
--      and SGBSTDN_STYP_CODE = :select_styp_code.SGASTDN_STYP_CODE
--      and SARAPPD.SARAPPD_APDC_CODE = :select_apdc_code.SAAADMS_APDC_CODE           /* export: decisioned applicants */
--      and SGBSTDN.SGBSTDN_MAJR_CODE_1 = :select_majr_code.SGASTDN_MAJR_CODE         /* export: major code*/
--      and :select_styp_code.SGASTDN_STYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE           /* export: student type */
--      and :select_admr_code.SORPCOL_ADMR_CODE = SORPCOL_ADMR_CODE                   /* export: transcript type*/
--      and SORPCOL.SORPCOL_ADMR_CODE = 'HST1'                                        /* export: high school transcripts only */
      and f_registered_this_term(SPRIDEN_PIDM, STVTERM_CODE) = 'Y'
      and SPRIDEN.ADID_CODE = 'SUID'
      and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
      and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
      and sgbstdn.sgbstdn_dept_code = 'FRM'
      and SARAPPD_TERM_CODE_ENTRY = STVTERM_CODE

--$addfilter

--$beginorder

order by
      SPRIDEN_SEARCH_LAST_NAME,
      SPRIDEN_SEARCH_FIRST_NAME
--$endorder