/// ��ࠢ�筨�� ��������⢠ ��ࠢ���࠭���� ��

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

function make_mzdrav( db, source )

  make_ed_izm( db, source)
  return nil

***** 22.04.22
Function make_ed_izm(db, source)
  LOCAL stmt
  local table_sql
  local oXmlNode, oNode1
  local nfile, nameRef
  local k, j, k1, j1
  local mID, mFullName, mShortName, mPrintName, mMeasure, mUCUM, mCoef, mConvID
  local mConvName, mOKEI
  local cdp := HB_SETCODEPAGE()


  table_sql := 'CREATE TABLE UnitOfMeasurement( id INTEGER, fullname TEXT(40), shortname TEXT(25) )'
  //   {"ID",        "N",   3, 0},;  // �������� �����䨪��� ������� ����७�� ������୮�� ���, 楫�� �᫮
  //   {"FULLNAME",  "C",  40, 0},;  // ������ ������������, �����
  //   {"SHOTNAME",  "C",  25, 0},;  // ��⪮� ������������, �����;

  sqlite3_exec( db, 'DROP TABLE UnitOfMeasurement' )
     
  if sqlite3_exec( db, table_sql ) == SQLITE_OK
     OutStd( hb_eol() + 'CREATE TABLE UnitOfMeasurement - Ok' + hb_eol() )
  endif

  nameRef := '1.2.643.5.1.13.13.11.1358.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - ������� ����७�� (OID)' + hb_eol() )
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    stmt := sqlite3_prepare( db, 'INSERT INTO UnitOfMeasurement ( id, fullname, shortname ) VALUES( :id, :fullname, :shortname )' )
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ENTRIES' == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if 'ENTRY' == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'UTF8')
              mFullName := hb_StrToUTF8(mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'UTF8'), cdp)
              mShortName := hb_StrToUTF8(mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'UTF8'), cdp)

              mPrintName := mo_read_xml_stroke(oNode1, 'PRINTNAME', , , 'utf8')
              mMeasure := mo_read_xml_stroke(oNode1, 'MEASUREMENT', , , 'utf8')
              mUCUM := mo_read_xml_stroke(oNode1, 'UCUM', , , 'utf8')
              mCoef := mo_read_xml_stroke(oNode1, 'COEFFICIENT', , , 'utf8')
              mConvID := mo_read_xml_stroke(oNode1, 'CONVERSION_ID', , , 'utf8')
              mConvName := mo_read_xml_stroke(oNode1, 'CONVERSION_NAME', , , 'utf8')
              mOKEI := mo_read_xml_stroke(oNode1, 'OKEI_CODE', , , 'utf8')
  
              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, mFullName ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 3, mShortName ) == SQLITE_OK
                      // sqlite3_bind_text( stmt, 2, hb_StrToUTF8(mFullName, cdp) ) == SQLITE_OK .AND. ;
                      // sqlite3_bind_text( stmt, 3, hb_StrToUTF8(mShortName, cdp) ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    // print_status_insert(db)
    out_obrabotka_eol()

  endif
  return nil

***** 22.04.22
function make_severity(db)
  LOCAL stmt
  local k, j, k1, j1
  local table_sql
  local oXmlNode, oNode1
  local mID, mName, mSYN, mSCTID, mSort

  table_sql := "CREATE TABLE Severity( id INTEGER, name TEXT(40) )"
  // table_sql := "CREATE TABLE Severity( id INTEGER, name TEXT(40), syn TEXT(40), sctid INTEGER, sort INTEGER )"
  // {"ID",      "N",  5, 0},;  // �����᫥���, 㭨����� �����䨪���, �������� ���祭�� ? 楫� �᫠ �� 1 �� 6
  // {"NAME",    "C", 40, 0},;  // ������ ��������, �����, ��易⥫쭮� ����, ⥪�⮢� �ଠ�;
  // {"SYN",     "C", 40, 0},;  // ��������, �����, ᨭ����� �ନ��� �ࠢ�筨��, ⥪�⮢� �ଠ�;
  // {"SCTID",   "N", 10, 0},;  // ��� SNOMED CT , �����, ᮮ⢥�����騩 ��� ������������;
  // {"SORT",    "N",  2, 0};  // ����஢�� , �����᫥���, �ਢ������ ������ � ���浪���� 誠�� ��� 㯮�冷稢���� �ନ��� �ࠢ�筨�� �� ����� ������ � ����� �殮��� �⥯��� �殮�� ���ﭨ�, 楫�� �᫮ �� 1 �� 7;

  sqlite3_exec( db, "DROP TABLE Severity" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE Severity - Ok"
  ENDIF

  nfile := "1.2.643.5.1.13.13.11.1006.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? '�訡�� � �⥭�� 䠩��', nfile
    wait 'Press any key'
  else
    ? "1.2.643.5.1.13.13.11.1006.xml - �⥯��� �殮�� ���ﭨ� ��樥�� (OID)"
    // stmt := sqlite3_prepare( db, "INSERT INTO Severity ( id, name, syn, sctid, sort ) VALUES( :id, :name, :syn, :sctid, :sort )" )
    stmt := sqlite3_prepare( db, "INSERT INTO Severity ( id, name ) VALUES( :id, :name )" )
    if ! Empty( stmt )
      ? "��ࠡ�⪠ 䠩�� " + nfile + " - "
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              @ row(), 52 say str(j1 / k1 * 100, 6, 2) + "%"
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              // mSYN := mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8')
              // mSCTID := mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8')
              // mSort := mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8')
  
              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, hb_StrToUTF8(mName, 'UTF8') ) == SQLITE_OK  // .AND. ;
                      // sqlite3_bind_text( stmt, 3, hb_StrToUTF8(mSYN, 'UTF8') ) == SQLITE_OK .AND. ;
                      // sqlite3_bind_text( stmt, 4, mSCTID ) == SQLITE_OK .AND. ;
                      // sqlite3_bind_text( stmt, 5, mSort ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  ? '�訡�� �� ����㧪� ��ப� - ', j
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    print_status_insert(db)

  endif
  return NIL

