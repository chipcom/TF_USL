/* программа конвертации XML-справочников ТФОМС в "плоские" DBF-файлы
   S_Subdiv.xml - список 11 учреждений с разными уровнями оплаты
   S_Dep.xml    - список отделений по 11-й стационарам с разными уровнями оплаты
   SPRMU.xml    - справочник услуг /наименование, шифр услуги
   S_MOServ.xml - даты действия услуги вообще
   S_Prices.xml - цена и дата действия по уровню
   S_LvlPay.xml - код МО и уровень услуг
   SPRDS.xml    - федеральный справочник услуг
   SPRUNIT.xml  - справочник видов помощи /план-заказ
   S_kiro.xml   - для КСГ - КИРО
   SPRKSLP.xml  - для КСГ - КСЛП
   T006.xml     - КСГ
   V024.xml     - для КСГ - Допкритерии
   V018.xml     - классификатор видов высокотехнологичной медицинской помощи (HVid)
   V019.xml     - классификатор методов высокотехнологичной медицинской помощи (HMet)
   V025.xml     - Классификатор целей посещения (KPC)
   V009.xml     - Классификатор результатов обращения за медицинской помощью (Rezult)
   V010.xml     - Классификатор способов оплаты медицинской помощи (Sposob)
   V012.xml     - Классификатор исходов заболевания (Ishod)
   V016.xml     - Классификатор типов диспансеризации (DispT)
   V017.xml     - Классификатор результатов диспансеризации (DispR)

   V030.xml     - Схемы лечения заболевания COVID-19 (TreatReg)
   V031.xml     - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)
   V032.xml     - Сочетание схемы лечения и группы препаратов (CombTreat)
   V033.xml     - Соответствие кода препарата схеме лечения (DgTreatReg)
   V034.xml     - Единицы измерения (UnitMeas)
   V035.xml     - Способы введения (MethIntro)
   V036.xml     - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)

   OID 1.2.643.5.1.13.13.11.1079 - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями

//  Что получаем на выходе - наши файлы

   _mo1usl    - _mo_usl  - справочник наименований всех услуг
   _mo1uslc   - _mo_uslc - справочник услуг с ценами для конкретных МО
                           без КСГ

  _mo_t2_v1   - справочник соответсвия услуг ТФОМС услугам МЗ РФ
  _mo_V018    - классификатор видов высокотехнологичной медицинской помощи (HVid)

*/

#include "edit_spr.ch"
#include "function.ch"

external errorsys

proc main()
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
//
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

local _t2_v1 := {;
  {"SHIFR",        "C",     10,      0},;
  {"SHIFR_MZ",     "C",     20,      0};
}

Local arr_err := {}
delete file ttt.ttt
f_first()
Public sys_date := date(), sys_year := year(date())

// create_version_DB()
// make_TO01()

make_implant()

work_V002()
work_V021()

InitSpravFFOMS()
//
read_spr_N00X()
//
dbcreate("_mo1usl",_mo_usl)
work_Shema()
work_SprSubDiv()
work_SprDep(_mo_dep,_mo_deppr)
work_LvlPay()
work_MOServ()
work_Prices()
work_mo_uslf()
work_SprUnit()
work_SprKslp()
work_SprKiro()
work_SprMU(_mo_prof, _mo_spec, _t2_v1)
work_SprDS()
work_t006(_mo_usl)
work_V009()
work_V010()
work_V012()
work_V015()
work_V016()
work_V017()
work_V018()
work_V019()
work_V020()
work_V022()
work_V025()
work_V030()
work_V031()
work_V032()
work_V033()
work_V034()
work_V035()
work_V036()
make_Q015()
make_Q016()
make_Q017()
make_F006()
make_F010()
make_F011()
make_F014()
make_O001()


close databases
//
rename t006_2.dbf to _mo1k006.dbf
rename t006_2.dbt to _mo1k006.dbt
//
dbcreate("_mo1it",{{"ds","C",5,0},{"it","N",1,0}})
use _mo1it new alias IT
index on ds+str(it,1) to tmp_it
use _mo1k006 new alias K6
index on ds to tmp_k6 for lower(left(ad_cr,2)) == "it"
go top
do while !eof()
  lit := int(val(substr(ltrim(k6->ad_cr),3,1)))
  select IT
  find (padr(k6->ds,5)+str(lit,1))
  if !found()
    append blank
    replace ds with k6->ds, it with lit
  endif
  select K6
  skip
