#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define TRACE

/*
 * 25.04.2022
*/
procedure main( ... )
  local cParam, cParamL
  local aParams
  local nResult

  local source
  local destination
  local lExists
  local os_sep := hb_osPathSeparator()
  local fp, i, s

  LOCAL lCreateIfNotExist := .T.
  LOCAL db

  REQUEST HB_CODEPAGE_UTF8
  HB_CDPSELECT("UTF8")
  // REQUEST HB_LANG_RU866
  // HB_LANGSELECT("RU866")
  
  // REQUEST DBFNTX
  // RDDSETDEFAULT('DBFNTX')
  
  // SET SCOREBOARD OFF
  // SET EXACT ON
  // SET DATE GERMAN
  // SET WRAP ON
  // SET CENTURY ON
  // SET EXCLUSIVE ON
  // SET DELETED ON
  // setblink(.f.)
  
  
  // READINSERT(.T.)        // режим редактирования по умолчанию Insert
  // KEYBOARD ''
  // ksetnum(.t.)
  // SETCURSOR(0)
  // SETCLEARB(' ')
  // SET COLOR TO
  
  source := upper(beforatnum(os_sep, exename())) + os_sep
  destination := upper(beforatnum(os_sep, exename())) + os_sep

  aParams := hb_AParams()
  for each cParam in aParams
    cParamL := Lower( cParam )
    do case
      case cParamL == "-help"
        About()
        return
      case cParamL == "-quiet"
        // ? 'quiet'
      case cParamL == "-all"
        if HB_VFEXISTS(source + FILE_HASH)
          HB_VFERASE(source + FILE_HASH)
        endif
      case hb_LeftEq( cParamL, "-in=" )
        source := SubStr( cParam, 4 + 1 )
      case hb_LeftEq( cParamL, "-out=" )
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

  OutStd(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol())

  if sqlite3_libversion_number() < 3005001
    return
  endif

  // db := sqlite3_open( destination + "chip_mo.s3db", lCreateIfNotExist )
  db := sqlite3_open( destination + 'mzdrav.db', lCreateIfNotExist )

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile( db, .T. ) // включим профайлер
         sqlite3_trace( db, .T. )   // включим трассировщик
    #endif

    sqlite3_exec( db, "PRAGMA auto_vacuum=0" )
    sqlite3_exec( db, "PRAGMA page_size=4096" )

    make_mzdrav( db, source )

    // // справочники группы F___
    // // make_f005( db, source )
    // // make_f006( db, source )
    // // make_f007( db, source )
    // // make_f008( db, source )
    // // make_f009( db, source )
    // // make_f010( db, source )
    // // make_f011( db, source )
    // // make_f014( db, source )
    // // make_f015( db, source )
    // // // справочники группы O___
    // // make_o001( db, source )
    // // // справочники группы Q___
    // // make_q015( db, source )
    // // make_q016( db, source )
    // // make_q017( db, source )
    // // справочники группы V___
    // make_v002( db, source )
    // // make_v005( db, source )
    // // make_v006( db, source )
    // // make_v008( db, source )
    // make_v009( db, source )
    // make_v010( db, source )
    // make_v012( db, source )
    // // make_v013( db, source )
    // // make_v014( db, source )
    // make_v015( db, source )
    // make_v016( db, source )
    // make_v017( db, source )
    // make_v018( db, source )
    // make_v019( db, source )
    // make_v020( db, source )
    // make_v021( db, source )
    // make_v022( db, source )
    // // make_v023( db, source )
    // make_v024( db, source )
    // make_v025( db, source )
    // // make_v026( db, source )
    // // make_v027( db, source )
    // // make_v028( db, source )
    // // make_v029( db, source )

  endif
  return

***** строка даты для XML-файла
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' + ;
       strzero(month(mdate), 2) + '-' + ;
       strzero(day(mdate), 2)

***** пребразовать дату из "2002-02-01" в тип "DATE"
Function xml2date(s)
  return stod(charrem('-', s))

