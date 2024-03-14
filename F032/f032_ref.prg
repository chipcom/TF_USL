#include 'function.ch'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
  
PROCEDURE Main() 
  
  local _f032 := {;
    {'MCOD',     'C',      6,      0},;
    {'NAMEMOK',  'C',     50,      0},;
    {'NAMEMOP',  'C',    150,      0},;
    {'ADDRESS',  'C',    250,      0},;
    {'YEAR',     'N',     17,      0};
  }
  local oXmlDoc, oXmlNode
  local cAlias := 'F032', nameRef, nfile, k, j
  local source := '.\'
  local mOSP

  nameRef := 'F032.xml'
  nfile := source + nameRef

  dbcreate('_mo_f032', _f032)
  dbUseArea( .t.,, '_mo_f032', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF "ZAP" == Upper( oXmlNode:title )
        mOSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
        if lower( alltrim( mOSP ) ) == 'false'  // проверка на головной офис
          ( cAlias )->( dbAppend() )
          ( cAlias )->MCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
          ( cAlias )->NAMEMOK := mo_read_xml_stroke( oXmlNode, 'NAM_MOK', )
          ( cAlias )->NAMEMOP := mo_read_xml_stroke( oXmlNode, 'NAM_MOP', )
          ( cAlias )->ADDRESS := mo_read_xml_stroke( oXmlNode, 'JURADDRESS_ADDRESS', )
          ( cAlias )->YEAR := 2024
        endif
      ENDIF
    NEXT j
  endif

  ( cAlias )->( dbCloseArea() )
  RETURN

// строка даты для XML-файла
Function date2xml( mdate )
  return strzero( year( mdate ), 4 ) + '-' + ;
         strzero( month( mdate ), 2 ) + '-' + ;
         strzero( day( mdate ), 2 )

// пребразовать дату из "2002-02-01" в тип "DATE"
Function xml2date( s )
  return stod( charrem( '-', s ) )

// проверить наличие в XML-файле тэга и вернуть его значение
Function mo_read_xml_stroke( _node, _title, _aerr, _binding, _codepage )
  // _node - указатель на узел
  // _title - наименование тэга
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', oNode, yes_err := ( valtype( _aerr ) == 'A' ), ;
      s_msg := 'Отсутствует значение обязательного тэга "' + _title + '"'

  DEFAULT _binding TO .t., _aerr TO {}

  DEFAULT _codepage TO 'WIN1251'
  // ищем необходимый "_title" тэг в узле "_node"
  oNode := _node:Find( _title )
  if oNode == NIL .and. _binding .and. yes_err
    aadd( _aerr, s_msg )
  endif
  if oNode != NIL
    ret := mo_read_xml_tag( oNode, _aerr, _binding, _codepage )
  endif
  return ret

// вернуть значение тэга
Function mo_read_xml_tag( oNode, _aerr, _binding, _codepage )
  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  // _codepage - кодировка переданной строки
  Local ret := '', c, yes_err := ( valtype( _aerr ) == 'A' ), ;
    s_msg := 'Отсутствует значение обязательного тэга "' + oNode:title + '"'
  local codepage := upper( _codepage )

  if empty( oNode:aItems )
    if _binding .and. yes_err
      aadd( _aerr, s_msg )
  endif
  elseif ( c := valtype( oNode:aItems[ 1 ] ) ) == 'C'
    if codepage == 'WIN1251'
      ret := hb_AnsiToOem( alltrim( oNode:aItems[ 1 ] ) )
    elseif codepage == 'UTF8'
      ret := hb_Utf8ToStr( alltrim( oNode:aItems[ 1 ] ), 'RU866' )	
    endif
  elseif yes_err
    aadd( _aerr, 'Неверный тип данных у тэга "' + oNode:title + '": "' + c + '"' )
  endif
  return ret