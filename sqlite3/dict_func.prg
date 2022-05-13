#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

#require 'hbsqlit3'

** 12.05.22
function clear_name_table(table)

  table := Lower(alltrim(table))
  return substr(table, 1, At('.', table) - 1)

** 12.05.22
function create_table(db, table, cmdText)
  // db - дескриптор SQL БД
  // table - имя таблицы вида name.xml
  // cmdText - строка команды SQL для создания таблицы SQL БД
  local ret := .f.
  
  table := clear_name_table(table)

  drop_table(db, table)
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('CREATE TABLE ' + table + ' - Ok' + hb_eol() )
    ret := .t.
  else
    OutStd('CREATE TABLE ' + table + ' - False' + hb_eol() )
  endif
  return ret

** 12.05.22
function drop_table(db, table)
  // db - дескриптор SQL БД
  // table - имя таблицы SQL БД
  local cmdText
  
  cmdText := 'DROP TABLE if EXISTS ' + table

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    OutStd('DROP TABLE ' + table + ' - Ok' + hb_eol())
  endif
  return nil

procedure About()

  OutStd( ;
      'Конвертер справочников обязательного медицинского страхования' + hb_eol() + ;
      'Copyright (c) 2022, Vladimir G.Baykin' + hb_eol() + hb_eol())
   
  OutStd( ;
      'Syntax:  create_dict [options] ' + hb_eol() + hb_eol())
  OutStd( ;
      'Опции:' + hb_eol() + ;
      '      -in=<source directory>' + hb_eol() + ;
      '      -out=<destination directory>' + hb_eol() + ;
      '      -all - конвертировать все' + hb_eol() + ;
      '      -update - конвертация отдельных файлов' + hb_eol() + ;
      '      -help - помощь' + hb_eol() ;
  )
      
  return
   
** 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say "Обработка файла " + nfile + " -"
  return Col()

** 13.02.22
function out_obrabotka(nfile)

  OutStd( ;
    '===== Обработка файла ' + nfile )
  return nil

** 15.02.22
function out_create_file(nfile)

  OutStd( ;
    'Создание файла ' + nfile )
  return nil

** 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

** 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + "%" )
  return nil
