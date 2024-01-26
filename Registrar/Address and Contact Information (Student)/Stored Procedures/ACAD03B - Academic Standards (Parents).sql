EXISTS(
    SELECT *
    FROM SHRLGPA
    WHERE
    SHRLGPA_PIDM = SPRIDEN_PIDM
    AND SHRLGPA_GPA_TYPE_IND = 'I'
    AND SHRLGPA_LEVL_CODE = SGBSTDN_LEVL_CODE
    AND(
    (
        SHRLGPA_GPA < 2.000
        and SHRLGPA_HOURS_EARNED > 60
    )
    or(
        SHRLGPA_GPA < 1.850
        and SHRLGPA_HOURS_EARNED > 30
        and SHRLGPA_HOURS_EARNED <= 60
    )
    or(
        SHRLGPA_GPA < 1.700
        and SHRLGPA_HOURS_EARNED < 30
        and SHRLGPA_HOURS_EARNED >= 0
    )
    or(
        SHRLGPA_GPA < 2.000
        and SGBSTDN_DEGC_CODE_1 = 'AAS'
    )))

AND SGBSTDN_MAJR_CODE_1 NOT IN ('0000', 'UNDC', 'EHS', 'SUS', 'VIS')
AND SPRADDR_ATYP_CODE IN ('PA')