enddo
close databases
// добавим наименования КСГ за 2021 год
use _mo1usl new alias LUSL
index on shifr to tmp_lusl
use t006_u new alias T006
index on fsort_usl(shifr) to tmp6
go top
do while !eof()
  ar := get_field()
  select LUSL
  find (t006->shifr)
  if found()
  endif
  append blank
  aeval(ar, {|x,i| fieldput(i,x) } )
  //
  // РАЗОБРАТЬ
  //
  if left(t006->shifr,2) == "st"
    lusl->idsp := lusl->idsps := '33' // КСГ в стационаре
    lusl->unit_code := 29 ; lusl->units := "29"  // случай госпитализации
    if left(t006->shifr,5) == "st37."
      lusl->unit_code := 142 ; lusl->units := "142" // случай госпитализации при реабилитации
    endif
  elseif alltrim(t006->shifr) == 'ds18.002' // лек.терапия у пациентов на диализе
    lusl->idsp := lusl->idsps := '33' // КСГ в дневном стационаре ????
    lusl->unit_code := 259 ; lusl->units := "259" // случай диализа
  else
    lusl->idsp := lusl->idsps := '33' // КСГ в дневном стационаре
    lusl->unit_code := 143 ; lusl->units := "143" // случай лечения
    if left(t006->shifr,5) == "ds37."
      // реабилитация в дневном стационаре
    endif
  endif
  select T006
  skip
enddo
close databases
//
work_uslc(_mo_uslc)
//
use _mo1uslc new alias LUSLC
go top
do while !eof()
  if luslc->DATEEND == 0d20191231
    luslc->DATEEND := ctod("")
  endif
  skip
enddo
close databases
//
aup := {}
use _mo_prof new alias PROF
index on fsort_usl(shifr) to tmp_prof
go top
do while !eof()
  if (j := ascan(aup, {|x| x[1]==prof->shifr.and.x[2]==prof->VZROS_REB}))== 0
    aadd(aup,{prof->shifr,prof->VZROS_REB,{}}) ; j := len(aup)
  endif
  if ascan(aup[j,3],prof->PROFIL) == 0
    aadd(aup[j,3],prof->PROFIL)
  endif
  skip
enddo
fp := fcreate("_mo_prof.txt") ; n_list := 1 ; tek_stroke := 0
for j := 1 to len(aup)
  s := aup[j,1]+iif(aup[j,2] == 0, "взр", "реб")+".{"
  asort(aup[j,3])
  for i := 1 to len(aup[j,3])
    s += lstr(aup[j,3,i])+"-"+inieditspr(A__MENUVERT,glob_V002,aup[j,3,i])
    if i < len(aup[j,3])
      s += ","
    endif
  next
  add_string(s+"}")
next
fclose(fp)
//
aup := {}
use _mo_spec new alias SPEC
index on fsort_usl(shifr) to tmp_spec
go top
do while !eof()
  if (j := ascan(aup, {|x| x[1]==spec->shifr.and.x[2]==spec->VZROS_REB}))== 0
    aadd(aup,{spec->shifr,spec->VZROS_REB,{}}) ; j := len(aup)
  endif
  if ascan(aup[j,3],spec->PRVS_NEW) == 0
    aadd(aup[j,3],spec->PRVS_NEW)
  endif
  skip
enddo
fp := fcreate("_mo_spec.txt") ; n_list := 1 ; tek_stroke := 0
for j := 1 to len(aup)
  s := aup[j,1]+iif(aup[j,2] == 0, "взр", "реб")+".{"
  asort(aup[j,3])
  for i := 1 to len(aup[j,3])
    s += lstr(aup[j,3,i])+"-"+inieditspr(A__MENUVERT,glob_V021,aup[j,3,i])
    if i < len(aup[j,3])
      s += ","
    endif
  next
  add_string(s+"}")
next
fclose(fp)
close databases
filedelete("tmp*.dbf")
filedelete("tmp*.ntx")

