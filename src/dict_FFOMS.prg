/// Справочники ФФОМС
#include "dict_error.ch"

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

// 30.06.26
function work_ffoms( source, destination )

  make_f031( source, destination )
  make_f032( source, destination )
  make_f033( source, destination )
  make_f034( source, destination )
//  make_f035( source, destination )
//  make_f036( source, destination )
  make_f037( source, destination )
  make_f038( source, destination )

  return nil

// 28.03.26
function make_f031( source, destination )

  local _f031 := { ;
    { 'IDMO',      'C',  17, 0 }, ;
    { 'NAM_MOP',   'C', 250, 0 }, ;
    { 'NAM_MOK',   'C',  50, 0 }, ;
    { 'OID_MO',    'C',  35, 0 }, ;
    { 'ADDR_J_GAR','C',  36, 0 } ;
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
    OutStd( nameRef + ' - F031 Единый реестр медицинских организаций (ERMO)', 'RU866' )	
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
        mOKTMO := mo_read_xml_stroke( oXmlNode, 'OKTMO', )
        if SubStr( mOKTMO, 1, 2 ) == '18'
          ( cAlias )->( dbAppend() )
          ( cAlias )->IDMO := mo_read_xml_stroke( oXmlNode, 'IDMO', )
          ( cAlias )->NAM_MOP := substr( mo_read_xml_stroke( oXmlNode, 'NAM_MOP', ), 1, 250 )
          ( cAlias )->NAM_MOK := substr( mo_read_xml_stroke( oXmlNode, 'NAM_MOK', ), 1, 50 )
          ( cAlias )->OID_MO := mo_read_xml_stroke( oXmlNode, 'OID_MO', )
          ( cAlias )->ADDR_J_GAR := mo_read_xml_stroke( oXmlNode, 'ADDR_J_GAR', )
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
    OutStd( nameRef + ' - Реестр медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (TRMO) ' )	
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
    OutStd( nameRef + ' - F033 Справочник структурных подразделений медицинских организаций, осуществляющих деятельность в сфере обязательного медицинского страхования (SPMO)', 'RU866' )	
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
    OutStd( nameRef + ' - F034 Справочник видов, условий и профилей медицинской помощи, оказываемой МО (VUP)' )	
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
    OutStd( nameRef + ' - F035 Справочник учредителей медицинских организаций, являющихся государственными (муниципальными) учреждениями (UMO)' )	
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
    OutStd( nameRef + ' - F036 Справочник руководителей медицинских организаций (RukMO)' )	
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
    OutStd( nameRef + ' - F037 лицензий медицинских организаций (LicMO)' )	
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
  local mUIDMO

  cAlias := 'F038'
  nameRef := 'F038.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    OutStd( nameRef + ' - F038 Справочник адресов оказания медицинской помощи (ADDRMP)' )	
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

// 30.03.26
Function work_V002( source, destination )

  local _mo_V002 := { ;
    {"IDPR",       "N",      3,      0}, ;
    {"PRNAME",     "C",    250,      0}, ;
    {"DATEBEG",    "D",      8,      0}, ;
    {"DATEEND",    "D",      8,      0} ;
  }
  local nfile, nameRef, oXmlDoc, oXmlNode
  local k, j, mDATEEND, mIDPR, mPRNAME, mDATEBEG

  nameRef := 'V002.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    return nil
  endif

  dbcreate( destination + '_mo_v002', _mo_V002 )
  use ( destination + '_mo_V002' ) new alias V002
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор профилей оказанной медицинской помощи (ProfOt)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )         
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mDATEEND := CToD( '  /  /    ' )
        mIDPR := mo_read_xml_stroke( oXmlNode, 'IDPR', )
        mPRNAME := mo_read_xml_stroke( oXmlNode, 'PRNAME', )
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode, 'DATEBEG', ) )
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode, 'DATEEND', ) )

        if !empty( mDATEEND ) .and. mDATEEND < FIRST_DAY
        else
          select V002
          V002->( dbAppend() )
          V002->IDPR := val( mIDPR )
          V002->PRNAME := alltrim( mPRNAME )
          V002->DATEBEG := mDATEBEG
          V002->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V016( source, destination )
  local _mo_V016 := {;
    {"IDDT",      "C",   3, 0},;  // Код типа диспансеризации
    {"DTNAME",    "C", 254, 0},;  // Наименование типа диспансеризации
    {"RULE",      "C",  40, 0},;  // Значение результата диспансеризации (список) (V017)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local mRULE := ''
  local nfile, nameRef, j, k

  nameRef := "V016.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    dbCloseAll()
    return nil
  endif

  dbcreate(destination + "_mo_v016", _mo_V016)
  use (destination + '_mo_v016') new alias V016
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор типов диспансеризации (DispT)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDDT := mo_read_xml_stroke( oXmlNode,"IDDT",)
        mDTNAME := mo_read_xml_stroke( oXmlNode,"DTNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        mRULE := ''
        if (oNode1 := oXmlNode:Find("DTRULE")) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if "RULE" == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[ 1 ])=="C"
              mRULE := mRULE + iif(empty(mRULE), '', ',') + alltrim(oNode2:aItems[ 1 ])
            endif
          next
        endif

        select V016
        append blank
        V016->IDDT := mIDDT
        V016->DTNAME := mDTNAME
        V016->RULE := mRULE
        V016->DATEBEG := mDATEBEG
        V016->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V017( source, destination )
  local _mo_V017 := {;
    {"IDDR",      "N",   2, 0},;  // Код результата диспансеризации
    {"DRNAME",    "C", 254, 0},;  // Наименование результата диспансеризации
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V017.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    dbCloseAll()
    return nil
  endif

  dbcreate(destination + "_mo_v017", _mo_V017)
  use (destination + '_mo_v017') new alias V017
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор результатов диспансеризации (DispR)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDDR := mo_read_xml_stroke( oXmlNode,"IDDR",)
        mDRNAME := mo_read_xml_stroke( oXmlNode,"DRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))

        select V017
        append blank
        V017->IDDR := val(mIDDR)
        V017->DRNAME := mDRNAME
        V017->DATEBEG := mDATEBEG
        V017->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V021( source, destination )

  local _mo_V021 := {;
    {"IDSPEC",     "N",      3,      0},;
    {"SPECNAME",   "C",    250,      0},;
    {"POSTNAME",   "C",    250,      0},;
    {"IDPOST_MZ",  "C",      4,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "V021.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v021", _mo_V021)
  use (destination + '_mo_V021') new alias V021
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор медицинских специальностей (должностей) (MedSpec)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDSPEC := mo_read_xml_stroke( oXmlNode,"IDSPEC",)
        mSPECNAME := mo_read_xml_stroke( oXmlNode,"SPECNAME",)
        mPOSTNAME := mo_read_xml_stroke( oXmlNode,"POSTNAME",)
        mIDPOST_MZ := mo_read_xml_stroke( oXmlNode,"IDPOST_MZ",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))

        if !empty(mDATEEND) .and. mDATEEND < 0d20180101
        else
          select V021
          append blank
          V021->IDSPEC := val(mIDSPEC)
          V021->SPECNAME := alltrim(mSPECNAME)
          V021->POSTNAME := alltrim(mPOSTNAME)
          V021->IDPOST_MZ := alltrim(mIDPOST_MZ)
          V021->DATEBEG := mDATEBEG
          V021->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22 вернуть массив по справочнику регионов ТФОМС V002.xml
function getV002(destination)
  // V002.xml - 
  //  1 - PRNAME(C)  2 - IDPR(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V002"
  local _v002 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v002, { (dbName)->PRNAME, (dbName)->IDPR, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v002

// 11.02.22
Function work_V009( source, destination )
  local _mo_V009 := {;
    {"IDRMP",     "N",   3, 0},;  // Код результата обращения
    {"RMPNAME",   "C", 254, 0},;  // Наименование результата обращения
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания медицинской помощи (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k
  
  nameRef := "V009.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v009", _mo_V009)
  use (destination + '_mo_v009') new alias V009
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор результатов обращения за медицинской помощью (Rezult)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDRMP := mo_read_xml_stroke( oXmlNode,"IDRMP",)
        mRMPNAME := mo_read_xml_stroke( oXmlNode,"RMPNAME",)
        mDL_USLOV := mo_read_xml_stroke( oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V009
        append blank
        V009->IDRMP := val(mIDRMP)
        V009->RMPNAME := mRMPNAME
        V009->DL_USLOV := val(mDL_USLOV)
        V009->DATEBEG := mDATEBEG
        V009->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V010( source, destination )
  local _mo_V010 := {;
    {"IDSP",      "N",   2, 0},;  // Код способа оплаты медицинской помощи
    {"SPNAME",    "C", 254, 0},;  // Наименование способа оплаты медицинской помощи
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V010.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif

  dbcreate(destination + "_mo_v010", _mo_V010)
  use (destination + '_mo_v010') new alias V010
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор способов оплаты медицинской помощи (Sposob)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDSP := mo_read_xml_stroke( oXmlNode,"IDSP",)
        mSPNAME := mo_read_xml_stroke( oXmlNode,"SPNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V010
        append blank
        V010->IDSP := val(mIDSP)
        V010->SPNAME := mSPNAME
        V010->DATEBEG := mDATEBEG
        V010->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V012( source, destination )
  local _mo_V012 := {;
    {"IDIZ",      "N",   3, 0},;  // Код исхода заболевания
    {"IZNAME",    "C", 254, 0},;  // Наименование исхода заболевания
    {"DL_USLOV",  "N",   2, 0},;  // Соответствует условиям оказания МП (V006)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V012.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v012", _mo_V012)
  use (destination + '_mo_v012') new alias V012
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор исходов заболевания (Ishod)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDIZ := mo_read_xml_stroke( oXmlNode,"IDIZ",)
        mIZNAME := mo_read_xml_stroke( oXmlNode,"IZNAME",)
        mDL_USLOV := mo_read_xml_stroke( oXmlNode,"DL_USLOV",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V012
        append blank
        V012->IDIZ := val(mIDIZ)
        V012->IZNAME := mIZNAME
        V012->DL_USLOV := val(mDL_USLOV)
        V012->DATEBEG := mDATEBEG
        V012->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22 вернуть массив по справочнику ТФОМС V021.xml
function getV021(destination)
  // V021.xml - Классификатор медицинских специальностей (последний)
  //  1 - SPECNAME(C)  2 - IDSPEC(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local dbName := "_mo_V021"
  local _v021 := {}

  dbUseArea( .t.,, destination + dbName, dbName, .f., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
      aadd(_v021, { (dbName)->SPECNAME, (dbName)->IDSPEC, (dbName)->DATEBEG, (dbName)->DATEEND })
      (dbName)->(dbSkip())
  enddo
  (dbName)->(dbCloseArea())

  return _v021

// 12.02.22
Function work_V015( source, destination )
  local _mo_V015 := {;
    {"NAME",   "C",  254,      0},;
    {"CODE",   "N",    4,      0},;
    {"HIGH",   "C",    4,      0},;
    {"OKSO",   "C",    3,      0},;
    {"DATEBEG","D",    8,      0},;
    {"DATEEND","D",    8,      0},;
    {"RECID",  "N",    3,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "V015.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v015", _mo_V015)
  use (destination + '_mo_V015') new alias V015
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор медицинских специальностей (Medspec)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mRECID := mo_read_xml_stroke( oXmlNode,"RECID",)
        mCODE := mo_read_xml_stroke( oXmlNode,"CODE",)
        mNAME := mo_read_xml_stroke( oXmlNode,"NAME",)
        mHIGH := mo_read_xml_stroke( oXmlNode,"HIGH",)
        mOKSO := mo_read_xml_stroke( oXmlNode,"OKSO",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V015
        append blank
        V015->RECID := val(mRECID)
        V015->CODE := val(mCODE)
        V015->NAME := mNAME
        V015->HIGH := mHIGH
        V015->OKSO := mOKSO
        V015->DATEBEG := mDATEBEG
        V015->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL
  
// 12.02.22
Function work_V018( source, destination )
  local _mo_V018 := {;
    {"IDHVID",     "C",     12,      0},;
    {"HVIDNAME",   "C",    254,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"HVIDNAME",   "M",     10,      0},;
  local nfile, nameRef, j, k

  nameRef := "V018.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v018", _mo_V018)
  use (destination + '_mo_V018') new alias V018
  // index on kod to tmp_shema
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - виды высокотехнологичной медицинской помощи (HVid)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDHVID := mo_read_xml_stroke( oXmlNode,"IDHVID",)
        mHVIDNAME := mo_read_xml_stroke( oXmlNode,"HVIDNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V018
        append blank
        V018->IDHVID := mIDHVID
        V018->HVIDNAME := mHVIDNAME
        V018->DATEBEG := mDATEBEG
        V018->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL
  
// 10.02.22
Function work_V019( source, destination )
  local _mo_V019 := {;
    {"IDHM",       "N",      4,      0},; // Идентификатор метода высокотехнологичной медицинской помощи
    {"HMNAME",     "C",    254,      0},; // Наименование метода высокотехнологичной медицинской помощи
    {"DIAG",       "M",     10,      0},; // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
    {"HVID",       "C",     12,      0},; // Код вида высокотехнологичной медицинской помощи для данного метода
    {"HGR",        "N",      3,      0},; // Номер группы высокотехнологичной медицинской помощи для данного метода
    {"HMODP",      "C",    254,      0},; // Модель пациента для методов высокотехнологичной медицинской помощи с одинаковыми значениями поля "HMNAME". Не заполняется, начиная с версии 3.0
    {"IDMODP",     "N",      5,      0},; // Идентификатор модели пациента для данного метода (начиная с версии 3.0, заполняется значением поля IDMPAC классификатора V022)
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }
  // {"DIAG",       "C",    700,      0},; // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
  local nfile, nameRef, j, k

  nameRef := "V019.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v019",_mo_V019)
  use (destination + '_mo_V019') new alias V019
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - методы высокотехнологичной медицинской помощи (HMet)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDHM := mo_read_xml_stroke( oXmlNode,"IDHM",)
        mHMNAME := mo_read_xml_stroke( oXmlNode,"HMNAME",)
        mDIAG := mo_read_xml_stroke( oXmlNode,"DIAG",)
        mHVID := mo_read_xml_stroke( oXmlNode,"HVID",)
        mHGR := mo_read_xml_stroke( oXmlNode,"HGR",)
        mHMODP := mo_read_xml_stroke( oXmlNode,"HMODP",)
        mIDMODP := mo_read_xml_stroke( oXmlNode,"IDMODP",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V019
        append blank
        V019->IDHM := val(mIDHM)
        V019->HMNAME := mHMNAME
        V019->DIAG := mDIAG
        V019->HVID := mHVID
        V019->HGR := val(mHGR)
        if upper(alltrim(mHMODP)) != 'NULL'
          V019->HMODP := mHMODP
        endif
        V019->IDMODP := val(mIDMODP)
        // V019->DATEBEG := mDATEBEG
        V019->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        // V019->DATEEND := mDATEEND
        V019->DATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V020( source, destination )
  local _mo_V020 := {;
    {"IDK_PR",     "N",      3,      0},; // Код профиля койки
    {"K_PRNAME",   "C",    254,      0},; // Наименование профиля койки
    {"DATEBEG",    "D",      8,      0},; // Дата начала действия записи
    {"DATEEND",    "D",      8,      0};  // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V020.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v020", _mo_V020)
  use (destination + '_mo_v020') new alias V020
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор профиля койки (KoPr)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDK_PR := mo_read_xml_stroke( oXmlNode,"IDK_PR",)
        mK_PRNAME := mo_read_xml_stroke( oXmlNode,"K_PRNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V020
        append blank
        V020->IDK_PR := val(mIDK_PR)
        V020->K_PRNAME := mK_PRNAME
        V020->DATEBEG := mDATEBEG
        V020->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 11.02.22
Function work_V022( source, destination )
  local _mo_V022 := {;
    {"IDMPAC",     "N",      5,      0},;
    {"MPACNAME",   "M",     10,      0},;
    {"DATEBEG",    "D",      8,      0},;
    {"DATEEND",    "D",      8,      0};
  }
  // {"MPACNAME",   "C",   1250,      0},;
  local nfile, nameRef, j, k
  
  nameRef := "V022.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v022",_mo_V022)
  use (destination + '_mo_V022') new alias V022
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDMPAC := mo_read_xml_stroke( oXmlNode,"IDMPAC",)
        mMPACNAME := mo_read_xml_stroke( oXmlNode,"MPACNAME",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        if mDATEBEG >= FIRST_DAY .or. Empty(mDATEEND)  //0d20210101
          select V022
          append blank
          V022->IDMPAC := val(mIDMPAC)
          V022->MPACNAME := mMPACNAME
          V022->DATEBEG := mDATEBEG
          V022->DATEEND := mDATEEND
        endif
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V025( source, destination )
  local _mo_V025 := {;
    {"IDPC",      "C",   3, 0},;  // Код цели посещения
    {"N_PC",      "C", 254, 0},;  // Наименование цели посещения
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V025.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v025", _mo_V025)
  use (destination + '_mo_V025') new alias V025
  // index on kod to tmp_shema
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Классификатор целей посещения (KPC)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mIDPC := mo_read_xml_stroke( oXmlNode,"IDPC",)
        mN_PC := mo_read_xml_stroke( oXmlNode,"N_PC",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V025
        append blank
        V025->IDPC := mIDPC
        V025->N_PC := mN_PC
        V025->DATEBEG := mDATEBEG
        V025->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V030( source, destination )
  local _mo_V030 := {;
    {"SCHEMCOD",  "C",   3, 0},;  // 
    {"SCHEME",    "C",  10, 0},;  //
    {"DEGREE",    "N",   2, 0},;  //
    {"COMMENT",   "M",  10, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V030.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v030", _mo_V030)
  use (destination + '_mo_V030') new alias V030
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Схемы лечения заболевания COVID-19 (TreatReg)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mSchemCod := mo_read_xml_stroke( oXmlNode,"SchemCode",)
        mScheme := mo_read_xml_stroke( oXmlNode,"Scheme",)
        mDegree := mo_read_xml_stroke( oXmlNode,"DegreeSeverity",)
        mComment := mo_read_xml_stroke( oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V030
        append blank
        V030->SCHEMCOD := mSchemCod
        V030->SCHEME := mScheme
        V030->DEGREE := val(mDegree)
        V030->COMMENT := mComment
        V030->DATEBEG := mDATEBEG
        V030->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V031( source, destination )
  local _mo_V031 := {;
    {"DRUGCODE",  "N",   2, 0},;  // 
    {"DRUGGRUP",  "C",  50, 0},;  //
    {"INDMNN",    "N",   2, 0},;  // Признак обязательности указания МНН (1-да, 0-нет)
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V031.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v031", _mo_V031)
  use (destination + '_mo_V031') new alias V031
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mDrugCode := mo_read_xml_stroke( oXmlNode,"DrugGroupCode",)
        mDrugGrup := mo_read_xml_stroke( oXmlNode,"DrugGroup",)
        mIndMNN := mo_read_xml_stroke( oXmlNode,"ManIndMNN",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V031
        append blank
        V031->DRUGCODE := val(mDrugCode)
        V031->DRUGGRUP := mDrugGrup
        V031->INDMNN := val(mIndMNN)
        V031->DATEBEG := mDATEBEG
        V031->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V032( source, destination )
  local _mo_V032 := {;
    {"SCHEDRUG",  "C",  10, 0},;  // Сочетание схемы лечения и группы препаратов
    {"NAME",      "C", 100, 0},;  //
    {"SCHEMCOD",  "C",   3, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V032.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v032", _mo_V032)
  use (destination + '_mo_V032') new alias V032
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Сочетание схемы лечения и группы препаратов (CombTreat)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mScheDrug := mo_read_xml_stroke( oXmlNode,"ScheDrugGrCd",)
        mName := mo_read_xml_stroke( oXmlNode,"Name",)
        mSchemCod := mo_read_xml_stroke( oXmlNode,"SchemCode",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V032
        append blank
        V032->SCHEDRUG := mScheDrug
        V032->NAME := mName
        V032->SCHEMCOD := mSchemCod
        V032->DATEBEG := mDATEBEG
        V032->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V033( source, destination )
  local _mo_V033 := {;
    {"SCHEDRUG",  "C",   5, 0},;  // 
    {"DRUGCODE",  "C",   6, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V033.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v033", _mo_V033)
  use (destination + '_mo_V033') new alias V033
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Соответствие кода препарата схеме лечения (DgTreatReg)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mScheDrug := mo_read_xml_stroke( oXmlNode,"ScheDrugGrCd",)
        mDrugCode := mo_read_xml_stroke( oXmlNode,"DrugCode",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V033
        append blank
        V033->SCHEDRUG := mScheDrug
        V033->DRUGCODE := mDrugCode
        V033->DATEBEG := mDATEBEG
        V033->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V034( source, destination )
  local _mo_V034 := {;
    {"UNITCODE",  "N",   3, 0},;  // код единицы измерения дозы
    {"UNITMEAS",  "C",  50, 0},;  //
    {"SHORTTIT",  "C",  15, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V034.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v034", _mo_V034)
  use (destination + '_mo_V034') new alias V034
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Единицы измерения (UnitMeas)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mUnitCode := mo_read_xml_stroke( oXmlNode,"UnitCode",)
        mUnitMeas := mo_read_xml_stroke( oXmlNode,"UnitMeasur",)
        mShortTit := mo_read_xml_stroke( oXmlNode,"ShortTitle",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V034
        append blank
        V034->UNITCODE := val(mUnitCode)
        V034->UNITMEAS := mUnitMeas
        V034->SHORTTIT := mShortTit
        V034->DATEBEG := mDATEBEG
        V034->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V035( source, destination )
  local _mo_V035 := {;
    {"METHCODE",  "N",   3, 0},;  // 
    {"METHNAME",   "C",  50, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V035.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v035", _mo_V035)
  use (destination + '_mo_V035') new alias V035
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Способы введения (MethIntro)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mMethCode := mo_read_xml_stroke( oXmlNode,"MethCode",)
        mMethName := mo_read_xml_stroke( oXmlNode,"MethNam",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V035
        append blank
        V035->METHCODE := val(mMethCode)
        V035->METHNAME := mMethName
        V035->DATEBEG := mDATEBEG
        V035->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V036( source, destination )
  local _mo_V036 := {;
    {"S_CODE",    "C",  16, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V036.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v036", _mo_V036)
  use (destination + '_mo_V036') new alias V036
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mS_Code := mo_read_xml_stroke( oXmlNode,"S_CODE",)
        mName := mo_read_xml_stroke( oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke( oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke( oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V036
        append blank
        V036->S_CODE := mS_Code
        V036->NAME := mName
        V036->PARAM := val(mParam)
        V036->COMMENT := mComment
        V036->DATEBEG := mDATEBEG
        V036->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function work_V037( source, destination )
  local _mo_V037 := {;
    {"CODE",      "N",   5, 0},;  // 
    {"NAME",      "C", 150, 0},;  //
    {"PARAM",     "N",   1, 0},;  //
    {"COMMENT",   "C",  20, 0},;  //
    {"DATEBEG",   "D",   8, 0},;  // Дата начала действия записи
    {"DATEEND",   "D",   8, 0};   // Дата окончания действия записи
  }
  local nfile, nameRef, j, k

  nameRef := "V037.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_v037", _mo_V037)
  use (destination + '_mo_V037') new alias V037
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Перечень методов ВМП, требующих имплантацию медицинских изделий" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        mCode := mo_read_xml_stroke( oXmlNode,"CODE",)
        mName := mo_read_xml_stroke( oXmlNode,"NAME",)
        mParam := mo_read_xml_stroke( oXmlNode,"Parameter",)
        mComment := mo_read_xml_stroke( oXmlNode,"COMMENT",)
        mDATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        mDATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
        select V037
        append blank
        V037->CODE := val(mCode)
        V037->NAME := mName
        V037->PARAM := val(mParam)
        V037->COMMENT := mComment
        V037->DATEBEG := mDATEBEG
        V037->DATEEND := mDATEEND
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function make_O001( source, destination )

    //  1 - NAME11(C)  2 - KOD(C)  3 - DATEBEG(D)  4 - DATEEND(D)  5 - ALFA2(C)  6 - ALFA3(C)
    local _mo_O001 := {;
    {"KOD",     "C",    3,      0},;
    {"NAME11",  "C",   60,      0},;
    {"NAME12",  "C",   60,      0},;
    {"ALFA2",   "C",    2,      0},;
    {"ALFA3",   "C",    3,      0},;
    {"DATEBEG", "D",    8,      0},;
    {"DATEEND", "D",    8,      0};
  }
  local mName := '', mArr
  local nfile, nameRef, j, k

  nameRef := "O001.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_o001", _mo_O001)
  use (destination + '_mo_O001') new alias O001
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + " - Общероссийский классификатор стран мира (OKSM)" + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        select O001
        append blank
        mArr := hb_ATokens( mo_read_xml_stroke( oXmlNode,"NAME11",), '^' )
        O001->KOD := mo_read_xml_stroke( oXmlNode,"KOD",)
        if len(mArr) == 1
          O001->NAME11 := mArr[ 1 ]
        else
          O001->NAME11 := mArr[ 1 ]
          O001->NAME12 := mArr[2]
        endif
        O001->ALFA2 := mo_read_xml_stroke( oXmlNode,"ALFA2",)
        O001->ALFA3 := mo_read_xml_stroke( oXmlNode,"ALFA3",)
        O001->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode,"DATEBEG",))
        O001->DATEEND := ctod(mo_read_xml_stroke( oXmlNode,"DATEEND",))
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function make_F006( source, destination )

  //  1 - VIDNAME(C)  2 - IDVID(N)  3 - DATEBEG(D)  4 - DATEEND(D)
  local _mo_F006 := {;
    { 'IDVID',      'N',    2,      0 },;
    { 'VIDNAME',    'M',   10,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F006.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f006', _mo_F006)
  use (destination + '_mo_f006') new alias F006
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - Классификатор видов контроля (VidExp)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        select F006
        append blank
        F006->IDVID := val(mo_read_xml_stroke( oXmlNode, 'IDVID',))
        F006->VIDNAME := mo_read_xml_stroke( oXmlNode, 'VIDNAME',)
        F006->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode, 'DATEBEG',))
        F006->DATEEND := ctod(mo_read_xml_stroke( oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function make_F010( source, destination )

  //  1 - SUBNAME(C) 2 - KOD_TF(N)  3 - OKRUG(N)  4 - KOD_OKATO(C)  5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F010 := {;
    { 'KOD_TF',     'C',    2,      0 },;
    { 'KOD_OKATO',  'C',    5,      0 },;
    { 'SUBNAME',    'C',  250,      0 },;
    { 'OKRUG',      'N',    1,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F010.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f010', _mo_F010)
  use (destination + '_mo_F010') new alias F010
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - Классификатор субъектов Российской Федерации (Subekti)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        select F010
        append blank
        F010->KOD_TF := mo_read_xml_stroke( oXmlNode, 'KOD_TF',)
        F010->KOD_OKATO := mo_read_xml_stroke( oXmlNode, 'KOD_OKATO',)
        F010->SUBNAME := mo_read_xml_stroke( oXmlNode, 'SUBNAME',)
        F010->OKRUG := val(mo_read_xml_stroke( oXmlNode, 'OKRUG',))
        F010->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode, 'DATEBEG',))
        F010->DATEEND := ctod(mo_read_xml_stroke( oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function make_F011( source, destination )

  //  1 - DOCNAME(C)  2 - IDDOC(N) 3 - DOCSER(C) 4 - DOCNUM(C) 5 - DATEBEG(D)  6 - DATEEND(D)
  local _mo_F011 := {;
    { 'IDDOC',      'N',    2,      0 },;
    { 'DOCNAME',    'C',  250,      0 },;
    { 'DOCSER',     'C',   10,      0 },;
    { 'DOCNUM',     'C',   20,      0 },;
    { 'DATEBEG',    'D',    8,      0 },;
    { 'DATEEND',    'D',    8,      0 };
  }
  local nfile, nameRef, j, k
  local mName := '', mArr

  nameRef := 'F011.xml'
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + '_mo_f011', _mo_F011)
  use (destination + '_mo_f011') new alias F011
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - Классификатор типов документов, удостоверяющих личность (Tipdoc)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if "ZAP" == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        select F011
        append blank
        F011->IDDOC := val(mo_read_xml_stroke( oXmlNode, 'IDDOC',))
        F011->DOCNAME := mo_read_xml_stroke( oXmlNode, 'DOCNAME',)
        F011->DOCSER := mo_read_xml_stroke( oXmlNode, 'DOCSER',)
        F011->DOCNUM := mo_read_xml_stroke( oXmlNode, 'DOCNUM',)
        F011->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode, 'DATEBEG',))
        F011->DATEEND := ctod(mo_read_xml_stroke( oXmlNode, 'DATEEND',))
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL

// 12.02.22
Function make_F014( source, destination )

  local _mo_F014 := {;
    {'KOD',     'N',      4,      0},;
    {'NAME',    'C',    250,      0},;
    {'OPIS',    'M',     10,      0},;
    {'DATEBEG', 'D',      8,      0},;
    {'DATEEND', 'D',      8,      0},;
    {'OSN',     'C',     20,      0};
  }
  local nfile, nameRef, j, k

  nameRef := "F014.xml"
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error(FILE_NOT_EXIST, nfile)
    return nil
  endif
  dbcreate(destination + "_mo_f014",_mo_F014)
  use (destination + '_mo_F014') new alias F014
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - Классификатор причин отказа в оплате медицинской помощи (OplOtk)' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    dbCloseAll()
    return nil
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ZAP' == upper( oXmlNode:title )
        out_obrabotka_count( j, k )
        select F014
        append blank
        F014->KOD := val( mo_read_xml_stroke( oXmlNode, 'KOD',) )
        F014->NAME := mo_read_xml_stroke( oXmlNode, 'KOMMENT',)
        F014->OPIS := mo_read_xml_stroke( oXmlNode, 'NAIM',)
        F014->DATEBEG := ctod(mo_read_xml_stroke( oXmlNode, 'DATEBEG',))
        F014->DATEEND := ctod(mo_read_xml_stroke( oXmlNode, 'DATEEND',))
        F014->OSN := mo_read_xml_stroke( oXmlNode, 'OSN',)
    
      endif
    NEXT j
  ENDIF
  out_obrabotka_eol()
  dbCloseAll()
  return NIL
