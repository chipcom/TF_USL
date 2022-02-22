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
   V037.xml     - Перечень методов ВМП, требующих имплантацию медицинских изделий

   OID 1.2.643.5.1.13.13.11.1070 - Номенклатура медицинских услуг (используется в других справочниках)
   OID 1.2.643.5.1.13.13.11.1079 - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями
   OID 1.2.643.5.1.13.13.11.10069 - Степень тяжести состояния пациента
   OID 1.2.643.5.1.13.13.11.1468_2.1.xml - Пути введения лекарственных препаратов
   OID 1.2.643.5.1.13.13.11.1358.xml - Единицы измерения

//  Что получаем на выходе - наши файлы

   _mo2usl    - _mo_usl  - справочник наименований всех услуг
   _mo2uslc   - _mo_uslc - справочник услуг с ценами для конкретных МО
                           без КСГ

  _mo_t2_v1   - справочник соответсвия услуг ТФОМС услугам МЗ РФ
  _mo_V018    - классификатор видов высокотехнологичной медицинской помощи (HVid)
*/

#include "dict_error.ch"

#include 'inkey.ch'
#include 'fileio.ch'
#include 'directry.ch'
#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

#define FILE_HASH   'files.hst'   // имя файла для хэшев файлов

external errorsys

// 01.11.21
// вернуть префикс справочного файла для года
function prefixFileName()
  return '_mo' + substr(CURENT_YEAR, 4, 1)

