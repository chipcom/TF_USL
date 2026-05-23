#include 'hbsqlit3.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 23.05.26
Function make_f0xx( db, source )

  make_f031s( db, source )
  make_f032s( db, source )
  make_f033s( db, source )
  make_f034s( db, source )
  make_f037s( db, source )
  make_f038s( db, source )

  Return Nil

// 23.05.26
function make_f038s( db, source )

//  IDADDRESS, N, 19 ; UIDMO, C, 17 ; UIDSPMO, C, 17 ; N_DOC, C, 32 ; ADDR, C,250 ; ADDR_GAR, C, 36;

  Local cmdText, table
  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  local mIDADDRESS, mUIDMO, mUIDSPMO, mN_DOC, mADDR, mADDR_GAR
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f038( idaddress INTEGER, uidmo TEXT(17), uidspmo TEXT(17), n_doc TEXT(32), addr TEXT, addr_gar TEXT(36), PRIMARY KEY ( idaddress, uidspmo ) )'

  table := 'f038'
  nameRef := 'F038.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F038 Справочник адресов оказания медицинской помощи (ADDRMP)', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ZAP' == Upper( oXmlNode:title )
        mUIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
        if SubStr( mUIDMO, 1, 2 ) == '34'
          mIDADDRESS := mo_read_xml_stroke( oXmlNode, 'IDADDRESS', )
          mUIDSPMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'UIDSPMO', )
          mN_DOC := read_xml_stroke_1251_to_utf8( oXmlNode, 'N_DOC', )
          mADDR := read_xml_stroke_1251_to_utf8( oXmlNode, 'ADDR', )
          mADDR_GAR := read_xml_stroke_1251_to_utf8( oXmlNode, 'ADDR_GAR', )

          count++
          cmdTextInsert += 'INSERT INTO f038( idaddress, uidmo, uidspmo, n_doc, addr, addr_gar ) VALUES(' ;
          + "" + mIDADDRESS + "," ;
          + "'" + mUIDMO + "'," ;
          + "'" + mUIDSPMO + "'," ;
          + "'" + mN_DOC + "'," ;
          + "'" + mADDR + "'," ;
          + "'" + mADDR_GAR + "');"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        endif
      endif
    next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
  endif
  out_obrabotka_eol()

  return Nil

// 23.05.26
function make_f037s( db, source )

//    IDMO, C, 17; OID_MO, C, 35; MCOD, C,  6; UIDMO, C, 17; N_DOC, C, 32;

  Local cmdText, table
  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  local mIDMO, mOID_MO, mMCOD, mUIDMO, mN_DOC
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f037( idmo TEXT(17), oid_mo TEXT(35), mcod TEXT(6), uidmo TEXT(17), n_doc TEXT(32), PRIMARY KEY ( uidmo, n_doc ) )'

  table := 'f037'
  nameRef := 'F037.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F037 лицензий медицинских организаций (LicMO)', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ZAP' == Upper( oXmlNode:title )
        mMCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
        if SubStr( mMCOD, 1, 2 ) == '34'
          mIDMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDMO', )
          mOID_MO := read_xml_stroke_1251_to_utf8( oXmlNode, 'OID_MO', )
          mUIDMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'UIDMO', )
          mN_DOC := read_xml_stroke_1251_to_utf8( oXmlNode, 'N_DOC', )
          count++
          cmdTextInsert += 'INSERT INTO f037( idmo, oid_mo, mcod, uidmo, n_doc ) VALUES(' ;
          + "'" + mIDMO + "'," ;
          + "'" + mOID_MO + "'," ;
          + "'" + mMCOD + "'," ;
          + "'" + mUIDMO + "'," ;
          + "'" + mN_DOC + "');"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        endif
      endif
    next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
  endif
  out_obrabotka_eol()

  return Nil

// 23.05.26
function make_f034s( db, source )

//  UIDSPMO, C, 17 ; IDADDRESS, N, 19 ; MPVID, N, 4 ; MPUSL, N, 2 ; MPROF, N, 3

  Local cmdText, table
  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  local mUIDSPMO, mIDADDRESS, mMPVID, mMPUSL, mMPROF
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f034( uidspmo TEXT(17), idaddress INTEGER, mpvid INTEGER, mpusl INTEGER, mprof INTEGER )'

  table := 'f034'
  nameRef := 'F034.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F034 Справочник видов, условий и профилей медицинской помощи, оказываемой МО (VUP)', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ZAP' == Upper( oXmlNode:title )
        mUIDSPMO := mo_read_xml_stroke( oXmlNode, 'UIDSPMO', )
        if SubStr( mUIDSPMO, 1, 2 ) == '34'
          mIDADDRESS := mo_read_xml_stroke( oXmlNode, 'IDADDRESS', )
          mMPVID := mo_read_xml_stroke( oXmlNode, 'MPVID', )
          mMPUSL := mo_read_xml_stroke( oXmlNode, 'MPUSL', )
          mMPROF := mo_read_xml_stroke( oXmlNode, 'MPROF', )

          count++
          cmdTextInsert += 'INSERT INTO f034( uidspmo, idaddress, mpvid, mpusl, mprof ) VALUES(' ;
          + "'" + mUIDSPMO + "'," ;
          + "" + mIDADDRESS + "," ;
          + "" + mMPVID + "," ;
          + "" + mMPUSL + "," ;
          + "" + mMPROF + ");"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        endif
      endif
    next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
  endif
  out_obrabotka_eol()

  return Nil

// 23.05.26
Function make_f033s( db, source )

