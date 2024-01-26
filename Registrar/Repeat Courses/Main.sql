with main_1 as
 (select shrtckn_term_code term,
         d.shrtckg_pidm pidm,
         spriden_id bid,
         (select goradid_additional_id
            from goradid
           where goradid_pidm(+) = spriden_pidm
             and goradid_adid_code(+) = 'SUID') suid,
         spriden_last_name lname,
         spriden_first_name fname,
         a.sgbstdn_levl_code levl,
         d.shrtckg_grde_code_final final_grade,
         d.shrtckg_gmod_code gmod_code,
         d.shrtckg_credit_hours crd_hrs,
         d.shrtckg_hours_attempted att_hrs,
         d.shrtckg_gchg_code chg_code,
         d.shrtckg_final_grde_chg_date final_grade_date,
         shrtckn_crn crn,
         shrtckn_subj_code subj,
         shrtckn_subj_code || shrtckn_crse_numb clas,
         shrtckn_crse_numb crse,
         shrtckn_crse_title crse_title,
         shrtckn_course_comment comments,
         shrtckn_coll_code coll,
         shrtckn_camp_code camp,
         d.shrtckg_final_grde_chg_user username,
         d.shrtckg_activity_date act_date
    from shrtckg d, shrtckn, spriden, sgbstdn a
   where d.shrtckg_pidm = shrtckn_pidm
     and d.shrtckg_term_code = shrtckn_term_code
     and d.shrtckg_tckn_seq_no = shrtckn_seq_no
     and d.shrtckg_seq_no =
         (select MAX(e.shrtckg_seq_no)
            from shrtckg e
           where e.shrtckg_pidm = d.shrtckg_pidm
             and e.shrtckg_term_code = d.shrtckg_term_code
             and e.shrtckg_tckn_seq_no = d.shrtckg_tckn_seq_no)
     and a.rowid = f_get_sgbstdn_rowid(shrtckn_pidm, shrtckn_term_code)
     and a.sgbstdn_levl_code = 'UG'
        --and d.shrtckg_grde_code_final NOT IN ('!', 'I', 'F', 'W', 'WF', 'WP')
     and shrtckn_subj_code NOT IN ('PED', 'ENI', 'ENV', 'ASC', 'DTS')
     and shrtckn_subj_code || shrtckn_crse_numb NOT IN
         ('BTC298',
          'BTC420',
          'BTC498',
          'EFB298',
          'EFB420',
          'EFB495',
          'EFB498',
          'ENS420',
          'ENS498',
          'ESF109',
          'ESF209',
          'ESF499',
          'EST400',
          'EST499',
          'FCH498',
          'FOR498',
          'FOR495',
          'LSA498',
          'BPE498',
          'PSE498',
          'ECH498',
          'RMS498')
     and shrtckn_term_code >= '202120'
     and spriden_pidm = shrtckn_pidm
     and spriden_change_ind is null
   order by spriden_last_name, spriden_first_name, shrtckn_crn)

,
repeat as
 (select a.shrtckg_pidm pidm,
         shrtckn_subj_code subj,
         shrtckn_crse_numb crse,
         shrtckn_subj_code || shrtckn_crse_numb clas
    from shrtckg a, shrtckn
   where a.shrtckg_pidm = shrtckn_pidm
     and a.shrtckg_term_code = shrtckn_term_code
     and a.shrtckg_tckn_seq_no = shrtckn_seq_no
     and a.shrtckg_seq_no =
         (select max(b.shrtckg_seq_no)
            from shrtckg b
           where b.shrtckg_pidm = a.shrtckg_pidm
             and b.shrtckg_term_code = a.shrtckg_term_code
             and b.shrtckg_tckn_seq_no = a.shrtckg_tckn_seq_no)
     and shrtckn_term_code >= '202120'
   group by shrtckg_pidm,
            shrtckn_subj_code,
            shrtckn_crse_Numb,
            shrtckn_subj_code || shrtckn_crse_numb
  having count(shrtckn_subj_code || shrtckn_crse_numb) > 1
   order by shrtckg_pidm, shrtckn_subj_code || shrtckn_crse_numb)

select *
  from main_1
 where main_1.pidm IN (select repeat.pidm from repeat)
   and main_1.clas IN
       (select repeat.clas from repeat where repeat.pidm = main_1.pidm)
--$addfilter
 order by main_1.lname, main_1.fname, main_1.clas
