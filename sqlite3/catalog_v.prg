#include "function.ch"

#require 'hbsqlit3'

static v_pom := { 'ст-р', 'дн.с', 'п-ка', 'вне МО' }

/*
 * 12.07.2021
*/
PROCEDURE make_v012(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v012( idiz INTEGER, izname TEXT, dl_uslov INTEGER, datebeg TEXT, dateend TEXT )"

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
          s_rmpname := s_idrmp + '/' + hb_StrToUTF8( v_pom[ v_dl_uslov ], 'RU866') + '/' + ;
            hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'IZNAME',), 'RU1251')
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
 * 12.07.2021
*/
PROCEDURE make_v009(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE v009( idrmp INTEGER, rmpname TEXT, dl_uslov INTEGER, datebeg TEXT, dateend TEXT )"

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
          s_rmpname := s_idrmp + '/' + hb_StrToUTF8( v_pom[ v_dl_uslov ], 'RU866') + '/' + ;
            hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'RMPNAME',), 'RU1251')
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
