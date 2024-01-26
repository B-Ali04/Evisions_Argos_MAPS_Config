select r.pidm,
       spriden.spriden_id,
       case
         when spbpers.spbpers_pref_first_name is not null and
              spbpers.spbpers_pref_first_name <> spriden.spriden_first_name then
          spriden.spriden_last_name || ', ' || spriden.spriden_first_name || ' (' ||
          spbpers.spbpers_pref_first_name || ')'
         else
          f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LF')
       end as "Student",
       spriden.spriden_last_name,
       spriden.spriden_first_name,
       spriden.spriden_mi,
       spbpers.spbpers_pref_first_name,
       spbpers_birth_date dob,
       case
         when spbpers.spbpers_gndr_code is not null then
          (select gtvgndr_gndr_desc
             from gtvgndr
            where gtvgndr_gndr_code = spbpers.spbpers_gndr_code)
         when spbpers.spbpers_sex = 'F' then
          'Female'
         when spbpers.spbpers_sex = 'M' then
          'Male'
         else
          spbpers.spbpers_sex
       end as GenderDesignation,
       case
         when spbpers.spbpers_pprn_code is not null then
          (select gtvpprn_pprn_desc
             from gtvpprn
            where gtvpprn_pprn_code = spbpers.spbpers_pprn_code)
         else
          ''
       end as PronounDesignation,
       suid.goradid_additional_id as SUID,
       stu.sprtele_tele_code stu_tele_code,
       replace(stu.sprtele_phone_area, '-', '') ||
       replace(stu.sprtele_phone_number, '-', '') ||
       replace(stu.sprtele_phone_ext, '-', '') stu_phone,
       replace(pa.sprtele_phone_area, '-', '') ||
       replace(pa.sprtele_phone_number, '-', '') ||
       replace(pa.sprtele_phone_ext, '-', '') pa_phone,
       replace(p2.sprtele_phone_area, '-', '') ||
       replace(p2.sprtele_phone_number, '-', '') ||
       replace(p2.sprtele_phone_ext, '-', '') p2_phone,
       stuaddr.spraddr_atyp_code stu_atyp,
       stuaddr.spraddr_street_line1 stu_street1,
       stuaddr.spraddr_street_line2 stu_street2,
       stuaddr.spraddr_street_line3 stu_street3,
       stuaddr.spraddr_city stu_city,
       stuaddr.spraddr_stat_code stu_state,
       stuaddr.spraddr_zip stu_zip,
       paraddr.spraddr_street_line1 pa_street1,
       paraddr.spraddr_street_line2 pa_street2,
       paraddr.spraddr_street_line3 pa_street3,
       paraddr.spraddr_city pa_city,
       paraddr.spraddr_stat_code pa_state,
       paraddr.spraddr_zip pa_zip,
       p2addr.spraddr_street_line1 p2_street1,
       p2addr.spraddr_street_line2 p2_street2,
       p2addr.spraddr_street_line3 p2_street3,
       p2addr.spraddr_city p2_city,
       p2addr.spraddr_stat_code p2_state,
       p2addr.spraddr_zip p2_zip,
       (select listagg(sorfolk_parent_first || ' ' || sorfolk_parent_last || '-' ||
                       sorfolk_atyp_code,
                       ', ') within group(order by sorfolk_atyp_code desc) "parent_info"
          from sorfolk
         where sorfolk_pidm = sgbstdn_pidm
           and sorfolk_relt_code = 'A') parent_info,
       tzkutil.fz_GET_EMAIL(sgbstdn_pidm, 'SU') su_email,
       tzkutil.fz_GET_EMAIL(sgbstdn_pidm, 'PERS') pers_email,
       tzkutil.fz_GET_EMAIL(sgbstdn_pidm, 'PA') pa_email,
       tzkutil.fz_GET_EMAIL(sgbstdn_pidm, 'P2') p2_email,
       STVCLAS.STVCLAS_DESC "Class",
       SGBSTDN.SGBSTDN_DEGC_CODE_1 "DegProg",
       STVMAJR.STVMAJR_DESC "ProgramOfStudy",
       SGBSTDN.SGBSTDN_EXP_GRAD_DATE as "ExpGradDate"

  from rel_student r
  left outer join spriden spriden
    on spriden.spriden_pidm = r.pidm
   and spriden.spriden_id like 'F%'
   and SPRIDEN_CHANGE_IND is null
  left outer join GORADID suid
    on suid.goradid_pidm = SPRIDEN.SPRIDEN_PIDM
   and suid.goradid_adid_code = 'SUID'
  left outer join SGBSTDN SGBSTDN
    on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
   and SGBSTDN.SGBSTDN_TERM_CODE_EFF =
       (select max(SGBSTDN_TERM_CODE_EFF)
          from SGBSTDN s2
         where s2.SGBSTDN_PIDM = SGBSTDN.SGBSTDN_PIDM)
  left outer join STVDEGC STVDEGC
    on STVDEGC.STVDEGC_CODE = SGBSTDN.SGBSTDN_DEGC_CODE_1
  left outer join STVDEPT STVDEPT
    on STVDEPT.STVDEPT_CODE = SGBSTDN.SGBSTDN_DEPT_CODE
  left outer join STVMAJR STVMAJR
    on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
  left outer join STVCLAS STVCLAS
    on STVCLAS.STVCLAS_CODE =
       f_class_calc_fnc(SPRIDEN.SPRIDEN_PIDM, r.LEVL_CODE, r.TERM_CODE)
  left outer join SPBPERS SPBPERS
    on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
  left outer join sprtele stu
    on stu.rowid = tzkutil.fz_Get_Tele_ROWID(sgbstdn_pidm,
                                             'PC',
                                             'PR',
                                             'AC',
                                             'BI',
                                             'EC',
                                             'MA')

  left outer join sprtele pa
    on pa.rowid = tzkutil.fz_Get_Tele_ROWID(sgbstdn_pidm, 'PA')
  left outer join sprtele p2
    on p2.rowid = tzkutil.fz_Get_Tele_ROWID(sgbstdn_pidm, 'P2')
  left outer join spraddr stuaddr
    on stuaddr.rowid = tzkutil.fz_Get_Addr_ROWID(sgbstdn_pidm,
                                                 'PR',
                                                 'MA',
                                                 'BI',
                                                 'BU',
                                                 'TE',
                                                 'C1')
  left outer join spraddr paraddr
    on paraddr.rowid = tzkutil.fz_Get_Addr_ROWID(sgbstdn_pidm, 'PA')
  left outer join spraddr p2addr
    on p2addr.rowid = tzkutil.fz_Get_Addr_ROWID(sgbstdn_pidm, 'P2')

 where r.TERM_CODE = :ddSemester.STVTERM_CODE
   and STVMAJR_CODE not in ('SUS', 'EHS')
   and exists (select *
          from sfrstcr
         where spriden_pidm = sfrstcr_pidm
           and sfrstcr_term_code = r.TERM_CODE
           and sfrstcr_rsts_code = 'RE')
   and sgbstdn.sgbstdn_majr_code_1 = :lbPOS.STVMAJR_CODE
  and stvclas.stvclas_code = :lbClassLvl.STVCLAS_CODE
--$addfilter
--$beginorder
 order by SPRIDEN.Spriden_Search_Last_Name,
          SPRIDEN.Spriden_Search_First_Name
--$endorder
