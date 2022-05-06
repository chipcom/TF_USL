// ����������� ������������ ����� ������������ ����������� �� ���� Q0xx

#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

***** 05.05.22
function make_Q0xx(db, source)

  make_q015(db, source)
  // make_q016(db, source)
  // make_q017(db, source)

  return nil

** 05.05.22
function make_q015(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2

  // ID_TEST, ��������(12), ������������� ��������.
  //      ����������� �� ������� KKKK.00.TTTT, ���
  //      KKKK - ������������� ��������� �������� 
  //        � ������������ � ��������������� Q017,
  //      TTTT - ���������� ����� �������� � ���������
  // ID_EL, ��������(100),	������������� ��������, 
  //      ����������� �������� (���������� �, ������������� Q018)
  // TYPE_MD	��	���������� ���� ������������ ������, ���������� 
  //      �������, ���������� ��������
  // TYPE_D, ��������(2),	��� ������������ ������, ���������� �������,
  //      ���������� �������� (���������� �, ������������� Q019)
  // NSI_OBJ, ��������(4), ��� ������� ���, �� ������������ � ������� 
  //      �������������� �������� �������� ��������
  // NSI_EL, ��������(20), ��� �������� ������� ���, �� ������������ � 
  //      ������� �������������� �������� �������� ��������
  // USL_TEST, ��������(254),	������� ���������� �������� ��������
  // VAL_EL, ��������(254),	��������� ���������� �������� ��������
  // MIN_LEN, �������������(4),	����������� ����� �������� ��������
  // MAX_LEN, �������������(4),	������������ ����� �������� ��������
  // MASK_VAL, ��������(254),	����� �������� ��������
  // COMMENT, ��������(500), �����������
  // DATEBEG, ��������(10),	���� ������ �������� ������
  // DATEEND, ��������(10),	���� ��������� �������� ������
  cmdText := 'CREATE TABLE q015( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT(4), nsi_el TEXT(20), usl_test TEXT, val_el TEXT, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'Q015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  else
    OutStd(hb_eol() + nameRef + ' - �������� ��������������� ������ ���������� ��� � �� ������� �������������������� ����� �������� �� ��������� ����������� ������ (FLK_MPF)' + hb_eol())
  endif
  
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q015') == SQLITE_OK
    OutStd('DROP TABLE q015 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE q015 - Ok' + hb_eol() )
  else
    OutStd('CREATE TABLE q015 - False' + hb_eol() )
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q015 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'ID_TEST', , , 'ru1251')
          s_name := mo_read_xml_stroke(oXmlNode, 'ID_EL', , , 'ru1251')
          s_nsi_obj := mo_read_xml_stroke(oXmlNode, 'NSI_OBJ', , , 'ru1251')
          s_nsi_el := mo_read_xml_stroke(oXmlNode, 'NSI_EL', , , 'ru1251')
          s_usl_test := mo_read_xml_stroke(oXmlNode, 'USL_TEST', , , 'ru1251')
          s_val_el := mo_read_xml_stroke(oXmlNode, 'VAL_EL', , , 'ru1251')
          s_comment :=  mo_read_xml_stroke(oXmlNode, 'COMMENT', , , 'ru1251')
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
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
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif

  return nil

