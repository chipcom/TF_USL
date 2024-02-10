#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 08.02.24
PROCEDURE Main() 
  
  local _dn_mkb := {;
    {'MKB',     'C',     10,      0} ,;
    {'SHIFR',       'C',     10,      0} ;
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('_dn_mkb', _dn_mkb)
  dbUseArea( .t.,, '_dn_mkb', 'DN_MKB', .f., .f. )
  DN_MKB->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=dn_mkb.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'VMP') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  VMP->(dbGoTop())
  while !empty((VMP->(fieldget(4)))) // != nil //(eof())
    DN_MKB->(dbAppend())
    DN_MKB->MKB := alltrim(VMP->(fieldget(2)))
    DN_MKB->SHIFR := alltrim(VMP->(fieldget(3)))
    VMP->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  VMP->(dbCloseArea())
  DN_MKB->(dbCloseArea())
  
  RETURN