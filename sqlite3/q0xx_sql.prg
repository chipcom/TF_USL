// Справочники федерального фонда медицинского страхования РФ типа O0xx

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 15.06.24
Function make_q0xx( db, source )

  make_q015( db, source )
  make_q016( db, source )
  make_q017( db, source )

  Return Nil

// 20.12.24
Function make_q015( db, source )

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans
  local st

  // ID_TEST, Строчный(12), Идентификатор проверки.
  // Формируется по шаблону KKKK.00.TTTT, где
  // KKKK - идентификатор категории проверки
  // в соответствии с классификатором Q017,
  // TTTT - уникальный номер проверки в категории
  // ID_EL, Строчный(100), Идентификатор элемента,
  // подлежащего проверке (Приложение А, классификатор Q018)
  // TYPE_MD ОМ Допустимые типы передаваемых данных, содержащих
  // элемент, подлежащий проверке
  // TYPE_D, Строчный(2), Тип передаваемых данных, содержащих элемент,
  // подлежащий проверке (Приложение А, классификатор Q019)
  // NSI_OBJ, Строчный(4), Код объекта НСИ, на соответствие с которым
  // осуществляется проверка значения элемента
  // NSI_EL, Строчный(20), Имя элемента объекта НСИ, на соответствие с
  // которым осуществляется проверка значения элемента
  // USL_TEST, Строчный(254), Условие проведения проверки элемента
  // VAL_EL, Строчный(254), Множество допустимых значений элемента
  // MIN_LEN, Целочисленный(4), Минимальная длина значения элемента
  // MAX_LEN, Целочисленный(4), Максимальная длина значения элемента
  // MASK_VAL, Строчный(254), Маска значения элемента
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10), Дата начала действия записи
  // DATEEND, Строчный(10), Дата окончания действия записи
  cmdText := 'CREATE TABLE q015( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT(4), nsi_el TEXT(20), usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q015.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    st := hb_Utf8ToStr( ' - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)', 'RU866' )	
    OutStd( hb_eol() + nameRef + st + hb_eol() )

//    OutStd( hb_eol() + nameRef + ' - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS q015' ) == SQLITE_OK
    OutStd( 'DROP TABLE q015 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE q015 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE q015 - False' + hb_eol() )
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
        s_kod := read_xml_stroke_1251_to_utf8( oXmlNode, 'ID_TEST' )
        s_name := read_xml_stroke_1251_to_utf8( oXmlNode, 'ID_EL' )
        s_nsi_obj := read_xml_stroke_1251_to_utf8( oXmlNode, 'NSI_OBJ' )
        s_nsi_el := read_xml_stroke_1251_to_utf8( oXmlNode, 'NSI_EL' )
        s_usl_test := read_xml_stroke_1251_to_utf8( oXmlNode, 'USL_TEST' )
        s_val_el := read_xml_stroke_1251_to_utf8( oXmlNode, 'VAL_EL' )
        s_comment :=  read_xml_stroke_1251_to_utf8( oXmlNode, 'COMMENT' )

        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
  
        count++
        cmdTextInsert += "INSERT INTO q015( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + s_kod + "',"
        cmdTextInsert += "'" + s_name + "',"
        cmdTextInsert += "'" + s_nsi_obj+ "',"
        cmdTextInsert += "'" + s_nsi_el + "',"
        cmdTextInsert += "'" + s_usl_test + "',"
        cmdTextInsert += "'" + s_val_el + "',"
        cmdTextInsert += "'" + s_comment + "',"
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