//  UIDSPMO, C, 17 ; IDSPMO, C, 17 ; NAM_SK, C, 80 ; NAM_SPMO, C, 150 ; OSP, C, 1;

  Local cmdText, table
  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  local mUIDSPMO, mIDSPMO, mOSP, mNameSk, mNameSPMO  //  , dBeg, dEnd
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f033( uidspmo TEXT(17) PRIMARY KEY, idspmo TEXT(17), nam_sk TEXT, nam_spmo TEXT, osp TEXT(1) )'

  table := 'f033'
  nameRef := 'F033.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F033 Справочник структурных подразделений медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (SPMO)', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF 'ZAP' == Upper( oXmlNode:title )
        mUIDSPMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'UIDSPMO', )
        mOSP := read_xml_stroke_1251_to_utf8( oXmlNode, 'OSP', )
        if SubStr( mUIDSPMO, 1, 2 ) == '34' .and. mOSP == '0'
          mIDSPMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDSPMO', )
          mNameSk := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_SK_SPMO', )
          mNameSPMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_SPMO', )

          count++
          cmdTextInsert += 'INSERT INTO f033( uidspmo, idspmo, nam_sk, nam_spmo, osp ) VALUES(' ;
          + "'" + mUIDSPMO + "'," ;
          + "'" + mIDSPMO + "'," ;
          + "'" + mNameSk + "'," ;
          + "'" + mNameSPMO + "'," ;
          + "'" + mOSP + "');"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        endif
      ENDIF
    NEXT j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
  endif
  out_obrabotka_eol()

  return nil

// 23.05.26
Function make_f032s( db, source )

//    UIDMO, C, 17; IDMO, C, 17; MCOD, C, 6; OSP, C, 1; NAMEMOK, C, 50; NAMEMOP, C, 150;
//    ADDRESS, C, 250; DBEGIN, C, 10; DEND, C, 10

  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  Local cmdText, table

  local mUIDMO, mIDMO, mMCOD, mOSP, mNameMOK, mNameMOP, mAddress  //  , dBeg, dEnd
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f032( uidmo TEXT(17) PRIMARY KEY, idmo TEXT(17), mcod TEXT(6), osp TEXT(1), namemop TEXT, namemok TEXT, address TEXT, dbegin TEXT(10), dbend TEXT(10) )'

  table := 'f032'
  nameRef := 'F032.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Реестр медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (TRMO) ', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

//  cmdText := 'CREATE INDEX pk_f032_uidmo ON f032( uidmo )'
//  create_index( db, 'pk_f032_uidmo', cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF 'ZAP' == Upper( oXmlNode:title )
        mMcod := read_xml_stroke_1251_to_utf8( oXmlNode, 'MCOD', )
        mUIDMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'UIDMO', )
        mIDMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDMO', )
        mOSP := read_xml_stroke_1251_to_utf8( oXmlNode, 'OSP', )
        mNameMOK := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_MOK', )
        mNameMOP := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_MOP', )
        mAddress := read_xml_stroke_1251_to_utf8( oXmlNode, 'JURADDRESS_ADDRESS', )
//        dBeg := 
//        dEnd := 

        count++
        cmdTextInsert += 'INSERT INTO f032( uidmo, idmo, mcod, osp, namemop, namemok, address ) VALUES(' ;
          + "'" + mUIDMO + "'," ;
          + "'" + mIDMO + "'," ;
          + "'" + mMCOD + "'," ;
          + "'" + mOSP + "'," ;
          + "'" + mNameMOP + "'," ;
          + "'" + mNameMOK + "'," ;
          + "'" + mAddress + "');"
//          + "'" + d1 + "'," ;
//          + "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      ENDIF
    NEXT j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
//    Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  endif
  out_obrabotka_eol()

  return nil

// 23.05.26
function make_f031s( db, source )

//  IDMO, C, 17; NAM_MOP, C, 250; NAM_MOK, C, 50; OID_MO, C, 35; ADDR_J_GAR, C, 36

  local oXmlDoc, oXmlNode
  local nameRef, nfile, k, j
  Local cmdText, table
  local mOKTMO, midmo, mNam_MOP, mNam_MOK, mOIDMO, mAddr_J_Gar
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f031( idmo TEXT(17) PRIMARY KEY, nam_mop TEXT, nam_mok TEXT, oid_mo TEXT(35), addr_j_gar TEXT(36) )'

  table := 'f031'
  nameRef := 'F031.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F031 Единый реестр медицинских организаций (ERMO)', 'RU866' )	
  Endif

  create_table( db, table, cmdText )

//  cmdText := 'CREATE INDEX pk_f031_idmo ON f031( idmo )'
//  create_index( db, 'pk_f031_idmo', cmdText )

  oXmlDoc := HXMLDoc():Read( nfile )
  IF ! Empty( oXmlDoc:aItems )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ZAP' == Upper( oXmlNode:title )
        mOKTMO := mo_read_xml_stroke( oXmlNode, 'OKTMO', )
        if SubStr( mOKTMO, 1, 2 ) == '18'
          midmo := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDMO' )
          mNam_MOP := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_MOP' )
          mNam_MOK := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAM_MOK' )
          mOIDMO := read_xml_stroke_1251_to_utf8( oXmlNode, 'OID_MO' )
          mAddr_J_Gar := read_xml_stroke_1251_to_utf8( oXmlNode, 'ADDR_J_GAR' )

          count++
          cmdTextInsert += 'INSERT INTO f031( idmo, nam_mop, nam_mok, oid_mo, addr_j_gar ) VALUES(' ;
            + "'" + midmo + "'," ;
            + "'" + mNam_MOP + "'," ;
            + "'" + mNam_MOK + "'," ;
            + "'" + mOIDMO + "'," ;
            + "'" + mAddr_J_Gar + "');"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        endif
      endif
    next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert, , .t., 'RU866' )
    Endif
  endif

  out_obrabotka_eol()

  return Nil