filedelete('t006_2.dbf')
filedelete('t006_2.dbt')
filedelete('t006_d.dbf')
filedelete('t006_u.dbf')

filedelete('v001.ntx')
filedelete('not_lev.ntx')
filedelete('not_usl.ntx')
f_end()
return

***** 16.05.19
Function work_uslc(_mo_uslc)
Local nul_level := padr('0',5)
//Local nul_level := padr('1',5)

? "Создание файла _mo1uslc.dbf - "
dbcreate("_mo1uslc",_mo_uslc)
dbcreate("not_usl",{{"shifr","C",10,0},{"spr_mu","N",1,0},{"s_price","N",1,0}})
dbcreate("not_lev",{{"codem","C",6,0},{"shifr","C",10,0},{"usl_ok","N",1,0},{"level","C",5,0},{"depart","N",3,0}})
use _mo1dep new alias DEP
use _mo1deppr new alias DP
use _mo1subdiv new alias SD
//
use not_usl new
index on shifr to not_usl
use not_lev new
index on codem+shifr+str(usl_ok,1)+level+str(depart,3) to not_lev
use _mo1usl new alias LUSL
index on shifr to tmp_lusl
use _mo1uslc new alias LUSLC
use _mo1prices new alias PRIC
index on shifr+str(vzros_reb,1)+level to tmp_prices
use _mo1lvlpay new alias LP
index on codem+str(usl_ok,1)+level+str(depart,3) to tmp_lvlpay
use _mo1moserv new alias SERV
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

***** 13.12.21
Function work_Shema()
  Local _mo_shema := {;
    {"KOD",        "C",     10,      0},;
    {"NAME",       "C",    255,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo1shema",_mo_shema)
  use _mo1shema new alias SH
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
        if !empty(mDATEEND) .and. mDATEEND < 0d20210101
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

***** 29.10.21
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

  dbcreate("_mo1subdiv",_mo_subdiv)
  use _mo1subdiv new alias SD
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
              sd->codem    :=         mo_read_xml_stroke(oXmlNode,"CODEM",)
              sd->mcode    :=         mo_read_xml_stroke(oXmlNode,"MCODE",)
              sd->code    :=      val(mo_read_xml_stroke(oNode2,"CODE",))
              sd->NAME    :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_FULL",))))
              sd->flag    :=      val(mo_read_xml_stroke(oNode2,"FLAG",))
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

***** 30.12.18
Function work_SprDep(_mo_dep,_mo_deppr)
dbcreate("_mo1dep",_mo_dep)
dbcreate("_mo1deppr",_mo_deppr)
use _mo1dep new alias DEP
use _mo1deppr new alias DP
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
            dep->codem    :=         mo_read_xml_stroke(oXmlNode,"CODEM",)
            dep->mcode    :=         mo_read_xml_stroke(oXmlNode,"MCODE",)
            dep->code    :=      val(mo_read_xml_stroke(oNode2,"CODE",))
            dep->NAME    :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_FULL",))))
            dep->NAME_SHORT := ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oNode2,"NAME_SHORT",))))
            dep->usl_ok  :=      val(mo_read_xml_stroke(oNode2,"USL_OK",))
            dep->vmp     :=      val(mo_read_xml_stroke(oNode2,"VMP",))
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

***** 13.12.21
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

  dbcreate("_mo1lvlpay",_mo_lvlpay)
  use _mo1lvlpay new alias LP
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
                          lp->codem   :=          mo_read_xml_stroke(oXmlNode,"CODEM",)
                          lp->mcode   :=          mo_read_xml_stroke(oXmlNode,"MCODE",)
                          lp->usl_ok  :=      val(mo_read_xml_stroke(oNode2,"USL_OK",))
                          lp->DEPART  :=      val(mo_read_xml_stroke(oNode4,"CODE",))
                          lp->LEVEL   :=          mo_read_xml_stroke(oNode6,"VALUE",)
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

