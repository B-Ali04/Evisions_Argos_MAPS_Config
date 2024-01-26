SELECT BannerID, LastName, count(Bannerid) as Recs FROM (
select distinct spriden_id as BannerID, spriden_pidm AS PIDM
       ,(case when dc.sarappd_apdc_code is null THEN 'AX' ELSE dc.sarappd_apdc_code END) as APDC
       ,(case when dc.sarappd_pidm is null then SYSDATE ELSE dc.sarappd_apdc_date END) as APDC_DATE
       ,TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY') AS AsOf
       ,SUBSTR(TO_CHAR(t.STVTERM_START_DATE,'YYYYMMDD'),1,6) AS ENTRYDT
,s.spriden_last_name AS LASTNAME, s.spriden_first_name AS FIRSTNAME, s.spriden_mi AS MIDDLENAME, p.spbpers_name_suffix AS NAME_SUFFIX
,p.spbpers_pref_first_name as Pref_First_Name
,st.sgbstdn_stst_code as STST
,st.sgbstdn_styp_code as STYP
,st.sgbstdn_resd_code as resd_code
,su.goradid_additional_id as SUID
,ni.goradid_additional_id as NETID
,e.goremal_email_address as pers_email
,sue.goremal_email_address as su_email
,c.gobumap_udc_id as UDCID, d.gobtpac_external_user as ESFiD
,CASE WHEN a.spraddr_pidm is not null then 'PR' else case when a2.spraddr_pidm is not null then 'MA' else null end end as atyp_code
,case when a.spraddr_pidm is not null then a.spraddr_seqno ELSE case when a2.spraddr_pidm is not null then a2.spraddr_seqno else null end end as atyp_seq
,CASE WHEN a.spraddr_pidm is not null THEN
           CASE WHEN a.spraddr_natn_code is not null THEN a.spraddr_natn_code
                WHEN dc.sarappd_apdc_code is null THEN 'US'
                ELSE '' END
      WHEN a2.spraddr_pidm is not null THEN
           CASE WHEN a2.spraddr_natn_code is not null THEN a2.spraddr_natn_code
                WHEN dc.sarappd_apdc_code is null THEN 'US'
                ELSE '' END
      ELSE '' END as atyp_natn
,CONCAT(ph.sprtele_phone_area,ph.sprtele_phone_number) as phone
,p.spbpers_ssn as ssn
,p.spbpers_sex as sex
,p.spbpers_birth_date as birthdate
,st.sgbstdn_levl_code as su_level
,st.sgbstdn_term_code_eff, st.sgbstdn_term_code_admit
,st.sgbstdn_degc_code_1 AS Degree
,st.sgbstdn_majr_code_1 as Major
,st.sgbstdn_majr_code_conc_1 as Conc
,CASE WHEN st.sgbstdn_levl_code = 'UG' THEN
      CASE WHEN st.sgbstdn_degc_code_1 = 'ND' THEN 'F998U'
           WHEN st.sgbstdn_majr_code_1 = 'UNDC' THEN 'F000B'
           WHEN st.sgbstdn_majr_code_1 = 'BMAT' THEN 'F030B'
           WHEN st.sgbstdn_majr_code_1 = 'BPEN' THEN 'F040B'
           WHEN st.sgbstdn_majr_code_1 = 'PSEN' THEN 'F050B'
           WHEN st.sgbstdn_majr_code_1 = 'SEMN' THEN 'F060B'
           WHEN st.sgbstdn_majr_code_1 = 'WDSI' THEN 'F070B'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F080B'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 ='ZCME' THEN 'F081B'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 ='ZSCT' THEN 'F082B'
           WHEN st.sgbstdn_majr_code_1 = 'SENR' THEN 'F090B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F100B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZEPH' THEN 'F101B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IFEN' THEN 'F102B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZFMS' THEN 'F103B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZRRM' THEN 'F104B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZWPH' THEN 'F105B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZECE' THEN 'F106B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IFSI' THEN 'F107B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZFSS' THEN 'F108B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ITRE' THEN 'F109B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IINF' THEN 'F110B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZURF' THEN 'F111B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZMAM' THEN 'F112B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IRIM' THEN 'F113B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZNRM' THEN 'F114B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZSEN' THEN 'F115B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZCMT' THEN 'F116B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZSCM' THEN 'F117B'
           WHEN st.sgbstdn_majr_code_1 = 'FMOG' THEN 'F120B'
           WHEN st.sgbstdn_majr_code_1 = 'NRMN' THEN 'F130B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F140B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IMG1' THEN 'F141B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IWR1' THEN 'F142B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IFB1' THEN 'F143B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IRRM' THEN 'F144B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IRFR' THEN 'F145B'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IUCF' THEN 'F146B'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F150B'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 ='IRSR' THEN 'F151B'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 ='IWAT' THEN 'F152B'
           WHEN st.sgbstdn_majr_code_1 = 'SEMT' THEN 'F160B'
           WHEN st.sgbstdn_majr_code_1 = 'FESC' THEN 'F180B'
           WHEN st.sgbstdn_majr_code_1 = 'IDU2' THEN 'F195B'
           WHEN st.sgbstdn_majr_code_1 = 'IDU4' THEN 'F196B'
           WHEN st.sgbstdn_majr_code_1 = 'IDU3' THEN 'F197B'
           WHEN st.sgbstdn_majr_code_1 = 'EFBG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F200B'
           WHEN st.sgbstdn_majr_code_1 = 'BIOC' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F220B'
           WHEN st.sgbstdn_majr_code_1 = 'EFCG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F230B'
           WHEN st.sgbstdn_majr_code_1 = 'CHEM' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F240B'
           WHEN st.sgbstdn_majr_code_1 = 'CHEM' AND st.sgbstdn_majr_code_conc_1 ='ZBNP' THEN 'F241B'
           WHEN st.sgbstdn_majr_code_1 = 'CHEM' AND st.sgbstdn_majr_code_conc_1 ='ZECH' THEN 'F242B'
           WHEN st.sgbstdn_majr_code_1 = 'CHEM' AND st.sgbstdn_majr_code_conc_1 ='ZNSP' THEN 'F243B'
           WHEN st.sgbstdn_majr_code_1 = 'ENBI' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F250B'
           WHEN st.sgbstdn_majr_code_1 = 'ENHE' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F270B'
           WHEN st.sgbstdn_majr_code_1 = 'BIOT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F280B'
           WHEN st.sgbstdn_majr_code_1 = 'EREG' THEN 'F300B'
           WHEN st.sgbstdn_majr_code_1 = 'FORE' THEN 'F310B'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F320B'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS2' THEN 'F321B'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS3' THEN 'F322B'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS4' THEN 'F323B'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS5' THEN 'F324B'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F330B'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 ='ICME' THEN 'F331B'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 ='IWDE' THEN 'F332B'
           WHEN st.sgbstdn_majr_code_1 = 'CMGN' THEN 'F340B'
           WHEN st.sgbstdn_majr_code_1 = 'IWPR' THEN 'F350B'
           WHEN st.sgbstdn_majr_code_1 = 'PSCI' THEN 'F360B'
           WHEN st.sgbstdn_majr_code_1 = 'PAEN' THEN 'F370B'
           WHEN st.sgbstdn_majr_code_1 = 'BIEN' THEN 'F380B'
           WHEN st.sgbstdn_majr_code_1 = 'EREN' THEN 'F390B'
           WHEN st.sgbstdn_majr_code_1 = 'OSUS' THEN 'F400B'
           WHEN st.sgbstdn_majr_code_1 = 'LARC' THEN 'F410B'
           WHEN st.sgbstdn_majr_code_1 = 'ENST' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F420B'
           WHEN st.sgbstdn_majr_code_1 = 'RMSC' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F430B'
           WHEN st.sgbstdn_majr_code_1 = 'ENSC' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F440B'
           WHEN st.sgbstdn_majr_code_1 = 'AFSC' THEN 'F450B'
           WHEN st.sgbstdn_majr_code_1 = 'CONB' THEN 'F460B'
           WHEN st.sgbstdn_majr_code_1 = 'FOHE' THEN 'F470B'
           WHEN st.sgbstdn_majr_code_1 = 'EEIN' THEN 'F480B'
           WHEN st.sgbstdn_majr_code_1 = 'WLSC' THEN 'F490B'
           WHEN st.sgbstdn_majr_code_1 = 'ERNG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F500B'
           WHEN st.sgbstdn_majr_code_1 = 'SCWG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F520B'
           WHEN st.sgbstdn_majr_code_1 = 'PBEG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F540B'
           WHEN st.sgbstdn_majr_code_1 = 'ENSG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F560B'
           WHEN st.sgbstdn_majr_code_1 = 'ENTG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F580B'
           WHEN st.sgbstdn_majr_code_1 = 'FOTC' THEN 'F610A'
           WHEN st.sgbstdn_majr_code_1 = 'LSTC' THEN 'F620A'
           WHEN st.sgbstdn_majr_code_1 = 'ENRC' THEN 'F630A'
           WHEN st.sgbstdn_majr_code_1 = 'EDMK' THEN 'F701B'
           WHEN st.sgbstdn_majr_code_1 = 'ENVL' THEN 'F702B'
           WHEN st.sgbstdn_majr_code_1 = 'CHME' THEN 'F710B'
           WHEN st.sgbstdn_majr_code_1 = 'ADET' THEN 'F801B'
           WHEN st.sgbstdn_majr_code_1 = 'BIOP' THEN 'F802B'
           WHEN st.sgbstdn_majr_code_1 = 'RADC' THEN 'F803B'
           WHEN st.sgbstdn_majr_code_1 = 'ENVL' THEN 'F804B'
           ELSE 'UG_Lookup' END
      WHEN st.sgbstdn_levl_code = 'GR' THEN
      CASE WHEN st.sgbstdn_degc_code_1 = 'ND' THEN 'F998G'
           WHEN st.sgbstdn_majr_code_1 = 'UNDC' THEN 'F000'
           WHEN st.sgbstdn_majr_code_1 = 'BMAT' THEN 'F030'
           WHEN st.sgbstdn_majr_code_1 = 'BPEN' THEN 'F040'
           WHEN st.sgbstdn_majr_code_1 = 'PSEN' THEN 'F050'
           WHEN st.sgbstdn_majr_code_1 = 'SEMN' THEN 'F060'
           WHEN st.sgbstdn_majr_code_1 = 'WDSI' THEN 'F070'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F080'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 ='ZCME' THEN 'F081'
           WHEN st.sgbstdn_majr_code_1 = 'SCMT' AND st.sgbstdn_majr_code_conc_1 ='ZSCT' THEN 'F082'
           WHEN st.sgbstdn_majr_code_1 = 'SENR' THEN 'F090'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F100'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZEPH' THEN 'F101'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IFEN' THEN 'F102'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZFMS' THEN 'F103'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZRRM' THEN 'F104'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZWPH' THEN 'F105'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZECE' THEN 'F106'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IFSI' THEN 'F107'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZFSS' THEN 'F108'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ITRE' THEN 'F109'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IINF' THEN 'F110'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZURF' THEN 'F111'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZMAM' THEN 'F112'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='IRIM' THEN 'F113'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZNRM' THEN 'F114'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZSEN' THEN 'F115'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZCMT' THEN 'F116'
           WHEN st.sgbstdn_majr_code_1 = 'FRMG' AND st.sgbstdn_majr_code_conc_1 ='ZSCM' THEN 'F117'
           WHEN st.sgbstdn_majr_code_1 = 'FMOG' THEN 'F120'
           WHEN st.sgbstdn_majr_code_1 = 'NRMN' THEN 'F130'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F140'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IMG1' THEN 'F141'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IWR1' THEN 'F142'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IFB1' THEN 'F143'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IRRM' THEN 'F144'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IRFR' THEN 'F145'
           WHEN st.sgbstdn_majr_code_1 = 'FRMT' AND st.sgbstdn_majr_code_conc_1 ='IUCF' THEN 'F146'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F150'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 ='IRSR' THEN 'F151'
           WHEN st.sgbstdn_majr_code_1 = 'NRMT' AND st.sgbstdn_majr_code_conc_1 ='IWAT' THEN 'F152'
           WHEN st.sgbstdn_majr_code_1 = 'SEMT' THEN 'F160'
           WHEN st.sgbstdn_majr_code_1 = 'FESC' THEN 'F180'
           WHEN st.sgbstdn_majr_code_1 = 'IDU2' THEN 'F195'
           WHEN st.sgbstdn_majr_code_1 = 'IDU4' THEN 'F196'
           WHEN st.sgbstdn_majr_code_1 = 'IDU3' THEN 'F197'
           WHEN st.sgbstdn_majr_code_1 = 'EFBG' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'BIOC' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'EFCG' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'CHEM' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'ENBI' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'ENHE' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'BIOT' THEN 'F200'
           WHEN st.sgbstdn_majr_code_1 = 'EREG' THEN 'F300'
           WHEN st.sgbstdn_majr_code_1 = 'FORE' THEN 'F310'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F320'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS2' THEN 'F320'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS3' THEN 'F320'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS4' THEN 'F320'
           WHEN st.sgbstdn_majr_code_1 = 'IPS1' AND st.sgbstdn_majr_code_conc_1 ='IPS5' THEN 'F320'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 is null THEN 'F330'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 ='ICME' THEN 'F330'
           WHEN st.sgbstdn_majr_code_1 = 'IWPE' AND st.sgbstdn_majr_code_conc_1 ='IWDE' THEN 'F330'
           WHEN st.sgbstdn_majr_code_1 = 'CMGN' THEN 'F340'
           WHEN st.sgbstdn_majr_code_1 = 'IWPR' THEN 'F350'
           WHEN st.sgbstdn_majr_code_1 = 'PSCI' THEN 'F360'
           WHEN st.sgbstdn_majr_code_1 = 'PAEN' THEN 'F370'
           WHEN st.sgbstdn_majr_code_1 = 'BIEN' THEN 'F380'
           WHEN st.sgbstdn_majr_code_1 = 'EREN' THEN 'F390'
           WHEN st.sgbstdn_majr_code_1 = 'OSUS' THEN 'F400'
           WHEN st.sgbstdn_majr_code_1 = 'LARC' THEN 'F410'
           WHEN st.sgbstdn_majr_code_1 = 'ENST' THEN 'F420'
           WHEN st.sgbstdn_majr_code_1 = 'RMSC' THEN 'F430'
           WHEN st.sgbstdn_majr_code_1 = 'ENSC' THEN 'F440'
           WHEN st.sgbstdn_majr_code_1 = 'AFSC' THEN 'F450'
           WHEN st.sgbstdn_majr_code_1 = 'CONB' THEN 'F460'
           WHEN st.sgbstdn_majr_code_1 = 'FOHE' THEN 'F470'
           WHEN st.sgbstdn_majr_code_1 = 'EEIN' THEN 'F480'
           WHEN st.sgbstdn_majr_code_1 = 'WLSC' THEN 'F490'
           WHEN st.sgbstdn_majr_code_1 = 'ERNG' THEN 'F500'
           WHEN st.sgbstdn_majr_code_1 = 'SCWG' THEN 'F520'
           WHEN st.sgbstdn_majr_code_1 = 'PBEG' THEN 'F540'
           WHEN st.sgbstdn_majr_code_1 = 'ENSG' THEN 'F560'
           WHEN st.sgbstdn_majr_code_1 = 'ENTG' THEN 'F580'
           WHEN st.sgbstdn_majr_code_1 = 'FOTC' THEN 'F610'
           WHEN st.sgbstdn_majr_code_1 = 'LSTC' THEN 'F620'
           WHEN st.sgbstdn_majr_code_1 = 'ENRC' THEN 'F630'
           WHEN st.sgbstdn_majr_code_1 = 'EDMK' THEN 'F701'
           WHEN st.sgbstdn_majr_code_1 = 'CHME' THEN 'F710'
           WHEN st.sgbstdn_majr_code_1 = 'SCPR' THEN 'F711'
           WHEN st.sgbstdn_majr_code_1 = 'ADET' THEN 'F801'
           WHEN st.sgbstdn_majr_code_1 = 'BIOP' THEN 'F802'
           WHEN st.sgbstdn_majr_code_1 = 'RADC' THEN 'F803'
           WHEN st.sgbstdn_majr_code_1 = 'ENVL' THEN 'F804'
           ELSE 'GR_Lookup' END
      ELSE '??_Lookup'
END AS SU_POS
,CASE WHEN st.sgbstdn_levl_code = 'GR' THEN
      CASE WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='M' THEN 'M'
           WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='P' THEN 'D'
           WHEN SUBSTR(st.sgbstdn_degc_code_1,1,1)='C' THEN 'C'
           WHEN st.sgbstdn_degc_code_1='ND' THEN ''
           ELSE 'M' END
      ELSE '' END AS GR_SUFFIX
,case when i.gobintl_natn_code_birth is null then case when st.sgbstdn_resd_code in ('I','O') THEN 'US' ELSE '' end else i.gobintl_natn_code_birth end as natn_birth
,case when i.gobintl_natn_code_legal is null then case when i.gobintl_natn_code_birth is null then case when st.sgbstdn_resd_code in ('I','O') THEN 'US' ELSE '' end else i.gobintl_natn_code_birth end else i.gobintl_natn_code_legal end as natn_citz

from sgbstdn st
inner join spriden s on (st.sgbstdn_pidm=s.spriden_pidm and s.spriden_change_ind is null)
inner join spbpers p on (s.spriden_pidm=p.spbpers_pidm)
inner join stvterm t on (st.sgbstdn_term_code_eff=t.stvterm_code)
left outer join goradid su on (s.spriden_pidm=su.goradid_pidm and su.goradid_adid_code='SUID')
left outer join goradid ni on (s.spriden_pidm=ni.goradid_pidm and ni.goradid_adid_code='SUNI')
left outer join goradid x on (s.spriden_pidm=x.goradid_pidm and x.goradid_adid_code=:selADID.Missing)
LEFT OUTER JOIN gobumap c on (c.gobumap_pidm=s.spriden_pidm)
LEFT OUTER JOIN gobtpac d on (d.gobtpac_pidm=s.spriden_pidm)
LEFT OUTER JOIN SARADAP ap on (s.spriden_pidm=ap.saradap_pidm and ap.saradap_term_code_entry=st.sgbstdn_term_code_eff)
left outer join sarappd dc on (ap.saradap_pidm=dc.sarappd_pidm and ap.saradap_appl_no=dc.sarappd_appl_no and sarappd_term_code_entry=ap.saradap_term_code_entry and dc.sarappd_seq_no= (select max(b.sarappd_seq_no) as maxseq from sarappd b where ap.saradap_pidm=b.sarappd_pidm and ap.saradap_appl_no=b.sarappd_appl_no and b.sarappd_term_code_entry=st.sgbstdn_term_code_eff))
LEFT OUTER JOIN GOREMAL e on (s.spriden_pidm=e.goremal_pidm and e.goremal_emal_code='PERS' and e.goremal_status_ind='A')
LEFT OUTER JOIN GOREMAL sue on (s.spriden_pidm=sue.goremal_pidm and sue.goremal_emal_code='SU' and sue.goremal_status_ind='A')
LEFT OUTER JOIN SPRADDR a on (s.spriden_pidm=a.spraddr_pidm and a.spraddr_status_ind is null and a.spraddr_atyp_code='PR')
LEFT OUTER JOIN SPRADDR a2 on (s.spriden_pidm=a2.spraddr_pidm and a2.spraddr_status_ind is null and a2.spraddr_atyp_code='MA')
LEFT OUTER JOIN SPRTELE ph on (s.spriden_pidm=ph.sprtele_pidm and ph.sprtele_tele_code='PC' AND ph.sprtele_status_ind is null)
left outer join GOBINTL i on (s.spriden_pidm=i.gobintl_pidm)

where
st.sgbstdn_term_code_eff=(select max(b.sgbstdn_term_code_eff) from sgbstdn b where b.sgbstdn_pidm=st.sgbstdn_pidm)
--and st.sgbstdn_term_code_eff=st.sgbstdn_term_code_admit
and st.sgbstdn_term_code_eff >= :selMinTerm.CODE
and st.sgbstdn_term_code_eff <= :selMaxTerm.CODE
--and ap.saradap_term_code_entry >= :selMinTerm.CODE
--and ap.saradap_term_code_entry <= :selMaxTerm.CODE
--and sysdate < t.stvterm_end_date
--and sysdate + 90 > t.stvterm_start_date
and st.sgbstdn_stst_code in ('IR','AS')
and st.sgbstdn_coll_code_1 <> 'SU'
and st.sgbstdn_majr_code_1 <> 'EHS'
AND st.sgbstdn_styp_code = :selSTYP.STYP
and x.goradid_adid_code is null
and (case WHEN :chkReg=1 then
          CASE WHEN st.sgbstdn_pidm in (select DISTINCT sfrstcr_pidm from sfrstcr where sfrstcr_TERM_CODE >= :selMinTerm.CODE and sfrstcr_term_code <= :selMaxTerm.CODE and SFRSTCR_RSTS_CODE='RE') THEN 1 ELSE 0 END
          ELSE 1 END)=1
and (case WHEN :chkUnReg=1 then
          CASE WHEN st.sgbstdn_pidm not in (select DISTINCT sfrstcr_pidm from sfrstcr where sfrstcr_TERM_CODE >= :selMinTerm.CODE and sfrstcr_term_code <= :selMaxTerm.CODE and SFRSTCR_RSTS_CODE='RE') THEN 1 ELSE 0 END
          ELSE 1 END)=1
)
WHERE APDC = :selAPDC.APDC
group by Bannerid, LastName
having count(BannerID) > 1