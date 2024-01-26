WITH grades AS(
SELECT
    a.shrtckg_grde_code_final grade,
    shrtckn_pidm pidm,
    shrtckn_crn crn,
    shrtckn_term_code term
FROM
    shrtckg a,
    shrtckn
WHERE
    a.shrtckg_pidm = shrtckn_pidm
AND a.shrtckg_term_code = shrtckn_term_code
AND a.shrtckg_tckn_seq_no = shrtckn_seq_no
AND a.shrtckg_seq_no = (
    SELECT
        MAX(b.shrtckg_seq_no)
    FROM
        shrtckg b
    WHERE
        b.shrtckg_pidm = a.shrtckg_pidm
    AND b.shrtckg_term_code = a.shrtckg_term_code
    AND b.shrtckg_tckn_seq_no = a.shrtckg_tckn_seq_no))

,main_1 AS(
select
    s.id id,
    goradid_additional_id SUID,
    s.lname || ', ' || coalesce(s.pref_fname, s.fname) || ' ' || s.mname as StudentName,
    s.pref_fname pref_fname,
    s.fname fname,
    s.mname mname,
    s.lname lname,
    e.email email,
    reg.sfrstcr_credit_hr credit_hr,
    reg.sfrstcr_rsts_code rsts_code,
    CASE
      WHEN grades.grade IS NULL THEN reg.sfrstcr_grde_code
      ELSE grades.grade
    END grde_code,
    cs.crn crn,
    cs.subj_code subj_code,
    cs.crse_numb crse_numb,
    cs.seq_numb seq_numb,
    cs.crse_title crse_title,
    ci.lfmi_name as PrimaryInstrName,
    g.sgbstdn_majr_code_1 as ProgramofStudy,
    g.sgbstdn_majr_code_1 as major_code,
    stvmajr_desc as major_desc,
    g.sgbstdn_degc_code_1 degree_code,
    stvdegc_desc degree_desc,
    STVCLAS.STVCLAS_DESC as ClassLvl,
    g.sgbstdn_resd_code resd_code
from
    rel_course_sections cs
left outer join rel_course_instructors ci on ci.term_code = cs.term_code and ci.crn = cs.crn and ci.primary_ind = 'Y'
inner join sfrstcr reg on reg.sfrstcr_term_code = cs.term_code and cs.crn = reg.sfrstcr_crn
inner join rel_identity_student s on s.pidm = reg.sfrstcr_pidm
inner join sgbstdn g on g.sgbstdn_pidm = s.pidm and g.sgbstdn_term_code_eff = fy_sgbstdn_eff_term(s.pidm, cs.term_code)
left outer join STVCLAS STVCLAS on STVCLAS.STVCLAS_CODE = f_class_calc_fnc(s.pidm,g.SGBSTDN_LEVL_CODE, cs.TERM_CODE)
left outer join rel_email e on e.pidm = s.pidm and e.emal_code = 'SU'
left outer join grades on grades.term = cs.term_code and grades.pidm = s.pidm and grades.crn = cs.crn
left outer join goradid on goradid_pidm = s.pidm and goradid_adid_code = 'SUID'
left outer join stvmajr on stvmajr_code = g.sgbstdn_majr_code_1
left outer join stvdegc on stvdegc_code = g.sgbstdn_degc_code_1
where
    cs.term_code = :ddSemester.STVTERM_CODE
and reg.sfrstcr_rsts_code = :main_LB_rsts.Code
order by
    cs.subj_code,
    cs.crse_numb,
    cs.seq_numb,
    s.lname,
    s.fname)

select
    *
FROM
    main_1