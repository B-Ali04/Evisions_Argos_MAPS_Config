WITH advr_name AS
 (select i0.spriden_pidm pidm,
         case
           when upper(i1.spbpers_pref_first_name) =
                upper(i0.spriden_first_name) THEN
            NULL
           else
            i1.spbpers_pref_first_name
         end pref_fname,
         i0.spriden_first_name fname,
         i0.spriden_last_name lname
    from spriden i0, spbpers i1
   where i1.spbpers_pidm = i0.spriden_pidm
     and i0.spriden_change_ind is null)

,praddr AS(
    select
        a.spraddr_pidm pidm,
        a.spraddr_street_line1 street1,
        a.spraddr_street_line2 street2,
        a.spraddr_street_line3 street3,
        a.spraddr_city city,
        a.spraddr_stat_code state,
        a.spraddr_zip zip,
        a.spraddr_atyp_code atyp
    from
        spraddr a
    where
        a.spraddr_atyp_code = 'PR'
    and a.spraddr_seqno = (
        select
            max(b.spraddr_seqno)
        from
            spraddr b
        where
            b.spraddr_pidm = a.spraddr_pidm
        and b.spraddr_atyp_code = 'PR'
    and a.spraddr_activity_date = (
        select
            max(c.spraddr_activity_date)
        from
            spraddr c
        where
            c.spraddr_pidm = a.spraddr_pidm
        and c.spraddr_atyp_code = 'PR'
        and c.spraddr_seqno = a.spraddr_seqno)
))

,maaddr AS(
    select
        a.spraddr_pidm pidm,
        a.spraddr_street_line1 street1,
        a.spraddr_street_line2 street2,
        a.spraddr_street_line3 street3,
        a.spraddr_city city,
        a.spraddr_stat_code state,
        a.spraddr_zip zip,
        a.spraddr_atyp_code atyp
    from
        spraddr a
    where
        a.spraddr_atyp_code = 'MA'
    and a.spraddr_seqno = (
        select
            max(b.spraddr_seqno)
        from
            spraddr b
        where
            b.spraddr_pidm = a.spraddr_pidm
        and b.spraddr_atyp_code = 'MA'
    and a.spraddr_activity_date = (
        select
            max(c.spraddr_activity_date)
        from
            spraddr c
        where
            c.spraddr_pidm = a.spraddr_pidm
        and c.spraddr_atyp_code = 'MA'
        and c.spraddr_seqno = a.spraddr_seqno)
))

,pcphone AS(
    select
        a.sprtele_pidm pidm,
        a.sprtele_phone_area||a.sprtele_phone_number phone
    from
        sprtele a
    where
        a.sprtele_tele_code = 'PC'
    and a.sprtele_seqno = (
        select
            max(b.sprtele_seqno)
        from
            sprtele b
        where
            b.sprtele_pidm = a.sprtele_pidm
        and b.sprtele_tele_code = 'PC')
    and a.sprtele_activity_date = (
        select
            max(c.sprtele_activity_date)
        from
            sprtele c
        where
            c.sprtele_pidm = a.sprtele_pidm
        and c.sprtele_tele_code = 'PC'
        and c.sprtele_seqno = a.sprtele_seqno)
)

,acphone AS(
    select
        a.sprtele_pidm pidm,
        a.sprtele_phone_area||a.sprtele_phone_number phone
    from
        sprtele a
    where
        a.sprtele_tele_code = 'AC'
    and a.sprtele_seqno = (
        select
            max(b.sprtele_seqno)
        from
            sprtele b
        where
            b.sprtele_pidm = a.sprtele_pidm
        and b.sprtele_tele_code = 'AC')
    and a.sprtele_activity_date = (
        select
            max(c.sprtele_activity_date)
        from
            sprtele c
        where
            c.sprtele_pidm = a.sprtele_pidm
        and c.sprtele_tele_code = 'AC'
        and c.sprtele_seqno = a.sprtele_seqno)
)

