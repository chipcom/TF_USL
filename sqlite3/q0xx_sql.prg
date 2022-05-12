// Справочники федерального фонда медицинского страхования РФ типа O0xx

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 05.05.22
function make_Q0xx(db, source)

  make_q015(db, source)
  make_q016(db, source)
  make_q017(db, source)

  return nil

** 07.05.22
function make_q015(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2

  // ID_TEST, Строчный(12), Идентификатор проверки.
  //      Формируется по шаблону KKKK.00.TTTT, где
  //      KKKK - идентификатор категории проверки 
  //        в соответствии с классификатором Q017,
  //      TTTT - уникальный номер проверки в категории
  // ID_EL, Строчный(100),	Идентификатор элемента, 
  //      подлежащего проверке (Приложение А, классификатор Q018)
  // TYPE_MD	ОМ	Допустимые типы передаваемых данных, содержащих 
  //      элемент, подлежащий проверке
  // TYPE_D, Строчный(2),	Тип передаваемых данных, содержащих элемент,
  //      подлежащий проверке (Приложение А, классификатор Q019)
  // NSI_OBJ, Строчный(4), Код объекта НСИ, на соответствие с которым 
  //      осуществляется проверка значения элемента
  // NSI_EL, Строчный(20), Имя элемента объекта НСИ, на соответствие с 
  //      которым осуществляется проверка значения элемента
  // USL_TEST, Строчный(254),	Условие проведения проверки элемента
  // VAL_EL, Строчный(254),	Множество допустимых значений элемента
  // MIN_LEN, Целочисленный(4),	Минимальная длина значения элемента
  // MAX_LEN, Целочисленный(4),	Максимальная длина значения элемента
  // MASK_VAL, Строчный(254),	Маска значения элемента
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10),	Дата начала действия записи
  // DATEEND, Строчный(10),	Дата окончания действия записи
  cmdText := 'CREATE TABLE q015( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT(4), nsi_el TEXT(20), usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q015') == SQLITE_OK
    OutStd('DROP TABLE q015 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE q015 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE q015 - False' + hb_eol() )
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q015 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_EL')
          s_nsi_obj := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_OBJ')
          s_nsi_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_EL')
          s_usl_test := read_xml_stroke_1251_to_utf8(oXmlNode, 'USL_TEST')
          s_val_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'VAL_EL')
          s_comment :=  read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
          if sqlite3_bind_text(stmt, 1, s_kod) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, s_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, s_nsi_obj) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, s_nsi_el) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, s_usl_test) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, s_val_el) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 7, s_comment) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 8, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 9, d2) == SQLITE_OK
            IF sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  out_obrabotka_eol()
  return nil

** 07.05.22
function make_q016(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2

  // ID_TEST, Строчный(12),	Идентификатор проверки. 
  //      Формируется по шаблону KKKK.RR.TTTT, где
  //      KKKK - идентификатор категории проверки 
  //        в соответствии с классификатором Q017,
  //      RR код ТФОМС в соответствии с классификатором F010.
  //        Для проверок федерального уровня RR принимает значение 00.
  //      TTTT - уникальный номер проверки в категории
  // ID_EL, Строчный(100),	Идентификатор элемента, 
  //      подлежащего проверке (Приложение А, классификатор Q018)
  
  // DESC_TEST, Строчный(500),	Описание проверки
  // TYPE_MD	ОМ	Допустимые типы передаваемых данных, содержащих 
  //      элемент, подлежащий проверке
  // TYPE_D, Строчный(2),	Тип передаваемых данных, содержащих элемент,
  //      подлежащий проверке (Приложение А, классификатор Q019)
  // NSI_OBJ, Строчный(4), Код объекта НСИ, на соответствие с которым 
  //      осуществляется проверка значения элемента
  // NSI_EL, Строчный(20), Имя элемента объекта НСИ, на соответствие с 
  //      которым осуществляется проверка значения элемента
  // USL_TEST, Строчный(254),	Условие проведения проверки элемента
  // VAL_EL, Строчный(254),	Множество допустимых значений элемента
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10),	Дата начала действия записи
  // DATEEND, Строчный(10),	Дата окончания действия записи
  
  cmdText := 'CREATE TABLE q016( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT, nsi_el TEXT, usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  nameRef := 'Q016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q016') == SQLITE_OK
    OutStd('DROP TABLE q016 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE q016 - Ok' + hb_eol())
  else
    OutStd('CREATE TABLE q016 - False' + hb_eol())
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q016 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_EL')
          s_nsi_obj := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_OBJ')
          s_nsi_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'NSI_EL')
          s_usl_test := read_xml_stroke_1251_to_utf8(oXmlNode, 'USL_TEST')
          s_val_el := read_xml_stroke_1251_to_utf8(oXmlNode, 'VAL_EL')
          s_comment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_nsi_obj ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_nsi_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, s_usl_test ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, s_val_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 7, s_comment ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 8, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 9, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  out_obrabotka_eol()
  return nil

** 07.05.22
function make_q017(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local s_kod, s_name, s_comment, d1, d2

  // ID_KTEST, Строчный(4),	Идентификатор категории проверки
  // NAM_KTEST, Строчный(400),	Наименование категории проверки
  // COMMENT, Строчный(500), Комментарий
  // DATEBEG, Строчный(10),	Дата начала действия записи
  // DATEEND, Строчный(10),	Дата окончания действия записи
  
  cmdText := 'CREATE TABLE q017( id_ktest TEXT(4), nam_ktest BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  nameRef := 'Q017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Перечень категорий проверок ФЛК и МЭК (TEST_K)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q017') == SQLITE_OK
    OutStd('DROP TABLE q017 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE q017 - Ok' + hb_eol())
  else
    OutStd('CREATE TABLE q017 - False' + hb_eol())
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q017 ( id_ktest, nam_ktest, comment, datebeg, dateend ) VALUES( :id_ktest, :nam_ktest, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_KTEST')
          s_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAM_KTEST')
          s_comment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_comment ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  out_obrabotka_eol()
  return nil