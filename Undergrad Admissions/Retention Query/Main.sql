select r.pidm,
    case
       when spbpers.spbpers_pref_first_name is not null and spbpers.spbpers_pref_first_name <> spriden.spriden_first_name
          then spriden.spriden_last_name || ', ' || spriden.spriden_first_name || ' (' || spbpers.spbpers_pref_first_name || ')'
       else
           f_format_name(SPRIDEN.SPRIDEN_PIDM,'LF')
       end as "Student",
    suid.goradid_additional_id as SUID,
    SPBPERS.SPBPERS_sex as "Gender",
    SGBSTDN.SGBSTDN_RESD_CODE as "Residence",
    STVMAJR.STVMAJR_DESC "ProgramOfStudy",
    r.STYP_DESC as "RegType",
    case
        when SGRADVR.advr_PIDM is null then ''
        else f_format_name(SGRADVR.advr_PIDM,'LF30')
    end as "Advisor",
    case
        when spbpers_ethn_cde = 2 then 1
        else coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '40'),0)
    end as RaceHisp,
    coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '70'),0) as RaceWhite,
    coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '30'),0) as RaceBlack,
    coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '20'),0) as RaceAsian,
    coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '50'),0) as RaceHaw,
    coalesce((select 1 from rel_race rac where r.pidm = rac.pidm and rac.race_code = '10'),0) as RaceNative,
    case
        when exists (select * from rel_race rac where r.pidm = rac.pidm) then 0
        else 1
    end as RaceUnk,
    (select max(sfrstcr_term_code) from sfrstcr regt where regt.sfrstcr_pidm = r.pidm and regt.sfrstcr_rsts_code = 'RE') as LastRegTerm
from
    rel_student r
    left outer join spriden spriden on spriden.spriden_pidm = r.pidm and spriden.spriden_id like 'F%'
    and SPRIDEN_CHANGE_IND is null
    left outer join GORADID suid on suid.goradid_pidm = SPRIDEN.SPRIDEN_PIDM and suid.goradid_adid_code = 'SUID'
    left outer join rel_student_advisor SGRADVR on
         sgradvr.pidm = SPRIDEN.SPRIDEN_PIDM
         and sgradvr.term_code = r.term_code
         and sgradvr.primary_ind = 1
         and SGRADVR.PIDM like '%'
    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
        and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SPRIDEN.SPRIDEN_PIDM,r.term_code)
    left outer join STVMAJR STVMAJR on STVMAJR.STVMAJR_CODE = SGBSTDN.SGBSTDN_MAJR_CODE_1
    left outer join SPBPERS SPBPERS on SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
where
    r.TERM_CODE = :ddEntryTerm.STVTERM_CODE
    and STVMAJR_CODE not in ('SUS','EHS') -- exclude SU Accessory Instruction and ESFHS students.
    and exists
        (select 1 from sfrstcr
        where spriden_pidm = sfrstcr_pidm
          and sfrstcr_term_code = r.TERM_CODE and sfrstcr_rsts_code = 'RE')
    and r.pidm in (
            select distinct r1.sfrstcr_pidm from sfrstcr r1
            where r1.sfrstcr_pidm in (
                  select s.sgbstdn_pidm
                  from sgbstdn s
                  where s.sgbstdn_term_code_admit = :ddEntryTerm.STVTERM_CODE
                  and s.sgbstdn_levl_code = 'UG' and s.sgbstdn_styp_code = 'F'
              )
              and r1.sfrstcr_term_code = :ddEntryTerm.STVTERM_CODE and r1.sfrstcr_rsts_code = 'RE' -- has registrations in the entry term
         )
    --$addfilter
--$beginorder
order by
    LastRegTerm, SPRIDEN.Spriden_Search_Last_Name, SPRIDEN.Spriden_Search_First_Name
--$endorder