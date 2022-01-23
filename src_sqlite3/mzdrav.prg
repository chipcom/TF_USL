/// Справочники Минестерства здравоохранения РФ

#include 'function.ch'

#require 'hbsqlit3'

***** 23.01.22
Function make_ed_izm(db)
  LOCAL stmt
  local k, j, k1, j1
  local table_sql
  local oXmlNode, oNode1
  local mId, mFullName, mShortName
  // LOCAL nI, nJ
  // LOCAL aTable

  table_sql := "CREATE TABLE UnitOfMeasurement( id INTEGER, fullname TEXT(40), shortname TEXT(25) )"
  //   {"ID",        "N",   3, 0},;  // Уникальный идентификатор единицы измерения лабораторного теста, целое число
  //   {"FULLNAME",  "C",  40, 0},;  // Полное наименование, Строчный
  //   {"SHOTNAME",  "C",  25, 0},;  // Краткое наименование, Строчный;

  sqlite3_exec( db, "DROP TABLE UnitOfMeasurement" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE UnitOfMeasurement - Ok"
  ENDIF

  nfile := "1.2.643.5.1.13.13.11.1358_3.3.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? "1.2.643.5.1.13.13.11.1358_3.3.xml     - Единицы измерения (OID)"
    stmt := sqlite3_prepare( db, "INSERT INTO UnitOfMeasurement ( id, fullname, shortname ) VALUES( :id, :fullname, :shortname )" )
    if ! Empty( stmt )
      ? "Обработка файла " + nfile + " - "
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              @ row(), 52 say str(j1 / k1 * 100, 6, 2) + "%"
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mFullName := mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'utf8')
              mShortName := mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'utf8')

              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, hb_StrToUTF8(mFullName, 'UTF8') ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 3, hb_StrToUTF8(mShortName, 'UTF8') ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  ? 'Ошибка при загрузки строки - ', j
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    print_status_insert(db)

    // aTable := sqlite3_get_table( db, "SELECT * FROM o001" )
    // FOR nI := 1 TO Len( aTable )
    //   // FOR nJ := 1 TO Len( aTable[ nI ] )
    //   //   ?? aTable[ nI ][ nJ ], " "
    //   // NEXT
    //   ? aTable[ nI ][ 1 ], "-", hb_UTF8ToStr( aTable[ nI ][ 2 ], 'RU866'), "-", aTable[ nI ][ 6 ]
    // NEXT

  endif
  return nil

***** 04.01.22
function make_severity(db)
  LOCAL stmt
  local k, j, k1, j1
  local table_sql
  local oXmlNode, oNode1
  local mID, mName, mSYN, mSCTID, mSort

  table_sql := "CREATE TABLE Severity( id INTEGER, name TEXT(40) )"
  // table_sql := "CREATE TABLE Severity( id INTEGER, name TEXT(40), syn TEXT(40), sctid INTEGER, sort INTEGER )"
  // {"ID",      "N",  5, 0},;  // Целочисленный, уникальный идентификатор, возможные значения ? целые числа от 1 до 6
  // {"NAME",    "C", 40, 0},;  // Полное название, Строчный, обязательное поле, текстовый формат;
  // {"SYN",     "C", 40, 0},;  // Синонимы, Строчный, синонимы терминов справочника, текстовый формат;
  // {"SCTID",   "N", 10, 0},;  // Код SNOMED CT , Строчный, соответствующий код номенклатуры;
  // {"SORT",    "N",  2, 0};  // Сортировка , Целочисленный, приведение данных к порядковой шкале для упорядочивания терминов справочника от более легкой к более тяжелой степени тяжести состояний, целое число от 1 до 7;

  sqlite3_exec( db, "DROP TABLE Severity" )
     
  IF sqlite3_exec( db, table_sql ) == SQLITE_OK
     ? "CREATE TABLE Severity - Ok"
  ENDIF

  nfile := "1.2.643.5.1.13.13.11.1006_2.3.xml"
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    ? 'Ошибка в чтении файла', nfile
    wait 'Press any key'
  else
    ? "1.2.643.5.1.13.13.11.1006.xml - Степень тяжести состояния пациента"
    // stmt := sqlite3_prepare( db, "INSERT INTO Severity ( id, name, syn, sctid, sort ) VALUES( :id, :name, :syn, :sctid, :sort )" )
    stmt := sqlite3_prepare( db, "INSERT INTO Severity ( id, name ) VALUES( :id, :name )" )
    if ! Empty( stmt )
      ? "Обработка файла " + nfile + " - "
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              @ row(), 52 say str(j1 / k1 * 100, 6, 2) + "%"
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              // mSYN := mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8')
              // mSCTID := mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8')
              // mSort := mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8')
  
              if sqlite3_bind_text( stmt, 1, mID ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, hb_StrToUTF8(mName, 'UTF8') ) == SQLITE_OK  // .AND. ;
                      // sqlite3_bind_text( stmt, 3, hb_StrToUTF8(mSYN, 'UTF8') ) == SQLITE_OK .AND. ;
                      // sqlite3_bind_text( stmt, 4, mSCTID ) == SQLITE_OK .AND. ;
                      // sqlite3_bind_text( stmt, 5, mSort ) == SQLITE_OK
                if sqlite3_step( stmt ) != SQLITE_DONE
                  ? 'Ошибка при загрузки строки - ', j
                endif
              endif
              sqlite3_reset( stmt )
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )

    print_status_insert(db)

  endif
  return NIL

function print_status_insert(db)
  ? "Количество измененных строк базы данных: " + hb_ntos( sqlite3_changes( db ) )
  ? "Всего изменений: " + hb_ntos( sqlite3_total_changes( db ) )
  ? "Последний _ROWID_: " + Str( sqlite3_last_insert_rowid( db ) )
  ? ""
return nil