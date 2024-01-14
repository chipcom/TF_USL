// Справочники федерального фонда медицинского страхования РФ типа N0xx

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

static textBeginTrans := 'BEGIN TRANSACTION;'
static textCommitTrans := 'COMMIT;'

// 12.05.22
function make_N0xx(db, source)

//  make_n001(db, source)
//  make_n002(db, source)
//  make_n003(db, source)
//  make_n004(db, source)
//  make_n005(db, source)
//  make_n006(db, source)
//  make_n007(db, source)
//  make_n008(db, source)
//  make_n009(db, source)
//  make_n010(db, source)
//  make_n011(db, source)
//  make_n012(db, source)
//  make_n013(db, source)
//  make_n014(db, source)
//  make_n015(db, source)
//  make_n016(db, source)
//  make_n017(db, source)
//  make_n018(db, source)
//  make_n019(db, source)
//  make_n020(db, source)
  make_n021(db, source)

  return nil

// 31.08.23
function make_n001(db, source)
  // ID_PrOt,    "N",  1, 0 // Идентификатор противопоказания или отказа
  // PrOt_NAME,  "C",250, 0 // Наименование противопоказания или отказа
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_prot, mProt_Name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_prot := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_PrOt')
        mProt_Name := read_xml_stroke_1251_to_utf8(oXmlNode, 'PrOt_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n001(id_prot, prot_name, datebeg, dateend) VALUES(' ;
            + "" + mID_prot + "," ;
            + "'" + mProt_Name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n002(db, source)
  // ID_St,      "N",  4, 0 // Идентификатор стадии
  // DS_St,      "C",  5, 0 // Диагноз по МКБ
  // KOD_St,     "C",  5, 0 // Стадия
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_st, mDS_St, mKod_st, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n002(id_st, ds_st, kod_st, datebeg, dateend) VALUES(' ;
            + "" + mID_st + "," ;
            + "'" + mDS_St + "'," ;
            + "'" + mKod_St + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n003(db, source)
  // ID_T,       "N",  4, 0 // Идентификатор T
  // DS_T,       "C",  5, 0 // Диагноз по МКБ
  // KOD_T,      "C",  5, 0 // Обозначение T для диагноза
  // T_NAME,     "C", 250, 0 // Расшифровка T для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_T, mDS_T, mKod_T, mT_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n003(id_t, ds_t, kod_t, t_name, datebeg, dateend) VALUES(' ;
            + "" + mID_t + "," ;
            + "'" + mDS_t + "'," ;
            + "'" + mKod_t + "'," ;
            + "'" + mT_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n004(db, source)
  // ID_N,       "N",  4, 0 // Идентификатор N
  // DS_N,       "C",  5, 0 // Диагноз по МКБ
  // KOD_N,      "C",  5, 0 // Обозначение N для диагноза
  // N_NAME,     "C",500, 0 // Расшифровка N для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_N, mDS_N, mKod_N, mN_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n004(id_n, ds_n, kod_n, n_name, datebeg, dateend) VALUES(' ;
            + "" + mID_n + "," ;
            + "'" + mDS_n + "'," ;
            + "'" + mKod_n + "'," ;
            + "'" + mN_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n005(db, source)
  // ID_M,       "N",  4, 0 // Идентификатор M
  // DS_M,       "C",  5, 0 // Диагноз по МКБ
  // KOD_M,      "C",  5, 0 // Обозначение M для диагноза
  // M_NAME,     "C",250, 0 // Расшифровка M для диагноза
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_M, mDS_M, mKod_M, mM_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n005(id_m, ds_m, kod_m, m_name, datebeg, dateend) VALUES(' ;
            + "" + mID_m + "," ;
            + "'" + mDS_m + "'," ;
            + "'" + mKod_m + "'," ;
            + "'" + mM_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n006(db, source)
  // ID_gr,      "N",  4, 0 // Идентификатор строки
  // DS_gr,      "C",  5, 0 // Диагноз по МКБ
  // ID_St,      "N",  4, 0 // Идентификатор стадии
  // ID_T,       "N",  4, 0 // Идентификатор T
  // ID_N,       "N",  4, 0 // Идентификатор N
  // ID_M,       "N",  4, 0 // Идентификатор M
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_gr, mDS_gr, mID_St, mID_T, mID_N, mID_M, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n006(id_gr, ds_gr, id_st, id_t, id_n, id_m, datebeg, dateend) VALUES(' ;
            + "" + mID_gr + "," ;
            + "'" + mDS_gr + "'," ;
            + "" + mID_St + "," ;
            + "" + mID_T + "," ;
            + "" + mID_M + "," ;
            + "" + mID_N + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n007(db, source)
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака
  // Mrf_NAME,   "C",250, 0 // Наименование гистологического признака
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mMrf_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
        mMrf_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Mrf_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n007(id_mrf, mrf_name, datebeg, dateend) VALUES(' ;
            + "" + mID_mrf + "," ;
            + "'" + mMrf_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n008(db, source)
  // ID_R_M,     "N",  3, 0 // Идентификатор записи
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака в соответствии с N007
  // R_M_NAME,   "C",250, 0 // Наименование результата гистологического исследования
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mID_r_m, mR_M_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n008(id_r_m, id_mrf, r_m_name, datebeg, dateend) VALUES(' ;
            + "" + mID_r_m + "," ;
            + "" + mID_Mrf + "," ;
            + "'" + mR_M_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n009(db, source)
  // ID_M_D,     "N",  2, 0 // Идентификатор строки
  // DS_Mrf,     "C",  3, 0 // Диагноз по МКБ
  // ID_Mrf,     "N",  2, 0 // Идентификатор гистологического признака в соответствии с N007
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mID_m_d, mDS_mrf, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n009(id_m_d, ds_mrf, id_mrf, datebeg, dateend) VALUES(' ;
            + "" + mID_m_d + "," ;
            + "'" + mDS_Mrf + "'," ;
            + "" + mID_Mrf + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n010(db, source)
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера
  // KOD_Igh,    "C",250, 0 // Обозначение маркера
  // Igh_NAME,   "C",250, 0 // Наименование маркера
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_igh, mKOD_igh, mIgh_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n010(id_igh, kod_igh, igh_name, datebeg, dateend) VALUES(' ;
            + "" + mID_igh + "," ;
            + "'" + mKOD_igh + "'," ;
            + "'" + mIgh_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n011(db, source)
  // ID_R_I,     "N",  3, 0 // Идентификатор записи
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера в соответствии с N010
  // KOD_R_I,    "C",250, 0 // Обозначение результата
  // R_I_NAME,   "C",250, 0 // Наименование результата
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_R_I, mID_igh, mKOD_R_I, mR_I_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n011(id_r_i, id_igh, kod_r_i, r_i_name, datebeg, dateend) VALUES(' ;
            + "" + mID_R_I + "," ;
            + "" + mID_igh + "," ;
            + "'" + mKOD_r_i + "'," ;
            + "'" + mR_I_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n012(db, source)
  // ID_I_D,     "N",  2, 0 // Идентификатор строки
  // DS_Igh,     "C",  3, 0 // Диагноз по МКБ
  // ID_Igh,     "N",  2, 0 // Идентификатор маркера в соответствии с N010
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_I_D, mID_igh, mDS_Igh, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

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

        count++
        cmdTextInsert += 'INSERT INTO n012(id_i_d, ds_igh, id_igh, datebeg, dateend) VALUES(' ;
            + "" + mID_I_D + "," ;
            + "'" + mDS_Igh + "'," ;
            + "" + mID_igh + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n013(db, source)
  // ID_TLech,   "N",  1, 0 // Идентификатор типа лечения
  // TLech_NAME, "C",250, 0 // Наименование типа лечения
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlech, mTlech_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N013.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор типов лечения (OnkLech)' + hb_eol())
  cmdText := 'CREATE TABLE n013(id_tlech INTEGER, tlech_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_tlech := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Tlech')
        mTlech_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Tlech_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n013(id_tlech, tlech_name, datebeg, dateend) VALUES(' ;
            + "" + mID_tlech + "," ;
            + "'" + mTlech_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n014(db, source)
  // ID_THir,    "N",  1, 0 // Идентификатор типа хирургического лечения
  // THir_NAME,  "C",250, 0 // Наименование типа хирургического лечения
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_thir, mThir_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N014.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор типов хирургического лечения (OnkHir)' + hb_eol())
  cmdText := 'CREATE TABLE n014(id_thir INTEGER, thir_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_thir := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_THir')
        mThir_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'THir_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n014(id_thir, thir_name, datebeg, dateend) VALUES(' ;
            + "" + mID_thir + "," ;
            + "'" + mThir_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n015(db, source)
  // ID_TLek_L,  "N",  1, 0 // Идентификатор линии лекарственной терапии
  // TLek_NAME_L,"C",250, 0 // Наименование линии лекарственной терапии
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlek_l, mTlek_name_l, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор линий лекарственной терапии (OnkLek_L)' + hb_eol())
  cmdText := 'CREATE TABLE n015(id_tlek_l INTEGER, tlek_name_l TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_tlek_l := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLek_L')
        mTlek_name_l := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLek_NAME_L')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n015(id_tlek_l, tlek_name_l, datebeg, dateend) VALUES(' ;
            + "" + mID_tlek_l + "," ;
            + "'" + mTlek_name_l + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n016(db, source)
  // ID_TLek_V,  "N",  1, 0 // Идентификатор цикла лекарственной терапии
  // TLek_NAME_V,"C",250, 0 // Наименование цикла лекарственной терапии
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlek_v, mTlek_name_v, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор циклов лекарственной терапии (OnkLek_V)' + hb_eol())
  cmdText := 'CREATE TABLE n016(id_tlek_v INTEGER, tlek_name_v TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_tlek_v := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLek_V')
        mTlek_name_v := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLek_NAME_V')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n016(id_tlek_v, tlek_name_v, datebeg, dateend) VALUES(' ;
            + "" + mID_tlek_v + "," ;
            + "'" + mTlek_name_v + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n017(db, source)
  // ID_TLuch,  "N",  1, 0 // Идентификатор типа лучевой терапии
  // TLuch_NAME,"C",250, 0 // Наименование типа лучевой терапии
  // DATEBEG,    "D",  8, 0 // Дата начала действия записи
  // DATEEND,    "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tluch, mTluch_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор типов лучевой терапии (OnkLuch)' + hb_eol())
  cmdText := 'CREATE TABLE n017(id_tluch INTEGER, tluch_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_tluch := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLuch')
        mTluch_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLuch_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n017(id_tluch, tluch_name, datebeg, dateend) VALUES(' ;
            + "" + mID_tluch + "," ;
            + "'" + mTluch_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.06.23
function make_n018(db, source)
  // ID_REAS,   "N",  2, 0 // Идентификатор повода обращения
  // REAS_NAME, "C",300, 0 // Наименование повода обращения
  // DATEBEG,   "D",  8, 0 // Дата начала действия записи
  // DATEEND,   "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_reas, mReas_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N018.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор поводов обращения (OnkReas)' + hb_eol())
  cmdText := 'CREATE TABLE n018(id_reas INTEGER, reas_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_reas := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_REAS')
        mReas_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'REAS_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n018(id_reas, reas_name, datebeg, dateend) VALUES(' ;
            + "" + mID_reas + "," ;
            + "'" + mReas_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n019(db, source)
  // ID_CONS,   "N",  1, 0 // Идентификатор цели консилиума
  // CONS_NAME, "C",300, 0 // Наименование цели консилиума
  // DATEBEG,   "D",  8, 0 // Дата начала действия записи
  // DATEEND,   "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_cons, mCons_name, d1, d2
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N019.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор целей консилиума (OnkCons)' + hb_eol())
  cmdText := 'CREATE TABLE n019(id_cons INTEGER, cons_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_cons := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_CONS')
        mCons_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'CONS_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n019(id_cons, cons_name, datebeg, dateend) VALUES(' ;
            + "" + mID_cons + "," ;
            + "'" + mCons_name + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 27.09.23
function make_n020(db, source)
  // ID_LEKP,   "C",  6, 0 // Идентификатор лекарственного препарата
  // MNN,       "C",300, 0 // Международное непатентованное наименование лекарственного препарата (МНН)
  // DATEBEG,   "D",  8, 0 // Дата начала действия записи
  // DATEEND,   "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_lekp, mMNN, d1, d2, d1_1, d2_1
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N020.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор лекарственных препаратов, применяемых при проведении лекарственной терапии (OnkLekp)' + hb_eol())
  cmdText := 'CREATE TABLE n020(id_lekp TEXT(6), mnn TEXT, datebeg TEXT(19), dateend TEXT(19))'
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_lekp := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_LEKP')
        mMNN := read_xml_stroke_1251_to_utf8(oXmlNode, 'MNN')
        // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        // s := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := iif(empty(d1_1), '', hb_ValToStr(d1_1) + ' 00:00:00')
        d2 := iif(empty(d2_1), '2222-01-01 00:00:00', hb_ValToStr(d2_1) + ' 00:00:00')

        count++
        cmdTextInsert += 'INSERT INTO n020(id_lekp, mnn, datebeg, dateend) VALUES(' ;
            + "'" + mID_lekp + "'," ;
            + "'" + mMNN + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil

// 31.08.23
function make_n021(db, source)
  // ID_ZAP,    "N",  4, 0 // Идентификатор записи (в описании Char 15)
  // CODE_SH,   "C", 10, 0 // Код схемы лекарственной терапии
  // ID_LEKP,   "C",  6, 0 // Идентификатор лекарственного препарата, применяемого при проведении лекарственной противоопухолевой терапии. Заполняется в соответствии с N020
  // DATEBEG,   "D",  8, 0 // Дата начала действия записи
  // DATEEND,   "D",  8, 0 // Дата окончания действия записи
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_zap, mCode_sh, mID_lekp, d1, d2, d1_1, d2_1, s
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N021.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  OutStd(hb_eol() + nameRef + ' - Классификатор соответствия лекарственного препарата схеме лекарственной терапии (OnkLpsh)' + hb_eol())
  // cmdText := 'CREATE TABLE n021(id_zap INTEGER, code_sh TEXT(10), id_lekp TEXT(6), datebeg TEXT(10), dateend TEXT(10))'
  cmdText := 'CREATE TABLE n021(id_zap INTEGER, code_sh TEXT(10), id_lekp TEXT(6), datebeg TEXT(19), dateend TEXT(19))'
  // 2018-04-02 12:13:46
  if ! create_table(db, nameRef, cmdText)
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    out_obrabotka(nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mID_zap := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_ZAP')
        mCode_sh := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE_SH')
        mId_lekp := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_LEKP')
        // d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG') + ' 00:00:00'
        // d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND') + ' 00:00:00'

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        // s := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := iif(empty(d1_1), '', hb_ValToStr(d1_1) + ' 00:00:00')
        d2 := iif(empty(d2_1), '2222-01-01 00:00:00', hb_ValToStr(d2_1) + ' 00:00:00')


        count++
        cmdTextInsert += 'INSERT INTO n021(id_zap, code_sh, id_lekp, datebeg, dateend) VALUES(' ;
            + "" + mID_zap + "," ;
            + "'" + mCode_sh + "'," ;
            + "'" + mID_lekp + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
  endif
  out_obrabotka_eol()
  return nil
