#include 'function.ch'
#include 'dict_error.ch'

REQUEST FCOMMA

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 18.05.25
Function make_other( db, source )

  make_p_cel( db, source )
  make_t005( db, source )
  make_t007( db, source )
  make_ISDErr( db, source )
  dlo_lgota( db, source )
  err_csv_prik( db, source )
  rekv_smo( db, source )
  db_holiday( db, source )
  db_planzakaz( db, source )
  make_planDRZ( db, source )
  db_diagnoze_dn( db, source )
  Return Nil

// 22.12.24
Function make_p_cel( db, source )

  // SHIFR,     "C",    10,      0
  // P_CEL,  "C",  4,      0

  Local cmdText
  Local nfile, nameRef
  Local mSHIFR, mPCEL
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := 'pcel'

  cmdText := 'CREATE TABLE usl_p_cel(shifr TEXT(10), p_cel TEXT(4))'

  nameRef := 'p_cel_usl.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Соответствие услуг АПП и цели посещения USL_P_CEL', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS usl_p_cel' ) == SQLITE_OK
    OutStd( 'DROP TABLE usl_p_cel - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE usl_p_cel - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE usl_p_cel - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  Do While !( dbSource )->( Eof() )
    mSHIFR := AllTrim( ( dbSource )->SHIFR )
    mPCEL := AllTrim( ( dbSource )->P_CEL )

    count++
    cmdTextInsert += 'INSERT INTO usl_p_cel(shifr, p_cel) VALUES('
    cmdTextInsert += "'" + mSHIFR + "',"
    cmdTextInsert += "'" + mPCEL + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif

    ( dbSource )->( dbSkip() )
  End Do
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  ( dbSource )->( dbCloseArea() )
  out_obrabotka_eol()
  Return Nil

// 22.12.24
Function make_t007( db, source )

  // PROFIL_K,  N,  2
  // PK_V020,   N,  2
  // PROFIL,    N,  2
  // NAME,      C,  255

  Local cmdText
  Local nfile, nameRef
  Local profil_k, pk_v020, profil, name
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := 't007'

  cmdText := 'CREATE TABLE t007(profil_k INTEGER, pk_v020 INTEGER, profil INTEGER, name TEXT)'

  nameRef := 't007.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Справочник T007', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS t007' ) == SQLITE_OK
    OutStd( 'DROP TABLE t007 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE t007 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE t007 - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  Do While !( dbSource )->( Eof() )
    profil_k := str( ( dbSource )->PROFIL_K )
    pk_v020 := str( ( dbSource )->PK_V020 )
    profil := str( ( dbSource )->PROFIL )
    name := hb_StrToUTF8( ( dbSource )->NAME, 'RU866' )

    count++
    cmdTextInsert += 'INSERT INTO t007(profil_k, pk_v020, profil, name) VALUES(' ;
      + "'" + profil_k + "'," ;
      + "'" + pk_v020 + "'," ;
      + "'" + profil + "'," ;
      + "'" + name + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif

    ( dbSource )->( dbSkip() )
  End Do

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  ( dbSource )->( dbCloseArea() )

  out_obrabotka_eol()
  Return Nil

// 22.12.24
Function make_t005( db, source )

  // CODE,     "N",    4,      0
  // ERROR,  "C",  91,      0
  // OPIS, "C",  251,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  Local cmdText
  Local nfile, nameRef
  Local mCode, mError, mOpis, d1, d2, d1_1, d2_1
  Local count := 0, cmdTextInsert := textBeginTrans
  Local dbSource := 't005'

  cmdText := 'CREATE TABLE t005(code INTEGER, error TEXT, opis TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 't005.dbf'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Endif

  out_utf8_to_str( nameRef + ' - Классификатор кодов ошибок T005', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS t005' ) == SQLITE_OK
    OutStd( 'DROP TABLE t005 - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE t005 - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE t005 - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., , nfile, dbSource, .t., .f. )
  Do While !( dbSource )->( Eof() )
    mCode := str( ( dbSource )->CODE )
    mError := hb_StrToUTF8( ( dbSource )->ERROR, 'RU866' )
    mOpis := hb_StrToUTF8( ( dbSource )->OPIS, 'RU866' )
    Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
    d1_1 := ( dbSource )->DATEBEG
    d2_1 := ( dbSource )->DATEEND
    Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
    d1 := hb_ValToStr( d1_1 )
    d2 := hb_ValToStr( d2_1 )

    count++
    cmdTextInsert += 'INSERT INTO t005(code, error, opis, datebeg, dateend) VALUES(' ;
      + "'" + mCode + "'," ;
      + "'" + mError + "'," ;
      + "'" + mOpis + "'," ;
      + "'" + d1 + "'," ;
      + "'" + d2 + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif

    ( dbSource )->( dbSkip() )
  End Do
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  ( dbSource )->( dbCloseArea() )
  out_obrabotka_eol()
  Return Nil

// 22.12.24
Function dlo_lgota( db, source )

  // Классификатор кодов льгот по ДЛО
  // 1 - NAME(C)  2 - KOD(C)

  Local cmdText
  Local k
  Local mKod, mName
  Local mArr := {}
  Local count := 0, cmdTextInsert := textBeginTrans

  AAdd( mArr, { '000 --- без льготы ---', '   ' } )
  AAdd( mArr, { '010 Инвалиды войны', '010' } )
  AAdd( mArr, { '011 Участники Великой Отечественной войны, ставшие инвалидами', '011' } )
  AAdd( mArr, { '012 Военнослужащие органов внутренних дел, Государственной противопожарной службы, учреждений и органов уголовно-исполнительной системы, ставших инвалидами вследствие ранения, контузии или увечья, полученных при исполнении обязанностей военной службы', '012' } )
  AAdd( mArr, { '020 Участники Великой Отечественной войны', '020' } )
  AAdd( mArr, { '030 Ветераны боевых действий', '030' } )
  AAdd( mArr, { '040 Военнослужащие, проходившие военную службу в воинских частях, не входивших в состав действующей армии, в период с 22 июня 1941 года по 3 сентября 1945 года не менее шести месяцев, военнослужащие, награжденные орденами или медалями СССР', '040' } )
  AAdd( mArr, { '050 Лица, награжденные знаком "Жителю блокадного Ленинграда"', '050' } )
  AAdd( mArr, { '060 Члены семей погибших (умерших) инвалидов войны, участников Великой Отечественной войны и ветеранов боевых действий', '060' } )
  AAdd( mArr, { '061 Члены семей погибших в Великой Отечественной войне лиц из числа личного состава групп самозащиты объектовых и аварийных команд местной противовоздушной обороны, а также члены семей погибших работников госпиталей и больниц города Ленинграда', '061' } )
  AAdd( mArr, { '062 Члены семей военнослужащих органов внутренних дел, Государственной противопожарной службы, учреждений и органов уголовно-исполнительной системы и органов государственной безопасности, погибших при исполнении обязанностей военной службы', '062' } )
  AAdd( mArr, { '063 Члены семей военнослужащих, погибших в плену, признанных в установленном порядке пропавшими без вести в районах боевых действий', '063' } )
  AAdd( mArr, { '081 Инвалиды I степени', '081' } )
  AAdd( mArr, { '082 Инвалиды II степени', '082' } )
  AAdd( mArr, { '083 Инвалиды III степени', '083' } )
  AAdd( mArr, { '084 Дети-инвалиды', '084' } )
  AAdd( mArr, { '085 Инвалиды, не имеющие степени ограничения способности к трудовой деятельности', '085' } )
  AAdd( mArr, { '091 Граждане, получившие или перенесшие лучевую болезнь и другие заболевания, связанные с радиационным воздействием вследствие чернобыльской катастрофы или с работами по ликвидации последствий катастрофы на Чернобыльской АЭС', '091' } )
  AAdd( mArr, { '092 Инвалиды вследствие чернобыльской катастрофы', '092' } )
  AAdd( mArr, { '093 Граждане, принимавшие в 1986-1987 годах участие в работах по ликвидации последствий чернобыльской катастрофы', '093' } )
  AAdd( mArr, { '094 Граждане, принимавшие участие в 1988-90гг. участие в работах по ликвидации последствий чернобыльской катастрофы', '094' } )
  AAdd( mArr, { '095 Граждане, постоянно проживающие (работающие) на территории зоны проживания с правом на отселение', '095' } )
  AAdd( mArr, { '096 Граждане, постоянно проживающие (работающие) на территории зоны проживания с льготным социально-экономическим статусом', '096' } )
  AAdd( mArr, { '097 Граждане, постоянно проживающие (работающие) в зоне отселения до их переселения в другие районы', '097' } )
  AAdd( mArr, { '098 Граждане, эвакуированные (в том числе выехавшие добровольно) в 1986 году из зоны отчуждения', '098' } )
  AAdd( mArr, { '099 Дети и подростки в возрасте до 18 лет, проживающие в зоне отселения и зоне проживания с правом на отселение, эвакуированные и переселенные из зон отчуждения, отселения, проживания с правом на отселение', '099' } )
  AAdd( mArr, { '100 Дети и подростки в возрасте до 18 лет, постоянно проживающие в зоне с льготным социально-экономическим статусом', '100' } )
  AAdd( mArr, { '101 Дети и подростки, страдающие болезнями вследствие чернобыльской катастрофы, ставшие инвалидами', '101' } )
  AAdd( mArr, { '102 Дети и подростки, страдающие болезнями вследствие чернобыльской катастрофы', '102' } )
  AAdd( mArr, { '111 Граждане, получившие суммарную (накопительную) эффективную дозу облучения, превышающую 25 сЗв (бэр)', '111' } )
  AAdd( mArr, { '112 Граждане, получившие суммарную (накопительную) эффективную дозу облучения более 5 сЗв (бэр), но не превышающую 25 сЗв (бэр)', '112' } )
  AAdd( mArr, { '113 Дети в возрасте до 18 лет первого и второго поколения граждан, получившие суммарную (накопительную) эффективную дозу облучения более 5 сЗв (бэр), страдающих заболеваниями вследствие радиационного воздействия на одного из родителей', '113' } )
  AAdd( mArr, { '120 Лица, работавшие в период Великой Отечественной войны на объектах противовоздушной обороны, на строительстве оборонительных сооружений, военно-морских баз, аэродромов и других военных объектов', '120' } )
  AAdd( mArr, { '121 Граждане, получившие лучевую болезнь, обусловленную воздействием радиации вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '121' } )
  AAdd( mArr, { '122 Граждане, ставшие инвалидами в результате воздействия радиации вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '122' } )
  AAdd( mArr, { '123 Граждане, принимавшие в 1957-58гг. участие в работах по ликвидации последствий аварии в 1957 году на производственном объединении "Маяк", а также граждане, занятые на работах по проведению мероприятий вдоль реки Теча в 1949-56гг.', '123' } )
  AAdd( mArr, { '124 Граждане, принимавшие в 1959-61гг. участие в работах по ликвидации последствий аварии в 1957 году на производственном объединении "Маяк", а также граждане, занятые на работах по проведению мероприятий вдоль реки Теча в 1957-62гг.', '124' } )
  AAdd( mArr, { '125 Граждане, проживающие в населенных пунктах, подвергшихся радиоактивному загрязнению вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '125' } )
  AAdd( mArr, { '128 Граждане, эвакуированные из населенных пунктов, подвергшихся радиоактивному загрязнению вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '128' } )
  AAdd( mArr, { '129 Дети первого и второго поколения граждан, указанных в статье 1 Федерального закона от 26.11.98 № 175-ФЗ, страдающие заболеваниями вследствие воздействия радиации на их родителей', '129' } )
  AAdd( mArr, { '131 Граждане из подразделений особого риска, не имеющие инвалидности', '131' } )
  AAdd( mArr, { '132 Граждане из подразделений особого риска, имеющие инвалидность', '132' } )
  AAdd( mArr, { '140 Бывшие несовершеннолетние узники концлагерей, признанные инвалидами вследствие общего заболевания, трудового увечья и других причин (за исключением лиц, инвалидность которых наступила вследствие их противоправных действий)', '140' } )
  AAdd( mArr, { '141 Рабочие и служащие, а также военнослужащих органов внутренних дел, Государственной противопожарной службы, получившие профессиональные заболевания, связанные с лучевым воздействием на работах в зоне отчуждения', '141' } )
  AAdd( mArr, { '142 Рабочие и служащие, а также военнослужащие органов внутренних дел, Государственной противопожарной службы, получивших профессиональные заболевания, связанные с лучевым воздействием на работах в зоне отчуждения, ставшие инвалидами', '142' } )
  AAdd( mArr, { '150 Бывшие несовершеннолетние узники концлагерей', '150' } )

  cmdText := 'CREATE TABLE dlo_lgota(kod TEXT(3), name TEXT)'

  out_utf8_to_str( 'Классификатор кодов льгот по ДЛО', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS dlo_lgota' ) == SQLITE_OK
    OutStd( 'DROP TABLE dlo_lgota - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE dlo_lgota - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE dlo_lgota - False' + hb_eol() )
    Return Nil
  Endif

  For k := 1 To Len( mArr )
    mKod := mArr[ k, 2 ]
    mName := mArr[ k, 1 ]

    count++
    cmdTextInsert += 'INSERT INTO dlo_lgota (kod, name) VALUES(' ;
      + "'" + mKod + "'," ;
      + "'" + mName + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  Next

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  out_obrabotka_eol()
  Return Nil

// 27.12.24
Function err_csv_prik( db, source )

  // Классификатор кодов льгот по ДЛО
  // 1 - NAME(C)  2 - KOD(C)

//  Local stmt
  Local cmdText
  Local k
  Local mKod, mName
  Local arr := {}
  Local count := 0, cmdTextInsert := textBeginTrans

  AAdd( arr, { "Неверная команда", 1 } )
  AAdd( arr, { "Отсутствует единый номер полиса для полиса ОМС единого образца", 2 } )
  AAdd( arr, { 'Длина временного номера полиса не равна 9', 3 } )
  AAdd( arr, { 'Длина нового номера полиса не равна 16 (неверная контрольная сумма)', 4 } )
  AAdd( arr, { "Недопустимые знаки или сочетания знаков в фамилии", 5 } )
  AAdd( arr, { "Недопустимые знаки или сочетания знаков в имени", 6 } )
  AAdd( arr, { "Недопустимые знаки или сочетания знаков в отчестве", 7 } )
  AAdd( arr, { "Не указана дата рождения", 10 } )
  AAdd( arr, { "Ошибка в дате рождения (указана нереальная дата)", 11 } )
  AAdd( arr, { "Указан некорректный СНИЛС", 12 } )
  AAdd( arr, { "В строке имеются недопустимые символы", 13 } )
  AAdd( arr, { "Неверный порядковый номер файла", 19 } )
  AAdd( arr, { "Дата актуализации больше текущей даты", 20 } )
  AAdd( arr, { "Ошибка в значении СНИЛС", 21 } )
  AAdd( arr, { "Ошибка в контрольном числе СНИЛС", 22 } )
  AAdd( arr, { "Неверный код территории", 24 } )
  AAdd( arr, { "Отсутствует серия и номер для полиса ОМС старого образца или номер для временного свидетельства", 25 } )
  AAdd( arr, { "Ошибка в заголовке метаданных файла", 38 } )
  AAdd( arr, { "Ошибка в формате даты прикрепления", 46 } )
  AAdd( arr, { "Не указана дата актуализации", 86 } )
  AAdd( arr, { "Дата прикрепления больше даты актуализации", 87 } )
  AAdd( arr, { "Формат единого номера полиса неверен", 102 } )
  AAdd( arr, { "Неверная версия формата", 183 } )
  AAdd( arr, { "Не указан СНИЛС медицинского работника", 239 } )
  AAdd( arr, { "Не указан код способа прикрепления к МО", 242 } )
  AAdd( arr, { "Недопустимый код способа прикрепления к МО", 243 } )
  AAdd( arr, { "Дата прикрепления не заполнена", 245 } )
  AAdd( arr, { "Ошибка в дате прикрепления", 246 } )
  AAdd( arr, { "Реестровый номер МО не указан", 264 } )
  AAdd( arr, { "Реестровый номер МО не найден", 265 } )
  AAdd( arr, { "Неверный формат реестрового номера МО", 300 } )
  AAdd( arr, { "По предоставленным данным застрахованное лицо не найдено в регистре застрахованных лиц", 404 } )
  AAdd( arr, { "Единый номер полиса не найден в регистре застрахованных лиц", 500 } )
  AAdd( arr, { "Невозможно идентифицировать застрахованное лицо в едином регистре застрахованных лиц", 522 } )
  AAdd( arr, { "Единый номер полиса не соответствует указанному документу, подтверждающему факт страхования", 525 } )
  AAdd( arr, { "МО не работает на территории", 541 } )
  AAdd( arr, { 'Застрахованное лицо не прикреплено к МО (для операции "И" не найдена действующая запись о прикреплении)', 542 } )
  AAdd( arr, { "Медработник не найден в Федеральном реестре медработников", 543 } )
  AAdd( arr, { "Медработник не работает в указанной МО", 544 } )
  AAdd( arr, { "Указан второй медработник с той же должностью", 545 } )
  AAdd( arr, { "Указан третий медработник (более двух прикреплений)", 546 } )
  AAdd( arr, { "Дата прикрепления к медработнику меньше даты прикрепления к МО или предыдущему медработнику", 547 } )
  AAdd( arr, { "В реестре отсутствуют сведения по прикреплению указанного лица к МО", 548 } )
  AAdd( arr, { "Для лица, не идентифицированного в реестре застрахованных, не указан ЕНП", 555 } )
  AAdd( arr, { "Дата заявления, указанная в файле, меньше имеющейся в СРЗ даты прикрепления", 600 } )
  AAdd( arr, { "Прикрепление в течение одного года к этой же МО (некорректное прикрепление)", 701 } )
  AAdd( arr, { "Прикрепление в течение одного года к другой МО (некорректное прикрепление)", 702 } )
  AAdd( arr, { "На указанную дату прикрепления ЗЛ не имеет действующего страхования в Волгоградской области", 703 } )
  AAdd( arr, { "Дата прикрепления больше даты смерти", 704 } )
  AAdd( arr, { "Неверный способ прикрепления", 705 } )
  AAdd( arr, { "Застрахованный умер", 706 } )
  AAdd( arr, { "Неверный код способа прикрепления или прикрепление без изменения места жительства в одном году", 707 } )
  AAdd( arr, { 'Неверная дата прикрепления или неверно указана категория врача', 708 } )
  AAdd( arr, { "ЗЛ уже прикреплено к Вашей организации по данным РС СРЗ", 709 } )
  AAdd( arr, { "Ошибка в дате открепления", 746 } )
  AAdd( arr, { "Обработка данных ЗЛ не выполнялась (направить повторно)", 801 } )
  AAdd( arr, { "ЗЛ не найдено в РС СРЗ (проверить данные и направить повторно)", 802 } )
  AAdd( arr, { "Наличие ошибок ФЛК, прикладной обработки (проверить данные и направить повторно)", 803 } )
  AAdd( arr, { "В программе обработки возникла исключительная ситуация", 99 } )

  cmdText := 'CREATE TABLE err_csv_prik(kod INTEGER, name TEXT)'

  out_utf8_to_str( 'Коды ошибок прикрепления населения', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS err_csv_prik' ) == SQLITE_OK
    OutStd( 'DROP TABLE err_csv_prik - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE err_csv_prik - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE err_csv_prik - False' + hb_eol() )
    Return Nil
  Endif

//  cmdText := 'INSERT INTO err_csv_prik (kod, name) VALUES( :kod, :name )'
  For k := 1 To Len( arr )
//    stmt := sqlite3_prepare( db, cmdText )
    mKod := str( arr[ k, 2 ] )
    mName := arr[ k, 1 ]
//    If sqlite3_bind_int( stmt, 1, mKod ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 2, mName ) == SQLITE_OK
//      If sqlite3_step( stmt ) != SQLITE_DONE
//        // out_error('Ошибка к = ', k)
//      Endif
//    Endif
//    sqlite3_reset( stmt )
    count++
    cmdTextInsert += 'INSERT INTO err_csv_prik (kod, name) VALUES(' ;
      + "'" + mKod + "'," ;
      + "'" + mName + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  Next
//  sqlite3_clear_bindings( stmt )
//  sqlite3_finalize( stmt )
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  out_obrabotka_eol()
  Return Nil

// 22.12.22
Function make_isderr( db, source )

  Local stmt
  Local cmdText
  Local k, j
  Local nfile, nameRef
  Local oXmlDoc, oXmlNode
  Local code, name
  Local count := 0, cmdTextInsert := textBeginTrans

  // CODE, Целочисленный(3), Код ошибки
  // NAME, Строчный(250), Наименование ошибки
  // NAME_F, Строчный(250), Дополнительная информация об ошибке
  // DATEBEG, Строчный(10), Дата начала действия записи
  // DATEEND, Строчный(10), Дата окончания действия записи
  // cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250), name_f TEXT(250))'
  cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250))'

  nameRef := 'ISDErr.xml'
  nfile := source + nameRef
  If ! hb_vfExists( nfile )
    out_error( FILE_NOT_EXIST, nfile )
    Return Nil
  Else
  Endif

  out_utf8_to_str( nameRef + ' - Справочник ошибок ИСОМПД (isderr)', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE IF EXISTS isderr' ) == SQLITE_OK
    OutStd( 'DROP TABLE isderr - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE isderr - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE isderr - False' + hb_eol() )
    Return Nil
  Endif

  oXmlDoc := hxmldoc():read( nfile )

  If Empty( oXmlDoc:aItems )
    out_error( FILE_READ_ERROR, nfile )
    Return Nil
  Else
    // cmdText := 'INSERT INTO isderr (code, name, name_f) VALUES(:code, :name, :name_f)'
//    cmdText := 'INSERT INTO isderr (code, name) VALUES(:code, :name)'
//    stmt := sqlite3_prepare( db, cmdText )
//    If ! Empty( stmt )
      out_obrabotka( nfile )
      k := Len( oXmlDoc:aItems[ 1 ]:aItems )
      For j := 1 To k
        oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
        If 'ZAP' == Upper( oXmlNode:title )
          code := read_xml_stroke_1251_to_utf8( oXmlNode, 'CODE' )
          name := read_xml_stroke_1251_to_utf8( oXmlNode, 'NAME' )
          // name_f := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME_F')

//          If sqlite3_bind_int( stmt, 1, Val( code ) ) == SQLITE_OK .and. ;
//              sqlite3_bind_text( stmt, 2, name ) == SQLITE_OK // .AND. ;
//            // sqlite3_bind_text(stmt, 3, name_f) == SQLITE_OK
//            If sqlite3_step( stmt ) != SQLITE_DONE
//              out_error( TAG_ROW_INVALID, nfile, j )
//            Endif
//          Endif
//          sqlite3_reset( stmt )

          count++
          cmdTextInsert += 'INSERT INTO isderr (code, name) VALUES(' ;
            + "'" + code + "'," ;
            + "'" + name + "');"
          If count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec( db, cmdTextInsert )
            count := 0
            cmdTextInsert := textBeginTrans
          Endif
        Endif
      Next j
//    Endif
//    sqlite3_clear_bindings( stmt )
//    sqlite3_finalize( stmt )
    If count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
    Endif
  Endif

  out_obrabotka_eol()
  Return Nil

// 15.04.24
Function rekv_smo( db, source )

  Local stmt
  Local cmdText
  Local k
  Local arr
  Local  mKod, mName, mINN, mKPP, mOGRN, mAddres
  Local count := 0, cmdTextInsert := textBeginTrans

  // 1-код,2-имя,3-ИНН,4-КПП,5-ОГРН,6-адрес,7-банк,8-р.счет,9-БИК
//  'ФИЛИАЛ ЗАКРЫТОГО АКЦИОНЕРНОГО ОБЩЕСТВА "КАПИТАЛ МЕДИЦИНСКОЕ СТРАХОВАНИЕ" В ГОРОДЕ ВОЛГОГРАДЕ', ;
  arr := { ;
    { '34001', ;
    'АСП ООО Капитал МС - Филиал в Волгоградской области', ;
    '7709028619', ;
    '344343001', ;
    '1028601441274', ;
    '400075 Волгоградская обл., г.Волгоград, ул.Историческая, д.122', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34002', ;
    'ВОЛГОГРАДСКИЙ ФИЛИАЛ АКЦИОНЕРНОГО ОБЩЕСТВА "СТРАХОВАЯ КОМПАНИЯ "СОГАЗ - МЕД"', ;
    '7728170427', ;
    '344343001', ;
    '1027739008440', ;
    '400105 Волгоградская обл., г.Волгоград, ул.Штеменко, д.5', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34003', ;
    'АКЦИОНЕРНОЕ ОБЩЕСТВО ВТБ МЕДИЦИНСКОЕ СТРАХОВАНИЕ', ;
    '7704103750', ;
    '774401001', ;
    '1027739815245', ;
    '400005 Волгоградская обл., г.Волгоград, ул.Мира, д.19', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34004', ;
    'ВОЛГОГРАДСКИЙ ФИЛИАЛ ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "СТРАХОВАЯ КОМПАНИЯ ВСК МИЛОСЕРДИЕ"', ;
    '7730519137', ;
    '775001001', ;
    '1057746135325', ;
    '400131 Волгоградская обл., г.Волгоград, ул.Коммунистическая, д.32', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34006', ;
    'ФИЛИАЛ ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "МЕДИЦИНСКАЯ СТРАХОВАЯ КОМПАНИЯ "МАКСИМУС" В Г.ВОЛГОГРАДЕ', ;
    '6161056686', ;
    '344445001', ;
    '1106193000022', ;
    '400074 Волгоградская обл., г.Волгоград, ул.Ковровская, д.24', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34007', ;
    'Административное структурное подразделение ООО "Капитал МС" - Филиал в Волгоградской области', ;
    '7813171100', ;
    '344303001', ;
    '1027806865481', ;
    '400074 Волгоградская обл., г.Волгоград, ул.Рабоче-Крестьянская, д.30А', ;
    '', ;
    '', ;
    '' ;
    }, ;
    { '34   ', ;
    'ГОСУДАРСТВЕННОЕ УЧРЕЖДЕНИЕ "ТЕРРИТОРИАЛЬНЫЙ ФОНД ОБЯЗАТЕЛЬНОГО МЕДИЦИНСКОГО СТРАХОВАНИЯ ВОЛГОГРАДСКОЙ ОБЛАСТИ"', ;
    '          ', ;
    '         ', ;
    '1023403856123', ;
    '400005 г.Волгоград, проспект Ленина, 56а', ;
    '', ;
    '', ;
    '' ;
    } ;
    }

  cmdText := 'CREATE TABLE rekv_smo(kod TEXT(5), name TEXT, inn TEXT(10), kpp TEXT(9), ogrn TEXT(13), addres TEXT)'

  out_utf8_to_str( 'Страховые компании', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS rekv_smo' ) == SQLITE_OK
    OutStd( 'DROP TABLE rekv_smo - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE rekv_smo - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE rekv_smo - False' + hb_eol() )
    Return Nil
  Endif

  cmdText := 'INSERT INTO rekv_smo (kod, name, inn, kpp, ogrn, addres) VALUES( :kod, :name, :inn, :kpp, :ogrn, :addres )'
  For k := 1 To Len( arr )
//    stmt := sqlite3_prepare( db, cmdText )
    mKod := arr[ k, 1 ]
    mName := arr[ k, 2 ]
    mINN := arr[ k, 3 ]
    mKPP := arr[ k, 4 ]
    mOGRN := arr[ k, 5 ]
    mAddres := arr[ k, 6 ]
//    If sqlite3_bind_text( stmt, 1, mKod ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 2, mName ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 3, mINN ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 4, mKPP ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 5, mOGRN ) == SQLITE_OK .and. ;
//        sqlite3_bind_text( stmt, 6, mAddres ) == SQLITE_OK
//      If sqlite3_step( stmt ) != SQLITE_DONE
//        out_error( 'Ошибка к = ', k )
//      Endif
//    Endif
//    sqlite3_reset( stmt )
    count++
//    cmdText := 'INSERT INTO rekv_smo (kod, name, inn, kpp, ogrn, addres) VALUES( :kod, :name, :inn, :kpp, :ogrn, :addres )'
    cmdTextInsert += 'INSERT INTO rekv_smo (kod, name, inn, kpp, ogrn, addres) VALUES(' ;
      + "'" + mKod + "'," ;
      + "'" + mName + "'," ;
      + "'" + mINN + "'," ;
      + "'" + mKPP + "'," ;
      + "'" + mOGRN + "'," ;
      + "'" + mAddres + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
  Next
//  sqlite3_clear_bindings( stmt )
//  sqlite3_finalize( stmt )
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  out_obrabotka_eol()
  Return Nil

// 26.02.25
Function db_holiday_old( db, source )

  // Календарь выходных и праздничных дней

  Local cmdText
  Local k, i
  Local mYear, mMonth, mHoliday
  Local mArr, nameView, nameRef, nfile
  Local count := 0, cmdTextInsert := textBeginTrans
  local aYear := {}

  // Local arr_holiday := { ;
  //   { 2013, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 2, '[ 2, 3, 9, 10, 16, 17, 23, 24 ]' }, ;
  //   { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 4, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 11, '[ 2, 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 12, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' } } ;
  //   }, ;
  //   { 2014, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23 ]' }, ;
  //   { 3, '[ 1, 2, 8, 9, 10, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 4, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 6, '[ 1, 7, 8, 12, 13, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 7, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 8, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 9, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 10, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 11, '[ 1, 2, 3, 4, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 12, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' } } ;
  //   }, ;
  //   { 2015, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 2, '[ 1, 7, 8, 14, 15, 21, 22, 23, 28 ]' }, ;
  //   { 3, '[ 1, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 4, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 9, 10, 11, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 6, '[ 6, 7, 12, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 7, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 8, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 9, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 10, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 11, '[ 1, 4, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 12, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' } } ;
  //   }, ;
  //   { 2016, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 2, '[ 6, 7, 13, 14, 21, 22, 23, 27, 28 ]' }, ;
  //   { 3, '[ 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 4, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 5, '[ 1, 2, 3, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 6, '[ 4, 5, 11, 12, 13, 18, 19, 25, 26 ]' }, ;
  //   { 7, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 8, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 9, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
  //   { 10, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 11, '[ 4, 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 12, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' } } ;
  //   }, ;
  //   { 2017, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 2, '[ 4, 5, 11, 12, 18, 19, 23, 24, 25, 26 ]' }, ;
  //   { 3, '[ 4, 5, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 4, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 5, '[ 1, 6, 7, 8, 9, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 6, '[ 3, 4, 10, 11, 12, 17, 18, 24, 25 ]' }, ;
  //   { 7, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 8, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 9, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 10, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 11, '[ 4, 5, 6, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 12, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' } } ;
  //   }, ;
  //   { 2018, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 2, '[ 3, 4, 10, 11, 17, 18, 23, 24, 25 ]' }, ;
  //   { 3, '[ 3, 4, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 4, '[ 1, 7, 8, 14, 15, 21, 22, 29, 30 ]' }, ;
  //   { 5, '[ 1, 2, 5, 6, 9, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 6, '[ 2, 3, 10, 11, 12, 16, 17, 23, 24, 30 ]' }, ;
  //   { 7, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 8, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 9, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 10, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 11, '[ 3, 4, 5, 10, 11, 17, 18, 24, 25 ]' }, ;
  //   { 12, '[ 1, 2, 8, 9, 15, 16, 22, 23, 30, 31 ]' } } ;
  //   }, ;
  //   { 2019, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 2, '[ 2, 3, 9, 10, 16, 17, 23, 24 ]' }, ;
  //   { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 4, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 11, '[ 2, 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 12, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' } } ;
  //   }, ;
  //   { 2020, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23, 24, 29 ]' }, ;
  //   { 3, '[ 1, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 4, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 6, '[ 6, 7, 12, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 7, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 8, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 9, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 10, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 11, '[ 1, 4, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 12, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' } } ;
  //   }, ;
  //   { 2021, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 2, '[ 6, 7, 13, 14, 21, 22, 23, 27, 28 ]' }, ;
  //   { 3, '[ 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 4, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
  //   { 5, '[ 1, 2, 3, 8, 9, 10, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 6, '[ 5, 6, 12, 13, 14, 19, 20, 26, 27 ]' }, ;
  //   { 7, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 8, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 9, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 10, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 11, '[ 4, 5, 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 12, '[ 4, 5, 11, 12, 18, 19, 25, 26, 31 ]' } } ;
  //   }, ;
  //   { 2022, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 2, '[ 5, 6, 12, 13, 19, 20, 23, 26, 27 ]' }, ;
  //   { 3, '[ 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 4, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 5, '[ 1, 2, 3, 7, 8, 9, 10, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 6, '[ 4, 5, 11, 12, 13, 18, 19, 25, 26 ]' }, ;
  //   { 7, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 8, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 9, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
  //   { 10, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 11, '[ 4, 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 12, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' } } ;
  //   }, ;
  //   { 2023, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 2, '[ 4, 5, 11, 12, 18, 19, 23, 24, 25, 26 ]' }, ;
  //   { 3, '[ 4, 5, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 4, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 5, '[ 1, 6, 7, 8, 9, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 6, '[ 3, 4, 10, 11, 12, 17, 18, 24, 25 ]' }, ;
  //   { 7, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 8, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 9, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 10, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 11, '[ 4, 5, 6, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 12, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' } } ;
  //   }, ;
  //   { 2024, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 2, '[ 3, 4, 10, 11, 17, 18, 23, 24, 25 ]' }, ;
  //   { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 4, '[ 6, 7, 13, 14, 20, 21, 28, 29, 30 ]' }, ;
  //   { 5, '[ 1, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 11, '[ 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
  //   { 12, '[ 1, 7, 8, 14, 15, 21, 22, 29, 30, 31 ]' } } ;
  //   }, ;
  //   { 2025, { ;
  //   { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23 ]' }, ;
  //   { 3, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 4, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 5, '[ 1, 2, 3, 4, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
  //   { 6, '[ 1, 7, 8, 12, 13, 14, 15, 21, 22, 28, 29 ]' }, ;
  //   { 7, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
  //   { 8, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
  //   { 9, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
  //   { 10, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
  //   { 11, '[ 2, 3, 4, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
  //   { 12, '[ 6, 7, 13, 14, 20, 21, 27, 28, 31 ]' } } ;
  //   } ;
  // }

  nameRef := 'holiday.csv'
  nfile := source + nameRef

  cmdText := 'CREATE TABLE calendar( m_year INTEGER, m_month INTEGER, description TEXT )'

  out_utf8_to_str( 'Список выходных и праздников', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS calendar' ) == SQLITE_OK
    OutStd( 'DROP TABLE calendar - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE calendar - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE calendar - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., 'FCOMMA', nfile, , .f., .f. )
  dbGoTop()
  DO WHILE ! Eof()
    mArr := split( FIELD->LINE, ',' )
    mYear := val( mArr[ 1 ] )
    if ( AScan( aYear, mYear ) ) == 0
       AAdd( aYear, mYear )
    endif
    mMonth := AllTrim( mArr[ 2 ] )
    mHoliday := AllTrim( mArr[ 3 ] )
    count++
    cmdTextInsert += "INSERT INTO calendar (m_year, m_month, description ) VALUES(" ;
      + "'" + mArr[ 1 ] + "'," ;
      + "'" + mMonth + "'," ;
      + "'" + strTran( mHoliday, '; ', ',' ) + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
    dbSkip()
  enddo

  // For k := 1 To Len( arr_holiday )
  //   mYear := str( arr_holiday[ k, 1 ], 4 )
  //   mArr := arr_holiday[ k, 2 ]

  //   for i := 1 to 12
  //     mMonth := AllTrim( str( mArr[ i, 1 ], 2 ) )
  //     mHoliday := mArr[ i, 2 ]
  //     count++
  //     cmdTextInsert += "INSERT INTO calendar (m_year, m_month, description ) VALUES(" ;
  //       + "'" + mYear + "'," ;
  //       + "'" + mMonth + "'," ;
  //       + "'" + mHoliday + "');"
  //     If count == COMMIT_COUNT
  //       cmdTextInsert += textCommitTrans
  //       sqlite3_exec( db, cmdTextInsert )
  //       count := 0
  //       cmdTextInsert := textBeginTrans
  //     Endif
  //   next

  // Next
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  // for k := 1 to Len( arr_holiday )
  //   mYear := str( arr_holiday[ k, 1 ], 4 )
  //   nameView := 'year' + mYear
  //   If sqlite3_exec( db, 'DROP VIEW if EXISTS ' + nameView ) == SQLITE_OK
  //     OutStd( 'DROP VIEW ' + nameView + ' - Ok' + hb_eol() )
  //   Endif
  //   cmdText := 'CREATE VIEW ' + nameView + ' AS SELECT m_month, description FROM calendar WHERE m_year=' + mYear + ';'
  //   If sqlite3_exec( db, cmdText ) == SQLITE_OK
  //     OutStd( 'CREATE VIEW ' + nameView + ' - Ok' + hb_eol() )
  //   Else
  //     OutStd( 'CREATE VIEW ' + nameView + ' - False' + hb_eol() )
  //     Return Nil
  //   Endif
  // next
  for k := 1 to Len( aYear )
    mYear := str( aYear[ k ], 4 )
    nameView := 'year' + mYear
    If sqlite3_exec( db, 'DROP VIEW if EXISTS ' + nameView ) == SQLITE_OK
      OutStd( 'DROP VIEW ' + nameView + ' - Ok' + hb_eol() )
    Endif
    cmdText := 'CREATE VIEW ' + nameView + ' AS SELECT m_month, description FROM calendar WHERE m_year=' + mYear + ';'
    If sqlite3_exec( db, cmdText ) == SQLITE_OK
      OutStd( 'CREATE VIEW ' + nameView + ' - Ok' + hb_eol() )
    Else
      OutStd( 'CREATE VIEW ' + nameView + ' - False' + hb_eol() )
      Return Nil
    Endif
  next
  out_obrabotka_eol()
  Return Nil

// 27.02.25
Function make_planDRZ( db, source )

  // План на выполнение диспансеризации репродуктивного здоровья
  // 1 - year(N)  2 - kod(C) 3 - kol_m(N) 4 - kol_f(N)  // 5 - name_u(C)

  Local cmdText
  Local mKod, mYear, mKol_m, mKol_f //, mName
  Local arr := {}
  Local count := 0, cmdTextInsert := textBeginTrans
  Local mArr, nameRef, nfile

  nameRef := 'plan_DRZ.csv'
  nfile := source + nameRef

  cmdText := 'CREATE TABLE plan_drz( year INTEGER, kod_mo TEXT(6), kol_m INTEGER, kol_f INTEGER )'

  out_utf8_to_str( 'Плановые показатели по проведению диспансеризации репродуктивного здоровья', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS plan_drz' ) == SQLITE_OK
    OutStd( 'DROP TABLE plan_drz - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE plan_drz - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE plan_drz - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., 'FCOMMA', nfile, , .f., .f. )
  dbGoTop()
  DO WHILE ! Eof()
     mArr := split( FIELD->LINE, ',' )

     mYear := AllTrim( mArr[ 1 ] )
     mKod := AllTrim( mArr[ 2 ] )
     mKol_m := AllTrim( mArr[ 3 ] )
     mKol_f := AllTrim( mArr[ 4 ] )

     count++
     cmdTextInsert += 'INSERT INTO plan_drz ( year, kod_mo, kol_m, kol_f ) VALUES(' ;
      + "'" + mYear + "'," ;
      + "'" + mKod + "'," ;
      + "'" + mKol_m + "'," ;
      + "'" + mKol_f + "');"
     If count == COMMIT_COUNT
       cmdTextInsert += textCommitTrans
       sqlite3_exec( db, cmdTextInsert )
       count := 0
       cmdTextInsert := textBeginTrans
     Endif
    dbSkip()
  ENDDO
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
  out_obrabotka_eol()
  Return Nil

// 18.05.25
function db_diagnoze_dn( db, source )

  // список диагнозов для диспансерного наблюдения

  Local cmdText
  Local mDiag
  Local nameRef, nfile
  Local count := 0, cmdTextInsert := textBeginTrans
  local aYear := {}

  nameRef := 'diagnozeDN.csv'
  nfile := source + nameRef

  cmdText := 'CREATE TABLE diagnozeDN( diag TEXT(10) )'

  out_utf8_to_str( 'список диагнозов для диспансерного наблюдения', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS diagnozeDN' ) == SQLITE_OK
    OutStd( 'DROP TABLE diagnozeDN - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE diagnozeDN - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE diagnozeDN - False' + hb_eol() )
    Return Nil
  Endif

  dbUseArea( .t., 'FCOMMA', nfile, , .f., .f. )
  dbGoTop()
  DO WHILE ! Eof()
    mDiag := FIELD->LINE
    count++
    cmdTextInsert += "INSERT INTO diagnozeDN ( diag ) VALUES(" ;
      + "'" + alltrim( mDiag ) + "');"
    If count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec( db, cmdTextInsert )
      count := 0
      cmdTextInsert := textBeginTrans
    Endif
    dbSkip()
  enddo

  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif

  return nil