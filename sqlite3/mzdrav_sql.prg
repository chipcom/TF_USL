// Справочники Министерства здравоохранения РФ

#include 'function.ch'
#include 'dict_error.ch'

#include 'simpleio.ch'
#include 'dbinfo.ch'

#require 'hbsqlit3'

#require 'rddsql'
#require 'sddodbc'

REQUEST SDDODBC, SQLMIX 
REQUEST HB_CODEPAGE_RU1251

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 16.07.25
Function make_mzdrav( db, source )

//  make_uslugi_mz(db, source) // не используем (для будующего)
  make_ed_izm( db, source )       // справочник единиц измерения
  make_severity( db, source )   // справочник тяжести заболевания
  make_implant( db, source )      // справочник имплантов
  make_MethIntro( db, source )    // справочник способов введения лекарственных препаратов
  make_mzrf798( db, source )    // справочник характеристик высвобождения активных веществ из лекарственных препаратов
  make_mkb_mkbo( db, source )    // справочник Соответствие кодов МКБ-10 и кодов МКБ-О Топография для классификации TNM
  make_onko_stad( db, source )    // справочник TNM. Стадирование злокачественных опухолей
  Return Nil

// 07.08.25
function make_onko_stad( db, source )

  Local cmdText
  Local nfile, nameRef
  Local mID, mShort, mICDTop, mMorph, mStage, mTumor, mIDTumor
  Local mNodus, mIDNodus, mMetastasis, mIDMetastasis
  Local mClassif, mVersion
  Local mIDAddition, mAddition  // пока не используем
  Local count := 0, cmdTextInsert := textBeginTrans
  Local cAlias

  // 1) ID, Код, Целочисленное, обязательное поле, Обязательное;
  // 2) ShortNameOfTopography, Краткое наименование топографии, Строковое, обязательное поле,
  // Обязательное;
  // 3) ICDOTopography, МКБ-О Топография, Строковое, соответствует уникальному идентификатору
  // записи справочника «МКБ-О-3 Топография» (OID: 1.2.643.5.1.13.13.11.1487);
  // 4) Morphology, Гистологическая группа, Строковое, обязательное поле, Обязательное;
  // 5) Stage, Стадирование по TNM, Строковое, обязательное поле, Обязательное;
  // 6) Tumor, Tumor, Строковое, обязательное поле, Обязательное;
  // 7) ID_Tumor, Код Tumor, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 8) Nodus, Nodus, Строковое, необязательное поле;
  // 9) ID_Nodus, Код Nodus, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 10) Metastasis, Metastasis, Строковое, обязательное поле, Обязательное;
  // 11) ID_Metastasis, Код Metastasis, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 12) Addition, Дополнительная информация, Строковое, необязательное поле;
  // 13) ID_Addition, Код дополнительной информации, Целочисленное, соответствует уникальному
  // идентификатору записи справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 14) Classification, Вид классификации, Целочисленное, обязательное поле
  // Возможные виды классификации:
  //  1 – клиническая,
  //  2 – патологоанатомическая,
  //  3 – клиническая и патологоанатомическая.;
  // 15) Version, Версия TNM, Целочисленное, обязательное поле, Обязательное;

  #if defined( __HBSCRIPT__HBSHELL ) 
    rddRegister( 'SQLBASE' ) 
    rddRegister( 'SQLMIX' ) 
    hb_SDDODBC_Register() 
  #endif 

  // Логическое храним как целое 0 - false, 1 - true
  cmdText := 'CREATE TABLE onko_stad( id INTEGER PRIMARY KEY NOT NULL, icdtop TEXT(10), stage TEXT(5), '
  cmdText += 'id_tumor INTEGER, id_nodus INTEGER, id_metastas INTEGER, versionTNM INTEGER)'
//  cmdText += 'id_addition INTEGER, classification INTEGER, versionTNM INTEGER)'

  nameRef := '1.2.643.5.1.13.13.99.2.546.csv'  // может меняться из-за версий
  nameRef := '123.csv'  // может меняться из-за версий
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - TNM. Стадирование злокачественных опухолей', 'RU866' )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS onko_stad' ) == SQLITE_OK
    OutStd( 'DROP TABLE onko_stad - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE onko_stad - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE onko_stad - False' + hb_eol() )
    Return Nil
  Endif

  cAlias := 'XLS_STAD'
  rddSetDefault( 'SQLMIX' ) 
  // ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=TEST1.XLS;' })
  ? 'Connect:', rddInfo( RDDI_CONNECT, { 'ODBC', 'Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq=onko123.xls;' })
  ? 'Use:', dbUseArea( .T., , 'select * from [111$] ', cAlias ) //'XL_PCEL') 
  ? 'Alias:', Alias() 

  ( cAlias )->( dbGoto( 3 ) )
  DO WHILE ! ( cAlias )->( Eof() )
