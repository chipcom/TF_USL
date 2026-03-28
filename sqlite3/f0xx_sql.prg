#include 'hbsqlit3.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 28.03.26
Function make_f0xx( db, source, destination )

  make_f006( db, source )
  make_f010( db, source )
  make_f011( db, source )
  make_f014( db, source )

  make_f031( source, destination )
  make_f032( source, destination )
  make_f033( source, destination )
  make_f034( source, destination )
//  make_f035( source, destination )
//  make_f036( source, destination )
  make_f037( source, destination )
  make_f038( source, destination )

  Return Nil

// 26.03.26
function make_f038( source, destination )

  local _f038 := { ;
    { 'IDADDRESS', 'N',  19, 0 }, ;
    { 'UIDMO',     'C',  17, 0 }, ;
    { 'UIDSPMO',   'C',  17, 0 }, ;
    { 'N_DOC',     'C',  32, 0 }, ;
    { 'ADDR',      'C', 250, 0 }, ;
    { 'ADDR_GAR',  'C',  36, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mUIDMO   //  , mMCOD

  cAlias := 'F038'
  nameRef := 'F038.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F038 Справочник адресов оказания медицинской помощи (ADDRMP)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f038', _f038 )
  dbUseArea( .t., , destination + '_mo_f038', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
//        mMCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
//        if SubStr( mMCOD, 1, 2 ) == '34'
        mUIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
        if SubStr( mUIDMO, 1, 2 ) == '34'
          ( cAlias )->( dbAppend() )
          ( cAlias )->IDADDRESS := val( mo_read_xml_stroke( oXmlNode, 'IDADDRESS', ) )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->UIDSPMO := mo_read_xml_stroke( oXmlNode, 'UIDSPMO', )
          ( cAlias )->N_DOC := mo_read_xml_stroke( oXmlNode, 'N_DOC', )
          ( cAlias )->ADDR := mo_read_xml_stroke( oXmlNode, 'ADDR', )
          ( cAlias )->ADDR_GAR := mo_read_xml_stroke( oXmlNode, 'ADDR_GAR', )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 26.03.26
function make_f037( source, destination )

  local _f037 := { ;
    { 'IDMO',      'C',  17, 0 }, ;
    { 'OID_MO',    'C',  35, 0 }, ;
    { 'MCOD',      'C',   6, 0 }, ;
    { 'UIDMO',     'C',  17, 0 }, ;
    { 'N_DOC',     'C',  32, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mMCOD

  cAlias := 'F037'
  nameRef := 'F037.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F037 лицензий медицинских организаций (LicMO)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f037', _f037 )
  dbUseArea( .t., , destination + '_mo_f037', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
        mMCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
        if SubStr( mMCOD, 1, 2 ) == '34'
          ( cAlias )->( dbAppend() )
          ( cAlias )->MCOD := mMCOD
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->OID_MO := mo_read_xml_stroke( oXmlNode, 'OID_MO', )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->N_DOC := mo_read_xml_stroke( oXmlNode, 'N_DOC', )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 26.03.26
function make_f036( source, destination )

  local _f036 := { ;
    { 'IDMO',      'C',  17, 0 }, ;
    { 'MCOD',      'C',   6, 0 }, ;
    { 'UIDMO',     'C',  17, 0 }, ;
    { 'OID_MO',    'C',  35, 0 }, ;
    { 'FAM_RUK',   'C',  40, 0 }, ;
    { 'IM_RUK',    'C',  40, 0 }, ;
    { 'OT_RUK',    'C',  40, 0 }, ;
    { 'TYPE_RUK',  'C',   1, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mMCOD

  cAlias := 'F036'
  nameRef := 'F036.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F036 Справочник руководителей медицинских организаций (RukMO)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f036', _f036 )
  dbUseArea( .t., , destination + '_mo_f036', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
        mMCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
        if SubStr( mMCOD, 1, 2 ) == '34'
          ( cAlias )->( dbAppend() )
          ( cAlias )->MCOD := mMCOD
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->OID_MO := mo_read_xml_stroke( oXmlNode, 'OID_MO', )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->FAM_RUK := mo_read_xml_stroke( oXmlNode, 'FAM_RUK', )
          ( cAlias )->IM_RUK := mo_read_xml_stroke( oXmlNode, 'IM_RUK', )
          ( cAlias )->OT_RUK := mo_read_xml_stroke( oXmlNode, 'OT_RUK', )
          ( cAlias )->TYPE_RUK := mo_read_xml_stroke( oXmlNode, 'TYPE_RUK', )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 26.03.26
function make_f035( source, destination )

  local _f035 := { ;
    { 'IDMO',      'C',  17, 0 }, ;
    { 'MCOD',      'C',   6, 0 }, ;
    { 'UIDMO',     'C',  17, 0 }, ;
    { 'NAM_UMOP',  'C', 250, 0 }, ;
    { 'NAM_UMOK',  'C',  50, 0 }, ;
    { 'OID_MO',    'C',  35, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mMCOD

  cAlias := 'F035'
  nameRef := 'F035.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F035 Справочник учредителей медицинских организаций, являющихся государственными (муниципальными) учреждениями (UMO)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f035', _f035 )
  dbUseArea( .t., , destination + '_mo_f035', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
        mMCOD := mo_read_xml_stroke( oXmlNode, 'MCOD', )
        if SubStr( mMCOD, 1, 2 ) == '34'
          ( cAlias )->( dbAppend() )
          ( cAlias )->MCOD := mMCOD
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->NAM_UMOP := substr( mo_read_xml_stroke( oXmlNode, 'NAM_UMOP', ), 1, 250 )
          ( cAlias )->NAM_UMOK := substr( mo_read_xml_stroke( oXmlNode, 'NAM_UMOK', ), 1, 50 )
          ( cAlias )->OID_MO := mo_read_xml_stroke( oXmlNode, 'OID_MO', )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 28.03.26
function make_f031( source, destination )

  local _f031 := { ;
    { 'IDMO',      'C',  17, 0 }, ;
    { 'NAM_MOP',   'C', 250, 0 }, ;
    { 'NAM_MOK',   'C',  50, 0 }, ;
    { 'OID_MO',    'C',  35, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mOKTMO  //  , mIDMO

  cAlias := 'F031'
  nameRef := 'F031.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F031 Единый реестр медицинских организаций (ERMO)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f031', _f031 )
  dbUseArea( .t., , destination + '_mo_f031', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
//        mIDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
//        if SubStr( mIDMO, 1, 2 ) == '34'
        mOKTMO := mo_read_xml_stroke( oXmlNode, 'OKTMO', )
        if SubStr( mOKTMO, 1, 2 ) == '18'
          ( cAlias )->( dbAppend() )
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->NAM_MOP := substr( mo_read_xml_stroke( oXmlNode, 'NAM_MOP', ), 1, 250 )
          ( cAlias )->NAM_MOK := substr( mo_read_xml_stroke( oXmlNode, 'NAM_MOK', ), 1, 50 )
          ( cAlias )->OID_MO := mo_read_xml_stroke( oXmlNode, 'OID_MO', )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 25.01.26
Function make_f033( source, destination )

  local _f033 := { ;
    { 'UIDSPMO',  'C',  17, 0 }, ;
    { 'IDSPMO',   'C',  17, 0 }, ;
    { 'NAM_SK',   'C',  50, 0 }, ;
    { 'NAM_SPMO', 'C', 150, 0 },  ;
    { 'OSP',      'C',   1, 0 } ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mUIDSPMO, mOSP

  cAlias := 'F033'
  nameRef := 'F033.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F033 Справочник структурных подразделений медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (SPMO)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f033', _f033)
  dbUseArea( .t., , destination + '_mo_f033', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF "ZAP" == Upper( oXmlNode:title )
        mUIDSPMO := mo_read_xml_stroke( oXmlNode, 'UIDSPMO', )
        mOSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
        if SubStr( mUIDSPMO, 1, 2 ) == '34' .and. mOSP == '0'
          ( cAlias )->( dbAppend() )
          ( cAlias )->UIDSPMO := mUIDSPMO
          ( cAlias )->IDSPMO := mo_read_xml_stroke( oXmlNode, 'IDSPMO', )
          ( cAlias )->OSP := mOSP
          ( cAlias )->NAM_SK := substr( mo_read_xml_stroke( oXmlNode, 'NAM_SK_SPMO', ), 1, 50 )
          ( cAlias )->NAM_SPMO := substr( mo_read_xml_stroke( oXmlNode, 'NAM_SPMO', ), 1, 150 )
        endif
      ENDIF
    NEXT j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return nil

// 28.03.26
function make_f034( source, destination )

  local _f034 := { ;
    { 'UIDSPMO',  'C',  17, 0 }, ;
    { 'IDADDRESS','N',  19, 0 }, ;
    { 'MPVID',    'N',   4, 0 }, ;
    { 'MPUSL',    'N',   2, 0 }, ;
    { 'MPROF',    'N',   3, 0 }  ;
  }
  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mUIDSPMO

  cAlias := 'F034'
  nameRef := 'F034.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - F034 Справочник видов, условий и профилей медицинской помощи, оказываемой МО (VUP)', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f034', _f034 )
  dbUseArea( .t., , destination + '_mo_f034', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == Upper( oXmlNode:title )
        mUIDSPMO := mo_read_xml_stroke( oXmlNode, 'UIDSPMO', )
        if SubStr( mUIDSPMO, 1, 2 ) == '34'
          ( cAlias )->( dbAppend() )
          ( cAlias )->UIDSPMO := mUIDSPMO
          ( cAlias )->IDADDRESS := val( mo_read_xml_stroke( oXmlNode, 'IDADDRESS', ) )
          ( cAlias )->MPVID := val( mo_read_xml_stroke( oXmlNode, 'MPVID', ) )
          ( cAlias )->MPUSL := val( mo_read_xml_stroke( oXmlNode, 'MPUSL', ) )
          ( cAlias )->MPROF := val( mo_read_xml_stroke( oXmlNode, 'MPROF', ) )
        endif
      endif
    next j
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return Nil

// 25.01.26
Function make_f032( source, destination )

  local _f032 := { ;
    { 'UIDMO',    'C',  17, 0 }, ;
    { 'IDMO',     'C',  17, 0 }, ;
    { 'MCOD',     'C',   6, 0 }, ;
    { 'OSP',      'C',   1, 0 }, ;
    { 'NAMEMOK',  'C',  50, 0 }, ;
    { 'NAMEMOP',  'C', 150, 0 }, ;
    { 'ADDRESS',  'C', 250, 0 }, ;
    { 'DBEGIN',   'D',   8, 0 }, ;
    { 'DEND',     'D',   8, 0 } ;
  }
//    { 'NAME_MOK', 'C',  50, 0 }, ;
//    { 'NAME_MOP', 'C', 150, 0 }  ;

  local oXmlDoc, oXmlNode
  local cAlias, nameRef, nfile, k, j
  local mMcod

  cAlias := 'F032'
  nameRef := 'F032.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Реестр медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (TRMO) ', 'RU866' )	
  Endif

  dbcreate( destination + '_mo_f032', _f032)
  dbUseArea( .t.,, destination + '_mo_f032', cAlias, .f., .f. )
  ( cAlias )->(dbGoTop())

  oXmlDoc := HXMLDoc():Read( nfile )
  IF Empty( oXmlDoc:aItems )
    ( cAlias )->( dbCloseArea() )
  else
    Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      IF "ZAP" == Upper( oXmlNode:title )
//        mOSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
        mMcod := mo_read_xml_stroke( oXmlNode, 'MCOD', )
//        if SubStr( mMcod, 1, 2 ) == '34'  // 
          ( cAlias )->( dbAppend() )
          ( cAlias )->UIDMO := mo_read_xml_stroke( oXmlNode, 'UIDMO', )
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->MCOD := mMcod // mo_read_xml_stroke( oXmlNode, 'MCOD', )
          ( cAlias )->OSP := mo_read_xml_stroke( oXmlNode, 'OSP', )
          ( cAlias )->NAMEMOK := mo_read_xml_stroke( oXmlNode, 'NAM_MOK', )
          ( cAlias )->NAMEMOP := mo_read_xml_stroke( oXmlNode, 'NAM_MOP', )
          ( cAlias )->ADDRESS := mo_read_xml_stroke( oXmlNode, 'JURADDRESS_ADDRESS', )
          ( cAlias )->DBEGIN := CToD( mo_read_xml_stroke( oXmlNode, 'DATEBEG', ) )
          ( cAlias )->DEND := CToD( mo_read_xml_stroke( oXmlNode, 'DATEEND', ) )
//        endif
      ENDIF
    NEXT j
    Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
  endif
  out_obrabotka_eol()

  ( cAlias )->( dbCloseArea() )

  return nil

// 01.09.23
Function make_f006( db, source )

  // IDVID,       "N",      2,      0  // Код вида контроля
  // VIDNAME,     "C",    350,      0  // Наименование вида контроля
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDVID, mVidname, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f006(idvid INTEGER, vidname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F006.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор видов контроля (VidExp)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f006' ) == SQLITE_OK
    OutStd( 'DROP TABLE f006 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f006 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f006 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    For j := 1 To k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ZAP' == Upper( oXmlNode:title )
        mIDVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDVID' )
        mVidname := read_xml_stroke_1251_to_utf8( oXmlNode, 'VIDNAME' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f006(idvid, vidname, datebeg, dateend) VALUES(' ;
          + "" + AllTrim( Str( Val( mIDVID ) ) ) + "," ;
          + "'" + mVidname + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 01.09.23
Function make_f010( db, source )

  // KOD_TF,       "C",      2,      0  // Код ТФОМС
  // KOD_OKATO,     "C",    5,      0  // Код по ОКАТО (Приложение А O002).
  // SUBNAME,     "C",    254,      0  // Наименование субъекта РФ
  // OKRUG,     "N",        1,      0  // Код федерального округа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mKOD_TF, mKOD_OKATO, mSubname, mOkrug, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f010(kod_tf TEXT(2), kod_okato TEXT(5), subname TEXT, okrug INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F010.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор субъектов Российской Федерации (Subekti)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f010' ) == SQLITE_OK
    OutStd( 'DROP TABLE f010 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f010 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f010 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    For j := 1 To k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ZAP' == Upper( oXmlNode:title )
        mKOD_TF := read_xml_stroke_1251_to_utf8( oXmlNode, 'KOD_TF' )
        mKOD_OKATO := read_xml_stroke_1251_to_utf8( oXmlNode, 'KOD_OKATO' )
        mSubname := read_xml_stroke_1251_to_utf8( oXmlNode, 'SUBNAME' )
        mOkrug := read_xml_stroke_1251_to_utf8( oXmlNode, 'OKRUG' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f010(kod_tf, kod_okato, subname, okrug, datebeg, dateend) VALUES(' ;
          + "'" + mKOD_TF + "'," ;
          + "'" + mKOD_OKATO + "'," ;
          + "'" + mSubname + "'," ;
          + "" + AllTrim( Str( Val( mOkrug ) ) ) + "," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 01.09.23
Function make_f011( db, source )

  // IDDoc,       "C",      2,      0  // Код типа документа
  // DocName,     "C",    254,      0  // Наименование типа документа
  // DocSer,     "C",    10,      0  // Маска серии документа
  // DocNum,     "C",      20,      0  // Маска номера документа
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mIDDoc, mDocName, mDocSer, mDocNum, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f011(iddoc TEXT(2), docname TEXT, docser TEXT(10), docnum TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F011.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор типов документов, удостоверяющих личность (Tipdoc)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f011' ) == SQLITE_OK
    OutStd( 'DROP TABLE f011 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f011 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f011 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    For j := 1 To k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ZAP' == Upper( oXmlNode:title )
        mIDDoc := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDDoc' )
        mDocName := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocName' )
        mDocSer := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocSer' )
        mDocNum := read_xml_stroke_1251_to_utf8( oXmlNode, 'DocNum' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f011(iddoc, docname, docser, docnum, datebeg, dateend) VALUES(' ;
          + "'" + mIDDoc + "'," ;
          + "'" + mDocName + "'," ;
          + "'" + mDocSer + "'," ;
          + "'" + mDocNum + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 01.09.23
Function make_f014( db, source )

  // Kod,       "N",      3,      0  // Код ошибки
  // IDVID,     "N",    1,      0  // Код вида контроля, резервное поле
  // Naim,     "C",    1000,      0  // Наименование причины отказа
  // Osn,     "C",      20,      0  // Основание отказа
  // Komment,     "C",      100,      0  // Служебный комментарий
  // KodPG,     "C",      20,      0  // Код по форме N ПГ
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local mKod, mIDVID, mNaim, mOsn, mKomment, mKodPG, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f014(kod INTEGER, idvid INTEGER, naim BLOB, osn TEXT(20), komment BLOB, kodpg TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F014.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Классификатор причин отказа в оплате медицинской помощи (OplOtk)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE if EXISTS f014' ) == SQLITE_OK
    OutStd( 'DROP TABLE f014 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE f014 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE f014 - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    For j := 1 To k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      If 'ZAP' == Upper( oXmlNode:title )
        mKod := read_xml_stroke_1251_to_utf8( oXmlNode, 'Kod' )
        mIDVID := read_xml_stroke_1251_to_utf8( oXmlNode, 'IDVID' )
        mNaim := read_xml_stroke_1251_to_utf8( oXmlNode, 'Naim' )
        mOsn := read_xml_stroke_1251_to_utf8( oXmlNode, 'Osn' )
        mKomment := read_xml_stroke_1251_to_utf8( oXmlNode, 'Komment' )
        mKodPG := read_xml_stroke_1251_to_utf8( oXmlNode, 'KodPG' )

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEBEG' ) )
        d2_1 := CToD( read_xml_stroke_1251_to_utf8( oXmlNode, 'DATEEND' ) )
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr( d1_1 )
        d2 := hb_ValToStr( d2_1 )

        count++
        cmdTextInsert += 'INSERT INTO f014(kod, idvid, naim, osn, komment, kodpg, datebeg, dateend) VALUES(' ;
          + "" + AllTrim( Str( Val( mKod ) ) ) + "," ;
          + "" + AllTrim( Str( Val( mIDVID ) ) ) + "," ;
          + "'" + mNaim + "'," ;
          + "'" + mOsn + "'," ;
          + "'" + mKomment + "'," ;
          + "'" + mKodPG + "'," ;
          + "'" + d1 + "'," ;
          + "'" + d2 + "');"
        If count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec( db, cmdTextInsert )
          count := 0
          cmdTextInsert := textBeginTrans
        Endif
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil
