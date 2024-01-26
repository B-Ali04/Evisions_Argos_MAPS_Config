select
    ssbsect_term_code term,
    ssbsect_crn crn,
    ssbsect_subj_code subj,
    ssbsect_crse_numb crse
from
    ssbsect,
    sirasgn
where
--    sirasgn_pidm = fy_getpidm(:main_EB_id)
    sirasgn_pidm = :ddInstructor.SIRASGN_PIDM
and sirasgn_term_code = :ddSemester.STVTERM_CODE
and ssbsect_term_code = sirasgn_term_code
and ssbsect_crn = sirasgn_crn
and :main_BTN_exec is not null