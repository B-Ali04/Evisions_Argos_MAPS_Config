-- REPORT FORMAT
select

      -- ESF/SU ID DETAILS
     SPRIDEN.SPRIDEN_ID as BANNER_ID,
     SPRIDEN_LAST_NAME as Last_Name,
     SPRIDEN_FIRST_NAME as First_Name,
     GORADID.GORADID_ADDITIONAL_ID as SUID,
     F_FORMAT_NAME(SPRIDEN.SPRIDEN_PIDM, 'LF30') as LegalName,

     -- ADVISEMENT DETAILS
     SGBSTDN.SGBSTDN_STYP_CODE as Reg_Type,
     SGBSTDN.SGBSTDN_PROGRAM_1 as Program,
     f_get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, STVTERM.STVTERM_CODE), 30) as Student_Class,
     f_get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as Program_of_Study,
     f_get_desc_fnc('STVDEGC', SGBSTDN.SGBSTDN_DEGC_CODE_1, 30) as Degree_Prog,

     -- COURSE REGISTRATION DETAILS
     SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID as Course_Key,
     SSBSECT.SSBSECT_CRN as Course_CRN,
     SSBSECT.SSBSECT_SEQ_NUMB as Seq_Numb,
     F_GET_DESC_FNC('STVTERM', SFRSTCR.SFRSTCR_TERM_CODE, 30) as RegTerm,
     F_GET_DESC_FNC('STVRSTS', SFRSTCR.SFRSTCR_RSTS_CODE, 30) as Course_Reg_Status,
     -- SORTING FIELDS
     SPRIDEN.SPRIDEN_SEARCH_LAST_NAME as LNS_Value

from
    STVTERM STVTERM

    -- IDENTIFICATION
    join SPRIDEN SPRIDEN on SPRIDEN.SPRIDEN_PIDM is not null

    left outer join GORADID GORADID on GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
         and GORADID.GORADID_ADID_CODE = 'SUID'

    -- STUDENT DATA
    left outer join SGBSTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)
         and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
         and SGBSTDN.SGBSTDN_STST_CODE in ('AS')

    -- COURSE INFORMATION
    left outer join SFRSTCR SFRSTCR on SFRSTCR.SFRSTCR_PIDM = SPRIDEN.SPRIDEN_PIDM

    left outer join SSBSECT SSBSECT on SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN
         and SSBSECT.SSBSECT_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE

    left outer join SCBCRSE SCBCRSE on SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
          and SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
          and SCBCRSE.SCBCRSE_EFF_TERM = (select max(SCBCRSE.SCBCRSE_EFF_TERM)
                                         from SCBCRSE SCBCRSEX
                                         where SCBCRSEX.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
                                         and SCBCRSEX.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
                                         and SCBCRSEX.SCBCRSE_EFF_TERM <= SSBSECT.SSBSECT_TERM_CODE
                                   )
-- CONDITIONS
where
     SPRIDEN.SPRIDEN_NTYP_CODE is null
     and SPRIDEN.SPRIDEN_CHANGE_IND is null

     and not exists(
             select *
             from SFRWDRL SFRWDRL
             where SFRWDRL.SFRWDRL_PIDM = SPRIDEN.SPRIDEN_PIDM
             and SFRWDRL.SFRWDRL_TERM_CODE = SGBSTDN.SGBSTDN_TERM_CODE_EFF
             )
     and 'Y' = f_registered_this_term(SFRSTCR.SFRSTCR_PIDM, STVTERM.STVTERM_CODE)
     and stvterm.stvterm_code = :parm_term_code_select.STVTERM_CODE
     and SFRSTCR.SFRSTCR_TERM_CODE <= STVTERM.STVTERM_CODE
     and SFRSTCR.SFRSTCR_RSTS_CODE = 'DC'
     and SGBSTDN_DEPT_CODE = 'ERE'

--$addfilter
--$beginorder

-- GROUPING/ORDERING
order by
      SPRIDEN.SPRIDEN_SEARCH_LAST_NAME, SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME, STVTERM.STVTERM_CODE
--$endorder