/// Справочники Минестерства здравоохранения РФ

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

function make_mzdrav( db, source )

  make_ed_izm( db, source)
  return nil

***** 22.04.22
Function make_ed_izm(db, source)
  local stmt
  local cmdText
  local table_sql
  local oXmlNode, oNode1
  local nfile, nameRef
  local k, j, k1, j1
  local mID, mFullName, mShortName, mPrintName, mMeasure, mUCUM, mCoef, mConvID
  local mConvName, mOKEI
  local cdp := HB_SETCODEPAGE()


  table_sql := 'CREATE TABLE UnitOfMeasurement( id INTEGER, fullname TEXT(40), ' + ;
    'shortname TEXT(25), prnname TEXT(25), measur TEXT(45), ucum TEXT(15), coef TEXT(15), ' + ;
    'conv_id INTEGER, conv_nam TEXT(25), okei_cod INTEGER )'
//   {"ID",        "N",   3, 0},;  // Уникальный идентификатор единицы измерения лабораторного теста, целое число
//   {"FULLNAME",  "C",  40, 0},;  // Полное наименование, Строчный
//   {"SHOTNAME",  "C",  25, 0},;  // Краткое наименование, Строчный;
//   {"PRNNAME",   "C",  25, 0},;  // Наименование для печати, Строчный;
//   {"MEASUR",    "C",  45, 0},;  // Размерность, Строчный;
//   {"UCUM",      "C",  15, 0},;  // Код UCUM, Строчный;
//   {"COEF",      "C",  15, 0},;  // Коэффициент пересчета, Строчный, Коэффициент пересчета в рамках одной размерности.;
//   {"CONV_ID",   "N",   3, 0},;  // Код единицы измерения для пересчета, Целочисленный, Код единицы измерения, в которую осуществляется пересчет.;
//   {"CONV_NAM",  "C",  25, 0},;  // Единица измерения для пересчета, Строчный, Краткое наименование единицы измерения, в которую осуществляется пересчет.;
//   {"OKEI_COD",  "N",   4, 0};    // Код ОКЕИ, Строчный, Соответствующий код Общероссийского классификатора единиц измерений.;
// // {"NSI_EEC",  "C",  10, 0},;   // Код справочника ЕАЭК, Строчный, необязательное поле ? код справочника реестра НСИ ЕАЭК;
// // {"NSI_EL_EEC",  "C",  10, 0};   // Код элемента справочника ЕАЭК, Строчный, необязательное поле ? код элемента справочника реестра НСИ ЕАЭК;

  sqlite3_exec( db, 'DROP TABLE UnitOfMeasurement' )
     
  if sqlite3_exec( db, table_sql ) == SQLITE_OK
     OutStd( hb_eol() + 'CREATE TABLE UnitOfMeasurement - Ok' + hb_eol() )
  endif

  nameRef := '1.2.643.5.1.13.13.11.1358.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - Единицы измерения (OID)' + hb_eol() )
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := 'INSERT INTO UnitOfMeasurement (id, fullname, shortname, prnname, ' + ;
      'measur, ucum, coef, conv_id, conv_nam, okei_cod) ' + ;
      'VALUES(:id, :fullname, :shortname, :prnname, :measur, :ucum, :coef, :conv_id, :conv_nam, :okei_cod)'
    stmt := sqlite3_prepare( db, cmdText )
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ENTRIES' == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if 'ENTRY' == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'UTF8')
              mFullName := mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'UTF8')
              mShortName := mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'UTF8')
              mPrintName := mo_read_xml_stroke(oNode1, 'PRINTNAME', , , 'utf8')
              mMeasure := mo_read_xml_stroke(oNode1, 'MEASUREMENT', , , 'utf8')
              mUCUM := mo_read_xml_stroke(oNode1, 'UCUM', , , 'utf8')
              mCoef := mo_read_xml_stroke(oNode1, 'COEFFICIENT', , , 'utf8')
              mConvID := mo_read_xml_stroke(oNode1, 'CONVERSION_ID', , , 'utf8')
              mConvName := mo_read_xml_stroke(oNode1, 'CONVERSION_NAME', , , 'utf8')
              mOKEI := mo_read_xml_stroke(oNode1, 'OKEI_CODE', , , 'utf8')
  
              if sqlite3_bind_int( stmt, 1, val(mID) ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 2, mFullName ) == SQLITE_OK .AND. ;
                      sqlite3_bind_text( stmt, 3, mShortName ) == SQLITE_OK .and. ;
                      sqlite3_bind_text( stmt, 4, mPrintName ) == SQLITE_OK .and. ;
                      sqlite3_bind_text( stmt, 5, mMeasure ) == SQLITE_OK .and. ;
                      sqlite3_bind_text( stmt, 6, mUCUM ) == SQLITE_OK .and. ;
                      sqlite3_bind_text( stmt, 7, mCoef ) == SQLITE_OK .and. ;
                      sqlite3_bind_int( stmt, 8, val(mConvID) ) == SQLITE_OK .and. ;
                      sqlite3_bind_text( stmt, 9, mConvName ) == SQLITE_OK .and. ;
                      sqlite3_bind_int( stmt, 10, val(mOKEI) ) == SQLITE_OK

                if sqlite3_step( stmt ) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
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

    // print_status_insert(db)
    out_obrabotka_eol()

  endif
  return nil

