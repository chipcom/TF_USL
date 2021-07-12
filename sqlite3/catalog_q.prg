#include "function.ch"

#require 'hbsqlit3'

/*
 * 12.07.2021
*/
PROCEDURE make_q017(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE q017( id_ktest TEXT, nam_ktest TEXT, comment TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE q017" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE q017 - Ok"
  ENDIF

  nfile := "Q017.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла Q017.xml - Перечень категорий проверок ФЛК и МЭК (TEST_K)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO q017 ( id_ktest, nam_ktest, comment, datebeg, dateend ) VALUES( :id_ktest, :nam_ktest, :comment, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_id_ktest := mo_read_xml_stroke(oXmlNode, 'ID_KTEST',)
          s_nam_ktest := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'NAM_KTEST',), 'RU1251')
          s_comment :=  hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'COMMENT',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_id_ktest ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_nam_ktest ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_comment ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM q017" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 4 ]
    // NEXT

  endif

  return

/*
 * 12.07.2021
*/
PROCEDURE make_q016(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE q016( kod TEXT, name TEXT, nsi_obj TEXT, nsi_el TEXT, usl_test TEXT, val_el TEXT, comment TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE q016" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE q016 - Ok"
  ENDIF

  nfile := "Q016.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла Q016.xml - Перечень проверок автоматизированной поддержки МЭК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (MEK_MPF)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO q016 ( kod, name, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :kod, :name, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'ID_TEST',)
          s_name := mo_read_xml_stroke(oXmlNode, 'ID_EL',)
          s_nsi_obj := mo_read_xml_stroke(oXmlNode, 'NSI_OBJ',)
          s_nsi_el := mo_read_xml_stroke(oXmlNode, 'NSI_EL',)
          s_usl_test := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'USL_TEST',), 'RU1251')
          s_val_el := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'VAL_EL',), 'RU1251')
          s_comment :=  hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'COMMENT',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_nsi_obj ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_nsi_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, s_usl_test ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, s_val_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 7, s_comment ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM q016" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 7 ], 'RU866'), "-", aTable[ nI ][ 8 ]
    // NEXT

  endif

  return

/*
 * 11.07.2021
*/
PROCEDURE make_q015(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE q015( kod TEXT, name TEXT, nsi_obj TEXT, nsi_el TEXT, usl_test TEXT, val_el TEXT, comment TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE q015" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE q015 - Ok"
  ENDIF

  nfile := "Q015.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла Q015.xml - Перечень технологических правил реализации ФЛК в ИС ведения персонифицированного учета сведений об оказанной медицинской помощи (FLK_MPF)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO q015 ( kod, name, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :kod, :name, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'ID_TEST',)
          s_name := mo_read_xml_stroke(oXmlNode, 'ID_EL',)
          s_nsi_obj := mo_read_xml_stroke(oXmlNode, 'NSI_OBJ',)
          s_nsi_el := mo_read_xml_stroke(oXmlNode, 'NSI_EL',)
          s_usl_test := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'USL_TEST',), 'RU1251')
          s_val_el := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'VAL_EL',), 'RU1251')
          s_comment :=  hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'COMMENT',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_nsi_obj ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_nsi_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, s_usl_test ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 6, s_val_el ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 7, s_comment ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM q015" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 7 ], 'RU866'), "-", aTable[ nI ][ 8 ]
    // NEXT

  endif

  return

