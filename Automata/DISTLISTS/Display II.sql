--
--  Script Name: distlists.sql
--  Create Date: 24APR2023
--  Creator: Ian Gallagher
--  Generates distribution list flat file to be sent to CNS for distlist processing
--  Audit Trail:
--    24APR2023 - Created
--
--  Notes:
--  IEG -- 24APR2023 -- created to replace legacy hrsf..sp_CreDist_Lists stored procedure and automated task on is-server02
--
--
with emp_data as
 (SELECT DISTINCT a.spriden_pidm pidm,
                  a.spriden_id bid,
                  a.spriden_last_name lname,
                  a.spriden_first_name fname,
                  c.hrvyemp_separation_date job_end_date,
                  CASE
                    WHEN d.action_code NOT IN ('TER') THEN
                     NULL
                    ELSE
                     d.action_code
                  END AS emp_term_action,
                  CASE
                    WHEN d.reason_code NOT IN ('TER') THEN
                     NULL
                    ELSE
                     d.reason_code
                  END AS emp_term_reason,
                  c.hrvyemp_negotiating_unit negot_unit

    FROM spriden              a,
         goradid              k,
         goradid              l,
         hr_commitment        b,
         hrvyemp              c,
         hr_employment_status d
   WHERE a.spriden_change_ind IS NULL
     AND a.spriden_pidm = k.goradid_pidm
     AND k.goradid_adid_code IN ('SUNE', 'SUNY')
     AND a.spriden_pidm = l.goradid_pidm
     AND l.goradid_adid_code = 'SUID'
     AND k.goradid_additional_id = b.suny_id(+)
     AND k.goradid_additional_id = c.hrvyemp_suny_id
     AND nvl(c.hrvyemp_separation_date, SYSDATE) =
         (SELECT nvl(MAX(cc.hrvyemp_separation_date), SYSDATE)
            FROM hrvyemp cc
           WHERE cc.hrvyemp_pidm = c.hrvyemp_pidm)
     AND c.hrvyemp_pidm NOT IN
         (select ca.hrvyemp_pidm
            from hrvyemp ca
           where ca.hrvyemp_role_type_code = 'STGTA'
              or (ca.hrvyemp_nys_emp_id is null and
                 ca.hrvyemp_role_type_code = 'STEMP' and
                 ca.hrvyemp_campus_title is null and
                 ca.hrvyemp_recent_start_date < sysdate))
     AND k.goradid_additional_id = d.suny_id(+)
     AND d.data_status(+) = 'C'
     AND nvl(d.employment_effective_date, to_date('1/1/9900', 'MM/DD/YYYY')) =
         (SELECT nvl(MAX(dd.employment_effective_date),
                     to_date('1/1/9900', 'MM/DD/YYYY'))
            FROM hr_employment_status dd
           WHERE dd.suny_id = d.suny_id
             AND dd.data_status = 'C')
     AND nvl(b.commitment_effective_date, to_date('1/1/9900', 'MM/DD/YYYY')) =
         nvl((SELECT MAX(bb.commitment_effective_date)
               FROM hr_commitment bb
              WHERE bb.suny_id = b.suny_id
                AND bb.hr_commitment_id = b.hr_commitment_id),
             to_date('1/1/9900', 'MM/DD/YYYY'))
     and c.hrvyemp_recent_start_date =
         (select max(d.hrvyemp_recent_start_date)
            from hrvyemp d
           where d.hrvyemp_pidm = c.hrvyemp_pidm)),
emp_data2 as
 (select distinct emp.pidm  pidm,
                  emp.bid   bid,
                  emp.lname lname,
                  emp.fname fname
    from emp_data emp
   where emp.job_end_date is null
     and emp.emp_term_action is null
     and emp.emp_term_reason is null)

,
negot_unit as
 (select distinct emp.pidm pidm, emp.negot_unit negot_unit
    from emp_data emp
   where emp.job_end_date is null
     and emp.emp_term_action is null
     and emp.emp_term_reason is null)

