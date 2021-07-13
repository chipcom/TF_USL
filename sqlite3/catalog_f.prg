#include "function.ch"

#require 'hbsqlit3'

/*
 * 11.07.2021
*/
PROCEDURE make_f006(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE f006( id INTEGER, name TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE f006" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE f006 - Ok"
  ENDIF

  nfile := "F006.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла F006.xml - Классификатор видов контроля (VidExp)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO f006 ( id, name, datebeg, dateend ) VALUES( :id, :name, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          v1 := val( mo_read_xml_stroke(oXmlNode, 'IDVID',) )
          ss1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'VIDNAME',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',), 'RU1251')
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',), 'RU1251')
          IF sqlite3_bind_int( stmt, 1, v1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, ss1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            // IF sqlite3_step( stmt ) == SQLITE_DONE
            //   ? v1, ' - ', j
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM f006" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   // ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 3 ]
    // NEXT

  endif

  return

/*
 * 11.07.2021
*/
PROCEDURE make_f010(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE f010( kod_tf TEXT, kod_okato TEXT, subname TEXT, okrug INTEGER, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE f010" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE f010 - Ok"
  ENDIF

  nfile := "F010.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла F010.xml - Классификатор субъектов Российской Федерации (Subekti)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO f010 ( kod_tf, kod_okato, subname, okrug, datebeg, dateend ) VALUES( :kod_tf, :kod_okato, :subname, :okrug, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_tf := mo_read_xml_stroke(oXmlNode, 'KOD_TF',)
          s_okato := mo_read_xml_stroke(oXmlNode, 'KOD_OKATO',)
          s_subname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'SUBNAME',), 'RU1251')
          v_okrug := val( mo_read_xml_stroke(oXmlNode, 'OKRUG',) )
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          // d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',), 'RU1251')
          // d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',), 'RU1251')
          if sqlite3_bind_text( stmt, 1, s_tf ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_okato ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_subname ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 4, v_okrug ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM f010" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 3 ], 'RU866'), "-", aTable[ nI ][ 5 ]
    // NEXT

  endif

  return

/*
 * 11.07.2021
*/
PROCEDURE make_f011(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE f011( iddoc INTEGER, docname TEXT, docser TEXT, docnum TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE f011" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE f011 - Ok"
  ENDIF

  nfile := "F011.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла F011.xml - Классификатор типов документов, удостоверяющих личность (Tipdoc)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO f011 ( iddoc, docname, docser, docnum, datebeg, dateend ) VALUES( :iddoc, :docname, :docser, :docnum, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          v_iddoc := val( mo_read_xml_stroke(oXmlNode, 'IDDOC',) )
          s_docname := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DOCNAME',), 'RU1251')
          s_docser := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DOCSER',), 'RU1251')
          s_docnum := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DOCNUM',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_int( stmt, 1, v_iddoc ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_docname ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_docser ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_docnum ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM f011" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 5 ]
    // NEXT

  endif

  return

/*
 * 11.07.2021
*/
PROCEDURE make_f014(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local table_sql := "CREATE TABLE f014( id INTEGER, name TEXT, opis TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE f014" )
     
  if sqlite3_exec( db, table_sql ) == SQLITE_OK
    ? "CREATE TABLE f014 - Ok"
  endif

  nfile := "F014.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла F014.xml - Классификатор причин отказа в оплате медицинской помощи (OplOtk)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO f014 ( id, name, opis, datebeg, dateend ) VALUES( :id, :name, :opis, :datebeg, :dateend )" )
    if ! Empty( stmt )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          v1 := val( mo_read_xml_stroke(oXmlNode, 'KOD',) )
          ss1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'KOMMENT',), 'RU1251')
          ss2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'NAIM',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',), 'RU1251')
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',), 'RU1251')
          if sqlite3_bind_int( stmt, 1, v1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, ss1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, ss2 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            if sqlite3_step( stmt ) != SQLITE_DONE
              ? 'Ошибка при загрузки строки - ', j
            endif
          endif
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
    ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
    ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
    ? ""

    // aTable := sqlite3_get_table( db, "SELECT * FROM f014" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", substr(hb_UTF8ToStr( aTable[ nI ][ 3 ], 'RU866'),1,60), "-", aTable[ nI ][ 4 ]
    // NEXT
  endif

  return