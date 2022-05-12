// Справочники федерального фонда медицинского страхования РФ типа N0xx

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 12.05.22
function make_N0xx(db, source)

  // make_n001(db, source)
  // make_n002(db, source)
  // make_n003(db, source)
  // make_n004(db, source)
  // make_n005(db, source)
  // make_n006(db, source)
  // make_n007(db, source)
  // make_n008(db, source)
  // make_n009(db, source)
  // make_n010(db, source)
  // make_n011(db, source)
  make_n012(db, source)

  return nil

** 12.05.22
function make_n001(db, source)
  // ID_PrOt,    "N",  1, 0 // Идентификатор противопоказания или отказа
  // PrOt_NAME,  "C",250, 0 // Наименование противопоказания или отказа
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_prot, mProt_Name, d1, d2

  nameRef := 'N001.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор противопоказаний и отказов (OnkPrOt)' + hb_eol())

  cmdText := 'CREATE TABLE n001(id_prot INTEGER, prot_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n001(id_prot, prot_name, datebeg, dateend) VALUES( :id_prot, :prot_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_prot := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_PrOt')
          mProt_Name := read_xml_stroke_1251_to_utf8(oXmlNode, 'PrOt_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_prot)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mProt_Name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n002(db, source)
  // ID_St,      "N",  4, 0 // Идентификатор стадии
  // DS_St,      "C",  5, 0 // Диагноз по МКБ
  // KOD_St,     "C",  5, 0 // Стадия
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_st, mDS_St, mKod_st, d1, d2

  nameRef := 'N002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор стадий (OnkStad)' + hb_eol())
  cmdText := 'CREATE TABLE n002(id_st INTEGER, ds_st TEXT(5), kod_st TEXT(5), datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n002(id_st, ds_st, kod_st, datebeg, dateend) VALUES( :id_st, :ds_st, :kod_st, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_st := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_St')
          mDS_St := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_St')
          mKod_st := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_St')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_st)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_St) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mKod_St) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n003(db, source)
  // ID_T,       "N",  4, 0 // Идентификатор T
  // DS_T,       "C",  5, 0 // Диагноз по МКБ
  // KOD_T,      "C",  5, 0 // Обозначение T для диагноза
  // T_NAME,     "C", 250, 0 // Расшифровка T для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_T, mDS_T, mKod_T, mT_name, d1, d2

  nameRef := 'N003.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор Tumor (OnkT)' + hb_eol())
  cmdText := 'CREATE TABLE n003(id_t INTEGER, ds_t TEXT(5), kod_t TEXT(5), t_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n003(id_t, ds_t, kod_t, t_name, datebeg, dateend) VALUES( :id_t, :ds_t, :kod_t, :t_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_T')
          mDS_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_T')
          mKod_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_T')
          mT_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'T_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_t)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_t) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mKod_t) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mT_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n004(db, source)
  // ID_N,       "N",  4, 0 // Идентификатор N
  // DS_N,       "C",  5, 0 // Диагноз по МКБ
  // KOD_N,      "C",  5, 0 // Обозначение N для диагноза
  // N_NAME,     "C",500, 0 // Расшифровка N для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_N, mDS_N, mKod_N, mN_name, d1, d2

  nameRef := 'N004.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор Nodus (OnkN)' + hb_eol())
  cmdText := 'CREATE TABLE n004(id_n INTEGER, ds_n TEXT(5), kod_n TEXT(5), n_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n004(id_n, ds_n, kod_n, n_name, datebeg, dateend) VALUES( :id_n, :ds_n, :kod_n, :n_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_N')
          mDS_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_N')
          mKod_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_N')
          mN_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'N_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_n)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_n) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mKod_n) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mN_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n005(db, source)
  // ID_M,       "N",  4, 0 // Идентификатор M
  // DS_M,       "C",  5, 0 // Диагноз по МКБ
  // KOD_M,      "C",  5, 0 // Обозначение M для диагноза
  // M_NAME,     "C",250, 0 // Расшифровка M для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_M, mDS_M, mKod_M, mM_name, d1, d2

  nameRef := 'N005.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор Metastasis (OnkM)' + hb_eol())
  cmdText := 'CREATE TABLE n005(id_m INTEGER, ds_m TEXT(5), kod_m TEXT(5), m_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n005(id_m, ds_m, kod_m, m_name, datebeg, dateend) VALUES( :id_m, :ds_m, :kod_m, :m_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M')
          mDS_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_M')
          mKod_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_M')
          mM_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'M_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_m)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_m) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mKod_m) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mM_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n006(db, source)
  // ID_gr,      "N",  4, 0 // Идентификатор строки
  // DS_gr,      "C",  5, 0 // Диагноз по МКБ
  // ID_St,      "N",  4, 0 // Идентификатор стадии
  // ID_T,       "N",  4, 0 // Идентификатор T
  // ID_N,       "N",  4, 0 // Идентификатор N
  // ID_M,       "N",  4, 0 // Идентификатор M
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_gr, mDS_gr, mID_St, mID_T, mID_N, mID_M, d1, d2

  nameRef := 'N006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Справочник соответствия стадий TNM (OnkTNM)' + hb_eol())
  cmdText := 'CREATE TABLE n006(id_gr INTEGER, ds_gr TEXT(5), id_st INTEGER, id_t INTEGER, id_n INTEGER, id_m INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n006(id_gr, ds_gr, id_st, id_t, id_n, id_m, datebeg, dateend) VALUES( :id_gr, :ds_gr, :id_st, :id_t, :id_n, :id_m, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_gr := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_gr')
          mDS_gr := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_gr')
          mID_St := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_ST')
          mID_T := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_T')
          mID_N := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_N')
          mID_M := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_gr)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_gr) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mID_St)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 4, val(mID_T)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 5, val(mID_M)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 6, val(mID_N)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 7, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 8, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n007(db, source)
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака
  // Mrf_NAME,   "C",250, 0 // Наименование гистологического признака
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_Mrf, mMrf_name, d1, d2

  nameRef := 'N007.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор гистологических признаков (OnkMrf)' + hb_eol())
  cmdText := 'CREATE TABLE n007(id_mrf INTEGER, mrf_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n007(id_mrf, mrf_name, datebeg, dateend) VALUES( :id_mrf, :mrf_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          mMrf_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Mrf_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_mrf)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mMrf_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n008(db, source)
  // ID_R_M,     "N",  3, 0 // Идентификатор записи
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака в соответствии с N007
  // R_M_NAME,   "C",250, 0 // Наименование результата гистологического исследования
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_Mrf, mID_r_m, mR_M_name, d1, d2

  nameRef := 'N008.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор результатов гистологических исследований (OnkMrfRt)' + hb_eol())
  cmdText := 'CREATE TABLE n008(id_r_m INTEGER, id_mrf INTEGER, r_m_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n008(id_r_m, id_mrf, r_m_name, datebeg, dateend) VALUES( :id_r_m, :id_mrf, :r_m_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_r_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_R_M')
          mID_Mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          mR_m_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'R_M_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_r_m)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 2, val(mID_Mrf)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mR_M_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n009(db, source)
  // ID_M_D,     "N",  2, 0 // Идентификатор строки
  // DS_Mrf,     "C",  3, 0 // Диагноз по МКБ
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака в соответствии с N007
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_Mrf, mID_m_d, mDS_mrf, d1, d2

  nameRef := 'N009.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор соответствия гистологических признаков диагнозам (OnkMrtDS)' + hb_eol())
  cmdText := 'CREATE TABLE n009(id_m_d INTEGER, ds_mrf TEXT(3), id_mrf INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n009(id_m_d, ds_mrf, id_mrf, datebeg, dateend) VALUES( :id_m_d, :ds_mrf, :id_mrf, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_m_d := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M_D')
          mDS_mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_Mrf')
          mID_Mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_m_d)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_mrf) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mID_Mrf)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n010(db, source)
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера
  // KOD_Igh,    "C",250, 0 // Обозначение маркера
  // Igh_NAME,   "C",250, 0 // Наименование маркера
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_igh, mKOD_igh, mIgh_name, d1, d2

  nameRef := 'N010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор маркеров (OnkIgh)' + hb_eol())
  cmdText := 'CREATE TABLE n010(id_igh INTEGER, kod_igh TEXT, igh_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n010(id_igh, kod_igh, igh_name, datebeg, dateend) VALUES( :id_igh, :kod_igh, :igh_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          mKOD_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_Igh')
          mIgh_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Igh_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_igh)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mKOD_igh) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mIgh_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n011(db, source)
  // ID_R_I,     "N",  3, 0 // Идентификатор записи
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера в соответствии с N010
  // KOD_R_I,    "C",250, 0 // Обозначение результата
  // R_I_NAME,   "C",250, 0 // Наименование результата
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_R_I, mID_igh, mKOD_R_I, mR_I_name, d1, d2

  nameRef := 'N011.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор значений маркеров (OnkIghRt)' + hb_eol())
  cmdText := 'CREATE TABLE n011(id_r_i INTEGER, id_igh INTEGER, kod_r_i TEXT, r_i_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n011(id_r_i, id_igh, kod_r_i, r_i_name, datebeg, dateend) VALUES( :id_r_i, :id_igh, :kod_r_i, :r_i_name, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_R_I := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_R_I')
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          mKOD_r_i := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_R_I')
          mR_I_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'R_I_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_R_I)) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 2, val(mID_igh)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mKOD_r_i) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mR_I_name) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil

** 12.05.22
function make_n012(db, source)
  // ID_I_D,     "N",  2, 0 // Идентификатор строки
  // DS_Igh,     "C",  3, 0 // Диагноз по МКБ
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера в соответствии с N010
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID_I_D, mID_igh, mDS_Igh, d1, d2

  nameRef := 'N012.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор соответствия маркеров диагнозам (OnkIghDS)' + hb_eol())
  cmdText := 'CREATE TABLE n012(id_i_d INTEGER, ds_igh TEXT(3), id_igh INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO n012(id_i_d, ds_igh, id_igh, datebeg, dateend) VALUES( :id_i_d, :ds_igh, :id_igh, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_I_D := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_I_D')
          mDS_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_Igh')
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          if sqlite3_bind_int(stmt, 1, val(mID_I_D)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mDS_Igh) == SQLITE_OK .AND. ;
            sqlite3_bind_int(stmt, 3, val(mID_igh)) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  out_obrabotka_eol()
  return nil
