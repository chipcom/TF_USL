#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 06.05.22
function make_V0xx(db, source)

  make_V033(db, source)
  // make_v036(db, source)

  return nil

** 07.05.22
Function make_V033(db, source)
  // SCHEDRUG,  "C",   5, 0  // 
  // DRUGCODE,  "C",   6, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mScheDrug, mDrugCode, d1, d2

  cmdText := 'CREATE TABLE v033(schedrug TEXT(5), drugcode TEXT(6), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V033.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Соответствие кода препарата схеме лечения (DgTreatReg)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS v033') == SQLITE_OK
    OutStd('DROP TABLE v033 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v033 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v033 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v033 (schedrug, drugcode, datebeg, dateend) VALUES( :schedrug, :drugcode, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
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
            IF sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
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
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS v036') == SQLITE_OK
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
    if ! Empty( stmt )
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