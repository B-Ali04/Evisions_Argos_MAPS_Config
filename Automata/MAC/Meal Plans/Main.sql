select suid.goradid_additional_id as SUID,
    slrmasg_mrcd_code as MealPlan,
    case
        when st.SFBETRM_ESTS_CODE != 'EL' then '101'
        when slrmasg_mrcd_code = 'TFRM' then '65'
        when slrmasg_mrcd_code = 'TH3' then '64'
        when slrmasg_mrcd_code = 'TH4' then '67'
        when slrmasg_mrcd_code = 'TH2' then '63'
        when slrmasg_mrcd_code = 'TH1' then '62'
        when slrmasg_mrcd_code = 'THA' then '60'
        when slrmasg_mrcd_code = 'THB' then '61'
        else '65'
    end as MacPlan,
    spriden_last_name as LastName,
    spriden_first_name as FirstName,
    spriden_mi as MiddleName,
    spbpers_pref_first_name as PrefFirst,
    spbpers_birth_date as BirthDate,
    spbpers_sex as Gender,
    concat(netid.goradid_additional_id,'@syr.edu') as Email,
    '2' as AddrId, -- permanent address (PR)
    spraddr_street_line1 as AddrLine1,
    spraddr_street_line2 as AddrLine2,
    spraddr_city as City,
    spraddr_stat_code as State,
    spraddr_zip as ZipCd,
    spraddr_natn_code as Country,
    null as AddrPhone,
    '10000000' || substr(spriden_id,2,8) as CardNumber,
    'M' as CampusInd,
    st.sfbetrm_term_code as termcode
from SFBETRM st
inner join SPRIDEN sp on sp.SPRIDEN_PIDM = st.SFBETRM_PIDM and sp.SPRIDEN_ID like 'F%' and sp.SPRIDEN_ACTIVITY_DATE = (select max(sp2.SPRIDEN_ACTIVITY_DATE) from spriden sp2 where sp2.spriden_pidm = st.SFBETRM_PIDM and sp2.spriden_id like 'F%')
left outer join slrmasg mp on mp.slrmasg_term_code  = st.SFBETRM_TERM_CODE and mp.slrmasg_PIDM = st.SFBETRM_PIDM and mp.slrmasg_mscd_code = 'AC'
--inner join SFBETRM st on st.SFBETRM_PIDM = st.SFBETRM_PIDM and st.SFBETRM_TERM_CODE = '202120' -- and st.SFBETRM_ESTS_CODE = 'EL'
inner join SPBPERS pers on pers.SPBPERS_PIDM = st.SFBETRM_PIDM
inner join GORADID netid on netid.GORADID_PIDM = st.SFBETRM_PIDM and netid.GORADID_ADID_CODE = 'SUNI'
inner join GORADID suid on suid.GORADID_PIDM = st.SFBETRM_PIDM and suid.GORADID_ADID_CODE = 'SUID'
inner join SPRADDR adr on adr.SPRADDR_PIDM = st.SFBETRM_PIDM and adr.SPRADDR_ATYP_CODE = 'PR' and adr.SPRADDR_SEQNO = (select max(SPRADDR_SEQNO) from SPRADDR where SPRADDR_PIDM = SPRIDEN_PIDM and SPRADDR_ATYP_CODE = 'PR')
where  st.sfbetrm_term_code =  :sql_getMACSem.MACSEM

UNION

select suid.goradid_additional_id as SUID,
    slrmasg_mrcd_code as MealPlan,
    case
        when st.SFBETRM_ESTS_CODE != 'EL' then '101'
        when slrmasg_mrcd_code = 'TFRM' then '65'
        when slrmasg_mrcd_code = 'TH3' then '64'
        when slrmasg_mrcd_code = 'TH4' then '67'
        when slrmasg_mrcd_code = 'TH2' then '63'
        when slrmasg_mrcd_code = 'TH1' then '62'
        when slrmasg_mrcd_code = 'THA' then '60'
        when slrmasg_mrcd_code = 'THB' then '61'
        else '65'
    end as MacPlan,
    spriden_last_name as LastName,
    spriden_first_name as FirstName,
    spriden_mi as MiddleName,
    spbpers_pref_first_name as PrefFirst,
    spbpers_birth_date as BirthDate,
    spbpers_sex as Gender,
    concat(netid.goradid_additional_id,'@syr.edu') as Email,
    '1' as AddrId, -- Local address (MA)
    spraddr_street_line1 as AddrLine1,
    spraddr_street_line2 as AddrLine2,
    spraddr_city as City,
    spraddr_stat_code as State,
    spraddr_zip as ZipCd,
    spraddr_natn_code as Country,
    null as AddrPhone,
    '10000000' || substr(spriden_id,2,8) as CardNumber,
    'M' as CampusInd,
    st.sfbetrm_term_code as termcode
from SFBETRM st
inner join SPRIDEN sp on sp.SPRIDEN_PIDM = st.SFBETRM_PIDM and sp.SPRIDEN_ID like 'F%' and sp.SPRIDEN_ACTIVITY_DATE = (select max(sp2.SPRIDEN_ACTIVITY_DATE) from spriden sp2 where sp2.spriden_pidm = st.SFBETRM_PIDM and sp2.spriden_id like 'F%')
left outer join slrmasg mp on mp.slrmasg_term_code  = st.SFBETRM_TERM_CODE and mp.slrmasg_PIDM = st.SFBETRM_PIDM and mp.slrmasg_mscd_code = 'AC'
inner join SPBPERS pers on pers.SPBPERS_PIDM = st.SFBETRM_PIDM
inner join GORADID netid on netid.GORADID_PIDM = st.SFBETRM_PIDM and netid.GORADID_ADID_CODE = 'SUNI'
inner join GORADID suid on suid.GORADID_PIDM = st.SFBETRM_PIDM and suid.GORADID_ADID_CODE = 'SUID'
inner join SPRADDR adr on adr.SPRADDR_PIDM = st.SFBETRM_PIDM and adr.SPRADDR_ATYP_CODE = 'MA' and adr.SPRADDR_SEQNO = (select max(SPRADDR_SEQNO) from SPRADDR where SPRADDR_PIDM = slrmasg_PIDM and SPRADDR_ATYP_CODE = 'MA')
where st.sfbetrm_term_code =  :sql_getMACSem.MACSEM

order by SUID,AddrId