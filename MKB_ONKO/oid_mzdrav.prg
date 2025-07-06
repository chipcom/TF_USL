#include 'function.ch'
#include 'common.ch'
#include 'dict_error.ch'

// 05.07.25
function make_oid_sootv( source, destination )

  Local mkb_onko := { ;
    {'ICD10',  'C',   10, 0}, ;
    {'ICDTOP', 'C',   10, 0}, ;
    {'TNM_7',  'L',    1, 0}, ;
    {'TNM_8',  'L',    1, 0} ;
  }
  local name_file
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local k, j, k1, j1  //, klll
  local mICD10, mICD10T, mTNM7, mTNM8

  nameRef := '1.2.643.5.1.13.13.99.2.734.xml'  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    return .f.
  endif
  
  name_file := 'mkb_onko'
  // Справочники ФФОМС
  dbcreate( destination + name_file, mkb_onko )
  use ( destination + name_file ) new alias SOOT
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - Соответствие кодов МКБ-10 и кодов МКБ-О Топография для классификации TNM' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    return .f.
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ENTRIES' == upper( oXmlNode:title )
        k1 := len( oXmlNode:aItems )
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[ j1 ]
//          klll := upper( oNode1:title )
          if 'ENTRY' == upper( oNode1:title )
            out_obrabotka_count( j1, k1 )
            mICD10 := mo_read_xml_stroke( oNode1, 'ICD10', , , 'utf8' )
            mICD10T := mo_read_xml_stroke( oNode1, 'ICDOTopography', , , 'utf8' )
            mTNM7 := mo_read_xml_stroke( oNode1, 'TNM_7', , , 'utf8' )
            mTNM8 := mo_read_xml_stroke( oNode1, 'TNM_8', , , 'utf8' )
            select SOOT
            append blank
            SOOT->ICD10 := mICD10
            SOOT->ICDTOP := mICD10T
            SOOT->TNM_7 := iif( Lower( mTNM7 ) == 'true', .t., .f. )
            SOOT->TNM_8 := iif( Lower( mTNM8 ) == 'true', .t., .f. )
          endif
        next j1
      endif
    next j
  endif
  out_obrabotka_eol()

  SOOT->( dbCloseArea() )
  return nil

// 05.07.25
function make_oid_stad_TNM( source, destination )

  Local mkb_onko := { ;
    {'ID',     'N',    6, 0}, ;
    {'SHORTNAME',     'C',  100, 0}, ;
    {'ICDTOP', 'C',   50, 0}, ;
    {'MORPH',  'C',   20, 0}, ;
    {'STAGE',  'C',   20, 0}, ;
    {'TUMOR',  'C',    5, 0}, ;
    {'ID_TUMOR',  'N',    5, 0}, ;
    {'NODUS',  'C',    5, 0}, ;
    {'ID_NODUS',  'N',    5, 0}, ;
    {'METASTASIS',  'C',    5, 0}, ;
    {'ID_META',  'N',    5, 0}, ;
    {'ADDITION',  'C',    5, 0}, ;
    {'ID_ADD',  'N',    5, 0}, ;
    {'CLASSIF',  'N',    2, 0}, ;
    {'VERSION',  'N',    2, 0} ;
  }
  local name_file
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local k, j, k1, j1
  local mID, mShortName, mClassif, mVersion, mMorph, mISCDTOP
  local mStage, mTumor, mIDTumor, mNodus, mIDNodus, mMetastasis, mIDMetastasis
  local mAddition, mIDAddition

  nameRef := '1.2.643.5.1.13.13.99.2.546.xml'  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    return .f.
  endif
  
  name_file := 'stad_onko'
  // Справочники ФФОМС
  dbcreate( destination + name_file, mkb_onko )
  use ( destination + name_file ) new alias STAD
  oXmlDoc := HXMLDoc():Read( nfile )
  OutStd( nameRef + ' - TNM. Стадирование злокачественных опухолей' + hb_eol() )
  IF Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    return .f.
  else
    out_obrabotka( nfile )
    k := Len( oXmlDoc:aItems[ 1 ]:aItems )
    FOR j := 1 TO k
      oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
      if 'ENTRIES' == upper( oXmlNode:title )
        k1 := len( oXmlNode:aItems )
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[ j1 ]
          if 'ENTRY' == upper( oNode1:title )
            out_obrabotka_count( j1, k1 )
//            mAddition := ''
//            mIDAddition := ''
            mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
            mShortName := mo_read_xml_stroke( oNode1, 'ShortNameOfTopography', , , 'utf8' )
            mISCDTOP := mo_read_xml_stroke( oNode1, 'ICDOTopography', , , 'utf8' )
            mMorph := mo_read_xml_stroke( oNode1, 'Morphology', , , 'utf8' )
            mStage := mo_read_xml_stroke( oNode1, 'Stage', , , 'utf8' )
            mTumor := mo_read_xml_stroke( oNode1, 'Tumor', , , 'utf8' )
            mIDTumor := mo_read_xml_stroke( oNode1, 'ID_Tumor', , , 'utf8' )
            mNodus := mo_read_xml_stroke( oNode1, 'Nodus', , , 'utf8' )
            mIDNodus := mo_read_xml_stroke( oNode1, 'ID_Nodus', , , 'utf8' )
            mMetastasis := mo_read_xml_stroke( oNode1, 'Metastasis', , , 'utf8' )
            mIDMetastasis := mo_read_xml_stroke( oNode1, 'ID_Metastasis', , , 'utf8' )
            mAddition := mo_read_xml_stroke( oNode1, 'Addition', , , 'utf8' )
            mIDAddition := mo_read_xml_stroke( oNode1, 'ID_Addition', , , 'utf8' )

            mClassif := mo_read_xml_stroke( oNode1, 'Classification', , , 'utf8' )
            mVersion := mo_read_xml_stroke( oNode1, 'Version', , , 'utf8' )
            select STAD
            append blank
            STAD->ID := val( mID )
            STAD->SHORTNAME := mShortName
            STAD->ICDTOP := mISCDTOP
            STAD->MORPH := mMorph
            STAD->STAGE := mStage
            STAD->TUMOR := mTumor
            STAD->ID_TUMOR := val( mIDTumor )
            STAD->NODUS := mNodus
            STAD->ID_NODUS := val( mIDNodus )
            STAD->METASTASIS := mMetastasis
            STAD->ID_META := val( mIDMetastasis )
            STAD->ADDITION := mAddition
            STAD->ID_ADD := val( mIDAddition )
            STAD->CLASSIF := val( mClassif )
            STAD->VERSION := val( mVersion )
          endif
        next j1
      endif
    next j
  endif
  out_obrabotka_eol()
  STAD->( dbCloseArea() )
  return nil