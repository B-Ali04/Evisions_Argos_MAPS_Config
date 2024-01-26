WITH emerg AS (
SELECT
    e.spremrg_pidm pidm,
    e.spremrg_last_name lname,
    e.spremrg_first_name fname,
     case
      when
        e.spremrg_phone_number LIKE '%-%' then '('||e.spremrg_phone_area||') '||e.spremrg_phone_number
      when
        e.spremrg_phone_area = '1' then '('||substr(e.spremrg_phone_number,1,3)||') '||substr(e.spremrg_phone_number,4,3)||'-'||substr(e.spremrg_phone_number,7,4)
      when
        e.spremrg_phone_number is null then ''
      else
        '('||e.spremrg_phone_area||') '||substr(e.spremrg_phone_number,1,3)||'-'||substr(e.spremrg_phone_number,4,4)
    end phone,
    rel.stvrelt_desc relt,
    e.spremrg_street_line1 street1,
    e.spremrg_street_line2 street2,
    e.spremrg_city city,
    e.spremrg_stat_code state,
    e.spremrg_zip zip
FROM
    spremrg e,
    stvrelt rel
where
    rel.stvrelt_code (+)= e.spremrg_relt_code
and e.spremrg_priority = '1'
and e.spremrg_activity_date = (
    select
        max(f.spremrg_activity_date)
    from
        spremrg f
    where
        f.spremrg_pidm = e.spremrg_pidm
    and f.spremrg_priority = '1'))

