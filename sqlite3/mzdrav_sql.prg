/// Справочники Министерства здравоохранения РФ

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

***** 03.05.22
function make_mzdrav(db, source)

  make_method_inj(db, source)
  make_implant(db, source)
  make_ed_izm(db, source)
  make_severity(db, source)

  // make_uslugi_mz(db, source) // не используем (для будующего)

  return nil

***** 02.05.22
Function make_method_inj(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j, k1, j1
  local nfile, nameRef
  local oXmlNode, oNode1
  local mID, mNameRus, mNameEng, mParent, mType

  // 1) ID, Код, Целочисленный, уникальный идентификатор, обязательное поле, целое число;
  // 2) NAME_RUS, Путь введения на русском языке, Строчный, наименование пути введения лекарственных средств на русском языке, обязательное поле, текстовый формат;
  // 3) NAME_ENG, Путь введения на английском языке, Строчный, наименование пути введения лекарственных средств на английском языке, обязательное поле, текстовый формат;
  // 4) PARENT, Родительский узел, Целочисленный, родительский узел иерархического справочника, целое число;
  // // 5) NSI_CODE_EEC, Код справочника ЕАЭК, Строчный, необязательное поле – код справочника реестра НСИ ЕАЭК;
  // // 6) NSI_ELEMENT_CODE_EEC, Код элемента справочника ЕАЭК, Строчный, необязательное поле – код элемента справочника реестра НСИ ЕАЭК;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  cmdText := 'CREATE TABLE method_inj( id INTEGER, name_rus TEXT(30), name_eng TEXT(30), parent INTEGER, type TEXT(1) )'
    
  if sqlite3_exec(db, 'DROP TABLE method_inj') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE method_inj - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd( hb_eol() + 'CREATE TABLE method_inj - Ok' + hb_eol() )
  else
    OutStd( hb_eol() + 'CREATE TABLE method_inj - False' + hb_eol() )
    return nil
  endif

  // временная таблица для дальнейшего использования
  cmdTextTMP := 'CREATE TABLE tmp( id INTEGER, parent INTEGER)'
  sqlite3_exec(db, 'DROP TABLE tmp')
  sqlite3_exec(db, cmdTextTMP)
    
  nameRef := "1.2.643.5.1.13.13.11.1468.xml"
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Пути введения лекарственных препаратов, в том числе для льготного обеспечения граждан лекарственными средствами (MethIntro)" + hb_eol() )
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdTextTMP := 'INSERT INTO tmp(id, parent) VALUES (:id, :parent)'
    stmtTMP := sqlite3_prepare(db, cmdTextTMP)
    cmdText := 'INSERT INTO method_inj ( id, name_rus, name_eng, parent ) VALUES( :id, :name_rus, :name_eng, :parent )'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            klll := upper(oNode1:title)
            if "ENTRY" == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mNameRus := mo_read_xml_stroke(oNode1, 'NAME_RUS', , , 'utf8')
              mNameEng := mo_read_xml_stroke(oNode1, 'NAME_ENG', , , 'utf8')
              mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')

              if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
                sqlite3_bind_text(stmt, 2, mNameRus) == SQLITE_OK .AND. ;
                sqlite3_bind_text(stmt, 3, mNameEng) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmt, 4, val(mParent)) == SQLITE_OK

                if sqlite3_step(stmt) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset(stmt)
              if sqlite3_bind_int(stmtTMP, 1, val(mID)) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmtTMP, 2, val(mParent)) == SQLITE_OK
                if sqlite3_step(stmtTMP) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
                sqlite3_reset(stmtTMP)
              endif
            endif
          next j1
        endif
      next j
    endif
  endif

  sqlite3_clear_bindings(stmt)
  sqlite3_finalize(stmt)

  sqlite3_clear_bindings(stmtTMP)
  sqlite3_finalize(stmtTMP)

  cmdText := "UPDATE method_inj SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE method_inj.id = tmp.parent)"
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd(hb_eol() + cmdText + ' - Ok' + hb_eol())
  else
    OutErr(hb_eol() + cmdText + ' - False' + hb_eol())
  endif
  cmdText := "UPDATE method_inj SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE method_inj.id = tmp.parent)"
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd(hb_eol() + cmdText + ' - Ok' + hb_eol())
  else
    OutErr(hb_eol() + cmdText + ' - False' + hb_eol())
  endif
  sqlite3_exec(db, 'DROP TABLE tmp')

  return NIL

