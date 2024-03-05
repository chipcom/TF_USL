#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 08.02.24
PROCEDURE Main() 
  
  local _vmp_usl := {;
    {'SHIFR',    'C',     10,      0}, ;
    {'P_CEL',  'C',      4,      0} ;
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('p_cel_usl', _vmp_usl)
  dbUseArea( .t.,, 'p_cel_usl', 'PCEL', .f., .f. )
  PCEL->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=P_CEL.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'CEL') 
  ? 'Alias:', Alias() 

  CEL->(dbGoTop())
  // VMP->(dbSkip())
  while !empty((CEL->(fieldget(1)))) // != nil //(eof())
    PCEL->(dbAppend())
    PCEL->SHIFR := CEL->(fieldget(1))
    PCEL->P_CEL := CEL->(fieldget(3))
    CEL->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  // dbGoTop() 
  // Browse() 
  CEL->(dbCloseArea())
  PCEL->(dbCloseArea())
  
  RETURN