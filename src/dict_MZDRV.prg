/// Справочники Минестерства здравоохранения РФ

#include "dict_error.ch"

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 10.02.22
function make_uslugi_mz(source, destination)
  local _uslugi_mz := {;
    {"ID",      "N",  5, 0},;  // Целочисленный, уникальный идентификатор, возможные значения ? целые числа от 1 до 6
    {"IDRB",    "C", 16, 0},;  // Строчный, уникальный код услуги согласно Приказу Минздравсоцразвития России от 27.12.2011 N 1664н ?Об утверждении номенклатуры медицинских услуг?,текстовый формат, обязательное поле
    {"RBNAME",  "C",255, 0},;  // Полное название , Строчный, текстовый формат, обязательное поле
    {"REL",     "N",  1, 0},;  // Признак актуальности , Целочисленный, числовой формат, один символ (если =1 ? запись актуальна, если 0 ? запись упразднена в соответствии с новыми нормативно-правовыми актами)
    {"DATEBEG", "D",  8, 0},;
    {"DATEEND", "D",  8, 0};
  }
  local mID, mS_code, mName, mRel, mDateOut
  local mDateBeg := 0d20110101
  local nfile, nameRef
  
  nameRef := "1.2.643.5.1.13.13.11.1070_2.10.xml"  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif
  dbcreate(destination + "_usl_mz", _uslugi_mz)
  use (destination + '_usl_mz') new alias MZUSL
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Номенклатура медицинских услуг" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)         
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            out_obrabotka_count(j1, k1)
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mS_code := mo_read_xml_stroke(oNode1, 'S_CODE', , , 'utf8')
            mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
            mRel := mo_read_xml_stroke(oNode1, 'REL', , , 'utf8')
            mDateOut := CToD(mo_read_xml_stroke(oNode1, 'DATEOUT', , , 'utf8')) //xml2date(mo_read_xml_stroke(oNode1,"DATEOUT",))
            select MZUSL
            append blank
            MZUSL->ID := val(mID)
            MZUSL->IDRB := mS_code
            MZUSL->RBNAME := mName
            MZUSL->REL := val(mRel)
            MZUSL->DATEBEG := mDateBeg
            MZUSL->DATEEND := mDateOut
          endif
        next j1
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return nil

***** 10.01.22
function make_severity(source, destination)

  local _mo_severity := {;
    {"ID",      "N",  5, 0},;  // Целочисленный, уникальный идентификатор, возможные значения ? целые числа от 1 до 6
    {"NAME",    "C", 40, 0},;  // Полное название, Строчный, обязательное поле, текстовый формат;
    {"SYN",     "C", 40, 0},;  // Синонимы, Строчный, синонимы терминов справочника, текстовый формат;
    {"SCTID",   "N", 10, 0},;  // Код SNOMED CT , Строчный, соответствующий код номенклатуры;
    {"SORT",    "N",  2, 0};  // Сортировка , Целочисленный, приведение данных к порядковой шкале для упорядочивания терминов справочника от более легкой к более тяжелой степени тяжести состояний, целое число от 1 до 7;
  }
  local nfile, nameRef

  nameRef := "1.2.643.5.1.13.13.11.1006_2.3.xml"  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif
  dbcreate(destination + "_mo_severity", _mo_severity)
  use (destination + '_mo_severity') new alias SEV
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Степень тяжести состояния пациента" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)         
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            out_obrabotka_count(j1, k1)
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
            mSYN := mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8')
            mSCTID := mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8')
            mSort := mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8')
            select SEV
            append blank
            SEV->ID := val(mID)
            SEV->NAME := mName
            SEV->SYN := mSYN
            SEV->SCTID := val(mSCTID)
            SEV->SORT := val(mSort)
          endif
        next j1
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL

