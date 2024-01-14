#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

static textBeginTrans := 'BEGIN TRANSACTION;'
static textCommitTrans := 'COMMIT;'

// 17.01.23
function make_V0xx(db, source)

  // make_V002(db, source)

  // make_V009(db, source)
  // make_V010(db, source)
  // make_V012(db, source)
  // make_V015(db, source)
  // make_V016(db, source)
  // make_V017(db, source)
  // make_V018(db, source)
  // make_V019(db, source)
  // make_V020(db, source)
  // make_V021(db, source)
  // make_V022(db, source)
  // make_V024(db, source)
  // make_V025(db, source)

  make_V030(db, source)
  // make_V031(db, source)
  // make_V032(db, source)
  // make_V033(db, source)
  // make_v036(db, source)

  return nil

// 10.01.23
Function make_V009(db, source)
  // IDRMP,     "N",   3, 0  // ��� ���������� ���������
  // RMPNAME,   "C", 254, 0  // ������������ ���������� ���������
  // DL_USLOV,  "N",   2, 0  // ������������� �������� �������� ����������� ������ (V006)
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDRMP, mRmpname, mDL_USLOV, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v009(idrmp INTEGER, rmpname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V009.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����������� ��������� �� ����������� ������� (Rezult)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v009') == SQLITE_OK
    OutStd('DROP TABLE v009 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v009 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v009 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v009 (idrmp, rmpname, dl_uslov, datebeg, dateend) VALUES( :idrmp, :rmpname, :dl_uslov, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDRMP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDRMP')
          mRmpname := read_xml_stroke_1251_to_utf8(oXmlNode, 'RMPNAME')
          mDL_USLOV := read_xml_stroke_1251_to_utf8(oXmlNode, 'DL_USLOV')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDRMP)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mRmpname) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mDL_USLOV)) == SQLITE_OK .AND. ;
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
  
// 10.01.23
Function make_v010(db, source)
  // IDSP,       "N",      2,      0  // ��� ������� ������ ����������� ������
  // SPNAME,     "C",    254,      0  // ������������ ������� ������ ����������� ������
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDSP, mSpname, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v010(idsp INTEGER, spname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� �������� ������ ����������� ������ (Sposob)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v010') == SQLITE_OK
    OutStd('DROP TABLE v010 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v010 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v010 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v010 (idsp, spname, datebeg, dateend) VALUES( :idsp, :spname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDSP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDSP')
          mSpname := read_xml_stroke_1251_to_utf8(oXmlNode, 'SPNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDSP)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mSpname) == SQLITE_OK .AND. ;
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

// 10.01.23
Function make_V012(db, source)
  // IDIZ,      "N",   3, 0  // ��� ������ �����������
  // IZNAME,    "C", 254, 0  // ������������ ������ �����������
  // DL_USLOV,  "N",   2, 0  // ������������� �������� �������� �� (V006)
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDIZ, mIzname, mDL_USLOV, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v012(idiz INTEGER, izname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V012.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ������� ����������� (Ishod)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v012') == SQLITE_OK
    OutStd('DROP TABLE v012 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v012 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v012 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v012 (idiz, izname, dl_uslov, datebeg, dateend) VALUES( :idiz, :izname, :dl_uslov, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDIZ := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDIZ')
          mIzname := read_xml_stroke_1251_to_utf8(oXmlNode, 'IZNAME')
          mDL_USLOV := read_xml_stroke_1251_to_utf8(oXmlNode, 'DL_USLOV')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDIZ)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mIzname) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mDL_USLOV)) == SQLITE_OK .AND. ;
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
  