,main_1 AS(
SELECT
    r.term_code term,
    stvterm_desc term_desc,
    r.pidm pidm,
    spriden_id banner_id,
     CASE
      WHEN spbpers_pref_first_name IS NOT NULL AND spbpers_pref_first_name <> spriden_first_name
        THEN spriden_last_name || ', '|| spriden_first_name || ' (' || spbpers_pref_first_name || ')'
      ELSE f_format_name(spriden_pidm, 'LF')
    END student,
    spriden_last_name lname,
    spriden_first_name fname,
    spriden_mi middle,
    suid.goradid_additional_id SUID,
    goremal_email_address email,
    spbpers_sex gender,
    spbpers_birth_date dob,
    stvclas_desc class,
    sgbstdn_degc_code_1 degprog,
    sgbstdn_majr_code_1 majr,
    stvmajr_desc majr_desc,
    stvmajr_desc programofstudy,
    stvdept_code||'-'||stvdept_desc DPT,
    fy_sfrstcr_credit_hr(r.pidm,r.term_code) credits_inp,
    shrlgpa_hours_earned credits_earned_overall,
    r.styp_desc regtype,
    a.sgbstdn_exp_grad_date expgraddate,
    case
      when
        hot.sprtele_phone_number LIKE '%-%' then '('||hot.sprtele_phone_area||') '||hot.sprtele_phone_number
      when
        hot.sprtele_phone_area = '1' then '('||substr(hot.sprtele_phone_number,1,3)||') '||substr(hot.sprtele_phone_number,4,3)||'-'||substr(hot.sprtele_phone_number,7,4)
      when
        hot.sprtele_phone_number is null then ''
      else
        '('||hot.sprtele_phone_area||') '||substr(hot.sprtele_phone_number,1,3)||'-'||substr(hot.sprtele_phone_number,4,4)
    end ho_phone,
    ho.spraddr_atyp_code ho_atyp,
    ho.spraddr_street_line1 ho_1,
    ho.spraddr_street_line2 ho_2,
    ho.spraddr_street_line3 ho_3,
    ho.spraddr_city ho_city,
    ho.spraddr_stat_code ho_state,
    ho.spraddr_zip ho_zip,
    ho.spraddr_city||' '||ho.spraddr_stat_code||' '||ho.spraddr_zip ho_full,
    lo.spraddr_atyp_code lo_atyp,
    lo.spraddr_street_line1 lo_1,
    lo.spraddr_street_line2 lo_2,
    lo.spraddr_street_line3 lo_3,
    lo.spraddr_city lo_city,
    lo.spraddr_stat_code lo_state,
    lo.spraddr_zip lo_zip,
    lo.spraddr_city||' '||lo.spraddr_stat_code||' '||lo.spraddr_zip lo_full,
    emerg.lname elname,
    emerg.fname efname,
    case
      when emerg.lname IS NULL THEN emerg.fname
      when emerg.fname IS NULL THEN emerg.lname
      when emerg.fname||emerg.lname IS NULL THEN NULL
      else emerg.lname||', '||emerg.fname
    end efullname,
    emerg.phone ephone,
    emerg.street1 estreet1,
    emerg.street2 estreet2,
    emerg.city ecity,
    emerg.state estate,
    emerg.zip ezip,
    emerg.city||' '||emerg.state||' '||emerg.zip emerg_full,
    case
      when
        prt.sprtele_phone_number LIKE '%-%' then '('||prt.sprtele_phone_area||') '||prt.sprtele_phone_number
      when
        prt.sprtele_phone_area = '1' then '('||substr(prt.sprtele_phone_number,1,3)||') '||substr(prt.sprtele_phone_number,4,3)||'-'||substr(prt.sprtele_phone_number,7,4)
      when
        prt.sprtele_phone_number is null then ''
      else
        '('||prt.sprtele_phone_area||') '||substr(prt.sprtele_phone_number,1,3)||'-'||substr(prt.sprtele_phone_number,4,4)
    end pr_phone,
    pr.spraddr_atyp_code pr_atyp,
    pr.spraddr_street_line1 pr_1,
    pr.spraddr_street_line2 pr_2,
    pr.spraddr_street_line3 pr_3,
    pr.spraddr_city pr_city,
    pr.spraddr_stat_code pr_state,
    pr.spraddr_zip pr_zip,
    pr.spraddr_city||' '||pr.spraddr_stat_code||' '||pr.spraddr_zip pr_full,
    case
      when
        cell.sprtele_phone_number LIKE '%-%' then '('||cell.sprtele_phone_area||') '||cell.sprtele_phone_number
      when
        cell.sprtele_phone_area = '1' then '('||substr(cell.sprtele_phone_number,1,3)||') '||substr(cell.sprtele_phone_number,4,3)||'-'||substr(cell.sprtele_phone_number,7,4)
      when
        cell.sprtele_phone_number is null then 'None'
      else
        '('||cell.sprtele_phone_area||') '||substr(cell.sprtele_phone_number,1,3)||'-'||substr(cell.sprtele_phone_number,4,4)
    end cell_phone
FROM
    rel_student r,
    stvmajr,
    sgbstdn a,
    spriden,
    spbpers,
    goradid suid,
    goremal,
    stvclas,
    stvdept,
    shrlgpa,
    spraddr ho,
    spraddr lo,
    sprtele hot,
    spraddr pr,
    sprtele prt,
    sprtele cell,
    emerg,
    stvterm

WHERE
    r.pidm = spriden_pidm
AND r.term_code = :ddSemester
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
AND ho.rowid (+)= tzkutil.fz_Get_Addr_ROWID(spriden_pidm,'MA','BI','TE')
AND hot.rowid (+)= tzkutil.fz_get_tele_rowid(spriden_pidm,'BI','MA','PC','AC','PR')
AND lo.rowid (+)= tzkutil.fz_get_addr_rowid(spriden_pidm,'C1','C2')
AND emerg.pidm (+)= spriden_pidm
AND pr.rowid (+)= tzkutil.fz_Get_Addr_ROWID(spriden_pidm,'PR','MA','PA','P2','BI','TE')
AND prt.rowid (+)= tzkutil.fz_get_tele_rowid(spriden_pidm,'PR','PC','PA','P2','EC','MA')
AND stvterm_code = r.term_code
AND cell.rowid (+)= tzkutil.fz_get_tele_rowid(spriden_pidm,'PC','PR')
)

select * from main_1
order by main_1.lname,
main_1.fname