//?( cAlias )->( Recno() )
    mID := str( ( cAlias )->( fieldget( 1 ) ) )
    mShort := ( ( cAlias )->( fieldget( 2 ) ) )
    mICDTOP := ( ( cAlias )->( fieldget( 3 ) ) )
    mMorph := ( ( cAlias )->( fieldget( 4 ) ) )
    mStage := ( ( cAlias )->( fieldget( 5 ) ) )
    mTumor := ( ( cAlias )->( fieldget( 6 ) ) )
    mIDTumor := ( ( cAlias )->( fieldget( 7 ) ) )
    if ValType( mIDTumor ) == 'N'
      mIDTumor := str( mIDTumor )
    endif

    mNodus := ( ( cAlias )->( fieldget( 8 ) ) )
    mIDNodus := ( ( cAlias )->( fieldget( 9 ) ) )
    if Empty( mIDNodus )
      mIDNodus := '0'
    endif
    if ValType( mIDNodus ) == 'N'
      mIDNodus := str( mIDNodus )
    endif
    mMetastasis := ( ( cAlias )->( fieldget( 10 ) ) )
    mIDMetastasis := ( ( cAlias )->( fieldget( 11 ) ) )
    if ValType( mIDMetastasis ) == 'N'
      mIDMetastasis := str( mIDMetastasis )
    endif
    mAddition := ( ( cAlias )->( fieldget( 12 ) ) )
    mIDAddition := ( ( cAlias )->( fieldget( 13 ) ) )
    mClassif := ( ( cAlias )->( fieldget( 14 ) ) )
    mVersion := ( ( cAlias )->( fieldget( 15 ) ) )
    if ValType( mVersion ) == 'N'
      mVersion := str( mVersion )
    endif

    count++
    cmdTextInsert := cmdTextInsert + "INSERT INTO onko_stad( id, icdtop, stage, "
    cmdTextInsert += "id_tumor, id_nodus, id_metastas, versionTNM ) VALUES( "
    cmdTextInsert += "" + mID + ","
    cmdTextInsert += "'" + mICDTop + "',"
    cmdTextInsert += "'" + mStage + "',"
    cmdTextInsert += "" + mIDTumor + ","
    cmdTextInsert += "" + mIDNodus + ","
    cmdTextInsert += "" + mIDMetastasis + "," //");"
    cmdTextInsert += "" + mVersion + ");"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
    ( cAlias )->( dbSkip() )
  enddo

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  out_obrabotka_eol()
  return nil

// 17.07.28
function make_onko_stad_2( db, source )

  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mShort, mICDTop, mMorph, mStage, mTumor, mIDTumor
  Local mNodus, mIDNodus, mMetastasis, mIDMetastasis
  Local mClassif, mVersion
  Local mIDAddition, mAddition  // пока не используем
  Local count := 0, cmdTextInsert := textBeginTrans
  Local mArr, cAlias, tStr, ic

  // 1) ID, Код, Целочисленное, обязательное поле, Обязательное;
  // 2) ShortNameOfTopography, Краткое наименование топографии, Строковое, обязательное поле,
  // Обязательное;
  // 3) ICDOTopography, МКБ-О Топография, Строковое, соответствует уникальному идентификатору
  // записи справочника «МКБ-О-3 Топография» (OID: 1.2.643.5.1.13.13.11.1487);
  // 4) Morphology, Гистологическая группа, Строковое, обязательное поле, Обязательное;
  // 5) Stage, Стадирование по TNM, Строковое, обязательное поле, Обязательное;
  // 6) Tumor, Tumor, Строковое, обязательное поле, Обязательное;
  // 7) ID_Tumor, Код Tumor, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 8) Nodus, Nodus, Строковое, необязательное поле;
  // 9) ID_Nodus, Код Nodus, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 10) Metastasis, Metastasis, Строковое, обязательное поле, Обязательное;
  // 11) ID_Metastasis, Код Metastasis, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 12) Addition, Дополнительная информация, Строковое, необязательное поле;
  // 13) ID_Addition, Код дополнительной информации, Целочисленное, соответствует уникальному
  // идентификатору записи справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 14) Classification, Вид классификации, Целочисленное, обязательное поле
  // Возможные виды классификации:
  //  1 – клиническая,
  //  2 – патологоанатомическая,
  //  3 – клиническая и патологоанатомическая.;
  // 15) Version, Версия TNM, Целочисленное, обязательное поле, Обязательное;

  // Логическое храним как целое 0 - false, 1 - true
  cmdText := 'CREATE TABLE onko_stad( id INTEGER PRIMARY KEY NOT NULL, icdtop TEXT(10), stage TEXT(5), '
  cmdText += 'id_tumor INTEGER, id_nodus INTEGER, id_metastas INTEGER)'
//  cmdText += 'id_addition INTEGER, classification INTEGER, versionTNM INTEGER)'

//  nameRef := '1.2.643.5.1.13.13.99.2.546.csv'  // может меняться из-за версий
  nameRef := '123.csv'  // может меняться из-за версий
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - TNM. Стадирование злокачественных опухолей', 'RU866' )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS onko_stad' ) == SQLITE_OK
    OutStd( 'DROP TABLE onko_stad - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE onko_stad - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE onko_stad - False' + hb_eol() )
    Return Nil
  Endif

//  ic := 0
  cAlias := 'CSV'
  dbUseArea( .t., 'FCOMMA', nfile, cAlias, .f., .f. )
  ( cAlias )->( dbGoto( 2 ) )
