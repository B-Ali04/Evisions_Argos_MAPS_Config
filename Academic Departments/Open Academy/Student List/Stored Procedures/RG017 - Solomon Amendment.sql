EXISTS(SELECT SPBPERS_BIRTH_DATE
      FROM    SPBPERS
      WHERE   SPBPERS_PIDM = SPRIDEN_PIDM
      AND     SPBPERS_BIRTH_DATE <= SYSDATE - 6205)

AND EXISTS(SELECT *
          FROM    SHAGPAR
          WHERE   SHRLGPA_PIDM = SPRIDEN_PIDM
          AND     SHRLGPA_HOURS_EARNED > 0)

ORDER BY
    SPRIDEN_LAST_NAME,
    SPRIDEN_FIRST_NAME,
    SPRIDEN_MI