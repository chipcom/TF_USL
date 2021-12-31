/// ��ࠢ�筨�� ��������⢠ ��ࠢ���࠭���� ��

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

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