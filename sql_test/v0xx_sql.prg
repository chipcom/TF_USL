#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 17.01.23
Function make_v0xx( db, source )

  make_v002( db, source )
  make_v004( db, source )

  make_v009( db, source )
  make_v010( db, source )
  make_v012( db, source )
  make_v015( db, source )
  // make_V016(db, source)
  // make_V017(db, source)
  // make_V018(db, source)
  // make_v019( db, source )
  // make_V020(db, source)
  // make_V021(db, source)
  // make_V022(db, source)
  make_v024( db, source )
  // make_V025(db, source)

  // make_V030(db, source)
  // make_V031(db, source)
  // make_V032(db, source)
  // make_V033(db, source)
  make_v036( db, source )

  Return Nil

// 25.12.24
Function make_v009( db, source )

  // IDRMP,     "N",   3, 0  // Код результата обращения
  // RMPNAME,   "C", 254, 0  // Наименование результата обращения
  // DL_USLOV,  "N",   2, 0  // Соответствует условиям оказания медицинской помощи (V006)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDRMP, mRmpname, mDL_USLOV, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v009(idrmp INTEGER, rmpname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V009.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор результатов обращения за медицинской помощью (Rezult)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v009' ) == SQLITE_OK
    OutStd( 'DROP TABLE v009 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v009 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v009 - False' + hb_eol() )
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
        mIDRMP := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDRMP' )
        mRmpname := read_xml_stroke_1251_to_utf8( oXmlNode, 'RMPNAME' )
        mDL_USLOV := read_xml_stroke_1251_to_utf8( oXmlNode, 'DL_USLOV' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        // cmdText := "INSERT INTO v009 (idrmp, rmpname, dl_uslov, datebeg, dateend) VALUES( :idrmp, :rmpname, :dl_uslov, :datebeg, :dateend )"
        cmdTextInsert := cmdTextInsert + "INSERT INTO v009( idrmp, rmpname, dl_uslov, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + mIDRMP + "',"
        cmdTextInsert += "'" + mRmpname + "',"
        cmdTextInsert += "'" + mDL_USLOV + "',"
        cmdTextInsert += "'" + d1 + "',"
        cmdTextInsert += "'" + d2 + "');"
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

// 25.12.24
Function make_v010( db, source )

  // IDSP,       "N",      2,      0  // Код способа оплаты медицинской помощи
  // SPNAME,     "C",    254,      0  // Наименование способа оплаты медицинской помощи
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDSP, mSpname, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v010(idsp INTEGER, spname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V010.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор способов оплаты медицинской помощи (Sposob)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v010' ) == SQLITE_OK
    OutStd( 'DROP TABLE v010 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v010 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v010 - False' + hb_eol() )
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
        mIDSP := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDSP' )
        mSpname := read_xml_stroke_1251_to_utf8( oXmlNode, 'SPNAME' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert := cmdTextInsert + "INSERT INTO v010( idsp, spname, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + mIDSP + "',"
        cmdTextInsert += "'" + mSpname + "',"
        cmdTextInsert += "'" + d1 + "',"
        cmdTextInsert += "'" + d2 + "');"
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

// 25.12.24
Function make_v012( db, source )

  // IDIZ,      "N",   3, 0  // Код исхода заболевания
  // IZNAME,    "C", 254, 0  // Наименование исхода заболевания
  // DL_USLOV,  "N",   2, 0  // Соответствует условиям оказания МП (V006)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDIZ, mIzname, mDL_USLOV, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v012(idiz INTEGER, izname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V012.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор исходов заболевания (Ishod)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v012' ) == SQLITE_OK
    OutStd( 'DROP TABLE v012 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v012 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v012 - False' + hb_eol() )
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
        mIDIZ := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDIZ' )
        mIzname := read_xml_stroke_1251_to_utf8( oXmlNode, 'IZNAME' )
        mDL_USLOV := read_xml_stroke_1251_to_utf8( oXmlNode, 'DL_USLOV' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert := cmdTextInsert + "INSERT INTO v012( idiz, izname, dl_uslov, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + mIDIZ + "',"
        cmdTextInsert += "'" + mIzname + "',"
        cmdTextInsert += "'" + mDL_USLOV + "',"
        cmdTextInsert += "'" + d1 + "',"
        cmdTextInsert += "'" + d2 + "');"
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

// 25.12.24
Function make_v015( db, source )

  // RECID,  "N",    3,      0      // Номер записи
  // CODE,   "N",    4,      0      // Код специальности
  // NAME,   "C",  254,      0      // Наименование специальности
  // HIGH,   "N",    4,      0      // Принадлежность (иерархия)
  // OKSO,   "N",    3,      0      // Значение ОКСО
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mRecid, mCode, mName, mHigh, mOKSO, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v015(recid INTEGER, code INTEGER, name TEXT, high TEXT(4), okso TEXT(3), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V015.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор медицинских специальностей (Medspec)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v015' ) == SQLITE_OK
    OutStd( 'DROP TABLE v015 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v015 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v015 - False' + hb_eol() )
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
        mRecid := read_xml_stroke_1251_to_utf8( oXmlNode, 'RECID' )
        mCode := read_xml_stroke_1251_to_utf8( oXmlNode, 'CODE' )
        mName := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAME' )
        mHigh := read_xml_stroke_1251_to_utf8( oXmlNode, 'HIGH' )
        mOKSO := read_xml_stroke_1251_to_utf8( oXmlNode, 'OKSO' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert := cmdTextInsert + "INSERT INTO v015( recid, code, name, high, okso, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + mRecid + "',"
        cmdTextInsert += "'" + mCode + "',"
        cmdTextInsert += "'" + mName + "',"
        cmdTextInsert += "'" + mHigh + "',"
        cmdTextInsert += "'" + mOKSO + "',"
        cmdTextInsert += "'" + d1 + "',"
        cmdTextInsert += "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    // добавим фиктивную запись
    count++
    cmdTextInsert := cmdTextInsert + "INSERT INTO v015( recid, code, name, high, okso, datebeg, dateend ) VALUES("
    cmdTextInsert += "'999',"
    cmdTextInsert += "'9999',"
    cmdTextInsert += "'Клиническая психология',"
    cmdTextInsert += "'287',"
    cmdTextInsert += "'201',"
    cmdTextInsert += "'" + d1 + "',"
    cmdTextInsert += "'');"
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v016( db, source )

  // IDDT,     "C",        3,      0 // Код типа диспансеризации
  // DTNAME,   "C",      254,      0 // Наименование типа диспансеризации
  // RULE,     "N",        2,      0 // Значение результата диспансеризации (Заполняется в соответствии с классификатором V017)
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j, j1
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode, oNode1, oNode2
  Local mIDDT, mDTNAME, mRule, d1, d2

  cmdText := 'CREATE TABLE v016(iddt TEXT(3), dtname TEXT, rule TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V016.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор типов диспансеризации (DispT)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v016' ) == SQLITE_OK
    OutStd( 'DROP TABLE v016 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v016 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v016 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v016 (iddt, dtname, rule, datebeg, dateend) VALUES( :iddt, :dtname, :rule, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDDT := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDDT' )
          mDTNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'DTNAME' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          mRule := ''
          If ( oNode1 := oXmlNode:find( 'DTRULE' ) ) != NIL
            For j1 := 1 To Len( oNode1:aItems )
              oNode2 := oNode1:aItems[ j1 ]
              If 'RULE' == oNode2:title .and. !Empty( oNode2:aItems ) .and. ValType( oNode2:aItems[ 1 ] ) == 'C'
                mRule := mRule + iif( Empty( mRule ), '', ',' ) + AllTrim( oNode2:aItems[ 1 ] )
              Endif
            Next
          Endif

          If sqlite3_bind_text( stmt, 1, mIDDT ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mDTNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, mRule ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v017( db, source )

  // IDDR,     "N",        2,      0 // Код результата диспансеризации
  // DRNAME,   "C",      254,      0 // Наименование результата диспансеризации
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDDR, mDRNAME, d1, d2

  cmdText := 'CREATE TABLE v017(iddr INTEGER, drname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V017.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор результатов диспансеризации (DispR)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v017' ) == SQLITE_OK
    OutStd( 'DROP TABLE v017 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v017 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v017 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v017 (iddr, drname, datebeg, dateend) VALUES( :iddr, :drname, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDDR := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDDR' )
          mDRNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'DRNAME' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_int( stmt, 1, Val( mIDDR ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mDRNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v018( db, source )

  // IDHVID,     "C",     12,      0 // Код вида высокотехнологичной медицинской помощи
  // HVIDNAME,   "C",   1000,      0 // Наименование вида высокотехнологичной медицинской помощи
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDHVID, mHVIDNAME, d1, d2

  cmdText := 'CREATE TABLE v018(idhvid TEXT(12), hvidname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V018.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор видов высокотехнологичной медицинской помощи (HVid)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v018' ) == SQLITE_OK
    OutStd( 'DROP TABLE v018 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v018 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v018 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v018 (idhvid, hvidname, datebeg, dateend) VALUES( :idhvid, :hvidname, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDHVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDHVID' )
          mHVIDNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'HVIDNAME' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_text( stmt, 1, mIDHVID ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mHVIDNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v020( db, source )

  // IDK_PR,     "N",      3,      0 // Код профиля койки
  // K_PRNAME,   "C",    254,      0 // Наименование профиля койки
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0  // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDK_PR, mK_PRNAME, d1, d2

  cmdText := 'CREATE TABLE v020(idk_pr INTEGER, k_prname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V020.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор профиля койки (KoPr)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v020' ) == SQLITE_OK
    OutStd( 'DROP TABLE v020 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v020 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v020 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v020 (idk_pr, k_prname, datebeg, dateend) VALUES( :idk_pr, :k_prname, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDK_PR := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDK_PR' )
          mK_PRNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'K_PRNAME' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_int( stmt, 1, Val( mIDK_PR ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mK_PRNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v021( db, source )

  // IDSPEC,     "N",      3,      0  // Код специальности
  // SPECNAME,   "C", 254             // Наименование специальности
  // POSTNAME,   "C",    400,      0  // Наименование должности
  // IDPOST_MZ,   "C",    4,      0  // Код должности в соответствии с НСИ Минздрава России (OID 1.2.643.5.1.13.13.11.1002)
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDSPEC, mSPECNAME, mPOSTNAME, mIDPOST_MZ, d1, d2

  cmdText := 'CREATE TABLE v021(idspec INTEGER, specname BLOB, postname BLOB, idpost_mz TEXT(4), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V021.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор медицинских специальностей (должностей) (MedSpec)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v021' ) == SQLITE_OK
    OutStd( 'DROP TABLE v021 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v021 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v021 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v021 (idspec, specname, postname, idpost_mz, datebeg, dateend) VALUES( :idspec, :specname, :postname, :idpost_mz, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDSPEC := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDSPEC' )
          mSPECNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'SPECNAME' )
          mPOSTNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'POSTNAME' )
          mIDPOST_MZ := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDPOST_MZ' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_int( stmt, 1, Val( mIDSPEC ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mSPECNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, mPOSTNAME ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, mIDPOST_MZ ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 5, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 6, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v022( db, source )

  // IDMPAC,     "N",      5,      0  //  Идентификатор модели пациента
  // MPACNAME,   "M",     10,      0  // Наименование модели пациента
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDMPAC, mMPACNAME, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v022(idmpac INTEGER, mpacname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V022.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v022' ) == SQLITE_OK
    OutStd( 'DROP TABLE v022 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v022 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v022 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v022 (idmpac, mpacname, datebeg, dateend) VALUES( :idmpac, :mpacname, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDMPAC := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDMPAC' )
          mMPACNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'MPACNAME' )
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
          If d1_1 >= 0d20210101 .or. Empty( d2_1 )  // 0d20210101

            Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
            d1 := hb_ValToStr( d1_1 )
            d2 := hb_ValToStr( d2_1 )

            If sqlite3_bind_int( stmt, 1, Val( mIDMPAC ) ) == SQLITE_OK .and. ;
                sqlite3_bind_text( stmt, 2, mMPACNAME ) == SQLITE_OK .and. ;
                sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
                sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
              If sqlite3_step( stmt ) != SQLITE_DONE
                out_error( TAG_ROW_INVALID, nfile, j )
              Endif
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v025( db, source )

  // IDPC,      "C",   3, 0  // Код цели посещения
  // N_PC,      "C", 254, 0  // Наименование цели посещения
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDPC, mN_PC, d1, d2

  cmdText := 'CREATE TABLE v025(idpc TEXT(3), n_pc BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V025.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор целей посещения (KPC)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v025' ) == SQLITE_OK
    OutStd( 'DROP TABLE v025 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v025 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v025 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v025 (idpc, n_pc, datebeg, dateend) VALUES( :idpc, :n_pc, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mIDPC := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDPC' )
          mN_PC := read_xml_stroke_1251_to_utf8( oXmlNode, 'N_PC' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_text( stmt, 1, mIDPC ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mN_PC ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v030( db, source )

  // SCHEMCOD,  "C",   5, 0  //
  // SCHEME,    "C",  15, 0  //
  // DEGREE,    "N",   2, 0  //
  // COMMENT,   "M",  10, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mSchemCode, mScheme, mDegree, mComment, d1, d2, d1_1, d2_1
  Local strD_End

  cmdText := 'CREATE TABLE v030(schemcode TEXT(5), scheme TEXT(15), degree INTEGER, comment BLOB, datebeg TEXT(10), dateend TEXT(10), '
  cmdText += 'FOREIGN KEY(degree) REFERENCES Severity(id))'

  nameRef := 'V030.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Схемы лечения заболевания COVID-19 (TreatReg)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v030' ) == SQLITE_OK
    OutStd( 'DROP TABLE v030 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v030 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v030 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v030 (schemcode, scheme, degree, comment, datebeg, dateend) VALUES( :schemcode, :scheme, :degree, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mSchemCode := read_xml_stroke_1251_to_utf8( oXmlNode, 'SchemCode' )
          mScheme := read_xml_stroke_1251_to_utf8( oXmlNode, 'Scheme' )
          mDegree := read_xml_stroke_1251_to_utf8( oXmlNode, 'DegreeSeverity' )
          mComment := read_xml_stroke_1251_to_utf8( oXmlNode, 'COMMENT' )
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          strD_End := read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' )
          // d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          If Empty( strD_End )
            d2_1 := CToD( '01.01.2222' )
          Else
            d2_1 := CToD( strD_End )
          Endif
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr( d1_1 )
          d2 := hb_ValToStr( d2_1 )

          If sqlite3_bind_text( stmt, 1, mSchemCode ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mScheme ) == SQLITE_OK .and. ;
              sqlite3_bind_int( stmt, 3, Val( mDegree ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, mComment ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 5, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 6, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v031( db, source )

  // DRUGCODE,  "N",   2, 0  //
  // DRUGGRUP,  "C",  50, 0  //
  // INDMNN,    "N",   2, 0  // Признак обязательности указания МНН (1-да, 0-нет)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mDrugCode, mDrugGrup, mIndMNN, d1, d2

  cmdText := 'CREATE TABLE v031(drugcode INTEGER, druggrup TEXT, indmnn INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V031.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v031' ) == SQLITE_OK
    OutStd( 'DROP TABLE v031 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v031 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v031 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v031 (drugcode, druggrup, indmnn, datebeg, dateend) VALUES( :drugcode, :druggrup, :indmnn, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mDrugCode := read_xml_stroke_1251_to_utf8( oXmlNode, 'DrugGroupCode' )
          mDrugGrup := read_xml_stroke_1251_to_utf8( oXmlNode, 'DrugGroup' )
          mIndMNN := read_xml_stroke_1251_to_utf8( oXmlNode, 'ManIndMNN' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_int( stmt, 1, Val( mDrugCode ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mDrugGrup ) == SQLITE_OK .and. ;
              sqlite3_bind_int( stmt, 3, Val( mIndMNN ) ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v032( db, source )

  // SCHEDRUG,  "C",  10, 0  // Сочетание схемы лечения и группы препаратов
  // NAME,      "C", 100, 0  //
  // SCHEMCODE,  "C",   5, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0  // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mScheDrug, mName, mSchemCode, d1, d2

  cmdText := 'CREATE TABLE v032(schedrug TEXT(10), name TEXT, schemcode TEXT(5), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V032.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Сочетание схемы лечения и группы препаратов (CombTreat)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v032' ) == SQLITE_OK
    OutStd( 'DROP TABLE v032 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v032 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v032 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v032 (schedrug, name, schemcode, datebeg, dateend) VALUES( :schedrug, :name, :schemcode, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mScheDrug := read_xml_stroke_1251_to_utf8( oXmlNode, 'ScheDrugGrCd' )
          mName := read_xml_stroke_1251_to_utf8( oXmlNode, 'Name' )
          mSchemCode := read_xml_stroke_1251_to_utf8( oXmlNode, 'SchemCode' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_text( stmt, 1, mScheDrug ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mName ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, mSchemCode ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v033( db, source )

  // SCHEDRUG,  "C",  10, 0  //
  // DRUGCODE,  "C",   6, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mScheDrug, mDrugCode, d1, d2

  cmdText := 'CREATE TABLE v033(schedrug TEXT(10), drugcode TEXT(6), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V033.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Соответствие кода препарата схеме лечения (DgTreatReg)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v033' ) == SQLITE_OK
    OutStd( 'DROP TABLE v033 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v033 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v033 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := "INSERT INTO v033 (schedrug, drugcode, datebeg, dateend) VALUES( :schedrug, :drugcode, :datebeg, :dateend )"
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          mScheDrug := read_xml_stroke_1251_to_utf8( oXmlNode, 'ScheDrugGrCd' )
          mDrugCode := read_xml_stroke_1251_to_utf8( oXmlNode, 'DrugCode' )
          d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
          d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

          If sqlite3_bind_text( stmt, 1, mScheDrug ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 2, mDrugCode ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .and. ;
              sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            If sqlite3_step( stmt ) != SQLITE_DONE
              out_error( TAG_ROW_INVALID, nfile, j )
            Endif
          Endif
          sqlite3_reset( stmt )
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil

// 25.12.24
Function make_v036( db, source )

  // S_CODE    "C",  16, 0
  // NAME",      "C", 150, 0
  // "PARAM",     "N",   1, 0
  // "COMMENT",   "C",  20, 0
  // "DATEBEG",   "D",   8, 0 Дата начала действия записи
  // "DATEEND",   "D",   8, 0 Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mS_Code, mName, mParam, mComment, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v036( s_code TEXT(16), name BLOB, param INTEGER, comment TEXT, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'V036.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v036' ) == SQLITE_OK
    OutStd( 'DROP TABLE v036 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v036 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v036 - False' + hb_eol() )
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
        mS_Code := read_xml_stroke_1251_to_utf8( oXmlNode, 'S_CODE' )
        mName := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAME' )
        mParam := read_xml_stroke_1251_to_utf8( oXmlNode, 'Parameter' )
        mComment := read_xml_stroke_1251_to_utf8( oXmlNode, 'COMMENT' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert += 'INSERT INTO v036(s_code, name, param, comment, datebeg, dateend) VALUES(' ;
          + "'" + mS_Code + "'," ;
          + "'" + mName + "'," ;
          + "'" + mParam + "'," ;
          + "'" + mComment + "'," ;
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

// 25.12.24
Function make_v002( db, source )

  // IDPR,       "N",      3,      0  // Код профиля медицинской помощи
  // PRNAME,     "C",    350,      0  // Наименование профиля медицинской помощи
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDPR, mPrname, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v002(idpr INTEGER, prname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V002.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор профилей оказанной медицинской помощи (ProfOt)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v002' ) == SQLITE_OK
    OutStd( 'DROP TABLE v002 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v002 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v002 - False' + hb_eol() )
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
        mIDPR := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDPR' )
        mPrname := read_xml_stroke_1251_to_utf8( oXmlNode, 'PRNAME' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert += 'INSERT INTO v002(idpr, prname, datebeg, dateend) VALUES(' ;
          + "'" + mIDPR + "'," ;
          + "'" + mPrname + "'," ;
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

// 25.12.24
Function make_v024( db, source )

  // IDDKK,     "C",  10,      0  //  Идентификатор модели пациента
  // DKKNAME,   "C", 255,      0  // Наименование модели пациента
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDDKK, mDkkname, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'V024.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  else
    out_utf8_to_str( nameRef + ' - Классификатор классификационных критериев (DopKr)', 'RU866' )	
  Endif

  cmdText := 'CREATE TABLE v024(iddkk TEXT(10), dkkname BLOB, datebeg TEXT(19), dateend TEXT(19))'
  If ! create_table( db, nameRef, cmdText )
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
        mIDDKK := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDDKK' )
        mDkkname := read_xml_stroke_1251_to_utf8( oXmlNode, 'DKKNAME' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert += 'INSERT INTO v024(iddkk, dkkname, datebeg, dateend) VALUES(' ;
          + "'" + mIDDKK + "'," ;
          + "'" + mDkkname + "'," ;
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

// 25.12.24
Function make_v019( db, source )

  // IDHM,       "N",      4,      0 // Идентификатор метода высокотехнологичной медицинской помощи
  // HMNAME,     "C",   1000,      0; // Наименование метода высокотехнологичной медицинской помощи
  // DIAG,       "C",   1000,      0 // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
  // HVID,       "C",     12,      0 // Код вида высокотехнологичной медицинской помощи для данного метода
  // HGR,        "N",      3,      0 // Номер группы высокотехнологичной медицинской помощи для данного метода
  // HMODP,      "C",   1000,      0 // Модель пациента для методов высокотехнологичной медицинской помощи с одинаковыми значениями поля "HMNAME". Не заполняется, начиная с версии 3.0
  // IDMODP,     "N",      5,      0 // Идентификатор модели пациента для данного метода (начиная с версии 3.0, заполняется значением поля IDMPAC классификатора V022)
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDHM, mHMNAME, mDIAG, mHVID, mHGR, mHMODP, mIDMODP, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v019(idhm INTEGER, hmname BLOB, diag BLOB, hvid TEXT(12), hgr INTEGER, hmodp BLOB, idmodp INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V019.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор методов высокотехнологичной медицинской помощи (HMet)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v019' ) == SQLITE_OK
    OutStd( 'DROP TABLE v019 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v019 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v019 - False' + hb_eol() )
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
        mIDHM := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDHM' )
        mHMNAME := read_xml_stroke_1251_to_utf8( oXmlNode, 'HMNAME' )
        mDIAG := read_xml_stroke_1251_to_utf8( oXmlNode, 'DIAG' )
        mHVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'HVID' )
        mHGR := read_xml_stroke_1251_to_utf8( oXmlNode, 'HGR' )
        mHMODP := read_xml_stroke_1251_to_utf8( oXmlNode, 'HMODP' )
        mIDMODP := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDMODP' )
        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert += 'INSERT INTO v019(idhm, hmname, diag, hvid, hgr, hmodp, idmodp, datebeg, dateend) VALUES(' ;
          + "'" + AllTrim( mIDHM ) + "'," ;
          + "'" + mHMNAME + "'," ;
          + "'" + mDIAG + "'," ;
          + "'" + mHVID + "'," ;
          + "'" + AllTrim( mHGR ) + "'," ;
          + "'" + mHMODP + "'," ;
          + "'" + AllTrim( mIDMODP ) + "'," ;
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

// 25.12.24
Function make_v004( db, source )

  // V004.xml - Классификатор медицинских специальностей
  // IDMSP(N)   // Код медицинской специальности
  // MSPNAME(C) // Наименование медицинской специальности
  // DATEBEG(D) // Дата начала действия записи
  // DATEEND(D) // Дата окончания действия записи

  Local cmdText
  Local _arr := {}
  Local empty_date := SToD( '' )
  Local date_20110101 := SToD( '20110101' )
  Local j, nameRef
  Local mIDMSP, mMSPname, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  AAdd( _arr, { 'Высшее медицинское образование', 1, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебное дело. Педиатрия', 11, date_20110101, empty_date } )
  AAdd( _arr, { 'Акушерство и гинекология', 1101, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 110101, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 110102, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 110103, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 110104, date_20110101, empty_date } )
  AAdd( _arr, { 'Анестезиология и реаниматология', 1103, date_20110101, empty_date } )
  AAdd( _arr, { 'Токсикология', 110301, date_20110101, empty_date } )
  AAdd( _arr, { 'Трансфузиология', 110302, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 110303, date_20110101, empty_date } )
  AAdd( _arr, { 'Дерматовенерология', 1104, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая микология', 110401, date_20110101, empty_date } )
  AAdd( _arr, { 'Генетика', 1105, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 110501, date_20110101, empty_date } )
  AAdd( _arr, { 'Инфекционные болезни', 1106, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая микология', 110601, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая лабораторная диагностика', 1107, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 110701, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 110702, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 110703, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная микология', 110704, date_20110101, empty_date } )
  AAdd( _arr, { 'Неврология', 1109, date_20110101, empty_date } )
  AAdd( _arr, { 'Мануальная терапия', 110901, date_20110101, empty_date } )
  AAdd( _arr, { 'Рефлексотерапия', 110902, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 110903, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 110904, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 110905, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 110906, date_20110101, empty_date } )
  AAdd( _arr, { 'Общая врачебная практика (семейная медицина)', 1110, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 111001, date_20110101, empty_date } )
  AAdd( _arr, { 'Гериатрия', 111002, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 111003, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 111004, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 111005, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 111006, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 111007, date_20110101, empty_date } )
  AAdd( _arr, { 'Отоларингология', 1111, date_20110101, empty_date } )
  AAdd( _arr, { 'Сурдология-отоларингология', 111101, date_20110101, empty_date } )
  AAdd( _arr, { 'Офтальмология', 1112, date_20110101, empty_date } )
  AAdd( _arr, { 'Патологическая анатомия', 1113, date_20110101, empty_date } )
  AAdd( _arr, { 'Психиатрия', 1115, date_20110101, empty_date } )
  AAdd( _arr, { 'Психотерапия', 111501, date_20110101, empty_date } )
  AAdd( _arr, { 'Сексология', 111502, date_20110101, empty_date } )
  AAdd( _arr, { 'Судебно-психиатрическая экспертиза', 111503, date_20110101, empty_date } )
  AAdd( _arr, { 'Психиатрия-наркология', 111504, date_20110101, empty_date } )
  AAdd( _arr, { 'Рентгенология', 1118, date_20110101, empty_date } )
  AAdd( _arr, { 'Радиология', 111801, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 111802, date_20110101, empty_date } )
  AAdd( _arr, { 'Скорая медицинская помощь', 1119, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 111901, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 111902, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 111903, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 111904, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 111905, date_20110101, empty_date } )
  AAdd( _arr, { 'Организация здравоохранения и общественное здоровье', 1120, date_20110101, empty_date } )
  AAdd( _arr, { 'Судебно-медицинская экспертиза', 1121, date_20110101, empty_date } )
  AAdd( _arr, { 'Терапия', 1122, date_20110101, empty_date } )
  AAdd( _arr, { 'Гастроэнтерология', 112201, date_20110101, empty_date } )
  AAdd( _arr, { 'Гематология', 112202, date_20110101, empty_date } )
  AAdd( _arr, { 'Гериатрия', 112203, date_20110101, empty_date } )
  AAdd( _arr, { 'Диетология', 112204, date_20110101, empty_date } )
  AAdd( _arr, { 'Кардиология', 112205, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая фармакология', 112206, date_20110101, empty_date } )
  AAdd( _arr, { 'Нефрология', 112207, date_20110101, empty_date } )
  AAdd( _arr, { 'Пульмонология', 112208, date_20110101, empty_date } )
  AAdd( _arr, { 'Ревматология', 112209, date_20110101, empty_date } )
  AAdd( _arr, { 'Трансфузиология', 112210, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 112211, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 112212, date_20110101, empty_date } )
  AAdd( _arr, { 'Авиационная и космическая медицина', 112213, date_20110101, empty_date } )
  AAdd( _arr, { 'Аллергология и иммунология', 112214, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 112215, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 112216, date_20110101, empty_date } )
  AAdd( _arr, { 'Мануальная терапия', 112217, date_20110101, empty_date } )
  AAdd( _arr, { 'Профпатология', 112218, date_20110101, empty_date } )
  AAdd( _arr, { 'Рефлексотерапия', 112219, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 112220, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 112221, date_20110101, empty_date } )
  AAdd( _arr, { 'Травматология и ортопедия', 1123, date_20110101, empty_date } )
  AAdd( _arr, { 'Мануальная терапия', 112301, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 112302, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 112303, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиология', 112304, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 1124, date_20110101, empty_date } )
  AAdd( _arr, { 'Фтизиатрия', 1125, date_20110101, empty_date } )
  AAdd( _arr, { 'Пульмонология', 112501, date_20110101, empty_date } )
  AAdd( _arr, { 'Хирургия', 1126, date_20110101, empty_date } )
  AAdd( _arr, { 'Колопроктология', 112601, date_20110101, empty_date } )
  AAdd( _arr, { 'Нейрохирургия', 112602, date_20110101, empty_date } )
  AAdd( _arr, { 'Урология', 112603, date_20110101, empty_date } )
  AAdd( _arr, { 'Сердечно-сосудистая хирургия', 112604, date_20110101, empty_date } )
  AAdd( _arr, { 'Торакальная хирургия', 112605, date_20110101, empty_date } )
  AAdd( _arr, { 'Трансфузиология', 112606, date_20110101, empty_date } )
  AAdd( _arr, { 'Челюстно-лицевая хирургия', 112608, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 112609, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 112610, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 112611, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндокринология', 1127, date_20110101, empty_date } )
  AAdd( _arr, { 'Диабетология', 112701, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская эндокринология', 112702, date_20110101, empty_date } )
  AAdd( _arr, { 'Онкология', 1128, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская онкология', 112801, date_20110101, empty_date } )
  AAdd( _arr, { 'Радиология', 112802, date_20110101, empty_date } )
  AAdd( _arr, { 'Педиатрия', 1134, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская онкология', 113401, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская эндокринология', 113402, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская кардиология', 113403, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура и спортивная медицина', 113404, date_20110101, empty_date } )
  AAdd( _arr, { 'Аллергология и иммунология', 113405, date_20110101, empty_date } )
  AAdd( _arr, { 'Восстановительная медицина', 113406, date_20110101, empty_date } )
  AAdd( _arr, { 'Гастроэнтерология', 113407, date_20110101, empty_date } )
  AAdd( _arr, { 'Гематология', 113408, date_20110101, empty_date } )
  AAdd( _arr, { 'Диетология', 113409, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая фармакология', 113410, date_20110101, empty_date } )
  AAdd( _arr, { 'Мануальная терапия', 113411, date_20110101, empty_date } )
  AAdd( _arr, { 'Нефрология', 113412, date_20110101, empty_date } )
  AAdd( _arr, { 'Пульмонология', 113413, date_20110101, empty_date } )
  AAdd( _arr, { 'Ревматология', 113414, date_20110101, empty_date } )
  AAdd( _arr, { 'Трансфузиология', 113415, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 113416, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 113417, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 113418, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 113419, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская хирургия', 1135, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская онкология', 113501, date_20110101, empty_date } )
  AAdd( _arr, { 'Детская урология-андрология', 113502, date_20110101, empty_date } )
  AAdd( _arr, { 'Колопроктология', 113503, date_20110101, empty_date } )
  AAdd( _arr, { 'Нейрохирургия', 113504, date_20110101, empty_date } )
  AAdd( _arr, { 'Сердечно-сосудистая хирургия', 113505, date_20110101, empty_date } )
  AAdd( _arr, { 'Торакальная хирургия', 113506, date_20110101, empty_date } )
  AAdd( _arr, { 'Трансфузиология', 113507, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 113508, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 113509, date_20110101, empty_date } )
  AAdd( _arr, { 'Челюстно-лицевая хирургия', 113510, date_20110101, empty_date } )
  AAdd( _arr, { 'Эндоскопия', 113511, date_20110101, empty_date } )
  AAdd( _arr, { 'Неонатология', 1136, date_20110101, empty_date } )
  AAdd( _arr, { 'Медико-профилактическое дело', 13, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая лабораторная диагностика', 1301, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 130101, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 130102, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 130103, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная микология', 130104, date_20110101, empty_date } )
  AAdd( _arr, { 'Эпидемиология', 1302, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 130201, date_20110101, empty_date } )
  AAdd( _arr, { 'Дезинфектология', 130203, date_20110101, empty_date } )
  AAdd( _arr, { 'Паразитология', 130204, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 130205, date_20110101, empty_date } )
  AAdd( _arr, { 'Общая гигиена', 1303, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиена детей и подростков', 130301, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиеническое воспитание', 130302, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиена питания', 130303, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиена труда', 130304, date_20110101, empty_date } )
  AAdd( _arr, { 'Коммунальная гигиена', 130305, date_20110101, empty_date } )
  AAdd( _arr, { 'Радиационная гигиена', 130306, date_20110101, empty_date } )
  AAdd( _arr, { 'Санитарно-гигиенические лабораторные исследования', 130307, date_20110101, empty_date } )
  AAdd( _arr, { 'Социальная гигиена и организация госсанэпидслужбы', 1306, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология', 14, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология общей практики', 1401, date_20110101, empty_date } )
  AAdd( _arr, { 'Ортодонтия', 140101, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология детская', 140102, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология терапевтическая', 140103, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология ортопедическая', 140104, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология хирургическая', 140105, date_20110101, empty_date } )
  AAdd( _arr, { 'Челюстно-лицевая хирургия', 140106, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 140107, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая лабораторная диагностика', 1402, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 140201, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 140202, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 140203, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная микология', 140204, date_20110101, empty_date } )
  AAdd( _arr, { 'Фармация', 15, date_20110101, empty_date } )
  AAdd( _arr, { 'Управление и экономика фармации', 1501, date_20110101, empty_date } )
  AAdd( _arr, { 'Фармацевтическая технология', 1502, date_20110101, empty_date } )
  AAdd( _arr, { 'Фармацевтическая химия и фармакогнозия', 1503, date_20110101, empty_date } )
  AAdd( _arr, { 'Сестринское дело', 16, date_20110101, empty_date } )
  AAdd( _arr, { 'Управление сестринской деятельностью', 1601, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская биохимия', 17, date_20110101, empty_date } )
  AAdd( _arr, { 'Генетика', 1701, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 170101, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая лабораторная диагностика', 1702, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 170201, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 170202, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 170203, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная микология', 170204, date_20110101, empty_date } )
  AAdd( _arr, { 'Судебно-медицинская экспертиза', 1703, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская биофизика. Медицинская кибернетика', 18, date_20110101, empty_date } )
  AAdd( _arr, { 'Клиническая лабораторная диагностика', 1801, date_20110101, empty_date } )
  AAdd( _arr, { 'Бактериология', 180101, date_20110101, empty_date } )
  AAdd( _arr, { 'Вирусология', 180102, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная генетика', 180103, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная микология', 180104, date_20110101, empty_date } )
  AAdd( _arr, { 'Рентгенология', 1802, date_20110101, empty_date } )
  AAdd( _arr, { 'Радиология', 180201, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 180202, date_20110101, empty_date } )
  AAdd( _arr, { 'Ультразвуковая диагностика', 180203, date_20110101, empty_date } )
  AAdd( _arr, { 'Среднее медицинское и фармацевтическое образование', 2, date_20110101, empty_date } )
  AAdd( _arr, { 'Организация сестринского дела', 2001, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебное дело', 2002, date_20110101, empty_date } )
  AAdd( _arr, { 'Акушерское дело', 2003, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология', 2004, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология ортопедическая', 2005, date_20110101, empty_date } )
  AAdd( _arr, { 'Эпидемиология (паразитология)', 2006, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиена и санитария', 2007, date_20110101, empty_date } )
  AAdd( _arr, { 'Дезинфекционное дело', 2008, date_20110101, empty_date } )
  AAdd( _arr, { 'Гигиеническое воспитание', 2009, date_20110101, empty_date } )
  AAdd( _arr, { 'Энтомология', 2010, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторная диагностика', 2011, date_20110101, empty_date } )
  AAdd( _arr, { 'Гистология', 2012, date_20110101, empty_date } )
  AAdd( _arr, { 'Лабораторное дело', 2013, date_20110101, empty_date } )
  AAdd( _arr, { 'Фармация', 2014, date_20110101, empty_date } )
  AAdd( _arr, { 'Сестринское дело', 2015, date_20110101, empty_date } )
  AAdd( _arr, { 'Сестринское дело в педиатрии', 2016, date_20110101, empty_date } )
  AAdd( _arr, { 'Операционное дело', 2017, date_20110101, empty_date } )
  AAdd( _arr, { 'Анестезиология и реаниматология', 2018, date_20110101, empty_date } )
  AAdd( _arr, { 'Общая практика', 2019, date_20110101, empty_date } )
  AAdd( _arr, { 'Рентгенология', 2020, date_20110101, empty_date } )
  AAdd( _arr, { 'Функциональная диагностика', 2021, date_20110101, empty_date } )
  AAdd( _arr, { 'Физиотерапия', 2022, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинский массаж', 2023, date_20110101, empty_date } )
  AAdd( _arr, { 'Лечебная физкультура', 2024, date_20110101, empty_date } )
  AAdd( _arr, { 'Диетология', 2025, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская статистика', 2026, date_20110101, empty_date } )
  AAdd( _arr, { 'Стоматология профилактическая', 2027, date_20110101, empty_date } )
  AAdd( _arr, { 'Судебно-медицинская экспертиза', 2028, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская оптика', 2029, date_20110101, empty_date } )
  AAdd( _arr, { 'Естественные науки', 3, date_20110101, empty_date } )
  AAdd( _arr, { 'Биофизика', 31, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская биофизика', 3101, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская кибернетика', 3102, date_20110101, empty_date } )
  AAdd( _arr, { 'Биохимия', 32, date_20110101, empty_date } )
  AAdd( _arr, { 'Медицинская биохимия', 3201, date_20110101, empty_date } )

  cmdText := 'CREATE TABLE v004( idmsp INTEGER, mspname TEXT(50), datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'V004.xml'
  out_utf8_to_str( nameRef + ' - Классификатор медицинских специальностей', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS v004' ) == SQLITE_OK
    OutStd( 'DROP TABLE v004 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE v004 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE v004 - False' + hb_eol() )
    Return Nil
  Endif

  For j := 1 To Len( _arr )
    mIDMSP := Str( _arr[ j, 2 ], 10 )
    mMSPname := _arr[ j, 1 ]

    d1_1 := _arr[ j, 3 ]
    d2_1 := _arr[ j, 4 ]

    Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
    d1 := hb_ValToStr( d1_1 )
    d2 := hb_ValToStr( d2_1 )

    count++
    cmdTextInsert += 'INSERT INTO v004( idmsp, mspname, datebeg, dateend) VALUES(' ;
      + "'" + mIDMSP + "'," ;
      + "'" + mMSPname + "'," ;
      + "'" + d1 + "'," ;
      + "'" + d2 + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  Next j
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  out_obrabotka_eol()
  Return Nil