,
staff as
 (select distinct hrvyemp_pidm pidm
    from hrvyemp
   where (hrvyemp_campus_title is not null or hrvyemp_campus_title is null)
     and (hrvyemp_title_hrchy_desc <> 'Graduate Titles' or
         hrvyemp_title_hrchy_desc IS NULL)
     and ((hrvyemp_title_class_code not in ('20', '30', '40') or
         hrvyemp_title_class_code IS NULL) or
         (hrvyemp_title_family_desc not in
         ('Instructional Support', 'Research', 'Academic Administration') or
         hrvyemp_title_family_desc IS NULL) or
         (hrvyemp_dept_desc <> 'ESF Open Academy' or
         hrvyemp_dept_desc IS NULL) or
         hrvyemp_role_type_code IN ('RFEMP', 'EMRTS', 'AUXIL'))
     and hrvyemp_pidm not in
         (select distinct hrvyemp_pidm
            from hrvyemp
           where hrvyemp_campus_title is not null
             and hrvyemp_title_hrchy_desc <> 'Graduate Titles'
             and (hrvyemp_title_class_code in ('20', '30', '40') or
                 hrvyemp_title_family_desc in
                 ('Instructional Support',
                   'Research',
                   'Academic Administration') or
                 hrvyemp_dept_desc = 'ESF Open Academy'))),
rf as
 (select distinct a.hrvyemp_pidm pidm
    from hrvyemp a
   where (a.hrvyemp_campus_title is not null or
         a.hrvyemp_campus_title is null)
     and (a.hrvyemp_title_hrchy_desc <> 'Graduate Titles' or
         a.hrvyemp_title_hrchy_desc IS NULL)
     and ((a.hrvyemp_title_class_code not in ('20', '30', '40') or
         a.hrvyemp_title_class_code IS NULL) or
         (a.hrvyemp_title_family_desc not in
         ('Instructional Support', 'Research', 'Academic Administration') or
         a.hrvyemp_title_family_desc IS NULL) or
         (a.hrvyemp_dept_desc <> 'ESF Open Academy' or
         a.hrvyemp_dept_desc IS NULL) or
         a.hrvyemp_role_type_code IN ('RFEMP', 'EMRTS', 'AUXIL'))
     and a.hrvyemp_pidm not in
         (select distinct hrvyemp_pidm
            from hrvyemp
           where hrvyemp_campus_title is not null
             and hrvyemp_title_hrchy_desc <> 'Graduate Titles'
             and (hrvyemp_title_class_code in ('20', '30', '40') or
                 hrvyemp_title_family_desc in
                 ('Instructional Support',
                   'Research',
                   'Academic Administration') or
                 hrvyemp_dept_desc = 'ESF Open Academy'))
     and a.hrvyemp_recent_start_date =
         (select max(b.hrvyemp_recent_start_date)
            from hrvyemp b
           where b.hrvyemp_pidm = a.hrvyemp_pidm)
     and a.hrvyemp_role_type_code = 'RFEMP')

,
baker as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Baker%' or a.address_1 LIKE '%BAKER%')
     and hrvyemp_suny_id = a.suny_id)

,
bray as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Bray%' or a.address_1 LIKE '%BRAY%')
     and hrvyemp_suny_id = a.suny_id)

,
illick as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Illick%' or a.address_1 LIKE '%ILLICK%')
     and hrvyemp_suny_id = a.suny_id)

,
jahn as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Jahn%' or a.address_1 LIKE '%JAHN%')
     and hrvyemp_suny_id = a.suny_id)

,
moon as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Moon%' or a.address_1 LIKE '%MOON%' or
         a.address_1 LIKE '%Moo%' or a.address_1 LIKE '%MOO%')
     and hrvyemp_suny_id = a.suny_id)

,
marshall as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Marshal%' or a.address_1 LIKE '%Marshall%' or
         a.address_1 LIKE '%MARSHL%' or a.address_1 LIKE '%MARSHALL%' or
         a.address_1 LIKE '%Marshl%')
     and hrvyemp_suny_id = a.suny_id)

,
walters as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Walter%' or a.address_1 LIKE '%WALTER%' or
         a.address_1 LIKE '%Walters%' or a.address_1 LIKE '%WALTERS%')
     and hrvyemp_suny_id = a.suny_id)

