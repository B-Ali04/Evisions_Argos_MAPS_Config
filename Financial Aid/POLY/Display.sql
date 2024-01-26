select STVMAJR.STVMAJR_CODE "Major_Code",
       STVMAJR.STVMAJR_CODE || ' - ' || STVMAJR.STVMAJR_DESC "Major_Desc"
  from SATURN.STVMAJR STVMAJR
 where EXISTS
       (SELECT Y.SGBSTDN_MAJR_CODE_1
          FROM SFBETRM X, SGBSTDN Y
         WHERE X.SFBETRM_PIDM = Y.SGBSTDN_PIDM
           AND Y.SGBSTDN_MAJR_CODE_1 = STVMAJR.STVMAJR_CODE
           AND (:parm_CB_All_Campus = 'Y'
                OR Y.SGBSTDN_CAMP_CODE = :parm_LB_Campus.Campus_Code)
           AND Y.ROWID = F_GET_SGBSTDN_ROWID(X.SFBETRM_PIDM, :main_DD_AidYear.TERMCODE)
           AND X.SFBETRM_TERM_CODE = :main_DD_AidYear.TERMCODE)
   and :parm_CB_All_Majors <> 'Y'

UNION

SELECT '', 'All Codes'
  FROM DUAL
 WHERE :parm_CB_All_Majors = 'Y'

 order by 1