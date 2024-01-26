select
  e.hrvyemp_banner_id as bannerid,
  su.goradid_additional_id as suid,
  u.gobtpac_external_user as esfid,
  e.hrvyemp_last_name as lastname,
  e.hrvyemp_first_name as firstname,
  e.hrvyemp_mi as middlename,
  a2.address_1 as offcbldg,
  a2.address_2 as offcroom,
  (p1.phone_area_code || p1.phone_exchange || p1.phone_number) as offcphone,
  a1.address_1 as mailaddrbldg,
  a1.address_2 as mailaddrroom,
  (p2.phone_area_code || p2.phone_exchange || p2.phone_number) as altoffcphone,
  g.goremal_email_address as emailid,
  e.hrvyemp_campus_title as campustitle,
  e.hrvyemp_dept_desc as workloc,
  e.hrvyemp_suny_title_desc as civilservicetitle,
  case
    when (e.hrvyemp_campus_title is not null and e.hrvyemp_title_hrchy_desc <> 'Graduate Titles'
      and (e.hrvyemp_title_class_code in ('20','30','40') or e.hrvyemp_title_family_desc in ('Instructional Support','Research','Academic Administration')
      or e.hrvyemp_dept_desc = 'ESF Open Academy')) then 'Faculty'
    when (e.hrvyemp_campus_title is not null and e.hrvyemp_title_hrchy_desc <> 'Graduate Titles'
      and (e.hrvyemp_title_class_code not in ('20','30','40') or e.hrvyemp_title_family_desc not in ('Instructional Support','Research','Academic Administration')
      or e.hrvyemp_dept_desc <> 'ESF Open Academy')) then 'Staff'
    else 'Unknown'
  end as facstaff,
  e.hrvyemp_role_type_code as empaffil,
  e.hrvyemp_full_part_time as ftpt,
  case
      when e.hrvyemp_spvsr_pidm is null then null else e.hrvyemp_spvsr_last_name||', '||e.hrvyemp_spvsr_first_name end supervisor,
  d.gobumap_udc_id as UDCID
from hrvyemp e
left outer join goremal g on g.goremal_pidm = e.hrvyemp_pidm and g.goremal_emal_code = 'ESF' and g.goremal_status_ind = 'A'
left outer join gobtpac u on e.hrvyemp_pidm = u.gobtpac_pidm
left outer join gobumap d on d.gobumap_pidm = e.hrvyemp_pidm
left outer join hr_address a1 on a1.suny_id = e.hrvyemp_suny_id and a1.address_code = 'CMP'
left outer join hr_address a2 on a2.suny_id = e.hrvyemp_suny_id and a2.address_code = 'CMP2'
left outer join hr_phone p1 on p1.suny_id = e.hrvyemp_suny_id and p1.phone_type = 'WORK' and p1.print_flag = 'Y'
left outer join hr_phone p2 on p2.suny_id = e.hrvyemp_suny_id and p2.phone_type = 'WORK2' and p2.print_flag = 'Y'
left outer join goradid su on su.goradid_pidm = e.hrvyemp_pidm and su.goradid_adid_code = 'SUID'
where
     e.hrvyemp_active_ind = 1
     and e.hrvyemp_role_type_code in ('STEMP','AUXIL','RFEMP')
     and e.hrvyemp_primary_ind = 1
     --$beginorder

order by e.hrvyemp_last_name,
      e.hrvyemp_banner_id
      --$endorder

