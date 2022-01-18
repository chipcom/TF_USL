/// ��ࠢ�筨�� ��������⢠ ��ࠢ���࠭���� ��

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 04.01.22
function make_severity()

  local _mo_severity := {;
    {"ID",      "N",  5, 0},;  // �����᫥���, 㭨����� �����䨪���, �������� ���祭�� ? 楫� �᫠ �� 1 �� 6
    {"NAME",    "C", 40, 0},;  // ������ ��������, �����, ��易⥫쭮� ����, ⥪�⮢� �ଠ�;
    {"SYN",     "C", 40, 0},;  // ��������, �����, ᨭ����� �ନ��� �ࠢ�筨��, ⥪�⮢� �ଠ�;
    {"SCTID",   "N", 10, 0},;  // ��� SNOMED CT , �����, ᮮ⢥�����騩 ��� ������������;
    {"SORT",    "N",  2, 0};  // ����஢�� , �����᫥���, �ਢ������ ������ � ���浪���� 誠�� ��� 㯮�冷稢���� �ନ��� �ࠢ�筨�� �� ����� ������ � ����� �殮��� �⥯��� �殮�� ���ﭨ�, 楫�� �᫮ �� 1 �� 7;
  }

  dbcreate("_mo_severity", _mo_severity)
  use _mo_severity new alias SEV
  nfile := "1.2.643.5.1.13.13.11.1006_2.3.xml"  // ����� �������� ��-�� ���ᨩ
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1006.xml - �⥯��� �殮�� ���ﭨ� ��樥��"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            @ row(), 50 say str(j1 / k1 * 100, 6, 2) + "%"
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
            mSYN := mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8')
            mSCTID := mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8')
            mSort := mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8')
            select SEV
            append blank
            SEV->ID := val(mID)
            SEV->NAME := mName
            SEV->SYN := mSYN
            SEV->SCTID := val(mSCTID)
            SEV->SORT := val(mSort)
          endif
        next j1
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 31.12.21
function make_implant()

  local _mo_impl := {;
    {"ID",      "N",  5, 0},;  // ��� , 㭨����� �����䨪��� �����
    {"RZN",     "N",  6, 0},;  // ��� ������� ᮣ��᭮ ����������୮�� �����䨪���� ��᧤ࠢ������
    {"PARENT",  "N",  5, 0},;  // ��� த�⥫�᪮�� �����
    {"NAME",    "C", 120, 0},;  // ������������ , ������������ ���� �������
    {"LOCAL",   "C",  80, 0},;  // ���������� , ���⮬��᪠� �������, � ���ன �⭮���� ���������� �/��� ����⢨� �������
    {"MATERIAL","C",  20, 0},;  // ���ਠ� , ⨯ ���ਠ��, �� ���ண� ����⮢���� �������
    {"METAL",   "L",   1, 0},;  // ��⠫� , �ਧ��� ������ ��⠫�� � �������
    {"ORDER",   "N",   4, 0};  // ���冷� ���஢��
  }

  dbcreate("_mo_impl", _mo_impl)
  use _mo_impl new alias IMPL
  nfile := "1.2.643.5.1.13.13.11.1079_2.2.xml"  // ����� �������� ��-�� ���ᨩ
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1079.xml - ���� ����樭᪨� �������, ��������㥬�� � �࣠���� 祫�����, � ���� ���ன�� ��� ��樥�⮢ � ��࠭�祭�묨 ����������ﬨ"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            @ row(), 50 say str(j1 / k1 * 100, 6, 2) + "%"
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mRZN := mo_read_xml_stroke(oNode1, 'RZN', , , 'utf8')
            mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
            mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
            mLocal := mo_read_xml_stroke(oNode1, 'LOCALIZATION', , , 'utf8')
            mMaterial := mo_read_xml_stroke(oNode1, 'MATERIAL', , , 'utf8')
            mMetal := mo_read_xml_stroke(oNode1, 'METAL', , , 'utf8')
            mOrder := mo_read_xml_stroke(oNode1, 'ORDER', , , 'utf8')
            select IMPL
            append blank
            IMPL->ID := val(mID)
            IMPL->RZN := val(mRZN)
            IMPL->PARENT := val(mParent)
            IMPL->NAME := mName
            IMPL->LOCAL := mLocal
            IMPL->MATERIAL := mMaterial
            IMPL->METAL := iif(upper(mMetal) == '��', .t., .f.)
            IMPL->ORDER := val(mOrder)
          endif
        next j1
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.01.22
Function make_method_inj()
  local _mo_method_inj := {;
    {"ID",        "N",   3, 0},;  // 㭨����� �����䨪���, ��易⥫쭮� ����, 楫�� �᫮
    {"NAME_RUS",  "C",  30, 0},;  // ���� �������� �� ���᪮� �몥
    {"NAME_ENG",  "C",  30, 0},;  // ���� �������� �� ������᪮� �몥
    {"PARENT",    "N",   3, 0},;  // த�⥫�᪨� 㧥� ������᪮�� �ࠢ�筨��, 楫�� �᫮
    {"TYPE",      "C",   1, 0};   // ⨯ �����: 'O' ��୥��� 㧥�, 'U' 㧥�, 'L' ������ �����
  }
  // {"CODE_EEC",  "C",  10, 0},;   // ��� �ࠢ�筨�� ॥��� ��� ����
  // {"CODE_EEC",  "C",  10, 0};   // ��� ����� �ࠢ�筨�� ॥��� ��� ����

  dbcreate("_mo_method_inj", _mo_method_inj)
  use _mo_method_inj new alias INJ
  nfile := "1.2.643.5.1.13.13.11.1468_2.1.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1468_2.1.xml     - ���ᮡ� �������� (MethIntro)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            @ row(), 50 say str(j1 / k1 * 100, 6, 2) + "%"
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mNameRus := mo_read_xml_stroke(oNode1, 'NAME_RUS', , , 'utf8')
            mNameEng := mo_read_xml_stroke(oNode1, 'NAME_ENG', , , 'utf8')
            mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
            select INJ
            append blank
            INJ->ID := val(mID)
            INJ->NAME_RUS := mNameRus
            INJ->NAME_ENG := mNameEng
            INJ->PARENT := val(mParent)
            if val(mParent) == 0
              INJ->TYPE := 'O'
            endif
          endif
        next j1
      endif
    NEXT j
  ENDIF

  INJ->(dbGoTop())
  do while ! INJ->(eof())
    fl_parent := .f.
    if INJ->PARENT == 0
      INJ->(dbSkip())
      continue
    endif

    rec_n := INJ->(recno())
    id_t := INJ->ID
    INJ->(dbGoTop())
    do while ! INJ->(eof())
      if INJ->PARENT == id_t
        fl_parent := .t.
        exit
      endif
      INJ->(dbSkip())
    enddo
    INJ->(dbGoto(rec_n))
    if fl_parent
      iNJ->TYPE := 'U'
    else
      iNJ->TYPE := 'L'
    endif
    INJ->(dbSkip())
  enddo
  close databases
  return NIL

