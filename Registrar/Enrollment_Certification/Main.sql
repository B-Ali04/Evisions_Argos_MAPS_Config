Select stvterm_desc as Semester,
stvterm_Start_Date as Start_Date, stvterm_end_date as End_Date,
HRS_CARRIED,
HRS_PASSED,
CASE WHEN SYSDATE < STVTERM_START_DATE THEN CASE WHEN HRS_Carried > 0 THEN 'Pre-registered' ELSE 'Enrolled' END
     WHEN sfrthst_PIDM IS NULL THEN CASE WHEN HRS_Carried >= 12 THEN 'Full-Time' ELSE 'Part-Time' END
     ELSE STVTMST_DESC END AS Status,
Term_Code,
pidm
from
(
select pidm, Term_Code, sum(Hrs_Carried) as Hrs_Carried, sum(Hrs_Passed) as Hrs_Passed
from

(select
shrtgpa_pidm as pidm,
shrtgpa_term_code as Term_Code,
shrtgpa_HOURS_ATTEMPTED as Hrs_Carried,
shrtgpa_HOURS_PASSED as Hrs_Passed
from shrtgpa
where
SHRTGPA_GPA_TYPE_IND <> 'T' AND
SHRTGPA_TERM_CODE <= :MainTerm.TERM_CODE AND
Shrtgpa_pidm=:selStudent.PIDM AND
Shrtgpa_levl_code=:selLevlTerm.Levl

UNION

select pidm, Term_Code, sum(Hrs_Carried) as Hrs_Carried, sum(Hrs_Passed) as Hrs_Passed
from
(select
sfrstcr_pidm as pidm,
sfrstcr_term_code as Term_Code,
sfrstcr_credit_hr as Hrs_Carried,
0 as Hrs_Passed
FROM SFRSTCR
where sfrstcr_pidm=:selStudent.PIDM
and sfrstcr_term_code <= :MainTerm.TERM_CODE
and sfrstcr_levl_code = :selLevlTerm.Levl
AND SFRSTCR_RSTS_CODE = 'RE'
AND sfrstcr_grde_code is null
)
group by pidm, Term_Code)

group by pidm, Term_Code)
INNER JOIN STVTERM ON (Term_Code=STVTERM_CODE)
left outer join sfrthst on (sfrthst_pidm=pidm and sfrthst_term_code=term_code and sfrthst_SURROGATE_ID = (select max(b.sfrthst_SURROGATE_ID) from sfrthst b where b.sfrthst_pidm = pidm and b.sfrthst_term_code=term_code))
left outer join stvtmst on (sfrthst_tmst_code = stvtmst_code)
ORDER BY stvterm_START_DATE