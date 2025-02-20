//#include 'function.ch'
//#include 'dict_error.ch'

#require 'hbsqlit3'

#define COMMIT_COUNT  500

Static textBeginTrans := 'BEGIN TRANSACTION;'
Static textCommitTrans := 'COMMIT;'

// 01.06.23
Function make_other( db, source )

  db_holiday(db, source)
  Return Nil

// 20.02.25
Function db_holiday( db ) //, source )

  // Календарь выходных и праздничных дней
  // 1 - NAME(C)  2 - KOD(C)

  Local cmdText
  Local k, i
  Local mYear, mMonth, mHoliday
  Local mArr
  Local count := 0, cmdTextInsert := textBeginTrans

  Local arr_holiday := { ;
    { 2013, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 2, '[ 2, 3, 9, 10, 16, 17, 23, 24 ]' }, ;
    { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 4, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 11, '[ 2, 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 12, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' } } ;
    }, ;
    { 2014, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23 ]' }, ;
    { 3, '[ 1, 2, 8, 9, 10, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 4, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 6, '[ 1, 7, 8, 12, 13, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 7, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 8, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 9, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 10, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 11, '[ 1, 2, 3, 4, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 12, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' } } ;
    }, ;
    { 2015, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 2, '[ 1, 7, 8, 14, 15, 21, 22, 23, 28 ]' }, ;
    { 3, '[ 1, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 4, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 9, 10, 11, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 6, '[ 6, 7, 12, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 7, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 8, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 9, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 10, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 11, '[ 1, 4, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 12, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' } } ;
    }, ;
    { 2016, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 2, '[ 6, 7, 13, 14, 21, 22, 23, 27, 28 ]' }, ;
    { 3, '[ 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 4, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 5, '[ 1, 2, 3, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 6, '[ 4, 5, 11, 12, 13, 18, 19, 25, 26 ]' }, ;
    { 7, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 8, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 9, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
    { 10, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 11, '[ 4, 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 12, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' } } ;
    }, ;
    { 2017, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 2, '[ 4, 5, 11, 12, 18, 19, 23, 24, 25, 26 ]' }, ;
    { 3, '[ 4, 5, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 4, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 5, '[ 1, 6, 7, 8, 9, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 6, '[ 3, 4, 10, 11, 12, 17, 18, 24, 25 ]' }, ;
    { 7, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 8, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 9, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 10, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 11, '[ 4, 5, 6, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 12, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' } } ;
    }, ;
    { 2018, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 2, '[ 3, 4, 10, 11, 17, 18, 23, 24, 25 ]' }, ;
    { 3, '[ 3, 4, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 4, '[ 1, 7, 8, 14, 15, 21, 22, 29, 30 ]' }, ;
    { 5, '[ 1, 2, 5, 6, 9, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 6, '[ 2, 3, 10, 11, 12, 16, 17, 23, 24, 30 ]' }, ;
    { 7, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 8, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 9, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 10, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 11, '[ 3, 4, 5, 10, 11, 17, 18, 24, 25 ]' }, ;
    { 12, '[ 1, 2, 8, 9, 15, 16, 22, 23, 30, 31 ]' } } ;
    }, ;
    { 2019, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 2, '[ 2, 3, 9, 10, 16, 17, 23, 24 ]' }, ;
    { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 4, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 11, '[ 2, 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 12, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' } } ;
    }, ;
    { 2020, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23, 24, 29 ]' }, ;
    { 3, '[ 1, 7, 8, 9, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 4, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 5, 9, 10, 11, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 6, '[ 6, 7, 12, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 7, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 8, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 9, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 10, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 11, '[ 1, 4, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 12, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' } } ;
    }, ;
    { 2021, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 2, '[ 6, 7, 13, 14, 21, 22, 23, 27, 28 ]' }, ;
    { 3, '[ 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 4, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
    { 5, '[ 1, 2, 3, 8, 9, 10, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 6, '[ 5, 6, 12, 13, 14, 19, 20, 26, 27 ]' }, ;
    { 7, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 8, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 9, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 10, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 11, '[ 4, 5, 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 12, '[ 4, 5, 11, 12, 18, 19, 25, 26, 31 ]' } } ;
    }, ;
    { 2022, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 2, '[ 5, 6, 12, 13, 19, 20, 23, 26, 27 ]' }, ;
    { 3, '[ 6, 7, 8, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 4, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 5, '[ 1, 2, 3, 7, 8, 9, 10, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 6, '[ 4, 5, 11, 12, 13, 18, 19, 25, 26 ]' }, ;
    { 7, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 8, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 9, '[ 3, 4, 10, 11, 17, 18, 24, 25 ]' }, ;
    { 10, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 11, '[ 4, 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 12, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' } } ;
    }, ;
    { 2023, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 2, '[ 4, 5, 11, 12, 18, 19, 23, 24, 25, 26 ]' }, ;
    { 3, '[ 4, 5, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 4, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 5, '[ 1, 6, 7, 8, 9, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 6, '[ 3, 4, 10, 11, 12, 17, 18, 24, 25 ]' }, ;
    { 7, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 8, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 9, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 10, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 11, '[ 4, 5, 6, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 12, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' } } ;
    }, ;
    { 2024, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 2, '[ 3, 4, 10, 11, 17, 18, 23, 24, 25 ]' }, ;
    { 3, '[ 2, 3, 8, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 4, '[ 6, 7, 13, 14, 20, 21, 28, 29, 30 ]' }, ;
    { 5, '[ 1, 4, 5, 9, 10, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 6, '[ 1, 2, 8, 9, 12, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 7, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 8, '[ 3, 4, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 9, '[ 1, 7, 8, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 10, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 11, '[ 3, 4, 9, 10, 16, 17, 23, 24, 30 ]' }, ;
    { 12, '[ 1, 7, 8, 14, 15, 21, 22, 29, 30, 31 ]' } } ;
    }, ;
    { 2025, { ;
    { 1, '[ 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 2, '[ 1, 2, 8, 9, 15, 16, 22, 23 ]' }, ;
    { 3, '[ 1, 2, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 4, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 5, '[ 1, 2, 3, 4, 8, 9, 10, 11, 17, 18, 24, 25, 31 ]' }, ;
    { 6, '[ 1, 7, 8, 12, 13, 14, 15, 21, 22, 28, 29 ]' }, ;
    { 7, '[ 5, 6, 12, 13, 19, 20, 26, 27 ]' }, ;
    { 8, '[ 2, 3, 9, 10, 16, 17, 23, 24, 30, 31 ]' }, ;
    { 9, '[ 6, 7, 13, 14, 20, 21, 27, 28 ]' }, ;
    { 10, '[ 4, 5, 11, 12, 18, 19, 25, 26 ]' }, ;
    { 11, '[ 2, 3, 4, 8, 9, 15, 16, 22, 23, 29, 30 ]' }, ;
    { 12, '[ 6, 7, 13, 14, 20, 21, 27, 28, 31 ]' } } ;
    } ;
  }

  cmdText := 'CREATE TABLE calendar( m_year INTEGER, m_month INTEGER, description TEXT )'

//  out_utf8_to_str( 'Список выходных и праздников', 'RU866' )	

  If sqlite3_exec( db, 'DROP TABLE if EXISTS calendar' ) == SQLITE_OK
    OutStd( 'DROP TABLE calendar - Ok' + hb_eol() )
  Endif

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE calendar - Ok' + hb_eol() )
  Else
    OutStd( 'CREATE TABLE calendar - False' + hb_eol() )
    Return Nil
  Endif

  For k := 1 To Len( arr_holiday )
    mYear := str( arr_holiday[ k, 1 ], 4 )
    mArr := arr_holiday[ k, 2 ]

    for i := 1 to 2
      mMonth := AllTrim( str( mArr[ i, 1 ], 2 ) )
      mHoliday := mArr[ i, 2 ]
      count++
      cmdTextInsert += "INSERT INTO calendar (m_year, m_month, description ) VALUES(" ;
        + "'" + mYear + "'," ;
        + "'" + mMonth + "'," ;
        + "'" + mHoliday + "');"
      If count == COMMIT_COUNT
        cmdTextInsert += textCommitTrans
        sqlite3_exec( db, cmdTextInsert )
        count := 0
        cmdTextInsert := textBeginTrans
      Endif
    next

  Next
  If count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec( db, cmdTextInsert )
  Endif
//  out_obrabotka_eol()
  Return Nil