***** 13.12.21
Function work_MOServ()
  Local _mo_moserv := {;
    {"CODEM",      "C",      6,      0},;
    {"MCODE",      "C",      6,      0},;
    {"SHIFR",      "C",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo1moserv",_mo_moserv)
  use _mo1moserv new alias MS
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
                    ms->codem   :=          mo_read_xml_stroke(oXmlNode,"CODEM",)
                    ms->mcode   :=          mo_read_xml_stroke(oXmlNode,"MCOD",)
                    ms->shifr   :=          mo_read_xml_stroke(oNode2,"CODE",)
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

***** 13.12.21
Function work_Prices()
  Local _mo_prices := {;
    {"SHIFR",      "C",     10,      0},;
    {"VZROS_REB",  "N",      1,      0},;
    {"LEVEL",      "C",      5,      0},;
    {"CENA",       "N",     10,      2},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }

  dbcreate("_mo1prices",_mo_prices)
  use _mo1prices new alias MP
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
                          mp->cena      :=      val(mo_read_xml_stroke(oNode6,"COST",))
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

***** 13.12.21
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
  Local i := 0

  ? "index..."
  dbcreate("_mo1uslf",_mo_uslf)
  use _mo1uslf new alias LUSL
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
  index on IDRB to tmp1
  @ row(),0 say "Обработка файла V001.DBF - "
  go top
  do while !eof()
    @ row(),30 say str(++i/lastrec()*100,6,2)+"%"
    if !empty(v001->DATEEND) .and. year(v001->DATEEND) < 2022 // 2021
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
Function work_t006(_mo_usl)
  Static nfile := "T006.XML"
  Local oXmlDoc, oXmlNode, i, j, k, s, af := {}
  Local lshifr, lsy

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
dbcreate("_mo1it1",{;
  {"CODE",       "C",     10,      0},;
  {"USL_OK",     "N",      1,      0},;
  {"DS",         "C",   2300,      0},;
  {"DS1",        "C",    150,      0},;
  {"DS2",        "C",    250,      0};
 })
use _mo1it1 new alias it
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
      if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
        ? "Ошибка в чтении файла",nfile
        ? "Некорректное значение тега YEAR_REPORT",j1
        wait
        exit
      endif
    elseif "KSG" == oXmlNode:title
      @ row(),30 say str(j/k*100,6,2)+"%"
      select T6
      append blank
      t6->SHIFR   :=          mo_read_xml_stroke(oXmlNode,"CODE",)
      t6->NAME    := charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))
      t6->USL_OK  :=      val(mo_read_xml_stroke(oXmlNode,"USL",))
      t6->USL_OKS := lstr(t6->USL_OK)
      t6->ST      :=      val(mo_read_xml_stroke(oXmlNode,"ST",))
      //t6->DURV    :=      val(mo_read_xml_stroke(oXmlNode,"DUR_A",))
      //t6->DURD    :=      val(mo_read_xml_stroke(oXmlNode,"DUR_C",))
      t6->BUKVA   :=    upper(mo_read_xml_stroke(oXmlNode,"PAR",))
      t6->DATEBEG := xml2date(mo_read_xml_stroke(oXmlNode,"D_BEG",))
      t6->DATEEND := xml2date(mo_read_xml_stroke(oXmlNode,"D_END",))
      lkz         :=      val(mo_read_xml_stroke(oXmlNode,"K_Z",))
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

***** 05.01.18
Function work_SprMU(_mo_prof,_mo_spec,_mo_t2)

  dbcreate( "_mo_t2_v1", _mo_t2 )
  use _mo_t2_v1 new alias T2V1

  dbcreate("_mo_prof",_mo_prof)
use _mo_prof new alias PROF
dbcreate("_mo_spec",_mo_spec)
use _mo_spec new alias SPEC
use _mo1usl new alias LUSL
index on shifr to tmp_lusl
use _mo1unit new alias UN
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
      if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
      lusl->DATEBEG := stod("20210101")
      lusl->DATEEND := stod("20211231")
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

