#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 06.05.22
Function make_f0xx( db, source )

  make_f006( db, source )
  make_f010( db, source )
  make_f011( db, source )
  make_f014( db, source )

  Return Nil

// 01.09.23
Function make_f006( db, source )

  // IDVID,       "N",      2,      0  // Код вида контроля
  // VIDNAME,     "C",    350,      0  // Наименование вида контроля
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt, stmtTMP
  Local cmdText, cmdTextTMP
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDVID, mVidname, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f006(idvid INTEGER, vidname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F006.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    OutStd( hb_eol() + nameRef + ' - Классификатор видов контроля (VidExp)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f006' ) == SQLITE_OK
    OutStd( 'DROP TABLE f006 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f006 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f006 - False' + hb_eol() )
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
        mIDVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDVID' )
        mVidname := read_xml_stroke_1251_to_utf8( oXmlNode, 'VIDNAME' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f006(idvid, vidname, datebeg, dateend) VALUES(' ;
          + "" + AllTrim( Str( Val( mIDVID ) ) ) + "," ;
          + "'" + mVidname + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
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

// 01.09.23
Function make_f010( db, source )

  // KOD_TF,       "C",      2,      0  // Код ТФОМС
  // KOD_OKATO,     "C",    5,      0  // Код по ОКАТО (Приложение А O002).
  // SUBNAME,     "C",    254,      0  // Наименование субъекта РФ
  // OKRUG,     "N",        1,      0  // Код федерального округа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt, stmtTMP
  Local cmdText, cmdTextTMP
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mKOD_TF, mKOD_OKATO, mSubname, mOkrug, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f010(kod_tf TEXT(2), kod_okato TEXT(5), subname TEXT, okrug INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F010.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    OutStd( hb_eol() + nameRef + ' - Классификатор субъектов Российской Федерации (Subekti)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f010' ) == SQLITE_OK
    OutStd( 'DROP TABLE f010 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f010 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f010 - False' + hb_eol() )
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
        mKOD_TF := read_xml_stroke_1251_to_utf8( oXmlNode, 'KOD_TF' )
        mKOD_OKATO := read_xml_stroke_1251_to_utf8( oXmlNode, 'KOD_OKATO' )
        mSubname := read_xml_stroke_1251_to_utf8( oXmlNode, 'SUBNAME' )
        mOkrug := read_xml_stroke_1251_to_utf8( oXmlNode, 'OKRUG' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f010(kod_tf, kod_okato, subname, okrug, datebeg, dateend) VALUES(' ;
          + "'" + mKOD_TF + "'," ;
          + "'" + mKOD_OKATO + "'," ;
          + "'" + mSubname + "'," ;
          + "" + AllTrim( Str( Val( mOkrug ) ) ) + "," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
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

// 01.09.23
Function make_f011( db, source )

  // IDDoc,       "C",      2,      0  // Код типа документа
  // DocName,     "C",    254,      0  // Наименование типа документа
  // DocSer,     "C",    10,      0  // Маска серии документа
  // DocNum,     "C",      20,      0  // Маска номера документа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt, stmtTMP
  Local cmdText, cmdTextTMP
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDDoc, mDocName, mDocSer, mDocNum, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f011(iddoc TEXT(2), docname TEXT, docser TEXT(10), docnum TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F011.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    OutStd( hb_eol() + nameRef + ' - Классификатор типов документов, удостоверяющих личность (Tipdoc)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f011' ) == SQLITE_OK
    OutStd( 'DROP TABLE f011 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f011 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f011 - False' + hb_eol() )
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
        mIDDoc := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDDoc' )
        mDocName := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocName' )
        mDocSer := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocSer' )
        mDocNum := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocNum' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f011(iddoc, docname, docser, docnum, datebeg, dateend) VALUES(' ;
          + "'" + mIDDoc + "'," ;
          + "'" + mDocName + "'," ;
          + "'" + mDocSer + "'," ;
          + "'" + mDocNum + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
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

// 01.09.23
Function make_f014( db, source )

  // Kod,       "N",      3,      0  // Код ошибки
  // IDVID,     "N",    1,      0  // Код вида контроля, резервное поле
  // Naim,     "C",    1000,      0  // Наименование причины отказа
  // Osn,     "C",      20,      0  // Основание отказа
  // Komment,     "C",      100,      0  // Служебный комментарий
  // KodPG,     "C",      20,      0  // Код по форме N ПГ
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt, stmtTMP
  Local cmdText, cmdTextTMP
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mKod, mIDVID, mNaim, mOsn, mKomment, mKodPG, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f014(kod INTEGER, idvid INTEGER, naim BLOB, osn TEXT(20), komment BLOB, kodpg TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F014.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    OutStd( hb_eol() + nameRef + ' - Классификатор причин отказа в оплате медицинской помощи (OplOtk)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f014' ) == SQLITE_OK
    OutStd( 'DROP TABLE f014 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f014 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f014 - False' + hb_eol() )
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
        mKod := read_xml_stroke_1251_to_utf8( oXmlNode, 'Kod' )
        mIDVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDVID' )
        mNaim := read_xml_stroke_1251_to_utf8( oXmlNode, 'Naim' )
        mOsn := read_xml_stroke_1251_to_utf8( oXmlNode, 'Osn' )
        mKomment := read_xml_stroke_1251_to_utf8( oXmlNode, 'Komment' )
        mKodPG := read_xml_stroke_1251_to_utf8( oXmlNode, 'KodPG' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f014(kod, idvid, naim, osn, komment, kodpg, datebeg, dateend) VALUES(' ;
          + "" + AllTrim( Str( Val( mKod ) ) ) + "," ;
          + "" + AllTrim( Str( Val( mIDVID ) ) ) + "," ;
          + "'" + mNaim + "'," ;
          + "'" + mOsn + "'," ;
          + "'" + mKomment + "'," ;
          + "'" + mKodPG + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
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