***** 18.01.22
Function make_ed_izm()
  local _mo_ed_izm := {;
    {"ID",        "N",   3, 0},;  // �������� �����䨪��� ������� ����७�� ������୮�� ���, 楫�� �᫮
    {"FULLNAME",  "C",  40, 0},;  // ������ ������������, �����
    {"SHOTNAME",  "C",  25, 0},;  // ��⪮� ������������, �����;
    {"PRNNAME",   "C",  25, 0},;  // ������������ ��� ����, �����;
    {"MEASUR",    "C",  45, 0},;  // �����୮���, �����;
    {"UCUM",      "C",  15, 0},;  // ��� UCUM, �����;
    {"COEF",      "C",  15, 0},;  // �����樥�� ������, �����, �����樥�� ������ � ࠬ��� ����� ࠧ��୮��.;
    {"CONV_ID",   "N",   3, 0},;  // ��� ������� ����७�� ��� ������, �����᫥���, ��� ������� ����७��, � ������ �����⢫���� ������.;
    {"CONV_NAM",  "C",  25, 0},;  // ������ ����७�� ��� ������, �����, ��⪮� ������������ ������� ����७��, � ������ �����⢫���� ������.;
    {"OKEI_COD",  "N",   4, 0};    // ��� ����, �����, ���⢥�����騩 ��� �����ᨩ᪮�� �����䨪��� ������ ����७��.;
  }
  // {"NSI_EEC",  "C",  10, 0},;   // ��� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� �ࠢ�筨�� ॥��� ��� ����;
  // {"NSI_EL_EEC",  "C",  10, 0};   // ��� ����� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� ����� �ࠢ�筨�� ॥��� ��� ����;
  local rec_n, id_t, fl_parent := .f.

  dbcreate("_mo_ed_izm", _mo_ed_izm)
  use _mo_ed_izm new alias EDI
  nfile := "1.2.643.5.1.13.13.11.1358_3.3.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1358_3.3.xml     - ������� ����७�� (OID)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          if "ENTRY" == upper(oNode1:title)
            @ row(), 50 say str(j1 / k1 * 100, 6, 2) + "%"
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mFullName := mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'utf8')
            mShortName := mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'utf8')
            mPrintName := mo_read_xml_stroke(oNode1, 'PRINTNAME', , , 'utf8')
            mMeasure := mo_read_xml_stroke(oNode1, 'MEASUREMENT', , , 'utf8')
            mUCUM := mo_read_xml_stroke(oNode1, 'UCUM', , , 'utf8')
            mCoef := mo_read_xml_stroke(oNode1, 'COEFFICIENT', , , 'utf8')
            mConvID := mo_read_xml_stroke(oNode1, 'CONVERSION_ID', , , 'utf8')
            mConvName := mo_read_xml_stroke(oNode1, 'CONVERSION_NAME', , , 'utf8')
            mOKEI := mo_read_xml_stroke(oNode1, 'OKEI_CODE', , , 'utf8')

            select EDI
            append blank
            EDI->ID := val(mID)
            EDI->FULLNAME := mFullName
            EDI->SHOTNAME := mShortName
            EDI->PRNNAME := mPrintName
            EDI->MEASUR := mMeasure
            EDI->UCUM := mUCUM
            EDI->COEF := mCoef
            EDI->CONV_ID := val(mConvID)
            EDI->CONV_NAM := mConvName
            EDI->OKEI_COD := val(mOKEI)
          endif
        next j1
      endif
    NEXT j
  ENDIF
  close databases
  return NIL