******* 19.02.22
proc main( ... )
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

  local cParam, cParamL
  local aParams

  local nameFileUsl := prefixFileName() + 'usl'
  local nameFileUslC := prefixFileName() + 'uslc'
  local nameFileIt := prefixFileName() + 'it'
  local nameFileK006 := prefixFileName() + 'k006'

  local k006dbf := nameFileK006 + '.dbf'
  local k006dbt := nameFileK006 + '.dbt'
  local nResult

  local source
  local destination
  local curent_dir
  local lExists
  local os_sep := hb_osPathSeparator()
  local fp, i, s
  local t1, t2


  Public sys_date := date() // ctod('31/12/2021') //date()
  Public sys_year := year(date()) // 2021 // year(date())
  Public hash_files   // переменная для хранения хэшев исходных файлов

  t1 := seconds()

  source := upper(beforatnum(os_sep, exename())) + os_sep
  destination := upper(beforatnum(os_sep, exename())) + os_sep
  curent_dir := upper(beforatnum(os_sep, exename())) + os_sep

  aParams := hb_AParams()

  // delete file ttt.ttt
  f_first()

  FOR EACH cParam IN aParams
    cParamL := Lower( cParam )
    DO CASE
      CASE cParamL == "-help"
        About()
        RETURN
      CASE cParamL == "-quiet"
        // ? 'quiet'
      CASE cParamL == "-all"
        if HB_VFEXISTS(source + FILE_HASH)
          HB_VFERASE(source + FILE_HASH)
        endif
      CASE hb_LeftEq( cParamL, "-in=" )
        source := SubStr( cParam, 4 + 1 )
      CASE hb_LeftEq( cParamL, "-out=" )
        destination := SubStr( cParam, 5 + 1 )
    endcase
  next

  if right(source, 1) != os_sep
    source += os_sep
  endif
  if right(destination, 1) != os_sep
    destination += os_sep
  endif
  
  if !(lExists := hb_vfDirExists( source ))
    out_error(DIR_IN_NOT_EXIST, source)
    quit
  endi

  if !(lExists := hb_vfDirExists( destination ))
    out_error(DIR_OUT_NOT_EXIST, destination)
    quit
  endi

  // прочитаем массив md5-хэшев файлов
  hash_files := hb_Hash()
  hash_files := read_files_md5(source)

  // make_TO01()
  // Справочники минздрава
  OutStd( '***********************' + hb_eol() )
  OutStd( 'Справочники министерства здравоохранения.' + hb_eol() )
  OutStd( '***********************' + hb_eol() )

  make_implant(source, destination)
  make_severity(source, destination)
  make_method_inj(source, destination)
  make_ed_izm(source, destination)

  OutStd( '***********************' + hb_eol() )
  OutStd( 'Справочники ФФОМС.' + hb_eol() )
  OutStd( '***********************' + hb_eol() )
  // Справочники ФФОМС
  work_V002(source, destination)
  work_V009(source, destination)
  work_V010(source, destination)
  work_V012(source, destination)
  work_V015(source, destination)
  work_V016(source, destination)
  work_V017(source, destination)
  work_V018(source, destination)
  work_V019(source, destination)
  work_V020(source, destination)
  work_V021(source, destination)
  work_V022(source, destination)
  work_V025(source, destination)
  work_V030(source, destination)
  work_V031(source, destination)
  work_V032(source, destination)
  work_V033(source, destination)
  work_V034(source, destination)
  // work_V035(source, destination)
  work_V036(source, destination)
  work_V037(source, destination)
  make_Q015(source, destination)
  make_Q016(source, destination)
  make_Q017(source, destination)
  make_F006(source, destination)
  make_F010(source, destination)
  make_F011(source, destination)
  make_F014(source, destination)
  make_O001(source, destination)

  InitSpravFFOMS(source, destination)
  //
  read_spr_N00X(source, destination)
  //
  OutStd( '***********************' + hb_eol() )
  OutStd( 'Справочники ТФОМС.' + hb_eol() )
  OutStd( '***********************' + hb_eol() )

  // make_uslugi_mz(source, destination)  // Справочник минздрава для формирования файлов ТФОМС
  // Справочники ТФОМС
  dbcreate(destination + nameFileUsl, _mo_usl)
  work_Shema(source, destination)
  work_SprSubDiv(source, destination)
  work_SprDep(source, destination)
  work_LvlPay(source, destination)
  work_MOServ(source, destination)
  work_Prices(source, destination)
  work_mo_uslf(source, destination)
  work_SprUnit(source, destination)
  work_SprKslp(source, destination)
  work_SprKiro(source, destination)
  work_SprMU(source, destination)
  work_SprDS(source, destination)
  work_t006(source, destination)
  close databases
  //
  HB_VFERASE(destination + k006dbf)
  nResult := FRename(destination + 't006_2.dbf', destination + k006dbf)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbf')
  endif

  HB_VFERASE(destination + k006dbt)
  nResult := FRename(destination + 't006_2.dbt', destination + k006dbt)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbt')
  endif
  if upper(source) != upper(destination)
    filecopy(source + 'onko_napr' + '.dbf', destination + 'onko_napr' + '.dbf')
    filecopy(source + 'onko_ksg' + '.dbf', destination + 'onko_ksg' + '.dbf')
    filecopy(source + 'telemed' + '.dbf', destination + 'telemed' + '.dbf')
    filecopy(source + 'par_org' + '.dbf', destination + 'par_org' + '.dbf')
  endif

  //
  dbcreate(destination + nameFileIt, { {"ds","C",5,0}, {"it","N",1,0} } )

  use (destination + nameFileIt) new alias IT
  index on ds+str(it,1) to tmp_it

  use (destination + nameFileK006) new alias K6
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

  // добавим наименования КСГ за 2022 год
  use (destination + nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use (destination + 't006_u') new alias T006
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
  work_uslc(source, destination)
  //
  use (destination + nameFileUslC) new alias LUSLC
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
  use (destination + '_mo_prof') new alias PROF
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
  fp := fcreate(curent_dir + "_mo_prof.txt") ; n_list := 1 ; tek_stroke := 0
  for j := 1 to len(aup)
    s := aup[j,1]+iif(aup[j,2] == 0, "взр", "реб")+".{"
    asort(aup[j,3])
    for i := 1 to len(aup[j,3])
      s += lstr(aup[j,3,i])+"-" + alltrim(inieditspr(A__MENUVERT,glob_V002,aup[j,3,i]))
      if i < len(aup[j,3])
        s += ","
      endif
    next
    add_string(s+"}")
  next
  fclose(fp)
  //
  aup := {}
  use (destination + '_mo_spec') new alias SPEC
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
  fp := fcreate(curent_dir + "_mo_spec.txt") ; n_list := 1 ; tek_stroke := 0
  for j := 1 to len(aup)
    s := aup[j,1]+iif(aup[j,2] == 0, "взр", "реб")+".{"
    asort(aup[j,3])
    for i := 1 to len(aup[j,3])
      s += lstr(aup[j,3,i])+"-"+ alltrim(inieditspr(A__MENUVERT,glob_V021,aup[j,3,i]))
      if i < len(aup[j,3])
        s += ","
      endif
    next
    add_string(s+"}")
  next
  fclose(fp)
  close databases
  HB_VFERASE(curent_dir + "tmp*.dbf")
  HB_VFERASE(curent_dir + "tmp*.ntx")
  HB_VFERASE(curent_dir + "tmp_it.ntx")
  HB_VFERASE(curent_dir + "tmp_k6.ntx")
  HB_VFERASE(curent_dir + "tmp_lusl.ntx")
  HB_VFERASE(curent_dir + "tmp_lvlpay.ntx")
  HB_VFERASE(curent_dir + "tmp_ok.ntx")
  HB_VFERASE(curent_dir + "tmp_on.ntx")
  HB_VFERASE(curent_dir + "tmp_po.ntx")
  HB_VFERASE(curent_dir + "tmp_prices.ntx")
  HB_VFERASE(curent_dir + "tmp_prof.ntx")
  HB_VFERASE(curent_dir + "tmp_shema.ntx")
  HB_VFERASE(curent_dir + "tmp_spec.ntx")
  HB_VFERASE(curent_dir + "tmp_tel.ntx")
  HB_VFERASE(curent_dir + "tmp_unit.ntx")
  HB_VFERASE(curent_dir + "tmp_usl.ntx")
  HB_VFERASE(curent_dir + "tmp1.ntx")
  HB_VFERASE(curent_dir + "tmp6.ntx")
  HB_VFERASE(curent_dir + "not_lev.ntx")
  HB_VFERASE(curent_dir + "not_usl.ntx")
  
  HB_VFERASE(destination + 't006_2.dbf')
  HB_VFERASE(destination + 't006_2.dbt')
  HB_VFERASE(destination + 't006_d.dbf')
  HB_VFERASE(destination + 't006_u.dbf')

  // запишем md5-хэши файлов источников
  create_files_md5(source, '*.xml')

  // запишем md5-хэши готовых файлов 
  // create_files_md5(destination, '*.dbf')

  t2 := seconds() - t1

  if t2 > 0
    OutStd( "Время конвертации - " + sectotime(t2) + hb_eol() )
  endif

  SET KEY K_ALT_F4 TO
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X TO
  SET COLOR TO
  SET CURSOR ON

  return

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

PROCEDURE About()

  OutStd( ;
    "Конвертер справочников обязательного медицинского страхования" + hb_eol() + ;
      "Copyright (c) 2022, Vladimir G.Baykin" + hb_eol() + ;
    hb_eol() )
 
  OutStd( ;
    "Syntax:  create_dict [options] " + hb_eol() + hb_eol() )
  OutStd( ;
    "Опции:" + hb_eol() + ;
    "      -in=<source directory>" + hb_eol() + ;
    "      -out=<destination directory>" + hb_eol() + ;
    "      -all - конвертировать все" + hb_eol() + ;
    "      -help - помощь" + hb_eol() ;
  )
    
  RETURN
 
****** 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say "Обработка файла " + nfile + " -"
  return Col()

****** 13.02.22
function out_obrabotka(nfile)

  OutStd( ;
    "===== Обработка файла " + nfile )
  return nil

****** 15.02.22
function out_create_file(nfile)

  OutStd( ;
    "Создание файла " + nfile )
  return nil

****** 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

****** 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + "%" )
  return nil

