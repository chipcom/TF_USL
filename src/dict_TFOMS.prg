/// Справочники ФФОМС

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 09.03.21
Function make_TO01()

  local _mo_T001 := {;
    { 'MCOD',       'C',    6,      0 },;
    { 'CODEM',      'C',    6,      0 },;
    { 'NAMEF',      'M',    10,     0 },;
    { 'NAMES',      'C',    80,     0 },;
    { 'ADRES',      'M',    10,     0 },;
    { 'MAIN',       'C',    1,      0 },;
    { 'PFA',        'C',    1,      0 },;
    { 'PFS',        'C',    1,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local dbName := '_mo_t001'
  local dbSource := 'T001'
  local mName := '', mArr

  ? 'Т001.dbf     - Справочник МО и обособленных подразделений, финансируемых самостоятельно'
  dbcreate('_mo_t001', _mo_T001)
  dbUseArea( .t.,, dbName, dbName, .t., .f. )

  dbUseArea( .t.,, dbSource, dbSource, .f., .f. )
  (dbSource)->(dbGoTop())
  do while !(dbSource)->(EOF())
    if (dbSource)->(DATEEND) > stod(FIRST_DAY)  //0d20210101
      (dbName)->(dbAppend())
      (dbName)->MCOD := (dbSource)->MCOD
      (dbName)->CODEM := (dbSource)->CODEM
      (dbName)->NAMEF := (dbSource)->NAMEF
      (dbName)->NAMES := (dbSource)->NAMES
      (dbName)->ADRES := (dbSource)->ADRES_M
      (dbName)->MAIN := (dbSource)->MAIN
      (dbName)->PFA := (dbSource)->PFA
      (dbName)->PFS := (dbSource)->PFS
      (dbName)->DATEBEG := (dbSource)->DATEBEG
      (dbName)->DATEEND := (dbSource)->DATEEND
    endif
    (dbSource)->(dbSkip())
  enddo
  (dbSource)->(dbCloseArea())
  (dbName)->(dbCloseArea())
  return NIL

***** 01.11.21
Function work_SprUnit()
  Local _mo_unit := {;
    {"CODE",       "N",      3,      0},;
    {"pz",         "N",      2,      0},;
    {"ii",         "N",      2,      0},;
    {"c_t",        "N",      1,      0},;
    {"NAME",       "C",     60,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  local nameFile := prefixFileName() + 'unit'

  dbcreate(nameFile, _mo_unit)
  use (nameFile) new alias UN

  nfile := "SprUnit.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "SPRUNIT.xml  - справочник видов помощи /план-заказ"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
            ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "ZAP" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        select UN
        append blank
        un->code := val(mo_read_xml_stroke(oXmlNode,"CODE",))
        un->NAME := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))))
        un->c_t  := val(mo_read_xml_stroke(oXmlNode,"C_T",))
        if (oNode1 := oXmlNode:Find("PERIODS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "PERIOD" == oNode2:title
              un->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"DATEBEG",))
              un->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"DATEEND",))
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_MOServ()
  Local _mo_moserv := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"SHIFR",      "C",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nameFile := prefixFileName() + 'moserv'

  dbcreate(nameFile, _mo_moserv)
  use (nameFile) new alias MS

  nfile := "S_MOServ.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_MOServ.xml - даты действия услуги вообще"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "MO_SERVICES" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("SERVICES")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "SERVICE" == oNode2:title
              if (oNode3 := oNode2:Find("PERIODS")) != NIL
                for j2 := 1 TO Len( oNode3:aItems )
                  oNode4 := oNode3:aItems[j2]
                  if "PERIOD" == oNode4:title
                    if j2 > 1
                      ? "Ошибка в чтении файла - более одного тега PERIOD",nfile
                      ? " в учреждении",ms->codem," в услуге",ms->shifr
                      wait
                    endif
                    select MS
                    append blank
                    ms->codem   := mo_read_xml_stroke(oXmlNode,"CODEM",)
                    ms->mcode   := mo_read_xml_stroke(oXmlNode,"MCOD",)
                    ms->shifr   := mo_read_xml_stroke(oNode2,"CODE",)
                    ms->DATEBEG := xml2date(mo_read_xml_stroke(oNode4,"D_B",))
                    ms->DATEEND := xml2date(mo_read_xml_stroke(oNode4,"D_E",))
                  endif
                next j2
              endif
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_Prices()
  Local _mo_prices := {;
    {"SHIFR",      "C",     10,      0},;
    {"VZROS_REB",  "N",      1,      0},;
    {"LEVEL",      "C",      5,      0},;
    {"CENA",       "N",     10,      2},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nameFile := prefixFileName() + 'prices'

  dbcreate(nameFile, _mo_prices)
  use (nameFile) new alias MP

  nfile := "S_Prices.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_Prices.xml - цена и дата действия по уровню"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "AGE_PRICES" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        s := mo_read_xml_stroke(oXmlNode,"AGE",)
        lvzros_reb := iif(alltrim(s)=="В", 0, 1)
        if (oNode1 := oXmlNode:Find("PRICES")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "CODE_PRICE" == oNode2:title
              lshifr := mo_read_xml_stroke(oNode2,"CODE",)
              if (oNode3 := oNode2:Find("LEVELS")) != NIL
                for j2 := 1 TO Len( oNode3:aItems )
                  oNode4 := oNode3:aItems[j2]
                  if "LEVEL" == oNode4:title
                    lLEVEL := mo_read_xml_stroke(oNode4,"VALUE",)
                    if empty(lLEVEL)
                      ? "Пустое значение тега VALUE/LEVEL",lLEVEL + " " + lshifr
                      lLEVEL := '0'
                    elseif len(alltrim(lLEVEL)) > 5
                      ? "Некорректное значение тега VALUE/LEVEL",lLEVEL + " " + lshifr
                      wait
                    endif
                    if (oNode5 := oNode4:Find("TARIFS")) != NIL
                      for j3 := 1 TO Len( oNode5:aItems )
                        oNode6 := oNode5:aItems[j3]
                        if "TARIF" == oNode6:title
                          select MP
                          append blank
                          mp->shifr     := lshifr
                          mp->vzros_reb := lvzros_reb
                          mp->LEVEL     := lLEVEL
                          mp->cena      := val(mo_read_xml_stroke(oNode6,"COST",))
                          mp->DATEBEG   := xml2date(mo_read_xml_stroke(oNode6,"D_B",))
                          mp->DATEEND   := xml2date(mo_read_xml_stroke(oNode6,"D_E",))
                        endif
                      next j3
                    endif
                  endif
                next j2
              endif
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 02.11.21
Function work_mo_uslf()
  Local _mo_uslf := {;
    {"SHIFR",      "C",     20,      0},;
    {"NAME",       "C",    255,      0},;
    {"TIP",        "N",      1,      0},; // 1-есть ещё в стоматологии,2-только в стоматологии
    {"GRP",        "N",      1,      0},; // код группы стоматологических услуг
    {"TELEMED",    "N",      1,      0},; // 1-услуга телемедицины
    {"ONKO_NAPR",  "N",      1,      0},; // тип диагн.услуги для дообследования в направлении ЗНО
    {"ONKO_KSG",   "N",      1,      0},; // тип лечения ОНКО - привязка к КСГ
    {"UETV",       "N",      5,      2},;
    {"UETD",       "N",      5,      2},;
    {"ZF",         "N",      1,      0},; // 1-обязателен ввод зубной формулы
    {"PAR_ORG",    "C",     40,      0},; // операция на парных органах (список)
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nameFileUslF := prefixFileName() + 'uslf'
  Local i := 0

  dbcreate(nameFileUslF,_mo_uslf)
  use (nameFileUslF) new alias LUSL
  ? "index..."
  index on shifr to tmp_usl
  use onko_napr new alias ON
  index on kod to tmp_on
  use onko_ksg new alias OK
  index on kod to tmp_ok
  use telemed new alias TEL
  index on kod to tmp_tel
  use par_org new alias PO
  index on kod to tmp_po
  use v001 new
  // use _usl_mz new alias v001
  index on IDRB to tmp1
  // @ row(),0 say "Обработка файла V001.DBF - "
  @ row(),0 say "Обработка файла _usl_mz.dbf - "
  go top
  do while !eof()
    @ row(),30 say str(++i/lastrec()*100, 6, 2) + "%"
    // if !empty(v001->DATEEND) .and. year(v001->DATEEND) < 2022 // 2021
    if !empty(v001->DATEEND) .and. year(v001->DATEEND) < val(CURENT_YEAR) // 2022 // 2021
      //
    else
      select LUSL
      find (padr(v001->IDRB,20))
      if found()
      else
        append blank
        lusl->SHIFR   := v001->IDRB
        lusl->NAME    := ltrim(charrem(eos,charone(" ",v001->RBNAME)))
        lusl->DATEBEG := v001->DATEBEG
        lusl->DATEEND := v001->DATEEND
        select TEL
        find (left(lusl->SHIFR,15))
        if found()
          lusl->telemed := 1
        endif
        select PO
        find (left(lusl->SHIFR,15))
        if found()
          lusl->par_org := po->organ
        endif
        select ON
        find (left(lusl->SHIFR,15))
        if found()
          lusl->onko_napr := on->id_tlech
        endif
        select OK
        find (left(lusl->SHIFR,15))
        if found()
          lusl->onko_ksg := iif(empty(ok->id_tlech), 6, ok->id_tlech)
        endif
        if empty(lusl->onko_ksg) .and. left(lusl->SHIFR,4) == "A16."
          lusl->onko_ksg := 1 // хирургическое лечение
        endif
      endif
    endif
    select V001
    skip
  enddo
  select PO
  go top
  do while !eof()
    select LUSL
    find (padr(po->kod,20))
    if !found()
    endif
    select V001
    find (padr(po->kod,15))
    if !found()
    endif
    select PO
    skip
  enddo
  close databases
  return NIL

***** 22.11.21
Function work_t006()
  Static nfile := "T006.XML"
  Local oXmlDoc, oXmlNode, i, j, k, s, af := {}
  local nameFileIt1 := prefixFileName() + 'it1'
  Local lshifr, lsy

  Local _mo_usl := {;
    {"SHIFR",      "C",     10,      0},;
    {"NAME",       "C",    255,      0},;
    {"ST",         "N",      1,      0},;
    {"USL_OK",     "N",      1,      0},;
    {"USL_OKS",    "C",      4,      0},;
    {"UNIT_CODE",  "N",      3,      0},; // ЮНИТ -план - заказ
    {"UNITS",      "C",     16,      0},; // ЮНИТ -план - заказ
    {"BUKVA",      "C",     10,      0},; // буква типа счета
    {"VMP_F",      "C",      2,      0},;
    {"VMP_S",      "C",      8,      0},;
    {"IDSP",       "C",      2,      0},;
    {"IDSPS",      "C",      8,      0},;
    {"KSLP",       "N",      2,      0},;
    {"KSLPS",      "C",     10,      0},;
    {"KIRO",       "N",      2,      0},;
    {"KIROS",      "C",     10,      0},;
    {"UETV",       "N",      5,      2},; // УЕТ - сейчас не используются
    {"UETD",       "N",      5,      2},; // УЕТ - сейчас не используются
    {"DATEBEG",    "D",      8,      0},; // дата начала действия - по умолчанию т.г
    {"DATEEND",    "D",      8,      0};  // дата конец действия - по умолчанию т.г
  }

  dbcreate("t006_u",_mo_usl)
  dbcreate("t006_2",{;
    {"SHIFR",      "C",     10,      0},;
    {"kz",         "N",      7,      3},;
    {"PROFIL",     "N",      2,      0},;
    {"DS",         "C",      6,      0},;
    {"DS1",        "M",     10,      0},;
    {"DS2",        "M",     10,      0},;
    {"SY",         "C",     20,      0},;
    {"AGE",        "C",      1,      0},;
    {"SEX",        "C",      1,      0},;
    {"LOS",        "C",      2,      0},;
    {"AD_CR",      "C",     20,      0},;
    {"AD_CR1",     "C",     20,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0},;
    {"NS",         "N",      6,      0};
  })
  dbcreate("t006_d",{;
    {"CODE",       "C",     10,      0},;
    {"DS",         "C",     20,      0},;
    {"DS1",        "C",     10,      0},;
    {"DS2",        "C",     10,      0},;
    {"SY",         "C",     20,      0},;
    {"AGE",        "C",      1,      0},;
    {"SEX",        "C",      1,      0},;
    {"LOS",        "C",      2,      0},;
    {"AD_CR",      "C",     20,      0},;
    {"AD_CR1",     "C",     20,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0},;
    {"NAME",       "C",    255,      0};
  })
  dbcreate(nameFileIt1,{;
    {"CODE",       "C",     10,      0},;
    {"USL_OK",     "N",      1,      0},;
    {"DS",         "C",   2300,      0},;
    {"DS1",        "C",    150,      0},;
    {"DS2",        "C",    250,      0};
  })
  use (nameFileIt1) new alias it
  index on code+str(usl_ok,1)+ds+ds1+ds2 to tmp_it
  use t006_u new alias t6
  use t006_2 new alias t62
  use t006_d new alias d6
  oXmlDoc := HXMLDoc():Read(nfile)
  kl := kl1 := kl2 := 0
  ? "T006.xml     - КСГ"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "KSG" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        select T6
        append blank
        t6->SHIFR   := mo_read_xml_stroke(oXmlNode,"CODE",)
        t6->NAME    := charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))
        t6->USL_OK  := val(mo_read_xml_stroke(oXmlNode,"USL",))
        t6->USL_OKS := lstr(t6->USL_OK)
        t6->ST      := val(mo_read_xml_stroke(oXmlNode,"ST",))
        //t6->DURV    :=      val(mo_read_xml_stroke(oXmlNode,"DUR_A",))
        //t6->DURD    :=      val(mo_read_xml_stroke(oXmlNode,"DUR_C",))
        t6->BUKVA   := upper(mo_read_xml_stroke(oXmlNode,"PAR",))
        t6->DATEBEG := xml2date(mo_read_xml_stroke(oXmlNode,"D_BEG",))
        t6->DATEEND := xml2date(mo_read_xml_stroke(oXmlNode,"D_END",))
        lkz         := val(mo_read_xml_stroke(oXmlNode,"K_Z",))
        if (oNode1 := oXmlNode:Find("VMP")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "TYPE_MP" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(t6->VMP_F)
                t6->VMP_F := s
              endif
              t6->VMP_S := iif(empty(t6->VMP_S), "", rtrim(t6->VMP_S)+",")+s
            endif
          next j1
        endif
        if (oNode1 := oXmlNode:Find("KSLPS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "KSLP" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(t6->KSLP)
                t6->KSLP := val(s)
              endif
              t6->KSLPS := iif(empty(t6->KSLPS), "", rtrim(t6->KSLPS)+",")+s
            endif
          next j1
        endif
        if (oNode1 := oXmlNode:Find("KIROS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "KIRO" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(t6->KIRO)
                t6->KIRO := val(s)
              endif
              t6->KIROS := iif(empty(t6->KIROS), "", rtrim(t6->KIROS)+",")+s
            endif
          next j1
        endif
        if (oNode1 := oXmlNode:Find("REGULATIONS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "RULE" == oNode2:title
              select D6
              append blank
              d6->code := t6->SHIFR
              d6->DS  := lDS  := alltrim(mo_read_xml_stroke(oNode2,"DS",))+" "
              d6->DS1 := lDS1 := alltrim(mo_read_xml_stroke(oNode2,"DS1",))+" "
              d6->DS2 := lDS2 := alltrim(mo_read_xml_stroke(oNode2,"DS2",))+" "
              d6->SY   := mo_read_xml_stroke(oNode2,"SY",)

              // для реабилитации после COVID-19            
              lshifr := lower(alltrim(t6->SHIFR))
              lsy     := mo_read_xml_stroke(oNode2,"SY",)
              if (lshifr = 'st37.021' .or. lshifr = 'st37.022' .or. lshifr = 'st37.023' ) .and. empty(lDS) .and. empty(lsy)
                d6->DS  := lDS  := 'U09.9'
              endif

              // if (lshifr = 'ds36.008' .or. lshifr = 'ds36.009' .or. lshifr = 'ds36.010' ;
              //     .or. lshifr = 'st36.017' .or. lshifr = 'st36.018' .or. lshifr = 'st36.019' ) ;
              //     .and. empty(lDS) .and. empty(lsy)
              //   d6->DS  := lDS  := ''
              // endif

              d6->AGE  := mo_read_xml_stroke(oNode2,"AGE",)
              d6->SEX  := mo_read_xml_stroke(oNode2,"SEX",)
              d6->LOS  := alltrim(mo_read_xml_stroke(oNode2,"LOS",))
              d6->AD_CR := mo_read_xml_stroke(oNode2,"AD_CRITERION",)
              d6->AD_CR1 := mo_read_xml_stroke(oNode2,"OTHER_CRITERIA",)
              d6->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"D_FROM",))
              d6->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"D_TO",))
              d6->name := t6->NAME
              if !empty(d6->AD_CR) .and. !eq_any(left(d6->AD_CR,2),"sh","mt","rb")
                select IT
                find (padr(d6->AD_CR,10)+str(t6->usl_ok,1)+padr(lds,2300)+padr(lds1,150)+padr(lds2,250))
                if !found()
                  append blank
                  it->CODE := d6->AD_CR
                  it->USL_OK := t6->USL_OK
                  it->DS := lds
                  it->DS1 := lds1
                  it->DS2 := lds2
                endif
                kl := max(kl,len(lds))
                kl1 := max(kl1,len(lds1))
                kl2 := max(kl2,len(lds2))
              endif
              if empty(lDS) // нет основного диагноза
                select T62
                append blank
                t62->SHIFR := t6->SHIFR
                t62->kz := lkz
                //t62->PROFIL := ksg->PROFIL
                if !empty(lDS1)
                  t62->DS1 := lds1
                endif
                if !empty(lDS2)
                  t62->DS2 := lds2
                endif
                t62->SY  := d6->SY
                t62->AGE := d6->AGE
                t62->SEX := d6->SEX
                t62->LOS := d6->LOS
                t62->AD_CR := d6->AD_CR
                t62->AD_CR1 := d6->AD_CR1
                t62->DATEBEG := d6->DATEBEG
                t62->DATEEND := d6->DATEEND
                t62->ns := d6->(recno())
              else
                sList := alltrim(lDS)
                for is := 1 to numtoken(sList,",")
                  s := alltrim(token(sList,",",is))
                  if !empty(s)
                    select T62
                    append blank
                    t62->SHIFR :=t6->SHIFR
                    t62->kz := lkz
                    //t62->PROFIL := ksg->PROFIL
                    t62->DS := s
                    if !empty(lDS1)
                      t62->DS1 := lds1
                    endif
                    if !empty(lDS2)
                      t62->DS2 := lds2
                    endif
                    t62->SY  := d6->SY
                    t62->AGE := d6->AGE
                    t62->SEX := d6->SEX
                    t62->LOS := d6->LOS
                    t62->AD_CR := d6->AD_CR
                    t62->AD_CR1 := d6->AD_CR1
                    t62->DATEBEG := d6->DATEBEG
                    t62->DATEEND := d6->DATEEND
                    t62->ns := d6->(recno())
                  endif
                next
              endif
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 02.11.21
Function work_SprMU()
  local nameFileUnit := prefixFileName() + 'unit'
  local nameFileUsl := prefixFileName() + 'usl'
  Local _mo_prof := {;
    {"SHIFR",      "C",     20,      0},;
    {"VZROS_REB",  "N",      1,      0},;
    {"PROFIL",     "N",      3,      0};
  }
  Local _mo_spec := {;
    {"SHIFR",      "C",     20,      0},;
    {"VZROS_REB",  "N",      1,      0},;
    {"PRVS",       "N",      6,      0},;
    {"PRVS_NEW",   "N",      4,      0};
  }
  local _t2_v1 := {;
    {"SHIFR",        "C",     10,      0},;
    {"SHIFR_MZ",     "C",     20,      0};
  }


  dbcreate( "_mo_t2_v1", _t2_v1)
  use _mo_t2_v1 new alias T2V1

  dbcreate("_mo_prof",_mo_prof)
  use _mo_prof new alias PROF
  dbcreate("_mo_spec",_mo_spec)
  use _mo_spec new alias SPEC

  use (nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use (nameFileUnit) new alias UN
  index on str(code,3) to tmp_unit
  nfile := "SprMU.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "SPRMU.xml    - справочник услуг /наименование, шифр услуги"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "ZAP" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        lshifr := mo_read_xml_stroke(oXmlNode,"CodeMU",)
        select LUSL
        find (padr(lshifr,10))
        if !found()
          append blank
          lusl->shifr := lshifr
        endif
        lusl->NAME := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NameMU",))))
        //МЕНЯТЬ
        lusl->DATEBEG := stod(FIRST_DAY)
        lusl->DATEEND := stod(LAST_DAY)
        lusl->USL_OK := 0 ; lusl->USL_OKS := ""
        if (oNode1 := oXmlNode:Find("USL_OKS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "USL_OK" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(lusl->USL_OK)
                lusl->USL_OK := int(val(s))
                lusl->USL_OKS := s
              else
                lusl->USL_OKS := alltrim(lusl->USL_OKS)+","+s
              endif
            endif
          next j1
        endif
        lusl->ST := val(mo_read_xml_stroke(oXmlNode,"ST",))
        lusl->VMP_F := lusl->VMP_S := ""
        if (oNode1 := oXmlNode:Find("VMP_F")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "V_MP" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(lusl->VMP_F)
                lusl->VMP_F := lusl->VMP_S := s
              else
                lusl->VMP_S := alltrim(lusl->VMP_S)+","+s
              endif
            endif
          next j1
        endif
        lusl->BUKVA := ""
        if (oNode1 := oXmlNode:Find("PARS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "PAR" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              lusl->BUKVA := iif(empty(lusl->BUKVA),"",alltrim(lusl->BUKVA))+upper(s)
            endif
          next j1
        endif
        lusl->idsp := lusl->idsps := ""
        if (oNode1 := oXmlNode:Find("IDSPS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "IDSP" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              if empty(lusl->idsp)
                lusl->idsp := lusl->idsps := s
              else
                lusl->idsps := alltrim(lusl->idsps)+","+s
              endif
            endif
          next j1
        endif
        lusl->unit_code := 0 ; lusl->units := ""
        if (oNode1 := oXmlNode:Find("UNITS")) != NIL
          arr_u := {}
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "UNIT_CODE" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1])=="C"
              s := hb_AnsiToOem(alltrim(oNode2:aItems[1]))
              aadd(arr_u, int(val(s)))
            endif
          next j1
          if len(arr_u) > 0
            s := ""
            for i := 1 to len(arr_u)
              s += iif(i==1,"",",")+lstr(arr_u[i])
            next i
            lusl->units := s
            for i := 1 to len(arr_u)
              select UN
              find (str(arr_u[i],3))
              if found() .and. (empty(un->dateend) .or. year(un->dateend) >= sys_year)
                lusl->unit_code := arr_u[i]
                exit
              endif
            next i
          endif
        endif
        if (oNode1 := oXmlNode:Find("PROFILES")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "PROFILE" == oNode2:title
              select PROF
              append blank
              prof->SHIFR := lshifr
              prof->VZROS_REB := val(mo_read_xml_stroke(oNode2,"P_AGE",)) - 1
              prof->profil := val(mo_read_xml_stroke(oNode2,"P_CODE",))
            endif
          next j1
        endif
        if (oNode1 := oXmlNode:Find("SPECIALTIES")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "SPECIALTY" == oNode2:title
              select SPEC
              append blank
              spec->SHIFR := lshifr
              spec->VZROS_REB := val(mo_read_xml_stroke(oNode2,"S_AGE",)) - 1
              spec->PRVS_NEW := val(mo_read_xml_stroke(oNode2,"S_CODE",))
            endif
          next j1
        endif
        if (oNode1 := oXmlNode:Find("SERVICE")) != NIL
          select T2V1
          append blank
          T2V1->SHIFR := lshifr
          T2V1->SHIFR_MZ := mo_read_xml_stroke(oXmlNode,"SERVICE",)
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 02.11.21
Function work_SprDS()
  Local fl := .f., lfp, s
  local nameFileUslF := prefixFileName() + 'uslf'

  use _mo_prof new alias PROF
  use _mo_spec new alias SPEC
  use (nameFileUslF) new alias LUSL
  index on shifr to tmp_lusl
  nfile := "SprDS.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "SPRDS.xml    - федеральный справочник услуг"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      @ row(),30 say str(j/k*100,6,2)+"%"
      o1 := oXmlDoc:aItems[1]:aItems[j]
      if "GRP" == o1:title
        ngrp := val(mo_read_xml_stroke(o1,"C_GRP",))
        if (o2 := o1:Find("ZAPS")) != NIL
          for j1o2 := 1 TO Len( o2:aItems )
            oXmlNode := o2:aItems[j1o2]
            if "ZAP" == oXmlNode:title
              lshifr := mo_read_xml_stroke(oXmlNode,"CodeMU",)
              fl := .f.
              muetv := muetd := 0
              if (oNode1 := oXmlNode:Find("UETV")) != NIL
                for j1 := 1 TO Len( oNode1:aItems )
                  oNode2 := oNode1:aItems[j1]
                  if "UET_A" == oNode2:title
                    bd := xml2date(mo_read_xml_stroke(oNode2,"DA_B",))
                    ed := xml2date(mo_read_xml_stroke(oNode2,"DA_E",))
                    if between_date(bd,ed,sys_date)
                      mUETV := val(mo_read_xml_stroke(oNode2,"VAL_UETA",))
                      fl := .t. ; exit
                    endif
                  endif
                next j1
              endif
              if (oNode1 := oXmlNode:Find("UETD")) != NIL
                for j1 := 1 TO Len( oNode1:aItems )
                  oNode2 := oNode1:aItems[j1]
                  if "UET_C" == oNode2:title
                    bd := xml2date(mo_read_xml_stroke(oNode2,"DC_B",))
                    ed := xml2date(mo_read_xml_stroke(oNode2,"DC_E",))
                    if between_date(bd,ed,sys_date)
                      mUETD := val(mo_read_xml_stroke(oNode2,"VAL_UETC",))
                      fl := .t. ; exit
                    endif
                  endif
                next j1
              endif
              if fl
                select LUSL
                find (padr(lshifr,20))
                if found()
                  lusl->tip := 1
                else
                  append blank
                  lusl->shifr := lshifr
                  lusl->tip := 2
                endif
                lusl->UETV := mUETV
                lusl->UETD := mUETD
                lusl->grp  := ngrp
                lusl->NAME := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NameMU",))))
                lusl->DATEBEG := xml2date(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
                lusl->DATEEND := xml2date(mo_read_xml_stroke(oXmlNode,"DATEEND",))
                lusl->zf := val(mo_read_xml_stroke(oXmlNode,"T_FORMULA",))
                if (oNode1 := oXmlNode:Find("PROFILES")) != NIL
                  for j1 := 1 TO Len( oNode1:aItems )
                    oNode2 := oNode1:aItems[j1]
                    if "PROFILE" == oNode2:title
                      select PROF
                      append blank
                      prof->SHIFR := lshifr
                      prof->VZROS_REB := val(mo_read_xml_stroke(oNode2,"P_AGE",)) - 1
                      prof->profil := val(mo_read_xml_stroke(oNode2,"P_CODE",))
                    endif
                  next j1
                endif
                if (oNode1 := oXmlNode:Find("SPECIALTIES")) != NIL
                  for j1 := 1 TO Len( oNode1:aItems )
                    oNode2 := oNode1:aItems[j1]
                    if "SPECIALTY" == oNode2:title
                      select SPEC
                      append blank
                      spec->SHIFR := lshifr
                      spec->VZROS_REB := val(mo_read_xml_stroke(oNode2,"S_AGE",)) - 1
                      spec->PRVS_NEW := val(mo_read_xml_stroke(oNode2,"S_CODE",))
                    endif
                  next j1
                endif
              endif
            endif
          next j1o2
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 23.04.21
Function work_SprKslp()
  Local _mo_kslp := {;
    {"CODE",       "N",      2,      0},;
    {"NAME",       "C",     55,      0},;
    {"NAME_F",     "C",    255,      0},;
    {"COEFF",      "N",      4,      2},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  local nameFile := prefixFileName() + 'kslp'

  dbcreate(nameFile, _mo_kslp)
  use (nameFile) new alias KS

  nfile := "SprKslp.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "SPRKSLP.xml  - для КСГ - КСЛП"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "ZAP" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("COEFF")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "ENTRY" == oNode2:title
              select KS
              append blank
              ks->code    := val(mo_read_xml_stroke(oXmlNode,"CODE",))
              ks->NAME    := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))))
              ks->NAME_F  := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME_F",))))
              ks->COEFF   := val(mo_read_xml_stroke(oNode2,"C_VAL",))
              ks->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"D_B",))
              ks->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"D_E",))
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 23.04.21
Function work_SprKiro()
  Local _mo_kiro := {;
    {"CODE",       "N",      2,      0},;
    {"NAME",       "C",     55,      0},;
    {"NAME_F",     "C",    255,      0},;
    {"COEFF",      "N",      4,      2},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  local nameFile := prefixFileName() + 'kiro'

  dbcreate(nameFile, _mo_kiro)
  use (nameFile) new alias KS

  nfile := "S_KIRO.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_kiro.xml   - для КСГ - КИРО"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "ZAP" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("COEFF")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "ENTRY" == oNode2:title
              select KS
              append blank
              ks->code    := val(mo_read_xml_stroke(oXmlNode,"CODE",))
              ks->NAME    := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))))
              ks->NAME_F  := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME_F",))))
              ks->COEFF   := val(mo_read_xml_stroke(oNode2,"C_VAL",))
              ks->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"D_B",))
              ks->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"D_E",))
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_uslc()
  Local _mo_uslc := {;
    {"CODEMO",     "C",      6,      0},;
    {"SHIFR",      "C",     10,      0},;
    {"usl_ok",     "N",      1,      0},;
    {"DEPART",     "N",      3,      0},;
    {"UROVEN",     "C",      5,      0},;
    {"VZROS_REB",  "N",      1,      0},;
    {"CENA",       "N",     10,      2},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  local nameFile := prefixFileName() + 'uslc'
  local nameFileUsl := prefixFileName() + 'usl'
  local nameFileDep := prefixFileName() + 'dep'
  local nameFileDepPr := prefixFileName() + 'deppr'
  local nameFileSubDiv := prefixFileName() + 'subdiv'
  local nameFilePrices := prefixFileName() + 'prices'
  local nameFileLvlPay := prefixFileName() + 'lvlpay'
  local nameFileMoServ := prefixFileName() + 'moserv'

  Local nul_level := padr('0',5)
  //Local nul_level := padr('1',5)

  ? "Создание файла " + nameFile + ".dbf - "
  dbcreate(nameFile, _mo_uslc)
  dbcreate("not_usl",{{"shifr","C",10,0},{"spr_mu","N",1,0},{"s_price","N",1,0}})
  dbcreate("not_lev",{{"codem","C",6,0},{"shifr","C",10,0},{"usl_ok","N",1,0},{"level","C",5,0},{"depart","N",3,0}})

  use (nameFileDep) new alias DEP
  use (nameFileDepPr) new alias DP
  use (nameFileSubDiv) new alias SD
  //
  use not_usl new
  index on shifr to not_usl
  use not_lev new
  index on codem+shifr+str(usl_ok,1)+level+str(depart,3) to not_lev

  use (nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use (nameFile) new alias LUSLC

  use (nameFilePrices) new alias PRIC
  index on shifr+str(vzros_reb,1)+level to tmp_prices
  
  use (nameFileLvlPay) new alias LP
  index on codem+str(usl_ok,1)+level+str(depart,3) to tmp_lvlpay

  use (nameFileMoServ) new alias SERV
  go top
  do while !eof()
    @ row(),30 say str(recno()/lastrec()*100,6,2)+"%"
    lcodem := serv->codem
    lshifr := serv->shifr
    select LUSL
    find (lshifr)
    if found()
      fld := lcodem=='801942' .and. alltrim(lshifr)=='2.78.15'
      lusl_ok := lusl->usl_ok
      arr1 := {} ; arr2 := {}
      select LP
      find (lcodem+str(lusl_ok,1))
      do while lp->codem == lcodem .and. lp->usl_ok == lusl_ok .and. !eof()
        fl := .t.
        llevel := lp->level
        aadd(arr1,llevel)
        select PRIC
        find (lshifr)
        if found()
          for lvzros_reb := 0 to 1
            select PRIC
            find (lshifr+str(lvzros_reb,1)+llevel)
            do while pric->shifr == lshifr .and. pric->vzros_reb == lvzros_reb .and. pric->level == llevel .and. !eof()
              if between_date(pric->datebeg,pric->dateend,lp->datebeg,lp->dateend) .or. ;
                between_date(lp->datebeg,lp->dateend,pric->datebeg,pric->dateend)
                lcena := pric->cena
                bd := max(lp->datebeg,pric->datebeg)
                bd := max(bd,serv->datebeg)
                ed := min(lp->dateend,pric->dateend)
                ed := min(ed,serv->dateend)
                if fl
                  aadd(arr2,llevel)
                endif
                fl := .f.
                select LUSLC
                append blank
                luslc->CODEMO    := lcodem
                luslc->SHIFR     := lshifr
                luslc->usl_ok    := lusl_ok
                luslc->DEPART    := lp->depart
                luslc->UROVEN    := llevel
                luslc->VZROS_REB := lvzros_reb
                luslc->CENA      := lcena
                luslc->DATEBEG   := bd
                luslc->DATEEND   := ed
                if lastrec() % 2000 == 0
                  commit
                endif
              endif
              select PRIC
              skip
            enddo
          next
          if fl .and. empty(lp->depart)
            for lvzros_reb := 0 to 1
              select PRIC
              find (lshifr+str(lvzros_reb,1)+nul_level)
              do while pric->shifr == lshifr .and. pric->vzros_reb == lvzros_reb .and. pric->level == nul_level .and. !eof()
                if between_date(pric->datebeg,pric->dateend,lp->datebeg,lp->dateend) .or. ;
                      between_date(lp->datebeg,lp->dateend,pric->datebeg,pric->dateend)
                  lcena := pric->cena
                  bd := max(lp->datebeg,pric->datebeg)
                  bd := max(bd,serv->datebeg)
                  ed := min(lp->dateend,pric->dateend)
                  ed := min(ed,serv->dateend)
                  if fl
                    aadd(arr2,llevel)
                  endif
                  fl := .f.
                  select LUSLC
                  append blank
                  luslc->CODEMO    := lcodem
                  luslc->SHIFR     := lshifr
                  luslc->usl_ok    := lusl_ok
                  luslc->DEPART    := lp->depart
                  luslc->UROVEN    := nul_level
                  luslc->VZROS_REB := lvzros_reb
                  luslc->CENA      := lcena
                  luslc->DATEBEG   := bd
                  luslc->DATEEND   := ed
                  if lastrec() % 2000 == 0
                    commit
                  endif
                endif
                select PRIC
                skip
              enddo
            next
          endif
        else
          select not_usl
          find (lshifr)
          if !found()
            append blank
          endif
          replace shifr with lshifr, s_price with 1
        endif
        if fl .and. empty(lp->depart)  // не найдено ни одного уровня оплаты в _mo0lvlpay для lcodem ...
          select NOT_LEV
          find (lcodem+lshifr+str(lusl_ok,1)+llevel+str(lp->depart,3))
          if !found()
            append blank
            replace codem with lcodem, shifr with lshifr, usl_ok with lusl_ok, ;
                  level with llevel, depart with lp->depart
          endif
        endif
        select LP
        skip
      enddo
      if empty(arr2) // если по всем ненулевым кодам depart не найдены цены
        for lvzros_reb := 0 to 1
          select PRIC
          find (lshifr+str(lvzros_reb,1)+nul_level)
          do while pric->shifr == lshifr .and. pric->vzros_reb == lvzros_reb .and. pric->level == nul_level .and. !eof()
            lcena := pric->cena
            bd := pric->datebeg
            ed := pric->dateend
            bd := max(bd,serv->datebeg)
            ed := min(ed,serv->dateend)
            select LUSLC
            append blank
            luslc->CODEMO    := lcodem
            luslc->SHIFR     := lshifr
            luslc->usl_ok    := lusl_ok
            luslc->DEPART    := 0 // lp->depart
            luslc->UROVEN    := nul_level
            luslc->VZROS_REB := lvzros_reb
            luslc->CENA      := lcena
            luslc->DATEBEG   := bd
            luslc->DATEEND   := ed
            if lastrec() % 2000 == 0
              commit
            endif
            select PRIC
            skip
          enddo
        next
      elseif len(arr1) > len(arr2)
        select LP
        find (lcodem+str(lusl_ok,1))
        do while lp->codem == lcodem .and. lp->usl_ok == lusl_ok .and. !eof()
          llevel := lp->level
          if ascan(arr2,llevel) == 0
            select NOT_LEV
            find (lcodem+lshifr+str(lusl_ok,1)+llevel+str(lp->depart,3))
            if !found()
              append blank
              replace codem with lcodem, shifr with lshifr, usl_ok with lusl_ok, ;
                    level with llevel, depart with lp->depart
            endif
          endif
          select LP
          skip
        enddo
      endif
    else
      select not_usl
      find (lshifr)
      if !found()
        append blank
      endif
      replace shifr with lshifr, spr_mu with 1
    endif
    select SERV
    skip
  enddo
  close databases
  return NIL

***** 01.11.21
Function work_Shema()
  Local _mo_shema := {;
    {"KOD",        "C",     10,      0},;
    {"NAME",       "C",    255,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  local nameFile := prefixFileName() + 'shema'

  dbcreate(nameFile, _mo_shema)
  use (nameFile) new alias SH

  index on kod to tmp_shema
  nfile := "V024.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V024.xml     - для КСГ - Допкритерии"
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
        mkod := mo_read_xml_stroke(oXmlNode,"IDDKK",)
        mNAME := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"DKKNAME",))))
        mDATEBEG := ctod(mo_read_xml_stroke(oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke(oXmlNode,"DATEEND",))
        fl := .t.
        if !empty(mDATEEND) .and. mDATEEND < stod(FIRST_DAY)
          fl := .f.
        endif
        if fl
          select SH
          find (mkod)
          if found()
            if mDATEBEG > sh->DATEBEG
              sh->NAME := mname
              sh->DATEBEG := mDATEBEG
              sh->DATEEND := mDATEEND
            endif
          else
            append blank
            sh->kod := mkod
            sh->NAME := mname
            sh->DATEBEG := mDATEBEG
            sh->DATEEND := mDATEEND
          endif
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
// S_Subdiv.xml - список 11 учреждений с разными уровнями оплаты
Function work_SprSubDiv()

  Local _mo_subdiv := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"CODE",       "N",      3,      0},;
    {"NAME",       "C",     60,      0},;
    {"flag",       "N",      1,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nameFile := prefixFileName() + 'subdiv'

  dbcreate(nameFile, _mo_subdiv)
  use (nameFile) new alias SD
  nfile := "S_SubDiv.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_Subdiv.xml - список 11 учреждений с разными уровнями оплаты"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "MO_PLACES" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("PLACES")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "PLACE" == oNode2:title
              select SD
              append blank
              sd->codem   := mo_read_xml_stroke(oXmlNode,"CODEM",)
              sd->mcode   := mo_read_xml_stroke(oXmlNode,"MCODE",)
              sd->code    := val(mo_read_xml_stroke(oNode2,"CODE",))
              sd->NAME    := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_FULL",))))
              sd->flag    := val(mo_read_xml_stroke(oNode2,"FLAG",))
              sd->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"D_B",))
              sd->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"D_E",))
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_SprDep()
  Local _mo_dep := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"CODE",       "N",      3,      0},;
    {"place",      "N",      3,      0},;
    {"NAME",       "C",    100,      0},;
    {"NAME_SHORT", "C",     35,      0},;
    {"usl_ok",     "N",      1,      0},;
    {"vmp",        "N",      1,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  Local _mo_deppr := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"CODE",       "N",      3,      0},;
    {"place",      "N",      3,      0},;
    {"pr_berth",   "N",      3,      0},;
    {"pr_mp",      "N",      3,      0};
  }
  local nameFileDep := prefixFileName() + 'dep'
  local nameFileDepPr := prefixFileName() + 'deppr'

  dbcreate(nameFileDep, _mo_dep)
  dbcreate(nameFileDepPr, _mo_deppr)

  use (nameFileDep) new alias DEP
  use (nameFileDepPr) new alias DP

  nfile := "S_Dep.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_Dep.xml    - список отделений по 11-й стационарам с разными уровнями оплаты"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "MO_DEPARTMENTS" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("DEPARTMENTS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "DEPARTMENT" == oNode2:title
              select DEP
              append blank
              dep->codem   := mo_read_xml_stroke(oXmlNode,"CODEM",)
              dep->mcode   := mo_read_xml_stroke(oXmlNode,"MCODE",)
              dep->code    := val(mo_read_xml_stroke(oNode2,"CODE",))
              dep->NAME    := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_FULL",))))
              dep->NAME_SHORT := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_SHORT",))))
              dep->usl_ok  := val(mo_read_xml_stroke(oNode2,"USL_OK",))
              dep->vmp     := val(mo_read_xml_stroke(oNode2,"VMP",))
              dep->DATEBEG := xml2date(mo_read_xml_stroke(oNode2,"D_B",))
              dep->DATEEND := xml2date(mo_read_xml_stroke(oNode2,"D_E",))
              if (oNode3 := oNode2:Find("PLACES")) != NIL
                for j2 := 1 TO Len( oNode3:aItems )
                  oNode4 := oNode3:aItems[j2]
                  if "PLACE" == oNode4:title .and. !empty(oNode4:aItems) .and. valtype(oNode4:aItems[1])=="C"
                    if j2 > 1
                      ? "Ошибка в чтении файла - более одного тега PLACE",nfile
                      ? " в отделении",alltrim(dep->NAME)
                      wait
                    endif
                    dep->place := int(val(hb_AnsiToOem(alltrim(oNode4:aItems[1]))))
                  endif
                next j2
              endif
              if (oNode3 := oNode2:Find("PROFILS")) != NIL
                for j2 := 1 TO Len( oNode3:aItems )
                  oNode4 := oNode3:aItems[j2]
                  if "PROFIL" == oNode4:title
                    select DP
                    append blank
                    dp->codem    := dep->codem
                    dp->mcode    := dep->mcode
                    dp->code     := dep->code
                    dp->place    := dep->place
                    dp->PR_BERTH := val(mo_read_xml_stroke(oNode4,"PR_BERTH",))
                    dp->PR_MP    := val(mo_read_xml_stroke(oNode4,"PR_MP",))
                  endif
                next j2
              endif
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL

***** 01.11.21
Function work_LvlPay()
  Local _mo_lvlpay := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"usl_ok",     "N",      1,      0},;
    {"DEPART",     "N",      3,      0},;
    {"LEVEL",      "C",      5,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nameFile := prefixFileName() + 'lvlpay'

  dbcreate(nameFile, _mo_lvlpay)
  use (nameFile) new alias LP

  nfile := "S_LvlPay.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "S_LvlPay.xml - код МО и уровень услуг"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ZGLV" == oXmlNode:title
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == CURENT_YEAR)
          ? "Ошибка в чтении файла",nfile
          ? "Некорректное значение тега YEAR_REPORT",j1
          wait
          exit
        endif
      elseif "MO_LEVELS" == oXmlNode:title
        @ row(),30 say str(j/k*100,6,2)+"%"
        if (oNode1 := oXmlNode:Find("USL_LEVELS")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "USL_LEVEL" == oNode2:title
              if (oNode3 := oNode2:Find("DEPARTMENTS")) != NIL
                for j2 := 1 TO Len( oNode3:aItems )
                  oNode4 := oNode3:aItems[j2]
                  if "DEPARTMENT" == oNode4:title
                    if (oNode5 := oNode4:Find("PAY_LEVELS")) != NIL
                      for j3 := 1 TO Len( oNode5:aItems )
                        oNode6 := oNode5:aItems[j3]
                        if "PAY_LEVEL" == oNode6:title
                          select LP
                          append blank
                          lp->codem   := mo_read_xml_stroke(oXmlNode,"CODEM",)
                          lp->mcode   := mo_read_xml_stroke(oXmlNode,"MCODE",)
                          lp->usl_ok  := val(mo_read_xml_stroke(oNode2,"USL_OK",))
                          lp->DEPART  := val(mo_read_xml_stroke(oNode4,"CODE",))
                          lp->LEVEL   := mo_read_xml_stroke(oNode6,"VALUE",)
                          lp->DATEBEG := xml2date(mo_read_xml_stroke(oNode6,"D_B",))
                          lp->DATEEND := xml2date(mo_read_xml_stroke(oNode6,"D_E",))
                          /*if j3 > 1
                            ? "Ошибка в чтении файла - более одного тега PAY_LEVEL",nfile
                            ? " в учреждении",lp->codem, "в отделении",lstr(lp->DEPART)
                            wait
                          endif*/
                        endif
                      next j3
                    endif
                  endif
                next j2
              endif
            endif
          next j1
        endif
      endif
    NEXT j
  ENDIF
  close databases
  return NIL