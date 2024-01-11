#include 'directry.ch'
// #include 'function.ch'

#require 'hbsqlit3'

// #define TRACE

// 11.01.24
procedure main( ... )

  local nameDB
  local lCreateIfNotExist := .t.
//  local oConn, oMeta, oStmt, oRs
//  local cSql

  local db  // , aTable,   // , ni  , nJ  //, stmt

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


  nameDB := 'test_mo.db'

//    ? "Excecuting query"
 
//    oRs := oStmt:executeQuery( "SELECT * FROM sqlite_master where type='table'" )
 
//    ? "Showing results"
 

    db := sqlite3_open(nameDB, lCreateIfNotExist)
  
    if ! Empty( db )
      #ifdef TRACE
           sqlite3_profile(db, .t.) // включим профайлер
           sqlite3_trace(db, .t.)   // включим трассировщик
      #endif
  
//      sqlite3_exec(db, 'PRAGMA auto_vacuum=0')
//      sqlite3_exec(db, 'PRAGMA page_size=4096')
//      sqlite3_exec( db, 'PRAGMA user_version = 1000' )      
//      make_table( db )
//    aTable := 
    getTablesSQL( db )
//    ? hb_ValToExp( aTable )

//    aTable := sqlite3_get_table( db, "SELECT * FROM sqlite_master where type='table'" )

//      ?aTable[ 1 ]
//    FOR nI := 1 TO Len( aTable )
//      ? hb_ValToExp( aTable[ nI ] )
//      FOR nJ := 1 TO Len( aTable[ nI ] )
//        ?? aTable[ nI ][ nJ ], " "
//      NEXT
//      ?
//    NEXT
    db := nil
    endif

//    db := sqlite3_open( nameDB, .f. )

//    if ! empty( db )
//      aTable := sqlite3_get_table( db, 'SELECT * FROM pragma_user_version' )
    //    stmt := sqlite3_prepare( db, 'SELECT user_version FROM pragma_user_version' )
    
//          ??'Вывод: '
    //      ? sqlite3_column_name( stmt, 1 )
    //      ? sqlite3_column_decltype( stmt, 1 )
//          ?Len( aTable )
    //      OutStd( hb_eol() )
          
    //      if len(aTable) > 1
    //        for nI := 1 to Len( aTable )
    //          aadd( _arr, { alltrim( aTable[ nI, 1 ] ), alltrim( aTable[ nI, 2 ] ) } )
    //          OutStd( alltrim( aTable[ nI, 1 ] ) + hb_eol())
    //        next
    //      endif
    //      altd()
//    endif
//    db := nil
  
  return

// 11.01.23
function getTablesSQL( db )
//  local aTable
  local stmt, nI, nJ, nCCount, nCType
  LOCAL aCType :=  { "SQLITE_INTEGER", "SQLITE_FLOAT", "SQLITE_TEXT", "SQLITE_BLOB", "SQLITE_NULL" }
  local aRet := {}

//  aTable := sqlite3_get_table( db, "SELECT type, name, tbl_name, rootpage, sql FROM sqlite_master where type='table'" )
//  for nI := 2 TO Len( aTable )
//    aRet := AAdd( aRet, { aTable[ nI, 1 ], aTable[ nI, 2 ], aTable[ nI, 3 ], aTable[ nI, 4 ], aTable[ nI, 5 ] } )
//  next
  stmt := sqlite3_prepare( db, "SELECT type, name, tbl_name, rootpage, sql FROM sqlite_master where type=?1" )
  sqlite3_bind_text( stmt, 1, 'table' )
  nJ := 0
  DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
     nCCount := sqlite3_column_count( stmt )
     ++nJ
     ? 'Record # ' + Str( nJ )

     IF nCCount > 0
        FOR nI := 1 TO nCCount
           nCType := sqlite3_column_type( stmt, nI )
           ? 'Column name : ' + sqlite3_column_name( stmt, nI )
           ? 'Column type : ' + aCType[ nCType ]
           ? 'Column value: '
           if nCType == SQLITE_BLOB
            ?? 'BLOB' // sqlite3_column_blob( stmt, nI )
           elseif nCType == SQLITE_INTEGER
            ?? Str( sqlite3_column_int( stmt, nI ) )
          elseif nCType == SQLITE_NULL
            ?? 'NULL'
          elseif nCType == SQLITE_TEXT
            ?? sqlite3_column_text( stmt, nI )
          else
            ?? 'Unknow: ', nCType
          endif
        NEXT
     ENDIF
  ENDDO
  ? 'Total records - ' + Str( nJ )
  return aRet

//function make_table( db )
      
//  local cmdText
      
//  cmdText := 'CREATE TABLE test(id INTEGER, name TEXT)'
      
//  if sqlite3_exec(db, 'DROP TABLE if EXISTS test') == SQLITE_OK
//      OutStd('DROP TABLE test - Ok' + hb_eol())
//  endif
      
//  if sqlite3_exec(db, cmdText) == SQLITE_OK
//      OutStd('CREATE TABLE test - Ok' + hb_eol() )
//  else
//      OutStd('CREATE TABLE test - False' + hb_eol() )
//    return nil
//  endif
      
//  return nil