***** 28.12.18
Function work_SprDS()
Local fl := .f., lfp, s
use _mo_prof new alias PROF
use _mo_spec new alias SPEC
use _mo1uslf new alias LUSL
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

  dbcreate("_mo1kslp",_mo_kslp)
  use _mo1kslp new alias KS
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
              ks->code    :=      val(mo_read_xml_stroke(oXmlNode,"CODE",))
              ks->NAME    :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))))
              ks->NAME_F  :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME_F",))))
              ks->COEFF   :=      val(mo_read_xml_stroke(oNode2,"C_VAL",))
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

  dbcreate("_mo1kiro",_mo_kiro)
  use _mo1kiro new alias KS
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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
              ks->code    :=      val(mo_read_xml_stroke(oXmlNode,"CODE",))
              ks->NAME    :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME",))))
              ks->NAME_F  :=    ltrim(charrem(eos,charone(" ",mo_read_xml_stroke(oXmlNode,"NAME_F",))))
              ks->COEFF   :=      val(mo_read_xml_stroke(oNode2,"C_VAL",))
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

***** 13.12.21
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

  dbcreate("_mo1unit",_mo_unit)
  use _mo1unit new alias UN
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
        if !((j1 := mo_read_xml_stroke(oXmlNode,"YEAR_REPORT",)) == '2021')
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

***** строка даты для XML-файла
Function date2xml(mdate)
  return strzero(year(mdate),4)+'-'+;
       strzero(month(mdate),2)+'-'+;
       strzero(day(mdate),2)

***** пребразовать дату из "2002-02-01" в тип "DATE"
Function xml2date(s)
  return stod(charrem("-",s))

***** проверить наличие в XML-файле тэга и вернуть его значение
Function mo_read_xml_stroke(_node, _title, _aerr, _binding, _codepage)
  // _node - указатель на узел
  // _title - наименование тэга
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := "", oNode, yes_err := (valtype(_aerr) == "A"),;
      s_msg := 'Отсутствует значение обязательного тэга "'+_title+'"'

  DEFAULT _binding TO .t., _aerr TO {}

  DEFAULT _codepage TO 'WIN1251'
  // ищем необходимый "_title" тэг в узле "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr,s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  endif
  return ret

***** вернуть значение тэга
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := "", c, yes_err := (valtype(_aerr) == "A"),;
      s_msg := 'Отсутствует значение обязательного тэга "'+oNode:title+'"'
  local codepage := upper(_codepage)

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr,s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == "C"
    if codepage == 'WIN1251'
      ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    elseif codepage == 'UTF8'
      ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
    endif
  elseif yes_err
    aadd(_aerr,'Неверный тип данных у тэга "'+oNode:title+'": "'+c+'"')
  endif
  return ret

***** попадает ли date1 (диапазон date1-date2) в диапазон _begin_date-_end_date
Function between_date(_begin_date,_end_date,date1,date2)
// _begin_date - начало действия
// _end_date   - окончание действия
// date1 - проверяемая дата
// date2 - вторая дата диапазона (если = NIL, то проверяем только по date1)
Local fl := .f., fl2
DEFAULT date1 TO sys_date  // по умолчанию проверяем на сегодняшний момент
if empty(_begin_date)
  _begin_date := stod("19930101")  // если начало действия = пусто, то 01.01.1993
endif
// проверка даты date1 на попадание в диапазон
if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
  fl := (date1 <= _end_date)
endif
// проверка диапазона date1-date2 на пересечение с диапазоном
if valtype(date2) == 'D'
  if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
    fl2 := (date2 <= _end_date)
  endif
  fl := (fl .or. fl2)
endif
return fl

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

***** вернуть в массиве запись базы данных
Function get_field()
Local arr := array(fcount())
aeval(arr, {|x,i| arr[i] := fieldget(i) }  )
return arr

***** 15.01.14 функция сортировки шифров услуг по возрастанию (для команды INDEX)
Function fsort_usl(sh_u)
Static _sg := 5
Local i, s := "", flag_z := .f., flag_0 := .f., arr
if left(sh_u,1) == "*"
  flag_z := .t.
elseif left(sh_u,1) == "0"
  flag_0 := .t.
endif
arr := usl2arr(sh_u)
for i := 1 to len(arr)
  if i == 2 .and. flag_z
    s += "9"+strzero(arr[i],_sg)  // для удаленной услуги
  elseif i == 1 .and. flag_0
    s += " "+strzero(arr[i],_sg)  // если впереди стоит 0
  else
    s += strzero(arr[i],1+_sg)
  endif
next
return s

***** 28.01.17
Function usl2arr(sh_u,/*@*/j)
Local i, k, c, ascc, arr := {}, cDelimiter := ".", s := alltrim(sh_u), ;
      s1 := "", is_all_digit := .t.