//  ( cAlias )->( dbGoto( 6502 ) )
  DO WHILE ! ( cAlias )->( Eof() )
    tStr := ( cAlias )->( FIELD->LINE )
    tStr := hb_strReplace( tStr, '"', '' )

    mArr := split( tStr, ';' )
    mID := alltrim( mArr[ 1 ] )
    mShort := alltrim( mArr[ 2 ] )
    mICDTOP := alltrim( mArr[ 3 ] )
    mMorph := alltrim( mArr[ 4 ] )
    mStage := alltrim( mArr[ 5 ] )
    mTumor := alltrim( mArr[ 6 ] )
    mIDTumor := alltrim( mArr[ 7 ] )
    mNodus := alltrim( mArr[ 8 ] )
    mIDNodus := alltrim( mArr[ 9 ] )
    mMetastasis := alltrim( mArr[ 10 ] )
    mIDMetastasis := alltrim( mArr[ 11 ] )
    mAddition := alltrim( mArr[ 12 ] )
    mIDAddition := alltrim( mArr[ 13 ] )
    mClassif := alltrim( mArr[ 14 ] )
    mVersion := alltrim( mArr[ 15 ] )

    count++
    cmdTextInsert := cmdTextInsert + "INSERT INTO onko_stad( id, icdtop, stage, "
    cmdTextInsert += "id_tumor, id_nodus, id_metastas ) VALUES( "
    cmdTextInsert += "" + mID + ","
    cmdTextInsert += "'" + mICDTop + "',"
    cmdTextInsert += "'" + mStage + "',"
    cmdTextInsert += "" + mIDTumor + ","
    cmdTextInsert += "" + mIDNodus + ","
    cmdTextInsert += "" + mIDMetastasis + ");"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      if ( ic := sqlite3_exec( db, cmdTextInsert ) ) != SQLITE_OK
        ? sqlite3_errstr( ic )
//altd()
      endif
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
    ( cAlias )->( dbSkip() )
//    mArr := nil
  enddo

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
inkey(0)
  out_obrabotka_eol()
  return nil

// 17.07.28
function make_onko_stad_1( db, source )

  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mShort, mICDTop, mMorph, mStage, mTumor, mIDTumor
  Local mNodus, mIDNodus, mMetastasis, mIDMetastasis
  Local mClassif, mVersion
  Local mIDAddition, mAddition  // пока не используем
  Local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, Код, Целочисленное, обязательное поле, Обязательное;
  // 2) ShortNameOfTopography, Краткое наименование топографии, Строковое, обязательное поле,
  // Обязательное;
  // 3) ICDOTopography, МКБ-О Топография, Строковое, соответствует уникальному идентификатору
  // записи справочника «МКБ-О-3 Топография» (OID: 1.2.643.5.1.13.13.11.1487);
  // 4) Morphology, Гистологическая группа, Строковое, обязательное поле, Обязательное;
  // 5) Stage, Стадирование по TNM, Строковое, обязательное поле, Обязательное;
  // 6) Tumor, Tumor, Строковое, обязательное поле, Обязательное;
  // 7) ID_Tumor, Код Tumor, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 8) Nodus, Nodus, Строковое, необязательное поле;
  // 9) ID_Nodus, Код Nodus, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 10) Metastasis, Metastasis, Строковое, обязательное поле, Обязательное;
  // 11) ID_Metastasis, Код Metastasis, Целочисленное, соответствует уникальному идентификатору записи
  // справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 12) Addition, Дополнительная информация, Строковое, необязательное поле;
  // 13) ID_Addition, Код дополнительной информации, Целочисленное, соответствует уникальному
  // идентификатору записи справочника «TNM. Описание категорий» (OID: 1.2.643.5.1.13.13.99.2.547);
  // 14) Classification, Вид классификации, Целочисленное, обязательное поле
  // Возможные виды классификации:
  //  1 – клиническая,
  //  2 – патологоанатомическая,
  //  3 – клиническая и патологоанатомическая.;
  // 15) Version, Версия TNM, Целочисленное, обязательное поле, Обязательное;

  // Логическое храним как целое 0 - false, 1 - true
