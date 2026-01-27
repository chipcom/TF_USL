#include 'hbsqlit3.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 11.05.22
Function make_o0xx( db, source )

  make_o001( db, source )

  Return Nil

// 29.08.23
Function make_o001( db, source )

  // KOD,     "C",    3,      0
  // NAME11,  "C",  250,      0
  // NAME12", "C",  250,      0
  // ALFA2,   "C",    2,      0
  // ALFA3,   "C",    3,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mKod, mName11, mName12, mAlfa2, mAlfa3, d1, d2, d1_1
  Local mArr

  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE o001(kod TEXT(3), name11 TEXT, name12 TEXT, alfa2 TEXT(2), alfa3 TEXT(3))'

  nameRef := 'O001.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Общероссийский классификатор стран мира (OKSM)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS o001' ) == SQLITE_OK
    OutStd( 'DROP TABLE o001 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE o001 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE o001 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    For j := 1 To k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ZAP' == Upper( oXmlNode:title )
        d1 := ''
        d1_1 := ''
        d2 := ''
        mKod := read_xml_stroke_1251_to_utf8( oXmlNode, 'KOD' )
        mArr := hb_ATokens( read_xml_stroke_1251_to_utf8( oXmlNode, 'NAME11' ), '^' )
        If Len( mArr ) == 1
          mName11 := mArr[ 1 ]
          mName12 := ''
        Else
          mName11 := mArr[ 1 ]
          mName12 := mArr[ 2 ]
        Endif
        mAlfa2 := read_xml_stroke_1251_to_utf8( oXmlNode, 'ALFA2' )
        mAlfa3 := read_xml_stroke_1251_to_utf8( oXmlNode, 'ALFA3' )

        count++
        cmdTextInsert += 'INSERT INTO o001 (kod, name11, name12, alfa2, alfa3) VALUES(' ;
          + "'" + mKod + "'," ;
          + "'" + mName11 + "'," ;
          + "'" + mName12 + "'," ;
          + "'" + mAlfa2 + "'," ;
          + "'" + mAlfa3 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()

  Return Nil
