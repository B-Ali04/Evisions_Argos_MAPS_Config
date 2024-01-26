        /**
        ssbsect_subj_code = :select_subj_code.SUBJ_CODE
        and ssbsect_crse_numb = :select_crse_numb.CRSE_NUMB
        and ssbsect_term_code = :select_term_code.STVTERM_CODE
        **/
        --sfrstcr_crn = :select_crn.CRN
        ssbsect_term_code = :select_term_code.STVTERM_CODE
        and ssbsect_crn = :select_crn.CRN


/*
(
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
    ))
*/

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SSBSECT_SUBJ_CODE,
    SSBSECT_CRSE_NUMB,
    SSBSECT_SEQ_NUMB,
    SGBSTTDN_MAJR_DESC