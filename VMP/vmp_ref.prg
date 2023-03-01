#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

PROCEDURE Main() 
  
  local _vmp_usl := {;
    {'SHIFR',    'C',     10,      0},;
    {'HVID',     'C',     12,      0},;
    {'HMETHOD',  'N',      4,      0},;
    {'MODEL',    'N',      5,      0},;
    {'DIAGNOZIS','M',     10,      0},;
    {'DATEBEG',  'D',      8,      0},;
    {'DATEEND',  'D',      8,      0};
  }

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 
  
  dbcreate('_mo3vmp_usl', _vmp_usl)
  dbUseArea( .t.,, '_mo3vmp_usl', 'MO3VMP', .f., .f. )
  MO3VMP->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST23.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'VMP') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  VMP->(dbGoTop())
  // VMP->(dbSkip())
  while !empty((VMP->(fieldget(1)))) // != nil //(eof())
    MO3VMP->(dbAppend())
    MO3VMP->SHIFR := VMP->(fieldget(1))
    // if VMP->(fieldget(7)) != nil
    if VMP->(fieldget(6)) != nil
      // MO3VMP->HVID := hb_ValToStr(VMP->(fieldget(7)))
      MO3VMP->HVID := alltrim(Str(VMP->(fieldget(6)), 12))
    endif
    // MO3VMP->HMETHOD := VMP->(fieldget(9))
    MO3VMP->HMETHOD := VMP->(fieldget(8))
    // if VMP->(fieldget(10)) != nil
    if VMP->(fieldget(11)) != nil
      // MO3VMP->MODEL := val(alltrim(VMP->(fieldget(10))))
      MO3VMP->MODEL := VMP->(fieldget(11))
    endif
    // MO3VMP->DIAGNOZIS := VMP->(fieldget(12))
    MO3VMP->DIAGNOZIS := StrTran(VMP->(fieldget(10)), ', ', ';')
    MO3VMP->DATEBEG := VMP->(fieldget(13))
    MO3VMP->DATEEND := VMP->(fieldget(14))

    VMP->(dbSkip())
  end

  // , доступ к полям через fieldget( n )

  // dbGoTop() 
  // Browse() 
  VMP->(dbCloseArea())
  MO3VMP->(dbCloseArea())
  
  RETURN