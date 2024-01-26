WITH advr_info AS(
SELECT
    advr.term_code term,
    advr.pidm pidm,
    advr.advr_pidm advr_pidm,
    advr.advr_lname lname,
    advr.advr_fname fname,
    advr.primary_ind primary_ind
FROM
    rel_student_advisor advr
WHERE
    advr.primary_ind = '1'
AND advr.pidm LIKE '%' )

,main_1 AS(
SELECT
    r.term_code term,
    r.pidm pidm,
     CASE
      WHEN spbpers_pref_first_name IS NOT NULL AND spbpers_pref_first_name <> spriden_first_name
        THEN spriden_last_name || ', '|| spriden_first_name || ' (' || spbpers_pref_first_name || ')'
      ELSE f_format_name(spriden_pidm, 'LF')
    END student,
    spriden_last_name lname,
    spriden_first_name fname,
    suid.goradid_additional_id SUID,
    goremal_email_address email,
    spbpers_sex gender,
    stvclas_desc class,
    sgbstdn_degc_code_1 degprog,
    sgbstdn_majr_code_1 majr,
    stvmajr_desc majr_desc,
    stvmajr_desc programofstudy,
    CASE
      WHEN stvdept_code IS NULL THEN 'None'
      ELSE stvdept_code
    END dept_code,
    CASE
      WHEN stvdept_code IS NULL THEN ''
      ELSE stvdept_code||'-'||stvdept_desc
    END DPT,
    fy_sfrstcr_credit_hr(r.pidm,r.term_code) credits_inp,
    shrlgpa_hours_earned credits_earned_overall,
    r.styp_desc regtype,
    a.sgbstdn_exp_grad_date expgraddate,
    CASE
      WHEN advr.pidm IS NULL THEN '' ELSE advr.lname||', '||advr.fname
    END advisor
FROM
    rel_student r,
    advr_info advr,
    stvmajr,
    sgbstdn a,
    spriden,
    spbpers,
    goradid suid,
    goremal,
    stvclas,
    stvdept,
    shrlgpa
WHERE
    r.pidm = spriden_pidm
AND r.term_code = :ddSemester.STVTERM_CODE--IN ('202230','202240')
AND advr.pidm (+)= r.pidm
AND advr.term (+)= r.term_code
AND a.sgbstdn_pidm = spriden_pidm
AND a.sgbstdn_term_code_eff = (
    SELECT
        MAX(b.sgbstdn_term_code_eff)
    FROM
        sgbstdn b
    WHERE
        b.sgbstdn_pidm = a.sgbstdn_pidm)
AND stvmajr_code = a.sgbstdn_majr_code_1
AND stvmajr_code NOT IN ('SUS','EHS')
AND EXISTS
    (SELECT
         *
     FROM
         sfrstcr
     WHERE
         spriden_pidm = sfrstcr_pidm
     AND sfrstcr_term_code = r.term_code
     AND sfrstcr_rsts_code = 'RE')
AND spbpers_pidm = spriden_pidm
AND suid.goradid_pidm = spriden_pidm
AND suid.goradid_adid_code = 'SUID'
AND goremal_pidm (+)= spriden_pidm
AND goremal_preferred_ind (+)= 'Y'
AND stvclas_code = f_class_calc_fnc(spriden_pidm, r.levl_code, r.term_code)
AND stvdept_code (+)= a.sgbstdn_dept_code
AND shrlgpa_pidm (+)= r.pidm
AND shrlgpa_gpa_type_ind (+)= 'O'
AND shrlgpa_levl_code (+)= sgbstdn_levl_code
AND spriden_id LIKE 'F%'
AND spriden_change_ind IS NULL
ORDER BY
    spriden_search_last_name,
    spriden_search_first_name)

SELECT
    main_1.term,
    main_1.suid,
    main_1.lname,
    main_1.fname,
    main_1.class,
    main_1.majr,
    main_1.majr_desc,
    main_1.dpt,
    main_1.degprog,
    main_1.programofstudy,
    main_1.credits_inp,
    main_1.credits_earned_overall,
    main_1.advisor,
    main_1.email
FROM
    main_1
WHERE
    main_1.dept_code = :lbPOS.DEPT_CODE



