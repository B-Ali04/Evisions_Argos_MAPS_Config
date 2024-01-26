
select SPRIDEN.SPRIDEN_ID "Id",
       SPRIDEN.SPRIDEN_LAST_NAME "LastName",
       SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
       SPRIDEN.SPRIDEN_MI "MiddleName",
       (SELECT nvl(SUM(SFRSTCR.SFRSTCR_CREDIT_HR),0)
          FROM SFRSTCR, STVRSTS
         WHERE SFRSTCR.SFRSTCR_PIDM = trm.SFBETRM_PIDM
           AND SFRSTCR.SFRSTCR_TERM_CODE = trm.SFBETRM_TERM_CODE
           AND SFRSTCR.SFRSTCR_RSTS_CODE = STVRSTS.STVRSTS_CODE
           AND STVRSTS.STVRSTS_INCL_SECT_ENRL = 'Y') "Term_Credits",
       (select count(*) from sfrstcr r
        where r.sfrstcr_term_code = trm.SFBETRM_TERM_CODE
          and r.sfrstcr_rsts_code IN(select t.stvrsts_code from stvrsts t where t.stvrsts_incl_sect_enrl = 'Y')
          and r.sfrstcr_pidm = trm.SFBETRM_PIDM
          and r.sfrstcr_camp_code = 'B') as Online_Courses,
       sgbstdn.sgbstdn_full_part_ind as FTPT,
       (SELECT STVVETC.STVVETC_DESC
          FROM SGRVETN,
               STVVETC
         WHERE SGRVETN.SGRVETN_PIDM = trm.SFBETRM_PIDM
           AND SGRVETN.SGRVETN_TERM_CODE_VA = trm.SFBETRM_TERM_CODE
           AND SGRVETN.SGRVETN_VETC_CODE = STVVETC.STVVETC_CODE) "Veteran_Program",
       SGBSTDN.SGBSTDN_MAJR_CODE_1 "Major_Code",
       f_get_desc_fnc('STVMAJR',SGBSTDN.SGBSTDN_MAJR_CODE_1,30) "Major_Desc",


