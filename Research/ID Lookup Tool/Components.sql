-- records with student attributes

with term as(
select
case --20220816--IEG-- added case statement to always return a term regardless if term is in session
               when (select fy_stvterm_current() from dual) IS NULL THEN
                (SELECT MAX(stvterm_code)
                   FROM stvterm
                  WHERE trunc(stvterm_start_date) <= trunc(SYSDATE + 180)
                    AND trunc(stvterm_end_date) >= trunc(SYSDATE)
                    AND stvterm_acyr_code < '9999')
               when (select substr(fy_stvterm_current(), 5, 2) from dual) = '10' THEN
                (SELECT to_char(fy_stvterm_current() + 10) from dual)
               when (select substr(fy_stvterm_current(), 5, 2) from dual) = '30' THEN
                (SELECT to_char(fy_stvterm_current() + 10) from dual)
               else
                (select fy_stvterm_current() from dual)
             end term_code
        from dual)
select a.spriden_id as BannerID,
(select
    stvstst_desc student_status
from
    term,
    stvstst
where
    stvstst_code = f_sgbstdn_fields(a.spriden_pidm,term.term_code,'STU_STATUS'))student_status,
       ts.sgbstdn_term_code_admit as Admit_Term,
       a.spriden_pidm as PIDM,
       a.spriden_last_name as LastName,
       a.spriden_first_name as FirstName,
       c.gobumap_udc_id as UDCID,
       d.gobtpac_external_user as ESFiD,
       b1.goradid_additional_id as SUID,
       b2.goradid_additional_id as SUNetID,
       concat(rtrim(b2.goradid_additional_id),'@syr.edu') as SUEmail,
       g.goremal_email_address as PersEmail,
       b4.goradid_additional_id as SUNYStudentID,
       b3.goradid_additional_id as SUNYPersonID
  from spriden a
  INNER JOIN sgbstdn ts on (ts.sgbstdn_pidm=a.spriden_pidm)
  LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
  LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
  LEFT OUTER JOIN goradid b3 on (b3.goradid_pidm=a.spriden_pidm and b3.goradid_adid_code='SUNE')
  LEFT OUTER JOIN goradid b4 on (b4.goradid_pidm=a.spriden_pidm and b4.goradid_adid_code='SUNY')
  LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
  LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
  LEFT OUTER JOIN goremal g on (g.goremal_pidm=a.spriden_pidm and g.goremal_emal_code = 'PERS')
  where
       d.gobtpac_external_user is not null
       and c.gobumap_udc_id is not null
       and ts.sgbstdn_term_code_eff = (select MAX(g.sgbstdn_term_code_eff) from sgbstdn g where g.sgbstdn_pidm=ts.sgbstdn_pidm)
       --and a.spriden_id like 'F%'
       and a.spriden_change_ind is null
and (a.spriden_id like :tbBID OR a.spriden_search_last_name like coalesce(UPPER(:tbBID),'') || '%' or b1.goradid_additional_id like coalesce(:tbBID,'') || '%')
/*
((a.spriden_id like (coalesce(UPPER(:tbBID),'') || '%') or a.spriden_search_last_name like '%' and b1.goradid_additional_id like '%') or
        (a.spriden_id like '%' and a.spriden_search_last_name like (coalesce(upper(:tbBID),'') || '%') and b1.goradid_additional_id like '%') or
        (a.spriden_id like '%' and a.spriden_search_last_name like '%' and b1.goradid_additional_id like (coalesce(UPPER(:tbBID),'') || '%')))
*/
-- records with employee records
select a.spriden_id as BannerID,
(select
    stvfcst_desc
from
    sibinst a,
    stvfcst
where
    a.sibinst_pidm = a.spriden_pidm
and a.sibinst_term_code_eff = (
    select
        max(b.sibinst_term_code_eff)
    from
        sibinst b
    where
        b.sibinst_pidm = a.sibinst_pidm)
and stvfcst_code = a.sibinst_fcst_code)status,
       h.hrvyemp_role_type_code emp_role,
       a.spriden_pidm as PIDM,
       a.spriden_last_name as LastName,
       a.spriden_first_name as FirstName,
       c.gobumap_udc_id as UDCID,
       d.gobtpac_external_user as ESFiD,
       b1.goradid_additional_id as SUID,
       b2.goradid_additional_id as SUNetID,
       concat(b2.goradid_additional_id,'@syr.edu') as SUEmail,
       h.hrvyemp_suny_id as SUNYEmpID
  from spriden a
  INNER JOIN hrvyemp h on (h.hrvyemp_pidm=a.spriden_pidm)
  LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
  LEFT OUTER JOIN goradid b2 on (b2.goradid_pidm=a.spriden_pidm and b2.goradid_adid_code='SUNI')
  LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
  LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
  LEFT OUTER JOIN goremal g on (g.goremal_pidm=a.spriden_pidm and g.goremal_emal_code = 'PERS')
  where
       d.gobtpac_external_user is not null
       and c.gobumap_udc_id is not null
       and a.spriden_id like 'F%'
       and ((a.spriden_id like (coalesce(UPPER(:tbBID),'') || '%') and a.spriden_search_last_name like '%' and b1.goradid_additional_id like '%') or
        (a.spriden_id like '%' and a.spriden_search_last_name like (coalesce(upper(:tbBID),'') || '%') and b1.goradid_additional_id like '%') or
        (a.spriden_id like '%' and a.spriden_search_last_name like '%' and b1.goradid_additional_id like (coalesce(UPPER(:tbBID),'') || '%')))
-- UDCID
select a.spriden_id as BannerID, a.spriden_first_name, a.spriden_last_name,
c.gobumap_udc_id as UDCID
  from spriden a
  LEFT OUTER JOIN goradid b1 on (b1.goradid_pidm=a.spriden_pidm and b1.goradid_adid_code='SUID')
  LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=a.spriden_pidm)
  LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=a.spriden_pidm)
  where
       c.gobumap_udc_id is not null
       and a.spriden_id like 'F%'
       and ((a.spriden_id like (coalesce(:tbBID,'') || '%') and a.spriden_search_last_name like '%' ) or
        (a.spriden_id like '%' and a.spriden_search_last_name like (coalesce(upper(:tbBID),'') || '%') ) or
        (a.spriden_id like '%' and a.spriden_search_last_name like '%' and b1.goradid_additional_id like (coalesce(:tbBID,'') || '%')))

-- Roles
select GORIROL_ROLE AS ROLE, GORIROL_ACTIVITY_DATE AS ASOF from gorirol where gorirol_pidm=:Main_MC_Stu.PIDM