***** 02.05.22
function make_implant(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j, k1, j1
  local nfile, nameRef
  local oXmlNode, oNode1
  local mID, mName, mRZN, mParent, mType, mLocal, mMaterial, mOrder

  // 1)ID, Код , уникальный идентификатор записи;
  // 2)RZN, Росздравнадзор , код изделия согласно Номенклатурному классификатору Росздравнадзора;
  // 3)PARENT, Код родительского элемента;
  // 4)NAME, Наименование , наименование вида изделия;
  // // 5)LOCALIZATION, Локализация , анатомическая область, к которой относится локализация и/или действие изделия;
  // // 6)MATERIAL, Материал , тип материала, из которого изготовлено изделие;
  // // 7)METAL, Металл , признак наличия металла в изделии;
  // // 8)SCTID, Код SNOMED CT , уникальный код по номенклатуре клинических терминов SNOMED CT;
  // // 9)ORDER, Порядок сортировки ;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  cmdText := 'CREATE TABLE implantant( id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), local TEXT(80), material TEXT(20), _order INTEGER, type TEXT(1) )'
    
  if sqlite3_exec(db, 'DROP TABLE implantant') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE implantant - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd( hb_eol() + 'CREATE TABLE implantant - Ok' + hb_eol() )
  else
    OutStd( hb_eol() + 'CREATE TABLE implantant - False' + hb_eol() )
    return nil
  endif

  // временная таблица для дальнейшего использования
  cmdTextTMP := 'CREATE TABLE tmp( id INTEGER, parent INTEGER)'
  sqlite3_exec(db, 'DROP TABLE tmp')
  sqlite3_exec(db, cmdTextTMP)

  nameRef := '1.2.643.5.1.13.13.11.1079.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd(nameRef + ' - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями (OID)' + hb_eol())
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdTextTMP := 'INSERT INTO tmp(id, parent) VALUES (:id, :parent)'
    stmtTMP := sqlite3_prepare(db, cmdTextTMP)
    cmdText := 'INSERT INTO implantant ( id, rzn, parent, name, local, material, _order, type ) VALUES( :id, :rzn, :parent, :name, :local, :material, :_order, :type )'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len(oXmlDoc:aItems[1]:aItems)
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mRZN := mo_read_xml_stroke(oNode1, 'RZN', , , 'utf8')
              mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              mLocal := mo_read_xml_stroke(oNode1, 'LOCALIZATION', , , 'utf8')
              mMaterial := mo_read_xml_stroke(oNode1, 'MATERIAL', , , 'utf8')
              mOrder := mo_read_xml_stroke(oNode1, 'ORDER', , , 'utf8')
  
              if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 2, val(mRZN)) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 3, val(mParent)) == SQLITE_OK  .AND. ;
                      sqlite3_bind_text(stmt, 4, mName) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 5, mLocal) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 6, mMaterial) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 7, val(mOrder)) == SQLITE_OK
                if sqlite3_step(stmt) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset(stmt)
              if sqlite3_bind_int(stmtTMP, 1, val(mID)) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmtTMP, 2, val(mParent)) == SQLITE_OK
                if sqlite3_step(stmtTMP) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
                sqlite3_reset(stmtTMP)
              endif
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)

    sqlite3_clear_bindings(stmtTMP)
    sqlite3_finalize(stmtTMP)

    cmdText := "UPDATE implantant SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent)"
    if sqlite3_exec(db, cmdText) == SQLITE_OK
      OutStd(hb_eol() + cmdText + ' - Ok' + hb_eol())
    else
      OutErr(hb_eol() + cmdText + ' - False' + hb_eol())
    endif
    cmdText := "UPDATE implantant SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent)"
    if sqlite3_exec(db, cmdText) == SQLITE_OK
      OutStd(hb_eol() + cmdText + ' - Ok' + hb_eol())
    else
      OutErr(hb_eol() + cmdText + ' - False' + hb_eol())
    endif
    cmdText := 'UPDATE implantant SET type = "O" WHERE rzn = 0'
    if sqlite3_exec(db, cmdText) == SQLITE_OK
      OutStd(hb_eol() + cmdText + ' - Ok' + hb_eol())
    else
      OutErr(hb_eol() + cmdText + ' - False' + hb_eol())
    endif
    sqlite3_exec(db, 'DROP TABLE tmp')
  endif

  return nil

