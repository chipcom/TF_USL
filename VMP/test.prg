#require "rddsql" 
#require "sddodbc" 
  
#include "simpleio.ch" 
#include "dbinfo.ch" 
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

PROCEDURE Main() 
  
  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( "SQLBASE" ) 
    rddRegister( "SQLMIX" ) 
    hb_SDDODBC_Register() 
  #endif 
  
  Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
  HB_SETCODEPAGE( "RU1251" ) 
  
  rddSetDefault( "SQLMIX" ) 
  ? "Connect:", rddInfo( RDDI_CONNECT, { "ODBC", "Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST.XLS;" } ) 
  ? "Use:", dbUseArea( .T., , "select * from [111$] ", "test" ) 
  ? "Alias:", Alias() 
  ? "DB struct:", hb_ValToExp( dbStruct() ) 
  wait 
  
  dbGoTop() 
  Browse() 
  dbCloseArea() 
  
  RETURN