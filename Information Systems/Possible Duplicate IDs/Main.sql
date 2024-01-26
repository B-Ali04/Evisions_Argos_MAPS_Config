select SPRIDEN.SPRIDEN_PIDM "PIDM",
       SPRIDEN.SPRIDEN_ID "ID",
       SPBPERS.SPBPERS_SSN "SSN",
       SPRIDEN.SPRIDEN_LAST_NAME "LastName",
       SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
       SPRIDEN.SPRIDEN_MI "Middle",
       SPBPERS.SPBPERS_BIRTH_DATE "BirthDate",
       SPRIDEN.SPRIDEN_USER "User",
       decode(spriden_first_name, NULL, 'Y', 'N') "VendorFlag",
       'Last Name and DOB Duplicate' "Reason"
  from SATURN.SPRIDEN SPRIDEN,
       SATURN.SPBPERS SPBPERS
 where ( SPBPERS.SPBPERS_PIDM = SPRIDEN.SPRIDEN_PIDM )
   and (     spriden_change_ind is null
         and spriden_last_name||spbpers_birth_date in
                  (select spriden_last_name||spbpers_birth_date
                   from   spriden, spbpers
                   where  spriden_pidm = spbpers_pidm
                   and    spriden_change_ind is null
                   and   (   :InclBlankSSN = 'Y'
                          or (    :InclBlankSSN = 'N'
                              and spbpers_ssn is not null))
                   and   (   :InclVendors = 'Y'
                          or (    :InclVendors = 'N'
                              and spriden_first_name is not null))
                   and   (   :InclBlankDOB = 'Y'
                          or (    :InclBlankDOB = 'N'
                              and spbpers_birth_date is not null))
                   group by spriden_last_name||spbpers_birth_date
                   having count(*) > 1) )
 order by SPRIDEN.SPRIDEN_LAST_NAME,
          SPBPERS.SPBPERS_BIRTH_DATE