// 10.01.23
Function make_V015(db, source)
  // RECID,  "N",    3,      0      // ����� ������
  // CODE,   "N",    4,      0      // ��� �������������
  // NAME,   "C",  254,      0      // ������������ �������������
  // HIGH,   "N",    4,      0      // �������������� (��������)
  // OKSO,   "N",    3,      0      // �������� ����
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0 // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mRecid, mCode, mName, mHigh, mOKSO, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v015(recid INTEGER, code INTEGER, name TEXT, high TEXT(4), okso TEXT(3), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����������� �������������� (Medspec)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v015') == SQLITE_OK
    OutStd('DROP TABLE v015 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v015 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v015 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v015 (recid, code, name, high, okso, datebeg, dateend) VALUES( :recid, :code, :name, :high, :okso, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mRecid := read_xml_stroke_1251_to_utf8(oXmlNode, 'RECID')
          mCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE')
          mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')
          mHigh := read_xml_stroke_1251_to_utf8(oXmlNode, 'HIGH')
          mOKSO := read_xml_stroke_1251_to_utf8(oXmlNode, 'OKSO')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mRecid)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 2, val(mCode)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mName) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mHigh) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, mOKSO) == SQLITE_OK .AND. ;
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
  return nil
  
// 10.01.23
Function make_V016(db, source)
  // IDDT,     "C",        3,      0 // ��� ���� ���������������
  // DTNAME,   "C",      254,      0 // ������������ ���� ���������������
  // RULE,     "N",        2,      0 // �������� ���������� ��������������� (����������� � ������������ � ��������������� V017)
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0 // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDDT, mDTNAME, mRule, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v016(iddt TEXT(3), dtname TEXT, rule TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����� ��������������� (DispT)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v016') == SQLITE_OK
    OutStd('DROP TABLE v016 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v016 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v016 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v016 (iddt, dtname, rule, datebeg, dateend) VALUES( :iddt, :dtname, :rule, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDDT := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDT')
          mDTNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'DTNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          mRule := ''
          if (oNode1 := oXmlNode:Find('DTRULE')) != NIL
            for j1 := 1 TO Len( oNode1:aItems )
              oNode2 := oNode1:aItems[j1]
              if 'RULE' == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1]) == 'C'
                mRule := mRule + iif(empty(mRule), '', ',') + alltrim(oNode2:aItems[1])
              endif
            next
          endif
  
          if sqlite3_bind_text(stmt, 1, mIDDT) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDTNAME) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mRule) == SQLITE_OK .AND. ;
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
  
// 10.01.23
Function make_V017(db, source)
  // IDDR,     "N",        2,      0 // ��� ���������� ���������������
  // DRNAME,   "C",      254,      0 // ������������ ���������� ���������������
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0 // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDDR, mDRNAME, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v017(iddr INTEGER, drname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����������� ��������������� (DispR)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v017') == SQLITE_OK
    OutStd('DROP TABLE v017 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v017 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v017 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v017 (iddr, drname, datebeg, dateend) VALUES( :iddr, :drname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDDR := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDR')
          mDRNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'DRNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDDR)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDRNAME) == SQLITE_OK .AND. ;
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
  
// 10.01.23
Function make_V018(db, source)
  // IDHVID,     "C",     12,      0 // ��� ���� ������������������� ����������� ������
  // HVIDNAME,   "C",   1000,      0 // ������������ ���� ������������������� ����������� ������
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0 // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDHVID, mHVIDNAME, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v018(idhvid TEXT(12), hvidname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V018.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����� ������������������� ����������� ������ (HVid)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v018') == SQLITE_OK
    OutStd('DROP TABLE v018 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v018 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v018 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v018 (idhvid, hvidname, datebeg, dateend) VALUES( :idhvid, :hvidname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDHVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDHVID')
          mHVIDNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'HVIDNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_text(stmt, 1, mIDHVID) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mHVIDNAME) == SQLITE_OK .AND. ;
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
  
