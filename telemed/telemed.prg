#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 08.02.24
PROCEDURE Main() 
  
  local telemed := {;
    {'SHIFR',    'C',     15,      0},;
    {'NAME',     'C',     250,     0},;
    {'DATEBEG',  'D',      8,      0},;
    {'DATEEND',  'D',      8,      0};
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('telemed', telemed)
  dbUseArea( .t.,, 'telemed', 'TELE', .f., .f. )
  TELE->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
//  HB_SETCODEPAGE( 'RU1251' ) 
  HB_SETCODEPAGE( 'CP866' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=telemed.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'SRC') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  SRC->(dbGoTop())
  // SRC->(dbSkip())
  while !empty((SRC->(fieldget(1))))
    TELE->(dbAppend())
    TELE->SHIFR := SRC->(fieldget(1))
    TELE->NAME := SRC->(fieldget(2))
    TELE->DATEBEG := SRC->(fieldget(3))
    TELE->DATEEND := SRC->(fieldget(4))

    SRC->(dbSkip())
  end
  SRC->(dbCloseArea())
  TELE->(dbCloseArea())
  
  RETURN