***** 10.02.22
function make_implant(source, destination)

  local _mo_impl := {;
    {"ID",      "N",  5, 0},;  // Код , уникальный идентификатор записи
    {"RZN",     "N",  6, 0},;  // код изделия согласно Номенклатурному классификатору Росздравнадзора
    {"PARENT",  "N",  5, 0},;  // Код родительского элемента
    {"NAME",    "C", 120, 0},;  // Наименование , наименование вида изделия
    {"LOCAL",   "C",  80, 0},;  // Локализация , анатомическая область, к которой относится локализация и/или действие изделия
    {"MATERIAL","C",  20, 0},;  // Материал , тип материала, из которого изготовлено изделие
    {"METAL",   "L",   1, 0},;  // Металл , признак наличия металла в изделии
    {"ORDER",   "N",   4, 0},;  // Порядок сортировки
    {"TYPE",    "C",   1, 0};   // тип записи: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  }
  local fl_parent, rec_n, id_t
  local nfile, nameRef

  nameRef := "1.2.643.5.1.13.13.11.1079_2.3.xml"  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif
  dbcreate(destination + "_mo_impl", _mo_impl)
  use (destination + '_mo_impl') new alias IMPL
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)         
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            out_obrabotka_count(j1, k1)
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mRZN := mo_read_xml_stroke(oNode1, 'RZN', , , 'utf8')
            mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
            mName := mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8')
            mLocal := mo_read_xml_stroke(oNode1, 'LOCALIZATION', , , 'utf8')
            mMaterial := mo_read_xml_stroke(oNode1, 'MATERIAL', , , 'utf8')
            mMetal := mo_read_xml_stroke(oNode1, 'METAL', , , 'utf8')
            mOrder := mo_read_xml_stroke(oNode1, 'ORDER', , , 'utf8')
            select IMPL
            append blank
            IMPL->ID := val(mID)
            IMPL->RZN := val(mRZN)
            IMPL->PARENT := val(mParent)
            IMPL->NAME := mName
            IMPL->LOCAL := mLocal
            IMPL->MATERIAL := mMaterial
            IMPL->METAL := iif(upper(mMetal) == 'ДА', .t., .f.)
            IMPL->ORDER := val(mOrder)
            if val(mRZN) == 0
              IMPL->TYPE := 'O'
            endif
          endif
        next j1
      endif
    NEXT j
  ENDIF

  IMPL->(dbGoTop())
  do while ! IMPL->(eof())
    fl_parent := .f.
    if IMPL->RZN == 0
      IMPL->(dbSkip())
      continue
    endif

    rec_n := IMPL->(recno())
    id_t := IMPL->ID
    IMPL->(dbGoTop())
    do while ! IMPL->(eof())
      if IMPL->PARENT == id_t
        fl_parent := .t.
        exit
      endif
      IMPL->(dbSkip())
    enddo
    IMPL->(dbGoto(rec_n))
    if fl_parent
      IMPL->TYPE := 'U'
    else
      IMPL->TYPE := 'L'
    endif
    IMPL->(dbSkip())
  enddo
  out_obrabotka_eol()
  close databases
  return NIL

***** 10.02.22
Function make_method_inj(source, destination)
  local _mo_method_inj := {;
    {"ID",        "N",   3, 0},;  // уникальный идентификатор, обязательное поле, целое число
    {"NAME_RUS",  "C",  30, 0},;  // Путь введения на русском языке
    {"NAME_ENG",  "C",  30, 0},;  // Путь введения на английском языке
    {"PARENT",    "N",   3, 0},;  // родительский узел иерархического справочника, целое число
    {"TYPE",      "C",   1, 0};   // тип записи: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  }
  // {"CODE_EEC",  "C",  10, 0},;   // код справочника реестра НСИ ЕАЭК
  // {"CODE_EEC",  "C",  10, 0};   // код элемента справочника реестра НСИ ЕАЭК
  local nfile, nameRef

  nameRef := "1.2.643.5.1.13.13.11.1468_2.1.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif
  dbcreate(destination + "_mo_method_inj", _mo_method_inj)
  use (destination + '_mo_method_inj') new alias INJ
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Способы введения (MethIntro)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)         
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            out_obrabotka_count(j1, k1)
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mNameRus := mo_read_xml_stroke(oNode1, 'NAME_RUS', , , 'utf8')
            mNameEng := mo_read_xml_stroke(oNode1, 'NAME_ENG', , , 'utf8')
            mParent := mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8')
            select INJ
            append blank
            INJ->ID := val(mID)
            INJ->NAME_RUS := mNameRus
            INJ->NAME_ENG := mNameEng
            INJ->PARENT := val(mParent)
            if val(mParent) == 0
              INJ->TYPE := 'O'
            endif
          endif
        next j1
      endif
    NEXT j
  ENDIF

  INJ->(dbGoTop())
  do while ! INJ->(eof())
    fl_parent := .f.
    if INJ->PARENT == 0
      INJ->(dbSkip())
      continue
    endif

    rec_n := INJ->(recno())
    id_t := INJ->ID
    INJ->(dbGoTop())
    do while ! INJ->(eof())
      if INJ->PARENT == id_t
        fl_parent := .t.
        exit
      endif
      INJ->(dbSkip())
    enddo
    INJ->(dbGoto(rec_n))
    if fl_parent
      iNJ->TYPE := 'U'
    else
      iNJ->TYPE := 'L'
    endif
    INJ->(dbSkip())
  enddo
  out_obrabotka_eol()
  close databases
  return NIL

