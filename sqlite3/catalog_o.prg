#include "function.ch"

#require 'hbsqlit3'

/*
 * 11.07.2021
*/
PROCEDURE make_o001(db)

  LOCAL stmt
  LOCAL nI, nJ
  LOCAL aTable
  local k, j
  local ss1, d1, d2
  local table_sql := "CREATE TABLE o001( kod TEXT, name11 TEXT, name12 TEXT, alfa2 TEXT, alfa3 TEXT, datebeg TEXT, dateend TEXT )"

  sqlite3_exec( db, "DROP TABLE o001" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE o001 - Ok"
  ENDIF

  nfile := "O001.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  IF Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? 'Обработка файла O001.xml - Общероссийский классификатор стран мира (OKSM)'
    k := Len( oXmlDoc:aItems[1]:aItems )
    stmt := sqlite3_prepare( db, "INSERT INTO o001 ( kod, name11, name12, alfa2, alfa3, datebeg, dateend ) VALUES( :kod, :name11, :name12, :alfa2, :alfa3, :datebeg, :dateend )" )
    IF ! Empty( stmt )
      FOR j := 1 TO k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'KOD',)
          mArr := hb_ATokens( mo_read_xml_stroke(oXmlNode,"NAME11",), '^' )
          if len(mArr) == 1
            s_name11 := hb_StrToUTF8( mArr[1], 'RU1251')
            s_name12 := ''
          else
            s_name11 := hb_StrToUTF8( mArr[1], 'RU1251')
            s_name12 := hb_StrToUTF8( mArr[2], 'RU1251')
          endif
  
          s_alfa2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'ALFA2',), 'RU1251')
          s_alfa3 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'ALFA3',), 'RU1251')
          d1 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEBEG',) )
          d2 := hb_StrToUTF8( mo_read_xml_stroke(oXmlNode, 'DATEEND',) )
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name11 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_name12 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, s_alfa2 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, s_alfa3 ) == SQLITE_OK .AND. ;
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

    // aTable := sqlite3_get_table( db, "SELECT * FROM o001" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 6 ]
    // NEXT

  endif

  return

