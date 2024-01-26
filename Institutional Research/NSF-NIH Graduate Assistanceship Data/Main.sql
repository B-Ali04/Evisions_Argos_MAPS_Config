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

SOREMAL as
(

    select
        GOREMAL.GOREMAL_PIDM,
        GOREMAL.GOREMAL_EMAL_CODE,
        GOREMAL.GOREMAL_EMAIL_ADDRESS,
        GOREMAL.GOREMAL_STATUS_IND,
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
        and GOREMAL.GOREMAL_STATUS_IND = 'A'),

SPAPERS as
(
    select
        SPBPERS.SPBPERS_PIDM as SPBPERS_PIDM,
        SPBPERS.SPBPERS_SSN as SPBPERS_SSN,
        SPBPERS.SPBPERS_BIRTH_DATE as SPBPERS_BIRTH_DATE,
        SPBPERS.SPBPERS_SEX as SPBPERS_SEX,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_FIRST_NAME,
        SPBPERS.SPBPERS_CITZ_CODE as SPBPERS_CITZ_CODE,
        SUBSTR(TO_CHAR(SPBPERS.SPBPERS_BIRTH_DATE,'MM/DD/YYYY'),7,4) as SPBPERS_BIRTH_YEAR,
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
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE) as SGBSTDN_CLASS_CODE,
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
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, :select_term_code.STVTERM_CODE), 30) as SGBSTDN_CLASS_DESC

   from
        SGBSTDN SGBSTDN

   where
        SGBSTDN.SGBSTDN_STYP_CODE not in ('X')
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
    )

Select
    GORADID_ADDITIONAL_ID AS SU_ID,
    SPRIDEN_LEGAL_NAME as UNIT_NAME,
    SPRIDEN_ID as BANNER_ID,
    STVMAJR.STVMAJR_CIPC_CODE as CIP_Code,

    CASE
        when (exists(select * from gobintl where gobintl_pidm = spriden.spriden_pidm ) and SPBPERS_CITZ_CODE = 'N') then 1
        when GORRACE_RACE_CDE = '40' then 2 -- hispanic/latino
        when GORRACE_RACE_CDE = '10' then 3 -- mainland native
        when GORRACE_RACE_CDE = '20' then 4 -- asian
        when GORRACE_RACE_CDE = '30' then 5 -- black
        when GORRACE_RACE_CDE = '50' then 6 -- hawaiian native
        when GORRACE_RACE_CDE = '70' then 7 -- white
        when GORRACE_RACE_CDE like '%%, %%' then 8 --multiple races
        when GORRACE_RACE_CDE is null then 9 -- unknown
    END citizen_race_ethnicity_code,

    CASE
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 = 'PHD' then 1
        when SGBSTDN.SGBSTDN_DEGC_CODE_1 like 'M%%' then 2
        else 2
    END degree_code,

    CASE
        when SGBSTDN.SGBSTDN_FULL_PART_IND = 'F' then 1
        else 2
    END enrollment_code,

    CASE
        when SPBPERS.SPBPERS_SEX = 'M' then 1
        when SPBPERS.SPBPERS_SEX = 'F' then 2
        else null
    END sex_code,

    CASE
        when SGBSTDN.SGBSTDN_STYP_CODE in ('N', 'F', 'T','G') then 1
        else 2
    END firsttime_code,
    (select 'IP' from dual) support_source_code,
    (select 'IP' from dual) support_mechanism_code,
    f_get_desc_fnc('STVCITZ', SPBPERS_CITZ_CODE, 30) as Citizenship_Desc,
    f_get_desc_fnc('STVDEPT', SGBSTDN.SGBSTDN_DEPT_CODE, 30) as Department_Desc

from
    STVTERM STVTERM
    left outer join SPAIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null
    left outer join SOREMAL GOREMAL on GOREMAL.GOREMAL_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SPAPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join GOARACE GORPRAC on GORPRAC.GORPRAC_PIDM = SPRIDEN.SPRIDEN_PIDM
    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_LEVL_CODE = 'GR'
         and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
    join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    join STVSTYP STVSTYP on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

where
    STVTERM_CODE = :select_term_code.STVTERM_CODE
    and SPRIDEN_NTYP_CODE is null
    and SPRIDEN_CHANGE_IND is null
    and SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SPRIDEN_PIDM, STVTERM_CODE)
    and exists(
        select *
        from SFRSTCR SFRSTCR
        where SFRSTCR.SFRSTCR_PIDM = SPRIDEN_PIDM
        and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM_CODE
        and SFRSTCR.SFRSTCR_RSTS_CODE in ('RE','RW')
        )
--$addfilter

--$beginorder

order by
    SGBSTDN_DEGC_CODE_1 DESC, SPBPERS_SEX DESC, STVSTYP_SURROGATE_ID ASC

--$endorder

