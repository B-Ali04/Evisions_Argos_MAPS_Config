-- term selection
select TRIM(STVTERM_CODE) AS CODE, STVTERM_DESC AS TERM_DESCRIPTION
FROM STVTERM
WHERE STVTERM_CODE >= '202110' AND STVTERM_START_DATE < SYSDATE + 180
--and substr(stvterm_code,5,1) in ('1','3','5')
ORDER BY STVTERM_CODE DESC

-- id lookup
select x.username, spriden_last_name as Last_Name,
case when spbpers_pref_first_name is null then spriden_first_name else spbpers_pref_first_name end as First_Name,
x.pidm
from (
select u.username,
gobtpac_external_user, gobtpac_pidm,
esfl.goradid_pidm as esfl_pidm,
su.goradid_pidm as su_pidm,
case when esfl.goradid_pidm is not null then esfl.goradid_pidm when ad.goremal_pidm is not null then ad.goremal_pidm when e.goremal_pidm is not null then e.goremal_pidm when su.goradid_pidm is not null then su.goradid_pidm when gobtpac_pidm is not null then gobtpac_pidm else 0 end as pidm
from (
select
case
when :optUser = 'Override' and :edtUserO is not null then
case when Instr(:edtUserO,'@') > 0 then LOWER(substr(:edtUserO,1,Instr(:edtUserO,'@')-1))
     else Lower(:edtUserO) end
else
case when Instr(:edtUser,'@') > 0 then Lower(substr(:edtUser,1,Instr(:edtUser,'@')-1))
     else Lower(:edtUser) end
end as UserName
from dual) u
left join gobtpac on (u.username=gobtpac_external_user)
left join goradid esfl on (u.username=esfl.goradid_additional_id and esfl.goradid_adid_code='ESFL')
left join goradid su on (u.username=su.goradid_additional_id and su.goradid_adid_code='SUNI')
LEFT OUTER JOIN GOREMAL ad on (ad.goremal_emal_code='AD' and u.username=substr(ad.goremal_email_address,1,instr(ad.goremal_email_address,'@')-1))
LEFT OUTER JOIN GOREMAL e on (e.goremal_emal_code='ESF' and u.username=substr(e.goremal_email_address,1,instr(e.goremal_email_address,'@')-1))
) x
left join spriden s on (x.pidm=s.spriden_pidm and s.spriden_change_ind is null)
left join spbpers p on (x.pidm=p.spbpers_pidm)