#include 'common.ch'
#include 'inkey.ch'
#include 'fileio.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

// 05.07.25
proc main( ... )

  local cParam, cParamL
  local aParams

  local source
  local destination
//  local curent_dir
  local time_start, total_time

  source := beforatnum( hb_ps(), exename() ) + hb_ps()
  destination := beforatnum( hb_ps(), exename() ) + hb_ps()
//  curent_dir := beforatnum( hb_ps(), exename() ) + hb_ps()

  aParams := hb_AParams()

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")

  REQUEST DBFNTX
  RDDSETDEFAULT("DBFNTX")

  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON
  setblink(.f.)

  FOR EACH cParam IN aParams
    cParamL := Lower( cParam )
    DO CASE
      CASE cParamL == '-help'
        About()
        RETURN
      CASE cParamL == '-quiet'
        // ? 'quiet'
      CASE cParamL == '-all'
      CASE hb_LeftEq( cParamL, '-in=' )
        source := SubStr( cParam, 4 + 1 )
      CASE hb_LeftEq( cParamL, '-out=' )
        destination := SubStr( cParam, 5 + 1 )
    endcase
  next

  if right(source, 1) != hb_ps()
    source += hb_ps()
  endif
  if right(destination, 1) != hb_ps()
    destination += hb_ps()
  endif

  time_start := seconds()

  //
  OutStd( '********' + hb_eol() )
  OutStd( 'Справочники ФФОМС онкология.' + hb_eol() )
  OutStd( '********' + hb_eol() )

  make_oid_sootv( source, destination )
  make_oid_stad_TNM( source, destination )
  total_time := seconds() - time_start

  if total_time > 0
    OutStd( 'Время конвертации - ' + sectotime( total_time ) + hb_eol() )
  endif

  SET KEY K_ALT_F4 TO
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X TO
  SET COLOR TO
  SET CURSOR ON
  return

//
PROCEDURE About()

  OutStd('Конвертер справочников ФФОМС рнкология', hb_eol(), ;
      'Copyright (c) 2025, Vladimir G.Baykin', hb_eol(), ;
    hb_eol())
  OutStd('Syntax:  test_onko [options] ', hb_eol(), hb_eol())
  OutStd('Опции:', hb_eol(), ;
    '      -in=<source directory>', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -help - помощь', hb_eol())
    
  RETURN

// 11.02.22
function obrabotka( nfile )

  @ row() + 1, 1 say 'Обработка файла ' + nfile + ' -'
  return Col()

// 13.02.22
function out_obrabotka( nfile )

  OutStd( '===== Обработка файла ' + nfile )
  return nil

// 15.02.22
function out_create_file( nfile )

  OutStd( 'Создание файла ' + nfile )
  return nil

// 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

// 14.02.22
function out_obrabotka_count(j, k)

  OutStd( str(j / k * 100, 6, 2) + '%' )
  return nil

// 15.02.22
function out_error(nError, nfile, j, k)

  DO CASE
  CASE nError == FILE_NOT_EXIST
    OutErr('Файл ' + nfile + ' не существует', hb_eol())
  CASE nError == FILE_READ_ERROR
    OutErr('Ошибка в загрузке файла ' + nfile, hb_eol())
  CASE nError == FILE_RENAME_ERROR
    OutErr('Ошибка переименования файла ' + nfile, hb_eol())
  CASE nError == DIR_IN_NOT_EXIST
    OutErr('Каталог исходных данных "' + nfile + '" не существует. Продолжение работы не возможно!', hb_eol())
  CASE nError == DIR_OUT_NOT_EXIST
    OutErr('Каталог для выходных данных "' + nfile + '" не существует. Продолжение работы не возможно!', hb_eol())
  CASE nError == TAG_YEAR_REPORT
      OutErr('Ошибка при чтении файла "' + nfile + '". Некорректное значение тега YEAR_REPORT ', j, hb_eol())
  CASE nError == TAG_PLACE_ERROR
      OutErr('Ошибка при чтении файла "' + nfile + '" - более одного тега PLACE в отделении: ', alltrim(j), hb_eol())
  CASE nError == TAG_PERIOD_ERROR
      OutErr('Ошибка при чтении файла "' + nfile + '" - более одного тега PERIOD в учреждении: ', j, ' в услуге ', k, hb_eol())
  CASE nError == TAG_VALUE_EMPTY
      OutErr('Замечание при чтении файла "' + nfile + '" - пустое значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol())
  CASE nError == TAG_VALUE_INVALID
      OutErr('Замечание при чтении файла "' + nfile + '" - некорректное значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol())
  end case
  return nil

// строка даты для XML-файла
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' + ;
         strzero(month(mdate), 2) + '-' + ;
         strzero(day(mdate), 2)

// пребразовать дату из "2002-02-01" в тип "DATE"
Function xml2date(s)
  return stod(charrem('-', s))

// проверить наличие в XML-файле тэга и вернуть его значение
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
    aadd(_aerr, s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  endif
  return ret

// вернуть значение тэга
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'), ;
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
      ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
    endif
  elseif yes_err
    aadd(_aerr, 'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"')
  endif
  return ret
