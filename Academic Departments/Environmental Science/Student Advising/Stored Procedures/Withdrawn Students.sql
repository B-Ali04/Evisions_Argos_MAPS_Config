EXISTS(
SELECT *
FROM SFRWDRL
WHERE SFRWDRL_PIDM = SPRIDEN_PIDM
AND SFRWDRL_TERM_CODE = :select_term_code.STVTERM_CODE
AND SFRWDRL_ESTS_CODE IN (SELECT STVESTS_CODE FROM STVESTS))
