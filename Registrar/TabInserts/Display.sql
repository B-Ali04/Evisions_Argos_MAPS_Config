SELECT

--SPRIDEN.SPRIDEN_LAST_NAME AS LNAME,
--SPRIDEN.SPRIDEN_MI AS MI,
--SPRIDEN.SPRIDEN_FIRST_NAME AS FNAME,
F_FORMAT_NAME(SPRIDEN.SPRIDEN_PIDM, 'LFMI') AS STDN_NAME,
f_get_Desc_fnc('STVSTYP', SGBSTDN.SGBSTDN_STYP_CODE, 30) as STDNTYP,
SPRIDEN.SPRIDEN_ID AS BANNER_ID

FROM

SPRIDEN SPRIDEN

--SARAPPD SARAPPD

LEFT OUTER JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = :LISTBOX1.STVTERM_CODE
LEFT OUTER JOIN SARAPPD SARAPPD ON SARAPPD.SARAPPD_PIDM = SPRIDEN.SPRIDEN_PIDM
LEFT OUTER JOIN SGBSTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
     AND SGBSTDN.SGBSTDN_TERM_CODE_EFF = FY_SGBSTDN_EFF_TERM(SGBSTDN.SGBSTDN_PIDM, STVTERM.STVTERM_CODE)

WHERE
SPRIDEN_NTYP_CODE IS NULL
AND SPRIDEN_CHANGE_IND IS NULL

AND SARAPPD.SARAPPD_TERM_CODE_ENTRY = STVTERM.STVTERM_CODE
AND SARAPPD.SARAPPD_APPL_NO = (SELECT MAX(SARAPPD_APPL_NO)
                              FROM SARAPPD SARAPPDX
                              WHERE SARAPPDX.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM
                              AND SARAPPDX.SARAPPD_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY)
AND SARAPPD.SARAPPD_SEQ_NO = (SELECT MAX(SARAPPD_SEQ_NO)
                              FROM SARAPPD SARAPPDX
                              WHERE SARAPPDX.SARAPPD_PIDM = SARAPPD.SARAPPD_PIDM
                              AND SARAPPDX.SARAPPD_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY)
AND SARAPPD.SARAPPD_APDC_CODE IN ('AP', 'AC')

ORDER BY SPRIDEN.SPRIDEN_SEARCH_LAST_NAME