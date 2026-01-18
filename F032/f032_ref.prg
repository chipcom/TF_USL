#include 'function.ch'
  
#include 'simpleio.ch'
#include 'dbinfo.ch'
  
REQUEST HB_CODEPAGE_RU1251, HB_CODEPAGE_RU866 
Request HB_CODEPAGE_UTF8
  
PROCEDURE Main() 
  
  local _f032 := { ;
    { 'UIDMO',    'C',  11, 0 }, ;
    { 'IDMO',     'C',  17, 0 }, ;
    { 'MCOD',     'C',   6, 0 }, ;
    { 'OSP',      'C',   1, 0 } ;
  }
//    { 'NAME_MOK', 'C',  50, 0 }, ;
//    { 'NAME_MOP', 'C', 150, 0 }  ;

  local _f033 := { ;
    { 'UIDSPMO',  'C',  17, 0 }, ;
    { 'IDSPMO',   'C',  17, 0 }, ;
    { 'NAM_SK',   'C',  50, 0 }, ;
    { 'NAM_SPMO', 'C', 150, 0 },  ;
    { 'OSP',      'C',   1, 0 } ;
  }

  local _m003 := { ;
    { 'ID',       'N',  3, 0 }, ;
    { 'PROFILE',  'C', 70, 0 } ;
  }

  local oXmlDoc, oXmlNode, oNode1
  local cAlias, nameRef, nfile, k, j, k1, j1
  local mMcod, mUIDSPMO, mOSP, mID, mProfile
  local source := '.\'

  cAlias := 'F032'
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
//        mOSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
        mMcod := mo_read_xml_stroke( oXmlNode, 'MCOD', )
        if SubStr( mMcod, 1, 2 ) == '34'  // 
          ( cAlias )->( dbAppend() )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->MCOD := mMcod // mo_read_xml_stroke( oXmlNode, 'MCOD', )
          ( cAlias )->OSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
//          ( cAlias )->NAMEMOK := mo_read_xml_stroke( oXmlNode, 'NAM_MOK', )
//          ( cAlias )->NAMEMOP := mo_read_xml_stroke( oXmlNode, 'NAM_MOP', )
        endif
      ENDIF
    NEXT j
  endif

  ( cAlias )->( dbCloseArea() )

  cAlias := 'F033'
  nameRef := 'F033.xml'
  nfile := source + nameRef

  dbcreate('_mo_f033', _f033)
  dbUseArea( .t.,, '_mo_f033', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF "ZAP" == Upper( oXmlNode:title )
        mUIDSPMO := mo_read_xml_stroke( oXmlNode, 'UIDSPMO', )
        mOSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
        if SubStr( mUIDSPMO, 1, 2 ) == '34' .and. mOSP == '0'
          ( cAlias )->( dbAppend() )
          ( cAlias )->UIDSPMO := mUIDSPMO
          ( cAlias )->IDSPMO := mo_read_xml_stroke( oXmlNode, 'IDSPMO', )
          ( cAlias )->OSP := mOSP
          ( cAlias )->NAM_SK := substr( mo_read_xml_stroke( oXmlNode, 'NAM_SK_SPMO', ), 1, 50 )
          ( cAlias )->NAM_SPMO := substr( mo_read_xml_stroke( oXmlNode, 'NAM_SPMO', ), 1, 150 )
        endif
      ENDIF
    NEXT j
  endif

  ( cAlias )->( dbCloseArea() )
/*
  HB_CDPSELECT('UTF8')

  cAlias := 'M003'
  nameRef := '1.2.643.5.1.13.13.11.1119.xml'
  nfile := source + nameRef

  dbcreate('_mo_m003', _m003)
  dbUseArea( .t.,, '_mo_m003', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ENTRIES' == Upper( oXmlNode:title )
         k1 := Len( oXmlNode:aItems )
         For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          IF 'ENTRY' == Upper( oNode1:title )
            mID := mo_read_xml_stroke( oNode1, 'ID', )
            mProfile := SubStr( mo_read_xml_stroke( oNode1, 'PROFILE', , , 'UTF8' ), 1, 70 )
            ( cAlias )->( dbAppend() )
            ( cAlias )->ID := Val( mID )
            ( cAlias )->PROFILE := mProfile
          ENDIF
        next j1
      endif
    NEXT j
  endif

  ( cAlias )->( dbCloseArea() )
*/
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