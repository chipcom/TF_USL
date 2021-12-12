/// ��ࠢ�筨�� �����

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 09.03.21
Function work_V002()  //_mo_V002)
  local _mo_V002 := {;
    {"IDPR",       "N",      3,      0},;
    {"PRNAME",     "C",    250,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo_v002",_mo_V002)
  use _mo_V002 new alias V002
  nfile := "V002.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V002.xml     - �����䨪��� ��䨫�� ��������� ����樭᪮� ����� (ProfOt)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mDATEEND := CToD('  /  /    ')
        mIDPR := mo_read_xml_stroke(oXmlNode,"IDPR",)
        mPRNAME := mo_read_xml_stroke(oXmlNode,"PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < stod(FIRST_DAY)  //0d20210101
        else
          select V002
          append blank
          V002->IDPR := val(mIDPR)
          V002->PRNAME := alltrim(mPRNAME)
          V002->DATEBEG := mDATEBEG
          V002->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 11.12.21
Function work_V016()
  local _mo_V016 := {;
    {"IDDT",      "C",   3, 0},;  // ��� ⨯� ��ᯠ��ਧ�樨
    {"DTNAME",    "C", 254, 0},;  // ������������ ⨯� ��ᯠ��ਧ�樨
    {"RULE",      "C",  40, 0},;  // ���祭�� १���� ��ᯠ��ਧ�樨 (ᯨ᮪) (V017)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }
  local mRULE := ''

  dbcreate("_mo_v016", _mo_V016)
  use _mo_v016 new alias V016
  nfile := "V016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V016.xml     - �����䨪��� ⨯�� ��ᯠ��ਧ�樨 (DispT)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDDT := mo_read_xml_stroke(oXmlNode,"IDDT",)
        mDTNAME := mo_read_xml_stroke(oXmlNode,"DTNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        mRULE := ''
        if (oNode1 := oXmlNode:Find("DTRULE")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "RULE" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              mRULE := mRULE + iif(empty(mRULE), '', ',') + alltrim(oNode2:aItems[1])
            endif
          next
        endif

        select V016
        append blank
        V016->IDDT := mIDDT
        V016->DTNAME := mDTNAME
        V016->RULE := mRULE
        V016->DATEBEG := mDATEBEG
        V016->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.12.21
Function work_V017()
  local _mo_V017 := {;
    {"IDDR",      "N",   2, 0},;  // ��� १���� ��ᯠ��ਧ�樨
    {"DRNAME",    "C", 254, 0},;  // ������������ १���� ��ᯠ��ਧ�樨
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v017", _mo_V017)
  use _mo_v017 new alias V017
  nfile := "V017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V017.xml     - �����䨪��� १���⮢ ��ᯠ��ਧ�樨 (DispR)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDDR := mo_read_xml_stroke(oXmlNode,"IDDR",)
        mDRNAME := mo_read_xml_stroke(oXmlNode,"DRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        select V017
        append blank
        V017->IDDR := val(mIDDR)
        V017->DRNAME := mDRNAME
        V017->DATEBEG := mDATEBEG
        V017->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 16.02.21
Function work_V021()  //_mo_V021)

  local _mo_V021 := {;
    {"IDSPEC",     "N",      3,      0},;
    {"SPECNAME",   "C",    250,      0},;
    {"POSTNAME",   "C",    250,      0},;
    {"IDPOST_MZ",  "C",      4,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo_v021",_mo_V021)
  use _mo_V021 new alias V021
  nfile := "V021.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V021.xml     - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (�������⥩) (MedSpec)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDSPEC := mo_read_xml_stroke(oXmlNode,"IDSPEC",)
        mSPECNAME := mo_read_xml_stroke(oXmlNode,"SPECNAME",)
        mPOSTNAME := mo_read_xml_stroke(oXmlNode,"POSTNAME",)
        mIDPOST_MZ := mo_read_xml_stroke(oXmlNode,"IDPOST_MZ",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < 0d20180101
        else
          select V021
          append blank
          V021->IDSPEC := val(mIDSPEC)
          V021->SPECNAME := alltrim(mSPECNAME)
          V021->POSTNAME := alltrim(mPOSTNAME)
          V021->IDPOST_MZ := alltrim(mIDPOST_MZ)
          V021->DATEBEG := mDATEBEG
          V021->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

* 15.02.21 ������ ���ᨢ �� �ࠢ�筨�� ॣ����� ����� V002.xml
function getV002()
  // V002.xml - 
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V002"
  local _v002 := {}

  dbUseArea( .t.,, exe_dir + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v002, { (dbName)->PRNAME, (dbName)->IDPR, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v002

***** 09.12.21
Function work_V009()
  local _mo_V009 := {;
    {"IDRMP",     "N",   3, 0},;  // ��� १���� ���饭��
    {"RMPNAME",   "C", 254, 0},;  // ������������ १���� ���饭��
    {"DL_USLOV",  "N",   2, 0},;  // ���⢥����� �᫮��� �������� ����樭᪮� ����� (V006)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v009", _mo_V009)
  use _mo_v009 new alias V009
  nfile := "V009.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V009.xml     - �����䨪��� १���⮢ ���饭�� �� ����樭᪮� ������� (Rezult)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDRMP := mo_read_xml_stroke(oXmlNode,"IDRMP",)
        mRMPNAME := mo_read_xml_stroke(oXmlNode,"RMPNAME",)
        mDL_USLOV := mo_read_xml_stroke(oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V009
        append blank
        V009->IDRMP := val(mIDRMP)
        V009->RMPNAME := mRMPNAME
        V009->DL_USLOV := val(mDL_USLOV)
        V009->DATEBEG := mDATEBEG
        V009->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 09.12.21
Function work_V010()
  local _mo_V010 := {;
    {"IDSP",      "N",   2, 0},;  // ��� ᯮᮡ� ������ ����樭᪮� �����
    {"SPNAME",    "C", 254, 0},;  // ������������ ᯮᮡ� ������ ����樭᪮� �����
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v010", _mo_V010)
  use _mo_v010 new alias V010
  nfile := "V010.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V010.xml     - �����䨪��� ᯮᮡ�� ������ ����樭᪮� ����� (Sposob)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDSP := mo_read_xml_stroke(oXmlNode,"IDSP",)
        mSPNAME := mo_read_xml_stroke(oXmlNode,"SPNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V010
        append blank
        V010->IDSP := val(mIDSP)
        V010->SPNAME := mSPNAME
        V010->DATEBEG := mDATEBEG
        V010->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 11.12.21
Function work_V012()
  local _mo_V012 := {;
    {"IDIZ",      "N",   3, 0},;  // ��� ��室� �����������
    {"IZNAME",    "C", 254, 0},;  // ������������ ��室� �����������
    {"DL_USLOV",  "N",   2, 0},;  // ���⢥����� �᫮��� �������� �� (V006)
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v012", _mo_V012)
  use _mo_v012 new alias V012
  nfile := "V012.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V012.xml     - �����䨪��� ��室�� ����������� (Ishod)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDIZ := mo_read_xml_stroke(oXmlNode,"IDIZ",)
        mIZNAME := mo_read_xml_stroke(oXmlNode,"IZNAME",)
        mDL_USLOV := mo_read_xml_stroke(oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V012
        append blank
        V012->IDIZ := val(mIDIZ)
        V012->IZNAME := mIZNAME
        V012->DL_USLOV := val(mDL_USLOV)
        V012->DATEBEG := mDATEBEG
        V012->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

* 16.02.21 ������ ���ᨢ �� �ࠢ�筨�� ����� V021.xml
function getV021()
  // V021.xml - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (��᫥����)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V021"
  local _v021 := {}

  dbUseArea( .t.,, exe_dir + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v021, { (dbName)->SPECNAME, (dbName)->IDSPEC, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v021

***** 15.08.21
Function work_V015()
  local _mo_V015 := {;
    {"NAME",   "C",    254,      0},;
    {"CODE",   "N",    4,      0},;
    {"HIGH",   "C",    4,      0},;
    {"OKSO",   "C",    3,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0},;
    {"RECID",     "N",     3,      0};
  }

  dbcreate("_mo_v015",_mo_V015)
  use _mo_V015 new alias V015
  nfile := "V015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V015.xml     - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (Medspec)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mRECID := mo_read_xml_stroke(oXmlNode,"RECID",)
        mCODE := mo_read_xml_stroke(oXmlNode,"CODE",)
        mNAME := mo_read_xml_stroke(oXmlNode,"NAME",)
        mHIGH := mo_read_xml_stroke(oXmlNode,"HIGH",)
        mOKSO := mo_read_xml_stroke(oXmlNode,"OKSO",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V015
        append blank
        V015->RECID := val(mRECID)
        V015->CODE := val(mCODE)
        V015->NAME := mNAME
        V015->HIGH := mHIGH
        V015->OKSO := mOKSO
        V015->DATEBEG := mDATEBEG
        V015->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL
  
***** 31.03.21
Function work_V018()
  local _mo_V018 := {;
    {"IDHVID",     "C",     12,      0},;
    {"HVIDNAME",   "C",    254,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"HVIDNAME",   "M",     10,      0},;

  dbcreate("_mo_v018",_mo_V018)
  use _mo_V018 new alias V018
  // index on kod to tmp_shema
  nfile := "V018.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V018.xml     - ���� ��᮪��孮����筮� ����樭᪮� ����� (HVid)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDHVID := mo_read_xml_stroke(oXmlNode,"IDHVID",)
        mHVIDNAME := mo_read_xml_stroke(oXmlNode,"HVIDNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V018
        append blank
        V018->IDHVID := mIDHVID
        V018->HVIDNAME := mHVIDNAME
        V018->DATEBEG := mDATEBEG
        V018->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL
  
***** 31.03.21
Function work_V019()
  local _mo_V019 := {;
    {"IDHM",       "N",      4,      0},; // �����䨪��� ��⮤� ��᮪��孮����筮� ����樭᪮� �����
    {"HMNAME",     "C",    254,      0},; // ������������ ��⮤� ��᮪��孮����筮� ����樭᪮� �����
    {"DIAG",       "C",    700,      0},; // ���孨� �஢�� ����� �������� �� ��� ��� ������� ��⮤�; 㪠�뢠���� �१ ࠧ����⥫� ";".
    {"HVID",       "C",     12,      0},; // ��� ���� ��᮪��孮����筮� ����樭᪮� ����� ��� ������� ��⮤�
    {"HGR",        "N",      3,      0},; // ����� ��㯯� ��᮪��孮����筮� ����樭᪮� ����� ��� ������� ��⮤�
    {"HMODP",      "C",    254,      0},; // ������ ��樥�� ��� ��⮤�� ��᮪��孮����筮� ����樭᪮� ����� � ��������묨 ���祭�ﬨ ���� "HMNAME". �� ����������, ��稭�� � ���ᨨ 3.0
    {"IDMODP",     "N",      5,      0},; // �����䨪��� ������ ��樥�� ��� ������� ��⮤� (��稭�� � ���ᨨ 3.0, ���������� ���祭��� ���� IDMPAC �����䨪��� V022)
    {"DATEBEG",    "D",      8,      0},; // ��� ��砫� ����⢨� �����
    {"DATEEND",    "D",      8,      0};  // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v019",_mo_V019)
  use _mo_V019 new alias V019
  nfile := "V019.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V019.xml     - ��⮤� ��᮪��孮����筮� ����樭᪮� ����� (HMet)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDHM := mo_read_xml_stroke(oXmlNode,"IDHM",)
        mHMNAME := mo_read_xml_stroke(oXmlNode,"HMNAME",)
        mDIAG := mo_read_xml_stroke(oXmlNode,"DIAG",)
        mHVID := mo_read_xml_stroke(oXmlNode,"HVID",)
        mHGR := mo_read_xml_stroke(oXmlNode,"HGR",)
        mHMODP := mo_read_xml_stroke(oXmlNode,"HMODP",)
        mIDMODP := mo_read_xml_stroke(oXmlNode,"IDMODP",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V019
        append blank
        V019->IDHM := val(mIDHM)
        V019->HMNAME := mHMNAME
        V019->DIAG := mDIAG
        V019->HVID := mHVID
        V019->HGR := val(mHGR)
        V019->HMODP := mHMODP
        V019->IDMODP := val(mIDMODP)
        V019->DATEBEG := mDATEBEG
        V019->DATEEND := mDATEEND
      
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 08.12.21
Function work_V020()
  local _mo_V020 := {;
    {"IDK_PR",     "N",      3,      0},; // ��� ��䨫� �����
    {"K_PRNAME",   "C",    254,      0},; // ������������ ��䨫� �����
    {"DATEBEG",    "D",      8,      0},; // ��� ��砫� ����⢨� �����
    {"DATEEND",    "D",      8,      0};  // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v020",_mo_V020)
  use _mo_v020 new alias V020
  nfile := "V020.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V020.xml     - �����䨪��� ��䨫� ����� (KoPr)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� " + nfile + " - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDK_PR := mo_read_xml_stroke(oXmlNode,"IDK_PR",)
        mK_PRNAME := mo_read_xml_stroke(oXmlNode,"K_PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V020
        append blank
        V020->IDK_PR := val(mIDK_PR)
        V020->K_PRNAME := mK_PRNAME
        V020->DATEBEG := mDATEBEG
        V020->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_V022()  //_mo_V022)
  local _mo_V022 := {;
    {"IDMPAC",     "N",      5,      0},;
    {"MPACNAME",   "C",   1250,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  
  dbcreate("_mo_v022",_mo_V022)
  use _mo_V022 new alias V022
  nfile := "V022.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V022.xml     - �����䨪��� ������� ��樥�� �� �������� ��᮪��孮����筮� ����樭᪮� ����� (ModPac)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDMPAC := mo_read_xml_stroke(oXmlNode,"IDMPAC",)
        mMPACNAME := mo_read_xml_stroke(oXmlNode,"MPACNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        if mDATEBEG >= stod(FIRST_DAY)  //0d20210101
          select V022
          append blank
          V022->IDMPAC := val(mIDMPAC)
          V022->MPACNAME := mMPACNAME
          V022->DATEBEG := mDATEBEG
          V022->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 04.12.21
Function work_V025()
  local _mo_V025 := {;
    {"IDPC",      "C",   3, 0},;  // ��� 楫� ���饭��
    {"N_PC",      "C", 254, 0},;  // ������������ 楫� ���饭��
    {"DATEBEG",   "D",   8, 0},;  // ��� ��砫� ����⢨� �����
    {"DATEEND",   "D",   8, 0};   // ��� ����砭�� ����⢨� �����
  }

  dbcreate("_mo_v025", _mo_V025)
  use _mo_V025 new alias V025
  // index on kod to tmp_shema
  nfile := "V025.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V025.xml     - �����䨪��� 楫�� ���饭�� (KPC)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        mIDPC := mo_read_xml_stroke(oXmlNode,"IDPC",)
        mN_PC := mo_read_xml_stroke(oXmlNode,"N_PC",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V025
        append blank
        V025->IDPC := mIDPC
        V025->N_PC := mN_PC
        V025->DATEBEG := mDATEBEG
        V025->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 21.02.21
Function make_Q015()

  local _mo_Q015 := {;
    {"KOD",       "C",     12,      0},;
    {"NAME",      "C",     60,      0},;
    {"NSI_OBJ",   "C",      4,      0},;
    {"NSI_EL",    "C",     20,      0},;
    {"USL_TEST",  "M",     10,      0},;
    {"VAL_EL",    "M",     10,      0},;
    {"COMMENT",   "M",     10,      0},;
    {"DATEBEG",   "D",      8,      0},;
    {"DATEEND",   "D",      8,      0};
  }

  dbcreate("_mo_q015",_mo_Q015)
  use _mo_Q015 new alias Q015
  nfile := "Q015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q015.xml     - ���祭� �孮�����᪨� �ࠢ�� ॠ����樨 ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (FLK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select Q015
        append blank
        Q015->KOD := mo_read_xml_stroke(oXmlNode,"ID_TEST",)
        Q015->NAME := mo_read_xml_stroke(oXmlNode,"ID_EL",)

        Q015->NSI_OBJ := mo_read_xml_stroke(oXmlNode,"NSI_OBJ",)
        Q015->NSI_EL := mo_read_xml_stroke(oXmlNode,"NSI_EL",)
        Q015->USL_TEST := mo_read_xml_stroke(oXmlNode,"USL_TEST",)
        Q015->VAL_EL := mo_read_xml_stroke(oXmlNode,"VAL_EL",)
        Q015->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q015->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q015->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 21.05.21
Function make_Q016()

  local _mo_Q016 := {;
    {"KOD",       "C",     12,      0},;
    {"NAME",      "C",     60,      0},;
    {"NSI_OBJ",   "C",      4,      0},;
    {"NSI_EL",    "C",     20,      0},;
    {"USL_TEST",  "M",     10,      0},;
    {"VAL_EL",    "M",     10,      0},;
    {"COMMENT",   "M",     10,      0},;
    {"DATEBEG",   "D",      8,      0},;
    {"DATEEND",   "D",      8,      0};
  }

  dbcreate("_mo_q016",_mo_Q016)
  use _mo_Q016 new alias Q016
  nfile := "Q016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q016.xml     - ���祭� �஢�ப ��⮬�⨧�஢����� �����প� ��� � �� ������� ���ᮭ���஢������ ��� ᢥ����� �� ��������� ����樭᪮� ����� (MEK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select Q016
        append blank
        Q016->KOD := mo_read_xml_stroke(oXmlNode,"ID_TEST",)
        Q016->NAME := mo_read_xml_stroke(oXmlNode,"DESC_TEST",)

        Q016->NSI_OBJ := mo_read_xml_stroke(oXmlNode,"NSI_OBJ",)
        Q016->NSI_EL := mo_read_xml_stroke(oXmlNode,"NSI_EL",)
        Q016->USL_TEST := mo_read_xml_stroke(oXmlNode,"USL_TEST",)
        Q016->VAL_EL := mo_read_xml_stroke(oXmlNode,"VAL_EL",)
        Q016->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q016->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q016->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 21.02.21
Function make_Q017()
  // Function work_Q017(_mo_Q017)

  local _mo_Q017 := {;
    {"ID_KTEST",   "C",      4,      0},;
    {"NAM_KTEST",  "C",    250,      0},;
    {"COMMENT",    "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo_q017",_mo_Q017)
  use _mo_Q017 new alias Q017
  nfile := "Q017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q017.xml     - ���祭� ��⥣�਩ �஢�ப ��� � ��� (TEST_K)"
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select Q017
        append blank
        Q017->ID_KTEST := mo_read_xml_stroke(oXmlNode,"ID_KTEST",)
        Q017->NAM_KTEST := mo_read_xml_stroke(oXmlNode,"NAM_KTEST",)
        Q017->COMMENT := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        Q017->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        Q017->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 21.02.21
Function make_O001()

    //  1 - NAME11(C)  2 - KOD(C)  3 - DATEBEG(D)  4 - DATEEND(D)  5 - ALFA2(C)  6 - ALFA3(C)
    local _mo_O001 := {;
    {"KOD",     "C",    3,      0},;
    {"NAME11",  "C",   60,      0},;
    {"NAME12",  "C",   60,      0},;
    {"ALFA2",   "C",    2,      0},;
    {"ALFA3",   "C",    3,      0},;
    {"DATEBEG", "D",    8,      0},;
    {"DATEEND", "D",    8,      0};
  }
  local mName := '', mArr

  dbcreate("_mo_o001",_mo_O001)
  use _mo_O001 new alias O001
  nfile := "O001.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "O001.xml     - �����ᨩ᪨� �����䨪��� ��࠭ ��� (OKSM) "
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select O001
        append blank
        mArr := hb_ATokens( mo_read_xml_stroke(oXmlNode,"NAME11",), '^' )
        O001->KOD := mo_read_xml_stroke(oXmlNode,"KOD",)
        if len(mArr) == 1
          O001->NAME11 := mArr[1]
        else
          O001->NAME11 := mArr[1]
          O001->NAME12 := mArr[2]
        endif
        O001->ALFA2 := mo_read_xml_stroke(oXmlNode,"ALFA2",)
        O001->ALFA3 := mo_read_xml_stroke(oXmlNode,"ALFA3",)
        O001->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        O001->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 04.03.21
Function make_F006()

  //  1 - VIDNAME(C)  2 - IDVID(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local _mo_F006 := {;
    { 'IDVID',      'N',    2,      0 },;
    { 'VIDNAME',    'M',   10,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr

  dbcreate('_mo_f006',_mo_F006)
  use _mo_f006 new alias F006
  nfile := 'F006.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F006.xml     - �����䨪��� ����� ����஫� (VidExp)'
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select F006
        append blank
        F006->IDVID := val(mo_read_xml_stroke(oXmlNode, 'IDVID',))
        F006->VIDNAME := mo_read_xml_stroke(oXmlNode, 'VIDNAME',)
        F006->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F006->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.03.21
Function make_F010()

  //  1 - SUBNAME(C) 2 - KOD_TF(N)  3 - OKRUG(N)  4 - KOD_OKATO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F010 := {;
    { 'KOD_TF',     'C',    2,      0 },;
    { 'KOD_OKATO',  'C',    5,      0 },;
    { 'SUBNAME',    'C',  250,      0 },;
    { 'OKRUG',      'N',    1,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr

  dbcreate('_mo_f010',_mo_F010)
  use _mo_F010 new alias F010
  nfile := 'F010.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F010.xml     - �����䨪��� ��ꥪ⮢ ���ᨩ᪮� �����樨 (Subekti)'
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select F010
        append blank
        F010->KOD_TF := mo_read_xml_stroke(oXmlNode, 'KOD_TF',)
        F010->KOD_OKATO := mo_read_xml_stroke(oXmlNode, 'KOD_OKATO',)
        F010->SUBNAME := mo_read_xml_stroke(oXmlNode, 'SUBNAME',)
        F010->OKRUG := val(mo_read_xml_stroke(oXmlNode, 'OKRUG',))
        F010->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F010->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 04.03.21
Function make_F011()

  //  1 - DOCNAME(C)  2 - IDDOC(N) 3 - DOCSER(C) 4 - DOCNUM(C) 5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F011 := {;
    { 'IDDOC',      'N',    2,      0 },;
    { 'DOCNAME',    'C',  250,      0 },;
    { 'DOCSER',     'C',   10,      0 },;
    { 'DOCNUM',     'C',   20,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr

  dbcreate('_mo_f011',_mo_F011)
  use _mo_f011 new alias F011
  nfile := 'F011.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F011.xml     - �����䨪��� ⨯�� ���㬥�⮢, 㤮�⮢������ ��筮��� (Tipdoc)'
  IF Empty( oXmlDoc:aItems )
    ? "�訡�� � �⥭�� 䠩��",nfile
    wait
  else
    ? "��ࠡ�⪠ 䠩�� "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2)+"%"
        select F011
        append blank
        F011->IDDOC := val(mo_read_xml_stroke(oXmlNode, 'IDDOC',))
        F011->DOCNAME := mo_read_xml_stroke(oXmlNode, 'DOCNAME',)
        F011->DOCSER := mo_read_xml_stroke(oXmlNode, 'DOCSER',)
        F011->DOCNUM := mo_read_xml_stroke(oXmlNode, 'DOCNUM',)
        F011->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F011->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.08.21
Function make_F014()

  local _mo_F014 := {;
    {'KOD',     'N',      4,      0},;
    {'NAME',    'C',    250,      0},;
    {'OPIS',    'M',     10,      0},;
    {'DATEBEG', 'D',      8,      0},;
    {'DATEEND', 'D',      8,      0},;
    {'OSN',     'C',     20,      0};
  }

  dbcreate("_mo_f014",_mo_F014)
  use _mo_F014 new alias F014
  nfile := "F014.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F014.xml     - �����䨪��� ��稭 �⪠�� � ����� ����樭᪮� ����� (OplOtk)'
  IF Empty( oXmlDoc:aItems )
    ? '�訡�� � �⥭�� 䠩��', nfile
    wait
  else
    ? '��ࠡ�⪠ 䠩�� ' + nfile + ' - '
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        @ row(),30 say str(j/k*100,6,2) + '%'
        select F014
        append blank
        F014->KOD := val( mo_read_xml_stroke(oXmlNode, 'KOD',) )
        F014->NAME := mo_read_xml_stroke(oXmlNode, 'KOMMENT',)
        F014->OPIS := mo_read_xml_stroke(oXmlNode, 'NAIM',)
        F014->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode, 'DATEBEG',))
        F014->DATEEND := ctod(mo_read_xml_stroke(oXmlNode, 'DATEEND',))
        F014->OSN := mo_read_xml_stroke(oXmlNode, 'OSN',)
    
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

*****
Function InitSpravFFOMS()

  // V002.dbf - �����䨪��� ��䨫�� ��������� ����樭᪮� �����
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V002 := getV002() //{}
  
  // V021.xml - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩ (��᫥����)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V021 := {}
  aadd(glob_V021, {"����樮���� � ��ᬨ�᪠� ����樭�",1,stod("20151128"),stod("")})
  aadd(glob_V021, {"������⢮ � �����������",2,stod("20151128"),stod("")})
  aadd(glob_V021, {"����࣮����� � ���㭮�����",3,stod("20151128"),stod("")})
  aadd(glob_V021, {"����⥧�������-ॠ����⮫����",4,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ਮ�����",5,stod("20151128"),stod("")})
  aadd(glob_V021, {"����᮫����",6,stod("20151128"),stod("")})
  aadd(glob_V021, {"���������� ����樭�",7,stod("20151128"),stod("")})
  aadd(glob_V021, {"�������஫����",8,stod("20151128"),stod("")})
  aadd(glob_V021, {"����⮫����",9,stod("20151128"),stod("")})
  aadd(glob_V021, {"����⨪�",10,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ਠ���",11,stod("20151128"),stod("")})
  aadd(glob_V021, {"������� ��⥩ � �����⪮�",12,stod("20151128"),stod("")})
  aadd(glob_V021, {"������� ��⠭��",13,stod("20151128"),stod("")})
  aadd(glob_V021, {"������� ��㤠",14,stod("20151128"),stod("")})
  aadd(glob_V021, {"��������᪮� ��ᯨ⠭��",15,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����䥪⮫����",16,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ଠ⮢���஫����",17,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᪠� ��न������",18,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᪠� ���������",19,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᪠� �஫����-���஫����",20,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᪠� ���ࣨ�",21,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᪠� ���ਭ������",22,stod("20151128"),stod("")})
  aadd(glob_V021, {"���⮫����",23,stod("20151128"),stod("")})
  aadd(glob_V021, {"��䥪樮��� �������",24,stod("20151128"),stod("")})
  aadd(glob_V021, {"��न������",25,stod("20151128"),stod("")})
  aadd(glob_V021, {"������᪠� ������ୠ� �������⨪�",26,stod("20151128"),stod("")})
  aadd(glob_V021, {"������᪠� �ଠ�������",27,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����ப⮫����",28,stod("20151128"),stod("")})
  aadd(glob_V021, {"����㭠�쭠� �������",29,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ᬥ⮫����",30,stod("20151128"),stod("")})
  aadd(glob_V021, {"������ୠ� ����⨪�",31,stod("20151128"),stod("")})
  aadd(glob_V021, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",32,stod("20151128"),stod("")})
  aadd(glob_V021, {"���㠫쭠� �࠯��",33,stod("20151128"),stod("")})
  aadd(glob_V021, {"������-�樠�쭠� �ᯥ�⨧�",34,stod("20151128"),stod("")})
  aadd(glob_V021, {"���஫����",35,stod("20151128"),stod("")})
  aadd(glob_V021, {"�������ࣨ�",36,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����⮫����",37,stod("20151128"),stod("")})
  aadd(glob_V021, {"���஫����",38,stod("20151128"),stod("")})
  aadd(glob_V021, {"���� ��祡��� �ࠪ⨪� (ᥬ����� ����樭�)",39,stod("20151128"),stod("")})
  aadd(glob_V021, {"���� �������",40,stod("20151128"),stod("")})
  aadd(glob_V021, {"���������",41,stod("20151128"),stod("")})
  aadd(glob_V021, {"�࣠������ ��ࠢ���࠭���� � ����⢥���� ���஢�",42,stod("20151128"),stod("")})
  aadd(glob_V021, {"��⮤����",43,stod("20151128"),stod("")})
  aadd(glob_V021, {"��⥮����",44,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ਭ���ਭ�������",45,stod("20151128"),stod("")})
  aadd(glob_V021, {"��⠫쬮�����",46,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ࠧ�⮫����",47,stod("20151128"),stod("")})
  aadd(glob_V021, {"��⮫����᪠� ���⮬��",48,stod("20151128"),stod("")})
  aadd(glob_V021, {"��������",49,stod("20151128"),stod("")})
  aadd(glob_V021, {"������᪠� ���ࣨ�",50,stod("20151128"),stod("")})
  aadd(glob_V021, {"��䯠⮫����",51,stod("20151128"),stod("")})
  aadd(glob_V021, {"��娠���",52,stod("20151128"),stod("")})
  aadd(glob_V021, {"��娠���-��મ�����",53,stod("20151128"),stod("")})
  aadd(glob_V021, {"����࠯��",54,stod("20151128"),stod("")})
  aadd(glob_V021, {"��쬮�������",55,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����樮���� �������",56,stod("20151128"),stod("")})
  aadd(glob_V021, {"����������",57,stod("20151128"),stod("")})
  aadd(glob_V021, {"������࠯��",58,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����⮫����",59,stod("20151128"),stod("")})
  aadd(glob_V021, {"���⣥�������",60,stod("20151128"),stod("")})
  aadd(glob_V021, {"���⣥���������� �������⨪� � ��祭��",61,stod("20151128"),stod("")})
  aadd(glob_V021, {"��䫥���࠯��",62,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����୮-��������᪨� �������� ��᫥�������",63,stod("20151128"),stod("")})
  aadd(glob_V021, {"���᮫����",64,stod("20151128"),stod("")})
  aadd(glob_V021, {"��थ筮-��㤨��� ���ࣨ�",65,stod("20151128"),stod("")})
  aadd(glob_V021, {"����� ����樭᪠� ������",66,stod("20151128"),stod("")})
  aadd(glob_V021, {"��樠�쭠� ������� � �࣠������ ���ᠭ���㦡�",67,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ���᪠�",68,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ��饩 �ࠪ⨪�",69,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ��⮯����᪠�",70,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� �࠯����᪠�",71,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ���ࣨ�᪠�",72,stod("20151128"),stod("")})
  aadd(glob_V021, {"�㤥���-����樭᪠� �ᯥ�⨧�",73,stod("20151128"),stod("")})
  aadd(glob_V021, {"�㤥���-��娠���᪠� �ᯥ�⨧�",74,stod("20151128"),stod("")})
  aadd(glob_V021, {"��म�����-��ਭ���ਭ�������",75,stod("20151128"),stod("")})
  aadd(glob_V021, {"��࠯��",76,stod("20151128"),stod("")})
  aadd(glob_V021, {"���ᨪ������",77,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ࠪ��쭠� ���ࣨ�",78,stod("20151128"),stod("")})
  aadd(glob_V021, {"�ࠢ��⮫���� � ��⮯����",79,stod("20151128"),stod("")})
  aadd(glob_V021, {"�࠭��㧨������",80,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ࠧ�㪮��� �������⨪�",81,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ࠢ����� � ������� �ଠ樨",82,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ࠢ����� ���ਭ᪮� ���⥫쭮����",83,stod("20151128"),stod("")})
  aadd(glob_V021, {"�஫����",84,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ଠ楢��᪠� �孮�����",85,stod("20151128"),stod("")})
  aadd(glob_V021, {"��ଠ楢��᪠� 娬�� � �ଠ��������",86,stod("20151128"),stod("")})
  aadd(glob_V021, {"������࠯��",87,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⨧�����",88,stod("20151128"),stod("")})
  aadd(glob_V021, {"�㭪樮���쭠� �������⨪�",89,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ࣨ�",90,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����⭮-��楢�� ���ࣨ�",91,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����ਭ������",92,stod("20151128"),stod("")})
  aadd(glob_V021, {"����᪮���",93,stod("20151128"),stod("")})
  aadd(glob_V021, {"�������������",94,stod("20151128"),stod("")})
  aadd(glob_V021, {"��祡��� ����",95,stod("20170107"),stod("")})
  aadd(glob_V021, {"������-��䨫����᪮� ����",96,stod("20170107"),stod("")})
  aadd(glob_V021, {"����樭᪠� ���娬��",97,stod("20170107"),stod("")})
  aadd(glob_V021, {"����樭᪠� ���䨧���",98,stod("20170107"),stod("")})
  aadd(glob_V021, {"����樭᪠� ����୥⨪�",99,stod("20170107"),stod("")})
  aadd(glob_V021, {"����ਭ᪮� ����",100,stod("20170107"),stod("")})
  aadd(glob_V021, {"��ଠ��",101,stod("20170107"),stod("")})
  aadd(glob_V021, {"��祡��� ���� (�।��� ������ᮭ��)",206,stod("20151128"),stod("")})
  aadd(glob_V021, {"�����᪮� ���� (�।��� ������ᮭ��)",207,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� (�।��� ������ᮭ��)",208,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ��⮯����᪠�",209,stod("20151128"),stod("")})
  aadd(glob_V021, {"������������� (��ࠧ�⮫����)",210,stod("20151128"),stod("")})
  aadd(glob_V021, {"��������᪮� ��ᯨ⠭��",213,stod("20151128"),stod("")})
  aadd(glob_V021, {"������ୠ� �������⨪�",215,stod("20151128"),stod("")})
  aadd(glob_V021, {"������୮� ����",217,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ਭ᪮� ����",219,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ਭ᪮� ���� � ������ਨ",221,stod("20151128"),stod("")})
  aadd(glob_V021, {"����樮���� ����",222,stod("20151128"),stod("")})
  aadd(glob_V021, {"����⥧������� � ॠ����⮫����",223,stod("20151128"),stod("")})
  aadd(glob_V021, {"���� �ࠪ⨪�",224,stod("20151128"),stod("")})
  aadd(glob_V021, {"�㭪樮���쭠� �������⨪�",226,stod("20151128"),stod("")})
  aadd(glob_V021, {"������࠯��",227,stod("20151128"),stod("")})
  aadd(glob_V021, {"����樭᪨� ���ᠦ",228,stod("20151128"),stod("")})
  aadd(glob_V021, {"��祡��� 䨧������",230,stod("20151128"),stod("")})
  aadd(glob_V021, {"���⮫����",231,stod("20151128"),stod("")})
  aadd(glob_V021, {"�⮬�⮫���� ��䨫����᪠�",233,stod("20151128"),stod("")})
  aadd(glob_V021, {"�㤥���-����樭᪠� �ᯥ�⨧�",234,stod("20151128"),stod("")})
  aadd(glob_V021, {"��મ�����",280,stod("20151128"),stod("")})
  aadd(glob_V021, {"��������樮���� ���ਭ᪮� ����",281,stod("20151128"),stod("")})
  aadd(glob_V021, {"����� � ���⫮���� ������",283,stod("20151128"),stod("")})
  aadd(glob_V021, {"����ਮ�����",284,stod("20151128"),stod("")})
  // V015.xml - �����䨪��� ����樭᪨� ᯥ樠�쭮�⥩
  //  1 - NAME(C)  2 - CODE(N)  3 - HIGH(C)  4 - OKSO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  Public glob_V015 := {}
  aadd(glob_V015, {"��祡�� ᯥ樠�쭮��",0,"","1",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� ����. ��������",1,"0","2",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-��䨫����᪮� ����",2,"0","138",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫����",3,"0","154",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ଠ��",4,"0","161",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਭ᪮� ����",5,"0","165",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ���娬��",6,"0","167",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ���䨧���",7,"0","168",stod("20131226"),stod("")})
  aadd(glob_V015, {"������⢮ � �����������",8,"1","3",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⥧������� � ॠ����⮫����",9,"1","8",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ଠ⮢���஫����",10,"1","12",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���ࣨ�",11,"1","125",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⨪�",12,"1","14",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",13,"1","18",stod("20131226"),stod("")})
  aadd(glob_V015, {"���஫����",14,"1","23",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⮫����",15,"1","137",stod("20131226"),stod("")})
  aadd(glob_V015, {"���� ��祡��� �ࠪ⨪� (ᥬ����� ����樭�)",16,"1","30",stod("20131226"),stod("")})
  aadd(glob_V015, {"���������",17,"1","102",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࣠������ ��ࠢ���࠭���� � ����⢥���� ���஢�",18,"1","56",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ਭ���ਭ�������",19,"1","38",stod("20131226"),stod("")})
  aadd(glob_V015, {"��⠫쬮�����",20,"1","40",stod("20131226"),stod("")})
  aadd(glob_V015, {"��⮫����᪠� ���⮬��",21,"1","41",stod("20131226"),stod("")})
  aadd(glob_V015, {"��������",22,"1","105",stod("20131226"),stod("")})
  aadd(glob_V015, {"��娠���",23,"1","42",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥�������",24,"1","47",stod("20131226"),stod("")})
  aadd(glob_V015, {"����� ����樭᪠� ������",25,"1","50",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㤥���-����樭᪠� �ᯥ�⨧�",26,"1","57",stod("20131226"),stod("")})
  aadd(glob_V015, {"��࠯��",27,"1","58",stod("20131226"),stod("")})
  aadd(glob_V015, {"�ࠢ��⮫���� � ��⮯����",28,"1","80",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⨧�����",29,"1","86",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࣨ�",30,"1","88",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����ਭ������",31,"1","99",stod("20131226"),stod("")})
  aadd(glob_V015, {"��䥪樮��� �������",32,"1","16",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",33,"8","4",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",34,"8","5",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",35,"8","6",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",36,"8","7",stod("20131226"),stod("")})
  aadd(glob_V015, {"���ᨪ������",37,"9","9",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",38,"9","10",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",39,"9","11",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ���������",40,"10","13",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���������",41,"11","126",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� �஫���� - ���஫����",42,"11","127",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����ப⮫����",43,"11","128",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������ࣨ�",44,"11","129",stod("20131226"),stod("")})
  aadd(glob_V015, {"��थ筮-��㤨��� ���ࣨ�",45,"11","130",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ࠪ��쭠� ���ࣨ�",46,"11","131",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",47,"11","132",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",48,"11","133",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",49,"11","134",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⭮-��楢�� ���ࣨ�",50,"11","135",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",51,"11","136",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",52,"12","15",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ���������",53,"32","17",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",54,"13","19",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",55,"13","20",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",56,"13","21",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",57,"13","22",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",58,"14","26",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",59,"14","27",stod("20131226"),stod("")})
  aadd(glob_V015, {"���㠫쭠� �࠯��",61,"14","24",stod("20131226"),stod("")})
  aadd(glob_V015, {"��䫥���࠯��",62,"14","25",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",63,"14","28",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",64,"14","29",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",65,"16","31",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ਠ���",66,"16","32",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",67,"16","33",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",69,"16","34",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",70,"16","35",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",71,"16","36",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",72,"16","37",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���������",73,"17","103",stod("20131226"),stod("")})
  aadd(glob_V015, {"����������",74,"17","104",stod("20131226"),stod("")})
  aadd(glob_V015, {"��म����� - ��ਭ���ਭ�������",75,"19","39",stod("20131226"),stod("")})
  aadd(glob_V015, {"����࣮����� � ���㭮�����",77,"22","110",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",78,"22","111",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������஫����",79,"22","112",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⮫����",80,"22","113",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ��न������",81,"22","108",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���������",82,"22","106",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���ਭ������",83,"22","107",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⮫����",84,"22","114",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� �ଠ�������",85,"22","115",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",86,"22","109",stod("20131226"),stod("")})
  aadd(glob_V015, {"���㠫쭠� �࠯��",88,"22","116",stod("20131226"),stod("")})
  aadd(glob_V015, {"���஫����",89,"22","117",stod("20131226"),stod("")})
  aadd(glob_V015, {"��쬮�������",90,"22","118",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⮫����",91,"22","119",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",92,"22","120",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",93,"22","121",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",94,"22","122",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",95,"22","123",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",96,"22","124",stod("20131226"),stod("")})
  aadd(glob_V015, {"��娠���-��મ�����",97,"23","46",stod("20131226"),stod("")})
  aadd(glob_V015, {"����࠯��",98,"23","43",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᮫����",99,"23","44",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㤥���-��娠���᪠� �ᯥ�⨧�",100,"23","45",stod("20131226"),stod("")})
  aadd(glob_V015, {"����������",102,"24","48",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",103,"24","49",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",104,"25","51",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",105,"25","52",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",107,"25","53",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",108,"25","54",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",109,"25","55",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樮���� � ��ᬨ�᪠� ����樭�",110,"27","71",stod("20131226"),stod("")})
  aadd(glob_V015, {"����࣮����� � ���㭮�����",112,"27","72",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",113,"27","73",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������஫����",114,"27","59",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⮫����",115,"27","60",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ਠ���",116,"27","61",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⮫����",117,"27","62",stod("20131226"),stod("")})
  aadd(glob_V015, {"��न������",118,"27","63",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� �ଠ�������",119,"27","64",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",120,"27","74",stod("20131226"),stod("")})
  aadd(glob_V015, {"���㠫쭠� �࠯��",122,"27","75",stod("20131226"),stod("")})
  aadd(glob_V015, {"���஫����",123,"27","65",stod("20131226"),stod("")})
  aadd(glob_V015, {"��䯠⮫����",124,"27","76",stod("20131226"),stod("")})
  aadd(glob_V015, {"��쬮�������",125,"27","66",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⮫����",126,"27","67",stod("20131226"),stod("")})
  aadd(glob_V015, {"��䫥���࠯��",127,"27","77",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",128,"27","68",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",129,"27","69",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",130,"27","78",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",131,"27","70",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",132,"27","79",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⠭���⥫쭠� ����樭�",133,"28","82",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������ � ᯮ�⨢��� ����樭�",134,"28","83",stod("20131226"),stod("")})
  aadd(glob_V015, {"���㠫쭠� �࠯��",136,"28","81",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",137,"28","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��쬮�������",138,"29","87",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����ப⮫����",139,"30","89",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������ࣨ�",140,"30","90",stod("20131226"),stod("")})
  aadd(glob_V015, {"��थ筮-��㤨��� ���ࣨ�",141,"30","92",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ࠪ��쭠� ���ࣨ�",142,"30","93",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",143,"30","94",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",144,"30","97",stod("20131226"),stod("")})
  aadd(glob_V015, {"�஫����",145,"30","91",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",146,"30","98",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⭮-��楢�� ���ࣨ�",147,"30","95",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᪮���",148,"30","96",stod("20131226"),stod("")})
  aadd(glob_V015, {"���᪠� ���ਭ������",149,"31","101",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⮫����",150,"31","100",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",151,"2","139",stod("20131226"),stod("")})
  aadd(glob_V015, {"���� �������",152,"2","145",stod("20131226"),stod("")})
  aadd(glob_V015, {"��樠�쭠� ������� � �࣠������ ���ᠭ���㦡�",153,"2","153",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������������",154,"2","142",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",155,"151","140",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",156,"151","141",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",157,"151","202",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",158,"151","203",stod("20131226"),stod("")})
  aadd(glob_V015, {"������� ��⥩ � �����⪮�",159,"152","146",stod("20131226"),stod("")})
  aadd(glob_V015, {"������� ��⠭��",160,"152","148",stod("20131226"),stod("")})
  aadd(glob_V015, {"������� ��㤠",161,"152","149",stod("20131226"),stod("")})
  aadd(glob_V015, {"��������᪮� ��ᯨ⠭��",162,"152","147",stod("20131226"),stod("")})
  aadd(glob_V015, {"����㭠�쭠� �������",163,"152","150",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����樮���� �������",164,"152","151",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����୮-��������᪨� �������� ��᫥�������",165,"152","152",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",167,"154","204",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",168,"154","205",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����䥪⮫����",169,"154","143",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ࠧ�⮫����",170,"154","144",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ��饩 �ࠪ⨪�",171,"3","155",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",172,"3","206",stod("20131226"),stod("")})
  aadd(glob_V015, {"��⮤����",173,"171","156",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ���᪠�",174,"171","157",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ��⮯����᪠�",175,"171","159",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� �࠯����᪠�",176,"171","158",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ���ࣨ�᪠�",177,"171","160",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⭮-��楢�� ���ࣨ�",178,"171","207",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",179,"171","208",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",180,"172","209",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",181,"172","210",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",182,"172","211",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",183,"172","212",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ࠢ����� � ������� �ଠ樨",184,"4","162",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ଠ楢��᪠� 娬�� � �ଠ��������",185,"4","164",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ࠢ����� ���ਭ᪮� ���⥫쭮����",186,"5","166",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⨪�",187,"6","213",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",188,"187","216",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",189,"6","214",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",190,"189","217",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",191,"189","218",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",192,"189","220",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",193,"189","219",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㤥���-����樭᪠� �ᯥ�⨧�",194,"6","215",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",195,"7","221",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥�������",196,"7","222",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",197,"195","223",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",198,"195","224",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",199,"195","225",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",200,"195","226",stod("20131226"),stod("")})
  aadd(glob_V015, {"����������",201,"196","227",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",202,"196","228",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",203,"196","229",stod("20131226"),stod("")})
  aadd(glob_V015, {"�।��� ����樭᪨� ���ᮭ��",204,"","169",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࣠������ ���ਭ᪮�� ����",205,"204","170",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� ����",206,"204","171",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����᪮� ����",207,"204","172",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫����",208,"204","173",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ��⮯����᪠�",209,"204","174",stod("20131226"),stod("")})
  aadd(glob_V015, {"������������� (��ࠧ�⮫����)",210,"204","175",stod("20131226"),stod("")})
  aadd(glob_V015, {"������� � ᠭ����",211,"204","176",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����䥪樮���� ����",212,"204","177",stod("20131226"),stod("")})
  aadd(glob_V015, {"��������᪮� ��ᯨ⠭��",213,"204","178",stod("20131226"),stod("")})
  aadd(glob_V015, {"��⮬������",214,"204","179",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� �������⨪�",215,"204","180",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⮫����",216,"204","181",stod("20131226"),stod("")})
  aadd(glob_V015, {"������୮� ����",217,"204","182",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ଠ��",218,"204","183",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਭ᪮� ����",219,"204","184",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਭ᪮� ���� � ������ਨ",221,"204","185",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樮���� ����",222,"204","186",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⥧������� � ॠ����⮫����",223,"204","187",stod("20131226"),stod("")})
  aadd(glob_V015, {"���� �ࠪ⨪�",224,"204","188",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥�������",225,"204","189",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",226,"204","190",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",227,"204","191",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪨� ���ᠦ",228,"204","192",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ଠ楢��᪠� �孮�����",229,"4","163",stod("20131226"),stod("")})
  aadd(glob_V015, {"��祡��� 䨧������",230,"204","193",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⮫����",231,"204","194",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ����⨪�",232,"204","195",stod("20131226"),stod("")})
  aadd(glob_V015, {"�⮬�⮫���� ��䨫����᪠�",233,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㤥���-����樭᪠� �ᯥ�⨧�",234,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ��⨪�",235,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",236,"27","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",237,"28","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",238,"29","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",239,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",240,"31","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",241,"11","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",242,"14","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",243,"17","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",244,"19","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",245,"20","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� �ᯥ�⨧�",246,"22","",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ���ࣨ�",247,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",248,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",249,"31","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",250,"8","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",251,"8","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��ᬥ⮫����",252,"10","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",253,"11","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",254,"14","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����࣮����� � ���㭮�����",255,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���������� ����樭�",256,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�������஫����",257,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⮫����",258,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⮫����",259,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��न������",260,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���஫����",261,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��쬮�������",262,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�����⮫����",263,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࠭��㧨������",264,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",265,"17","",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥���������� �������⨪� � ��祭��",266,"24","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࣠������ ��ࠢ���࠭���� � ����⢥���� ���஢�",267,"2","",stod("20131226"),stod("")})
  aadd(glob_V015, {"�࣠������ ��ࠢ���࠭���� � ����⢥���� ���஢�",268,"3","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ����୥⨪�",269,"0","168",stod("20131226"),stod("")})
  aadd(glob_V015, {"������᪠� ������ୠ� �������⨪�",270,"269","221",stod("20131226"),stod("")})
  aadd(glob_V015, {"���⣥�������",271,"269","222",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",272,"270","223",stod("20131226"),stod("")})
  aadd(glob_V015, {"����᮫����",273,"270","224",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ����⨪�",274,"270","225",stod("20131226"),stod("")})
  aadd(glob_V015, {"������ୠ� ���������",275,"270","226",stod("20131226"),stod("")})
  aadd(glob_V015, {"����������",276,"271","227",stod("20131226"),stod("")})
  aadd(glob_V015, {"�㭪樮���쭠� �������⨪�",277,"271","228",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ࠧ�㪮��� �������⨪�",278,"271","229",stod("20131226"),stod("")})
  aadd(glob_V015, {"������-�樠�쭠� ������",279,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��મ�����",280,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"��������樮���� ���ਭ᪮� ����",281,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਭ᪮� ���� � ��ᬥ⮫����",282,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����� � ���⫮���� ������",283,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����ਮ�����",284,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"����������",285,"28","84",stod("20131226"),stod("")})
  aadd(glob_V015, {"������࠯��",286,"1","85",stod("20131226"),stod("")})
  aadd(glob_V015, {"����⢥��� ��㪨",287,"0","196",stod("20131226"),stod("")})
  aadd(glob_V015, {"���䨧���",288,"287","197",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ���䨧���",289,"287","198",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ����୥⨪�",290,"287","199",stod("20131226"),stod("")})
  aadd(glob_V015, {"���娬��",3200,"287","200",stod("20131226"),stod("")})
  aadd(glob_V015, {"����樭᪠� ���娬��",3201,"287","201",stod("20131226"),stod("")})

  // ���ᨢ ��४���஢�� ᯥ樠�쭮�⥩ �� V004 � V015
  Public glob_arr_V004_V015 := {;
    {     1,  0,"���襥 ����樭᪮� ��ࠧ������"},;
    {    11,  1,"��祡��� ����. ��������"},;
    {  1101,  8,"������⢮ � �����������"},;
    {110101, 33,"����ࠧ�㪮��� �������⨪�"},;
    {110102, 34,"������࠯��"},;
    {110103, 35,"�㭪樮���쭠� �������⨪�"},;
    {110104, 36,"����᪮���"},;
    {  1103,  9,"����⥧������� � ॠ����⮫����"},;
    {110301, 37,"���ᨪ������"},;
    {110302, 38,"�࠭��㧨������"},;
    {110303, 39,"�㭪樮���쭠� �������⨪�"},;
    {  1104, 10,"��ଠ⮢���஫����"},;
    {110401, 40,"������᪠� ���������"},;
    {  1105, 12,"����⨪�"},;
    {110501, 52,"������ୠ� ����⨪�"},;
    {  1106, 32,"��䥪樮��� �������"},;
    {110601, 53,"������᪠� ���������"},;
    {  1107, 13,"������᪠� ������ୠ� �������⨪�"},;
    {110701, 54,"����ਮ�����"},;
    {110702, 55,"����᮫����"},;
    {110703, 56,"������ୠ� ����⨪�"},;
    {110704, 57,"������ୠ� ���������"},;
    {  1109, 14,"���஫����"},;
    {110901, 61,"���㠫쭠� �࠯��"},;
    {110902, 62,"��䫥���࠯��"},;
    {110903, 58,"����⠭���⥫쭠� ����樭�"},;
    {110904, 59,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {110905, 63,"������࠯��"},;
    {110906, 64,"�㭪樮���쭠� �������⨪�"},;
    {  1110, 16,"���� ��祡��� �ࠪ⨪� (ᥬ����� ����樭�)"},;
    {111001, 65,"����⠭���⥫쭠� ����樭�"},;
    {111002, 66,"��ਠ���"},;
    {111003, 67,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {111004, 69,"����ࠧ�㪮��� �������⨪�"},;
    {111005, 70,"������࠯��"},;
    {111006, 71,"�㭪樮���쭠� �������⨪�"},;
    {111007, 72,"����᪮���"},;
    {  1111, 19,"�⮫�ਭ�������"},;
    {111101, 75,"��म�����-�⮫�ਭ�������"},;
    {  1112, 20,"��⠫쬮�����"},;
    {  1113, 21,"��⮫����᪠� ���⮬��"},;
    {  1115, 23,"��娠���"},;
    {111501, 98,"����࠯��"},;
    {111502, 99,"���᮫����"},;
    {111503,100,"�㤥���-��娠���᪠� �ᯥ�⨧�"},;
    {111504, 97,"��娠���-��મ�����"},;
    {  1118, 24,"���⣥�������"},;
    {111801,102,"����������"},;
    {111802,103,"����ࠧ�㪮��� �������⨪�"},;
    {  1119, 25,"����� ����樭᪠� ������"},;
    {111901,104,"����⠭���⥫쭠� ����樭�"},;
    {111902,105,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {111903,107,"����ࠧ�㪮��� �������⨪�"},;
    {111904,108,"������࠯��"},;
    {111905,109,"�㭪樮���쭠� �������⨪�"},;
    {  1120, 18,"�࣠������ ��ࠢ���࠭���� � ����⢥���� ���஢�"},;
    {  1121, 26,"�㤥���-����樭᪠� �ᯥ�⨧�"},;
    {  1122, 27,"��࠯��"},;
    {112201,114,"�������஫����"},;
    {112202,115,"����⮫����"},;
    {112203,116,"��ਠ���"},;
    {112204,117,"���⮫����"},;
    {112205,118,"��न������"},;
    {112206,119,"������᪠� �ଠ�������"},;
    {112207,123,"���஫����"},;
    {112208,125,"��쬮�������"},;
    {112209,126,"�����⮫����"},;
    {112210,128,"�࠭��㧨������"},;
    {112211,129,"����ࠧ�㪮��� �������⨪�"},;
    {112212,131,"�㭪樮���쭠� �������⨪�"},;
    {112213,110,"����樮���� � ��ᬨ�᪠� ����樭�"},;
    {112214,112,"����࣮����� � ���㭮�����"},;
    {112215,113,"����⠭���⥫쭠� ����樭�"},;
    {112216,120,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {112217,122,"���㠫쭠� �࠯��"},;
    {112218,124,"��䯠⮫����"},;
    {112219,127,"��䫥���࠯��"},;
    {112220,130,"������࠯��"},;
    {112221,132,"����᪮���"},;
    {  1123, 28,"�ࠢ��⮫���� � ��⮯����"},;
    {112301,136,"���㠫쭠� �࠯��"},;
    {112302,133,"����⠭���⥫쭠� ����樭�"},;
    {112303,134,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {112304,285,"����������"},;
    {  1124,137,"������࠯��"},;
    {  1125, 29,"�⨧�����"},;
    {112501,138,"��쬮�������"},;
    {  1126, 30,"����ࣨ�"},;
    {112601,139,"�����ப⮫����"},;
    {112602,140,"�������ࣨ�"},;
    {112603,145,"�஫����"},;
    {112604,141,"��थ筮-��㤨��� ���ࣨ�"},;
    {112605,142,"��ࠪ��쭠� ���ࣨ�"},;
    {112606,143,"�࠭��㧨������"},;
    {112608,147,"�����⭮-��楢�� ���ࣨ�"},;
    {112609,148,"����᪮���"},;
    {112610,144,"����ࠧ�㪮��� �������⨪�"},;
    {112611,146,"�㭪樮���쭠� �������⨪�"},;
    {  1127, 31,"�����ਭ������"},;
    {112701,150,"�����⮫����"},;
    {112702,149,"���᪠� ���ਭ������"},;
    {  1128, 17,"���������"},;
    {112801, 73,"���᪠� ���������"},;
    {112802, 74,"����������"},;
    {  1134, 22,"��������"},;
    {113401, 82,"���᪠� ���������"},;
    {113402, 83,"���᪠� ���ਭ������"},;
    {113403, 81,"���᪠� ��न������"},;
    {113404, 86,"��祡��� 䨧������ � ᯮ�⨢��� ����樭�"},;
    {113405, 77,"����࣮����� � ���㭮�����"},;
    {113406, 78,"����⠭���⥫쭠� ����樭�"},;
    {113407, 79,"�������஫����"},;
    {113408, 80,"����⮫����"},;
    {113409, 84,"���⮫����"},;
    {113410, 85,"������᪠� �ଠ�������"},;
    {113411, 88,"���㠫쭠� �࠯��"},;
    {113412, 89,"���஫����"},;
    {113413, 90,"��쬮�������"},;
    {113414, 91,"�����⮫����"},;
    {113415, 92,"�࠭��㧨������"},;
    {113416, 93,"����ࠧ�㪮��� �������⨪�"},;
    {113417, 94,"������࠯��"},;
    {113418, 95,"�㭪樮���쭠� �������⨪�"},;
    {113419, 96,"����᪮���"},;
    {  1135, 11,"���᪠� ���ࣨ�"},;
    {113501, 41,"���᪠� ���������"},;
    {113502, 42,"���᪠� �஫����-���஫����"},;
    {113503, 43,"�����ப⮫����"},;
    {113504, 44,"�������ࣨ�"},;
    {113505, 45,"��थ筮-��㤨��� ���ࣨ�"},;
    {113506, 46,"��ࠪ��쭠� ���ࣨ�"},;
    {113507, 47,"�࠭��㧨������"},;
    {113508, 48,"����ࠧ�㪮��� �������⨪�"},;
    {113509, 49,"�㭪樮���쭠� �������⨪�"},;
    {113510, 50,"�����⭮-��楢�� ���ࣨ�"},;
    {113511, 51,"����᪮���"},;
    {  1136, 15,"�����⮫����"},;
    {    13,  2,"������-��䨫����᪮� ����"},;
    {  1301,151,"������᪠� ������ୠ� �������⨪�"},;
    {130101,155,"����ਮ�����"},;
    {130102,156,"����᮫����"},;
    {130103,157,"������ୠ� ����⨪�"},;
    {130104,158,"������ୠ� ���������"},;
    {  1302,154,"�������������"},;
    {130201,167,"����ਮ�����"},;
    {130203,169,"�����䥪⮫����"},;
    {130204,170,"��ࠧ�⮫����"},;
    {130205,168,"����᮫����"},;
    {  1303,152,"���� �������"},;
    {130301,159,"������� ��⥩ � �����⪮�"},;
    {130302,162,"��������᪮� ��ᯨ⠭��"},;
    {130303,160,"������� ��⠭��"},;
    {130304,161,"������� ��㤠"},;
    {130305,163,"����㭠�쭠� �������"},;
    {130306,164,"�����樮���� �������"},;
    {130307,165,"�����୮-��������᪨� �������� ��᫥�������"},;
    {  1306,153,"��樠�쭠� ������� � �࣠������ ���ᠭ���㦡�"},;
    {    14,  3,"�⮬�⮫����"},;
    {  1401,171,"�⮬�⮫���� ��饩 �ࠪ⨪�"},;
    {140101,173,"��⮤����"},;
    {140102,174,"�⮬�⮫���� ���᪠�"},;
    {140103,176,"�⮬�⮫���� �࠯����᪠�"},;
    {140104,175,"�⮬�⮫���� ��⮯����᪠�"},;
    {140105,177,"�⮬�⮫���� ���ࣨ�᪠�"},;
    {140106,178,"�����⭮-��楢�� ���ࣨ�"},;
    {140107,179,"������࠯��"},;
    {  1402,172,"������᪠� ������ୠ� �������⨪�"},;
    {140201,180,"����ਮ�����"},;
    {140202,181,"����᮫����"},;
    {140203,182,"������ୠ� ����⨪�"},;
    {140204,183,"������ୠ� ���������"},;
    {    15,  4,"��ଠ��"},;
    {  1501,184,"��ࠢ����� � ������� �ଠ樨"},;
    {  1502,229,"��ଠ楢��᪠� �孮�����"},;
    {  1503,185,"��ଠ楢��᪠� 娬�� � �ଠ��������"},;
    {    16,  5,"����ਭ᪮� ����"},;
    {  1601,186,"��ࠢ����� ���ਭ᪮� ���⥫쭮����"},;
    {    17,  6,"����樭᪠� ���娬��"},;
    {  1701,187,"����⨪�"},;
    {170101,188,"������ୠ� ����⨪�"},;
    {  1702,189,"������᪠� ������ୠ� �������⨪�"},;
    {170201,190,"����ਮ�����"},;
    {170202,191,"����᮫����"},;
    {170203,193,"������ୠ� ����⨪�"},;
    {170204,192,"������ୠ� ���������"},;
    {  1703,194,"�㤥���-����樭᪠� �ᯥ�⨧�"},;
    {    18,  7,"����樭᪠� ���䨧���. ����樭᪠� ����୥⨪�"},;
    {  1801,195,"������᪠� ������ୠ� �������⨪�"},;
    {180101,197,"����ਮ�����"},;
    {180102,198,"����᮫����"},;
    {180103,199,"������ୠ� ����⨪�"},;
    {180104,200,"������ୠ� ���������"},;
    {  1802,196,"���⣥�������"},;
    {180201,201,"����������"},;
    {180202,202,"�㭪樮���쭠� �������⨪�"},;
    {180203,203,"����ࠧ�㪮��� �������⨪�"},;
    {     2,204,"�।��� ����樭᪮� � �ଠ楢��᪮� ��ࠧ������"},;
    {  2001,205,"�࣠������ ���ਭ᪮�� ����"},;
    {  2002,206,"��祡��� ����"},;
    {  2003,207,"�����᪮� ����"},;
    {  2004,208,"�⮬�⮫����"},;
    {  2005,209,"�⮬�⮫���� ��⮯����᪠�"},;
    {  2006,210,"������������� (��ࠧ�⮫����)"},;
    {  2007,211,"������� � ᠭ����"},;
    {  2008,212,"�����䥪樮���� ����"},;
    {  2009,213,"��������᪮� ��ᯨ⠭��"},;
    {  2010,214,"��⮬������"},;
    {  2011,215,"������ୠ� �������⨪�"},;
    {  2012,216,"���⮫����"},;
    {  2013,217,"������୮� ����"},;
    {  2014,218,"��ଠ��"},;
    {  2015,219,"����ਭ᪮� ����"},;
    {  2016,221,"����ਭ᪮� ���� � ������ਨ"},;
    {  2017,222,"����樮���� ����"},;
    {  2019,223,"����⥧������� � ॠ����⮫����"},;
    {  2019,224,"���� �ࠪ⨪�"},;
    {  2020,225,"���⣥�������"},;
    {  2021,226,"�㭪樮���쭠� �������⨪�"},;
    {  2022,227,"������࠯��"},;
    {  2023,228,"����樭᪨� ���ᠦ"},;
    {  2024,230,"��祡��� 䨧������"},;
    {  2025,231,"���⮫����"},;
    {  2026,232,"����樭᪠� ����⨪�"},;
    {  2027,233,"�⮬�⮫���� ��䨫����᪠�"},;
    {  2028,234,"�㤥���-����樭᪠� �ᯥ�⨧�"},;
    {  2029,235,"����樭᪠� ��⨪�"},;
    {     3,287,"����⢥��� ��㪨"},;
    {    31,288,"���䨧���"},;
    {  3101,289,"����樭᪠� ���䨧���"},;
    {  3102,290,"����樭᪠� ����୥⨪�"},;
    {    32,3200,"���娬��"},;
    {  3201,3201,"����樭᪠� ���娬��"};
  }
  return NIL
  
  