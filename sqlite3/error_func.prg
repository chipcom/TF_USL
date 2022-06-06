#include 'function.ch'
#include 'dict_error.ch'

****** 06.06.22
function out_error(nError, nfile, j, k)

  do case
    case nError == FILE_NOT_EXIST
      OutErr('Файл ', nfile, ' не существует', hb_eol())
    case nError == FILE_READ_ERROR
      OutErr('Ошибка в загрузке файла ', nfile, hb_eol())
    case nError == FILE_RENAME_ERROR
      OutErr('Ошибка переименования файла ', nfile, hb_eol())
    case nError == DIR_IN_NOT_EXIST
      OutErr('Каталог исходных данных "', nfile, '" не существует. Продолжение работы не возможно!', hb_eol())
    case nError == DIR_OUT_NOT_EXIST
      OutErr('Каталог для выходных данных "', nfile, '" не существует. Продолжение работы не возможно!', hb_eol())
    case nError == TAG_YEAR_REPORT
        OutErr('Ошибка при чтении файла "', nfile, '". Некорректное значение тега YEAR_REPORT ', j, hb_eol())
    case nError == TAG_PLACE_ERROR
        OutErr('Ошибка при чтении файла "', nfile, '" - более одного тега PLACE в отделении: ', alltrim(j), hb_eol())
    case nError == TAG_PERIOD_ERROR
        OutErr('Ошибка при чтении файла "', nfile, '" - более одного тега PERIOD в учреждении: ', j, ' в услуге ', k, hb_eol())
    case nError == TAG_VALUE_EMPTY
        OutErr('Замечание при чтении файла "', nfile, '" - пустое значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol())
    case nError == TAG_VALUE_INVALID
        OutErr('Замечание при чтении файла "', nfile, '" - некорректное значение тега VALUE/LEVEL: ', j, ' в услуге ', k, hb_eol())
    case nError == TAG_ROW_INVALID
        OutErr('Ошибка при загрузки строки - ', j, ' из файла ',nfile, hb_eol())
    case nError == UPDATE_TABLE_ERROR
        OutErr('Ошибка обновления записей в таблице - ', nfile, hb_eol())
    case nError == PACK_ERROR
        OutErr('Ошибка при очистки БД - ', nfile, hb_eol())
    case nError == INVALID_COMMAND_LINE
        OutErr('Совместное использование опций -all и -update недопустимо', hb_eol())
  end case

  return nil
