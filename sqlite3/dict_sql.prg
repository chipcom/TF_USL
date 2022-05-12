#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

// #define TRACE

** 07.05.2022
procedure main( ... )
  local cParam, cParamL
  local aParams

  local source
  local destination
  local lExists
  local os_sep := hb_osPathSeparator()

  local lCreateIfNotExist := .t.
  local nameDB
  local db

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866
  HB_CDPSELECT("UTF8")
  // HB_LANGSELECT("RU866")
  
  // REQUEST DBFNTX
  // RDDSETDEFAULT('DBFNTX')
  
  SET DATE GERMAN
  SET CENTURY ON
  
  // SET SCOREBOARD OFF
  // SET EXACT ON
  // SET WRAP ON
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

  OutStd(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol() + hb_eol())

  if sqlite3_libversion_number() < 3005001
    return
  endif

  nameDB := destination + 'chip_mo.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // включим профайлер
         sqlite3_trace(db, .t.)   // включим трассировщик
    #endif

    sqlite3_exec(db, "PRAGMA auto_vacuum=0")
    sqlite3_exec(db, "PRAGMA page_size=4096")

    // make_mzdrav(db, source)
    // make_Q0xx(db, source)
    // make_V0xx(db, source)
    // make_F0xx(db, source)
    // make_O0xx(db, source)
    make_N0xx(db, source)

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    if ! Empty( db )
      if sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
        OutStd(hb_eol() + 'Pack - ok' + hb_eol())
      else
        out_error(PACK_ERROR, nameDB)
      endif
    endif
  endif
  return

** 12.05.22
function clear_name_table(table)

  table := Lower(alltrim(table))
  return substr(table, 1, At('.', table) - 1)

** 12.05.22
function create_table(db, table, cmdText)
  // db - дескриптор SQL БД
  // table - имя таблицы вида name.xml
  // cmdText - строка команды SQL для создания таблицы SQL БД
  local ret := .f.
  
  table := clear_name_table(table)

  drop_table(db, table)
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE ' + table + ' - Ok' + hb_eol() )
    ret := .t.
  else
    OutStd('CREATE TABLE ' + table + ' - False' + hb_eol() )
  endif
  return ret

** 12.05.22
function drop_table(db, table)
  // db - дескриптор SQL БД
  // table - имя таблицы SQL БД
  local cmdText
  
  cmdText := 'DROP TABLE if EXISTS ' + table

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('DROP TABLE ' + table + ' - Ok' + hb_eol())
  endif
  return nil

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
   
** 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say "Обработка файла " + nfile + " -"
  return Col()

** 13.02.22
function out_obrabotka(nfile)

  OutStd( ;
    '===== Обработка файла ' + nfile )
  return nil

** 15.02.22
function out_create_file(nfile)

  OutStd( ;
    'Создание файла ' + nfile )
  return nil

** 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

** 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + "%" )
  return nil

