#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 06.05.22
function make_F0xx(db, source)

  make_f006(db, source)
  make_f010(db, source)
  make_f011(db, source)
  make_f014(db, source)
  
  return nil

** 09.05.22
Function make_f006(db, source)
  // IDVID,       "N",      2,      0  // Код вида контроля
  // VIDNAME,     "C",    350,      0  // Наименование вида контроля
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDVID, mVidname, d1, d2

  cmdText := 'CREATE TABLE f006(idvid INTEGER, vidname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Классификатор видов контроля (VidExp)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f006') == SQLITE_OK
    OutStd('DROP TABLE f006 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE f006 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE f006 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO f006 (idvid, vidname, datebeg, dateend) VALUES( :idvid, :vidname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDVID')
          mVidname := read_xml_stroke_1251_to_utf8(oXmlNode, 'VIDNAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mIDVID)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mVidname) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 09.05.22
Function make_f010(db, source)
  // KOD_TF,       "C",      2,      0  // Код ТФОМС
  // KOD_OKATO,     "C",    5,      0  // Код по ОКАТО (Приложение А O002).
  // SUBNAME,     "C",    254,      0  // Наименование субъекта РФ
  // OKRUG,     "N",        1,      0  // Код федерального округа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mKOD_TF, mKOD_OKATO, mSubname, mOkrug, d1, d2

  cmdText := 'CREATE TABLE f010(kod_tf TEXT(2), kod_okato TEXT(5), subname TEXT, okrug INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Классификатор субъектов Российской Федерации (Subekti)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f010') == SQLITE_OK
    OutStd('DROP TABLE f010 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE f010 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE f010 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO f010 (kod_tf, kod_okato, subname, okrug, datebeg, dateend) VALUES( :kod_tf, :kod_okato, :subname, :okrug, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mKOD_TF := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_TF')
          mKOD_OKATO := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_OKATO')
          mSubname := read_xml_stroke_1251_to_utf8(oXmlNode, 'SUBNAME')
          mOkrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'OKRUG')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_text(stmt, 1, mKOD_TF) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mKOD_OKATO) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mSubname) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 4, val(mOkrug)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 09.05.22
Function make_f011(db, source)
  // IDDoc,       "C",      2,      0  // Код типа документа
  // DocName,     "C",    254,      0  // Наименование типа документа
  // DocSer,     "C",    10,      0  // Маска серии документа
  // DocNum,     "C",      20,      0  // Маска номера документа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDDoc, mDocName, mDocSer, mDocNum, d1, d2

  cmdText := 'CREATE TABLE f011(iddoc TEXT(2), docname TEXT, docser TEXT(10), docnum TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F011.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Классификатор типов документов, удостоверяющих личность (Tipdoc)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f011') == SQLITE_OK
    OutStd('DROP TABLE f011 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE f011 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE f011 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO f011 (iddoc, docname, docser, docnum, datebeg, dateend) VALUES( :iddoc, :docname, :docser, :docnum, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDDoc := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDoc')
          mDocName := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocName')
          mDocSer := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocSer')
          mDocNum := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocNum')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_text(stmt, 1, mIDDoc) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDocName) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mDocSer) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mDocNum) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()

return nil

** 09.05.22
Function make_f014(db, source)

  // Kod,       "N",      3,      0  // Код ошибки
  // IDVID,     "N",    1,      0  // Код вида контроля, резервное поле
  // Naim,     "C",    1000,      0  // Наименование причины отказа
  // Osn,     "C",      20,      0  // Основание отказа
  // Komment,     "C",      100,      0  // Служебный комментарий
  // KodPG,     "C",      20,      0  // Код по форме N ПГ
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mKod, mIDVID, mNaim, mOsn, mKomment, mKodPG, d1, d2

  cmdText := 'CREATE TABLE f014(kod INTEGER, idvid INTEGER, naim BLOB, osn TEXT(20), komment BLOB, kodpg TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F014.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Классификатор причин отказа в оплате медицинской помощи (OplOtk)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f014') == SQLITE_OK
    OutStd('DROP TABLE f014 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE f014 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE f014 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO f014 (kod, idvid, naim, osn, komment, kodpg, datebeg, dateend) VALUES( :kod, :idvid, :naim, :osn, :komment, :kodpg, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mKod := read_xml_stroke_1251_to_utf8(oXmlNode, 'Kod')
          mIDVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDVID')
          mNaim := read_xml_stroke_1251_to_utf8(oXmlNode, 'Naim')
          mOsn := read_xml_stroke_1251_to_utf8(oXmlNode, 'Osn')
          mKomment := read_xml_stroke_1251_to_utf8(oXmlNode, 'Komment')
          mKodPG := read_xml_stroke_1251_to_utf8(oXmlNode, 'KodPG')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mKod)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 2, val(mIDVID)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mNaim) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mOsn) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, mKomment) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, mKodPG) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 7, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 8, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
return nil