****** 15.02.22
function out_error(nError, nfile, j, k)

  DO CASE
  CASE nError == FILE_NOT_EXIST
    OutErr( ;
      "Файл " + nfile + " не существует" + hb_eol() )
  CASE nError == FILE_READ_ERROR
    OutErr( ;
      "Ошибка в загрузке файла " + nfile + hb_eol() )
  CASE nError == FILE_RENAME_ERROR
    OutErr( ;
      "Ошибка переименования файла " + nfile + hb_eol() )
  CASE nError == DIR_IN_NOT_EXIST
    OutErr( ;
      'Каталог исходных данных "' + nfile + '" не существует. Продолжение работы не возможно!' + hb_eol() )
  CASE nError == DIR_OUT_NOT_EXIST
    OutErr( ;
      'Каталог для выходных данных "' + nfile + '" не существует. Продолжение работы не возможно!' + hb_eol() )
  CASE nError == TAG_YEAR_REPORT
      OutErr( ;
        'Ошибка при чтении файла "' + nfile + '". Некорректное значение тега YEAR_REPORT ' + j + hb_eol() )
  CASE nError == TAG_PLACE_ERROR
      OutErr( ;
        'Ошибка при чтении файла "' + nfile + '" - более одного тега PLACE в отделении: ' + alltrim(j) + hb_eol() )
  CASE nError == TAG_PERIOD_ERROR
      OutErr( ;
        'Ошибка при чтении файла "' + nfile + '" - более одного тега PERIOD в учреждении: ' + j + " в услуге " + k + hb_eol() )
  CASE nError == TAG_VALUE_EMPTY
      OutErr( ;
        'Замечание при чтении файла "' + nfile + '" - пустое значение тега VALUE/LEVEL: ' + j + " в услуге " + k + hb_eol() )
  CASE nError == TAG_VALUE_INVALID
      OutErr( ;
        'Замечание при чтении файла "' + nfile + '" - некорректное значение тега VALUE/LEVEL: ' + j + " в услуге " + k + hb_eol() )
  end case

  return nil