(select "advisor" from
(
select spriden_last_name || ',' || spriden_first_name "advisor" from
sgradvr left join spriden on spriden_pidm = sgradvr_advr_pidm and spriden_change_ind is null
where sgradvr_pidm = trm.SFBETRM_PIDM
order by sgradvr_term_code_eff desc, decode(sgradvr_prim_ind,'Y',0,99) asc
) where rownum = 1) "Advisor",

       (SELECT LISTAGG(Y.SPRIDEN_LAST_NAME||', '||Y.SPRIDEN_FIRST_NAME,'; ')
               WITHIN GROUP (ORDER BY Y.SPRIDEN_LAST_NAME)
          FROM SGRADVR, SPRIDEN Y
         WHERE SGRADVR.SGRADVR_PIDM = trm.SFBETRM_PIDM
           AND SGRADVR.SGRADVR_ADVR_PIDM = Y.SPRIDEN_PIDM
           AND Y.SPRIDEN_CHANGE_IND IS NULL
           AND SGRADVR.SGRADVR_PRIM_IND != 'Y'
           AND SGRADVR.SGRADVR_TERM_CODE_EFF =
               (SELECT MAX(X.SGRADVR_TERM_CODE_EFF)
                  FROM SGRADVR X
                 WHERE X.SGRADVR_PIDM = SGRADVR.SGRADVR_PIDM
                   AND X.SGRADVR_TERM_CODE_EFF <= trm.SFBETRM_TERM_CODE
                   AND X.SGRADVR_PRIM_IND != 'Y')) "Additional_Advisors",
       (SELECT LISTAGG(GOREMAL.GOREMAL_EMAIL_ADDRESS,'; ' )
               WITHIN GROUP (ORDER BY GOREMAL.GOREMAL_EMAIL_ADDRESS)
          FROM GOREMAL
         WHERE GOREMAL.GOREMAL_PIDM = trm.SFBETRM_PIDM
           AND GOREMAL.GOREMAL_EMAL_CODE = 'SU') "Email_Address",
       to_char(SGBSTDN.SGBSTDN_EXP_GRAD_DATE, 'YYYY-MM-DD') "Expected_Grad_Date",
       (SELECT SHRLGPA.SHRLGPA_GPA
          FROM SHRLGPA
         WHERE SHRLGPA.SHRLGPA_PIDM = trm.SFBETRM_PIDM
           AND SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'O'
           AND SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE) "Level_GPA",
       (select SUM(r.sfrstcr_credit_hr) from sfrstcr r
        where r.sfrstcr_pidm = trm.SFBETRM_PIDM
          and r.sfrstcr_term_code = :main_DD_AidYear.TERMCODE
          and r.sfrstcr_rsts_code IN ('DD','DC')) as TotalDropped,
       (SELECT SHRTGPA.SHRTGPA_GPA
          FROM SHRTGPA
         WHERE SHRTGPA.SHRTGPA_PIDM = trm.SFBETRM_PIDM
           AND SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'
           AND SHRTGPA.SHRTGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
           AND SHRTGPA.SHRTGPA_TERM_CODE =
               (SELECT MAX(X.SHRTGPA_TERM_CODE)
                  FROM SHRTGPA X
                 WHERE X.SHRTGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
                   AND X.SHRTGPA_LEVL_CODE = SHRTGPA.SHRTGPA_LEVL_CODE
                   AND X.SHRTGPA_GPA_TYPE_IND = 'I'
                   AND X.SHRTGPA_TERM_CODE < trm.SFBETRM_TERM_CODE)) "Last_Term_GPA",
       (SELECT SHRLGPA.SHRLGPA_HOURS_EARNED
          FROM SHRLGPA
         WHERE SHRLGPA.SHRLGPA_PIDM = trm.SFBETRM_PIDM
           AND SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'O'
           AND SHRLGPA.SHRLGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE) "Earned_Hours",
       (SELECT LISTAGG(SPRHOLD.SPRHOLD_HLDD_CODE,'; ')
               WITHIN GROUP (ORDER BY SPRHOLD.SPRHOLD_HLDD_CODE)
          FROM SPRHOLD
         WHERE SPRHOLD.SPRHOLD_PIDM = trm.SFBETRM_PIDM
           AND SPRHOLD.SPRHOLD_TO_DATE > SYSDATE) "Hold_Codes",
       (SELECT LISTAGG(STVHLDD.STVHLDD_DESC,'; ')
               WITHIN GROUP (ORDER BY SPRHOLD.SPRHOLD_HLDD_CODE)
          FROM SPRHOLD, STVHLDD
         WHERE SPRHOLD.SPRHOLD_PIDM = trm.SFBETRM_PIDM
           AND SPRHOLD.SPRHOLD_HLDD_CODE = STVHLDD.STVHLDD_CODE
           AND SPRHOLD.SPRHOLD_TO_DATE > SYSDATE) "Hold_Desc",
       (SELECT LISTAGG(STVACTC_DESC,'; ')
               WITHIN GROUP (ORDER BY STVACTC_DESC)
          FROM SGRSPRT, STVACTC
         WHERE SGRSPRT_PIDM = trm.SFBETRM_PIDM
           AND SGRSPRT_TERM_CODE = trm.SFBETRM_TERM_CODE
           AND SGRSPRT_ACTC_CODE = STVACTC_CODE) "Sports",
       trm.SFBETRM_ESTS_CODE "ESTS_Code",
       trm.SFBETRM_ESTS_DATE "ESTS_Date",
       SGBSTDN.SGBSTDN_STST_CODE "Student_Status_Code",
       f_get_desc_fnc('STVSTST',SGBSTDN.SGBSTDN_STST_CODE,30) "Student_Status_Desc",
       SGBSTDN.SGBSTDN_LEVL_CODE "Level_Code",
       f_get_desc_fnc('STVLEVL',SGBSTDN.SGBSTDN_LEVL_CODE,30) "Level_Desc",
       SGBSTDN.SGBSTDN_STYP_CODE "Student_Type_Code",
       f_get_desc_fnc('STVSTYP',SGBSTDN.SGBSTDN_STYP_CODE,30) "Student_Type_Desc",
       f_calculate_age(SYSDATE,SPBPERS.SPBPERS_BIRTH_DATE,SPBPERS.SPBPERS_DEAD_DATE) "Age",
       F_GET_DESC_FNC('STVCLAS',F_CLASS_CALC_FNC(trm.SFBETRM_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE,trm.SFBETRM_TERM_CODE),30) "Class_Year",
       SGBSTDN.SGBSTDN_RESD_CODE "Residency_Code",
       (SELECT SUM(TBRACCD_BALANCE)
          FROM TBRACCD
         WHERE TBRACCD_PIDM = trm.SFBETRM_PIDM) "Account_Balance",
       (SELECT SUM(TBRACCD_AMOUNT)
          FROM TBRACCD, TBBDETC
         WHERE TBRACCD_PIDM = trm.SFBETRM_PIDM
           AND TBRACCD_DETAIL_CODE = TBBDETC_DETAIL_CODE
           AND TBRACCD_TERM_CODE = SFBETRM_TERM_CODE
           AND TBBDETC_DCAT_CODE = 'TUI') "Tuition_Charge_This_Term",
       CASE
         WHEN (SELECT SHRTTRM_ASTD_CODE_END_OF_TERM FROM SHRTTRM
               WHERE SHRTTRM_PIDM = trm.SFBETRM_PIDM
                 AND SHRTTRM_TERM_CODE = (SELECT MAX(X.SHRTTRM_TERM_CODE) FROM SHRTTRM X
                                          WHERE X.SHRTTRM_PIDM = trm.SFBETRM_PIDM
                                            AND X.SHRTTRM_TERM_CODE < :main_DD_AidYear.TERMCODE)) = 'DS'
           THEN NVL(SGBSTDN.SGBSTDN_ASTD_CODE,'DS')
         ELSE (SELECT SHRTTRM_ASTD_CODE_END_OF_TERM FROM SHRTTRM
               WHERE SHRTTRM_PIDM = trm.SFBETRM_PIDM
                 AND SHRTTRM_TERM_CODE = (SELECT MAX(X.SHRTTRM_TERM_CODE) FROM SHRTTRM X
                                          WHERE X.SHRTTRM_PIDM = trm.SFBETRM_PIDM
                                            AND X.SHRTTRM_TERM_CODE < :main_DD_AidYear.TERMCODE))
       END "Academic_Standing",
       (SELECT SPBYIMM_MMR_1_DATE
          FROM SPBYIMM
         WHERE SPBYIMM_PIDM = trm.SFBETRM_PIDM) "MMR_Date",
       (SELECT SPBYIMM_PHYS1_DATE
          FROM SPBYIMM
         WHERE SPBYIMM_PIDM = trm.SFBETRM_PIDM) "Physical_Date",
       (SELECT 'Y'
          FROM DUAL
         WHERE EXISTS
               (SELECT SLRRASG_PIDM
                  FROM SLRRASG
                 WHERE SLRRASG_PIDM = SFBETRM_PIDM
                   AND SLRRASG_TERM_CODE = SFBETRM_TERM_CODE
                   AND SLRRASG_ASCD_CODE = 'AC')) "Housing",
       f_get_desc_fnc('STVCAMP',SGBSTDN.SGBSTDN_CAMP_CODE,30) "Campus",
       (SELECT LISTAGG(GOREMAL.GOREMAL_EMAIL_ADDRESS,'; ' )
               WITHIN GROUP (ORDER BY GOREMAL.GOREMAL_EMAIL_ADDRESS)
          FROM GOREMAL
         WHERE GOREMAL.GOREMAL_PIDM = trm.SFBETRM_PIDM
           AND GOREMAL.GOREMAL_EMAL_CODE = 'PERS') "Personal_Email",
       SPBPERS.SPBPERS_CITZ_CODE "Citizen_Indicator",
       STVNATN.STVNATN_NATION "Nation_of_Birth",
       (SELECT GORVISA_VTYP_CODE || ' - ' || STVVTYP_DESC
          FROM GORVISA, STVVTYP
         WHERE GORVISA_PIDM = SFBETRM_PIDM
           AND GORVISA_VTYP_CODE = STVVTYP_CODE
           AND GORVISA_SEQ_NO = (SELECT MAX(V.GORVISA_SEQ_NO)
                                   FROM GORVISA V
                                  WHERE V.GORVISA_PIDM = SFBETRM_PIDM)) "Visa",
       (SELECT NVL(SUM(TBRACCD_AMOUNT),0)
          FROM TBRACCD
         WHERE TBRACCD_PIDM = SFBETRM_PIDM
           AND TBRACCD_DETAIL_CODE = 'FC40'
           AND TBRACCD_TERM_CODE = :main_DD_AidYear.TERMCODE) "Intl_Insurance_Amt",
       CASE
           WHEN SUBSTR(:main_DD_AidYear.TERMCODE,6,1) = '1'
           THEN
           (SELECT NVL(SUM(TBRACCD_AMOUNT),0)
              FROM TBRACCD
             WHERE TBRACCD_PIDM = SFBETRM_PIDM
               AND TBRACCD_DETAIL_CODE = 'FC40'
               AND TBRACCD_TERM_CODE = TO_CHAR(TO_NUMBER(SUBSTR(:main_DD_AidYear.TERMCODE,1,4))-1,'9999') || '09')
           WHEN SUBSTR(:main_DD_AidYear.TERMCODE,6,1) = '9'
           THEN
           (SELECT NVL(SUM(TBRACCD_AMOUNT),0)
              FROM TBRACCD
             WHERE TBRACCD_PIDM = SFBETRM_PIDM
               AND TBRACCD_DETAIL_CODE = 'FC40'
               AND TO_CHAR(TBRACCD_TERM_CODE,'999999') >= TO_CHAR(TO_NUMBER(SUBSTR(:main_DD_AidYear.TERMCODE,1,4))-1,'9999') || '09'
               AND TBRACCD_TERM_CODE < :main_DD_AidYear.TERMCODE)
       END "Prior_Insurance_Billed",
       CASE
           WHEN SUBSTR(:main_DD_AidYear.TERMCODE,6,1) = '1'
           THEN
               (SELECT nvl(SUM(SFRSTCR.SFRSTCR_CREDIT_HR),0)
                  FROM SFRSTCR, STVRSTS
                 WHERE SFRSTCR.SFRSTCR_PIDM = trm.SFBETRM_PIDM
                   AND TO_CHAR(SFRSTCR.SFRSTCR_TERM_CODE,'999999') = TO_CHAR(TO_NUMBER(SUBSTR(:main_DD_AidYear.TERMCODE,1,4))-1,'9999') || '09'
                   AND SFRSTCR.SFRSTCR_RSTS_CODE = STVRSTS.STVRSTS_CODE
                   AND STVRSTS.STVRSTS_INCL_SECT_ENRL = 'Y')
           WHEN SUBSTR(:main_DD_AidYear.TERMCODE,6,1) = '9'
           THEN
               (SELECT nvl(SUM(SFRSTCR.SFRSTCR_CREDIT_HR),0)
                  FROM SFRSTCR, STVRSTS
                 WHERE SFRSTCR.SFRSTCR_PIDM = trm.SFBETRM_PIDM
                   AND TO_CHAR(SFRSTCR.SFRSTCR_TERM_CODE,'999999') >= TO_CHAR(TO_NUMBER(SUBSTR(:main_DD_AidYear.TERMCODE,1,4))-1,'9999') || '09'
                   AND SFRSTCR.SFRSTCR_TERM_CODE < :main_DD_AidYear.TERMCODE
                   AND SFRSTCR.SFRSTCR_RSTS_CODE = STVRSTS.STVRSTS_CODE
                   AND STVRSTS.STVRSTS_INCL_SECT_ENRL = 'Y')
       END "Prior_Insurance_Credit_Hours",
       SPBPERS.SPBPERS_BIRTH_DATE "Birth_Date",
       SPBPERS.SPBPERS_SEX "Gender",
       (SELECT COUNT(SHRTGPA_TERM_CODE)
          FROM SHRTGPA
         WHERE SHRTGPA_PIDM = SFBETRM_PIDM
           AND SHRTGPA_HOURS_EARNED > 0
           AND SHRTGPA_LEVL_CODE = '01'
           AND SHRTGPA_GPA_TYPE_IND = 'I') "Terms_Completed",
       ((SELECT SUM(TBRACCD_AMOUNT)
          FROM TBRACCD, TBBDETC
         WHERE TBRACCD_PIDM = trm.SFBETRM_PIDM
           AND TBRACCD_DETAIL_CODE = TBBDETC_DETAIL_CODE
           AND TBRACCD_TERM_CODE = SFBETRM_TERM_CODE
           AND TBBDETC_DCAT_CODE IN ('HOU','MEA')) -
        (SELECT SUM(TBRACCD_AMOUNT) * 2 FROM TBRACCD
         WHERE TBRACCD_PIDM = trm.SFBETRM_PIDM
           AND TBRACCD_TERM_CODE = SFBETRM_TERM_CODE
           AND TBRACCD_DETAIL_CODE LIKE 'HW%')) "Housing_Meal_Charges_This_Term",
       (SELECT SUM(TBRACCD_AMOUNT)
          FROM TBRACCD, TBBDETC
         WHERE TBRACCD_PIDM = trm.SFBETRM_PIDM
           AND TBRACCD_DETAIL_CODE = TBBDETC_DETAIL_CODE
           AND TBRACCD_TERM_CODE = SFBETRM_TERM_CODE
           AND TBBDETC_TYPE_IND = 'C') "Total_Charges_This_Term",
       SGBSTDN.SGBSTDN_MAJR_CODE_2 "MajorCode2",
       f_get_desc_fnc('STVMAJR',SGBSTDN.SGBSTDN_MAJR_CODE_2,30) "MajorCode2Desc",
       SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 "Minor1",
       f_get_desc_fnc('STVMAJR',SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1,30) "Minor1Desc",
       SGBSTDN.SGBSTDN_MAJR_CODE_MINR_2 "Minor2",
       f_get_desc_fnc('STVMAJR',SGBSTDN.SGBSTDN_MAJR_CODE_MINR_2,30) "Minor2Desc",
       (SELECT 'Y'
          FROM DUAL
         WHERE EXISTS (SELECT SFRSTCR_PIDM
                         FROM SFRSTCR,
                              STVRSTS
                        WHERE SFRSTCR_PIDM = SFBETRM_PIDM
                          AND SFRSTCR_TERM_CODE > :main_DD_AidYear.TERMCODE
                          AND SFRSTCR_RSTS_CODE = STVRSTS_CODE
                          AND STVRSTS_INCL_SECT_ENRL = 'Y')) "Registered_Future_Term",
       (SELECT DISTINCT SFRSTCR_TERM_CODE
          FROM SFRSTCR,
               STVRSTS
         WHERE SFRSTCR_PIDM = SFBETRM_PIDM
           AND SFRSTCR_TERM_CODE =
               (SELECT MIN(X.SFRSTCR_TERM_CODE)
                  FROM SFRSTCR X
                 WHERE X.SFRSTCR_PIDM = SFRSTCR.SFRSTCR_PIDM
                   AND X.SFRSTCR_TERM_CODE > :main_DD_AidYear.TERMCODE)
           AND SFRSTCR_RSTS_CODE = STVRSTS_CODE
           AND STVRSTS_INCL_SECT_ENRL = 'Y') "Enrolled_Next_Term",
       (SELECT SUM(SFRSTCR_CREDIT_HR)
          FROM SFRSTCR,
               STVRSTS
         WHERE SFRSTCR_PIDM = SFBETRM_PIDM
           AND SFRSTCR_TERM_CODE =
               (SELECT MIN(X.SFRSTCR_TERM_CODE)
                  FROM SFRSTCR X
                 WHERE X.SFRSTCR_PIDM = SFRSTCR.SFRSTCR_PIDM
                   AND X.SFRSTCR_TERM_CODE > :main_DD_AidYear.TERMCODE)
           AND SFRSTCR_RSTS_CODE = STVRSTS_CODE
           AND STVRSTS_INCL_SECT_ENRL = 'Y') "Next_Term_Hours",
       (select distinct t.sprtele_phone_area||'-'||substr(t.sprtele_phone_number,1,3)||'-'||substr(t.sprtele_phone_number,4,4)
        from sprtele t
        where t.sprtele_tele_code  = 'PR'
          and t.sprtele_pidm = sgbstdn_pidm
          and t.sprtele_seqno = (select max(tt.sprtele_seqno) from sprtele tt
                                 where tt.sprtele_pidm = t.sprtele_pidm
                                   and tt.sprtele_tele_code = t.sprtele_tele_code)) "PR_phone",
       (select listagg(t.sprcmnt_text,';') within group(order by 1)
        from sprcmnt t
        where t.sprcmnt_cmtt_code = 'REG'
          and lower(t.sprcmnt_text) LIKE '%withd%'
          and t.sprcmnt_pidm = SGBSTDN.SGBSTDN_PIDM) as WithdrewComments,
       (select min(TRUNC(f.sfrstcr_rsts_date)) from sfrstcr f
        where f.sfrstcr_pidm = SGBSTDN.SGBSTDN_PIDM
          and f.sfrstcr_term_code = trm.SFBETRM_TERM_CODE) as FirstRegActivity,
       SGBSTDN.sgbstdn_coll_code_1 as CollegeCode,
       SGBSTDN.sgbstdn_dept_code as DepartmentCode,
       (select c.sorlcur_term_code_matric from sorlcur c
        where c.sorlcur_pidm = trm.SFBETRM_PIDM
          and c.sorlcur_seqno = (select max(cc.sorlcur_seqno) from sorlcur cc
                                 where c.sorlcur_pidm = cc.sorlcur_pidm
                                   and cc.sorlcur_cact_code = 'ACTIVE'
                                   and cc.sorlcur_term_code <= trm.SFBETRM_TERM_CODE
                                   and cc.sorlcur_lmod_code = 'LEARNER')) as MatricTermCUR,
        (select gordocm_srce_code from gordocm where gordocm_pidm = sgbstdn_pidm) as Gordocm_Srce_Code,
        (select gordocm_docm_code from gordocm where gordocm_pidm = sgbstdn_pidm) as Gordocm_Docm_Code,
        (select gordocm_request_date from gordocm where gordocm_pidm = sgbstdn_pidm) as Gordocm_Request_Date,
        (select gordocm_received_date from gordocm where gordocm_pidm = sgbstdn_pidm) as Gordocm_Received_date

  from SATURN.SFBETRM TRM,
       SATURN.SGBSTDN SGBSTDN,
       SATURN.SPRIDEN SPRIDEN,
       SATURN.SPBPERS SPBPERS,
       GENERAL.GOBINTL GOBINTL,
       SATURN.STVNATN STVNATN
 where trm.SFBETRM_PIDM = SGBSTDN.SGBSTDN_PIDM
   and trm.SFBETRM_PIDM = SPRIDEN.SPRIDEN_PIDM
   and SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM
   and spriden_change_ind is null
   and trm.SFBETRM_PIDM = GOBINTL.GOBINTL_PIDM (+)
   and GOBINTL.GOBINTL_NATN_CODE_BIRTH = STVNATN.STVNATN_CODE (+)
   and trm.SFBETRM_TERM_CODE = :main_DD_AidYear.TERMCODE
   and sgbstdn.rowid = f_get_sgbstdn_rowid(trm.SFBETRM_PIDM,trm.SFBETRM_TERM_CODE)
   and (:parm_CB_All_Campus = 'Y' or
        (:parm_CB_All_Campus <> 'Y'
     and SGBSTDN.SGBSTDN_CAMP_CODE = :parm_LB_Campus.Campus_Code ) )
   and (:parm_CB_All_Student_Types = 'Y' or
         (:parm_CB_All_Student_Types <> 'Y'
      and SGBSTDN.SGBSTDN_STYP_CODE = :parm_LB_Student_Type.Student_Type_Code ) )
   and (:parm_CB_Enrolled ='Y'
     and ((SELECT nvl(SUM(SFRSTCR.SFRSTCR_CREDIT_HR),0) FROM SFRSTCR, STVRSTS
           WHERE SFRSTCR.SFRSTCR_PIDM = trm.SFBETRM_PIDM
             AND SFRSTCR.SFRSTCR_TERM_CODE = trm.SFBETRM_TERM_CODE
             AND SFRSTCR.SFRSTCR_RSTS_CODE = STVRSTS.STVRSTS_CODE
             AND STVRSTS.STVRSTS_INCL_SECT_ENRL = 'Y') > 0)
       or :parm_CB_Enrolled <> 'Y' )
   and (:parm_CB_All_Majors = 'Y' or
        (:parm_CB_All_Majors <> 'Y'
     and (SGBSTDN_MAJR_CODE_1 = :parm_LB_Major.Major_Code or
          SGBSTDN_MAJR_CODE_1_2 = :parm_LB_Major.Major_Code) ) )
     --$addfilter
     --$beginorder
 order by SPRIDEN.SPRIDEN_LAST_NAME,
          SPRIDEN.SPRIDEN_FIRST_NAME,
          SPRIDEN.SPRIDEN_MI
--$endorder
