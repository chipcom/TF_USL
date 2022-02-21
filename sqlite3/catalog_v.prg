#include "dict_error.ch"
#include "function.ch"

#require 'hbsqlit3'

// static v_pom := { 'ст-р', 'дн.с', 'п-ка', 'вне МО' }

/*
 * 21.02.2022
*/
PROCEDURE make_v002(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v002( idpr INTEGER, prname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  nameRef := "v002.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  if check_izm_file(nameRef, nfile)
    return nil
  endif

  sqlite3_exec( db, "DROP TABLE v002" )
     
  OutStd( nameRef + " - Классификатор профилей оказанной медицинской помощи (ProfOt)" + hb_eol() )
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
    OutStd( "CREATE TABLE v002 - Ok" )
  ENDIF

  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v002 ( idpr, prname, datebeg, dateend ) VALUES( :idpr, :prname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idpr := mo_read_xml_stroke(oXmlNode, 'IDPR',)
          s_prname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'PRNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idpr ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_prname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(FILE_READ_ERROR, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    // OutStd( "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) ) )
    // OutStd( "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) ) )
    // OutStd( "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) ) )
    // OutStd( "" )

    // aTable := sqlite3_get_table( db, "SELECT * FROM v002" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v005(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v005( idpol INTEGER, polname TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v005" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v005 - Ok"
  ENDIF

  nfile := "v005.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v005.xml - Классификатор пола застрахованного (Pol)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v005 ( idpol, polname ) VALUES( :idpol, :polname )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idpol := mo_read_xml_stroke(oXmlNode, 'IDPOL',)
          s_polname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'POLNAME',), 'RU1251')
          if sqlite3_bind_int( stmt, 1, val( s_idpol ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_polname ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v005" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866')
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v006(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v006( idump INTEGER, umpname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v006" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v006 - Ok"
  ENDIF

  nfile := "v006.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v006.xml - Классификатор условий оказания медицинской помощи (UslMp)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v006 ( idump, umpname, datebeg, dateend ) VALUES( :idump, :umpname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idump := mo_read_xml_stroke(oXmlNode, 'IDUMP',)
          s_umpname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'UMPNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idump ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_umpname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v006" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v008(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v008( idvmp INTEGER, vmpname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v008" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v008 - Ok"
  ENDIF

  nfile := "v008.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v008.xml - Классификатор видов медицинской помощи (VidMp)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v008 ( idvmp, vmpname, datebeg, dateend ) VALUES( :idvmp, :vmpname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idvmp := mo_read_xml_stroke(oXmlNode, 'IDVMP',)
          s_vmpname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'VMPNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idvmp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_vmpname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v008" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v009(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v009( idrmp INTEGER, rmpname TEXT, dl_uslov INTEGER, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v009" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v009 - Ok"
  ENDIF

  nfile := "v009.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v009.xml - Классификатор результатов обращения за медицинской помощью (Rezult)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v009 ( idrmp, rmpname, dl_uslov, datebeg, dateend ) VALUES( :idrmp, :rmpname, :dl_uslov, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idrmp := mo_read_xml_stroke(oXmlNode, 'IDRMP',)
          v_dl_uslov := val( mo_read_xml_stroke(oXmlNode, 'DL_USLOV',) )
          // s_rmpname := s_idrmp + '/' + hb_StrToUTF8( v_pom[ v_dl_uslov ], 'RU866') + '/' + ;
          //   hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'RMPNAME',), 'RU1251')
          s_rmpname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'RMPNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idrmp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_rmpname ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 3, v_dl_uslov ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v009" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v010(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v010( idsp INTEGER, spname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v010" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v010 - Ok"
  ENDIF

  nfile := "v010.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v010.xml - Классификатор способов оплаты медицинской помощи (Sposob)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v010 ( idsp, spname, datebeg, dateend ) VALUES( :idsp, :spname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idsp := mo_read_xml_stroke(oXmlNode, 'IDSP',)
          s_spname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'SPNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idsp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_spname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v010" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_v012(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v012( idiz INTEGER, izname TEXT, dl_uslov INTEGER, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v012" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v012 - Ok"
  ENDIF

  nfile := "v012.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v012.xml - Классификатор исходов заболевания (Ishod)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v012 ( idiz, izname, dl_uslov, datebeg, dateend ) VALUES( :idiz, :izname, :dl_uslov, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idrmp := mo_read_xml_stroke(oXmlNode, 'IDIZ',)
          v_dl_uslov := val( mo_read_xml_stroke(oXmlNode, 'DL_USLOV',) )
          // s_rmpname := s_idrmp + '/' + hb_StrToUTF8( v_pom[ v_dl_uslov ], 'RU866') + '/' + ;
          //   hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IZNAME',), 'RU1251')
          s_izname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IZNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idrmp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_izname ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 3, v_dl_uslov ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v012" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v013(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v013( idkat INTEGER, katname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v013" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v013 - Ok"
  ENDIF

  nfile := "v013.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v013.xml - Классификатор категорий застрахованного лица (KategZL)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v013 ( idkat, katname, datebeg, dateend ) VALUES( :idkat, :katname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idkat := mo_read_xml_stroke(oXmlNode, 'IDKAT',)
          s_katname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'KATNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idkat ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_katname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v013" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v014(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v014( idfrmmp INTEGER, frmmpname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v014" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v014 - Ok"
  ENDIF

  nfile := "v014.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v014.xml - Классификатор форм оказания медицинской помощи (FRMMP)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v014 ( idfrmmp, frmmpname, datebeg, dateend ) VALUES( :idfrmmp, :frmmpname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idfrmmp := mo_read_xml_stroke(oXmlNode, 'IDFRMMP',)
          s_frmmpname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'FRMMPNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idfrmmp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_frmmpname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v014" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v015(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v015( recid INTEGER, code INTEGER, name TEXT, high INTEGER, okso INTEGER, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v015" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v015 - Ok"
  ENDIF

  nfile := "v015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v015.xml - Классификатор медицинских специальностей (Medspec)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v015 ( recid, code, name, high, okso, datebeg, dateend ) VALUES( :recid, :code, :name, :high, :okso, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_recid := mo_read_xml_stroke(oXmlNode, 'RECID',)
          s_code := mo_read_xml_stroke(oXmlNode, 'CODE',)
          s_name := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'NAME',), 'RU1251')
          s_high := mo_read_xml_stroke(oXmlNode, 'HIGH',)
          s_okso := mo_read_xml_stroke(oXmlNode, 'OKSO',)
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_recid ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 2, val( s_code ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 4, val( s_high ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 5, val( s_okso ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 7, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v015" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 3 ], 'RU866'), "-", aTable[ nI ][ 4 ], "-", aTable[ nI ][ 6 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v016(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v016( iddt TEXT, dtname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v016" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v016 - Ok"
  ENDIF

  nfile := "v016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v016.xml - Классификатор типов диспансеризации (DispT)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v016 ( iddt, dtname, datebeg, dateend ) VALUES( :iddt, :dtname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_iddt := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IDDT',), 'RU1251')
          s_dtname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DTNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_iddt ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_dtname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v016" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? hb_UTF8ToStr( aTable[ nI ][ 1 ], 'RU866'), "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v017(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v017( iddr INTEGER, drname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v017" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v017 - Ok"
  ENDIF

  nfile := "v017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v017.xml - Классификатор результатов диспансеризации (DispR)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v017 ( iddr, drname, datebeg, dateend ) VALUES( :iddr, :drname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_iddr := mo_read_xml_stroke(oXmlNode, 'IDDR',)
          s_drname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DRNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_iddr ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_drname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v017" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v018(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v018( idhvid TEXT, hvidname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v018" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v018 - Ok"
  ENDIF

  nfile := "v018.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v018.xml - Классификатор видов высокотехнологичной медицинской помощи (HVid)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v018 ( idhvid, hvidname, datebeg, dateend ) VALUES( :idhvid, :hvidname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idhvid := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IDHVID',), 'RU1251')
          s_hvidname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'HVIDNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_idhvid ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_hvidname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v018" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v019(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v019( idhm INTEGER, hmname TEXT, diag TEXT, hvid TEXT, hgr INTEGER, hmodp TEXT, idmodp INTEGER, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v019" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v019 - Ok"
  ENDIF

  nfile := "v019.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v019.xml - Классификатор методов высокотехнологичной медицинской помощи (HMet)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v019 ( idhm, hmname, diag, hvid, hgr, hmodp, idmodp, datebeg, dateend ) VALUES( :idhm, :hmname, :diag, :hvid, :hgr, :hmodp, :idmodp, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idhm := mo_read_xml_stroke(oXmlNode, 'IDHM',)
          s_hmname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'HMNAME',), 'RU1251')
          s_diag := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DIAG',), 'RU1251')
          s_hvid := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'HVID',), 'RU1251')
          s_hgr := mo_read_xml_stroke(oXmlNode, 'HGR',)
          s_hmodp := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'HMODP',), 'RU1251')
          s_idmodp := mo_read_xml_stroke(oXmlNode, 'IDMODP',)
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idhm ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_hmname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_diag ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_hvid ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 5, val( s_hgr ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, s_hmodp ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 7, val( s_idmodp ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 8, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 9, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v019" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 8 ], "-", aTable[ nI ][ 9 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v020(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v020( idk_pr INTEGER, k_prname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v020" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v020 - Ok"
  ENDIF

  nfile := "v020.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v020.xml - Классификатор профиля койки (KoPr)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v020 ( idk_pr, k_prname, datebeg, dateend ) VALUES( :idk_pr, :k_prname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idk_pr := mo_read_xml_stroke(oXmlNode, 'IDK_PR',)
          s_k_prname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'K_PRNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idk_pr ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_k_prname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v020" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v021(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v021( idspec INTEGER, specname TEXT, postname TEXT, idpost_mz TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v021" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v021 - Ok"
  ENDIF

  nfile := "v021.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v021.xml - Классификатор медицинских специальностей (должностей) (MedSpec)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v021 ( idspec, specname, postname, idpost_mz, datebeg, dateend ) VALUES( :idspec, :specname, :postname, :idpost_mz, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idspec := mo_read_xml_stroke(oXmlNode, 'IDSPEC',)
          s_specname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'SPECNAME',), 'RU1251')
          s_postname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'POSTNAME',), 'RU1251')
          s_idpost_mz := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IDPOST_MZ',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idspec ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_specname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_postname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_idpost_mz ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v021" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 5 ], "-", aTable[ nI ][ 6 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v022(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v022( idmpac INTEGER, mpacname TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v022" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v022 - Ok"
  ENDIF

  nfile := "v022.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v022.xml - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v022 ( idmpac, mpacname, datebeg, dateend ) VALUES( :idmpac, :mpacname, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idmpac := mo_read_xml_stroke(oXmlNode, 'IDMPAC',)
          s_mpacname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'MPACNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idmpac ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_mpacname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v022" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v023(db, source)
  local nfile, nameRef

  ? ''
  ? 'Обработка файла v023.xml - Классификатор клинико-статистических групп (KSG)'
  ? 'Формируется ФОМС.'
  ? ''

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v024(db, source)
  local nfile, nameRef

  ? ''
  ? 'Обработка файла v024.xml - Классификатор классификационных критериев (DopKr)'
  ? 'Формируется ФОМС.'
  ? ''

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v025(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v025( idpc TEXT, n_pc TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v025" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v025 - Ok"
  ENDIF

  nfile := "v025.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v025.xml - Классификатор целей посещения (KPC)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v025 ( idpc, n_pc, datebeg, dateend ) VALUES( :idpc, :n_pc, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idpc := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IDPC',), 'RU1251')
          s_n_pc := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'N_PC',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_idpc ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_n_pc ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v025" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v026(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v026( idump INTEGER, k_kpg TEXT, n_kpg TEXT, koef_z REAL, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v026" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v026 - Ok"
  ENDIF

  nfile := "v026.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v026.xml - Классификатор клинико-профильных групп (KPG)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v026 ( idump, k_kpg, n_kpg, koef_z, datebeg, dateend ) VALUES( :idump, :k_kpg, :n_kpg, :koef_z, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idump := mo_read_xml_stroke(oXmlNode, 'IDUMP',)
          s_k_kpg := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'K_KPG',), 'RU1251')
          s_n_kpg := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'N_KPG',), 'RU1251')
          s_koef_z := mo_read_xml_stroke(oXmlNode, 'KOEF_Z',)
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idump ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_k_kpg ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_n_kpg ) == SQLITE_OK .AND. ;
            sqlite3_bind_double( stmt, 4, val( s_koef_z ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v026" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 3 ], 'RU866'), "-", aTable[ nI ][ 4 ], "-", aTable[ nI ][ 5 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v027(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v027( idcz INTEGER, n_cz TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v027" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v027 - Ok"
  ENDIF

  nfile := "v027.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v027.xml - Классификатор характера заболевания (C_ZAB)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v027 ( idcz, n_cz, datebeg, dateend ) VALUES( :idcz, :n_cz, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idcz := mo_read_xml_stroke(oXmlNode, 'IDCZ',)
          s_n_cz := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'N_CZ',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idcz ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_n_cz ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v027" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v028(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v028( idvn INTEGER, n_vn TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v028" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v028 - Ok"
  ENDIF

  nfile := "v028.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v028.xml - Классификатор видов направления (NAPR_V)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v028 ( idvn, n_vn, datebeg, dateend ) VALUES( :idvn, :n_vn, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idvn := mo_read_xml_stroke(oXmlNode, 'IDVN',)
          s_n_vn := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'N_VN',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idvn ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_n_vn ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v028" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 13.07.2021
*/
PROCEDURE make_v029(db, source)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v029( idmet INTEGER, n_met TEXT, datebeg TEXT, dateend TEXT )"
  local nfile, nameRef

  sqlite3_exec( db, "DROP TABLE v029" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE v029 - Ok"
  ENDIF

  nfile := "v029.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла v029.xml - Классификатор методов диагностического исследования (MET_ISSL)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO v029 ( idmet, n_met, datebeg, dateend ) VALUES( :idmet, :n_met, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_idmet := mo_read_xml_stroke(oXmlNode, 'IDMET',)
          s_n_met := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'N_MET',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, val( s_idmet ) ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_n_met ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      NEXT j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM v029" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ], "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return
