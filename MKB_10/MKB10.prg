
external errorsys

proc main()

  local sys_date := date(), sys_year := year(date())
  local dbName := '_mo_mkb'
  local dbTFOMS := 'mkb_10_tf'
  local dbSource := 'm001'
  local aRemoved := {}, aAdded := {}
  local lastNotFound

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

  // dbUseArea( .t.,, dbSource, dbSource, .t., .f. )
  // index on MKB_CODE to (dbSource)
  
  dbUseArea( .t.,, dbName, dbName, .t., .f. )

  (dbTFOMS)->(dbGoTop())
  do while ! (dbTFOMS)->(EOF())
    (dbName)->(dbAppend())
    (dbName)->SHIFR := (dbTFOMS)->CODED
    (dbName)->NAME  := substr((dbTFOMS)->NAMED, 1, 65)
    (dbName)->KS    := 0
    (dbName)->DBEGIN:= (dbTFOMS)->DATE_B
    (dbName)->DEND  := (dbTFOMS)->DATE_E
    if ! empty((dbTFOMS)->W)
      (dbName)->POL   := iif((dbTFOMS)->W == '1', 'М', 'Ж')
    endif
    (dbName)->KOL   := 1

    // if len(alltrim((dbTFOMS)->NAMED)) > 65
    //   ? (dbTFOMS)->NAMED
    //   // aResult := hb_Regex( '.{0,50}(?=\\s|$)', alltrim((dbTFOMS)->NAMED), , )
    //   // ? aResult[1]
    //   // ? aResult[2]
    //   exit
    // endif

  //   dbSelectArea(dbSource)
  //   if dbSeek((dbName)->SHIFR)
  //     if (dbName)->(dbRLock())
  //       if (dbSource)->ACTUAL == 1
  //         (dbName)->DEND := CToD('  /  /    ')
  //       elseif (dbSource)->ACTUAL == 0
  //         (dbName)->DEND := CToD((dbSource)->DATE)
  //         aadd(aRemoved,{(dbName)->shifr,(dbName)->Name})
  //       endif
  //       (dbName)->(dbUnlock())
  //     endif
  //   else
  //     if Empty((dbName)->DEND)
  //       if lastNotFound != (dbName)->SHIFR
  //         lastNotFound := (dbName)->SHIFR
  //         aadd(aRemoved,{(dbName)->shifr,(dbName)->Name})
  //       endif
  //       if (dbName)->(dbRLock())
  //         (dbName)->DEND := CToD('28/02/2021')
  //         (dbName)->(dbUnlock())
  //       endif
  //     endif
  //   endif
  //   dbSelectArea(dbName)
    (dbTFOMS)->(dbSkip())
  end

  inkey(0)
  // // fp := fcreate("notFoundMKB.txt")
  // // for j := 1 to len(aRemoved)
  // //   add_string(aRemoved[j,1] + " - " + aRemoved[j,2])
  // // next
  // // fclose(fp)

  // dbSelectArea(dbName)
  // index on SHIFR to (dbName)

  // dbSelectArea(dbSource)
  // (dbSource)->(dbGoTop())
  // do while !(dbSource)->(EOF())
  //   if ! empty((dbSource)->MKB_CODE)
  //     dbSelectArea(dbName)
  //     if ((dbSource)->ACTUAL == 1)
  //       if !dbSeek((dbSource)->MKB_CODE)
  //         (dbName)->(dbAppend())
  //         (dbName)->SHIFR := (dbSource)->MKB_CODE
  //         (dbName)->NAME := (dbSource)->MKB_NAME
  //         (dbName)->KS := 0
  //         (dbName)->DBEGIN := CToD((dbSource)->DATE)
  //         aadd(aAdded,{(dbSource)->MKB_CODE,(dbSource)->MKB_NAME})
  //       endif
  //     endif
  //     dbSelectArea(dbSource)
  //   endif
  //   (dbSource)->(dbSkip())
  // end

  // // fp := fcreate("newMKB.txt")
  // // for j := 1 to len(aAdded)
  // //   add_string(aAdded[j,1] + " - " + aAdded[j,2])
  // // next
  // // fclose(fp)
  
  // (dbSource)->(dbCloseArea())

  // dbSelectArea(dbName)
  // (dbName)->(dbGoTop())
  // do while !(dbName)->(EOF())
  //   dbSelectArea(dbTFOMS)
  //   if dbSeek((dbName)->SHIFR)
  //     if (dbName)->(dbRLock())
  //       (dbName)->DBEGIN := (dbTFOMS)->DATE_B
  //       (dbName)->DEND := (dbTFOMS)->DATE_E
  //       (dbName)->(dbUnlock())
  //     endif
  //   endif
  //   dbSelectArea(dbName)
  //   (dbName)->(dbSkip())
  // end

  
  // (dbName)->(dbCloseArea())
  // (dbTFOMS)->(dbCloseArea())

  // filedelete(dbName + '.ntx')
  // filedelete(dbSource + '.ntx')
  // filedelete(dbTFOMS + '.ntx')

  // if WriteToExcel(aAdded, aRemoved) != 0
  //   ? 'ERROR'
  // endif

  f_end()
  return
  
