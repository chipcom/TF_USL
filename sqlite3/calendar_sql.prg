#include 'function.ch'
#include 'dict_error.ch'

REQUEST FCOMMA

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 26.02.25
Function db_holiday( db, source )

  // Календарь выходных и праздничных дней

  Local cmdText
  Local k, i
  Local mYear, mMonth, mHoliday
  Local mArr, nameView, nameRef, nfile
  Local count := 0, cmdTextInsert := textBeginTrans
  local aYear := {}

  nameRef := 'holiday.csv'
  nfile := source + nameRef

  cmdText := 'CREATE TABLE calendar( m_year INTEGER, m_month INTEGER, description TEXT )'

  out_utf8_to_str( 'Список выходных и праздников', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS calendar' ) == SQLITE_OK
    OutStd( 'DROP TABLE calendar - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE calendar - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE calendar - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., 'FCOMMA', nfile, , .f., .f. )
  dbGoTop()
  DO WHILE ! Eof()
    mArr := split( FIELD->LINE, ',' )
    mYear := val( mArr[ 1 ] )
    if ( AScan( aYear, mYear ) ) == 0
       AAdd( aYear, mYear )
    endif
    mMonth := AllTrim( mArr[ 2 ] )
    mHoliday := AllTrim( mArr[ 3 ] )
    count++
    cmdTextInsert += "INSERT INTO calendar (m_year, m_month, description ) VALUES(" ;
      + "'" + mArr[ 1 ] + "'," ;
      + "'" + mMonth + "'," ;
      + "'" + strTran( mHoliday, '; ', ',' ) + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
    dbSkip()
  enddo

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  for k := 1 to Len( aYear )
    mYear := str( aYear[ k ], 4 )
    nameView := 'year' + mYear
    If sqlite3_exec( db, 'DROP VIEW if EXISTS ' + nameView ) == SQLITE_OK
      OutStd( 'DROP VIEW ' + nameView + ' - Ok' + hb_eol() )
    Endif
    cmdText := 'CREATE VIEW ' + nameView + ' AS SELECT m_month, description FROM calendar WHERE m_year=' + mYear + ';'
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( 'CREATE VIEW ' + nameView + ' - Ok' + hb_eol() )
    Else
      OutStd( 'CREATE VIEW ' + nameView + ' - False' + hb_eol() )
      Return Nil
    Endif
  next
  out_obrabotka_eol()
  Return Nil
