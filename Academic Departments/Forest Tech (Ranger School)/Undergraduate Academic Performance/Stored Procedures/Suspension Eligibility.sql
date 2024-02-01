(
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
    )
)
AND SHRTTRM_ASTD_CODE_END_OF_TERM LIKE 'P%'

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI
