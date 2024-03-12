#include 'common.ch'
#include 'function.ch'

Function read_xml_stroke_1251_to_utf8( node, title )
  Return hb_StrToUTF8( mo_read_xml_stroke( node, title, , , 'win1251' ), 'RU866' )

Function date_xml_sqlite( sDate )

  Local sDay, sMonth, sYear, out

  sDay := SubStr( sDate, 1, 2 )
  sMonth := SubStr( sDate, 4, 2 )
  sYear := SubStr( sDate, 7, 4 )
  out := sYear + '-' + sMonth + '-' + sDay

  Return out

// строка даты для XML-файла
Function date2xml( mdate )
  Return StrZero( Year( mdate ), 4 ) + '-' + ;
    StrZero( Month( mdate ), 2 ) + '-' + ;
    StrZero( Day( mdate ), 2 )

// пребразовать дату из "2002-02-01" в тип "DATE"
Function xml2date( s )
  Return SToD( CharRem( '-', s ) )

// проверить наличие в XML-файле тэга и вернуть его значение
Function mo_read_xml_stroke( _node, _title, _aerr, _binding, _codepage )

  // _node - указатель на узел
  // _title - наименование тэга
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', oNode, yes_err := ( ValType( _aerr ) == 'A' ), ;
    s_msg := 'Отсутствует значение обязательного тэга "' + _title + '"'

  Default _binding To .t., _aerr TO {}

  Default _codepage To 'WIN1251'
  // ищем необходимый "_title" тэг в узле "_node"
  oNode := _node:find( _title )
  If oNode == Nil .and. _binding .and. yes_err
    AAdd( _aerr, s_msg )
  Endif
  If oNode != NIL
    ret := mo_read_xml_tag( oNode, _aerr, _binding, _codepage )
  Endif

  Return ret

// вернуть значение тэга
Function mo_read_xml_tag( oNode, _aerr, _binding, _codepage )

  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', c, yes_err := ( ValType( _aerr ) == 'A' ), ;
    s_msg := 'Отсутствует значение обязательного тэга "' + oNode:title + '"'
  Local codepage := Upper( _codepage )

  If Empty( oNode:aItems )
    If _binding .and. yes_err
      AAdd( _aerr, s_msg )
    Endif
  Elseif ( c := ValType( oNode:aItems[ 1 ] ) ) == 'C'
    If codepage == 'WIN1251'
      ret := hb_ANSIToOEM( AllTrim( oNode:aItems[ 1 ] ) )
    Elseif codepage == 'RU1251'
      // ret := hb_strToUTF8(alltrim(oNode:aItems[1]), 'ru1251')
      If HB_ISSTRING( oNode:aItems[ 1 ] )
        ret := AllTrim( hb_StrToUTF8( oNode:aItems[ 1 ] ), 'ru1251' )
      Endif
    Elseif codepage == 'UTF8'
      // ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )
      ret := AllTrim( oNode:aItems[ 1 ] )
    Endif
  Elseif yes_err
    AAdd( _aerr, 'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"' )
  Endif

  Return ret