/*  // пока не используем
  cmdText := 'CREATE TABLE onko_stad( id INTEGER PRIMARY KEY NOT NULL, shortname TEXT(100), icdtop TEXT(10), morph TEXT(20), stage TEXT(5), '
  cmdText += 'tumor TEXT(5), id_tumor INTEGER, nodus TEXT(5), id_nodus INTEGER, metastas TEXT(5), id_metastas INTEGER, '
  cmdText += 'addition TEXT(5), id_addition INTEGER, classification INTEGER, versionTNM INTEGER)'
*/
  cmdText := 'CREATE TABLE onko_stad( id INTEGER PRIMARY KEY NOT NULL, icdtop TEXT(10), stage TEXT(5), '
  cmdText += 'id_tumor INTEGER, id_nodus INTEGER, id_metastas INTEGER, '
  cmdText += 'id_addition INTEGER, classification INTEGER, versionTNM INTEGER)'

  nameRef := '1.2.643.5.1.13.13.99.2.546.xml'  // может меняться из-за версий
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - TNM. Стадирование злокачественных опухолей', 'RU866' )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS onko_stad' ) == SQLITE_OK
    OutStd( 'DROP TABLE onko_stad - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE onko_stad - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE onko_stad - False' + hb_eol() )
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
       If "ENTRIES" == Upper( oXmlNode:title )
         k1 := Len( oXmlNode:aItems )
         For j1 := 1 To k1
           oNode1 := oXmlNode:aItems[ j1 ]
           If "ENTRY" == Upper( oNode1:title )
              mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
              mShort := mo_read_xml_stroke( oNode1, 'ShortNameOfTopography', , , 'utf8' )
              mICDTOP := mo_read_xml_stroke( oNode1, 'ICDOTopography', , , 'utf8' )
              mMorph := mo_read_xml_stroke( oNode1, 'Morphology', , , 'utf8' )
              mStage := mo_read_xml_stroke( oNode1, 'Stage', , , 'utf8' )
              mTumor := mo_read_xml_stroke( oNode1, 'Tumor', , , 'utf8' )
              mIDTumor := mo_read_xml_stroke( oNode1, 'ID_Tumor', , , 'utf8' )
              mNodus := mo_read_xml_stroke( oNode1, 'Nodus', , , 'utf8' )
              mIDNodus := mo_read_xml_stroke( oNode1, 'ID_Nodus', , , 'utf8' )
              mMetastasis := mo_read_xml_stroke( oNode1, 'Metastasis', , , 'utf8' )
              mIDMetastasis := mo_read_xml_stroke( oNode1, 'ID_Metastasis', , , 'utf8' )
              mAddition := mo_read_xml_stroke( oNode1, 'Addition', , , 'utf8' )  // пока не используем
              mIDAddition := mo_read_xml_stroke( oNode1, 'ID_Addition', , , 'utf8' )
              mClassif := mo_read_xml_stroke( oNode1, 'Classification', , , 'utf8' )
              mVersion := mo_read_xml_stroke( oNode1, 'Version', , , 'utf8' )

            count++
/*            // пока не используем
            cmdTextInsert := cmdTextInsert + "INSERT INTO onko_stad( id, shortname, icdtop, morph, stage, "
            cmdTextInsert += "tumor, id_tumor, nodus, id_nodus, metastas, id_metastas, "
            cmdTextInsert += "addition, id_addition, classification, versionTNM ) VALUES("
*/

            cmdTextInsert := cmdTextInsert + "INSERT INTO onko_stad( id, icdtop, stage, "
            cmdTextInsert += "id_tumor, id_nodus, id_metastas, "
            cmdTextInsert += "id_addition, classification, versionTNM ) VALUES("
            cmdTextInsert += "" + mID + ","
//            cmdTextInsert += "'" + mShort + "',"
            cmdTextInsert += "'" + mICDTop + "',"
//            cmdTextInsert += "'" + mMorph + "',"
            cmdTextInsert += "'" + mStage + "',"
//            cmdTextInsert += "'" + mTumor + "',"
            cmdTextInsert += "" + mIDTumor + ","
//            cmdTextInsert += "'" + mNodus + "',"
            cmdTextInsert += "" + mIDNodus + ","
//            cmdTextInsert += "'" + mMetastasis + "',"
            cmdTextInsert += "" + mIDMetastasis + ","
//            cmdTextInsert += "'" + mAddition + "',"  // пока не используем
            cmdTextInsert += "" + iif( Empty( mIDAddition ), 'NULL', mIDAddition ) + ","  // пока не используем
            cmdTextInsert += "" + mClassif + ","
            cmdTextInsert += "" + mVersion + ");"
            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              count := 0
              cmdTextInsert := textBeginTrans
            Endif
           Endif
         Next j1
       Endif
     Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  return nil

// 07.07.25
function make_mkb_mkbo( db, source )

  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1
  Local oXmlDoc, oXmlNode, oNode1
  Local mICD10, mICD10T, mTNM7, mTNM8
  Local count := 0, cmdTextInsert := textBeginTrans

  // 1) ICD10, Код МКБ-10, Строковое, обязательное поле, Обязательное;
  // 2) ICDOTopography, Код МКБ-О Топография, Строковое, обязательное поле, Обязательное;
  // 3) TNM_7, TNM 7 версия, Логическое;
  // 4) TNM_8, TNM 8 версия, Логическое;
  
  // Логическое храним как целое 0 - false, 1 - true
  cmdText := 'CREATE TABLE mkb_mkbo( icd10 TEXT(10) PRIMARY KEY NOT NULL, icd10top TEXT(10), tnm_7 INTEGER, tnm_8 INTEGER)'

  nameRef := '1.2.643.5.1.13.13.99.2.734.xml'  // может меняться из-за версий
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Соответствие кодов МКБ-10 и кодов МКБ-О Топография для классификации TNM', 'RU866' )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS mkb_mkbo' ) == SQLITE_OK
    OutStd( 'DROP TABLE mkb_mkbo - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE mkb_mkbo - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE mkb_mkbo - False' + hb_eol() )
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
       If "ENTRIES" == Upper( oXmlNode:title )
         k1 := Len( oXmlNode:aItems )
         For j1 := 1 To k1
           oNode1 := oXmlNode:aItems[ j1 ]
           If "ENTRY" == Upper( oNode1:title )
              mICD10 := mo_read_xml_stroke( oNode1, 'ICD10', , , 'utf8' )
              mICD10T := mo_read_xml_stroke( oNode1, 'ICDOTopography', , , 'utf8' )
              mTNM7 := iif( lower( mo_read_xml_stroke( oNode1, 'TNM_7', , , 'utf8' ) ) == 'true', '1', '0' )
              mTNM8 := iif( lower( mo_read_xml_stroke( oNode1, 'TNM_8', , , 'utf8' ) ) == 'true', '1', '0' )

            count++
            cmdTextInsert := cmdTextInsert + "INSERT INTO mkb_mkbo( icd10, icd10top, tnm_7, tnm_8 ) VALUES("
            cmdTextInsert += "'" + mICD10 + "',"
            cmdTextInsert += "'" + mICD10T + "',"
            cmdTextInsert += "" + mTNM7 + ","
            cmdTextInsert += "" + mTNM8 + ");"
            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              count := 0
              cmdTextInsert := textBeginTrans
            Endif
           Endif
         Next j1
       Endif
     Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 08.01.25
