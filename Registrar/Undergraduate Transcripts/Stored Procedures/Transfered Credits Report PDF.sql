SORPCOL.SORPCOL_ADMR_CODE = :select_admr_code.SORPCOL_ADMR_CODE
and SHRTRCE.SHRTRCE_GRDE_CODE = :select_grde_code.GRDE_CODE
and SORPCOL.SORDEGR_VERSION = (select max(SORDEGR_VERSION)
                              from SORDEGR SORDEGRX
                              where SORDEGRX.SORDEGR_PIDM = SORPCOL.SORDEGR_PIDM)