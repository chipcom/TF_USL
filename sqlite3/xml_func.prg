#include 'common.ch'
#include 'function.ch'

function read_xml_stroke_1251_to_utf8(node, title)
  return hb_strToUTF8(mo_read_xml_stroke(node, title, , , 'win1251'), 'RU866')

function date_xml_sqlite( sDate )

  local sDay, sMonth, sYear, out

  sDay := substr( sDate, 1, 2 )
  sMonth := substr( sDate, 4, 2 )
  sYear := substr( sDate, 7, 4 )
  out := sYear + '-' + sMonth + '-' + sDay
  return out

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
    elseif codepage == 'RU1251'
      // ret := hb_strToUTF8(alltrim(oNode:aItems[1]), 'ru1251')
      if HB_ISSTRING(oNode:aItems[1])
        ret := alltrim(hb_strToUTF8(oNode:aItems[1]), 'ru1251')
      endif
    elseif codepage == 'UTF8'
      // ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
      ret := alltrim(oNode:aItems[1])
    endif
  elseif yes_err
    aadd(_aerr, 'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"')
  endif
  return ret