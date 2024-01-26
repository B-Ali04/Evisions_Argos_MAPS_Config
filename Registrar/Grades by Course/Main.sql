WITH main_1 AS
 (select i.spriden_pidm            pidm,
         i.spriden_id              banner_id,
         i.spriden_last_name       lname,
         i.spriden_first_name      fname,
         stu.sgbstdn_majr_code_1   as Majr,
         stu.sgbstdn_dept_code     as Dept,
         f_get_desc_fnc('stvmajr', stu.sgbstdn_majr_code_1, 30) as majr_desc,
         f_get_desc_fnc('stvdept', stu.sgbstdn_dept_code, 30) as dept_desc,
         g.shrtckg_term_code       as TermCd,
         n.shrtckn_crn             as ClassNumber,
         n.shrtckn_subj_code       as Subject,
         n.shrtckn_crse_numb       as CatalogNbr,
         n.shrtckn_crn             as crn,
         g.shrtckg_grde_code_final as CourseGradeImport
    from shrtckg g
   inner join shrtckn n
      on n.shrtckn_seq_no = g.shrtckg_tckn_seq_no
     and n.shrtckn_pidm = g.shrtckg_pidm
     and n.shrtckn_term_code = g.shrtckg_term_code
     and ('-All-' = :main_LB_subj.CODE
         or ('-All-' <> :main_LB_subj.CODE
            and n.shrtckn_subj_code = :main_LB_subj.CODE))
     and ('-All-' = :main_LB_crse.CODE
         or ('-All-' <> :main_LB_crse.CODE
            and n.shrtckn_crse_numb = :main_LB_crse.CODE))
   inner join sgbstdn stu
      on stu.sgbstdn_pidm = g.shrtckg_pidm
     and stu.sgbstdn_term_code_eff =
         (select max(SGBSTDN_TERM_CODE_EFF)
            from SGBSTDN s2
           where s2.SGBSTDN_PIDM = g.shrtckg_pidm)
     and stu.sgbstdn_majr_code_1 <> 'EHS'
   inner join spriden i
      on i.spriden_pidm = g.shrtckg_pidm
     and i.spriden_id like 'F%'
   where g.shrtckg_term_code = :main_LB_term.STVTERM_CODE)

select
       main_1.termcd term,
       main_1.banner_id,
       main_1.lname,
       main_1.fname,
       main_1.majr,
       main_1.majr_desc,
       main_1.dept,
       main_1.dept_desc,
       main_1.subject,
       main_1.catalognbr crse_numb,
       main_1.coursegradeimport grade,
       CASE
         WHEN f_instructor_fnc(main_1.termcd, main_1.crn, 'NAME') = 'STAFF' THEN
          'NO INSTRUCTOR ASSIGNED IN SIRASGN'
         ELSE
          f_instructor_fnc(main_1.termcd, main_1.crn, 'NAME')
       END instructor

  from main_1
 order by main_1.termcd desc, main_1.catalognbr, main_1.lname, main_1.fname