// 10.01.23
Function make_V019(db, source)
  // IDHM,       "N",      4,      0 // ������������� ������ ������������������� ����������� ������
  // HMNAME,     "C",   1000,      0; // ������������ ������ ������������������� ����������� ������
  // DIAG,       "C",   1000,      0 // ������� ������ ����� �������� �� ��� ��� ������� ������; ����������� ����� ����������� ";".
  // HVID,       "C",     12,      0 // ��� ���� ������������������� ����������� ������ ��� ������� ������
  // HGR,        "N",      3,      0 // ����� ������ ������������������� ����������� ������ ��� ������� ������
  // HMODP,      "C",   1000,      0 // ������ �������� ��� ������� ������������������� ����������� ������ � ����������� ���������� ���� "HMNAME". �� �����������, ������� � ������ 3.0
  // IDMODP,     "N",      5,      0 // ������������� ������ �������� ��� ������� ������ (������� � ������ 3.0, ����������� ��������� ���� IDMPAC �������������� V022)
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0 // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDHM, mHMNAME, mDIAG, mHVID, mHGR, mHMODP, mIDMODP, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v019(idhm INTEGER, hmname BLOB, diag BLOB, hvid TEXT(12), hgr INTEGER, hmodp BLOB, idmodp INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V019.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ������� ������������������� ����������� ������ (HMet)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v019') == SQLITE_OK
    OutStd('DROP TABLE v019 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v019 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v019 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v019 (idhm, hmname, diag, hvid, hgr, hmodp, idmodp, datebeg, dateend) VALUES( :idhm, :hmname, :diag, :hvid, :hgr, :hmodp, :idmodp, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDHM := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDHM')
          mHMNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'HMNAME')
          mDIAG := read_xml_stroke_1251_to_utf8(oXmlNode, 'DIAG')
          mHVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'HVID')
          mHGR := read_xml_stroke_1251_to_utf8(oXmlNode, 'HGR')
          mHMODP := read_xml_stroke_1251_to_utf8(oXmlNode, 'HMODP')
          mIDMODP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDMODP')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDHM)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mHMNAME) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mDIAG) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mHVID) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 5, val(mHGR)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, mHMODP) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 7, val(mIDMODP)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 8, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 9, d2) == SQLITE_OK
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
  return NIL

