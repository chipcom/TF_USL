#include 'hbgtinfo.ch'
#include 'hbgtwvg.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

// #define TRACE

// 28.03.23
procedure main( ... )
  local cParam, cParamL
  local aParams

  local destination
  local lExists
  local os_sep := hb_osPathSeparator()

  local lCreateIfNotExist := .t.
  local nameDB
  local lAll := .f.
  local lUpdate := .f.
  local cMask := '*.xml'
  local db
  local source

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866
//  HB_CDPSELECT('UTF8')
  HB_CDPSELECT('RU1251')
  // HB_LANGSELECT('RU866')
  
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
  // READINSERT(.T.)        // ����� �������������� �� ��������� Insert
  // KEYBOARD ''
  // ksetnum(.t.)
  // SETCURSOR(0)
  // SETCLEARB(' ')
  // SET COLOR TO
  
    Announce HB_GTSYS
    Request HB_GT_WVT
    Request HB_GT_WVT_DEFAULT
    // ��������� �������� ���� (��������� � �� Alt+F4)
    hb_gtInfo( HB_GTI_CLOSABLE, .f. ) // ��� GT_WVT
    // hb_gtInfo(HB_GTI_CLOSEMODE, 2 ) // ��� GT_WVG
    // ���������� ����� ���� 25*80 ��������, ����� ����� �������������� ���������
    SetMode( 25, 80 )
  
  source := upper(beforatnum(os_sep, exename())) + os_sep
  destination := upper(beforatnum(os_sep, exename())) + os_sep

  aParams := hb_AParams()
  for each cParam in aParams
    cParamL := Lower( cParam )
    do case
      case cParamL == '-help'
        About()
        return
      case cParamL == '-quiet'
        // ? 'quiet'
      case cParamL == '-all'
        // if HB_VFEXISTS(source + FILE_HASH)
        //   HB_VFERASE(source + FILE_HASH)
        // endif
        lAll := .t.
      case cParamL == '-update'
        lUpdate := .t.
      case hb_LeftEq( cParamL, '-in=' )
        source := SubStr( cParam, 4 + 1 )
      case hb_LeftEq( cParamL, '-out=' )
        destination := SubStr( cParam, 5 + 1 )
    endcase
  next

  if lAll .and. lUpdate
    out_error(INVALID_COMMAND_LINE)
    return
  endif

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

  OutStd(hb_eol() + '������ ���������� SQLite3 - ' + sqlite3_libversion() + hb_eol() + hb_eol())

  if sqlite3_libversion_number() < 3005001
    return
  endif

  nameDB := destination + 'chip_mo.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // ������� ���������
         sqlite3_trace(db, .t.)   // ������� ������������
    #endif

    sqlite3_exec(db, 'PRAGMA auto_vacuum=0')
    sqlite3_exec(db, 'PRAGMA page_size=4096')

    // make_mzdrav(db, source)
    // make_O0xx(db, source)
    // make_Q0xx(db, source)
    // make_F0xx(db, source)
    make_V0xx(db, source)
    // make_other(db, source)
    // make_N0xx(db, source)

    // if lAll // �������������� ��� �����
      // make_mzdrav(db, source)
      // make_Q0xx(db, source)
      // make_V0xx(db, source)
      // make_F0xx(db, source)
      // make_N0xx(db, source)
      // make_other(db, source)
    // endif

    // if lUpdate // �������������� ������ ����� �� ��������
    //   for each file in hb_vfDirectory( source + cMask, 'HSD' )
    //     name_table := clear_name_table(file[F_NAME])
    //     if name_table == '1.2.643.5.1.13.13.11.1468'
    //       cFunc := 'make_method_inj(db,source)'
    //     elseif name_table == '1.2.643.5.1.13.13.11.1079'
    //       cFunc := 'make_implant(db,source)'
    //     elseif name_table == '1.2.643.5.1.13.13.11.1070'
    //       cFunc := 'make_uslugi_mz(db,source)'
    //     elseif name_table == '1.2.643.5.1.13.13.11.1006'
    //       cFunc := 'make_severity(db,source)'
    //     elseif name_table == '1.2.643.5.1.13.13.11.1358'
    //       cFunc := 'make_ed_izm(db,source)'
    //     else
    //       cFunc := 'make_' + name_table + '(db,source)'
    //     endif
    //     &(cFunc)  // ������ ������� �����������
    //   next
    // endif

    if lAll .or. lUpdate
      db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
      if ! Empty( db )
        if sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
          OutStd(hb_eol() + 'Pack - ok' + hb_eol())
        else
          out_error(PACK_ERROR, nameDB)
        endif
      endif
    endif
  endif
  return