// 20.12.24
Function make_q016( db, source )

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local s_kod, s_name, s_desc_test, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans
  local st

  // ID_TEST, Строчный(12), Идентификатор проверки.
  // Формируется по шаблону KKKK.RR.TTTT, где
  // KKKK - идентификатор категории проверки
  // в соответствии с классификатором Q017,
  // RR код ТФОМС в соответствии с классификатором F010.
  // Для проверок федерального уровня RR принимает значение 00.
  // TTTT - уникальный номер проверки в категории
  // ID_EL, Строчный(100), Идентификатор элемента,
  // подлежащего проверке (Приложение А, классификатор Q018)

  // DESC_TEST, Строчный(500), Описание проверки
  // TYPE_MD ОМ Допустимые типы передаваемых данных, содержащих
  // элемент, подлежащий проверке
  // TYPE_D, Строчный(2), Тип передаваемых данных, содержащих элемент,
  // подлежащий проверке (Приложение А, классификатор Q019)
  // NSI_OBJ, Строчный(4), Код объекта НСИ, на соответствие с которым
  // осуществляется проверка значения элемента
  // NSI_EL, Строчный(20), Имя элемента объекта НСИ, на соответствие с
  // которым осуществляется проверка значения элемента
  // USL_TEST, Строчный(254), Условие проведения проверки элемента
  // VAL_EL, Строчный(254), Множество допустимых значений элемента
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10), Дата начала действия записи
  // DATEEND, Строчный(10), Дата окончания действия записи

  cmdText := 'CREATE TABLE q016( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT, nsi_el TEXT, usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q016.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    st := hb_Utf8ToStr( ' - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)', 'RU866' )	
    OutStd( hb_eol() + nameRef + st + hb_eol() )

//    OutStd( hb_eol() + nameRef + ' - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS q016' ) == SQLITE_OK
    OutStd( 'DROP TABLE q016 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE q016 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE q016 - False' + hb_eol() )
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
        s_kod := read_xml_stroke_1251_to_utf8( oXmlNode, 'ID_TEST' )
        s_name := read_xml_stroke_1251_to_utf8( oXmlNode, 'ID_EL' )
        s_desc_test := read_xml_stroke_1251_to_utf8( oXmlNode, 'DESC_TEST' )
        s_nsi_obj := read_xml_stroke_1251_to_utf8( oXmlNode, 'NSI_OBJ' )
        s_nsi_el := read_xml_stroke_1251_to_utf8( oXmlNode, 'NSI_EL' )
        s_usl_test := hb_StrReplace( read_xml_stroke_1251_to_utf8( oXmlNode, 'USL_TEST' ), "'" )
        s_val_el := read_xml_stroke_1251_to_utf8( oXmlNode, 'VAL_EL' )
        s_comment := hb_StrReplace( read_xml_stroke_1251_to_utf8( oXmlNode, 'COMMENT' ), '"' )

        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert := cmdTextInsert + "INSERT INTO q016( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + s_kod + "',"
        cmdTextInsert += "'" + s_name + "',"
        cmdTextInsert += "'" + s_nsi_obj+ "',"
        cmdTextInsert += "'" + s_nsi_el + "',"
        cmdTextInsert += "'" + s_usl_test + "',"
        cmdTextInsert += "'" + s_val_el + "',"
        cmdTextInsert += "'" + s_comment + "',"
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

// 20.12.24
Function make_q017( db, source )

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local s_kod, s_name, s_comment, d1, d2
  Local count := 0, cmdTextInsert := textBeginTrans
  local st

  // ID_KTEST, Строчный(4), Идентификатор категории проверки
  // NAM_KTEST, Строчный(400), Наименование категории проверки
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10), Дата начала действия записи
  // DATEEND, Строчный(10), Дата окончания действия записи

  cmdText := 'CREATE TABLE q017( id_ktest TEXT(4), nam_ktest BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q017.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else

    st := hb_Utf8ToStr( ' - Перечень категорий проверок ФЛК и МЭК (TEST_K)', 'RU866' )	
    OutStd( hb_eol() + nameRef + st + hb_eol() )

//    OutStd( hb_eol() + nameRef + ' - Перечень категорий проверок ФЛК и МЭК (TEST_K)' + hb_eol() )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS q017' ) == SQLITE_OK
    OutStd( 'DROP TABLE q017 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE q017 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE q017 - False' + hb_eol() )
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
        s_kod := read_xml_stroke_1251_to_utf8( oXmlNode, 'ID_KTEST' )
        s_name := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_KTEST' )
        s_comment := read_xml_stroke_1251_to_utf8( oXmlNode, 'COMMENT' )

        d1 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2 := date_xml_sqlite( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )

        count++
        cmdTextInsert := cmdTextInsert + "INSERT INTO q017( id_ktest, nam_ktest, comment, datebeg, dateend ) VALUES("
        cmdTextInsert += "'" + s_kod + "',"
        cmdTextInsert += "'" + s_name + "',"
        cmdTextInsert += "'" + s_comment + "',"
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