function read_files_md5(source)
  local fp, i, s
  LOCAL aFiles, aFile
  LOCAL cBuffer, nFileSize
  local aStr, hash_files, tArr, row

  if HB_VFEXISTS(source + FILE_HASH)
    hash_files := hb_Hash()

    fp := HB_VFOPEN(source + FILE_HASH, FO_READ)
    nFileSize := hb_vfSize( fp )
    cBuffer := Space( nFileSize )
    IF hb_vfRead( fp, @cBuffer, nFileSize ) != nFileSize
    else
      aStr := split(cBuffer, hb_eol())
      for each row in aStr
        tArr := split(row, ', ')
        if len(tArr) == 2
          hash_files[tArr[1]] := tArr[2]
        endif
      next
    endif

    hb_vfClose( fp )
    return hash_files
  endif
  return nil
  
function create_files_md5(source, ext)
  local fp, i, s
  LOCAL aFiles, aFile

  fp := fcreate(source + FILE_HASH, FC_HIDDEN)
  IF ! Empty( aFiles := hb_vfDirectory( source + ext ) )
    // IF ! Empty( aFiles := hb_vfDirectory( source + '*.xml' ) )
    s := ''
    FOR EACH aFile IN aFiles
      s := upper(aFile[ F_NAME ]) + ', ' + hb_MD5File( source + aFile[ F_NAME ] ) + hb_eol()
      FWrite( fp, s)
    NEXT
  endif
  fclose(fp)
  return nil

function check_izm_file(nameRef, nfile)
  local fl := .f.
  local hashMD5File

  if hash_files != nil
    nameRef := upper(nameRef)
    if hb_HHasKey( hash_files, nameRef )
      hashMD5File := hb_HGet(hash_files, nameRef)
      if hashMD5file == hb_MD5File( nfile ) // файл не изменялся
        fl := .t.
      endif
    endif
  endif
  return fl