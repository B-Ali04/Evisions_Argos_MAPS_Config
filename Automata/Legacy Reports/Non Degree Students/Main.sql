SELECT
    SPRIDEN.SPRIDEN_ID AS Banner_ID,
    f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LF30') AS FULL_NAME,
    STVTERM.STVTERM_DESC AS TERM,
    SGBSTDN.SGBSTDN_LEVL_CODE AS CLASS_LEVEL,
    STVSTYP.STVSTYP_DESC AS STUDENT_TYPE,
    SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
    SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME,
    SGBSTDN.*

FROM SGBSTDN SGBSTDN

     LEFT OUTER JOIN SPRIDEN SPRIDEN ON SPRIDEN.SPRIDEN_PIDM = SGBSTDN.SGBSTDN_PIDM
          AND SPRIDEN_CHANGE_IND IS NULL
          AND SPRIDEN_NTYP_CODE IS NULL

     LEFT OUTER JOIN GORADID GORADID ON GORADID.GORADID_PIDM = SPRIDEN.SPRIDEN_PIDM
          AND GORADID.GORADID_ADID_CODE = 'SUID'

     JOIN STVTERM STVTERM ON STVTERM.STVTERM_CODE = :parm_term_code_select.STVTERM_CODE

JOIN STVSTYP STVSTYP ON STVSTYP.STVSTYP_CODE = SGBSTDN.SGBSTDN_STYP_CODE

--$addfilter

WHERE SGBSTDN.SGBSTDN_TERM_CODE_EFF = STVTERM.STVTERM_CODE
AND SGBSTDN.SGBSTDN_STYP_CODE IN ('X')

--$beginorder
ORDER BY SPRIDEN.SPRIDEN_SEARCH_LAST_NAME, SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME

--$endorder
/*

USE [CE]
GO
/****** Object:  StoredProcedure [dbo].[spCE_NonMatric]    Script Date: 8/2/2022 11:38:54 AM ******/
/*
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER    PROCEDURE [dbo].[spCE_NonMatric] @semester varchar(5) AS

--- CE001

SELECT Ts.RecId,
  FullName   = isnull(Nam.FullName,Ts.RecID),
    SemTitle   = ISNULL((SELECT C2.LongTitle FROM CD..vwCd_RGSemesters C2
           WHERE C2.TableCd = Ts.Semester), ''),
    ClassLvlLT = ISNULL((SELECT C2.LongTitle FROM CD..vwCd_RGClassLevels C2
           WHERE C2.TableCd = Ts.ClassLevel), '')
FROM RG..TermSummaries Ts
LEFT OUTER JOIN MN..vwMN_Names_Current Nam on Nam.RecID = Ts.RecID
WHERE Ts.Semester  = @Semester
  AND Ts.CollEnroll = '37'
  AND Ts.ClassLevel in ('L8', 'U8', 'A9', 'B9')
  AND Ts.RegisterDt <> '1/1/1900'
  AND EXISTS (SELECT * FROM RG..StudentCourses Sc
              WHERE Sc.RecID = Ts.RecID
                AND Sc.Semester = Ts.Semester
                AND Sc.CrsActionCd <> 'D')

*/
