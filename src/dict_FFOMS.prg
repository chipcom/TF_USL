/// Справочники ФФОМС

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
  ? "V002.xml     - Классификатор профилей оказанной медицинской помощи (ProfOt)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDDT",      "C",   3, 0},;  // Код типа диспансеризации
    {"DTNAME",    "C", 254, 0},;  // Наименование типа диспансеризации
    {"RULE",      "C",  40, 0},;  // Значение результата диспансеризации (список) (V017)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local mRULE := ''

  dbcreate("_mo_v016", _mo_V016)
  use _mo_v016 new alias V016
  nfile := "V016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V016.xml     - Классификатор типов диспансеризации (DispT)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDDR",      "N",   2, 0},;  // Код результата диспансеризации
    {"DRNAME",    "C", 254, 0},;  // Наименование результата диспансеризации
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v017", _mo_V017)
  use _mo_v017 new alias V017
  nfile := "V017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V017.xml     - Классификатор результатов диспансеризации (DispR)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "V021.xml     - Классификатор медицинских специальностей (должностей) (MedSpec)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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

* 15.02.21 вернуть массив по справочнику регионов ТФОМС V002.xml
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
    {"IDRMP",     "N",   3, 0},;  // Код результата обращения
    {"RMPNAME",   "C", 254, 0},;  // Наименование результата обращения
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания медицинской помощи (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v009", _mo_V009)
  use _mo_v009 new alias V009
  nfile := "V009.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V009.xml     - Классификатор результатов обращения за медицинской помощью (Rezult)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDSP",      "N",   2, 0},;  // Код способа оплаты медицинской помощи
    {"SPNAME",    "C", 254, 0},;  // Наименование способа оплаты медицинской помощи
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v010", _mo_V010)
  use _mo_v010 new alias V010
  nfile := "V010.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V010.xml     - Классификатор способов оплаты медицинской помощи (Sposob)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDIZ",      "N",   3, 0},;  // Код исхода заболевания
    {"IZNAME",    "C", 254, 0},;  // Наименование исхода заболевания
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания МП (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v012", _mo_V012)
  use _mo_v012 new alias V012
  nfile := "V012.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V012.xml     - Классификатор исходов заболевания (Ishod)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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

* 16.02.21 вернуть массив по справочнику ТФОМС V021.xml
function getV021()
  // V021.xml - Классификатор медицинских специальностей (последний)
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
  ? "V015.xml     - Классификатор медицинских специальностей (Medspec)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "V018.xml     - виды высокотехнологичной медицинской помощи (HVid)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDHM",       "N",      4,      0},; // Идентификатор метода высокотехнологичной медицинской помощи
    {"HMNAME",     "C",    254,      0},; // Наименование метода высокотехнологичной медицинской помощи
    {"DIAG",       "C",    700,      0},; // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
    {"HVID",       "C",     12,      0},; // Код вида высокотехнологичной медицинской помощи для данного метода
    {"HGR",        "N",      3,      0},; // Номер группы высокотехнологичной медицинской помощи для данного метода
    {"HMODP",      "C",    254,      0},; // Модель пациента для методов высокотехнологичной медицинской помощи с одинаковыми значениями поля "HMNAME". Не заполняется, начиная с версии 3.0
    {"IDMODP",     "N",      5,      0},; // Идентификатор модели пациента для данного метода (начиная с версии 3.0, заполняется значением поля IDMPAC классификатора V022)
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }

  dbcreate("_mo_v019",_mo_V019)
  use _mo_V019 new alias V019
  nfile := "V019.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V019.xml     - методы высокотехнологичной медицинской помощи (HMet)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDK_PR",     "N",      3,      0},; // Код профиля койки
    {"K_PRNAME",   "C",    254,      0},; // Наименование профиля койки
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }

  dbcreate("_mo_v020",_mo_V020)
  use _mo_v020 new alias V020
  nfile := "V020.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V020.xml     - Классификатор профиля койки (KoPr)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла " + nfile + " - "
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
  ? "V022.xml     - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
    {"IDPC",      "C",   3, 0},;  // Код цели посещения
    {"N_PC",      "C", 254, 0},;  // Наименование цели посещения
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v025", _mo_V025)
  use _mo_V025 new alias V025
  // index on kod to tmp_shema
  nfile := "V025.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V025.xml     - Классификатор целей посещения (KPC)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "Q015.xml     - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "Q016.xml     - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "Q017.xml     - Перечень категорий проверок ФЛК и МЭК (TEST_K)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? "O001.xml     - Общероссийский классификатор стран мира (OKSM) "
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? 'F006.xml     - Классификатор видов контроля (VidExp)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? 'F010.xml     - Классификатор субъектов Российской Федерации (Subekti)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? 'F011.xml     - Классификатор типов документов, удостоверяющих личность (Tipdoc)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
  ? 'F014.xml     - Классификатор причин отказа в оплате медицинской помощи (OplOtk)'
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait
  else
    ? 'Обработка файла ' + nfile + ' - '
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

  // V002.dbf - Классификатор профилей оказанной медицинской помощи
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V002 := getV002() //{}
  
  // V021.xml - Классификатор медицинских специальностей (последний)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V021 := {}
  aadd(glob_V021, {"Авиационная и космическая медицина",1,stod("20151128"),stod("")})
  aadd(glob_V021, {"Акушерство и гинекология",2,stod("20151128"),stod("")})
  aadd(glob_V021, {"Аллергология и иммунология",3,stod("20151128"),stod("")})
  aadd(glob_V021, {"Анестезиология-реаниматология",4,stod("20151128"),stod("")})
  aadd(glob_V021, {"Бактериология",5,stod("20151128"),stod("")})
  aadd(glob_V021, {"Вирусология",6,stod("20151128"),stod("")})
  aadd(glob_V021, {"Водолазная медицина",7,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гастроэнтерология",8,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гематология",9,stod("20151128"),stod("")})
  aadd(glob_V021, {"Генетика",10,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гериатрия",11,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гигиена детей и подростков",12,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гигиена питания",13,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гигиена труда",14,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гигиеническое воспитание",15,stod("20151128"),stod("")})
  aadd(glob_V021, {"Дезинфектология",16,stod("20151128"),stod("")})
  aadd(glob_V021, {"Дерматовенерология",17,stod("20151128"),stod("")})
  aadd(glob_V021, {"Детская кардиология",18,stod("20151128"),stod("")})
  aadd(glob_V021, {"Детская онкология",19,stod("20151128"),stod("")})
  aadd(glob_V021, {"Детская урология-андрология",20,stod("20151128"),stod("")})
  aadd(glob_V021, {"Детская хирургия",21,stod("20151128"),stod("")})
  aadd(glob_V021, {"Детская эндокринология",22,stod("20151128"),stod("")})
  aadd(glob_V021, {"Диетология",23,stod("20151128"),stod("")})
  aadd(glob_V021, {"Инфекционные болезни",24,stod("20151128"),stod("")})
  aadd(glob_V021, {"Кардиология",25,stod("20151128"),stod("")})
  aadd(glob_V021, {"Клиническая лабораторная диагностика",26,stod("20151128"),stod("")})
  aadd(glob_V021, {"Клиническая фармакология",27,stod("20151128"),stod("")})
  aadd(glob_V021, {"Колопроктология",28,stod("20151128"),stod("")})
  aadd(glob_V021, {"Коммунальная гигиена",29,stod("20151128"),stod("")})
  aadd(glob_V021, {"Косметология",30,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лабораторная генетика",31,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лечебная физкультура и спортивная медицина",32,stod("20151128"),stod("")})
  aadd(glob_V021, {"Мануальная терапия",33,stod("20151128"),stod("")})
  aadd(glob_V021, {"Медико-социальная экспертиза",34,stod("20151128"),stod("")})
  aadd(glob_V021, {"Неврология",35,stod("20151128"),stod("")})
  aadd(glob_V021, {"Нейрохирургия",36,stod("20151128"),stod("")})
  aadd(glob_V021, {"Неонатология",37,stod("20151128"),stod("")})
  aadd(glob_V021, {"Нефрология",38,stod("20151128"),stod("")})
  aadd(glob_V021, {"Общая врачебная практика (семейная медицина)",39,stod("20151128"),stod("")})
  aadd(glob_V021, {"Общая гигиена",40,stod("20151128"),stod("")})
  aadd(glob_V021, {"Онкология",41,stod("20151128"),stod("")})
  aadd(glob_V021, {"Организация здравоохранения и общественное здоровье",42,stod("20151128"),stod("")})
  aadd(glob_V021, {"Ортодонтия",43,stod("20151128"),stod("")})
  aadd(glob_V021, {"Остеопатия",44,stod("20151128"),stod("")})
  aadd(glob_V021, {"Оториноларингология",45,stod("20151128"),stod("")})
  aadd(glob_V021, {"Офтальмология",46,stod("20151128"),stod("")})
  aadd(glob_V021, {"Паразитология",47,stod("20151128"),stod("")})
  aadd(glob_V021, {"Патологическая анатомия",48,stod("20151128"),stod("")})
  aadd(glob_V021, {"Педиатрия",49,stod("20151128"),stod("")})
  aadd(glob_V021, {"Пластическая хирургия",50,stod("20151128"),stod("")})
  aadd(glob_V021, {"Профпатология",51,stod("20151128"),stod("")})
  aadd(glob_V021, {"Психиатрия",52,stod("20151128"),stod("")})
  aadd(glob_V021, {"Психиатрия-наркология",53,stod("20151128"),stod("")})
  aadd(glob_V021, {"Психотерапия",54,stod("20151128"),stod("")})
  aadd(glob_V021, {"Пульмонология",55,stod("20151128"),stod("")})
  aadd(glob_V021, {"Радиационная гигиена",56,stod("20151128"),stod("")})
  aadd(glob_V021, {"Радиология",57,stod("20151128"),stod("")})
  aadd(glob_V021, {"Радиотерапия",58,stod("20151128"),stod("")})
  aadd(glob_V021, {"Ревматология",59,stod("20151128"),stod("")})
  aadd(glob_V021, {"Рентгенология",60,stod("20151128"),stod("")})
  aadd(glob_V021, {"Рентгенэндоваскулярные диагностика и лечение",61,stod("20151128"),stod("")})
  aadd(glob_V021, {"Рефлексотерапия",62,stod("20151128"),stod("")})
  aadd(glob_V021, {"Санитарно-гигиенические лабораторные исследования",63,stod("20151128"),stod("")})
  aadd(glob_V021, {"Сексология",64,stod("20151128"),stod("")})
  aadd(glob_V021, {"Сердечно-сосудистая хирургия",65,stod("20151128"),stod("")})
  aadd(glob_V021, {"Скорая медицинская помощь",66,stod("20151128"),stod("")})
  aadd(glob_V021, {"Социальная гигиена и организация госсанэпидслужбы",67,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология детская",68,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология общей практики",69,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология ортопедическая",70,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология терапевтическая",71,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология хирургическая",72,stod("20151128"),stod("")})
  aadd(glob_V021, {"Судебно-медицинская экспертиза",73,stod("20151128"),stod("")})
  aadd(glob_V021, {"Судебно-психиатрическая экспертиза",74,stod("20151128"),stod("")})
  aadd(glob_V021, {"Сурдология-оториноларингология",75,stod("20151128"),stod("")})
  aadd(glob_V021, {"Терапия",76,stod("20151128"),stod("")})
  aadd(glob_V021, {"Токсикология",77,stod("20151128"),stod("")})
  aadd(glob_V021, {"Торакальная хирургия",78,stod("20151128"),stod("")})
  aadd(glob_V021, {"Травматология и ортопедия",79,stod("20151128"),stod("")})
  aadd(glob_V021, {"Трансфузиология",80,stod("20151128"),stod("")})
  aadd(glob_V021, {"Ультразвуковая диагностика",81,stod("20151128"),stod("")})
  aadd(glob_V021, {"Управление и экономика фармации",82,stod("20151128"),stod("")})
  aadd(glob_V021, {"Управление сестринской деятельностью",83,stod("20151128"),stod("")})
  aadd(glob_V021, {"Урология",84,stod("20151128"),stod("")})
  aadd(glob_V021, {"Фармацевтическая технология",85,stod("20151128"),stod("")})
  aadd(glob_V021, {"Фармацевтическая химия и фармакогнозия",86,stod("20151128"),stod("")})
  aadd(glob_V021, {"Физиотерапия",87,stod("20151128"),stod("")})
  aadd(glob_V021, {"Фтизиатрия",88,stod("20151128"),stod("")})
  aadd(glob_V021, {"Функциональная диагностика",89,stod("20151128"),stod("")})
  aadd(glob_V021, {"Хирургия",90,stod("20151128"),stod("")})
  aadd(glob_V021, {"Челюстно-лицевая хирургия",91,stod("20151128"),stod("")})
  aadd(glob_V021, {"Эндокринология",92,stod("20151128"),stod("")})
  aadd(glob_V021, {"Эндоскопия",93,stod("20151128"),stod("")})
  aadd(glob_V021, {"Эпидемиология",94,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лечебное дело",95,stod("20170107"),stod("")})
  aadd(glob_V021, {"Медико-профилактическое дело",96,stod("20170107"),stod("")})
  aadd(glob_V021, {"Медицинская биохимия",97,stod("20170107"),stod("")})
  aadd(glob_V021, {"Медицинская биофизика",98,stod("20170107"),stod("")})
  aadd(glob_V021, {"Медицинская кибернетика",99,stod("20170107"),stod("")})
  aadd(glob_V021, {"Сестринское дело",100,stod("20170107"),stod("")})
  aadd(glob_V021, {"Фармация",101,stod("20170107"),stod("")})
  aadd(glob_V021, {"Лечебное дело (средний медперсонал)",206,stod("20151128"),stod("")})
  aadd(glob_V021, {"Акушерское дело (средний медперсонал)",207,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология (средний медперсонал)",208,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология ортопедическая",209,stod("20151128"),stod("")})
  aadd(glob_V021, {"Эпидемиология (паразитология)",210,stod("20151128"),stod("")})
  aadd(glob_V021, {"Гигиеническое воспитание",213,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лабораторная диагностика",215,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лабораторное дело",217,stod("20151128"),stod("")})
  aadd(glob_V021, {"Сестринское дело",219,stod("20151128"),stod("")})
  aadd(glob_V021, {"Сестринское дело в педиатрии",221,stod("20151128"),stod("")})
  aadd(glob_V021, {"Операционное дело",222,stod("20151128"),stod("")})
  aadd(glob_V021, {"Анестезиология и реаниматология",223,stod("20151128"),stod("")})
  aadd(glob_V021, {"Общая практика",224,stod("20151128"),stod("")})
  aadd(glob_V021, {"Функциональная диагностика",226,stod("20151128"),stod("")})
  aadd(glob_V021, {"Физиотерапия",227,stod("20151128"),stod("")})
  aadd(glob_V021, {"Медицинский массаж",228,stod("20151128"),stod("")})
  aadd(glob_V021, {"Лечебная физкультура",230,stod("20151128"),stod("")})
  aadd(glob_V021, {"Диетология",231,stod("20151128"),stod("")})
  aadd(glob_V021, {"Стоматология профилактическая",233,stod("20151128"),stod("")})
  aadd(glob_V021, {"Судебно-медицинская экспертиза",234,stod("20151128"),stod("")})
  aadd(glob_V021, {"Наркология",280,stod("20151128"),stod("")})
  aadd(glob_V021, {"Реабилитационное сестринское дело",281,stod("20151128"),stod("")})
  aadd(glob_V021, {"Скорая и неотложная помощь",283,stod("20151128"),stod("")})
  aadd(glob_V021, {"Бактериология",284,stod("20151128"),stod("")})
  // V015.xml - Классификатор медицинских специальностей
  //  1 - NAME(C)  2 - CODE(N)  3 - HIGH(C)  4 - OKSO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  Public glob_V015 := {}
  aadd(glob_V015, {"Врачебные специальности",0,"","1",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебное дело. Педиатрия",1,"0","2",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-профилактическое дело",2,"0","138",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология",3,"0","154",stod("20131226"),stod("")})
  aadd(glob_V015, {"Фармация",4,"0","161",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сестринское дело",5,"0","165",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская биохимия",6,"0","167",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская биофизика",7,"0","168",stod("20131226"),stod("")})
  aadd(glob_V015, {"Акушерство и гинекология",8,"1","3",stod("20131226"),stod("")})
  aadd(glob_V015, {"Анестезиология и реаниматология",9,"1","8",stod("20131226"),stod("")})
  aadd(glob_V015, {"Дерматовенерология",10,"1","12",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская хирургия",11,"1","125",stod("20131226"),stod("")})
  aadd(glob_V015, {"Генетика",12,"1","14",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",13,"1","18",stod("20131226"),stod("")})
  aadd(glob_V015, {"Неврология",14,"1","23",stod("20131226"),stod("")})
  aadd(glob_V015, {"Неонатология",15,"1","137",stod("20131226"),stod("")})
  aadd(glob_V015, {"Общая врачебная практика (семейная медицина)",16,"1","30",stod("20131226"),stod("")})
  aadd(glob_V015, {"Онкология",17,"1","102",stod("20131226"),stod("")})
  aadd(glob_V015, {"Организация здравоохранения и общественное здоровье",18,"1","56",stod("20131226"),stod("")})
  aadd(glob_V015, {"Оториноларингология",19,"1","38",stod("20131226"),stod("")})
  aadd(glob_V015, {"Офтальмология",20,"1","40",stod("20131226"),stod("")})
  aadd(glob_V015, {"Патологическая анатомия",21,"1","41",stod("20131226"),stod("")})
  aadd(glob_V015, {"Педиатрия",22,"1","105",stod("20131226"),stod("")})
  aadd(glob_V015, {"Психиатрия",23,"1","42",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенология",24,"1","47",stod("20131226"),stod("")})
  aadd(glob_V015, {"Скорая медицинская помощь",25,"1","50",stod("20131226"),stod("")})
  aadd(glob_V015, {"Судебно-медицинская экспертиза",26,"1","57",stod("20131226"),stod("")})
  aadd(glob_V015, {"Терапия",27,"1","58",stod("20131226"),stod("")})
  aadd(glob_V015, {"Травматология и ортопедия",28,"1","80",stod("20131226"),stod("")})
  aadd(glob_V015, {"Фтизиатрия",29,"1","86",stod("20131226"),stod("")})
  aadd(glob_V015, {"Хирургия",30,"1","88",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндокринология",31,"1","99",stod("20131226"),stod("")})
  aadd(glob_V015, {"Инфекционные болезни",32,"1","16",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",33,"8","4",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",34,"8","5",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",35,"8","6",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",36,"8","7",stod("20131226"),stod("")})
  aadd(glob_V015, {"Токсикология",37,"9","9",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",38,"9","10",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",39,"9","11",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая микология",40,"10","13",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская онкология",41,"11","126",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская урология - андрология",42,"11","127",stod("20131226"),stod("")})
  aadd(glob_V015, {"Колопроктология",43,"11","128",stod("20131226"),stod("")})
  aadd(glob_V015, {"Нейрохирургия",44,"11","129",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сердечно-сосудистая хирургия",45,"11","130",stod("20131226"),stod("")})
  aadd(glob_V015, {"Торакальная хирургия",46,"11","131",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",47,"11","132",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",48,"11","133",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",49,"11","134",stod("20131226"),stod("")})
  aadd(glob_V015, {"Челюстно-лицевая хирургия",50,"11","135",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",51,"11","136",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",52,"12","15",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая микология",53,"32","17",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",54,"13","19",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",55,"13","20",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",56,"13","21",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",57,"13","22",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",58,"14","26",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",59,"14","27",stod("20131226"),stod("")})
  aadd(glob_V015, {"Мануальная терапия",61,"14","24",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рефлексотерапия",62,"14","25",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",63,"14","28",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",64,"14","29",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",65,"16","31",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гериатрия",66,"16","32",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",67,"16","33",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",69,"16","34",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",70,"16","35",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",71,"16","36",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",72,"16","37",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская онкология",73,"17","103",stod("20131226"),stod("")})
  aadd(glob_V015, {"Радиология",74,"17","104",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сурдология - оториноларингология",75,"19","39",stod("20131226"),stod("")})
  aadd(glob_V015, {"Аллергология и иммунология",77,"22","110",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",78,"22","111",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гастроэнтерология",79,"22","112",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гематология",80,"22","113",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская кардиология",81,"22","108",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская онкология",82,"22","106",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская эндокринология",83,"22","107",stod("20131226"),stod("")})
  aadd(glob_V015, {"Диетология",84,"22","114",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая фармакология",85,"22","115",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",86,"22","109",stod("20131226"),stod("")})
  aadd(glob_V015, {"Мануальная терапия",88,"22","116",stod("20131226"),stod("")})
  aadd(glob_V015, {"Нефрология",89,"22","117",stod("20131226"),stod("")})
  aadd(glob_V015, {"Пульмонология",90,"22","118",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ревматология",91,"22","119",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",92,"22","120",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",93,"22","121",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",94,"22","122",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",95,"22","123",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",96,"22","124",stod("20131226"),stod("")})
  aadd(glob_V015, {"Психиатрия-наркология",97,"23","46",stod("20131226"),stod("")})
  aadd(glob_V015, {"Психотерапия",98,"23","43",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сексология",99,"23","44",stod("20131226"),stod("")})
  aadd(glob_V015, {"Судебно-психиатрическая экспертиза",100,"23","45",stod("20131226"),stod("")})
  aadd(glob_V015, {"Радиология",102,"24","48",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",103,"24","49",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",104,"25","51",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",105,"25","52",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",107,"25","53",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",108,"25","54",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",109,"25","55",stod("20131226"),stod("")})
  aadd(glob_V015, {"Авиационная и космическая медицина",110,"27","71",stod("20131226"),stod("")})
  aadd(glob_V015, {"Аллергология и иммунология",112,"27","72",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",113,"27","73",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гастроэнтерология",114,"27","59",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гематология",115,"27","60",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гериатрия",116,"27","61",stod("20131226"),stod("")})
  aadd(glob_V015, {"Диетология",117,"27","62",stod("20131226"),stod("")})
  aadd(glob_V015, {"Кардиология",118,"27","63",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая фармакология",119,"27","64",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",120,"27","74",stod("20131226"),stod("")})
  aadd(glob_V015, {"Мануальная терапия",122,"27","75",stod("20131226"),stod("")})
  aadd(glob_V015, {"Нефрология",123,"27","65",stod("20131226"),stod("")})
  aadd(glob_V015, {"Профпатология",124,"27","76",stod("20131226"),stod("")})
  aadd(glob_V015, {"Пульмонология",125,"27","66",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ревматология",126,"27","67",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рефлексотерапия",127,"27","77",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",128,"27","68",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",129,"27","69",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",130,"27","78",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",131,"27","70",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",132,"27","79",stod("20131226"),stod("")})
  aadd(glob_V015, {"Восстановительная медицина",133,"28","82",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура и спортивная медицина",134,"28","83",stod("20131226"),stod("")})
  aadd(glob_V015, {"Мануальная терапия",136,"28","81",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",137,"28","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Пульмонология",138,"29","87",stod("20131226"),stod("")})
  aadd(glob_V015, {"Колопроктология",139,"30","89",stod("20131226"),stod("")})
  aadd(glob_V015, {"Нейрохирургия",140,"30","90",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сердечно-сосудистая хирургия",141,"30","92",stod("20131226"),stod("")})
  aadd(glob_V015, {"Торакальная хирургия",142,"30","93",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",143,"30","94",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",144,"30","97",stod("20131226"),stod("")})
  aadd(glob_V015, {"Урология",145,"30","91",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",146,"30","98",stod("20131226"),stod("")})
  aadd(glob_V015, {"Челюстно-лицевая хирургия",147,"30","95",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эндоскопия",148,"30","96",stod("20131226"),stod("")})
  aadd(glob_V015, {"Детская эндокринология",149,"31","101",stod("20131226"),stod("")})
  aadd(glob_V015, {"Диабетология",150,"31","100",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",151,"2","139",stod("20131226"),stod("")})
  aadd(glob_V015, {"Общая гигиена",152,"2","145",stod("20131226"),stod("")})
  aadd(glob_V015, {"Социальная гигиена и организация госсанэпидслужбы",153,"2","153",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эпидемиология",154,"2","142",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",155,"151","140",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",156,"151","141",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",157,"151","202",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",158,"151","203",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиена детей и подростков",159,"152","146",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиена питания",160,"152","148",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиена труда",161,"152","149",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиеническое воспитание",162,"152","147",stod("20131226"),stod("")})
  aadd(glob_V015, {"Коммунальная гигиена",163,"152","150",stod("20131226"),stod("")})
  aadd(glob_V015, {"Радиационная гигиена",164,"152","151",stod("20131226"),stod("")})
  aadd(glob_V015, {"Санитарно-гигиенические лабораторные исследования",165,"152","152",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",167,"154","204",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",168,"154","205",stod("20131226"),stod("")})
  aadd(glob_V015, {"Дезинфектология",169,"154","143",stod("20131226"),stod("")})
  aadd(glob_V015, {"Паразитология",170,"154","144",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология общей практики",171,"3","155",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",172,"3","206",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ортодонтия",173,"171","156",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология детская",174,"171","157",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология ортопедическая",175,"171","159",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология терапевтическая",176,"171","158",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология хирургическая",177,"171","160",stod("20131226"),stod("")})
  aadd(glob_V015, {"Челюстно-лицевая хирургия",178,"171","207",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",179,"171","208",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",180,"172","209",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",181,"172","210",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",182,"172","211",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",183,"172","212",stod("20131226"),stod("")})
  aadd(glob_V015, {"Управление и экономика фармации",184,"4","162",stod("20131226"),stod("")})
  aadd(glob_V015, {"Фармацевтическая химия и фармакогнозия",185,"4","164",stod("20131226"),stod("")})
  aadd(glob_V015, {"Управление сестринской деятельностью",186,"5","166",stod("20131226"),stod("")})
  aadd(glob_V015, {"Генетика",187,"6","213",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",188,"187","216",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",189,"6","214",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",190,"189","217",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",191,"189","218",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",192,"189","220",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",193,"189","219",stod("20131226"),stod("")})
  aadd(glob_V015, {"Судебно-медицинская экспертиза",194,"6","215",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",195,"7","221",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенология",196,"7","222",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",197,"195","223",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",198,"195","224",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",199,"195","225",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",200,"195","226",stod("20131226"),stod("")})
  aadd(glob_V015, {"Радиология",201,"196","227",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",202,"196","228",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",203,"196","229",stod("20131226"),stod("")})
  aadd(glob_V015, {"Средний медицинский персонал",204,"","169",stod("20131226"),stod("")})
  aadd(glob_V015, {"Организация сестринского дела",205,"204","170",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебное дело",206,"204","171",stod("20131226"),stod("")})
  aadd(glob_V015, {"Акушерское дело",207,"204","172",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология",208,"204","173",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология ортопедическая",209,"204","174",stod("20131226"),stod("")})
  aadd(glob_V015, {"Эпидемиология (паразитология)",210,"204","175",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиена и санитария",211,"204","176",stod("20131226"),stod("")})
  aadd(glob_V015, {"Дезинфекционное дело",212,"204","177",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гигиеническое воспитание",213,"204","178",stod("20131226"),stod("")})
  aadd(glob_V015, {"Энтомология",214,"204","179",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная диагностика",215,"204","180",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гистология",216,"204","181",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторное дело",217,"204","182",stod("20131226"),stod("")})
  aadd(glob_V015, {"Фармация",218,"204","183",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сестринское дело",219,"204","184",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сестринское дело в педиатрии",221,"204","185",stod("20131226"),stod("")})
  aadd(glob_V015, {"Операционное дело",222,"204","186",stod("20131226"),stod("")})
  aadd(glob_V015, {"Анестезиология и реаниматология",223,"204","187",stod("20131226"),stod("")})
  aadd(glob_V015, {"Общая практика",224,"204","188",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенология",225,"204","189",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",226,"204","190",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",227,"204","191",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинский массаж",228,"204","192",stod("20131226"),stod("")})
  aadd(glob_V015, {"Фармацевтическая технология",229,"4","163",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лечебная физкультура",230,"204","193",stod("20131226"),stod("")})
  aadd(glob_V015, {"Диетология",231,"204","194",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская статистика",232,"204","195",stod("20131226"),stod("")})
  aadd(glob_V015, {"Стоматология профилактическая",233,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Судебно-медицинская экспертиза",234,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская оптика",235,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",236,"27","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",237,"28","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",238,"29","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",239,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",240,"31","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",241,"11","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",242,"14","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",243,"17","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",244,"19","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",245,"20","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная экспертиза",246,"22","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Пластическая хирургия",247,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",248,"30","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",249,"31","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",250,"8","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",251,"8","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Косметология",252,"10","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",253,"11","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",254,"14","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Аллергология и иммунология",255,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Водолазная медицина",256,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гастроэнтерология",257,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Гематология",258,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Диетология",259,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Кардиология",260,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Нефрология",261,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Пульмонология",262,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ревматология",263,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Трансфузиология",264,"16","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",265,"17","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенэндоваскулярные диагностика и лечение",266,"24","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Организация здравоохранения и общественное здоровье",267,"2","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Организация здравоохранения и общественное здоровье",268,"3","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская кибернетика",269,"0","168",stod("20131226"),stod("")})
  aadd(glob_V015, {"Клиническая лабораторная диагностика",270,"269","221",stod("20131226"),stod("")})
  aadd(glob_V015, {"Рентгенология",271,"269","222",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",272,"270","223",stod("20131226"),stod("")})
  aadd(glob_V015, {"Вирусология",273,"270","224",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная генетика",274,"270","225",stod("20131226"),stod("")})
  aadd(glob_V015, {"Лабораторная микология",275,"270","226",stod("20131226"),stod("")})
  aadd(glob_V015, {"Радиология",276,"271","227",stod("20131226"),stod("")})
  aadd(glob_V015, {"Функциональная диагностика",277,"271","228",stod("20131226"),stod("")})
  aadd(glob_V015, {"Ультразвуковая диагностика",278,"271","229",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медико-социальная помощь",279,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Наркология",280,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Реабилитационное сестринское дело",281,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Сестринское дело в косметологии",282,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Скорая и неотложная помощь",283,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Бактериология",284,"204","",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиология",285,"28","84",stod("20131226"),stod("")})
  aadd(glob_V015, {"Физиотерапия",286,"1","85",stod("20131226"),stod("")})
  aadd(glob_V015, {"Естественные науки",287,"0","196",stod("20131226"),stod("")})
  aadd(glob_V015, {"Биофизика",288,"287","197",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская биофизика",289,"287","198",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская кибернетика",290,"287","199",stod("20131226"),stod("")})
  aadd(glob_V015, {"Биохимия",3200,"287","200",stod("20131226"),stod("")})
  aadd(glob_V015, {"Медицинская биохимия",3201,"287","201",stod("20131226"),stod("")})

  // массив перекодировки специальностей из V004 в V015
  Public glob_arr_V004_V015 := {;
    {     1,  0,"Высшее медицинское образование"},;
    {    11,  1,"Лечебное дело. Педиатрия"},;
    {  1101,  8,"Акушерство и гинекология"},;
    {110101, 33,"Ультразвуковая диагностика"},;
    {110102, 34,"Физиотерапия"},;
    {110103, 35,"Функциональная диагностика"},;
    {110104, 36,"Эндоскопия"},;
    {  1103,  9,"Анестезиология и реаниматология"},;
    {110301, 37,"Токсикология"},;
    {110302, 38,"Трансфузиология"},;
    {110303, 39,"Функциональная диагностика"},;
    {  1104, 10,"Дерматовенерология"},;
    {110401, 40,"Клиническая микология"},;
    {  1105, 12,"Генетика"},;
    {110501, 52,"Лабораторная генетика"},;
    {  1106, 32,"Инфекционные болезни"},;
    {110601, 53,"Клиническая микология"},;
    {  1107, 13,"Клиническая лабораторная диагностика"},;
    {110701, 54,"Бактериология"},;
    {110702, 55,"Вирусология"},;
    {110703, 56,"Лабораторная генетика"},;
    {110704, 57,"Лабораторная микология"},;
    {  1109, 14,"Неврология"},;
    {110901, 61,"Мануальная терапия"},;
    {110902, 62,"Рефлексотерапия"},;
    {110903, 58,"Восстановительная медицина"},;
    {110904, 59,"Лечебная физкультура и спортивная медицина"},;
    {110905, 63,"Физиотерапия"},;
    {110906, 64,"Функциональная диагностика"},;
    {  1110, 16,"Общая врачебная практика (семейная медицина)"},;
    {111001, 65,"Восстановительная медицина"},;
    {111002, 66,"Гериатрия"},;
    {111003, 67,"Лечебная физкультура и спортивная медицина"},;
    {111004, 69,"Ультразвуковая диагностика"},;
    {111005, 70,"Физиотерапия"},;
    {111006, 71,"Функциональная диагностика"},;
    {111007, 72,"Эндоскопия"},;
    {  1111, 19,"Отоларингология"},;
    {111101, 75,"Сурдология-отоларингология"},;
    {  1112, 20,"Офтальмология"},;
    {  1113, 21,"Патологическая анатомия"},;
    {  1115, 23,"Психиатрия"},;
    {111501, 98,"Психотерапия"},;
    {111502, 99,"Сексология"},;
    {111503,100,"Судебно-психиатрическая экспертиза"},;
    {111504, 97,"Психиатрия-наркология"},;
    {  1118, 24,"Рентгенология"},;
    {111801,102,"Радиология"},;
    {111802,103,"Ультразвуковая диагностика"},;
    {  1119, 25,"Скорая медицинская помощь"},;
    {111901,104,"Восстановительная медицина"},;
    {111902,105,"Лечебная физкультура и спортивная медицина"},;
    {111903,107,"Ультразвуковая диагностика"},;
    {111904,108,"Физиотерапия"},;
    {111905,109,"Функциональная диагностика"},;
    {  1120, 18,"Организация здравоохранения и общественное здоровье"},;
    {  1121, 26,"Судебно-медицинская экспертиза"},;
    {  1122, 27,"Терапия"},;
    {112201,114,"Гастроэнтерология"},;
    {112202,115,"Гематология"},;
    {112203,116,"Гериатрия"},;
    {112204,117,"Диетология"},;
    {112205,118,"Кардиология"},;
    {112206,119,"Клиническая фармакология"},;
    {112207,123,"Нефрология"},;
    {112208,125,"Пульмонология"},;
    {112209,126,"Ревматология"},;
    {112210,128,"Трансфузиология"},;
    {112211,129,"Ультразвуковая диагностика"},;
    {112212,131,"Функциональная диагностика"},;
    {112213,110,"Авиационная и космическая медицина"},;
    {112214,112,"Аллергология и иммунология"},;
    {112215,113,"Восстановительная медицина"},;
    {112216,120,"Лечебная физкультура и спортивная медицина"},;
    {112217,122,"Мануальная терапия"},;
    {112218,124,"Профпатология"},;
    {112219,127,"Рефлексотерапия"},;
    {112220,130,"Физиотерапия"},;
    {112221,132,"Эндоскопия"},;
    {  1123, 28,"Травматология и ортопедия"},;
    {112301,136,"Мануальная терапия"},;
    {112302,133,"Восстановительная медицина"},;
    {112303,134,"Лечебная физкультура и спортивная медицина"},;
    {112304,285,"Физиология"},;
    {  1124,137,"Физиотерапия"},;
    {  1125, 29,"Фтизиатрия"},;
    {112501,138,"Пульмонология"},;
    {  1126, 30,"Хирургия"},;
    {112601,139,"Колопроктология"},;
    {112602,140,"Нейрохирургия"},;
    {112603,145,"Урология"},;
    {112604,141,"Сердечно-сосудистая хирургия"},;
    {112605,142,"Торакальная хирургия"},;
    {112606,143,"Трансфузиология"},;
    {112608,147,"Челюстно-лицевая хирургия"},;
    {112609,148,"Эндоскопия"},;
    {112610,144,"Ультразвуковая диагностика"},;
    {112611,146,"Функциональная диагностика"},;
    {  1127, 31,"Эндокринология"},;
    {112701,150,"Диабетология"},;
    {112702,149,"Детская эндокринология"},;
    {  1128, 17,"Онкология"},;
    {112801, 73,"Детская онкология"},;
    {112802, 74,"Радиология"},;
    {  1134, 22,"Педиатрия"},;
    {113401, 82,"Детская онкология"},;
    {113402, 83,"Детская эндокринология"},;
    {113403, 81,"Детская кардиология"},;
    {113404, 86,"Лечебная физкультура и спортивная медицина"},;
    {113405, 77,"Аллергология и иммунология"},;
    {113406, 78,"Восстановительная медицина"},;
    {113407, 79,"Гастроэнтерология"},;
    {113408, 80,"Гематология"},;
    {113409, 84,"Диетология"},;
    {113410, 85,"Клиническая фармакология"},;
    {113411, 88,"Мануальная терапия"},;
    {113412, 89,"Нефрология"},;
    {113413, 90,"Пульмонология"},;
    {113414, 91,"Ревматология"},;
    {113415, 92,"Трансфузиология"},;
    {113416, 93,"Ультразвуковая диагностика"},;
    {113417, 94,"Физиотерапия"},;
    {113418, 95,"Функциональная диагностика"},;
    {113419, 96,"Эндоскопия"},;
    {  1135, 11,"Детская хирургия"},;
    {113501, 41,"Детская онкология"},;
    {113502, 42,"Детская урология-андрология"},;
    {113503, 43,"Колопроктология"},;
    {113504, 44,"Нейрохирургия"},;
    {113505, 45,"Сердечно-сосудистая хирургия"},;
    {113506, 46,"Торакальная хирургия"},;
    {113507, 47,"Трансфузиология"},;
    {113508, 48,"Ультразвуковая диагностика"},;
    {113509, 49,"Функциональная диагностика"},;
    {113510, 50,"Челюстно-лицевая хирургия"},;
    {113511, 51,"Эндоскопия"},;
    {  1136, 15,"Неонатология"},;
    {    13,  2,"Медико-профилактическое дело"},;
    {  1301,151,"Клиническая лабораторная диагностика"},;
    {130101,155,"Бактериология"},;
    {130102,156,"Вирусология"},;
    {130103,157,"Лабораторная генетика"},;
    {130104,158,"Лабораторная микология"},;
    {  1302,154,"Эпидемиология"},;
    {130201,167,"Бактериология"},;
    {130203,169,"Дезинфектология"},;
    {130204,170,"Паразитология"},;
    {130205,168,"Вирусология"},;
    {  1303,152,"Общая гигиена"},;
    {130301,159,"Гигиена детей и подростков"},;
    {130302,162,"Гигиеническое воспитание"},;
    {130303,160,"Гигиена питания"},;
    {130304,161,"Гигиена труда"},;
    {130305,163,"Коммунальная гигиена"},;
    {130306,164,"Радиационная гигиена"},;
    {130307,165,"Санитарно-гигиенические лабораторные исследования"},;
    {  1306,153,"Социальная гигиена и организация госсанэпидслужбы"},;
    {    14,  3,"Стоматология"},;
    {  1401,171,"Стоматология общей практики"},;
    {140101,173,"Ортодонтия"},;
    {140102,174,"Стоматология детская"},;
    {140103,176,"Стоматология терапевтическая"},;
    {140104,175,"Стоматология ортопедическая"},;
    {140105,177,"Стоматология хирургическая"},;
    {140106,178,"Челюстно-лицевая хирургия"},;
    {140107,179,"Физиотерапия"},;
    {  1402,172,"Клиническая лабораторная диагностика"},;
    {140201,180,"Бактериология"},;
    {140202,181,"Вирусология"},;
    {140203,182,"Лабораторная генетика"},;
    {140204,183,"Лабораторная микология"},;
    {    15,  4,"Фармация"},;
    {  1501,184,"Управление и экономика фармации"},;
    {  1502,229,"Фармацевтическая технология"},;
    {  1503,185,"Фармацевтическая химия и фармакогнозия"},;
    {    16,  5,"Сестринское дело"},;
    {  1601,186,"Управление сестринской деятельностью"},;
    {    17,  6,"Медицинская биохимия"},;
    {  1701,187,"Генетика"},;
    {170101,188,"Лабораторная генетика"},;
    {  1702,189,"Клиническая лабораторная диагностика"},;
    {170201,190,"Бактериология"},;
    {170202,191,"Вирусология"},;
    {170203,193,"Лабораторная генетика"},;
    {170204,192,"Лабораторная микология"},;
    {  1703,194,"Судебно-медицинская экспертиза"},;
    {    18,  7,"Медицинская биофизика. Медицинская кибернетика"},;
    {  1801,195,"Клиническая лабораторная диагностика"},;
    {180101,197,"Бактериология"},;
    {180102,198,"Вирусология"},;
    {180103,199,"Лабораторная генетика"},;
    {180104,200,"Лабораторная микология"},;
    {  1802,196,"Рентгенология"},;
    {180201,201,"Радиология"},;
    {180202,202,"Функциональная диагностика"},;
    {180203,203,"Ультразвуковая диагностика"},;
    {     2,204,"Среднее медицинское и фармацевтическое образование"},;
    {  2001,205,"Организация сестринского дела"},;
    {  2002,206,"Лечебное дело"},;
    {  2003,207,"Акушерское дело"},;
    {  2004,208,"Стоматология"},;
    {  2005,209,"Стоматология ортопедическая"},;
    {  2006,210,"Эпидемиология (паразитология)"},;
    {  2007,211,"Гигиена и санитария"},;
    {  2008,212,"Дезинфекционное дело"},;
    {  2009,213,"Гигиеническое воспитание"},;
    {  2010,214,"Энтомология"},;
    {  2011,215,"Лабораторная диагностика"},;
    {  2012,216,"Гистология"},;
    {  2013,217,"Лабораторное дело"},;
    {  2014,218,"Фармация"},;
    {  2015,219,"Сестринское дело"},;
    {  2016,221,"Сестринское дело в педиатрии"},;
    {  2017,222,"Операционное дело"},;
    {  2019,223,"Анестезиология и реаниматология"},;
    {  2019,224,"Общая практика"},;
    {  2020,225,"Рентгенология"},;
    {  2021,226,"Функциональная диагностика"},;
    {  2022,227,"Физиотерапия"},;
    {  2023,228,"Медицинский массаж"},;
    {  2024,230,"Лечебная физкультура"},;
    {  2025,231,"Диетология"},;
    {  2026,232,"Медицинская статистика"},;
    {  2027,233,"Стоматология профилактическая"},;
    {  2028,234,"Судебно-медицинская экспертиза"},;
    {  2029,235,"Медицинская оптика"},;
    {     3,287,"Естественные науки"},;
    {    31,288,"Биофизика"},;
    {  3101,289,"Медицинская биофизика"},;
    {  3102,290,"Медицинская кибернетика"},;
    {    32,3200,"Биохимия"},;
    {  3201,3201,"Медицинская биохимия"};
  }
  return NIL
  
  