***** 22.04.22
function make_method_inj(db)
  LOCAL stmt
  local k, j, k1, j1
  local table_sql
  local oXmlNode, oNode1
  local mID, mNameRus, mNameEng, mParent, mType

  table_sql := "CREATE TABLE method_inj( id INTEGER, name_rus TEXT(30), name_eng TEXT(30), parent INTEGER, type TEXT(1) )"
  //   {"ID",        "N",   3, 0},;  // 㭨����� �����䨪���, ��易⥫쭮� ����, 楫�� �᫮
  //   {"NAME_RUS",  "C",  30, 0},;  // ���� �������� �� ���᪮� �몥
  //   {"NAME_ENG",  "C",  30, 0},;  // ���� �������� �� ������᪮� �몥
  //   {"PARENT",    "N",   3, 0},;  // த�⥫�᪨� 㧥� ������᪮�� �ࠢ�筨��, 楫�� �᫮
  //   {"TYPE",      "C",   1, 0};   // ⨯ �����: 'O' ��୥��� 㧥�, 'U' 㧥�, 'L' ������ �����
  sqlite3_exec( db, "DROP TABLE method_inj" )
     
  if sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE method_inj - Ok"
  endif

  nfile := "1.2.643.5.1.13.13.11.1468.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? '�訡�� � �⥭�� 䠩��', nfile
    wait 'Press any key'
  else
    ? "1.2.643.5.1.13.13.11.1468.xml - ���ᮡ� �������� (OID)"
    stmt := sqlite3_prepare( db, "INSERT INTO method_inj ( id, name_rus, name_eng, parent, type ) VALUES( :id, :name_rus, :name_eng, :parent, :type )" )
    if ! Empty( stmt )
      ? "��ࠡ�⪠ 䠩�� " + nfile + " - "
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              @ row(), 52 say str(j1 / k1 * 100, 6, 2) + "%"
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mNameRus := mo_read_xml_stroke(oNode1, 'NAME_RUS', , , 'utf8')
              mNameEng := mo_read_xml_stroke(oNode1, 'NAME_ENG', , , 'utf8')
              mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
              mType := iif(val(mParent) == 0, 'O', ' ')
  
              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, hb_StrToUTF8(mNameRus, 'UTF8') ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 3, hb_StrToUTF8(mNameEng, 'UTF8') ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 4, mParent ) == SQLITE_OK  .AND. ;
                      sqlite3_bind_text( stmt, 5, hb_StrToUTF8(mType, 'UTF8') ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  ? '�訡�� �� ����㧪� ��ப� - ', j
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    print_status_insert(db)
  endif

  stmt := 'UPDATE method_inj AS m1 SET TYPE = "L" FROM (SELECT * FROM method_inj AS m2 WHERE m1.id <> m2.PARENT )'
  if sqlite3_exec( db, stmt ) == SQLITE_OK
    ? 'UPDATE TABLE method_inj - Ok'
  else
    ? 'UPDATE TABLE method_inj - ERROR'
  endif

  // INJ->(dbGoTop())
  // do while ! INJ->(eof())
  //   fl_parent := .f.
  //   if INJ->PARENT == 0
  //     INJ->(dbSkip())
  //     continue
  //   endif

  //   rec_n := INJ->(recno())
  //   id_t := INJ->ID
  //   INJ->(dbGoTop())
  //   do while ! INJ->(eof())
  //     if INJ->PARENT == id_t
  //       fl_parent := .t.
  //       exit
  //     endif
  //     INJ->(dbSkip())
  //   enddo
  //   INJ->(dbGoto(rec_n))
  //   if fl_parent
  //     iNJ->TYPE := 'U'
  //   else
  //     iNJ->TYPE := 'L'
  //   endif
  //   INJ->(dbSkip())
  // enddo
  // close databases
  return nil

***** 22.04.22
function make_implant(db)
  local stmt
  local k, j, k1, j1
  local table_sql
  local oXmlNode, oNode1
  local mID, mName, mRZN, mParent, mType

  table_sql := 'CREATE TABLE implantant( id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), type TEXT(1) )'
  //   {"ID",      "N",  5, 0},;  // ��� , 㭨����� �����䨪��� �����
  //   {"RZN",     "N",  6, 0},;  // ��� ������� ᮣ��᭮ ����������୮�� �����䨪���� ��᧤ࠢ������
  //   {"PARENT",  "N",  5, 0},;  // ��� த�⥫�᪮�� �����
  //   {"NAME",    "C", 120, 0},;  // ������������ , ������������ ���� �������
  //   {"TYPE",    "C",   1, 0},;   // ⨯ �����: 'O' ��୥��� 㧥�, 'U' 㧥�, 'L' ������ �����
  ////   {"LOCAL",   "C",  80, 0},;  // ���������� , ���⮬��᪠� �������, � ���ன �⭮���� ���������� �/��� ����⢨� �������
  ////   {"MATERIAL","C",  20, 0},;  // ���ਠ� , ⨯ ���ਠ��, �� ���ண� ����⮢���� �������
  ////   {"METAL",   "L",   1, 0},;  // ��⠫� , �ਧ��� ������ ��⠫�� � �������
  ////   {"ORDER",   "N",   4, 0};  // ���冷� ���஢��
  sqlite3_exec( db, 'DROP TABLE implantant' )
     
  if sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? 'CREATE TABLE implantant - Ok'
  endif

  nfile := '1.2.643.5.1.13.13.11.1079.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? '�訡�� � �⥭�� 䠩��', nfile
    wait 'Press any key'
  else
    ? '1.2.643.5.1.13.13.11.1079.xml - ���� ����樭᪨� �������, ��������㥬�� � �࣠���� 祫�����, � ���� ���ன�� ��� ��樥�⮢ � ��࠭�祭�묨 ����������ﬨ (OID)'
    stmt := sqlite3_prepare( db, 'INSERT INTO implantant ( id, rzn, parent, name, type ) VALUES( :id, :rzn, :parent, :name, :type )' )
    if ! Empty( stmt )
      ? "��ࠡ�⪠ 䠩�� " + nfile + " - "
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              @ row(), 52 say str(j1 / k1 * 100, 6, 2) + "%"
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mRZN := mo_read_xml_stroke(oNode1, 'RZN', , , 'utf8')
              mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              mType := ' '
  
              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, mRZN ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 3, mParent ) == SQLITE_OK  .AND. ;
                      sqlite3_bind_text( stmt, 4, hb_StrToUTF8(mName, 'UTF8') ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 5, hb_StrToUTF8(mType, 'UTF8') ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  ? '�訡�� �� ����㧪� ��ப� - ', j
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    print_status_insert(db)
  endif


  // IMPL->(dbGoTop())
  // do while ! IMPL->(eof())
  //   fl_parent := .f.
  //   if IMPL->RZN == 0
  //     IMPL->(dbSkip())
  //     continue
  //   endif

  //   rec_n := IMPL->(recno())
  //   id_t := IMPL->ID
  //   IMPL->(dbGoTop())
  //   do while ! IMPL->(eof())
  //     if IMPL->PARENT == id_t
  //       fl_parent := .t.
  //       exit
  //     endif
  //     IMPL->(dbSkip())
  //   enddo
  //   IMPL->(dbGoto(rec_n))
  //   if fl_parent
  //     IMPL->TYPE := 'U'
  //   else
  //     IMPL->TYPE := 'L'
  //   endif
  //   IMPL->(dbSkip())
  // enddo
  // close databases
  return NIL

function print_status_insert(db)
  ? "������⢮ ���������� ��ப ���� ������: " + hb_ntos( sqlite3_changes( db ) )
  ? "�ᥣ� ���������: " + hb_ntos( sqlite3_total_changes( db ) )
  ? "��᫥���� _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
  ? ""
return nil