// 10.01.23
Function make_V020(db, source)
  // IDK_PR,     "N",      3,      0 // ��� ������� �����
  // K_PRNAME,   "C",    254,      0 // ������������ ������� �����
  // DATEBEG,    "D",      8,      0 // ���� ������ �������� ������
  // DATEEND,    "D",      8,      0  // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDK_PR, mK_PRNAME, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v020(idk_pr INTEGER, k_prname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V020.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ������� ����� (KoPr)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v020') == SQLITE_OK
    OutStd('DROP TABLE v020 - Ok' + hb_eol())
  endif
 
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v020 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v020 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v020 (idk_pr, k_prname, datebeg, dateend) VALUES( :idk_pr, :k_prname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDK_PR := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDK_PR')
          mK_PRNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'K_PRNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDK_PR)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mK_PRNAME) == SQLITE_OK .AND. ;
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
  return NIL

// 10.01.23
Function make_V021(db, source)
  // IDSPEC,     "N",      3,      0  // ��� �������������
  // SPECNAME,   "C", 254             // ������������ �������������
  // POSTNAME,   "C",    400,      0  // ������������ ���������
  // IDPOST_MZ,   "C",    4,      0  // ��� ��������� � ������������ � ��� ��������� ������ (OID 1.2.643.5.1.13.13.11.1002)
  // DATEBEG,   "D",   8, 0           // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0           // ���� ��������� �������� ������
  
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDSPEC, mSPECNAME, mPOSTNAME, mIDPOST_MZ, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v021(idspec INTEGER, specname BLOB, postname BLOB, idpost_mz TEXT(4), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V021.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����������� �������������� (����������) (MedSpec)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v021') == SQLITE_OK
    OutStd('DROP TABLE v021 - Ok' + hb_eol())
  endif
   
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v021 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v021 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v021 (idspec, specname, postname, idpost_mz, datebeg, dateend) VALUES( :idspec, :specname, :postname, :idpost_mz, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDSPEC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDSPEC')
          mSPECNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'SPECNAME')
          mPOSTNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'POSTNAME')
          mIDPOST_MZ := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPOST_MZ')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDSPEC)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mSPECNAME) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mPOSTNAME) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mIDPOST_MZ) == SQLITE_OK .AND. ;
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

// 17.01.23
Function make_V022(db, source)
  // IDMPAC,     "N",      5,      0  //  ������������� ������ ��������
  // MPACNAME,   "M",     10,      0  // ������������ ������ ��������
  // DATEBEG,   "D",   8, 0           // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0           // ���� ��������� �������� ������
  
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDMPAC, mMPACNAME, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v022(idmpac INTEGER, mpacname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V022.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ������� �������� ��� �������� ������������������� ����������� ������ (ModPac)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v022') == SQLITE_OK
    OutStd('DROP TABLE v022 - Ok' + hb_eol())
  endif
   
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v022 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v022 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v022 (idmpac, mpacname, datebeg, dateend) VALUES( :idmpac, :mpacname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDMPAC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDMPAC')
          mMPACNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'MPACNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          if d1_1 >= 0d20210101 .or. Empty(d2_1)  //0d20210101

            Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
            d1 := hb_ValToStr(d1_1)
            d2 := hb_ValToStr(d2_1)

            if sqlite3_bind_int(stmt, 1, val(mIDMPAC)) == SQLITE_OK .AND. ;
              sqlite3_bind_text(stmt, 2, mMPACNAME) == SQLITE_OK .AND. ;
              sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
              sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
              if sqlite3_step(stmt) != SQLITE_DONE
                out_error(TAG_ROW_INVALID, nfile, j)
              endif
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

// 10.01.23
Function make_V025(db, source)
  // IDPC,      "C",   3, 0  // ��� ���� ���������
  // N_PC,      "C", 254, 0  // ������������ ���� ���������
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDPC, mN_PC, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v025(idpc TEXT(3), n_pc BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V025.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� ����� ��������� (KPC)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v025') == SQLITE_OK
    OutStd('DROP TABLE v025 - Ok' + hb_eol())
  endif
   
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v025 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v025 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty(oXmlDoc:aItems)
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v025 (idpc, n_pc, datebeg, dateend) VALUES( :idpc, :n_pc, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDPC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPC')
          mN_PC := read_xml_stroke_1251_to_utf8(oXmlNode, 'N_PC')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_text(stmt, 1, mIDPC) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mN_PC) == SQLITE_OK .AND. ;
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

// 13.01.24
Function make_V030(db, source)
  // SCHEMCOD,  "C",   5, 0  // 
  // SCHEME,    "C",  15, 0  //
  // DEGREE,    "N",   2, 0  //
  // COMMENT,   "M",  10, 0  //
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mSchemCode, mScheme, mDegree, mComment, d1, d2, d1_1, d2_1
  local strD_End

  cmdText := 'CREATE TABLE v030(schemcode TEXT(5), scheme TEXT(15), degree INTEGER, comment BLOB, datebeg TEXT(10), dateend TEXT(10), '
  cmdText += 'FOREIGN KEY(degree) REFERENCES Severity(id))'

  nameRef := 'V030.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ����� ������� ����������� COVID-19 (TreatReg)' + hb_eol())
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
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          strD_End := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
          // d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          if empty( strD_End )
            d2_1 := ctod('01.01.2222')
          else
            d2_1 := ctod(strD_End)
          endif
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

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

// 10.01.23
Function make_V031(db, source)
  // DRUGCODE,  "N",   2, 0  // 
  // DRUGGRUP,  "C",  50, 0  //
  // INDMNN,    "N",   2, 0  // ������� �������������� �������� ��� (1-��, 0-���)
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mDrugCode, mDrugGrup, mIndMNN, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v031(drugcode INTEGER, druggrup TEXT, indmnn INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V031.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������ ���������� ��� ������� ����������� COVID-19 (GroupDrugs)' + hb_eol())
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
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

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

// 10.01.23
Function make_V032(db, source)
  // SCHEDRUG,  "C",  10, 0  // ��������� ����� ������� � ������ ����������
  // NAME,      "C", 100, 0  //
  // SCHEMCODE,  "C",   5, 0  //
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0  // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mScheDrug, mName, mSchemCode, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v032(schedrug TEXT(10), name TEXT, schemcode TEXT(5), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V032.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ��������� ����� ������� � ������ ���������� (CombTreat)' + hb_eol())
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
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
            
          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

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

// 10.01.23
Function make_V033(db, source)
  // SCHEDRUG,  "C",  10, 0  // 
  // DRUGCODE,  "C",   6, 0  //
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mScheDrug, mDrugCode, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v033(schedrug TEXT(10), drugcode TEXT(6), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V033.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������ ���� ��������� ����� ������� (DgTreatReg)' + hb_eol())
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
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
  
          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

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

// 10.01.23
Function make_V036(db, source)
  // S_CODE    "C",  16, 0
  // NAME",      "C", 150, 0
  // "PARAM",     "N",   1, 0
  // "COMMENT",   "C",  20, 0
  // "DATEBEG",   "D",   8, 0 ���� ������ �������� ������
  // "DATEEND",   "D",   8, 0 ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mS_Code, mName, mParam, mComment, d1, d2, d1_1, d2_1
  // local mDATEBEG, mDATEEND

  cmdText := 'CREATE TABLE v036( s_code TEXT(16), name BLOB, param INTEGER, comment TEXT, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'V036.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - �������� �����, ��������� ����������� ����������� ������� (ServImplDv)' + hb_eol())
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
          // mDATEBEG := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // mDATEEND := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)
          
          if sqlite3_bind_text(stmt, 1, mS_Code) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mName) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mParam)) == SQLITE_OK .AND. ;
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

// 09.05.22
Function make_V002(db, source)
  // IDPR,       "N",      3,      0  // ��� ������� ����������� ������
  // PRNAME,     "C",    350,      0  // ������������ ������� ����������� ������
  // DATEBEG,   "D",   8, 0  // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0   // ���� ��������� �������� ������

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDPR, mPrname, d1, d2, d1_1, d2_1

  cmdText := 'CREATE TABLE v002(idpr INTEGER, prname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - ������������� �������� ��������� ����������� ������ (ProfOt)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v002') == SQLITE_OK
    OutStd('DROP TABLE v002 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE v002 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE v002 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO v002 (idpr, prname, datebeg, dateend) VALUES( :idpr, :prname, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mIDRP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPR')
          mPrname := read_xml_stroke_1251_to_utf8(oXmlNode, 'PRNAME')
          // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
          d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
          d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          if sqlite3_bind_int(stmt, 1, val(mIDRP)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mPrname) == SQLITE_OK .AND. ;
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

// 25.09.23
Function make_V024(db, source)
  // IDDKK,     "C",  10,      0  //  ������������� ������ ��������
  // DKKNAME,   "C", 255,      0  // ������������ ������ ��������
  // DATEBEG,   "D",   8, 0           // ���� ������ �������� ������
  // DATEEND,   "D",   8, 0           // ���� ��������� �������� ������
  
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mIDDKK, mDkkname, d1, d2, d1_1, d2_1
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'V024.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - ������������� ����������������� ��������� (DopKr)' + hb_eol())
  cmdText := 'CREATE TABLE v024(iddkk TEXT(10), dkkname BLOB, datebeg TEXT(19), dateend TEXT(19))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDDKK := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDKK')
        mDkkname := read_xml_stroke_1251_to_utf8(oXmlNode, 'DKKNAME')
        // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG') + ' 00:00:00'
        // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND') + ' 00:00:00'

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := iif(empty(d1_1), '', hb_ValToStr(d1_1) + ' 00:00:00')
        d2 := iif(empty(d2_1), '2222-01-01 00:00:00', hb_ValToStr(d2_1) + ' 00:00:00')


        count++
        cmdTextInsert += 'INSERT INTO v024(iddkk, dkkname, datebeg, dateend) VALUES(' ;
            + "'" + mIDDKK + "'," ;
            + "'" + mDkkname + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()

  return nil