if left(s,1) == "*"
  s := substr(s,2)
endif
for i := 1 to len(s)
  c := substr(s,i,1) ; ascc := asc(c)
  if between(ascc,48,57) // ?????
    s1 += c
  elseif ISLETTER(c) // ?????
    is_all_digit := .f.
    if len(s1) > 0 .and. right(s1,1) != cDelimiter
      s1 += cDelimiter // ???????????? ??????? ???????????
    endif
    s1 += lstr(ascc)
  else // ????? ???????????
    is_all_digit := .f.
    s1 += cDelimiter
  endif
next
if is_all_digit .and. eq_any((k := len(s1)),7,8)  // ???
  if k == 8
    aadd(arr, int(val(substr(s1,1,1))))
    aadd(arr, int(val(substr(s1,2,1))))
    aadd(arr, int(val(substr(s1,3,1))))
    aadd(arr, int(val(substr(s1,6,3))))
    aadd(arr, int(val(substr(s1,4,1))))
  else
    aadd(arr, int(val(substr(s1,1,1))))
    aadd(arr, int(val(substr(s1,2,1))))
    aadd(arr, int(val(substr(s1,3,1))))
    aadd(arr, int(val(substr(s1,5,3))))
    aadd(arr, int(val(substr(s1,4,1))))
  endif
else // ????????? ??????
  k := numtoken(alltrim(s1),cDelimiter)
  for i := 1 to k
    j := int(val(token(s1,cDelimiter,i)))
    aadd(arr,j)
  next
  if (j := len(arr)) < 5
    for i := j+1 to 5
      aadd(arr,0)
    next
  endif
endif
return arr

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

        if !empty(mDATEEND) .and. mDATEEND < 0d20210101
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
Function work_V021()

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

***** 11.02.21
Function work_V022()
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
        if mDATEBEG >= 0d20210101
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

