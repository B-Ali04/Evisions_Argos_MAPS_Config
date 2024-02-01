/*
EXISTS(select * from sfrstcr a
where a.sfrstcr_pidm = spriden_pidm
and a.sfrstcr_term_code = sfrstcr_term_code
and a.sfrstcr_crn = sfrstcr_crn
and a.sfrstcr_rsts_code != sfrstcr_rsts_Code)
*/
SFRSTCR_RSTS_CODE IN ('AW', 'DC', 'DD', 'DW', 'MW', 'WS', 'WW')