** 05.05.22
function make_q016(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlNode, oNode1
  local s_kod, s_name, s_nsi_obj, s_nsi_el, s_usl_test, s_val_el, s_comment, d1, d2

  // ID_TEST, ��������(12),	������������� ��������. 
  //      ����������� �� ������� KKKK.RR.TTTT, ���
  //      KKKK - ������������� ��������� �������� 
  //        � ������������ � ��������������� Q017,
  //      RR ��� ����� � ������������ � ��������������� F010.
  //        ��� �������� ������������ ������ RR ��������� �������� 00.
  //      TTTT - ���������� ����� �������� � ���������
  // ID_EL, ��������(100),	������������� ��������, 
  //      ����������� �������� (���������� �, ������������� Q018)
  
  // DESC_TEST, ��������(500),	�������� ��������
  // TYPE_MD	��	���������� ���� ������������ ������, ���������� 
  //      �������, ���������� ��������
  // TYPE_D, ��������(2),	��� ������������ ������, ���������� �������,
  //      ���������� �������� (���������� �, ������������� Q019)
  // NSI_OBJ, ��������(4), ��� ������� ���, �� ������������ � ������� 
  //      �������������� �������� �������� ��������
  // NSI_EL, ��������(20), ��� �������� ������� ���, �� ������������ � 
  //      ������� �������������� �������� �������� ��������
  // USL_TEST, ��������(254),	������� ���������� �������� ��������
  // VAL_EL, ��������(254),	��������� ���������� �������� ��������
  // COMMENT, ��������(500), �����������
  // DATEBEG, ��������(10),	���� ������ �������� ������
  // DATEEND, ��������(10),	���� ��������� �������� ������
  
  cmdText := 'CREATE TABLE q016( id_test TEXT(12), id_el TEXT(100), nsi_obj TEXT, nsi_el TEXT, usl_test BLOB, val_el BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q016') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE q016 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd( hb_eol() + 'CREATE TABLE q016 - Ok' + hb_eol() )
  else
    OutStd( hb_eol() + 'CREATE TABLE q016 - False' + hb_eol() )
    return nil
  endif

  nameRef := 'Q016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �������� �������� ������������������ ��������� ��� � �� ������� �������������������� ����� �������� �� ��������� ����������� ������ (MEK_MPF)' + hb_eol() )
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q016 ( id_test, id_el, nsi_obj, nsi_el, usl_test, val_el, comment, datebeg, dateend ) VALUES( :id_test, :id_el, :nsi_obj, :nsi_el, :usl_test, :val_el, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'ID_TEST',)
          s_name := mo_read_xml_stroke(oXmlNode, 'ID_EL',)
          s_nsi_obj := mo_read_xml_stroke(oXmlNode, 'NSI_OBJ',)
          s_nsi_el := mo_read_xml_stroke(oXmlNode, 'NSI_EL',)
          s_usl_test := mo_read_xml_stroke(oXmlNode, 'USL_TEST',)
          s_val_el := mo_read_xml_stroke(oXmlNode, 'VAL_EL',)
          s_comment := mo_read_xml_stroke(oXmlNode, 'COMMENT',)
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
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
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  return nil

** 05.05.22
function make_q017(db, source)
  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlNode, oNode1
  local s_kod, s_name, s_comment, d1, d2

  // ID_KTEST, ��������(4),	������������� ��������� ��������
  // NAM_KTEST, ��������(400),	������������ ��������� ��������
  // COMMENT, ��������(500), �����������
  // DATEBEG, ��������(10),	���� ������ �������� ������
  // DATEEND, ��������(10),	���� ��������� �������� ������
  
  cmdText := 'CREATE TABLE q017( id_ktest TEXT(4), nam_ktest BLOB, comment BLOB, datebeg TEXT(10), dateend TEXT(10) )'
    
  if sqlite3_exec(db, 'DROP TABLE IF EXISTS q017') == SQLITE_OK
    OutStd(hb_eol() + 'DROP TABLE q017 - Ok' + hb_eol())
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd( hb_eol() + 'CREATE TABLE q017 - Ok' + hb_eol() )
  else
    OutStd( hb_eol() + 'CREATE TABLE q017 - False' + hb_eol() )
    return nil
  endif

  nameRef := 'Q017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  
  oXmlDoc := HXMLDoc():Read(nfile)
  OutStd( nameRef + ' - �������� ��������� �������� ��� � ��� (TEST_K)' + hb_eol() )
  if Empty( oXmlDoc:aItems )
    out_error(FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := "INSERT INTO q017 ( id_ktest, nam_ktest, comment, datebeg, dateend ) VALUES( :id_ktest, :nam_ktest, :comment, :datebeg, :dateend )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          s_kod := mo_read_xml_stroke(oXmlNode, 'ID_KTEST',)
          s_name := mo_read_xml_stroke(oXmlNode, 'NAM_KTEST',)
          s_comment := mo_read_xml_stroke(oXmlNode, 'COMMENT',)
          d1 := mo_read_xml_stroke(oXmlNode, 'DATEBEG',)
          d2 := mo_read_xml_stroke(oXmlNode, 'DATEEND',)
          if sqlite3_bind_text( stmt, 1, s_kod ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 2, s_name ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 3, s_comment ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 4, d1 ) == SQLITE_OK .AND. ;
            sqlite3_bind_text( stmt, 5, d2 ) == SQLITE_OK
            IF sqlite3_step( stmt ) != SQLITE_DONE
              out_error(TAG_ROW_INVALID, nfile, j)
            ENDIF
          ENDIF
          sqlite3_reset( stmt )
        endif
      next j
    endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  endif
  return nil