select
    sfrstcr_term_code term,
    spriden_pidm pidm,
    spriden_id bid,
    goradid_additional_id suid,
    spriden_last_name lname,
    spriden_first_name fname,
    ssbsect_subj_code subj,
    ssbsect_crse_numb crse,
    sfrstcr_grde_code grade_inserted,
    sfrstcr_crn crn,
    sfrstcr_activity_date import_date
from
    sfrstcr,
    ssbsect,
    goradid,
    spriden
where
    spriden_pidm = sfrstcr_pidm
and spriden_change_ind is null
and sfrstcr_user = 'GRADESFROMSU'
and goradid_pidm = sfrstcr_pidm
and goradid_adid_code = 'SUID'
and ssbsect_crn = sfrstcr_crn
and ssbsect_term_code = sfrstcr_term_code
and :main_BTN_run is not null
--and to_char(sfrstcr_activity_date, 'DD-MON-YYYY') = to_char(sysdate, 'DD-MON-YYYY')
order by
    sfrstcr_activity_date desc,
    spriden_last_name,
    spriden_first_name