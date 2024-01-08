#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

// #define TRACE

// 08.01.24
procedure main( ... )

  local nameDB, db
  local lCreateIfNotExist := .t.
  local aTable, stmt, ni

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866
  HB_CDPSELECT('UTF8')
  // HB_LANGSELECT('RU866')
    
  // REQUEST DBFNTX
  // RDDSETDEFAULT('DBFNTX')
    
  SET DATE GERMAN
  SET CENTURY ON
    
  // SET SCOREBOARD OFF
  // SET EXACT ON
  // SET WRAP ON
  // SET EXCLUSIVE ON
  // SET DELETED ON
  // setblink(.f.)
  // READINSERT(.T.)        // режим редактирования по умолчанию Insert
  // KEYBOARD ''
  // ksetnum(.t.)
  // SETCURSOR(0)
  // SETCLEARB(' ')
  // SET COLOR TO
  
  OutStd(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol() + hb_eol())

    if sqlite3_libversion_number() < 3005001
      return
    endif

    nameDB := 'test_mo.db'
    db := sqlite3_open(nameDB, lCreateIfNotExist)
  
    if ! Empty( db )
      #ifdef TRACE
           sqlite3_profile(db, .t.) // включим профайлер
           sqlite3_trace(db, .t.)   // включим трассировщик
      #endif
  
      sqlite3_exec(db, 'PRAGMA auto_vacuum=0')
      sqlite3_exec(db, 'PRAGMA page_size=4096')
      sqlite3_exec( db, 'PRAGMA user_version = 1000' )      
      make_table( db )
      db := nil
    endif

//    SELECT * FROM pragma_index_info('idx52');

    db := sqlite3_open( nameDB, .f. )

    if ! empty( db )
      aTable := sqlite3_get_table( db, 'SELECT * FROM pragma_user_version' )
    //    stmt := sqlite3_prepare( db, 'SELECT user_version FROM pragma_user_version' )
    
          ??'Вывод: '
    //      ? sqlite3_column_name( stmt, 1 )
    //      ? sqlite3_column_decltype( stmt, 1 )
          ?Len( aTable )
    //      OutStd( hb_eol() )
          
    //      if len(aTable) > 1
    //        for nI := 1 to Len( aTable )
    //          aadd( _arr, { alltrim( aTable[ nI, 1 ] ), alltrim( aTable[ nI, 2 ] ) } )
    //          OutStd( alltrim( aTable[ nI, 1 ] ) + hb_eol())
    //        next
    //      endif
    //      altd()
    endif
    db := nil
  
    return

function make_table( db )
      
  local cmdText
      
  cmdText := 'CREATE TABLE test(id INTEGER, name TEXT)'
      
  if sqlite3_exec(db, 'DROP TABLE if EXISTS test') == SQLITE_OK
      OutStd('DROP TABLE test - Ok' + hb_eol())
  endif
      
  if sqlite3_exec(db, cmdText) == SQLITE_OK
      OutStd('CREATE TABLE test - Ok' + hb_eol() )
  else
      OutStd('CREATE TABLE test - False' + hb_eol() )
    return nil
  endif
      
  return nil
