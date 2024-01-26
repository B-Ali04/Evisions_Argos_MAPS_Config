select
  t.shrttrm_pidm,
  ids.lfmi_name as FullName,
  ids.fname as FirstName,
  ids.pref_fname as PrefFirstName,
  ids.mname as MiddleName,
  ids.lname as LastName,
  case
          when t.shrttrm_astd_code_dl = 'DL' then 'Deans List'
          when t.shrttrm_astd_code_dl = 'PL' then 'Presidents List'
          when t.shrttrm_astd_code_dl = 'PR' then 'Presidents List (4.000)'
  end as HonList,

  --Honors Student request, temporary
           --Bali04
           --requested by Laura, 4/28/23
           -- (+) levl_code

  case
        when exists(select * from SGRSATT
             where SGRSATT.SGRSATT_PIDM = r.PIDM
             and SGRSATT.SGRSATT_TERM_CODE_EFF = :ddSemester.STVTERM_CODE
             and SGRSATT.SGRSATT_ATTS_CODE in ('LHON','UHON', 'HONR'))
             then 'Y'
             else 'N'
              end HonorsStudent,
/* DELETE */
(select sgbstdn_dept_code from SGBSTDN
             where SGBSTDN.SGBSTDN_PIDM = r.PIDM
             and SGBSTDN.SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(r.PIDM, :ddSemester.STVTERM_CODE)
             and SGBSTDN.SGBSTDN_STST_CODE = 'AS') as Dept,
  f_get_desc_fnc('STVDEPT', sgbstdn_dept_code, 30) as Department,
  sgbstdn_majr_code_1 as Majr,
  f_get_desc_fnc('STVMAJr', sgbstdn_majr_code_1, 30) as Major,
  t.shrttrm_astd_code_dl,
  f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(r.PIDM,r.LEVL_CODE, r.TERM_CODE), 30) as ClassDesc,
  trunc(sGpa.shrtgpa_gpa, 3) SemGPA,
  aMail.street1 as MailLine1,
  aMail.street2 as MailLine2,
  aMail.city as MailCity,
  aMail.state_code as MailState,
  aMail.zip as MailZip,
  aMail.natn_desc as MailNatn,
  aParent.street1 as ParentLine1,
  aParent.street2 as ParentLine2,
  aParent.city as ParentCity,
  aParent.state_code as ParentState,
  aParent.zip as ParentZip,
  aParent.natn_desc as ParentNatn,
  aPerm.street1 as PermLine1,
  aPerm.street2 as PermLine2,
  aPerm.city as PermCity,
  aPerm.state_code as PermState,
  aPerm.zip as PermZip,
  aPerm.natn_desc as PermNatn,
  e.email
from shrttrm t
left outer join rel_address aMail
     on aMail.pidm = t.shrttrm_pidm and aMail.atyp_code = 'MA' and aMail.active_ind = 1
     and aMail.start_date = (select max(start_date) from rel_address aMail2 where aMail2.pidm = aMail.pidm and aMail2.atyp_code = 'MA' and aMail2.active_ind = 1) and (aMail.end_date is null or aMail.end_date > sysdate)
left outer join rel_address aParent
     on aParent.pidm = t.shrttrm_pidm and aParent.atyp_code = 'PA' and aParent.active_ind = 1
     and aParent.start_date = (select max(start_date) from rel_address aParent2 where aParent2.pidm = aParent.pidm and aParent2.atyp_code = 'PA' and aParent2.active_ind = 1) and (aParent.end_date is null or aParent.end_date > sysdate)
left outer join rel_address aPerm
     on aPerm.pidm = t.shrttrm_pidm and aPerm.atyp_code = 'PR' and aPerm.active_ind = 1
     and aPerm.start_date = (select max(start_date) from rel_address aPerm2 where aPerm2.pidm = aPerm.pidm and aPerm2.atyp_code = 'PR' and aPerm2.active_ind = 1) and (aPerm.end_date is null or aPerm.end_date > sysdate)
inner join rel_email e
     on e.pidm = t.shrttrm_pidm and e.emal_code = 'SU'
left outer join rel_identity ids on ids.pidm = t.shrttrm_pidm
left outer join rel_student r on r.pidm = t.shrttrm_pidm and r.term_Code = t.shrttrm_term_code
left outer join shrtgpa sgpa
     on sgpa.shrtgpa_pidm = t.shrttrm_pidm
     and sgpa.shrtgpa_term_code = t.shrttrm_term_code
     and sgpa.shrtgpa_levl_code = r.levl_code and sgpa.shrtgpa_gpa_type_ind = 'I'

/* 5/9/2023 - missing dept/majr*/
LEFT OUTER JOIN SGBSTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = r.PIDM
     and SGBSTDN_STST_CODE = 'AS'
     AND SGBSTDN_TERM_CODE_EFF = FY_SGBSTDN_EFF_TERM(r.PIDM, :ddSemester.STVTERM_CODE)
where t.shrttrm_term_code = :ddSemester.STVTERM_CODE

--$addfilter

--and t.shrttrm_astd_code_dl in ('PL','PR','DL')
/*
February 16, 2022
Bali04

Notes:
      - Mailing List Report redefined to display DL/PL codes only
      - new child report introduced, seperating PR from PL/DL ASTD_Codes, displays PR codes only
      - astd_code data set removed from base report query and explicitly specified in child reports

*/

order by t.shrttrm_astd_code_dl