***** 29.12.21
Function work_V030()
  local _mo_V030 := {;
    {"SCHEMCOD",  "C",   3, 0},;  // 
    {"SCHEME",    "C",  10, 0},;  //
    {"DEGREE",    "N",   2, 0},;  //
    {"COMMENT",   "M",  10, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v030", _mo_V030)
  use _mo_V030 new alias V030
  nfile := "V030.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V030.xml     - Схемы лечения заболевания COVID-19 (TreatReg)"
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

***** 29.12.21
Function work_V031()
  local _mo_V031 := {;
    {"DRUGCODE",  "N",   2, 0},;  // 
    {"DRUGGRUP",  "C",  50, 0},;  //
    {"INDMNN",    "N",   2, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v031", _mo_V031)
  use _mo_V031 new alias V031
  nfile := "V031.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V031.xml     - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)"
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

***** 29.12.21
Function work_V032()
  local _mo_V032 := {;
    {"SCHEDRUG",  "C",   5, 0},;  // 
    {"NAME",      "C", 100, 0},;  //
    {"SCHEMCOD",  "C",   3, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v032", _mo_V032)
  use _mo_V032 new alias V032
  nfile := "V032.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V032.xml     - Сочетание схемы лечения и группы препаратов (CombTreat)"
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

***** 29.12.21
Function work_V033()
  local _mo_V033 := {;
    {"SCHEDRUG",  "C",   5, 0},;  // 
    {"DRUGCODE",  "C",   6, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v033", _mo_V033)
  use _mo_V033 new alias V033
  nfile := "V033.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V033.xml     - Соответствие кода препарата схеме лечения (DgTreatReg)"
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

***** 29.12.21
Function work_V034()
  local _mo_V034 := {;
    {"UNITCODE",  "N",   4, 0},;  // 
    {"UNITMEAS",  "C",  50, 0},;  //
    {"SHORTTIT",  "C",  15, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v034", _mo_V034)
  use _mo_V034 new alias V034
  nfile := "V034.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V034.xml     - Единицы измерения (UnitMeas)"
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

***** 29.12.21
Function work_V035()
  local _mo_V035 := {;
    {"METHCODE",  "N",   4, 0},;  // 
    {"METHNAME",   "C",  50, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v035", _mo_V035)
  use _mo_V035 new alias V035
  nfile := "V035.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V035.xml     - Способы введения (MethIntro)"
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

***** 29.12.21
Function work_V036()
  local _mo_V036 := {;
    {"S_CODE",    "C",  16, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }

  dbcreate("_mo_v036", _mo_V036)
  use _mo_V036 new alias V036
  nfile := "V036.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "V036.xml     - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)"
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

***** 31.12.21
function make_implant()

  local _mo_impl := {;
    {"ID",      "N",  5, 0},;  // Код , уникальный идентификатор записи
    {"RZN",     "N",  6, 0},;  // код изделия согласно Номенклатурному классификатору Росздравнадзора
    {"PARENT",  "N",  5, 0},;  // Код родительского элемента
    {"NAME",    "C", 120, 0},;  // Наименование , наименование вида изделия
    {"LOCAL",   "C",  80, 0},;  // Локализация , анатомическая область, к которой относится локализация и/или действие изделия
    {"MATERIAL","C",  20, 0},;  // Материал , тип материала, из которого изготовлено изделие
    {"METAL",   "L",   1, 0},;  // Металл , признак наличия металла в изделии
    {"ORDER",   "N",   4, 0};  // Порядок сортировки
  }

  dbcreate("_mo_impl", _mo_impl)
  use _mo_impl new alias IMPL
  nfile := "1.2.643.5.1.13.13.11.1079_2.2.xml"  // может меняться из-за версий
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1079.xml - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
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
            IMPL->METAL := iif(upper(mMetal) == 'ДА', .t., .f.)
            IMPL->ORDER := val(mOrder)
          endif
        next j1
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

// ***** 09.03.21
// Function make_TO01()

//   local _mo_T001 := {;
//     { 'MCOD',       'C',    6,      0 },;
//     { 'CODEM',      'C',    6,      0 },;
//     { 'NAMEF',      'M',    10,     0 },;
//     { 'NAMES',      'C',    80,     0 },;
//     { 'ADRES',      'M',    10,     0 },;
//     { 'MAIN',       'C',    1,      0 },;
//     { 'PFA',        'C',    1,      0 },;
//     { 'PFS',        'C',    1,      0 },;
//     { 'DATEBEG',    'D',    8,      0 },;
//     { 'DATEEND',    'D',    8,      0 };
//   }
//   local dbName := '_mo_t001'
//   local dbSource := 'T001'
//   local mName := '', mArr

//   ? 'Т001.dbf     - Справочник МО и обособленных подразделений, финансируемых самостоятельно'
//   dbcreate('_mo_t001', _mo_T001)
//   dbUseArea( .t.,, dbName, dbName, .t., .f. )

//   dbUseArea( .t.,, dbSource, dbSource, .f., .f. )
//   (dbSource)->(dbGoTop())
//   do while !(dbSource)->(EOF())
//     if (dbSource)->(DATEEND) > 0d20210101
//       (dbName)->(dbAppend())
//       (dbName)->MCOD := (dbSource)->MCOD
//       (dbName)->CODEM := (dbSource)->CODEM
//       (dbName)->NAMEF := (dbSource)->NAMEF
//       (dbName)->NAMES := (dbSource)->NAMES
//       (dbName)->ADRES := (dbSource)->ADRES_M
//       (dbName)->MAIN := (dbSource)->MAIN
//       (dbName)->PFA := (dbSource)->PFA
//       (dbName)->PFS := (dbSource)->PFS
//       (dbName)->DATEBEG := (dbSource)->DATEBEG
//       (dbName)->DATEEND := (dbSource)->DATEEND
//     endif
//     (dbSource)->(dbSkip())
//   enddo
//   (dbSource)->(dbCloseArea())
//   (dbName)->(dbCloseArea())

//   return NIL

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

***** 14.12.21
function create_version_DB()
  local versionDB := {;
    {'TYPE',    'C',     10,      0},;    // Тип содержимого файла
    {'VERSION', 'C',      3,      0},;    // Версия структуры файла
    {'DATE_V',  'D',      8,      0};     // Дата создания файла
  }
  local sbase := "_versionDB"

  if hb_FileExists(sbase + '.dbf')
    dbcreate(sbase, versionDB)
  endif
  return nil