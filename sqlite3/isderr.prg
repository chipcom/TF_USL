// Справочник ошибок ИСОМП вида ISDErr_YYYY_MM_DD.xml

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 26.12.22
function make_ISDErr(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local code, name, name_f

  // CODE, Целочисленный(3),	Код ошибки
  // NAME, Строчный(250),	Наименование ошибки
  // NAME_F, Строчный(250), Дополнительная информация об ошибке
  // DATEBEG, Строчный(10),	Дата начала действия записи
  // DATEEND, Строчный(10),	Дата окончания действия записи
  // cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250), name_f TEXT(250))'
  cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250))'

  nameRef := 'ISDErr.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Справочник ошибок ИСОМПД (Т012)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS isderr') == SQLITE_OK
    OutStd('DROP TABLE isderr - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE isderr - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE isderr - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)

  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := 'INSERT INTO isderr (code, name, name_f) VALUES(:code, :name, :name_f)'
    cmdText := 'INSERT INTO isderr (code, name) VALUES(:code, :name)'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          code := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE')
          name := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')
          // name_f := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME_F')

          if sqlite3_bind_int(stmt, 1, val(code)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, name) == SQLITE_OK // .AND. ;
            // sqlite3_bind_text(stmt, 3, name_f) == SQLITE_OK
            IF sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif

  out_obrabotka_eol()
  return nil
