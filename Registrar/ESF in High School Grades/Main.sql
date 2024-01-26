WITH ma_addr AS(
select
    a.pidm pidm,
    a.street1 street1,
    a.street2 street2,
    a.street3 street3,
    a.street4 street4,
    a.city city,
    a.state_code state,
    a.zip zip
from
    rel_address a
where
    a.atyp_code = 'MA')

,pr_addr AS(
select
    p.pidm pidm,
    p.street1 street1,
    p.street2 street2,
    p.street3 street3,
    p.street4 street4,
    p.city city,
    p.state_code state,
    p.zip zip
from
    rel_address p
where
    p.atyp_code = 'PR')

,main_1 AS(
select
       i.spriden_pidm pidm,
       i.spriden_id banner_id,
       i.spriden_last_name lname,
       i.spriden_first_name fname,
       g.shrtckg_term_code as TermCd,
       n.shrtckn_crn as ClassNumber,
       n.shrtckn_subj_code as Subject,
       n.shrtckn_crse_numb as CatalogNbr,
       g.shrtckg_grde_code_final as CourseGradeImport
  from shrtckg g
 inner join shrtckn n
    on n.shrtckn_seq_no = g.shrtckg_tckn_seq_no
   and n.shrtckn_pidm = g.shrtckg_pidm
   and n.shrtckn_term_code = g.shrtckg_term_code
 inner join sgbstdn stu
    on stu.sgbstdn_pidm = g.shrtckg_pidm
   and stu.sgbstdn_term_code_eff =
       (select max(SGBSTDN_TERM_CODE_EFF)
          from SGBSTDN s2
         where s2.SGBSTDN_PIDM = g.shrtckg_pidm)
   and stu.sgbstdn_majr_code_1 = 'EHS'
 inner join spriden i
    on i.spriden_pidm = g.shrtckg_pidm
   and i.spriden_id like 'F%'
 where g.shrtckg_term_code = :parm_term_code_select.STVTERM_CODE
 order by i.spriden_last_name)

select
    main_1.banner_id,
    main_1.lname,
    main_1.fname,
      case
      when m.pidm IS NOT NULL THEN m.street1 ELSE p.street1
    end street1,
    case
      when m.pidm IS NOT NULL THEN m.street2 ELSE p.street2
    end street2,
    case
      when m.pidm IS NOT NULL THEN m.street3 ELSE p.street3
    end street3,
    case
      when m.pidm IS NOT NULL THEN m.street4 ELSE p.street4
    end street4,
    case
      when m.pidm IS NOT NULL THEN m.city ELSE p.city
    end city,
    case
      when m.pidm IS NOT NULL THEN m.state ELSE p.state
    end state,
    case
      when m.pidm IS NOT NULL THEN m.zip ELSE p.zip
    end zip,
    spbpers_birth_date dob,
    main_1.termcd term,
    main_1.classnumber,
    main_1.subject,
    main_1.catalognbr crse_numb,
    scbcrse_title course_title,
    main_1.coursegradeimport grade
from
    main_1,
    ma_addr m,
    pr_addr p,
    spbpers,
    scbcrse a
where
    m.pidm (+)= main_1.pidm
and p.pidm (+)= main_1.pidm
and spbpers_pidm (+)= main_1.pidm
and a.scbcrse_subj_code = main_1.subject
and a.scbcrse_crse_numb = main_1.catalognbr
and a.scbcrse_eff_term = (
    SELECT
        MAX(b.scbcrse_eff_term)
    FROM
        scbcrse b
    WHERE
        b.scbcrse_crse_numb = a.scbcrse_crse_numb
    AND b.scbcrse_subj_code = a.scbcrse_subj_code)
