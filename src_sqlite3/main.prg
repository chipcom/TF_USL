#include "function.ch"

#require 'hbsqlit3'

// #define TRACE

/*
 * 23.01.2022
*/
procedure main()
  LOCAL lCreateIfNotExist := .T.
  // LOCAL db := sqlite3_open( "chip_mo.s3db", lCreateIfNotExist )
  LOCAL db := sqlite3_open( "mzdrav.db", lCreateIfNotExist )

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")
  
  ? sqlite3_libversion()
  // sqlite3_sleep( 3000 )

  IF sqlite3_libversion_number() < 3005001
     RETURN
  ENDIF

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile( db, .T. ) // включим профайлер
         sqlite3_trace( db, .T. )   // включим трассировщик
    #endif

    sqlite3_exec( db, "PRAGMA auto_vacuum=0" )
    sqlite3_exec( db, "PRAGMA page_size=4096" )

    // справочники группы Минестерства здравоохранения
    make_ed_izm( db )

  endif
  return

***** строка даты для XML-файла
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' +;
       strzero(month(mdate), 2) + '-' +;
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
  Local ret := '', oNode, yes_err := (valtype(_aerr) == 'A'),;
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

***** вернуть значение тэга
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки, если пусто не перекодировать
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'),;
      s_msg := 'Отсутствует значение обязательного тэга "' + oNode:title + '"'
  local codepage := upper(_codepage)

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr,s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == 'C'
    if codepage == 'WIN1251'
      ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    elseif codepage == 'UTF8'
      ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
    endif
  elseif yes_err
    aadd(_aerr,'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"')
  endif
  return ret
