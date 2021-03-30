#require "rddsql" 
#require "sddodbc" 
  
#include "simpleio.ch" 
#include "dbinfo.ch" 
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

PROCEDURE Main() 
  
  local _vmp_usl := {;
    {'SHIFR',    'C',     10,      0},;
    {'HVID',     'C',     12,      0},;
    {'HMETHOD',  'N',      4,      0},;
    {'MODEL',    'N',      5,      0},;
    {'DIAGNOZIS','C',    700,      0};
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( "SQLBASE" ) 
    rddRegister( "SQLMIX" ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate("_mo1vmp_usl",_vmp_usl)
  dbUseArea( .t.,, "_mo1vmp_usl", 'MO1VMP', .f., .f. )
  MO1VMP->(dbGoTop())

  Set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
  HB_SETCODEPAGE( "RU1251" ) 
  
  rddSetDefault( "SQLMIX" ) 
  ? "Connect:", rddInfo( RDDI_CONNECT, { "ODBC", "Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST.XLS;" } ) 
  ? "Use:", dbUseArea( .T., , "select * from [111$] ", "VMP" ) 
  ? "Alias:", Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  VMP->(dbGoTop())
  VMP->(dbSkip())
  while (VMP->(fieldget(1))) != nil //(eof())
    MO1VMP->(dbAppend())
    MO1VMP->SHIFR := VMP->(fieldget(1))
    if VMP->(fieldget(7)) != nil
      MO1VMP->HVID := hb_ValToStr(VMP->(fieldget(7)))
    endif
    MO1VMP->HMETHOD := VMP->(fieldget(9))
    if VMP->(fieldget(10)) != nil
      MO1VMP->MODEL := val(alltrim(VMP->(fieldget(10))))
    endif
    MO1VMP->DIAGNOZIS := VMP->(fieldget(12))

    VMP->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  // dbGoTop() 
  // Browse() 
  VMP->(dbCloseArea())
  MO1VMP->(dbCloseArea())
  
  RETURN