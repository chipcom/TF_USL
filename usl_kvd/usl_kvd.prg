#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
#include 'common.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

PROCEDURE Main() 
  
  local t_shifr := ''
  local short_name := '', full_name := ''

  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbUseArea( .t.,, 'USLUGI', 'USL', .f., .f. )
  index on shifr to ('uslugish')

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=price.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'VMP') 
  ? 'Alias:', Alias() 
  ? ''
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  VMP->(dbGoTop())
  while !(eof())
    if ! isnil(VMP->(fieldget(1)))
      t_shifr := alltrim(VMP->(fieldget(1)))
      if len(t_shifr) == RAt('.', t_shifr)
        t_shifr := substr(t_shifr, 1, RAt('.', t_shifr) - 1)
      endif
      if USL->(dbSeek(t_shifr))
        if ! isnil(VMP->(fieldget(3)))
          short_name := alltrim(VMP->(fieldget(3)))
          if len(short_name) > 255
            full_name := substr(short_name, 1, 255)
          else
            full_name := short_name
          endif
  
          if len(short_name) > 65
            short_name := substr(short_name, 1, 65)
          endif
          USL->NAME := short_name
          USL->FULL_NAME := full_name
        endif
      endif
    endif

    VMP->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  // dbGoTop() 
  // Browse() 
  VMP->(dbCloseArea())
  USL->(dbCloseArea())
  ?'This is it'
  RETURN