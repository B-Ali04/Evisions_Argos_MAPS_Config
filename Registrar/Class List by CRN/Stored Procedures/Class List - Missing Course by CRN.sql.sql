(
    not exists(
        select * from sfrstca
        left outer join ssbsect ssbsect on ssbsect_crn = sfrstca_crn
        where sfrstca_pidm = spriden_pidm
        and sfrstca_crn = ssbsect_crn
        and ssbsect_subj_code = :select_subj_code.SUBJ_CODE
        and ssbsect_crse_numb = :select_crse_numb.CRSE_NUMB
        and ssbsect_term_Code <= stvterm_code
    )
    or not exists(
        select * from sfrstca
        left outer join ssbsect ssbsect on ssbsect_crn = sfrstca_crn
        where sfrstca_pidm = spriden_pidm
        and sfrstca_crn = ssbsect_crn
        and ssbsect_crn = :select_crn.CRN
        and ssbsect_term_Code <= stvterm_code
    ))

    and sfrstcr_surrogate_id = (
        select max(sfrstcr_surrogate_id)
        from sfrstcr sfrstcrx
        where sfrstcrx.sfrstcr_pidm = sfrstcr.sfrstcr_pidm
        and sfrstcrx.sfrstcr_term_code <= sfrstcr.sfrstcr_term_code
    )
/*
and sgradvr_surrogate_id = (
    select max(sgradvr_surrogate_id)
    from sgradvr sgradvrx
    where sgradvrx.sgradvr_pidm = sgradvr.sgradvr_pidm
    )
    */

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SSBSECT_SUBJ_CODE,
    SSBSECT_CRSE_NUMB,
    SSBSECT_SEQ_NUMB,
    SGBSTTDN_MAJR_DESC