,main_1 AS
 (
  -- REPORT FORMAT
  Select

  -- ESF/SU ID DETAILS & EMAIL
   S.SPRIDEN_ID Banner_ID,
    f_format_name(S.SPRIDEN_PIDM, 'LFMI') Student_Name,
    SP.SPBPERS_PREF_FIRST_NAME Pref_First_Name,
    a.GOREMAL_EMAIL_ADDRESS Email_Address,
    GORADID.GORADID_ADDITIONAL_ID SUID,
    SP.SPBPERS_SEX Sex,

    -- ADVISEMENT DETAILS
    STVCLAS.STVCLAS_DESC Student_Class,
    SGBSTDN.SGBSTDN_PROGRAM_1 Student_Program,
    SGBSTDN.SGBSTDN_DEGC_CODE_1 Deg_Program,
    STVMAJR.STVMAJR_DESC Program_of_Study,
    STVMAJR1.STVMAJR_DESC Major_Conc,
    STVDEPT.STVDEPT_DESC Dept_Desc,
    STVSTYP.STVSTYP_DESC Reg_Type,
    SGBSTDN.SGBSTDN_EXP_GRAD_DATE Exp_Grad_Date,
    case
      when advr_name.pidm IS NULL then
       'NAME NOT FOUND FOR PIDM:'
      when advr_name.pref_fname IS NULL then
       advr_name.lname || ', ' || advr_name.fname
      else
       advr_name.lname || '. ' || advr_name.pref_fname
    end Advisor_Name,
    GOREMAL1.GOREMAL_EMAIL_ADDRESS Advisor_Email,
    trunc(SHRTGPA.SHRTGPA_GPA, 3) Semester_GPA,
/* [HELPDESK REQUEST: #11605]
    SHRTGPA.SHRTGPA_HOURS_ATTEMPTED as CREDIT_HOURS_ATTEMPTED,
    SHRTGPA.SHRTGPA_HOURS_EARNED as CREDIT_HOURS_EARNED,
    SHRTGPA.SHRTGPA_GPA_HOURS as GPA_CREDIT_HOURS,
    */
    trunc(SHRLGPA.SHRLGPA_GPA, 3) Cumulative_GPA,
/* [HELPDESK REQUEST: #11605]
    SHRLGPA.SHRLGPA_HOURS_ATTEMPTED as TOTAL_HOURS_ATTEMPTED,
    SHRLGPA.SHRLGPA_HOURS_EARNED as TOTAL_HOURS_EARNED,
    SHRLGPA.SHRLGPA_GPA_HOURS as TOTAL_CREDIT_HOURS,
    */
    case
      when SP.SPBPERS_CITZ_CODE = 'Y' then
       'United States'
      else
       (select STVNATN_NATION
          from STVNATN
         where STVNATN_CODE =
               nvl(GOBINTL_NATN_CODE_LEGAL, GOBINTL_NATN_CODE_BIRTH))
    end as Citz_Country,
    praddr.street1 pr_street1,
    praddr.street2 pr_street2,
    praddr.street3 pr_street3,
    praddr.city pr_city,
    praddr.state pr_state,
    praddr.zip pr_zip,
    maaddr.street1 ma_street1,
    maaddr.street2 ma_street2,
    maaddr.street3 ma_street3,
    maaddr.city ma_city,
    maaddr.state ma_state,
    maaddr.zip ma_zip,
    pcphone.phone pc_phone,
    acphone.phone ac_phone


  -- SOURCES
    from -- IDENTIFICATION
           SPRIDEN S

    left outer join SPBPERS SP
      on SP.SPBPERS_PIDM = S.SPRIDEN_PIDM

    left outer join GOBINTL GOBINTL
      on GOBINTL.GOBINTL_PIDM = S.SPRIDEN_PIDM

  --SU Identification
    left outer join GORADID GORADID
      on GORADID.GORADID_PIDM = S.SPRIDEN_PIDM
     and GORADID.GORADID_ADID_CODE = 'SUID'

  -- ADVISEMENT INFORMATION
    left outer join sgradvr SGRADVR
      on SGRADVR.sgradvr_pidm = S.SPRIDEN_PIDM
     and SGRADVR.SGRADVR_ADVR_PIDM is not null
     and SGRADVR.SGRADVR_SURROGATE_ID =
         (select max(SGRADVR_SURROGATE_ID)
            from SGRADVR SGRADVRX
           where SGRADVRX.SGRADVR_PIDM = S.SPRIDEN_PIDM
             and SGRADVRX.SGRADVR_ADVR_PIDM is not null
             and SGRADVRX.SGRADVR_PRIM_IND = 'Y')
  -- EMAIL
    left outer join GOREMAL a
      on a.GOREMAL_PIDM = S.SPRIDEN_PIDM
     and a.GOREMAL_EMAL_CODE = 'SU'
      and a.goremal_activity_date =
         (select MAX(b.goremal_activity_date)
            from goremal b
           where b.goremal_pidm = a.goremal_pidm
             and b.goremal_emal_code = 'SU')

    left outer join GOREMAL GOREMAL1
      on GOREMAL1.GOREMAL_PIDM = SGRADVR.SGRADVR_ADVR_PIDM
     and GOREMAL1.GOREMAL_EMAL_CODE = 'SU'
     and goremal1.goremal_activity_date =
         (select MAX(goremal2.goremal_activity_date)
            from goremal goremal2
           where goremal2.goremal_pidm = goremal1.goremal_pidm
             and goremal2.goremal_emal_code = 'SU')

  -- TERM SELECTION
    join STVTERM STVTERM
      on STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE

  -- STUDENT DATA
    left outer join SGBSTDN SGBSTDN
      on SGBSTDN.SGBSTDN_PIDM = S.SPRIDEN_PIDM
     and SGBSTDN.SGBSTDN_TERM_CODE_EFF =
         fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
     and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
     and SGBSTDN.SGBSTDN_STST_CODE = 'AS'

    left outer join SHRTGPA SHRTGPA
      on SHRTGPA.SHRTGPA_PIDM = S.SPRIDEN_PIDM
     and SHRTGPA.SHRTGPA_TERM_CODE = STVTERM.STVTERM_CODE
     and SHRTGPA.SHRTGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE -- Added check for level on term GPA ACK 7/18/22
     and SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'

    left outer join SHRLGPA SHRLGPA
      on SHRLGPA.SHRLGPA_PIDM = S.SPRIDEN_PIDM
     and SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
     and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'

  -- Additional Details
    left outer join STVDEPT STVDEPT
      on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
    left outer join STVSTYP STVSTYP
      on STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE
    left outer join STVMAJR STVMAJR
      on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    left outer join STVMAJR STVMAJR1
      on STVMAJR1.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1
    left outer join STVCLAS STVCLAS
      on STVCLAS.STVCLAS_CODE =
         f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,
                          SGBSTDN.SGBSTDN_LEVL_CODE,
                          STVTERM.STVTERM_CODE)
    left outer join advr_name
      on advr_name.pidm = sgradvr_advr_pidm
    left outer join praddr on praddr.pidm = sgbstdn_pidm
    left outer join pcphone on pcphone.pidm = sgbstdn_pidm
    left outer join acphone on acphone.pidm = sgbstdn_pidm
    left outer join maaddr on maaddr.pidm = sgbstdn_pidm

  -- CONDITIONS
   where S.SPRIDEN_NTYP_CODE is null
     and S.SPRIDEN_CHANGE_IND is null

        -- TERM ENROLLMENT CHECK
     and exists (select *
            from SFRSTCR SFRSTCR
           where SFRSTCR.SFRSTCR_PIDM = S.SPRIDEN_PIDM
             and SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE
             and SFRSTCR.SFRSTCR_RSTS_CODE like 'R%')

        -- DEGREE REG CHECK
     and not exists
   (select *
            from SHRDGMR
           where SHRDGMR_PIDM = S.SPRIDEN_PIDM
             and SHRDGMR_DEGS_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
             and SHRDGMR.SHRDGMR_COLL_CODE_1 in ('EF') --*SECTION LIKELY TO FACE REMOVAL*
             and SHRDGMR.SHRDGMR_DEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
             and SHRDGMR.SHRDGMR_MAJR_CODE_CONC_1 =
                 SGBSTDN.SGBSTDN_MAJR_CODE_1
             and SHRDGMR.SHRDGMR_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
             and SHRDGMR.SHRDGMR_DEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
             and SHRDGMR.SHRDGMR_TERM_CODE_GRAD <= STVTERM.STVTERM_CODE

          )

--$addfilter

--$beginorder

  -- GROUPING/ORDERING
   order by SGBSTDN.SGBSTDN_DEPT_CODE,
             S.SPRIDEN_SEARCH_LAST_NAME,
             S.SPRIDEN_SEARCH_FIRST_NAME
             --$endorder
)

select * from main_1
