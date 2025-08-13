// #include 'function.ch'
// #include 'hbgtwvg.ch'
#include 'hbgtinfo.ch'
#include 'directry.ch'
#include 'common.ch'
#include 'nsi_ffoms.ch'

#require 'hbsqlit3'

// #define TRACE

// 13.06.25
Procedure Main( ... )

  Local cParam, cParamL
  Local aParams

  Local nameDB
  Local db
  Local source
  Local destination
  Local download
  Local lExists
  local st

  Request HB_CODEPAGE_UTF8
  Request HB_CODEPAGE_RU1251
  Request HB_LANG_RU866
  HB_CDPSELECT('UTF8')
//  hb_cdpSelect( 'RU1251' )
//  HB_LANGSELECT('RU866')

//  REQUEST DBFNTX
//  RDDSETDEFAULT('DBFNTX')

  Set Date GERMAN
  Set Century On

//  Announce HB_GTSYS
//  Request HB_GT_WVT
//  Request HB_GT_WVT_DEFAULT
// запретить закрытие окна (крестиком и по Alt+F4)
//  hb_gtInfo( HB_GTI_CLOSABLE, .f. ) // для GT_WVT
// hb_gtInfo(HB_GTI_CLOSEMODE, 2 ) // для GT_WVG
// Определить сразу окно 25*80 символов, иначе нужна дополнительная настройка
//  SetMode( 25, 80 )

  source := dir_exe()
  destination := dir_exe()
  download := ''

  aParams := hb_AParams()
  For Each cParam in aParams
    cParamL := Lower( cParam )
    Do Case
    Case cParamL == '-help'
      about()
      Return
    Case hb_LeftEq( cParamL, '-in=' )
      source := SubStr( cParam, 4 + 1 )
    Case hb_LeftEq( cParamL, '-out=' )
      destination := SubStr( cParam, 5 + 1 )
    Case hb_LeftEq( cParamL, '-download=' )
      download := SubStr( cParam, 10 + 1 )
    Endcase
  Next

  If Right( source, 1 ) != hb_ps()
    source += hb_ps()
  Endif
  If Right( destination, 1 ) != hb_ps()
    destination += hb_ps()
  Endif
  if Empty( download )
    download := destination
  endif
  If Right( download, 1 ) != hb_ps()
    download += hb_ps()
  Endif

  If !( lExists := hb_vfDirExists( source ) )
    out_error( DIR_IN_NOT_EXIST, source )
    Quit
  Endi

  If ! ( lExists := hb_vfDirExists( destination ) )
    hb_vfDirMake( destination )
  Endi

  If ! ( lExists := hb_vfDirExists( download ) )
    hb_vfDirMake( download )
  Endi

  st := Hb_Translate( 'Версия библиотеки SQLite3 - ', 'RU1251', 'RU866'  )	

  OutStd( hb_eol() + st + sqlite3_libversion() + hb_eol() + hb_eol() )

  If sqlite3_libversion_number() < 3005001
    Return
  Endif

  if HB_ISNIL( db := init_db( destination ) )
    st := Hb_Translate( 'Ошибка создания/открытия файла БД', 'RU1251', 'RU866'  )	
    OutStd( hb_eol() + st + sqlite3_libversion() + hb_eol() + hb_eol() )
    return
  endif

  If ! Empty( db )
//#ifdef TRACE
//    sqlite3_profile( db, .t. ) // включим профайлер
//    sqlite3_trace( db, .t. )   // включим трассировщик
//#endif

    sqlite3_exec( db, 'PRAGMA auto_vacuum=0' )
    sqlite3_exec( db, 'PRAGMA page_size=4096' )

    checking_file( db, download )

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    If ! Empty( db )
      If sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
        OutStd( hb_eol() + 'Pack - ok' + hb_eol() )
      Else
        out_error( PACK_ERROR, nameDB )
      Endif
    Endif
  Endif
  Return
