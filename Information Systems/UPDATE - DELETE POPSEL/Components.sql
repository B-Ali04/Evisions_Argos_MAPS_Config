-- id VERIFICATION
select spriden_id as banner_id,
       spriden_last_name as last_name,
       spriden_first_name as first_name
from spriden
where spriden_id = :MemoBoxID
  -------------------------------------------------------------------------------------
  -- if your institution's banner ids start with the number zero, use the following
  -- line of code instead of the line used above
  -- ( (spriden_id = :MemoBoxID) or (spriden_id = lpad(:MemoBoxID,9,'0') ))
  -------------------------------------------------------------------------------------
  and spriden_change_ind is null
  and :Execute_Verify is not null



-- CURRENT ENTRIES

select spriden_id,
       spriden_last_name,
       spriden_first_name
        --gzkolib.getemailaddress(spriden_pidm,'ICCICI') email
 from GLBEXTR,
      spriden
WHERE GLBEXTR_APPLICATION = :GetApplication.CODE
AND   GLBEXTR_SELECTION   = :GetSelection.CODE
AND   GLBEXTR_CREATOR_ID  = :GetCreator.CODE
AND   GLBEXTR_USER_ID     = :GetUser.CODE
--
and spriden_pidm = trim(glbextr_key)
and spriden_change_ind is null
--
--and :Execute_View_Popsel is not null

--
order by 1