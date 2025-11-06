
#require 'rddsql'
#require 'sddodbc'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
//  http://clipper.borda.ru/?1-4-0-00001115-000-10001-0-1606795293  

// 06.11.25
proc main()

  local dbName := '_mo_mkb'
  local dbeg, dend
  local adbf

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT( 'RU866' )
  REQUEST HB_LANG_RU866
  HB_LANGSELECT( 'RU866' )

  REQUEST DBFNTX
  RDDSETDEFAULT( 'DBFNTX' )

  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON
  setblink(.f.)

  adbf := { ;
    { 'MKB',    'C', 6, 0 } ,;
    { 'DBEGIN', 'D', 8, 0 }, ;
    { 'DEND',   'D', 8, 0 } ;
  }

  dbcreate( '_tmp_mkb', adbf )
  dbUseArea( .t.,, '_tmp_mkb', 'TMP', .t., .f. )

  dbUseArea( .t.,, dbName, 'MKB', .t., .f. )
  index on FIELD->SHIFR to ( dbName )

//  Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
//  HB_SETCODEPAGE( 'RU1251' ) 
  
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=book_MKB.XLS;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', 'TFOMS') 
  ? 'Alias:', Alias() 

  TFOMS->(dbGoTop())
  while !empty( ( TFOMS->( fieldget( 1 ) ) ) ) // != nil //(eof())
    dbeg := CToD( '' )
    dend := CToD( '' )
    TMP->( dbAppend() )
    TMP->MKB    := TFOMS->( fieldget( 1 ) )
    TMP->DBEGIN := CToD( TFOMS->( fieldget( 3 ) ) )
    TMP->DEND   := CToD( TFOMS->( fieldget( 4 ) ) )
    TFOMS->( dbSkip() )
  end

  TMP->( dbGoTop() )
  while ! TMP->( eof() )
    MKB->( dbSeek( PadR( TMP->MKB, 6 ) ) )
    if MKB->( Found() )
      MKB->( dbRLock() )
      MKB->DBEGIN := TMP->DBEGIN
      MKB->DEND   := TMP->DEND
      MKB->( dbUnlock() )
    endif
    TMP->( dbSkip() )
  end do
  TMP->( dbCloseArea() )
  TFOMS->( dbCloseArea() )
  MKB->( dbCloseArea() )
  hb_vfErase( '_tmp_mkb.dbf' )
  return
