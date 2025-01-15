#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 15.01.25
Function make_TFOMS( db, source )

  make_planDRZ( db, source )
  Return Nil

// 15.01.25
Function make_planDRZ( db, source )

  // План на выполнение диспансеризации репродуктивного здоровья
  // 1 - year(N)  2 - kod(C) 3 - kol_m(N) 4 - kol_f(N) 5 - name_u(C)

  Local cmdText
  Local k
  Local mKod, mName, mYear, mKol_m, mKol_f
Local arr := {}
  Local count := 0, cmdTextInsert := textBeginTrans

  arr := { ;
    { 2024, '340033', 1545, 1930, 'ГУЗ Поликлиника № 4' }, ;
    { 2024, '340041', 2532, 3467, 'ГУЗ Клиническая поликлиника № 28' }, ;
    { 2024, '340042', 1029, 1318, 'ГУЗ Поликлиника № 30' }, ;
    { 2024, '340050', 1597, 2214, 'ГУЗ Поликлиника № 5' }, ;
    { 2024, '340055', 1502, 1695, 'ГУЗ Больница № 16' }, ;
    { 2024, '340066', 2814, 3902, 'ГУЗ Поликлиника № 2' }, ;
    { 2024, '340075', 977, 1152, 'ГУЗ Клиническая больница № 11' }, ;
    { 2024, '340056', 991, 1028, 'ГУЗ Больница №22' }, ;
    { 2024, '340083', 2290, 3277, 'ГУЗ КП № 1' }, ;
    { 2024, '340104', 1733, 1744, 'ГБУЗ ГКБ № 1 им. С.З.Фишера' }, ;
    { 2024, '340096', 1473, 1946, 'ГАУЗ КП № 3' }, ;
    { 2024, '340106', 1593, 1612, 'ГБУЗ Городская больница № 2' }, ;
    { 2024, '340117', 306, 272, 'ГБУЗ Алексеевская ЦРБ' }, ;
    { 2024, '340118', 583, 373, 'ГБУЗ Быковская ЦРБ' }, ;
    { 2024, '340119', 1378, 1343, 'ГБУЗ Городищенская ЦРБ' }, ;
    { 2024, '340158', 297, 239, 'ГБУ ЦРБ Руднянского муниципального района' }, ;
    { 2024, '340120', 303, 272, 'ГБУЗ Даниловская ЦРБ' }, ;
    { 2024, '340126', 656, 602, 'ГБУЗ Иловлинская ЦРБ' }, ;
    { 2024, '340127', 1009, 1104, 'ГБУЗ Калачевская ЦРБ' }, ;
    { 2024, '340136', 314, 255, 'ГБУЗ Киквидзенская ЦРБ' }, ;
    { 2024, '340138', 604, 731, 'ГБУЗ Котельниковская ЦРБ' }, ;
    { 2024, '340157', 395, 342, 'ГБУЗ Кумылженская ЦРБ' }, ;
    { 2024, '340142', 588, 540, 'ГБУЗ Ленинская ЦРБ' }, ;
    { 2024, '340148', 264, 257, 'ГБУЗ Нехаевская ЦРБ' }, ;
    { 2024, '340149', 672, 451, 'ГБУЗ Николаевская ЦРБ' }, ;
    { 2024, '340150', 722, 654, 'ГБУЗ Новоаннинская ЦРБ' }, ;
    { 2024, '340151', 476, 447, 'ГБУЗ Новониколаевская ЦРБ' }, ;
    { 2024, '340152', 397, 452, 'ГБУЗ Октябрьская ЦРБ' }, ;
    { 2024, '340155', 807, 755, 'ГБУЗ Палласовская ЦРБ' }, ;
    { 2024, '340159', 791, 802, 'ГБУЗ Светлоярская ЦРБ' }, ;
    { 2024, '340160', 428, 341, 'ГБУЗ Серафимовичская ЦРБ' }, ;
    { 2024, '340161', 1095, 1092, 'ГБУЗ Среднеахтубинская ЦРБ' }, ;
    { 2024, '340163', 387, 359, 'ГБУЗ Старополтавская ЦРБ' }, ;
    { 2024, '340169', 927, 905, 'ГБУЗ Фроловская ЦРБ' }, ;
    { 2024, '340121', 514, 538, 'ГБУЗ ЦРБ Дубовского муниципального района' }, ;
    { 2024, '340137', 344, 301, 'ГБУЗ ЦРБ Клетского муниципального района' }, ;
    { 2024, '340153', 329, 288, 'ГБУЗ ЦРБ Ольховского муниципального района' }, ;
    { 2024, '340164', 668, 583, 'ГБУЗ ЦРБ Суровикинского муниципального района' }, ;
    { 2024, '340170', 319, 290, 'ГБУЗ Чернышковская ЦРБ' }, ;
    { 2024, '340122', 560, 543, 'ГБУЗ Еланская ЦРБ' }, ;
    { 2024, '340167', 1127, 1309, 'ГБУЗ Урюпинская ЦРБ' }, ;
    { 2024, '340140', 645, 629, 'ГБУЗ ЦРБ Котовского муниципального района' }, ;
    { 2024, '340124', 821, 699, 'ГУЗ Жирновская ЦРБ' }, ;
    { 2024, '340171', 805, 745, 'ЧУЗ КБ РЖД-Медицина г.Волгоград' }, ;
    { 2024, '340129', 944, 1024, 'ГБУЗ ЦГБ' }, ;
    { 2024, '340057', 915, 987, 'ГУЗ КБСМП № 15' }, ;
    { 2024, '340074', 909, 1194, 'КБ СМП № 7' }, ;
    { 2024, '340105', 1098, 992, 'ГБУЗ Городская клиническая больница №3' }, ;
    { 2024, '340109', 1338, 1643, 'ГБУЗ Городская поликлиника №5' }, ;           // конец 2024 года
    { 2025, '340033', 0, 0, 'ГУЗ Поликлиника № 4' }, ;
    { 2025, '340041', 0, 0, 'ГУЗ Клиническая поликлиника № 28' }, ;
    { 2025, '340042', 0, 0, 'ГУЗ Поликлиника № 30' }, ;
    { 2025, '340050', 0, 0, 'ГУЗ Поликлиника № 5' }, ;
    { 2025, '340055', 0, 0, 'ГУЗ Больница № 16' }, ;
    { 2025, '340066', 0, 0, 'ГУЗ Поликлиника № 2' }, ;
    { 2025, '340075', 0, 0, 'ГУЗ Клиническая больница № 11' }, ;
    { 2025, '340056', 0, 0, 'ГУЗ Больница №22' }, ;
    { 2025, '340083', 0, 0, 'ГУЗ КП № 1' }, ;
    { 2025, '340104', 0, 0, 'ГБУЗ ГКБ № 1 им. С.З.Фишера' }, ;
    { 2025, '340096', 0, 0, 'ГАУЗ КП № 3' }, ;
    { 2025, '340106', 0, 0, 'ГБУЗ Городская больница № 2' }, ;
    { 2025, '340117', 0, 0, 'ГБУЗ Алексеевская ЦРБ' }, ;
    { 2025, '340118', 0, 0, 'ГБУЗ Быковская ЦРБ' }, ;
    { 2025, '340119', 0, 0, 'ГБУЗ Городищенская ЦРБ' }, ;
    { 2025, '340158', 0, 0, 'ГБУ ЦРБ Руднянского муниципального района' }, ;
    { 2025, '340120', 0, 0, 'ГБУЗ Даниловская ЦРБ' }, ;
    { 2025, '340126', 0, 0, 'ГБУЗ Иловлинская ЦРБ' }, ;
    { 2025, '340127', 0, 0, 'ГБУЗ Калачевская ЦРБ' }, ;
    { 2025, '340136', 0, 0, 'ГБУЗ Киквидзенская ЦРБ' }, ;
    { 2025, '340138', 0, 0, 'ГБУЗ Котельниковская ЦРБ' }, ;
    { 2025, '340157', 0, 0, 'ГБУЗ Кумылженская ЦРБ' }, ;
    { 2025, '340142', 0, 0, 'ГБУЗ Ленинская ЦРБ' }, ;
    { 2025, '340148', 0, 0, 'ГБУЗ Нехаевская ЦРБ' }, ;
    { 2025, '340149', 0, 0, 'ГБУЗ Николаевская ЦРБ' }, ;
    { 2025, '340150', 0, 0, 'ГБУЗ Новоаннинская ЦРБ' }, ;
    { 2025, '340151', 0, 0, 'ГБУЗ Новониколаевская ЦРБ' }, ;
    { 2025, '340152', 0, 0, 'ГБУЗ Октябрьская ЦРБ' }, ;
    { 2025, '340155', 0, 0, 'ГБУЗ Палласовская ЦРБ' }, ;
    { 2025, '340159', 0, 0, 'ГБУЗ Светлоярская ЦРБ' }, ;
    { 2025, '340160', 0, 0, 'ГБУЗ Серафимовичская ЦРБ' }, ;
    { 2025, '340161', 0, 0, 'ГБУЗ Среднеахтубинская ЦРБ' }, ;
    { 2025, '340163', 0, 0, 'ГБУЗ Старополтавская ЦРБ' }, ;
    { 2025, '340169', 0, 0, 'ГБУЗ Фроловская ЦРБ' }, ;
    { 2025, '340121', 0, 0, 'ГБУЗ ЦРБ Дубовского муниципального района' }, ;
    { 2025, '340137', 0, 0, 'ГБУЗ ЦРБ Клетского муниципального района' }, ;
    { 2025, '340153', 0, 0, 'ГБУЗ ЦРБ Ольховского муниципального района' }, ;
    { 2025, '340164', 0, 0, 'ГБУЗ ЦРБ Суровикинского муниципального района' }, ;
    { 2025, '340170', 0, 0, 'ГБУЗ Чернышковская ЦРБ' }, ;
    { 2025, '340122', 0, 0, 'ГБУЗ Еланская ЦРБ' }, ;
    { 2025, '340167', 0, 0, 'ГБУЗ Урюпинская ЦРБ' }, ;
    { 2025, '340140', 0, 0, 'ГБУЗ ЦРБ Котовского муниципального района' }, ;
    { 2025, '340124', 0, 0, 'ГУЗ Жирновская ЦРБ' }, ;
    { 2025, '340171', 0, 0, 'ЧУЗ КБ РЖД-Медицина г.Волгоград' }, ;
    { 2025, '340129', 0, 0, 'ГБУЗ ЦГБ' }, ;
    { 2025, '340057', 0, 0, 'ГУЗ КБСМП № 15' }, ;
    { 2025, '340074', 0, 0, 'КБ СМП № 7' }, ;
    { 2025, '340105', 0, 0, 'ГБУЗ Городская клиническая больница №3' }, ;
    { 2025, '340109', 0, 0, 'ГБУЗ Городская поликлиника №5' } ;       // конец 2024 года
  }

  cmdText := 'CREATE TABLE plan_drz(year INTEGER, kod_mo TEXT(6), kol_m INTEGER, kol_f INTEGER, name_mo varchar( 40 ))'

  out_utf8_to_str( 'Плановые показатели по проведению диспансеризации репрдуктивного здоровья', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS plan_drz' ) == SQLITE_OK
    OutStd( 'DROP TABLE plan_drz - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE plan_drz - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE plan_drz - False' + hb_eol() )
    Return Nil
  Endif

  For k := 1 To Len( arr )
    mYear := str( arr[ k, 1 ], 4 )
    mKod := arr[ k, 2 ]
    mKol_m := str( arr[ k, 3 ] )
    mKol_f := str( arr[ k, 4 ] )
    mName := arr[ k, 5 ]

    count++
    cmdTextInsert += 'INSERT INTO plan_drz ( year, kod_mo, kol_m, kol_f, name_mo ) VALUES(' ;
      + "'" + mYear + "'," ;
      + "'" + mKod + "'," ;
      + "'" + mKol_m + "'," ;
      + "'" + mKol_f + "'," ;
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
