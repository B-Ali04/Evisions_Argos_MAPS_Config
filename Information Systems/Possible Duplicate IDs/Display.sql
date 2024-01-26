select spriden_pidm "PIDM",
       spriden_id "ID",
       spbpers_ssn "SSN",
       spriden_last_name "LastName",
       spriden_first_name "FirstName",
       spbpers_birth_date "BirthDate",
       spriden_user "User",
       decode(spriden_first_name, NULL, 'Y', 'N') as Vendor,
       'Last Name and DOB Duplicate' as Reason
from   spriden, spbpers
where  spriden_pidm = spbpers_pidm
and    spriden_change_ind is null
and    spriden_last_name||spbpers_birth_date in
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
          having count(*) > 1)
order by 4,6