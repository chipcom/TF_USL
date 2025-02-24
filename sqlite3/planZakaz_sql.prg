#include 'function.ch'
#include 'dict_error.ch'

REQUEST FCOMMA

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 24.02.25
Function db_planzakaz( db, source )

  // Списко план-заказов

  Local cmdText
  Local k //, i
  Local mYear, mId, mCode, mDescription, mShort, mKd  //, mAdd
  Local mArr, nameView, nameRef, nfile
  Local count := 0, cmdTextInsert := textBeginTrans
  local aYear := {}

  nameRef := 'planZakaz.csv'
  nfile := source + nameRef

  cmdText := 'CREATE TABLE planzakaz( m_year INTEGER, id INTEGER, code INTEGER, description TEXT, short TEXT, kd TEXT, add_t TEXT )'

  out_utf8_to_str( 'Список план-заказа', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS planzakaz' ) == SQLITE_OK
    OutStd( 'DROP TABLE planzakaz - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE planzakaz - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE planzakaz - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., 'FCOMMA', nfile, , .f., .f. )
//  USE test.csv VIA "FCOMMA"
  dbGoTop()
  DO WHILE ! Eof()
     mArr := split( FIELD->LINE, ',' )
     mYear := val( mArr[ 1 ] )
     if ( AScan( aYear, mYear ) ) == 0
        AAdd( aYear, mYear )
     endif
     mId := AllTrim( mArr[ 2 ] )
     mCode := AllTrim( mArr[ 3 ] )
     mDescription := AllTrim( mArr[ 4 ] )
     mShort := AllTrim( mArr[ 5 ] )
     mKd := AllTrim( mArr[ 6 ] )
//      mAdd := mArr[ 7 ]
     count++
     cmdTextInsert += "INSERT INTO planzakaz (m_year, id, code, description, short, kd, add_t) VALUES(" ;
       + "'" + mArr[ 1 ] + "'," ;
       + "'" + mId + "'," ;
       + "'" + mCode + "'," ;
       + "'" + mDescription + "'," ;
       + "'" + mShort + "'," ;
       + "'" + mKd + "'," ;
       + "'');"
//      + "'" + mAdd + "');"
     If count == COMMIT_COUNT
       cmdTextInsert += textCommitTrans
       sqlite3_exec( db, cmdTextInsert )
       count := 0
       cmdTextInsert := textBeginTrans
     Endif
    dbSkip()
  ENDDO
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  for k := 1 to Len( aYear )
    mYear := str( aYear[ k ], 4 )
    nameView := 'PZ_year' + mYear
    If sqlite3_exec( db, 'DROP VIEW if EXISTS ' + nameView ) == SQLITE_OK
      OutStd( 'DROP VIEW ' + nameView + ' - Ok' + hb_eol() )
    Endif
    cmdText := 'CREATE VIEW ' + nameView + ' AS SELECT id, code, description, short, kd, add_t FROM planzakaz WHERE m_year=' + mYear + ';'
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( 'CREATE VIEW ' + nameView + ' - Ok' + hb_eol() )
    Else
      OutStd( 'CREATE VIEW ' + nameView + ' - False' + hb_eol() )
      Return Nil
    Endif
  next
  out_obrabotka_eol()
  Return Nil
