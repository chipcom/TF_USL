#include "function.ch"

#require 'hbsqlit3'

// #define TRACE

/*
 * 12.07.2021
*/
procedure main()
  LOCAL lCreateIfNotExist := .T.
  LOCAL db := sqlite3_open( "chip_mo.s3db", lCreateIfNotExist )

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")
  
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

    // справочники группы F___
    make_f006( db )
    make_f010( db )
    make_f011( db )
    make_f014( db )
    // справочники группы O___
    make_o001( db )
    // справочники группы Q___
    make_q015( db )
    make_q016( db )
    make_q017( db )
    // справочники группы V___
    make_v002( db )
    make_v005( db )
    make_v006( db )
    make_v008( db )
    make_v009( db )
    make_v010( db )
    make_v012( db )
    make_v013( db )
    make_v014( db )
    make_v015( db )
    make_v016( db )
    make_v017( db )
    make_v018( db )
    make_v019( db )
    make_v020( db )
    make_v021( db )
    make_v022( db )
    make_v023( db )
    make_v024( db )
    make_v025( db )
    make_v026( db )
    make_v027( db )
    make_v028( db )
    make_v029( db )

  endif
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
Function mo_read_xml_stroke(_node,_title,_aerr,_binding)
  // _node - указатель на узел
  // _title - наименование тэга
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  Local ret := "", oNode, yes_err := (valtype(_aerr) == "A"),;
      s_msg := 'Отсутствует значение обязательного тэга "'+_title+'"'
  DEFAULT _binding TO .t., _aerr TO {}
  // ищем необходимый "_title" тэг в узле "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr,s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag1251(oNode,_aerr,_binding)
  endif
  return ret

***** вернуть значение тэга
Function mo_read_xml_tag1251(oNode,_aerr,_binding)
  // oNode - указатель на узел
  // _aerr - массив сообщений об ошибках
  // _binding - обязателен ли атрибут (по-умолчанию .T.)
  Local ret := "", c, yes_err := (valtype(_aerr) == "A"),;
      s_msg := 'Отсутствует значение обязательного тэга "'+oNode:title+'"'
  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr,s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == "C"
    // ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    ret := alltrim(oNode:aItems[1])
  elseif yes_err
    aadd(_aerr,'Неверный тип данных у тэга "'+oNode:title+'": "'+c+'"')
  endif
  return ret