***** 02.05.22
function make_uslugi_mz(db, source)
  LOCAL stmt
  local cmdText
  local nfile, nameRef
  local k, j, k1, j1
  local oXmlNode, oNode1
  local mID, mS_code, mName, mRel, mDateOut

  // 1) ID, Уникальный идентификатор , Целочисленный, числовой формат, обязательное поле;
  // 2) S_CODE, Код услуги, Строчный, уникальный код услуги согласно Приказу Минздравсоцразвития России от 27.12.2011 N 1664н «Об утверждении номенклатуры медицинских услуг»,текстовый формат, обязательное поле;
  // 3) NAME, Полное название , Строчный, текстовый формат, обязательное поле;
  // 4) REL, Признак актуальности , Целочисленный, числовой формат, один символ (если =1 – запись актуальна, если 0 – запись упразднена в соответствии с новыми нормативно-правовыми актами);
  // 5) DATEOUT, Дата упразднения , Дата, дата, после которой данная запись упраздняется согласно новым приказам;
  cmdText := 'CREATE TABLE Mz_services( id INTEGER, s_code TEXT(16), name TEXT(2550), rel INTEGER,  dateout TEXT(10) )'

  if sqlite3_exec(db, 'DROP TABLE IF EXISTS Mz_services') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE Mz_services - Ok' + hb_eol())
  endif
    
  if sqlite3_exec(db, cmdText) == SQLITE_OK
     OutStd(hb_eol() + 'CREATE TABLE Mz_services - Ok' + hb_eol())
  else
     OutStd(hb_eol() + 'CREATE TABLE Mz_services - False' + hb_eol())
    return nil
  endif

  nameRef := "1.2.643.5.1.13.13.11.1070.xml"  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd(nameRef + ' - Номенклатура медицинских услуг (OID)' + hb_eol())
  if Empty(oXmlDoc:aItems)
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := 'INSERT INTO Mz_services ( id, s_code, name, rel, dateout ) VALUES( :id, :s_code, :name, :rel, :dateout )'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len(oXmlDoc:aItems[1]:aItems)
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mS_code := mo_read_xml_stroke(oNode1, 'S_CODE', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              mRel := mo_read_xml_stroke(oNode1, 'REL', , , 'utf8')
              mDateOut := CToD(mo_read_xml_stroke(oNode1, 'DATEOUT', , , 'utf8')) //xml2date(mo_read_xml_stroke(oNode1,"DATEOUT",))

              if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 2, mS_code) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 3, mName) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 4, val(mRel)) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 5, mDateOut) == SQLITE_OK
                if sqlite3_step(stmt) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset(stmt)
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  return nil

