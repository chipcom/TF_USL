#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

PROCEDURE Main() 
  
  local _f003 := {;
    {'MCOD',     'C',      6,      0},;
    {'NAMEMOK',  'C',     50,      0},;
    {'NAMEMOP',  'C',    150,      0},;
    {'ADDRESS',  'C',    250,      0},;
    {'YEAR',     'N',     17,      0};
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('_mo_f003', _f003)
  dbUseArea( .t.,, '_mo_f003', 'F003', .f., .f. )
  F003->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=F032.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'SRC') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  SRC->(dbGoTop())
  // SRC->(dbSkip())
  while !empty((SRC->(fieldget(1)))) // != nil //(eof())
    F003->(dbAppend())
    F003->MCOD := SRC->(fieldget(1))
    F003->NAMEMOP := hb_AnsiToOem(alltrim(SRC->(fieldget(2))))
    F003->NAMEMOK := hb_AnsiToOem(alltrim(SRC->(fieldget(3))))
    F003->ADDRESS := hb_AnsiToOem(alltrim(SRC->(fieldget(4))))
    F003->YEAR := 2023  //  SRC->(fieldget(14))

    SRC->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  // dbGoTop() 
  // Browse() 
  SRC->(dbCloseArea())
  F003->(dbCloseArea())
  
  RETURN