***** проверить наличие в XML-файле тэга и вернуть его значение
Function mo_read_xml_stroke(_node, _title, _aerr, _binding, _codepage)
  // _node - указатель на узел
  // _title - наименование тэга
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', oNode, yes_err := (valtype(_aerr) == 'A'), ;
      s_msg := 'Отсутствует значение обязательного тэга "' + _title + '"'

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
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'),;
      s_msg := 'Отсутствует значение обязательного тэга "' + oNode:title + '"'
  local codepage := upper(_codepage)

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr, s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == 'C'
    if codepage == 'WIN1251'
      ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    elseif codepage == 'UTF8'
      // ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
      ret := alltrim(oNode:aItems[1])
    endif
  elseif yes_err
    aadd(_aerr, 'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"')
  endif
  return ret

procedure About()

  OutStd( ;
      'Конвертер справочников обязательного медицинского страхования' + hb_eol() + ;
      'Copyright (c) 2022, Vladimir G.Baykin' + hb_eol() + hb_eol())
   
  OutStd( ;
      'Syntax:  create_dict [options] ' + hb_eol() + hb_eol())
  OutStd( ;
      'Опции:' + hb_eol() + ;
      '      -in=<source directory>' + hb_eol() + ;
      '      -out=<destination directory>' + hb_eol() + ;
      '      -all - конвертировать все' + hb_eol() + ;
      '      -help - помощь' + hb_eol() ;
  )
      
  return
   
****** 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say "Обработка файла " + nfile + " -"
  return Col()

****** 13.02.22
function out_obrabotka(nfile)

  OutStd( ;
    '===== Обработка файла ' + nfile )
  return nil

****** 15.02.22
function out_create_file(nfile)

  OutStd( ;
    'Создание файла ' + nfile )
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

  do case
    case nError == FILE_NOT_EXIST
      OutErr( ;
        'Файл ' + nfile + ' не существует' + hb_eol() )
    case nError == FILE_READ_ERROR
      OutErr( ;
        'Ошибка в загрузке файла ' + nfile + hb_eol() )
    case nError == FILE_RENAME_ERROR
      OutErr( ;
        'Ошибка переименования файла ' + nfile + hb_eol() )
    case nError == DIR_IN_NOT_EXIST
      OutErr( ;
        'Каталог исходных данных "' + nfile + '" не существует. Продолжение работы не возможно!' + hb_eol() )
    case nError == DIR_OUT_NOT_EXIST
      OutErr( ;
        'Каталог для выходных данных "' + nfile + '" не существует. Продолжение работы не возможно!' + hb_eol() )
    case nError == TAG_YEAR_REPORT
        OutErr( ;
          'Ошибка при чтении файла "' + nfile + '". Некорректное значение тега YEAR_REPORT ' + j + hb_eol() )
    case nError == TAG_PLACE_ERROR
        OutErr( ;
          'Ошибка при чтении файла "' + nfile + '" - более одного тега PLACE в отделении: ' + alltrim(j) + hb_eol() )
    case nError == TAG_PERIOD_ERROR
        OutErr( ;
          'Ошибка при чтении файла "' + nfile + '" - более одного тега PERIOD в учреждении: ' + j + " в услуге " + k + hb_eol() )
    case nError == TAG_VALUE_EMPTY
        OutErr( ;
          'Замечание при чтении файла "' + nfile + '" - пустое значение тега VALUE/LEVEL: ' + j + " в услуге " + k + hb_eol() )
    case nError == TAG_VALUE_INVALID
        OutErr( ;
          'Замечание при чтении файла "' + nfile + '" - некорректное значение тега VALUE/LEVEL: ' + j + " в услуге " + k + hb_eol() )
    case nError == TAG_ROW_INVALID
        OutErr( ;
          'Ошибка при загрузки строки - ' + j + ' из файла ' +nfile + hb_eol() )
    case nError == UPDATE_TABLE_ERROR
        OutErr( ;
          'Ошибка обновления записей в таблице - ' + nfile + hb_eol() )
  end case

  return nil
