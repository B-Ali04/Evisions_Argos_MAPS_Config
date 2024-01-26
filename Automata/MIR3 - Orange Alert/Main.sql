select distinct
       suid.goradid_additional_id as Emplid,
       base.spbyevc_first_name as FirstName,
       base.spbyevc_last_name as LastName,
       null as AddrL1, --addr.spryeva_street_line_1 as AddrL1,     PER S. Medicis - Omit physical addresses from feed going forward. Not used by Rave.
       null as AddrL2, --addr.spryeva_street_line_2 as AddrL2,
       null as City, --addr.spryeva_city as City,
       null as State, --addr.spryeva_state as State,
       null as Zip, --addr.spryeva_zip as Zip,
       case when phns.spryevp_pidm is not null then
       (select listagg(case when spryevp_contact_type = 'SM' then 'Mobile Phone'
         when spryevp_contact_type = 'PH' then 'Home Phone'
          end ||chr(9) || spryevp_phone_number, chr(9)) within group (order by spryevp_pidm) as contacts from spryevp where spryevp_pidm = base.spbyevc_pidm group by spryevp_pidm) else null || chr(9) end as Phones,
       (select listagg('Home Email' || chr(9) || spryevm_email, chr(9)) within group (order by spryevm_pidm) as emails from spryevm where spryevm_pidm = base.spbyevc_pidm group by spryevm_pidm) as Emails
from spbyevc base
inner join goradid suid on suid.goradid_pidm = base.spbyevc_pidm and suid.goradid_adid_code = 'SUID'
left outer join spryeva addr on (addr.spryeva_pidm = base.spbyevc_pidm) -- address record
left outer join spryevp phns on (base.spbyevc_pidm = phns.spryevp_pidm)
where base.spbyevc_optout = 'N' and base.spbyevc_active_ind = 'Y'
and ('Y' =  (SELECT distinct
        'Y'
    FROM
        sig01.emp_data a
    WHERE
        a.emp_pidm = base.spbyevc_pidm)
or 'Y' = (SELECT distinct
        'Y'
    FROM
        sig01.student_data b
    WHERE
        b.pidm = base.spbyevc_pidm
    AND b.end_date IS NULL
    AND b.prog_termination IS NULL))
order by suid.goradid_additional_id