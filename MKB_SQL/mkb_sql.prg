#include 'hbgtinfo.ch'
#include 'hbgtwvg.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'mkb_error.ch'

// #define TRACE

#require 'hbsqlit3'

// 12.12.25
Procedure Main( ... )

  Local cParam, cParamL
  Local aParams
  Local nameDB, db

  Local source, destination
  Local os_sep := hb_osPathSeparator()
  Local lCreateIfNotExist := .t.

  Request HB_CODEPAGE_UTF8
  Request HB_CODEPAGE_RU1251
  Request HB_LANG_RU866
  HB_CDPSELECT( 'UTF8' )
//  hb_cdpSelect( 'RU1251' )
//  HB_LANGSELECT('RU866')

//  REQUEST DBFNTX
//  RDDSETDEFAULT('DBFNTX')

  Set Date GERMAN
  Set Century On

  Announce HB_GTSYS
  Request HB_GT_WVT
  Request HB_GT_WVT_DEFAULT
// запретить закрытие окна (крестиком и по Alt+F4)
  hb_gtInfo( HB_GTI_CLOSABLE, .f. ) // для GT_WVT
// hb_gtInfo(HB_GTI_CLOSEMODE, 2 ) // для GT_WVG
// Определить сразу окно 25*80 символов, иначе нужна дополнительная настройка
  SetMode( 25, 80 )

  source := Upper( BeforAtNum( os_sep, ExeName() ) ) + os_sep
  destination := Upper( BeforAtNum( os_sep, ExeName() ) ) + os_sep

  aParams := hb_AParams()
  For Each cParam in aParams
    cParamL := Lower( cParam )
    Do Case
    Case cParamL == '-help' .or. cParamL == '--help'
      about()
      Return
    Case hb_LeftEq( cParamL, '-in=' )
      source := SubStr( cParam, 4 + 1 )
    Case hb_LeftEq( cParamL, '-out=' )
      destination := SubStr( cParam, 5 + 1 )
    Endcase
  Next

  If Right( source, 1 ) != os_sep
    source += os_sep
  Endif
  If Right( destination, 1 ) != os_sep
    destination += os_sep
  Endif

  If !( hb_vfDirExists( source ) )
    out_error( DIR_IN_NOT_EXIST, source )
    Quit
  Endi

  If !( hb_vfDirExists( destination ) )
    out_error( DIR_OUT_NOT_EXIST, destination )
    Quit
  Endi

  OutStd( hb_eol() + Hb_Translate( 'Версия библиотеки SQLite3 - ', 'RU1251', 'RU866'  ) + ;
    sqlite3_libversion() + hb_eol() + hb_eol() )

  nameDB := destination + 'mkb10.db'
  db := sqlite3_open( nameDB, lCreateIfNotExist )

  If ! Empty( db )
#ifdef TRACE
    sqlite3_profile( db, .t. ) // включим профайлер
    sqlite3_trace( db, .t. )   // включим трассировщик
#endif

    sqlite3_exec( db, 'PRAGMA auto_vacuum=0' )
    sqlite3_exec( db, 'PRAGMA page_size=4096' )

    make_mkb10K( db, source )
    make_mkb10( db, source )
    make_mkb10G( db, source )

      db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
      If ! Empty( db )
        If sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
          OutStd( hb_eol() + 'Pack - ok' + hb_eol() )
        Else
          out_error( PACK_ERROR, nameDB )
        Endif
      Endif

  end if
  return