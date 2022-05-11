#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 11.05.22
function make_O0xx(db, source)

  make_O001(db, source)
  return nil

** 11.05.22
Function make_O001(db, source)
  // KOD,     "C",    3,      0
  // NAME11,  "C",  250,      0
  // NAME12", "C",  250,      0
  // ALFA2,   "C",    2,      0
  // ALFA3,   "C",    3,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  //  1 - NAME11(C)  2 - KOD(C)  3 - DATEBEG(D)  4 - DATEEND(D)  5 - ALFA2(C)  6 - ALFA3(C)
  // local _mo_O001 := {;
  //   {"KOD",     "C",    3,      0},;
  //   {"NAME11",  "C",   60,      0},;
  //   {"NAME12",  "C",   60,      0},;
  //   {"ALFA2",   "C",    2,      0},;
  //   {"ALFA3",   "C",    3,      0},;
  //   {"DATEBEG", "D",    8,      0},;
  //   {"DATEEND", "D",    8,      0};
  // }
  // local mName := '', mArr
  // local nfile, nameRef, j, k
  
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mKod, mName11, mName12, mAlfa2, mAlfa3, d1, d2
  local mArr

  cmdText := 'CREATE TABLE o001(kod TEXT(3), name11 TEXT, name12 TEXT, alfa2 TEXT(2), alfa3 TEXT(3), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'O001.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - Общероссийский классификатор стран мира (OKSM)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS o001') == SQLITE_OK
    OutStd('DROP TABLE o001 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE o001 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE o001 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO o001 (kod, name11, name12, alfa2, alfa3, datebeg, dateend) VALUES( :kod, :name11, :name12, :alfa2, :alfa3, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      d2 := ''
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mKod := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD')
          mArr := hb_ATokens(read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME11'), '^')
          if len(mArr) == 1
            mName11 := mArr[1]
            mName12 := ''
          else
            mName11 := mArr[1]
            mName12 := mArr[2]
          endif
          mAlfa2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'ALFA2')
          mAlfa3 := read_xml_stroke_1251_to_utf8(oXmlNode, 'ALFA3')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEUTV')

          if sqlite3_bind_text(stmt, 1, mKod) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mName11) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mName12) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mAlfa2) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, mAlfa3) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 7, d2) == SQLITE_OK
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


  // nameRef := "O001.xml"
  // nfile := source + nameRef
  // if ! hb_vfExists( nfile )
  //     out_error(FILE_NOT_EXIST, nfile)
  //     return nil
  //   endif
  //   if check_izm_file(nameRef, nfile)
  //     return nil
  //   endif
  //   dbcreate(destination + "_mo_o001", _mo_O001)
  //   use (destination + '_mo_O001') new alias O001
  //   oXmlDoc := HXMLDoc():Read(nfile)
  //   OutStd( nameRef + " - Общероссийский классификатор стран мира (OKSM)" + hb_eol() )
  //   IF Empty( oXmlDoc:aItems )
  //     out_error(FILE_READ_ERROR, nfile)
  //     CLOSE databases
  //     return nil
  //   else
  //     out_obrabotka(nfile)
  //     k := Len( oXmlDoc:aItems[1]:aItems )
  //     FOR j := 1 TO k
  //       oXmlNode := oXmlDoc:aItems[1]:aItems[j]
  //       if "ZAP" == upper(oXmlNode:title)
  //         out_obrabotka_count(j, k)
  //         select O001
  //         append blank
  //         mArr := hb_ATokens( mo_read_xml_stroke(oXmlNode,"NAME11",), '^' )
  //         O001->KOD := mo_read_xml_stroke(oXmlNode,"KOD",)
  //         if len(mArr) == 1
  //           O001->NAME11 := mArr[1]
  //         else
  //           O001->NAME11 := mArr[1]
  //           O001->NAME12 := mArr[2]
  //         endif
  //         O001->ALFA2 := mo_read_xml_stroke(oXmlNode,"ALFA2",)
  //         O001->ALFA3 := mo_read_xml_stroke(oXmlNode,"ALFA3",)
  //         O001->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
  //         O001->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
      
  //       endif
  //     NEXT j
  //   ENDIF
  //   out_obrabotka_eol()
  //   close databases
  //   return nil