function make_mzrf798( db, source )

  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1, j2, k2
  Local oXmlDoc, oXmlNode, oNode1, oNode2
  Local mID, mName, mNameEng, mComment
  Local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, Код, Целочисленное, уникальный идентификатор, обязательное поле, целое число, Обязательное;
  // 2) ReleaseCharacteristic, Характеристика высвобождения, Строковое, описывает отличие высвобождения действующего вещества по скорости, времени, месту в сравнении с обычным высвобождением того же самого вещества, без модификации;
  // 3) ReleaseCharacteristic_Engl, ЕврФармакопея_англ, Строковое, характеристика высвобождения (английский язык);
  // 4) Comment, Комментарий, Строковое;
//  // 5) NSI_Code_EEC, Код справочника ЕАЭК, Строковое, необязательное поле – код справочника реестра НСИ ЕАЭК;
//  // 6) NSI_element_Code_EEC, Код элемента справочника ЕАЭК, Строковое, необязательное поле – код элемента справочника реестра НСИ ЕАЭК;  

  cmdText := 'CREATE TABLE mzrf798( id INTEGER PRIMARY KEY NOT NULL, name TEXT(20), nameEng TEXT(20), comment TEXT(250) )'

  nameRef := '1.2.643.5.1.13.13.99.2.798.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Характеристики высвобождения активных веществ из лекарственных препаратов', 'RU866' )
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS mzrf798' ) == SQLITE_OK
    OutStd( 'DROP TABLE mzrf798 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE mzrf798 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE mzrf798 - False' + hb_eol() )
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
      If "ENTRIES" == Upper( oXmlNode:title )
        k1 := Len( oXmlNode:aItems )
        For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          If "ENTRY" == Upper( oNode1:title )
            k2 := Len( oNode1:aItems )
            for j2 := 1 to k2
              oNode2 := oNode1:aItems[ j2 ]
              If "DATA" == Upper( oNode2:title )
                mID := mo_read_xml_stroke( oNode2, 'ID', , , 'utf8' )
                mComment := mo_read_xml_stroke( oNode2, 'Comment', , , 'utf8' )
                mNameEng := mo_read_xml_stroke( oNode2, 'ReleaseCharacteristic_Engl', , , 'utf8' )
                mName := mo_read_xml_stroke( oNode2, 'ReleaseCharacteristic', , , 'utf8' )
              Endif
            next j2

            count++
            cmdTextInsert := cmdTextInsert + "INSERT INTO mzrf798 ( id, name, nameEng, comment ) VALUES("
            cmdTextInsert += "" + mID + ","
            cmdTextInsert += "'" + mName + "',"
            cmdTextInsert += "'" + mNameEng + "',"
            cmdTextInsert += "'" + mComment + "');"
            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              count := 0
              cmdTextInsert := textBeginTrans
            Endif
          Endif
        Next j1
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 04.01.25
Function make_implant( db, source )

  Local cmdText, cmdTextTMP
  Local k, j, k1, j1
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mName, mRZN, mParent
  Local count := 0, cmdTextInsert := textBeginTrans, cmdTextInsertTMP := textBeginTrans

  // 1)ID, Код , уникальный идентификатор записи;
  // 2)RZN, Росздравнадзор , код изделия согласно Номенклатурному классификатору Росздравнадзора;
  // 3)PARENT, Код родительского элемента;
  // 4)NAME, Наименование , наименование вида изделия;
  // 5)ACTUAL, Актуальность, Логический;
  // 6)EXISTENCE_NPA, Признак наличия НПА, Логический
  // // 5)LOCALIZATION, Локализация , анатомическая область, к которой относится локализация и/или действие изделия;
  // // 6)MATERIAL, Материал , тип материала, из которого изготовлено изделие;
  // // 7)METAL, Металл , признак наличия металла в изделии;
  // // 8)SCTID, Код SNOMED CT , уникальный код по номенклатуре клинических терминов SNOMED CT;
  // // 9)ORDER, Порядок сортировки ;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  cmdText := 'CREATE TABLE implantant(id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), type TEXT(1))'

  nameRef := '1.2.643.5.1.13.13.11.1079.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями (OID)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE implantant' ) == SQLITE_OK
    OutStd( 'DROP TABLE implantant - Ok' + hb_eol() )
  else
    OutStd( 'DROP TABLE implantant - False' + hb_eol() )
  Endif
  If sqlite3_exec( db, 'DROP TABLE tmp' ) == SQLITE_OK
    OutStd( 'DROP TABLE tmp - Ok' + hb_eol() )
  else
    OutStd( 'DROP TABLE tmp - False' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE implantant - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE implantant - False' + hb_eol() )
    Return Nil
  Endif

  // временная таблица для дальнейшего использования
  cmdTextTMP := 'CREATE TABLE tmp(id INTEGER, parent INTEGER)'
  If sqlite3_exec( db, cmdTextTMP ) == SQLITE_OK
    OutStd( 'CREATE TABLE tmp - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE tmp - False' + hb_eol() )
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
      If "ENTRIES" == Upper( oXmlNode:title )
        k1 := Len( oXmlNode:aItems )
        For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          If "ENTRY" == Upper( oNode1:title )
            mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
            mRZN := mo_read_xml_stroke( oNode1, 'RZN', , , 'utf8' )
            mParent := mo_read_xml_stroke( oNode1, 'PARENT', , , 'utf8' )
            mName := mo_read_xml_stroke( oNode1, 'NAME', , , 'utf8' )

            count++
            cmdTextInsert := cmdTextInsert + "INSERT INTO implantant (id, rzn, parent, name, type) VALUES( "
            cmdTextInsert += "'" + mID + "',"
            cmdTextInsert += "'" + mRZN + "',"
            cmdTextInsert += "'" + mParent + "',"
            cmdTextInsert += "'" + mName + "',"
            cmdTextInsert += "''); "

            cmdTextInsertTMP := cmdTextInsertTMP + "INSERT INTO tmp ( id, parent ) VALUES( "
            cmdTextInsertTMP += "'" + mID + "',"
            cmdTextInsertTMP += "'" + mParent + "'); "

            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              cmdTextInsertTMP += textCommitTrans
              sqlite3_exec( db, cmdTextInsertTMP )
              count := 0
              cmdTextInsert := textBeginTrans
              cmdTextInsertTMP := textBeginTrans
            Endif
          Endif
        Next j1
      Endif
    Next j

    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      cmdTextInsertTMP += textCommitTrans
      sqlite3_exec( db, cmdTextInsertTMP )
    Endif

    cmdText := "UPDATE implantant SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent);"
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( hb_eol() + cmdText + ' - Ok' + hb_eol() )
    Else
      OutErr( hb_eol() + cmdText + ' - False' + hb_eol() )
    Endif
    cmdText := "UPDATE implantant SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent);"
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( hb_eol() + cmdText + ' - Ok' + hb_eol() )
    Else
      OutErr( hb_eol() + cmdText + ' - False' + hb_eol() )
    Endif
    cmdText := 'UPDATE implantant SET type = "O" WHERE rzn = 0;'
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( hb_eol() + cmdText + ' - Ok' + hb_eol() )
    Else
      OutErr( hb_eol() + cmdText + ' - False' + hb_eol() )
    Endif
    sqlite3_exec( db, 'DROP TABLE tmp' )
  Endif
  Return Nil

// 29.12.24
Function make_severity( db, source )

  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mName, mSYN, mSCTID, mSort
  Local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, Код , Целочисленный, уникальный идентификатор, возможные значения – целые числа от 1 до 6;
  // 2) NAME, Полное название, Строчный, обязательное поле, текстовый формат;
  // 3) SYN, Синонимы, Строчный, синонимы терминов справочника, текстовый формат;
  // 4) SCTID, Код SNOMED CT , Строчный, соответствующий код номенклатуры;
  // 5) SORT, Сортировка , Целочисленный, приведение данных к порядковой шкале для упорядочивания терминов
  // справочника от более легкой к более тяжелой степени тяжести состояний, целое число от 1 до 7;
  cmdText := 'CREATE TABLE Severity( id INTEGER PRIMARY KEY NOT NULL, name TEXT(40), syn TEXT(50), sctid INTEGER, sort INTEGER )'

  nameRef := '1.2.643.5.1.13.13.11.1006.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Степень тяжести состояния пациента (OID)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS Severity' ) == SQLITE_OK
    OutStd( 'DROP TABLE Severity - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE Severity - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE Severity - False' + hb_eol() )
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
      If "ENTRIES" == Upper( oXmlNode:title )
        k1 := Len( oXmlNode:aItems )
        For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          If "ENTRY" == Upper( oNode1:title )
            mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
            mName := mo_read_xml_stroke( oNode1, 'NAME', , , 'utf8' )
            mSYN := mo_read_xml_stroke( oNode1, 'SYN', , , 'utf8' )
            mSCTID := mo_read_xml_stroke( oNode1, 'SCTID', , , 'utf8' )
            mSort := mo_read_xml_stroke( oNode1, 'SORT', , , 'utf8' )

            count++
            cmdTextInsert := cmdTextInsert + "INSERT INTO Severity ( id, name, syn, sctid, sort ) VALUES("
            cmdTextInsert += "" + mID + ","
            cmdTextInsert += "'" + mName + "',"
            cmdTextInsert += "'" + mSyn + "',"
            cmdTextInsert += "'" + mSCTID + "',"
            cmdTextInsert += "'" + mSort + "');"
            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              count := 0
              cmdTextInsert := textBeginTrans
            Endif
          Endif
        Next j1
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil

