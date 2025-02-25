#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 20.02.25
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
  
  dbcreate('_mo5vmp_usl', _vmp_usl)
  dbUseArea( .t.,, '_mo5vmp_usl', 'MO5VMP', .f., .f. )
  MO5VMP->(dbGoTop())

  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=VMP25.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'VMP') 
  ? 'Alias:', Alias() 
  // ? "DB struct:", hb_ValToExp( dbStruct() ) 
  // wait 

  VMP->(dbGoTop())
  VMP->(dbSkip())
  while !empty((VMP->(fieldget(1)))) // != nil //(eof())
    MO5VMP->(dbAppend())
    MO5VMP->SHIFR := VMP->(fieldget(1))
    // if VMP->(fieldget(7)) != nil
    if VMP->(fieldget(6)) != nil
      // MO5VMP->HVID := hb_ValToStr(VMP->(fieldget(7)))
      MO5VMP->HVID := alltrim(Str(VMP->(fieldget(6)), 12))
    endif
    // MO5VMP->HMETHOD := VMP->(fieldget(9))
    MO5VMP->HMETHOD := VMP->(fieldget(8))
    // if VMP->(fieldget(10)) != nil
    if VMP->(fieldget(11)) != nil
      // MO5VMP->MODEL := val(alltrim(VMP->(fieldget(10))))
      MO5VMP->MODEL := VMP->(fieldget(11))
    endif
    // MO5VMP->DIAGNOZIS := VMP->(fieldget(12))
    MO5VMP->DIAGNOZIS := StrTran(VMP->(fieldget(10)), ', ', ';')
    MO5VMP->DATEBEG := VMP->(fieldget(13))
    MO5VMP->DATEEND := VMP->(fieldget(14))

    VMP->(dbSkip())
  end

  // , ����� � ���� �१ fieldget( n )

  // dbGoTop() 
  // Browse() 
  VMP->(dbCloseArea())
  MO5VMP->(dbCloseArea())
  
  RETURN