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
    make_V0xx(db, source)

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    if ! Empty( db )
      if sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
        OutStd(hb_eol() + 'Pack - ok' + hb_eol())
      else
        out_error(PACK_ERROR, nameDB)
      endif
    endif
 
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