// 29.12.24
Function make_ed_izm( db, source )

  Local cmdText
  Local oXmlDoc, oXmlNode, oNode1
  Local nfile, nameRef
  Local k, j, k1, j1
  Local mID, mFullName, mShortName
  Local count := 0, cmdTextInsert := textBeginTrans

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
  // cmdText := 'CREATE TABLE ed_izm( id INTEGER, fullname TEXT(40), ' + ;
  // 'shortname TEXT(25), prnname TEXT(25), measur TEXT(45), ucum TEXT(15), coef TEXT(15), ' + ;
  // 'conv_id INTEGER, conv_nam TEXT(25), okei_cod INTEGER )'
  cmdText := 'CREATE TABLE ed_izm(id INTEGER, fullname TEXT(40), shortname TEXT(25))'

  nameRef := '1.2.643.5.1.13.13.11.1358.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Единицы измерения (OID)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS ed_izm' ) == SQLITE_OK
    OutStd( 'DROP TABLE ed_izm - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE ed_izm - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE ed_izm - False' + hb_eol() )
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
      If 'ENTRIES' == Upper( oXmlNode:title )
        k1 := Len( oXmlNode:aItems )
        For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          If 'ENTRY' == Upper( oNode1:title )
            mID := mo_read_xml_stroke( oNode1, 'ID', , , 'UTF8' )
            mFullName := mo_read_xml_stroke( oNode1, 'FULLNAME', , , 'UTF8' )
            mShortName := mo_read_xml_stroke( oNode1, 'SHORTNAME', , , 'UTF8' )

            count++
            cmdTextInsert := cmdTextInsert + 'INSERT INTO ed_izm (id, fullname, shortname) VALUES('
            cmdTextInsert += '' + mID + ','
            cmdTextInsert += '"' + mFullName + '",'
            cmdTextInsert += iif( val( mID ) != 28, '"' + mShortName + '");', "'" + mShortName + "');" )

            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              count := 0
              cmdTextInsert := textBeginTrans
            Endif
          Endif
        Next j1
      Endif
    Next j
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif
  out_obrabotka_eol()
  Return Nil


