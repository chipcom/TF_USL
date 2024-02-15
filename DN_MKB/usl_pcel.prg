#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 08.02.24
PROCEDURE Main() 
  
  local _usl_pcel := {;
    {'USLUGA',     'C',     15,      0} ,;
    {'P_CEL',      'C',      5,      0} ;
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('_usl_pcel', _usl_pcel)
  dbUseArea( .t.,, '_usl_pcel', 'USL_PCEL', .f., .f. )
  USL_PCEL->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=usl_pcel.xls;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'XL_PCEL') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  XL_PCEL->(dbGoTop())
  while !empty((XL_PCEL->(fieldget(4)))) // != nil //(eof())
    USL_PCEL->(dbAppend())
    USL_PCEL->USLUGA := alltrim(XL_PCEL->(fieldget(1)))
    USL_PCEL->P_CEL := alltrim(XL_PCEL->(fieldget(3)))
    XL_PCEL->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  XL_PCEL->(dbCloseArea())
  USL_PCEL->(dbCloseArea())
  
  RETURN