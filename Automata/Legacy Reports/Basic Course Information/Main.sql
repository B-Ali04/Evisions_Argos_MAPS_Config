with SCACRSE as
(

    select
        SSBSECT_TERM_CODE as SSBSECT_TERM_CODE,
        SSBSECT_CRN as SSBSECT_CRN,
        SSBSECT_PTRM_CODE as SSBSECT_PTRM_CODE,
        SSBSECT_SUBJ_CODE as SSBSECT_SUBJ_CODE,
        SSBSECT_CRSE_NUMB as SSBSECT_CRSE_NUMB,
        SSBSECT_SEQ_NUMB as SSBSECT_SEQ_NUMB,
        SSBSECT_CAMP_CODE as SSBSECT_CAMP_CODE,
        SSBSECT_GMOD_CODE as SSBSECT_GMOD_CODE,
        SSBSECT_SEATS_AVAIL,
        SSBSECT_TOT_CREDIT_HRS,
        SSBSECT_CENSUS_ENRL,
        SSBSECT_CENSUS_ENRL_DATE,
        SSBSECT_PTRM_START_DATE,
        SSBSECT_PTRM_END_DATE,
        SSBSECT_SICAS_CAMP_COURSE_ID as SSBSECT_SICAS_CAMP_COURSE_ID,
        SIRDPCL.SIRDPCL_PIDM,
        case
          when SIRDPCL.SIRDPCL_PIDM is not null then F_FORMAT_NAME(SIRDPCL.SIRDPCL_PIDM, 'LF30')
            else ''
              end as SIRDPCL_INSTR_NAME, --Primary_Instr_Name,
        SIRDPCL.SIRDPCL_SURROGATE_ID

   from
        SSBSECT SSBSECT
        left outer join SIRASGN SIRASGN on SIRASGN.SIRASGN_CRN = SSBSECT.SSBSECT_CRN
             and SIRASGN.SIRASGN_TERM_CODE = SSBSECT.SSBSECT_TERM_CODE
             and SIRASGN.SIRASGN_CATEGORY = 01

        left outer join SIRDPCL SIRDPCL on SIRDPCL.SIRDPCL_PIDM = SIRASGN.SIRASGN_PIDM

   where
        SIRDPCL.SIRDPCL_SURROGATE_ID = (select max(SIRDPCL_SURROGATE_ID)
                                       from SIRDPCL SIRDPCLx
                                       where SIRDPCLX.SIRDPCL_PIDM = SIRDPCL.SIRDPCL_PIDM)
    )

select
    STVTERM.STVTERM_DESC as From_Term,
    SSBSECT_SUBJ_CODE as Subj_Code,
    SSBSECT_CRSE_NUMB as Crse_No,
    SSBSECT_SEQ_NUMB as Seq_No,
    SSBSECT_CRN as CRN,
    SCBCRSE_TITLE as Title,
    SIRDPCL_INSTR_NAME as Primary_Instr,
    SSBSECT_SICAS_CAMP_COURSE_ID as Course_Key,
    SCBCRSE_DEPT_CODE as Dept,
    f_get_desc_fnc('STVDEPT', SCBCRSE_DEPT_CODE, 30) as Dept_Desc,
    SSBSECT_CAMP_CODE as Campus,
    SSBSECT_PTRM_CODE  as Session_Code,
    SCBCRSE_CREDIT_HR_LOW as Credit_HR,
    SSBSECT_SEATS_AVAIL as Avail_Seats,
    SSBSECT_TOT_CREDIT_HRS as TOT_Credit_HR,
    SSBSECT_CENSUS_ENRL as TOT_ENRL,
    SCBCRSE_CSTA_CODE as Active,
    SSRMEET_START_DATE as Start_Date,
    SSRMEET_END_DATE as End_date,
    SSRMEET_BEGIN_TIME as Start_Time,
    SSRMEET_END_TIME as End_Time,
    SSRMEET_BLDG_CODE as Building,
    SSRMEET_ROOM_CODE as Room,
    SCBCRSE_CIPC_CODE as CIP,
    SSRMEET_ACTIVITY_DATE as Recent_Activity

from
    STVTERM STVTERM
    left outer join SCACRSE SSBSECT on SSBSECT.SSBSECT_TERM_CODE = STVTERM.STVTERM_CODE
    left outer join SCBCRSE SCBCRSE on SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
               and SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
    left outer join SSRMEET SSRMEET on SSRMEET.SSRMEET_TERM_CODE = SSBSECT.SSBSECT_TERM_CODE
               and SSRMEET.SSRMEET_CRN = SSBSECT.SSBSECT_CRN

where
    STVTERM.STVTERM_CODE = :select_term_code.STVTERM_CODE

/*
in case that duplicate thing becomes an issue

    and SCBCRSE_EFF_TERM = (select max(SCBCRSE_EFF_TERM)
                           from   SCBCRSE SCBCRSEX
                           where  SCBCRSEX.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
                           and    SCBCRSEX.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
                           and    SCBCRSEX.SCBCRSE_EFF_TERM <= STVTERM.STVTERM_CODE)
*/

--$addfilter

--$beginorder

order by

    SSBSECT_SICAS_CAMP_COURSE_ID,
    SSBSECT_SEQ_NUMB


--$endorder