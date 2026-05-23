#include 'hbsqlit3.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

// 26.12.24
function out_utf8_to_str( str_in )

  OutStd( hb_eol() + hb_Utf8ToStr( str_in, 'RU866' ) + hb_eol() )
  return nil

// 15.05.22
Function clear_name_table( table )

  table := Lower( AllTrim( table ) )

  Return hb_FNameName( table )

// 12.05.22
Function create_table( db, table, cmdText )

  // db - дескриптор SQL БД
  // table - имя таблицы вида name.xml
  // cmdText - строка команды SQL для создания таблицы SQL БД
  Local ret := .f.

  table := clear_name_table( table )

  drop_table( db, table )
  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE TABLE ' + table + ' - Ok', hb_eol() )
    ret := .t.
  Else
    OutStd( 'CREATE TABLE ' + table + ' - False', hb_eol() )
  Endif

  Return ret

// 23.05.26
Function drop_table( db, table )

  // db - дескриптор SQL БД
  // table - имя таблицы SQL БД
  Local cmdText, lRet := .f.

  cmdText := 'DROP TABLE if EXISTS ' + table

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'DROP TABLE ' + table + ' - Ok', hb_eol() )
    lRet := .t.
  Endif

  Return lRet

// 12.05.22
Function create_index( db, name_index, cmdText )

  // db - дескриптор SQL БД
  // name_index - имя индекса вида name.xml
  // cmdText - строка команды SQL для создания таблицы SQL БД
  Local ret := .f.

//  table := clear_name_table( table )

  drop_index( db, name_index )
  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'CREATE INDEX ' + name_index + ' - Ok', hb_eol() )
    ret := .t.
  Else
    OutStd( 'CREATE INDEX ' + name_index + ' - False', hb_eol() )
  Endif

  Return ret

// 23.05.26
Function drop_index( db, name )

  // db - дескриптор SQL БД
  // name - имя индекса SQL БД
  Local cmdText, lRet := .f.

  cmdText := 'DROP INDEX if EXISTS ' + name

  If sqlite3_exec( db, cmdText ) == SQLITE_OK
    OutStd( 'DROP INDEX ' + name + ' - Ok', hb_eol() )
    lRet := .t.
  Endif

  Return lRet

// 23.05.26
Procedure about()

  OutStd( 'Конвертер справочников ГИС ОМС', hb_eol(), ;
    'Copyright (c) 2022, Vladimir G.Baykin', hb_eol(), hb_eol() )
  OutStd( 'Syntax:  create_dict [options] ', hb_eol(), hb_eol() )
  OutStd( 'Опции:', hb_eol(), ;
    '      -in=<source directory>', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -help - помощь', hb_eol() )

  Return

// 11.02.22
Function obrabotka( nfile )

  @ Row() + 1, 1 Say 'Обработка файла ' + nfile + ' -'

  Return Col()

// 20.12.24
Function out_obrabotka( nfile )

  local st

  st := hb_Utf8ToStr( '===== Обработка файла ', 'RU866' )	

  OutStd( st + nfile )

  Return Nil

// 15.02.22
Function out_create_file( nfile )

  OutStd( 'Создание файла ' + nfile )

  Return Nil

// 14.02.22
Function out_obrabotka_eol()

  OutStd( hb_eol() )

  Return Nil

// 27.01.26
Function out_obrabotka_count( j, k )

  j := 0
  k := 0
  // OutStd( str(j / k * 100, 6, 2) + "%" )

  Return Nil
