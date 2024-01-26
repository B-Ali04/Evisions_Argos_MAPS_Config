WITH main_1 AS
 (SELECT lower(goremal_email_address) email,
         a.sgbstdn_levl_code levl,
         spriden_first_name || ' ' || spriden_last_name name,
         a.sgbstdn_pidm pidm

    FROM rel_student r, stvmajr, sgbstdn a, spriden, goremal
   WHERE r.pidm = spriden_pidm
     AND r.term_code >= fz_esf_prior_term_mc_nonsum() --IN ('202230','202240')
     AND a.sgbstdn_pidm = spriden_pidm
     AND a.sgbstdn_term_code_eff =
         (SELECT MAX(b.sgbstdn_term_code_eff)
            FROM sgbstdn b
           WHERE b.sgbstdn_pidm = a.sgbstdn_pidm)
     AND stvmajr_code = a.sgbstdn_majr_code_1
     AND stvmajr_code NOT IN ('SUS', 'EHS')
     AND a.sgbstdn_stst_code NOT IN ('IS','IG')
     AND EXISTS (SELECT *
            FROM sfrstcr
           WHERE spriden_pidm = sfrstcr_pidm
             AND sfrstcr_term_code = r.term_code
             AND sfrstcr_rsts_code = 'RE')
     AND goremal_pidm = spriden_pidm
     AND goremal_emal_code = 'SU'
        --AND goremal_preferred_ind = 'Y'
     AND spriden_id LIKE 'F%'
     AND spriden_change_ind IS NULL
   ORDER BY spriden_search_last_name, spriden_search_first_name)

,
main_esf as
 (select distinct lower(a.goremal_email_address) email,
                  main_1.levl levl,
                  main_1.name name
    from main_1, goremal a
   where a.goremal_pidm = main_1.pidm
     and a.goremal_emal_code = 'ESF'
     and a.goremal_activity_date =
         (select max(b.goremal_activity_date)
            from goremal b
           where b.goremal_pidm = a.goremal_pidm
             and b.goremal_emal_code = 'ESF')
     and lower(a.goremal_email_address) LIKE '%esf%')

,
main_2 as
 (select 'aelombard@esf.edu', 'EMP', 'Anne Lombard'
    from dual
  UNION
  select 'bsorrells@esf.edu', 'EMP', 'Barbara Sorrells'
    from dual
  UNION
  select 'calanglo@esf.edu', 'EMP', 'Christine Langlois'
    from dual
  UNION
  select 'cduffy01@esf.edu', 'EMP', 'Casey Duffy'
    from dual
  UNION
  select 'communityservice@esf.edu', 'EMP', 'Community Service'
    from dual
  UNION
  select 'sknevins@esf.edu', 'EMP', 'Susan Nevins'
    from dual
  UNION
  select 'jlrufo@esf.edu', 'EMP', 'Joseph Rufo'
    from dual
  UNION
  select 'jturbev@esf.edu', 'EMP', 'John Turbeville'
    from dual
  UNION
  select 'lrpayne@esf.edu', 'EMP', 'Laura Payne'
    from dual
  UNION
  select 'msmith52@esf.edu', 'EMP', 'Matthew Smith'
    from dual
  UNION
  select 'mthurston@esf.edu', 'EMP', 'Megan Thurston'
    from dual
  UNION
  select 'mttriano@esf.edu', 'EMP', 'Mary Triano'
    from dual
  UNION
  select 'naotts@esf.edu', 'EMP', 'Nancy Otts'
    from dual
  UNION
  select 'rasquier@esf.edu', 'EMP', 'Ragan Squier'
    from dual
  UNION
  select 'rascheel@esf.edu', 'EMP', 'Ryan Scheel'
    from dual
  UNION
  select 'registrar@esf.edu', 'EMP', 'Registrar'
    from dual
  UNION
  select 'sbhouck@esf.edu', 'EMP', 'Sarah Houck'
    from dual
  UNION
  select 'karmani@esf.edu', 'EMP', 'Kimberly Armani'
    from dual
  UNION
  select 'studentactivities@esf.edu', 'EMP', 'Student Activities'
    from dual
  UNION
  select 'upolice@esf.edu', 'EMP', 'University Police'
    from dual
  UNION
  select 'usa@esf.edu', 'EMP', 'USA'
    from dual
  UNION
  select 'klang01@esf.edu', 'EMP', 'Katherine Lang'
    from dual
  /*UNION
  select 'tkgeorge@esf.edu','EMP' from dual*/ -- this was throwing errors any time an email went out.
  UNION
  select 'kswright@esf.edu', 'EMP', 'Kailyn Wright'
    from dual
  UNION
  select 'tecarter@esf.edu', 'EMP', 'Thomas Carter'
    from dual
  UNION
  select 'vluzadis@esf.edu', 'EMP', 'Valerie Luzadis'
    from dual
  UNION
  select 'hchen90@esf.edu', 'EMP', 'Hui Chen'
    from dual)

,
main_pop as
 (select main_1.email, main_1.levl, main_1.name
    from main_1
  UNION
  select *
    from main_esf
  UNION
  select *
    from main_2)

select *
  from main_pop --$newfilter
 order by main_pop.name
