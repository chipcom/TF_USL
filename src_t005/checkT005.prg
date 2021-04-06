#include 'function.ch'

external errorsys

proc main()

  local dbName := '_mo_t005'
  local dbSource := 'T005'

  f_first()

  dbUseArea( .t.,, dbName, dbName, .t., .f. )
  index on KOD to (dbName)

  dbUseArea( .t.,, dbSource, dbSource, .t., .f. )
  do while !(dbSource)->(EOF())
    if (dbName)->(dbSeek((dbSource)->CODE))
      // нашли
      if empty( (dbName)->OPIS )
        if (dbName)->(dbRLock())
          (dbName)->OPIS := (dbSource)->OPIS
          (dbName)->(dbUnlock())
        endif
      endif
    else
      (dbName)->(dbAppend())
      if (dbName)->(dbRLock())
        (dbName)->KOD := (dbSource)->CODE
        (dbName)->NAME := lstr((dbSource)->CODE) + ' ' +(dbSource)->ERROR
        (dbName)->OPIS := (dbSource)->OPIS
        (dbName)->(dbUnlock())
      endif
    endif
    (dbSource)->(dbSkip())
  end

  (dbName)->(dbCloseArea())
  (dbSource)->(dbCloseArea())
  filedelete(dbName + '.ntx')

  f_end()
  return
  
