/// Справочники ФФОМС
#include "dict_error.ch"

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 11.02.22
Function work_V002(source, destination)
  local _mo_V002 := {;
    {"IDPR",       "N",      3,      0},;
    {"PRNAME",     "C",    250,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nCol

  dbcreate(destination + "_mo_v002", _mo_V002)
  use (destination + '_mo_V002') new alias V002
  nfile := source + "V002.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V002.xml     - Классификатор профилей оказанной медицинской помощи (ProfOt)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    @ row() + 1, 1 say "Обработка файла " + nfile + " -"
    nCol := Col()
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j / k * 100, 6, 2 ) + "%"
        mDATEEND := CToD('  /  /    ')
        mIDPR := mo_read_xml_stroke(oXmlNode,"IDPR",)
        mPRNAME := mo_read_xml_stroke(oXmlNode,"PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < FIRST_DAY  //0d20210101
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

***** 11.02.22
Function work_V016(source, destination)
  local _mo_V016 := {;
    {"IDDT",      "C",   3, 0},;  // Код типа диспансеризации
    {"DTNAME",    "C", 254, 0},;  // Наименование типа диспансеризации
    {"RULE",      "C",  40, 0},;  // Значение результата диспансеризации (список) (V017)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local mRULE := ''
  local nCol

  dbcreate(destination + "_mo_v016", _mo_V016)
  use (destination + '_mo_v016') new alias V016
  nfile := source + "V016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V016.xml     - Классификатор типов диспансеризации (DispT)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    @ row() + 1, 1 say "Обработка файла " + nfile + " -"
    nCol := Col()
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 11.02.22
Function work_V017(source, destination)
  local _mo_V017 := {;
    {"IDDR",      "N",   2, 0},;  // Код результата диспансеризации
    {"DRNAME",    "C", 254, 0},;  // Наименование результата диспансеризации
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v017", _mo_V017)
  use (destination + '_mo_v017') new alias V017
  nfile := source + "V017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V017.xml     - Классификатор результатов диспансеризации (DispR)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    @ row()+ 1, 1 say "Обработка файла " + nfile + " -"
    nCol := Col()
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

***** 11.02.22
Function work_V021(source, destination)

  local _mo_V021 := {;
    {"IDSPEC",     "N",      3,      0},;
    {"SPECNAME",   "C",    250,      0},;
    {"POSTNAME",   "C",    250,      0},;
    {"IDPOST_MZ",  "C",      4,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nCol

  dbcreate(destination + "_mo_v021", _mo_V021)
  use (destination + '_mo_V021') new alias V021
  nfile := source + "V021.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V021.xml     - Классификатор медицинских специальностей (должностей) (MedSpec)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    obrabotka(nfile)
    nCol := Col()
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

* 12.02.22 вернуть массив по справочнику регионов ТФОМС V002.xml
function getV002(destination)
  // V002.xml - 
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V002"
  local _v002 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v002, { (dbName)->PRNAME, (dbName)->IDPR, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v002

***** 11.02.22
Function work_V009(source, destination)
  local _mo_V009 := {;
    {"IDRMP",     "N",   3, 0},;  // Код результата обращения
    {"RMPNAME",   "C", 254, 0},;  // Наименование результата обращения
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания медицинской помощи (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v009", _mo_V009)
  use (destination + '_mo_v009') new alias V009
  nfile := source + "V009.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V009.xml     - Классификатор результатов обращения за медицинской помощью (Rezult)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    obrabotka(nfile)
    nCol := Col()
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 11.02.22
Function work_V010(source, destination)
  local _mo_V010 := {;
    {"IDSP",      "N",   2, 0},;  // Код способа оплаты медицинской помощи
    {"SPNAME",    "C", 254, 0},;  // Наименование способа оплаты медицинской помощи
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v010", _mo_V010)
  use (destination + '_mo_v010') new alias V010
  nfile := source + "V010.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V010.xml     - Классификатор способов оплаты медицинской помощи (Sposob)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 11.02.22
Function work_V012(source, destination)
  local _mo_V012 := {;
    {"IDIZ",      "N",   3, 0},;  // Код исхода заболевания
    {"IZNAME",    "C", 254, 0},;  // Наименование исхода заболевания
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания МП (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v012", _mo_V012)
  use (destination + '_mo_v012') new alias V012
  nfile := source + "V012.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V012.xml     - Классификатор исходов заболевания (Ishod)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

* 12.02.22 вернуть массив по справочнику ТФОМС V021.xml
function getV021(destination)
  // V021.xml - Классификатор медицинских специальностей (последний)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V021"
  local _v021 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v021, { (dbName)->SPECNAME, (dbName)->IDSPEC, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v021

***** 12.02.22
Function work_V015(source, destination)
  local _mo_V015 := {;
    {"NAME",   "C",  254,      0},;
    {"CODE",   "N",    4,      0},;
    {"HIGH",   "C",    4,      0},;
    {"OKSO",   "C",    3,      0},;
    {"DATEBEG","D",    8,      0},;
    {"DATEEND","D",    8,      0},;
    {"RECID",  "N",    3,      0};
  }
  local nCol

  dbcreate(destination + "_mo_v015", _mo_V015)
  use (destination + '_mo_V015') new alias V015
  nfile := source + "V015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V015.xml     - Классификатор медицинских специальностей (Medspec)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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
  
***** 12.02.22
Function work_V018(source, destination)
  local _mo_V018 := {;
    {"IDHVID",     "C",     12,      0},;
    {"HVIDNAME",   "C",    254,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"HVIDNAME",   "M",     10,      0},;
  local nCol

  dbcreate(destination + "_mo_v018", _mo_V018)
  use (destination + '_mo_V018') new alias V018
  // index on kod to tmp_shema
  nfile := source + "V018.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V018.xml     - виды высокотехнологичной медицинской помощи (HVid)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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
  
***** 10.02.22
Function work_V019(source, destination)
  local _mo_V019 := {;
    {"IDHM",       "N",      4,      0},; // Идентификатор метода высокотехнологичной медицинской помощи
    {"HMNAME",     "C",    254,      0},; // Наименование метода высокотехнологичной медицинской помощи
    {"DIAG",       "M",     10,      0},; // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
    {"HVID",       "C",     12,      0},; // Код вида высокотехнологичной медицинской помощи для данного метода
    {"HGR",        "N",      3,      0},; // Номер группы высокотехнологичной медицинской помощи для данного метода
    {"HMODP",      "C",    254,      0},; // Модель пациента для методов высокотехнологичной медицинской помощи с одинаковыми значениями поля "HMNAME". Не заполняется, начиная с версии 3.0
    {"IDMODP",     "N",      5,      0},; // Идентификатор модели пациента для данного метода (начиная с версии 3.0, заполняется значением поля IDMPAC классификатора V022)
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }
  // {"DIAG",       "C",    700,      0},; // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
  local nCol

  dbcreate(destination + "_mo_v019",_mo_V019)
  use (destination + '_mo_V019') new alias V019
  nfile := source + "V019.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V019.xml     - методы высокотехнологичной медицинской помощи (HMet)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        // @ row(),30 say str(j/k*100,6,2)+"%"
        @ row(), nCol say str(j/k*100,6,2)+"%"
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
        if upper(alltrim(mHMODP)) != 'NULL'
          V019->HMODP := mHMODP
        endif
        V019->IDMODP := val(mIDMODP)
        // V019->DATEBEG := mDATEBEG
        V019->DATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        // V019->DATEEND := mDATEEND
        V019->DATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
      endif
    NEXT j
  ENDIF
  return NIL

***** 12.02.22
Function work_V020(source, destination)
  local _mo_V020 := {;
    {"IDK_PR",     "N",      3,      0},; // Код профиля койки
    {"K_PRNAME",   "C",    254,      0},; // Наименование профиля койки
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v020", _mo_V020)
  use (destination + '_mo_v020') new alias V020
  nfile := source + "V020.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V020.xml     - Классификатор профиля койки (KoPr)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 11.02.22
Function work_V022(source, destination)
  local _mo_V022 := {;
    {"IDMPAC",     "N",      5,      0},;
    {"MPACNAME",   "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"MPACNAME",   "C",   1250,      0},;
  local nCol
  
  dbcreate(destination + "_mo_v022",_mo_V022)
  use (destination + '_mo_V022') new alias V022
  nfile := source + "V022.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V022.xml     - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        // @ row(),30 say str(j/k*100,6,2)+"%"
        @ row(), nCol say str(j / k * 100, 6, 2) + "%"
        mIDMPAC := mo_read_xml_stroke(oXmlNode,"IDMPAC",)
        mMPACNAME := mo_read_xml_stroke(oXmlNode,"MPACNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        if mDATEBEG >= FIRST_DAY .or. Empty(mDATEEND)  //0d20210101
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

***** 12.02.22
Function work_V025(source, destination)
  local _mo_V025 := {;
    {"IDPC",      "C",   3, 0},;  // Код цели посещения
    {"N_PC",      "C", 254, 0},;  // Наименование цели посещения
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v025", _mo_V025)
  use (destination + '_mo_V025') new alias V025
  // index on kod to tmp_shema
  nfile := source + "V025.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V025.xml     - Классификатор целей посещения (KPC)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function work_V030(source, destination)
  local _mo_V030 := {;
    {"SCHEMCOD",  "C",   3, 0},;  // 
    {"SCHEME",    "C",  10, 0},;  //
    {"DEGREE",    "N",   2, 0},;  //
    {"COMMENT",   "M",  10, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v030", _mo_V030)
  use (destination + '_mo_V030') new alias V030
  nfile := source + "V030.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V030.xml     - Схемы лечения заболевания COVID-19 (TreatReg)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mSchemCod := mo_read_xml_stroke(oXmlNode,"SchemCode",)
        mScheme := mo_read_xml_stroke(oXmlNode,"Scheme",)
        mDegree := mo_read_xml_stroke(oXmlNode,"DegreeSeverity",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V030
        append blank
        V030->SCHEMCOD := mSchemCod
        V030->SCHEME := mScheme
        V030->DEGREE := val(mDegree)
        V030->COMMENT := mComment
        V030->DATEBEG := mDATEBEG
        V030->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V031(source, destination)
  local _mo_V031 := {;
    {"DRUGCODE",  "N",   2, 0},;  // 
    {"DRUGGRUP",  "C",  50, 0},;  //
    {"INDMNN",    "N",   2, 0},;  // Признак обязательности указания МНН (1-да, 0-нет)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v031", _mo_V031)
  use (destination + '_mo_V031') new alias V031
  nfile := source + "V031.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V031.xml     - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mDrugCode := mo_read_xml_stroke(oXmlNode,"DrugGroupCode",)
        mDrugGrup := mo_read_xml_stroke(oXmlNode,"DrugGroup",)
        mIndMNN := mo_read_xml_stroke(oXmlNode,"ManIndMNN",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V031
        append blank
        V031->DRUGCODE := val(mDrugCode)
        V031->DRUGGRUP := mDrugGrup
        V031->INDMNN := val(mIndMNN)
        V031->DATEBEG := mDATEBEG
        V031->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V032(source, destination)
  local _mo_V032 := {;
    {"SCHEDRUG",  "C",  10, 0},;  // Сочетание схемы лечения и группы препаратов
    {"NAME",      "C", 100, 0},;  //
    {"SCHEMCOD",  "C",   3, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v032", _mo_V032)
  use (destination + '_mo_V032') new alias V032
  nfile := source + "V032.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V032.xml     - Сочетание схемы лечения и группы препаратов (CombTreat)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mScheDrug := mo_read_xml_stroke(oXmlNode,"ScheDrugGrCd",)
        mName := mo_read_xml_stroke(oXmlNode,"Name",)
        mSchemCod := mo_read_xml_stroke(oXmlNode,"SchemCode",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V032
        append blank
        V032->SCHEDRUG := mScheDrug
        V032->NAME := mName
        V032->SCHEMCOD := mSchemCod
        V032->DATEBEG := mDATEBEG
        V032->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V033(source, destination)
  local _mo_V033 := {;
    {"SCHEDRUG",  "C",   5, 0},;  // 
    {"DRUGCODE",  "C",   6, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v033", _mo_V033)
  use (destination + '_mo_V033') new alias V033
  nfile := source + "V033.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V033.xml     - Соответствие кода препарата схеме лечения (DgTreatReg)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mScheDrug := mo_read_xml_stroke(oXmlNode,"ScheDrugGrCd",)
        mDrugCode := mo_read_xml_stroke(oXmlNode,"DrugCode",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V033
        append blank
        V033->SCHEDRUG := mScheDrug
        V033->DRUGCODE := mDrugCode
        V033->DATEBEG := mDATEBEG
        V033->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V034(source, destination)
  local _mo_V034 := {;
    {"UNITCODE",  "N",   3, 0},;  // код единицы измерения дозы
    {"UNITMEAS",  "C",  50, 0},;  //
    {"SHORTTIT",  "C",  15, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v034", _mo_V034)
  use (destination + '_mo_V034') new alias V034
  nfile := source + "V034.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V034.xml     - Единицы измерения (UnitMeas)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mUnitCode := mo_read_xml_stroke(oXmlNode,"UnitCode",)
        mUnitMeas := mo_read_xml_stroke(oXmlNode,"UnitMeasur",)
        mShortTit := mo_read_xml_stroke(oXmlNode,"ShortTitle",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V034
        append blank
        V034->UNITCODE := val(mUnitCode)
        V034->UNITMEAS := mUnitMeas
        V034->SHORTTIT := mShortTit
        V034->DATEBEG := mDATEBEG
        V034->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V035(source, destination)
  local _mo_V035 := {;
    {"METHCODE",  "N",   3, 0},;  // 
    {"METHNAME",   "C",  50, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v035", _mo_V035)
  use (destination + '_mo_V035') new alias V035
  nfile := source + "V035.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V035.xml     - Способы введения (MethIntro)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mMethCode := mo_read_xml_stroke(oXmlNode,"MethCode",)
        mMethName := mo_read_xml_stroke(oXmlNode,"MethNam",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V035
        append blank
        V035->METHCODE := val(mMethCode)
        V035->METHNAME := mMethName
        V035->DATEBEG := mDATEBEG
        V035->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V036(source, destination)
  local _mo_V036 := {;
    {"S_CODE",    "C",  16, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v036", _mo_V036)
  use (destination + '_mo_V036') new alias V036
  nfile := source + "V036.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V036.xml     - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mS_Code := mo_read_xml_stroke(oXmlNode,"S_CODE",)
        mName := mo_read_xml_stroke(oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke(oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V036
        append blank
        V036->S_CODE := mS_Code
        V036->NAME := mName
        V036->PARAM := val(mParam)
        V036->COMMENT := mComment
        V036->DATEBEG := mDATEBEG
        V036->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function work_V037(source, destination)
  local _mo_V037 := {;
    {"CODE",      "N",   5, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nCol

  dbcreate(destination + "_mo_v037", _mo_V037)
  use (destination + '_mo_V037') new alias V037
  nfile := source + "V037.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V037.xml     - Перечень методов ВМП, требующих имплантацию медицинских изделий"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
        mCode := mo_read_xml_stroke(oXmlNode,"CODE",)
        mName := mo_read_xml_stroke(oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke(oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke(oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        select V037
        append blank
        V037->CODE := val(mCode)
        V037->NAME := mName
        V037->PARAM := val(mParam)
        V037->COMMENT := mComment
        V037->DATEBEG := mDATEBEG
        V037->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 12.02.22
Function make_Q015(source, destination)

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
  local nCol

  dbcreate(destination + "_mo_q015", _mo_Q015)
  use (destination + '_mo_Q015') new alias Q015
  nfile := source + "Q015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q015.xml     - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_Q016(source, destination)

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
  local nCol

  dbcreate(destination + "_mo_q016", _mo_Q016)
  use (destination + '_mo_Q016') new alias Q016
  nfile := source + "Q016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q016.xml     - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_Q017(source, destination)

  local _mo_Q017 := {;
    {"ID_KTEST",   "C",      4,      0},;
    {"NAM_KTEST",  "C",    250,      0},;
    {"COMMENT",    "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nCol

  dbcreate(destination + "_mo_q017", _mo_Q017)
  use (destination + '_mo_Q017') new alias Q017
  nfile := source + "Q017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "Q017.xml     - Перечень категорий проверок ФЛК и МЭК (TEST_K)"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_O001(source, destination)

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
  local mName := '', mArr, nCol

  dbcreate(destination + "_mo_o001", _mo_O001)
  use (destination + '_mo_O001') new alias O001
  nfile := source + "O001.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "O001.xml     - Общероссийский классификатор стран мира (OKSM) "
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_F006(source, destination)

  //  1 - VIDNAME(C)  2 - IDVID(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local _mo_F006 := {;
    { 'IDVID',      'N',    2,      0 },;
    { 'VIDNAME',    'M',   10,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr, nCol

  dbcreate(destination + '_mo_f006', _mo_F006)
  use (destination + '_mo_f006') new alias F006
  nfile := source + 'F006.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F006.xml     - Классификатор видов контроля (VidExp)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_F010(source, destination)

  //  1 - SUBNAME(C) 2 - KOD_TF(N)  3 - OKRUG(N)  4 - KOD_OKATO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F010 := {;
    { 'KOD_TF',     'C',    2,      0 },;
    { 'KOD_OKATO',  'C',    5,      0 },;
    { 'SUBNAME',    'C',  250,      0 },;
    { 'OKRUG',      'N',    1,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr, nCol

  dbcreate(destination + '_mo_f010', _mo_F010)
  use (destination + '_mo_F010') new alias F010
  nfile := source + 'F010.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F010.xml     - Классификатор субъектов Российской Федерации (Subekti)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_F011(source, destination)

  //  1 - DOCNAME(C)  2 - IDDOC(N) 3 - DOCSER(C) 4 - DOCNUM(C) 5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F011 := {;
    { 'IDDOC',      'N',    2,      0 },;
    { 'DOCNAME',    'C',  250,      0 },;
    { 'DOCSER',     'C',   10,      0 },;
    { 'DOCNUM',     'C',   20,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local mName := '', mArr, nCol

  dbcreate(destination + '_mo_f011', _mo_F011)
  use (destination + '_mo_f011') new alias F011
  nfile := source + 'F011.xml'
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F011.xml     - Классификатор типов документов, удостоверяющих личность (Tipdoc)'
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZAP" == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2)+"%"
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

***** 12.02.22
Function make_F014(source, destination)

  local _mo_F014 := {;
    {'KOD',     'N',      4,      0},;
    {'NAME',    'C',    250,      0},;
    {'OPIS',    'M',     10,      0},;
    {'DATEBEG', 'D',      8,      0},;
    {'DATEEND', 'D',      8,      0},;
    {'OSN',     'C',     20,      0};
  }
  local nCol

  dbcreate(destination + "_mo_f014",_mo_F014)
  use (destination + '_mo_F014') new alias F014
  nfile := source + "F014.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? 'F014.xml     - Классификатор причин отказа в оплате медицинской помощи (OplOtk)'
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait
  else
    // ? "Обработка файла "+nfile+" - "
    nCol := obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        @ row(), nCol say str(j/k*100,6,2) + '%'
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
Function InitSpravFFOMS(source, destination)

  // V002.dbf - Классификатор профилей оказанной медицинской помощи
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V002 := getV002(destination)
  
  // V021.xml - Классификатор медицинских специальностей (последний)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  Public glob_V021 := getV021(destination)
  return NIL
  
  