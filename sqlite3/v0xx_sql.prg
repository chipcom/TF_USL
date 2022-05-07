#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 06.05.22
function make_V0xx(db, source)

  make_V030(db, source)
  make_V031(db, source)
  make_V032(db, source)
  make_V033(db, source)
  // make_v036(db, source)

  return nil

** 07.05.22
Function make_V030(db, source)
  // SCHEMCOD,  "C",   5, 0  // 
  // SCHEME,    "C",  15, 0  //
  // DEGREE,    "N",   2, 0  //
  // COMMENT,   "M",  10, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mSchemCode, mScheme, mDegree, mComment, d1, d2

  cmdText := 'CREATE TABLE v030(schemcode TEXT(5), scheme TEXT(15), degree INTEGER, comment BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V030.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Схемы лечения заболевания COVID-19 (TreatReg)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE if EXISTS v030') == SQLITE_OK
    OutStd('DROP TABLE v030 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v030 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v030 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v030 (schemcode, scheme, degree, comment, datebeg, dateend) VALUES( :schemcode, :scheme, :degree, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mSchemCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'SchemCode')
          mScheme := read_xml_stroke_1251_to_utf8(oXmlNode, 'Scheme')
          mDegree := read_xml_stroke_1251_to_utf8(oXmlNode, 'DegreeSeverity')
          mComment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          if sqlite3_bind_text(stmt, 1, mSchemCode) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mScheme) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mDegree)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mComment) == SQLITE_OK .AND. ;
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

** 07.05.22
Function make_V031(db, source)
  // DRUGCODE,  "N",   2, 0  // 
  // DRUGGRUP,  "C",  50, 0  //
  // INDMNN,    "N",   2, 0  // Признак обязательности указания МНН (1-да, 0-нет)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mDrugCode, mDrugGrup, mIndMNN, d1, d2

  cmdText := 'CREATE TABLE v031(drugcode INTEGER, druggrup TEXT, indmnn INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V031.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE if EXISTS v031') == SQLITE_OK
    OutStd('DROP TABLE v031 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v031 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v031 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v031 (drugcode, druggrup, indmnn, datebeg, dateend) VALUES( :drugcode, :druggrup, :indmnn, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mDrugCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugGroupCode')
          mDrugGrup := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugGroup')
          mIndMNN := read_xml_stroke_1251_to_utf8(oXmlNode, 'ManIndMNN')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          if sqlite3_bind_int(stmt, 1, val(mDrugCode)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDrugGrup) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mIndMNN)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
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

** 07.05.22
Function make_V032(db, source)
  // SCHEDRUG,  "C",  10, 0  // Сочетание схемы лечения и группы препаратов
  // NAME,      "C", 100, 0  //
  // SCHEMCODE,  "C",   5, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0  // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mScheDrug, mName, mSchemCode, d1, d2

  cmdText := 'CREATE TABLE v032(schedrug TEXT(10), name TEXT, schemcode TEXT(5), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V032.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Сочетание схемы лечения и группы препаратов (CombTreat)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE if EXISTS v032') == SQLITE_OK
    OutStd('DROP TABLE v032 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v032 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v032 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v032 (schedrug, name, schemcode, datebeg, dateend) VALUES( :schedrug, :name, :schemcode, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mScheDrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'ScheDrugGrCd')
          mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'Name')
          mSchemCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'SchemCode')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          if sqlite3_bind_text(stmt, 1, mScheDrug) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mName) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mSchemCode) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
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

** 07.05.22
Function make_V033(db, source)
  // SCHEDRUG,  "C",  10, 0  // 
  // DRUGCODE,  "C",   6, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mScheDrug, mDrugCode, d1, d2

  cmdText := 'CREATE TABLE v033(schedrug TEXT(10), drugcode TEXT(6), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V033.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Соответствие кода препарата схеме лечения (DgTreatReg)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE if EXISTS v033') == SQLITE_OK
    OutStd('DROP TABLE v033 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v033 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v033 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v033 (schedrug, drugcode, datebeg, dateend) VALUES( :schedrug, :drugcode, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mScheDrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'ScheDrugGrCd')
          mDrugCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugCode')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
  
          if sqlite3_bind_text(stmt, 1, mScheDrug) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDrugCode) == SQLITE_OK .AND. ;
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

** 06.05.22
Function make_V036(db, source)
  // S_CODE    "C",  16, 0
  // NAME",      "C", 150, 0
  // "PARAM",     "N",   1, 0
  // "COMMENT",   "C",  20, 0
  // "DATEBEG",   "D",   8, 0 Дата начала действия записи
  // "DATEEND",   "D",   8, 0 Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mS_Code, mName, mParam, mComment, mDATEBEG, mDATEEND

  cmdText := 'CREATE TABLE v036( s_code TEXT(16), name BLOB, param INTEGER, comment TEXT, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'V036.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE if EXISTS v036') == SQLITE_OK
    OutStd('DROP TABLE v036 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v036 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v036 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v036 ( s_code, name, param, comment, datebeg, dateend ) VALUES( :s_code, :name, :param, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mS_Code := read_xml_stroke_1251_to_utf8(oXmlNode, 'S_CODE')
          mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')
          mParam := read_xml_stroke_1251_to_utf8(oXmlNode, 'Parameter')
          mComment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
          mDATEBEG := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          mDATEEND := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
  
          if sqlite3_bind_text(stmt, 1, mS_Code) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mName) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mParam)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mComment) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, mDATEBEG) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, mDATEEND) == SQLITE_OK
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