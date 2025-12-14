#include 'function.ch'
#include 'mkb_error.ch'

#include 'simpleio.ch'
#include 'dbinfo.ch'

#require 'hbsqlit3'

#require 'rddsql'
#require 'sddodbc'

REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 14.12.25
function make_MKB10K( db, source )

  Local cmdText
  Local nfile, nameRef
  Local mKlass, mSh_b, mSh_e, mName, mKs
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := '_mo_mkbk'
  Local lSave, lastKlass, sName

  cmdText := 'CREATE TABLE mkbk(klass TEXT(5), sh_b TEXT(3), sh_e TEXT(3), name TEXT)'

  nameRef := '_mo_mkbk.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Классификатор категорий МКБ-10', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS mkbk' ) == SQLITE_OK
    OutStd( 'DROP TABLE mkbk - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE mkbk - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE mkbk - False' + hb_eol() )
    Return Nil
  Endif

  lSave := .f.
  lastKlass := ''
  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  Do While !( dbSource )->( Eof() )

    mKlass := AllTrim( ( dbSource )->KLASS )
    sName := hb_StrToUTF8( AllTrim( ( dbSource )->NAME ), 'RU866' )

    if lastKlass == mKlass
      mName += ' ' + sName
      lSave := .t.
    else
      if lSave
        count++
        cmdTextInsert += 'INSERT INTO mkbk(klass, sh_b, sh_e, name) VALUES(' ;
          + "'" + lastKlass + "'," ;
          + "'" + mSh_b + "'," ;
          + "'" + mSh_e + "'," ;
          + "'" + mName + "');"
//          + str( mKs ) + ");"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
        lSave := .f.
      endif
      mName := sName
      mSh_b := AllTrim( ( dbSource )->SH_B )
      mSh_e := AllTrim( ( dbSource )->SH_E )
      mKs := ( dbSource )->KS
      lastKlass := mKlass
      lSave := .t.
    endif
    ( dbSource )->( dbSkip() )
  End Do
  If count > 0
    if lSave
      count++
      cmdTextInsert += 'INSERT INTO mkbk(klass, sh_b, sh_e, name) VALUES(' ;
        + "'" + lastKlass + "'," ;
        + "'" + mSh_b + "'," ;
        + "'" + mSh_e + "'," ;
        + "'" + mName + "');"
//        + str( mKs ) + ");"
      If count == COMMIT_COUNT
        cmdTextInsert += textCommitTrans
        sqlite3_exec( db, cmdTextInsert )
        count := 0
        cmdTextInsert := textBeginTrans
      Endif
    endif
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  ( dbSource )->( dbCloseArea() )
  out_obrabotka_eol()

  return nil

// 14.12.25
function make_MKB10G( db, source )

  Local cmdText
  Local nfile, nameRef
  Local mSh_b, mSh_e, mName, sName
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := '_mo_mkbg'
  local lastShifr, lastShifr_e
  local lSave

  cmdText := 'CREATE TABLE mkbg(sh_b TEXT(3), sh_e TEXT(3), name TEXT(65))'

  nameRef := '_mo_mkbg.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Классификатор групп МКБ-10', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS mkbg' ) == SQLITE_OK
    OutStd( 'DROP TABLE mkbg - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE mkbg - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE mkbg - False' + hb_eol() )
    Return Nil
  Endif

  lastShifr := ''
  lastShifr_e := ''
  lSave := .f.
  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  ( dbSource )->( dbGoTop() )
  Do While !( dbSource )->( Eof() )

    mSh_b := AllTrim( ( dbSource )->SH_B )
    mSh_e := AllTrim( ( dbSource )->SH_E )
    sName := hb_StrToUTF8( AllTrim( ( dbSource )->NAME ), 'RU866' )
    if lastShifr == mSh_b
      mName += ' ' + sName
      lSave := .t.
    else
      if lSave
        count++
        cmdTextInsert += 'INSERT INTO mkbg(sh_b, sh_e, name) VALUES(' ;
          + "'" + lastShifr + "'," ;
          + "'" + lastShifr_e + "'," ;
          + "'" + mName + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
        lSave := .f.
      endif
      mName := sName
      lastShifr := mSh_b
      lSave := .t.
      lastShifr_e := mSh_e
    endif
    ( dbSource )->( dbSkip() )
  End Do
  If count > 0
    if lSave
      count++
      cmdTextInsert += 'INSERT INTO mkbg(sh_b, sh_e, name) VALUES(' ;
        + "'" + lastShifr + "'," ;
        + "'" + lastShifr_e + "'," ;
        + "'" + mName + "');"
      If count == COMMIT_COUNT
        cmdTextInsert += textCommitTrans
        sqlite3_exec( db, cmdTextInsert )
        count := 0
        cmdTextInsert := textBeginTrans
      Endif
    endif
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  ( dbSource )->( dbCloseArea() )
  out_obrabotka_eol()

  return nil

// 14.12.25
function make_MKB10( db, source )

  Local cmdText
  Local nfile, nameRef
  Local mShifr, mName, mPol, sName
  local mBegin_d, mEnd_d, mBegin, mEnd
  local lastShifr
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := '_mo_mkb'
  Local lSave

  cmdText := 'CREATE TABLE mkb(shifr TEXT(6), name TEXT, POL TEXT(1), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := '_mo_mkb.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Классификатор МКБ-10', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS mkb' ) == SQLITE_OK
    OutStd( 'DROP TABLE mkb - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE mkb - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE mkb - False' + hb_eol() )
    Return Nil
  Endif

  lastShifr := ''
  lSave := .f.
  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  Do While !( dbSource )->( Eof() )

    mShifr := AllTrim( ( dbSource )->SHIFR )
    sName := hb_StrToUTF8( StrTran( AllTrim( ( dbSource )->NAME ), "'", '"' ), 'RU866' )

    if lastShifr == mShifr
      mName += ' ' + sName
//      ( dbSource )->( dbSkip() )
//      loop
    else
      if lSave
        count++
        cmdTextInsert += 'INSERT INTO mkb( shifr, name, pol, datebeg, dateend ) VALUES(' ;
          + "'" + lastShifr + "'," ;
          + "'" + mName + "'," ;
          + "'" + mPol + "'," ;
          + "'" + mBegin + "'," ;
          + "'" + mEnd + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
        lSave := .f.
      endif

      lSave := .t.
      mName := sName
      mPol := hb_StrToUTF8( AllTrim( ( dbSource )->POL ), 'RU866' )

      Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
      mBegin_d := ( dbSource )->DBEGIN
      mEnd_d := ( dbSource )->DEND
      Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
      mBegin := hb_ValToStr( mBegin_d )
      mEnd := hb_ValToStr( mEnd_d )

      lastShifr := mShifr
    endif

    ( dbSource )->( dbSkip() )
  End Do
  If count > 0
    if lSave
        count++
        cmdTextInsert += 'INSERT INTO mkb( shifr, name, pol, datebeg, dateend ) VALUES(' ;
          + "'" + lastShifr + "'," ;
          + "'" + mName + "'," ;
          + "'" + mPol + "'," ;
          + "'" + mBegin + "'," ;
          + "'" + mEnd + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
    endif

    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  ( dbSource )->( dbCloseArea() )
  out_obrabotka_eol()

  return nil