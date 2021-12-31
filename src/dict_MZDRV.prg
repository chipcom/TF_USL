/// Справочники Минестерства здравоохранения РФ

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

***** 31.12.21
function make_implant()

  local _mo_impl := {;
    {"ID",      "N",  5, 0},;  // Код , уникальный идентификатор записи
    {"RZN",     "N",  6, 0},;  // код изделия согласно Номенклатурному классификатору Росздравнадзора
    {"PARENT",  "N",  5, 0},;  // Код родительского элемента
    {"NAME",    "C", 120, 0},;  // Наименование , наименование вида изделия
    {"LOCAL",   "C",  80, 0},;  // Локализация , анатомическая область, к которой относится локализация и/или действие изделия
    {"MATERIAL","C",  20, 0},;  // Материал , тип материала, из которого изготовлено изделие
    {"METAL",   "L",   1, 0},;  // Металл , признак наличия металла в изделии
    {"ORDER",   "N",   4, 0};  // Порядок сортировки
  }

  dbcreate("_mo_impl", _mo_impl)
  use _mo_impl new alias IMPL
  nfile := "1.2.643.5.1.13.13.11.1079_2.2.xml"  // может меняться из-за версий
  oXmlDoc := HXMLDoc():Read(nfile)
  ? "1.2.643.5.1.13.13.11.1079.xml - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями"
  IF Empty( oXmlDoc:aItems )
    ? "Ошибка в чтении файла",nfile
    wait
  else
    ? "Обработка файла "+nfile+" - "
    k := Len( oXmlDoc:aItems[1]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          klll := upper(oNode1:title)
          if "ENTRY" == upper(oNode1:title)
            @ row(), 50 say str(j1 / k1 * 100, 6, 2) + "%"
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
          endif
        next j1
      endif
    NEXT j
  ENDIF
  close databases
  return NIL