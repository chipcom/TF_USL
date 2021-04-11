#include "function.ch"

external errorsys

proc main()
  local sys_date := date(), sys_year := year(date())
  local dbName := '_mo_mkb'
  local dbTFOMS := 'mkb_10_tf'
  local aResult

  f_first()

  // MKB-10 Классификатор диагнозов
  dbcreate( dbName, { ;
    { 'SHIFR', 'C',  6, 0 },; // Шифр диагноза
    { 'NAME',  'C', 65, 0 },; // Наименование диагноза
    { 'KS',    'N',  1, 0 },; // Номер строки для длинных диагнозов
    { 'DBEGIN','D',  8, 0 },; // Дата начала действия диагноза
    { 'DEND',  'D',  8, 0 },; // Дата окончания действия диагноза
    { 'POL',   'C',  1, 0 },; // Пол на который распространяется диагноз
    { 'KOL',   'N',  1, 0 };  // Число строк в наименовании
  })

  dbUseArea( .t.,, dbTFOMS, dbTFOMS, .t., .f. )
  index on CODED to (dbTFOMS)

  dbUseArea( .t.,, dbName, dbName, .t., .f. )

  (dbTFOMS)->(dbGoTop())
  do while ! (dbTFOMS)->(EOF())
    aResult := splitStrToArray( alltrim((dbTFOMS)->NAMED), 65 )
    lenResult := len(aResult)

    for i := 1 to lenResult
      (dbName)->(dbAppend())
      (dbName)->SHIFR := (dbTFOMS)->CODED
      (dbName)->NAME  := aResult[i]
      (dbName)->KS    := i - 1
      (dbName)->DBEGIN:= (dbTFOMS)->DATE_B
      (dbName)->DEND  := (dbTFOMS)->DATE_E
      if ! empty((dbTFOMS)->W)
        (dbName)->POL   := iif((dbTFOMS)->W == '1', 'М', 'Ж')
      endif
      (dbName)->KOL   := lenResult
    next

    (dbTFOMS)->(dbSkip())
  end

  filedelete(dbTFOMS + '.ntx')

  f_end()
  return
