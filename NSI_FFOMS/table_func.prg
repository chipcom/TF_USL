// Справочники федерального фонда медицинского страхования РФ типа N0xx

#include 'nsi_ffoms.ch'
#include 'common.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 12.08.25
function Update_row( db, code, hStruct )

  Local cmdText
  Local st
  Local user_version, last_update

  code := AllTrim( lower( code ) )
  user_version := AllTrim( hStruct[ "user_version" ] )
  last_update := AllTrim( SubStr( hStruct[ "last_update" ], 1, 10 ) )
  cmdText := 'UPDATE checking SET version="' + user_version + '", last_update="' + last_update + '" WHERE code="' + code + '"'

  If !( sqlite3_exec( db, cmdText ) == SQLITE_OK )
    st := hb_Utf8ToStr( 'Ошибка обновления для справочника ' + code, 'RU866' )	
    OutStd( hb_eol() + st + hb_eol() )
  endif
  return nil

// 12.08.25
function checking_file( db, download )

  Local aChecking, aGeneral, i
  Local code, version, last_update, j
  Local hStruct

  aChecking := get_checking( db )
  aGeneral := get_general( db )

  for i := 1 to Len( aChecking )
    code := aChecking[ i, 1 ]
    version := AllTrim( aChecking[ i, 2 ] )
    last_update := aChecking[ i, 3 ]
    If ( j := AScan( aGeneral, {| x | Upper( x[ 1 ] ) == Upper( code ) } ) ) > 0
      if compare_version( AllTrim( aGeneral[ j, 3 ] ), version )

        hStruct := FindDictionary( Upper( code ) )
        GetFile( hStruct, download )
        Update_row( db, code, hStruct )

      endif
    endif
  next
  return nil

// 13.06.25 вернуть массив
Function get_general( db )

  Local _arr
  Local aTable
  Local nI

  _arr := {}
  aTable := sqlite3_get_table( db, 'SELECT ' + ;
      'code, ' + ;
      'name, ' + ;
      'version, ' + ;
      'last_update ' + ;
      'FROM general' )
  If Len( aTable ) > 1
    For nI := 2 To Len( aTable )
      AAdd( _arr, { AllTrim( aTable[ nI, 1 ] ), AllTrim( aTable[ nI, 2 ] ), AllTrim( aTable[ nI, 3 ] ), AllTrim( aTable[ nI, 4 ] ) } )
    Next
  Endif
  Return _arr

// 13.06.25 вернуть массив
Function get_checking( db )

  // возвращает массив checking требуемых для проверки загрузки файлов
  Local _arr
  Local aTable
  Local nI

  _arr := {}
  aTable := sqlite3_get_table( db, 'SELECT ' + ;
      'code, ' + ;
      'version, ' + ;
      'last_update ' + ;
      'FROM checking' )
  If Len( aTable ) > 1
    For nI := 2 To Len( aTable )
      AAdd( _arr, { AllTrim( aTable[ nI, 1 ] ), AllTrim( aTable[ nI, 2 ] ), AllTrim( aTable[ nI, 2 ] ) } )
    Next
  Endif
  Return _arr

function init_db( destination )

  Local db
  Local nameDB
  Local lCreateIfNotExist := .t.
  Local st

  nameDB := destination + SQL_DB_NAME
  If ! hb_vfExists( nameDB )
    st := hb_Utf8ToStr( 'Создание файла: ' + nameDB, 'RU866' )	
    OutStd( hb_eol() + st + hb_eol() )
  Endif

  db := sqlite3_open( nameDB, lCreateIfNotExist )

  if ! exists_table( db, 'general' )
    if ! tbl_general( db )
      st := hb_Utf8ToStr( 'Ошибка создания таблицы general в файле: ' + nameDB, 'RU866' )	
      OutStd( hb_eol() + st + hb_eol() )
      return nil
    Endif
  endif
  if ! exists_table( db, 'checking' )
    if ! tbl_checking( db )
      st := hb_Utf8ToStr( 'Ошибка создания таблицы checking в файле: ' + nameDB, 'RU866' )	
      OutStd( hb_eol() + st + hb_eol() )
      return nil
    endif
  endif
  return db

// 13.04.25
Function create_table( db, table, cmdText )

  // db - дескриптор SQL БД
  // table - имя таблицы вида name.xml
  // cmdText - строка команды SQL для создания таблицы SQL БД
  Local ret := .f.

  table := clear_name_table( table )

//  drop_table( db, table )
  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE ' + table + ' - Ok', hb_eol() )
    ret := .t.
  Else
    OutStd( 'CREATE TABLE ' + table + ' - False', hb_eol() )
  Endif
  Return ret

// 13.04.25
Function drop_table( db, table )

  // db - дескриптор SQL БД
  // table - имя таблицы SQL БД
  Local cmdText

  cmdText := 'DROP TABLE if EXISTS ' + table

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'DROP TABLE ' + table + ' - Ok', hb_eol() )
  Endif

  Return Nil

function exists_table( db, tbl_name )

  local aTable

  tbl_name := lower( AllTrim( tbl_name ) )
  aTable := sqlite3_get_table( db, 'SELECT * ' + ;
    'FROM sqlite_master WHERE type="table" and tbl_name="' + tbl_name + '"' )
  if len( aTable ) == 1 .or. HB_ISNIL( aTable )
    return .f.
  Endif
  return .t.

function tbl_general( db )

  Local hTable, row
  Local cmdText
  Local st
  Local count := 0, cmdTextInsert := textBeginTrans
  Local fullName, code, user_version, last_update

  cmdText := 'CREATE TABLE general( code TEXT(4), name TEXT, version TEXT(10), last_update TEXT(10))'
  st := hb_Utf8ToStr( 'Создание таблицы: "general"', 'RU866' )	
  OutStd( hb_eol() + st + hb_eol() )
  create_table( db, 'general', cmdText )
  hTable := GetDictionaryListFFOMS()
  for each row in hTable
    fullName := row[ "fullName" ]
    code := row[ "d" ][ "code" ]
    user_version := row[ "user_version" ]
    last_update := SubStr( row[ "last_update" ], 1, 10 )

    count++
    cmdTextInsert += 'INSERT INTO general(code, name, version, last_update) VALUES(' ;
      + "'" + code + "'," ;
      + "'" + fullName + "'," ;
      + "'" + user_version + "'," ;
      + "'" + last_update + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      If ! ( sqlite3_exec( db, cmdTextInsert ) == SQLITE_OK )
        return .f.
      endif
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  next
  If count > 0
    cmdTextInsert += textCommitTrans
    If ! ( sqlite3_exec( db, cmdTextInsert ) == SQLITE_OK )
      return .f.
    endif
  Endif
  return .t.

function tbl_checking( db )

  Local row
  Local cmdText
  Local st
  Local count := 0, cmdTextInsert := textBeginTrans
  
  cmdText := 'CREATE TABLE checking( code TEXT(4), version TEXT(10), last_update TEXT(10))'
  st := hb_Utf8ToStr( 'Создание таблицы: "checking"', 'RU866' )	
  OutStd( hb_eol() + st + hb_eol() )
  create_table( db, 'checking', cmdText )
  for each row in arrReference()
    count++
    cmdTextInsert += 'INSERT INTO checking(code) VALUES(' ;
      + "'" + row + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      If ! ( sqlite3_exec( db, cmdTextInsert ) == SQLITE_OK )
        return .f.
      endif
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  next
  If count > 0
    cmdTextInsert += textCommitTrans
    If ! ( sqlite3_exec( db, cmdTextInsert ) == SQLITE_OK )
      return .f.
    endif
  Endif
  return .t.