***** 10.02.22
Function make_ed_izm(source, destination)
  local _mo_ed_izm := {;
    {"ID",        "N",   3, 0},;  // Уникальный идентификатор единицы измерения лабораторного теста, целое число
    {"FULLNAME",  "C",  40, 0},;  // Полное наименование, Строчный
    {"SHOTNAME",  "C",  25, 0},;  // Краткое наименование, Строчный;
    {"PRNNAME",   "C",  25, 0},;  // Наименование для печати, Строчный;
    {"MEASUR",    "C",  45, 0},;  // Размерность, Строчный;
    {"UCUM",      "C",  15, 0},;  // Код UCUM, Строчный;
    {"COEF",      "C",  15, 0},;  // Коэффициент пересчета, Строчный, Коэффициент пересчета в рамках одной размерности.;
    {"CONV_ID",   "N",   3, 0},;  // Код единицы измерения для пересчета, Целочисленный, Код единицы измерения, в которую осуществляется пересчет.;
    {"CONV_NAM",  "C",  25, 0},;  // Единица измерения для пересчета, Строчный, Краткое наименование единицы измерения, в которую осуществляется пересчет.;
    {"OKEI_COD",  "N",   4, 0};    // Код ОКЕИ, Строчный, Соответствующий код Общероссийского классификатора единиц измерений.;
  }
  // {"NSI_EEC",  "C",  10, 0},;   // Код справочника ЕАЭК, Строчный, необязательное поле ? код справочника реестра НСИ ЕАЭК;
  // {"NSI_EL_EEC",  "C",  10, 0};   // Код элемента справочника ЕАЭК, Строчный, необязательное поле ? код элемента справочника реестра НСИ ЕАЭК;
  local rec_n, id_t, fl_parent := .f.
  local nfile, nameRef

  nameRef := "1.2.643.5.1.13.13.11.1358_3.3.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    CLOSE databases
    return nil
  endif
  dbcreate(destination + "_mo_ed_izm", _mo_ed_izm)
  use (destination + '_mo_ed_izm') new alias EDI
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + " - Единицы измерения (OID)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    CLOSE databases
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          if "ENTRY" == upper(oNode1:title)
            out_obrabotka_count(j1, k1)
            mID := mo_read_xml_stroke(oNode1, 'ID', , , 'utf8')
            mFullName := mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'utf8')
            mShortName := mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'utf8')
            mPrintName := mo_read_xml_stroke(oNode1, 'PRINTNAME', , , 'utf8')
            mMeasure := mo_read_xml_stroke(oNode1, 'MEASUREMENT', , , 'utf8')
            mUCUM := mo_read_xml_stroke(oNode1, 'UCUM', , , 'utf8')
            mCoef := mo_read_xml_stroke(oNode1, 'COEFFICIENT', , , 'utf8')
            mConvID := mo_read_xml_stroke(oNode1, 'CONVERSION_ID', , , 'utf8')
            mConvName := mo_read_xml_stroke(oNode1, 'CONVERSION_NAME', , , 'utf8')
            mOKEI := mo_read_xml_stroke(oNode1, 'OKEI_CODE', , , 'utf8')

            select EDI
            append blank
            EDI->ID := val(mID)
            EDI->FULLNAME := mFullName
            EDI->SHOTNAME := mShortName
            EDI->PRNNAME := mPrintName
            EDI->MEASUR := mMeasure
            EDI->UCUM := mUCUM
            EDI->COEF := mCoef
            EDI->CONV_ID := val(mConvID)
            EDI->CONV_NAM := mConvName
            EDI->OKEI_COD := val(mOKEI)
          endif
        next j1
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  close databases
  return NIL
