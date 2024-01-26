-- Term Selection
select t.stvterm_desc, t.stvterm_code as TermCode
from stvterm t
where EXISTS
      (SELECT SFBETRM.SFBETRM_TERM_CODE
         FROM SFBETRM
        WHERE SFBETRM.SFBETRM_TERM_CODE = T.STVTERM_CODE)
order by 2 desc

-- campus selection
select STVCAMP.STVCAMP_CODE "Campus_Code",
       STVCAMP.STVCAMP_CODE || ' - ' || STVCAMP_DESC "Campus_Desc"
  from SATURN.STVCAMP STVCAMP
 where EXISTS
       (SELECT Y.SGBSTDN_CAMP_CODE
          FROM SFBETRM X, SGBSTDN Y
         WHERE X.SFBETRM_PIDM = Y.SGBSTDN_PIDM
           AND Y.SGBSTDN_CAMP_CODE = STVCAMP.STVCAMP_CODE
           AND Y.ROWID = F_GET_SGBSTDN_ROWID(X.SFBETRM_PIDM, :main_DD_AidYear.TERMCODE)
           AND X.SFBETRM_TERM_CODE = :main_DD_AidYear.TERMCODE)
   and :parm_CB_All_Campus <> 'Y'

UNION

SELECT '','All Codes'
  FROM DUAL
 WHERE :parm_CB_All_Campus = 'Y'

 order by 1

-- student types

select STVSTYP.STVSTYP_CODE "Student_Type_Code",
       STVSTYP.STVSTYP_CODE || ' - ' || STVSTYP_DESC "Student_Type_Desc"
  from SATURN.STVSTYP STVSTYP
 where EXISTS
       (SELECT Y.SGBSTDN_STYP_CODE
          FROM SFBETRM X, SGBSTDN Y
         WHERE X.SFBETRM_PIDM = Y.SGBSTDN_PIDM
           AND Y.SGBSTDN_STYP_CODE = STVSTYP.STVSTYP_CODE
           AND Y.ROWID = F_GET_SGBSTDN_ROWID(X.SFBETRM_PIDM, :main_DD_AidYear.TERMCODE)
           AND X.SFBETRM_TERM_CODE = :main_DD_AidYear.TERMCODE)
   and :parm_CB_All_Student_Types <> 'Y'

UNION

SELECT '', 'All Codes'
  FROM DUAL
 WHERE :parm_CB_All_Student_Types = 'Y'

 order by 1