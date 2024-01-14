#include 'hbgtinfo.ch'
#include 'hbgtwvg.ch'
#include 'directry.ch'
// #include 'function.ch'

#require 'hbsqlit3'

// #define TRACE
#define _NUMROWS_ 10

// 14.01.24
procedure main( ... )

  local nameDB
  local lCreateIfNotExist := .t.
  local db, ar

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866
  HB_CDPSELECT('UTF8')
  // HB_LANGSELECT('RU866')
  // REQUEST DBFNTX
  // RDDSETDEFAULT('DBFNTX')
  SET DATE GERMAN
  SET CENTURY ON

  Announce HB_GTSYS
  Request HB_GT_WVT
  Request HB_GT_WVT_DEFAULT
  // запретить закрытие окна (крестиком и по Alt+F4)
  hb_gtInfo( HB_GTI_CLOSABLE, .f. ) // для GT_WVT
  // hb_gtInfo(HB_GTI_CLOSEMODE, 2 ) // для GT_WVG
  // Определить сразу окно 25*80 символов, иначе нужна дополнительная настройка
  SetMode( 25, 80 )
  
  OutStd(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol() + hb_eol())


  nameDB := 'test_db.db'
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

    ar := getTablesSQL( db )
    OutStd(hb_eol() + hb_ValToExp( ar ) )
//  stmt := sqlite3_prepare( db, 'SELECT user_version FROM pragma_user_version' )

    db := nil
  endif
    
  return

// 14.01.23
function getTablesSQL( db )
  local stmt
  local aRet := {}

  stmt := sqlite3_prepare( db, "SELECT type, name, tbl_name, rootpage, sql FROM sqlite_master where type=:type" )
  sqlite3_bind_text( stmt, 1, 'table' )
  DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
    AAdd( aRet, {sqlite3_column_text( stmt, 1 ), sqlite3_column_text( stmt, 2 ), sqlite3_column_text( stmt, 3 ), sqlite3_column_int( stmt, 4 ), sqlite3_column_text( stmt, 5 ) } )
  ENDDO
  return aRet

// 14.01.24
function make_table( db )
      
  local cSql, n, cName
      
  cSql := "CREATE TABLE tst("
  cSql += "     Code integer not null primary key, "
  cSql += "     dept Integer, "
  cSql += "     Name Varchar (40), "
  cSql += "     Sales boolean, "
  cSql += "     Tax Float4, "
  cSql += "     Salary Double Precision, "
  cSql += "     Budget Numeric (12,2), "
  cSql += "     Discount Numeric (5,2), "
  cSql += "     Creation Date, "
  cSql += "     Description text ) "
     
  if sqlite3_exec(db, 'DROP TABLE if EXISTS tst') == SQLITE_OK
    OutStd('DROP TABLE tst - Ok' + hb_eol())
  endif
      
  if sqlite3_exec(db, cSql) == SQLITE_OK
    OutStd('CREATE TABLE tst - Ok' + hb_eol() )

    FOR n := 1 TO _NUMROWS_
      cSql := "INSERT INTO tst(code, dept, name, sales, tax, salary, budget, Discount, Creation, Description) "
      cSql += "VALUES( " + Str( n ) + ", " + iif( n > 5, "1", "2" ) + ", 'TEST', '" + iif( n % 2 != 0, "y", "n" ) + "', 5, 3000, 1500.2, 7.5, '12-22-2003', 'Short Description ')"

      if sqlite3_exec(db, cSql) == SQLITE_OK
        OutStd('INSERT TABLE tst - Ok' + hb_eol() )
      endif
    NEXT

  else
    OutStd('CREATE TABLE tst - False' + hb_eol() )
  endif
  for n := 1 to 5
    cName := 'test' + alltrim( str(n) )
    OutStd( cName + hb_eol())
    cSql := "CREATE TABLE " + cName + "("
    cSql += "     id integer not null primary key, "
    cSql += "     dept Integer, "
    cSql += "     Name Varchar (40) )"

    if sqlite3_exec(db, 'DROP TABLE if EXISTS ' + cName ) == SQLITE_OK
      OutStd('DROP TABLE ' + cName + ' - Ok' + hb_eol())
    endif
    if sqlite3_exec(db, cSql) == SQLITE_OK
      OutStd('CREATE TABLE ' + cName + ' - Ok' + hb_eol() )
    else
      OutStd('CREATE TABLE ' + cName + ' - False' + hb_eol() )
    endif
      
  next
  return nil