***** 02.05.22
function make_severity(db, source)
  LOCAL stmt
  local cmdText
  local nfile, nameRef
  local k, j, k1, j1
  local oXmlNode, oNode1
  local mID, mName, mSYN, mSCTID, mSort

  // 1) ID, Код , Целочисленный, уникальный идентификатор, возможные значения – целые числа от 1 до 6;
  // 2) NAME, Полное название, Строчный, обязательное поле, текстовый формат;
  // 3) SYN, Синонимы, Строчный, синонимы терминов справочника, текстовый формат;
  // 4) SCTID, Код SNOMED CT , Строчный, соответствующий код номенклатуры;
  // 5) SORT, Сортировка , Целочисленный, приведение данных к порядковой шкале для упорядочивания терминов
  //    справочника от более легкой к более тяжелой степени тяжести состояний, целое число от 1 до 7;
  cmdText := 'CREATE TABLE Severity( id INTEGER, name TEXT(40), syn TEXT(50), sctid TEXT(10), sort INTEGER )'
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS Severity') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE Severity - Ok' + hb_eol())
  endif
    
  if sqlite3_exec(db, cmdText) == SQLITE_OK
     OutStd(hb_eol() + 'CREATE TABLE Severity - Ok' + hb_eol())
  else
     OutStd(hb_eol() + 'CREATE TABLE Severity - False' + hb_eol())
    return nil
  endif

  nameRef := '1.2.643.5.1.13.13.11.1006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd(nameRef + ' - Степень тяжести состояния пациента (OID)' + hb_eol())
  if Empty(oXmlDoc:aItems)
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := 'INSERT INTO Severity ( id, name, syn, sctid, sort ) VALUES( :id, :name, :syn, :sctid, :sort )'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len(oXmlDoc:aItems[1]:aItems)
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
              mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
              mSYN := mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8')
              mSCTID := mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8')
              mSort := mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8')
  
              if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 2, mName) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 3, mSYN) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 4, mSCTID) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 5, val(mSort)) == SQLITE_OK
                if sqlite3_step(stmt) != SQLITE_DONE
                  out_error(TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset(stmt)
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  return nil

***** 02.05.22
Function make_ed_izm(db, source)
  local stmt
  local cmdText
  local oXmlNode, oNode1
  local nfile, nameRef
  local k, j, k1, j1
  local mID, mFullName, mShortName, mPrintName, mMeasure, mUCUM, mCoef, mConvID
  local mConvName, mOKEI

  // 1) ID, Уникальный идентификатор, Целочисленный, Уникальный идентификатор единицы измерения лабораторного теста;
  // 2) FULLNAME, Полное наименование, Строчный;
  // 3) SHORTNAME, Краткое наименование, Строчный;
  // 4) PRINTNAME, Наименование для печати, Строчный;
  // 5) MEASUREMENT, Размерность, Строчный;
  // 6) UCUM, Код UCUM, Строчный;
  // 7) COEFFICIENT, Коэффициент пересчета, Строчный, Коэффициент пересчета в рамках одной размерности.;
  // 8) FORMULA, Формула пересчета, Строчный, В настоящей версии справочника не используется.;
  // 9) CONVERSION_ID, Код единицы измерения для пересчета, Целочисленный, Код единицы измерения, в которую осуществляется пересчет.;
  // 10) CONVERSION_NAME, Единица измерения для пересчета, Строчный, Краткое наименование единицы измерения, в которую осуществляется пересчет.;
  // 11) OKEI_CODE, Код ОКЕИ, Строчный, Соответствующий код Общероссийского классификатора единиц измерений.;
  // // 12) NSI_CODE_EEC, Код справочника ЕАЭК, Строчный, необязательное поле – код справочника реестра НСИ ЕАЭК;
  // // 13) NSI_ELEMENT_CODE_EEC, Код элемента справочника ЕАЭК, Строчный, необязательное поле – код элемента справочника реестра НСИ ЕАЭК;
  cmdText := 'CREATE TABLE UnitOfMeasurement( id INTEGER, fullname TEXT(40), ' + ;
    'shortname TEXT(25), prnname TEXT(25), measur TEXT(45), ucum TEXT(15), coef TEXT(15), ' + ;
    'conv_id INTEGER, conv_nam TEXT(25), okei_cod INTEGER )'
    
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS UnitOfMeasurement') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE UnitOfMeasurement - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd( hb_eol() + 'CREATE TABLE UnitOfMeasurement - Ok' + hb_eol() )
  else
    OutStd( hb_eol() + 'CREATE TABLE UnitOfMeasurement - False' + hb_eol() )
    return nil
  endif

  nameRef := '1.2.643.5.1.13.13.11.1358.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
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
    stmt := sqlite3_prepare(db, cmdText)
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
    out_obrabotka_eol()
  endif
  return nil

