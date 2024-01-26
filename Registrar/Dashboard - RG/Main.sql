SELECT
     SFRSTCR.SFRSTCR_PIDM,
     SPRIDEN.SPRIDEN_ID AS BANNER_ID,
     f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') AS FULL_NAME,

     SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID AS COURSE_ID,
     SSBSECT.SSBSECT_SEQ_NUMB AS SECTION,
     SSBSECT.SSBSECT_CAMP_CODE AS CAMPUS,
     SCBCRSE.SCBCRSE_TITLE AS COURSE_TITLE,
     SCBCRSE_LEC_HR_LOW AS CREDIT_HOUR,
     f_format_name(RII.PIDM, 'LF30') AS INSTURCTOR_NAME,
     SFRSTCR.*

FROM SFRSTCR SFRSTCR

JOIN SPRIDEN SPRIDEN ON SPRIDEN.SPRIDEN_PIDM = SFRSTCR.SFRSTCR_PIDM
     AND SPRIDEN_CHANGE_IND IS NULL
     AND SPRIDEN_NTYP_CODE IS NULL


JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE IS NOT NULL
     AND STVTERM.STVTERM_CODE = (SELECT MAX(STVTERM_CODE)
                                FROM STVTERM STVTERMX
                                WHERE STVTERMX.STVTERM_CODE IS NOT NULL
                                AND STVTERMX.STVTERM_START_DATE <= SYSDATE
                                AND STVTERMX.STVTERM_END_DATE >= SYSDATE
                                AND STVTERMX.STVTERM_CODE NOT LIKE '%%%%10'
                                AND STVTERMX.STVTERM_CODE NOT LIKE '%%%%20'
                                AND STVTERMX.STVTERM_CODE NOT LIKE '%%%%30'
                                AND STVTERMX.STVTERM_CODE NOT LIKE '%%%%40'
--                              AND STVTERMX.STVTERM_CODE NOT LIKE '%%%%50'
                                )
                                    --select * from scbcrse

LEFT OUTER JOIN SIRASGN SIRASGN ON SIRASGN.SIRASGN_CRN = SFRSTCR_CRN
     AND SIRASGN_TERM_CODE = STVTERM.STVTERM_CODE

LEFT OUTER JOIN REL_IDENTITY_INSTRUCTOR RII ON RII.PIDM = SIRASGN.SIRASGN_PIDM

LEFT OUTER JOIN SSBSECT SSBSECT ON SSBSECT.SSBSECT_TERM_CODE = SFRSTCR.SFRSTCR_TERM_CODE
     AND SSBSECT.SSBSECT_CRN = SFRSTCR.SFRSTCR_CRN

JOIN SCBCRSE SCBCRSE ON SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
     AND SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
     AND SCBCRSE.SCBCRSE_EFF_TERM = (SELECT MAX(SCBCRSE.SCBCRSE_EFF_TERM)
                                    FROM SCBCRSE SCBCRSEX
                                    WHERE SCBCRSEX.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
                                    AND SCBCRSEX.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
                                    AND SCBCRSEX.SCBCRSE_EFF_TERM <= SSBSECT.SSBSECT_TERM_CODE
                                    )
WHERE SFRSTCR.SFRSTCR_LEVL_CODE = 'GR'
AND SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE

ORDER BY SPRIDEN_SEARCH_LAST_NAME, SPRIDEN_SEARCH_FIRST_NAME, SSBSECT.SSBSECT_SICAS_CAMP_COURSE_ID

/*
FROM IS-SERVER01 : LEGACY

INNER JOIN MN..vwMN_Names_Current Nam on Nam.RecID = Ts.RecID
INNER JOIN RG..StudentCourses sc on sc.recid = ts.recid and sc.semester = ts.semester
  and sc.crsactioncd <> 'D'
  and substring(sc.CourseID,4,1) >= '5'
  and sc.auditnc <> 'WD'
INNER JOIN CR..TermCourses tc on tc.CollInstr = sc.CollInstr
  AND tc.Semester = sc.Semester and tc.CourseID = sc.CourseID
        AND tc.CampusCd = sc.CampusCd and tc.InstrTyp = sc.InstrTyp
  AND tc.SectNbr = sc.SectNbr
WHERE Ts.Semester  = @Semester
  AND Ts.CollEnroll = '37'
  AND Ts.ClassLevel in ('L8', 'U8', 'A9', 'B9')
ORDER BY nam.fullname, sc.CourseID, sc.SectNbr

SELECT  nam.FullName,
        sc.CourseId,
        sc.sectNbr,
        'Course Title' = tc.CourseTitle
FROM RG..TermSummaries Ts
INNER JOIN MN..vwMN_Names_Current Nam on Nam.RecID = Ts.RecID
INNER JOIN RG..StudentCourses sc on sc.recid = ts.recid and sc.semester = ts.semester
  and sc.crsactioncd <> 'D'
  and substring(sc.CourseID,4,1) >= '5'
  and sc.auditnc <> 'WD'
INNER JOIN CR..TermCourses tc on tc.CollInstr = sc.CollInstr
  AND tc.Semester = sc.Semester and tc.CourseID = sc.CourseID
        AND tc.CampusCd = sc.CampusCd and tc.InstrTyp = sc.InstrTyp
  AND tc.SectNbr = sc.SectNbr
WHERE Ts.Semester  = @Semester
  AND Ts.CollEnroll = '37'
  AND Ts.ClassLevel in ('L8', 'U8', 'A9', 'B9')
ORDER BY nam.fullname, sc.CourseID, sc.SectNbr


*/
