select DataBlock.Author,
       DataBlock.Path,
       DataBlock.Name as "Datablock",
       DataBlockObject.Name as "ObjectName",
       DataBlockObject.Type as "Type",
       DataBlockObject.Value
  from DataBlockObject inner join DataBlock on DataBlockObject.DataBlock_Id = DataBlock.Id
 where Author like '%' ||  :EB_COMET_ID  || '%'
       AND DataBlockObject.Type not in('Form','Panel','Image','Shape', 'Button', 'RadioButtonPanel','ScrollBox','Label','Memo','DateEdit','CheckBox')
       and DataBlockObject.Value like '%' || :EB_CONTAINS || '%'
       and :BT_SHOW is not null
 order by DataBlock.Author,
          DataBlock.Name