// 04.01.25
Function make_methintro( db, source )

  Local cmdText, cmdTextTMP
  Local k, j, k1, j1
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mNameRus, mNameEng, mParent, klll
  Local count := 0, cmdTextInsert := textBeginTrans, cmdTextInsertTMP := textBeginTrans

  // 1) ID, Код, Целочисленный, уникальный идентификатор, обязательное поле, целое число;
  // 2) NAME_RUS, Путь введения на русском языке, Строчный, наименование пути введения лекарственных средств на русском языке, обязательное поле, текстовый формат;
  // 3) NAME_ENG, Путь введения на английском языке, Строчный, наименование пути введения лекарственных средств на английском языке, обязательное поле, текстовый формат;
  // 4) PARENT, Родительский узел, Целочисленный, родительский узел иерархического справочника, целое число;
  // // 5) NSI_CODE_EEC, Код справочника ЕАЭК, Строчный, необязательное поле – код справочника реестра НСИ ЕАЭК;
  // // 6) NSI_ELEMENT_CODE_EEC, Код элемента справочника ЕАЭК, Строчный, необязательное поле – код элемента справочника реестра НСИ ЕАЭК;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  cmdText := 'CREATE TABLE MethIntro(id INTEGER, name_rus TEXT(30), name_eng TEXT(30), parent INTEGER, type TEXT(1))'

  nameRef := "1.2.643.5.1.13.13.11.1468.xml"
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Пути введения лекарственных препаратов, в том числе для льготного обеспечения граждан лекарственными средствами (MethIntro)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE MethIntro' ) == SQLITE_OK
    OutStd( 'DROP TABLE MethIntro - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE MethIntro - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE MethIntro - False' + hb_eol() )
    Return Nil
  Endif

  // временная таблица для дальнейшего использования
  If sqlite3_exec( db, 'DROP TABLE tmp' ) == SQLITE_OK
    OutStd( 'DROP TABLE tmp - Ok' + hb_eol() )
  Endif
  cmdTextTMP := 'CREATE TABLE tmp( id INTEGER, parent INTEGER )'
  If sqlite3_exec( db, cmdTextTMP ) == SQLITE_OK
    OutStd( 'CREATE TABLE tmp - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE tmp - False' + hb_eol() )
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
      If "ENTRIES" == Upper( oXmlNode:title )
        k1 := Len( oXmlNode:aItems )
        For j1 := 1 To k1
          oNode1 := oXmlNode:aItems[ j1 ]
          klll := Upper( oNode1:title )
          If "ENTRY" == Upper( oNode1:title )
            mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
            mNameRus := mo_read_xml_stroke( oNode1, 'NAME_RUS', , , 'utf8' )
            mNameEng := mo_read_xml_stroke( oNode1, 'NAME_ENG', , , 'utf8' )
            mParent := mo_read_xml_stroke( oNode1, 'PARENT', , , 'utf8' )

            count++
            cmdTextInsert := cmdTextInsert + "INSERT INTO MethIntro (id, name_rus, name_eng, parent, type) VALUES( "
            cmdTextInsert += "'" + mID + "',"
            cmdTextInsert += "'" + mNameRus + "',"
            cmdTextInsert += "'" + mNameEng + "',"
            cmdTextInsert += "'" + mParent + "',"
            cmdTextInsert += "''); "
  
            cmdTextInsertTMP := cmdTextInsertTMP + "INSERT INTO tmp ( id, parent ) VALUES( "
            cmdTextInsertTMP += "'" + mID + "',"
            cmdTextInsertTMP += "'" + mParent + "'); "
  
            If count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec( db, cmdTextInsert )
              cmdTextInsertTMP += textCommitTrans
              sqlite3_exec( db, cmdTextInsertTMP )
              count := 0
              cmdTextInsert := textBeginTrans
              cmdTextInsertTMP := textBeginTrans
            Endif
          Endif
        Next j1
      Endif
    Next j
  Endif

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
    cmdTextInsertTMP += textCommitTrans
    sqlite3_exec( db, cmdTextInsertTMP )
  Endif

  cmdText := "UPDATE MethIntro SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE MethIntro.id = tmp.parent)"
  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( hb_eol() + cmdText + ' - Ok' + hb_eol() )
  Else
    OutErr( hb_eol() + cmdText + ' - False' + hb_eol() )
  Endif
  cmdText := "UPDATE MethIntro SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE MethIntro.id = tmp.parent)"
  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( hb_eol() + cmdText + ' - Ok' + hb_eol() )
  Else
    OutErr( hb_eol() + cmdText + ' - False' + hb_eol() )
  Endif
  sqlite3_exec( db, 'DROP TABLE tmp' )
  Return Nil

