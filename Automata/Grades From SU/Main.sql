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
and to_char(sfrstcr_activity_date, 'DD-MON-YYYY') = to_char(sysdate, 'DD-MON-YYYY')
order by
    sfrstcr_activity_date desc,
    spriden_last_name,
    spriden_first_name




--code below shows everything that was brought over into the baninst1.sugrades table from SU, but not necessarily everything that was updated in SFAREGS
/*select
    su.bannerterm term,
    spriden_pidm pidm,
    spriden_id bid,
    su.suid suid,
    spriden_last_name lname,
    spriden_first_name fname,
    su.subjcode subj,
    su.crsenumb crse,
    su.grade grade_inserted,
    su.crn crn,
    su.importdt import_date,
    su.procdt process_date
from
    BANINST1.SUGRADES su,
    spriden
where
    spriden_pidm = su.pidm
and spriden_change_ind is null
and to_char(su.importdt, 'DD-MON-YYYY') = to_char(sysdate, 'DD-MON-YYYY')
order by
    su.bannerterm desc,
    spriden_last_name,
    spriden_first_name*/



