#include 'directry.ch'
#include 'function.ch'
 #include 'mkb_error.ch'

#require 'hbsqlit3'

// 12.12.25
Procedure about()

  OutStd( 'Конвертер справочников МКБ-10', hb_eol(), ;
    'Copyright (c) 2025, Vladimir G.Baykin', hb_eol(), hb_eol() )
  OutStd( 'Syntax:  mkb_sql [options] ', hb_eol(), hb_eol() )
  OutStd( 'Опции:', hb_eol(), ;
    '      -in=<source directory>', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -help - помощь', hb_eol() )

  Return

// 12.12.25
Function out_error( nError, nfile, j, k )

  Do Case
  Case nError == FILE_NOT_EXIST
    OutErr( 'Файл ', nfile, ' не существует', hb_eol() )
  Case nError == FILE_READ_ERROR
    OutErr( 'Ошибка в загрузке файла ', nfile, hb_eol() )
  Case nError == FILE_RENAME_ERROR
    OutErr( 'Ошибка переименования файла ', nfile, hb_eol() )
  Case nError == DIR_IN_NOT_EXIST
    OutErr( 'Каталог исходных данных "', nfile, '" не существует. Продолжение работы не возможно!', hb_eol() )
  Case nError == DIR_OUT_NOT_EXIST
    OutErr( 'Каталог для выходных данных "', nfile, '" не существует. Продолжение работы не возможно!', hb_eol() )
  Case nError == TAG_YEAR_REPORT
    OutErr( 'Ошибка при чтении файла "', nfile, '". Некорректное значение тега YEAR_REPORT ', j, hb_eol() )
  Case nError == TAG_PLACE_ERROR
    OutErr( 'Ошибка при чтении файла "', nfile, '" - более одного тега PLACE в отделении: ', AllTrim( j ), hb_eol() )
  Case nError == TAG_PERIOD_ERROR
    OutErr( 'Ошибка при чтении файла "', nfile, '" - более одного тега PERIOD в учреждении: ', j, ' в услуге ', k, hb_eol() )
  Case nError == TAG_VALUE_EMPTY
    OutErr( 'Замечание при чтении файла "', nfile, '" - пустое значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol() )
  Case nError == TAG_VALUE_INVALID
    OutErr( 'Замечание при чтении файла "', nfile, '" - некорректное значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol() )
  Case nError == TAG_ROW_INVALID
    OutErr( 'Ошибка при загрузки строки - ', j, ' из файла ', nfile, hb_eol() )
  Case nError == UPDATE_TABLE_ERROR
    OutErr( 'Ошибка обновления записей в таблице - ', nfile, hb_eol() )
  Case nError == PACK_ERROR
    OutErr( 'Ошибка при очистки БД - ', nfile, hb_eol() )
  Case nError == INVALID_COMMAND_LINE
    OutErr( 'Совместное использование опций -all и -update недопустимо', hb_eol() )
  End Case

  Return Nil

// 12.12.25
Function out_obrabotka_eol()

  OutStd( hb_eol() )

  Return Nil

// 12.12.25
function out_utf8_to_str( str_in )

  OutStd( hb_eol() + hb_Utf8ToStr( str_in, 'RU866' ) + hb_eol() )
  return nil