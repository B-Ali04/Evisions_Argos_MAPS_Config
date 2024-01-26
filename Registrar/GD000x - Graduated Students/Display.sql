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
        GOREMAL.GOREMAL_PREFERRED_IND,
        GORADID.GORADID_PIDM,
        GORADID.GORADID_ADDITIONAL_ID,
        GORADID.GORADID_ADID_CODE

    from
        GOREMAL GOREMAL
        left outer join GORADID GORADID on GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
            and GORADID.GORADID_ADID_CODE = 'SUID'

    where
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        and GOREMAL.GOREMAL_STATUS_IND = 'A'
        and GOREMAL_PREFERRED_IND = 'Y'),

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

GOARACE as
(
    select
        GORPRAC.GORPRAC_PIDM as GORPRAC_PIDM,
        (listagg(GORPRAC.GORPRAC_RACE_CDE,', ') within group (order by GORPRAC.GORPRAC_RACE_CDE)) as GORRACE_RACE_CDE,
        (listagg(GORRACE.GORRACE_DESC,', ') within group (order by GORRACE.GORRACE_DESC)) as GORRACE_DESC

    from
        GORPRAC GORPRAC

    left outer join GORRACE GORRACE ON GORRACE.GORRACE_RACE_CDE = GORPRAC.GORPRAC_RACE_CDE

    group by
        GORPRAC.GORPRAC_PIDM
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
        SPRADDR.SPRADDR_CITY as SPRADDR_CITY,
        SPRADDR.SPRADDR_STAT_CODE as SPRADDR_STAT_CODE,
        SPRADDR.SPRADDR_ZIP as SPRADDR_ZIP,
        SPRADDR.SPRADDR_CNTY_CODE as SPRADDR_CNTY_CODE,
        f_get_desc_fnc('STVATYP', SPRADDR.SPRADDR_ATYP_CODE, 30) as SPRADDR_ATYP_DESC,
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

        --Telephone
SPATELE as
(
    select
        SPRTELE.SPRTELE_PIDM as SPRTELE_PIDM,
        SPRTELE.SPRTELE_TELE_CODE as SPRTELE_TELE_CODE,
        SPRTELE.SPRTELE_PHONE_AREA as SPRTELE_PHONE_AREA,
        SPRTELE.SPRTELE_PHONE_NUMBER as SPRTELE_PHONE_NUMBER,
        SPRTELE.SPRTELE_SURROGATE_ID as SPRTELE_SURROGATE_ID,
        SPRTELE.SPRTELE_VERSION as SPRTELE_VERSION,
        SPRTELE.SPRTELE_INTL_ACCESS as SPRTELE_INTL_ACCESS,
        --SPRTELE.SPRTELE_INTL_ACCESS as Intl_access,
        f_get_desc_fnc('STVTELE', SPRTELE.SPRTELE_TELE_CODE, 30) as SPRTELE_TELE_DESC,
        concat(SPRTELE_PHONE_AREA, SPRTELE_PHONE_NUMBER) as SPRTELE_PHONE

    from
        SPRTELE SPRTELE

    where
         SPRTELE.SPRTELE_TELE_CODE = 'PC'
         and SPRTELE.SPRTELE_STATUS_IND is null
         and SPRTELE.SPRTELE_SURROGATE_ID = (select max(SPRTELE_SURROGATE_ID)
                                            from SPRTELE SPRTELEX
                                            where SPRTELEX.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
                                            and SPRTELEX.SPRTELE_STATUS_IND is null)
    ),

SHAGPAR as (

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
        and SHRTGPA.SHRTGPA_TERM_CODE = (select max(SHRTGPA_TERM_CODE)
                                               from SHRTGPA SHRTGPAX
                                               where SHRTGPAX.SHRTGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
                                               and SHRTGPAX.SHRTGPA_GPA_TYPE_IND = 'I')

    ),

SHRTTRM1 as(
    select
        SHRTTRM.SHRTTRM_PIDM AS SHRTTRM_PIDM,

        case
            when SHRTTRM.SHRTTRM_ASTD_CODE_DL = 'DL' then 'Deans List'
            when SHRTTRM.SHRTTRM_ASTD_CODE_DL in ('PL') then 'Presidents List'
            when SHRTTRM.SHRTTRM_ASTD_CODE_DL in ('PR') then 'Presidents List (4.000 List)'
                else ''
        end as SHRTTRM_ASTD_DESC

from
    SHRTTRM SHRTTRM

where
    SHRTTRM.SHRTTRM_TERM_CODE = (select max(SHRTTRM_TERM_CODE)
                                        from SHRTTRM SHRTTRMX
                                        where SHRTTRMX.SHRTTRM_PIDM = SHRTTRM.SHRTTRM_PIDM)
    group by
        SHRTTRM.SHRTTRM_PIDM,
        SHRTTRM.SHRTTRM_ASTD_CODE_DL
            ),

SGRSATT1 as(
    select
        SGRSATT_PIDM AS SGRSATT_PIDM,
        case
            when SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR') then 'Y'
        else 'N'
                end as SGRSATT_HONR_IND

    from
        SGRSATT SGRSATT

    where
        SGRSATT.SGRSATT_ATTS_CODE in ('HONR','UHON')
        and SGRSATT.SGRSATT_SURROGATE_ID = (select max(SGRSATT_SURROGATE_ID)
                                                   from SGRSATT SGRSATTX
                                                   where SGRSATTX.SGRSATT_PIDM = SGRSATT.SGRSATT_PIDM
                                                   and SGRSATTX.SGRSATT_ATTS_CODE in ('HONR','UHON'))
    group by
            SGRSATT_PIDM,
            SGRSATT_ATTS_CODE
                )

select
    SPRIDEN.SPRIDEN_ID as Banner_ID,
    f_format_name(SPRIDEN_PIDM, 'LFMI') as Full_Name,
    GOREMAL.GORADID_ADDITIONAL_ID as SUID,
    SHRDGMR.SHRDGMR_LEVL_CODE as Student_Level,
    SHRDGMR.SHRDGMR_DEGC_CODE as Degree_Program,
    SHRDGMR.SHRDGMR_GRAD_DATE as Grad_Date

from
    SHRDGMR SHRDGMR
    left outer join SPAIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM =SHRDGMR.SHRDGMR_PIDM
    left outer join TUIADDR SPRADDR on SPRADDR.SPRADDR_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SPATELE SPRTELE on SPRTELE.SPRTELE_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join GOARACE GORPRAC on GORPRAC.GORPRAC_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SOREMAL GOREMAL on GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SHAGPAR SHRTGPA on SHRTGPA.SHRTGPA_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SHRDGIH SHRDGIH on SHRDGIH.SHRDGIH_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRDGIH.SHRDGIH_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO
    left outer join SHRDGDH SHRDGDH on SHRDGDH.SHRDGDH_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SHRDGDH.SHRDGDH_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO
    left outer join SHRTTRM1 on SHRTTRM1.SHRTTRM_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SGRSATT1 on SGRSATT1.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM

where
    SHRDGMR.SHRDGMR_DEGS_CODE = 'GR'
    and SHRDGMR.SHRDGMR_GRAD_DATE >= to_date(:parm_date_min_select)
    and SHRDGMR.SHRDGMR_GRAD_DATE <= to_date(:parm_date_max_select)
    and SPRIDEN.SPRIDEN_NTYP_CODE is null
    and SPRIDEN.SPRIDEN_CHANGE_IND is null
--$addfilter

--$beginorder

order by
    SHRDGMR.SHRDGMR_DEGC_CODE asc,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME
--$endorder