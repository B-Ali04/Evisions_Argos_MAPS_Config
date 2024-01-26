SELECT
    goradid_additional_id suid,
    spriden_id bid,
    spriden_last_name lname,
    spriden_first_name fname,
    a.sgbstdn_styp_code styp,
    a.sgbstdn_majr_code_1 majr,
    a.sgbstdn_degc_code_1 degc
FROM
    spriden,
    sgbstdn a,
    goradid
WHERE
    a.sgbstdn_pidm = spriden_pidm
AND a.sgbstdn_term_code_eff = (
    SELECT
        MAX(b.sgbstdn_term_code_eff)
    FROM
        sgbstdn b
    WHERE
        b.sgbstdn_pidm = a.sgbstdn_pidm)
AND a.sgbstdn_styp_code = 'X'
AND a.sgbstdn_majr_code_1 = 'SUS'
AND a.sgbstdn_pidm IN
    (SELECT DISTINCT
         sfrstcr_pidm
     FROM
         sfrstcr
     WHERE
         sfrstcr_pidm = a.sgbstdn_pidm
     AND sfrstcr_term_code = :ddSemester.STVTERM_CODE
     AND sfrstcr_rsts_code = 'RE')
AND spriden_change_ind is null
AND goradid_pidm (+)= spriden_pidm
AND goradid_adid_code (+)= 'SUID'
ORDER BY
    spriden_last_name,
    spriden_first_name