// 07.05.22
Function make_uslugi_mz( db, source )

  Local stmt
  Local cmdText
  Local nfile, nameRef
  Local k, j, k1, j1
  Local oXmlDoc, oXmlNode, oNode1
  Local mID, mS_code, mName, mRel, mDateOut

  // 1) ID, Уникальный идентификатор , Целочисленный, числовой формат, обязательное поле;
  // 2) S_CODE, Код услуги, Строчный, уникальный код услуги согласно Приказу Минздравсоцразвития России от 27.12.2011 N 1664н «Об утверждении номенклатуры медицинских услуг»,текстовый формат, обязательное поле;
  // 3) NAME, Полное название , Строчный, текстовый формат, обязательное поле;
  // 4) REL, Признак актуальности , Целочисленный, числовой формат, один символ (если =1 – запись актуальна, если 0 – запись упразднена в соответствии с новыми нормативно-правовыми актами);
  // 5) DATEOUT, Дата упразднения , Дата, дата, после которой данная запись упраздняется согласно новым приказам;
  cmdText := 'CREATE TABLE Mz_services( id INTEGER, s_code TEXT(16), name TEXT(2550), rel INTEGER,  dateout TEXT(10) )'

  nameRef := "1.2.643.5.1.13.13.11.1070.xml"  // может меняться из-за версий
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
    out_utf8_to_str( nameRef + ' - Номенклатура медицинских услуг (OID)', 'RU866' )	
  Endif

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS Mz_services' ) == SQLITE_OK
    OutStd( 'DROP TABLE Mz_services - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE Mz_services - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE Mz_services - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )
  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    cmdText := 'INSERT INTO Mz_services ( id, s_code, name, rel, dateout ) VALUES( :id, :s_code, :name, :rel, :dateout )'
    stmt := sqlite3_prepare( db, cmdText )
    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If "ENTRIES" == Upper( oXmlNode:title )
          k1 := Len( oXmlNode:aItems )
          For j1 := 1 To k1
            oNode1 := oXmlNode:aItems[ j1 ]
            If "ENTRY" == Upper( oNode1:title )
              mID := mo_read_xml_stroke( oNode1, 'ID', , , 'utf8' )
              mS_code := mo_read_xml_stroke( oNode1, 'S_CODE', , , 'utf8' )
              mName := mo_read_xml_stroke( oNode1, 'NAME', , , 'utf8' )
              mRel := mo_read_xml_stroke( oNode1, 'REL', , , 'utf8' )
              mDateOut := CToD( mo_read_xml_stroke( oNode1, 'DATEOUT', , , 'utf8' ) )

              If sqlite3_bind_int( stmt, 1, Val( mID ) ) == SQLITE_OK .and. ;
                  sqlite3_bind_text( stmt, 2, mS_code ) == SQLITE_OK .and. ;
                  sqlite3_bind_text( stmt, 3, mName ) == SQLITE_OK .and. ;
                  sqlite3_bind_int( stmt, 4, Val( mRel ) ) == SQLITE_OK .and. ;
                  sqlite3_bind_text( stmt, 5, mDateOut ) == SQLITE_OK
                If sqlite3_step( stmt ) != SQLITE_DONE
                  out_error( TAG_ROW_INVALID, nfile, j )
                Endif
              Endif
              sqlite3_reset( stmt )
            Endif
          Next j1
        Endif
      Next j
    Endif
    sqlite3_clear_bindings( stmt )
    sqlite3_finalize( stmt )
  Endif
  out_obrabotka_eol()
  Return Nil