,
physplnt as
 (select distinct hrvyemp_pidm pidm
    from hr_address a, hrvyemp
   where a.address_code IN ('CMP', 'CMP2')
     and (a.address_1 LIKE '%Physical Plant%' or
         a.address_1 LIKE '%PHYSICAL PLANT%' or
         a.address_1 LIKE '%PHYSPLNT%' or a.address_1 LIKE '%FACILITIES%')
     and hrvyemp_suny_id = a.suny_id)

,
combined as
 (select emp2.pidm pidm,
         emp2.bid bid,
         emp2.lname lname,
         emp2.fname fname,
         case
           when tzkutil.fz_get_email(emp2.pidm, 'ESF') NOT LIKE '%.edu%' then
            tzkutil.fz_get_email(emp2.pidm, 'SU')
           else
            tzkutil.fz_get_email(emp2.pidm, 'ESF')
         end email,
         (select '1' from staff s where s.pidm = emp2.pidm) staff_ind,
         (select '1' from rf r where r.pidm = emp2.pidm) rf_ind,
         (select '1' from baker b where b.pidm = emp2.pidm) baker_ind,
         (select '1' from bray br where br.pidm = emp2.pidm) bray_ind,
         (select '1' from illick i where i.pidm = emp2.pidm) illick_ind,
         (select '1' from jahn j where j.pidm = emp2.pidm) jahn_ind,
         (select '1' from moon m where m.pidm = emp2.pidm) moon_ind,
         (select '1' from marshall ma where ma.pidm = emp2.pidm) marshl_ind,
         (select '1' from walters w where w.pidm = emp2.pidm) walters_ind,
         (select '1' from physplnt p where p.pidm = emp2.pidm) physplnt_ind,
         (select '1'
            from negot_unit n
           where n.pidm = emp2.pidm
             and n.negot_unit IN ('02', '03', '04')) csea_ind,
         (select '1'
            from negot_unit n
           where n.pidm = emp2.pidm
             and n.negot_unit IN ('08', 'ES')) uup_ind,
         (select '1'
            from negot_unit n
           where n.pidm = emp2.pidm
             and n.negot_unit IN ('13', '06')) mc_ind
    from emp_data2 emp2)

,
distlist_gen as
 (
  --faculty
  select '2' gid,
          'FACULTY' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '01' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.staff_ind IS NULL

  UNION

  --baker
  select '3' gid,
          'BAKER' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '02' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.baker_ind = '1'

  UNION

  --bray
  select '4' gid,
          'BRAY' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '03' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.bray_ind = '1'

  UNION

  --illick
  select '5' gid,
          'ILLICK' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '04' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.illick_ind = '1'

  UNION

  --jahn
  select '6' gid,
          'JAHN' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '05' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.jahn_ind = '1'

  UNION

  --moon
  select '7' gid,
          'MOON' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '06' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.moon_ind = '1'

  UNION

  --marshall
  select '8' gid,
          'MARSHALL' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '07' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.marshl_ind = '1'

  UNION

  --walters
  select '9' gid,
          'WALTERS' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '08' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.walters_ind = '1'

  UNION

  --physplnt
  select '10' gid,
          'PHYSICAL PLANT' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '09' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.physplnt_ind = '1'

  UNION

  --MC
  select '21' gid,
          'MANAGEMENT CONFIDENTIAL' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '10' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.mc_ind = '1'

  UNION

  --RF
  select '22' gid,
          'RESEARCH FOUNDATION' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '11' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.rf_ind = '1'

  UNION

  --CSEA
  select '24' gid,
          'CSEA' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '12' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.csea_ind = '1'

  UNION

  --UUP
  select '25' gid,
          'UUP' grp,
          c.email email,
          c.pidm pidm,
          c.bid bid,
          c.lname lname,
          c.fname fname,
          '13' ord_key
    from combined c
   where c.email LIKE '%.edu%'
     and c.uup_ind = '1')

select dg.gid, dg.grp, dg.email, dg.pidm, dg.bid, dg.lname, dg.fname
  from distlist_gen dg
  where :f1_Button_Search2 is not null
 order by dg.ord_key, dg.lname