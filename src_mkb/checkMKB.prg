// #include "edit_spr.ch"
// #include "function.ch"

external errorsys

proc main()

  local sys_date := date(), sys_year := year(date())
  local dbName := '_mo_mkb', dbSource := 'm001'
  local aRemoved := {}, aAdded := {}
  local lastNotFound
  f_first()

  dbUseArea( .t.,, dbSource, dbSource, .t., .f. )
  index on MKB_CODE to (dbSource)
  
  dbUseArea( .t.,, dbName, dbName, .t., .f. )
  (dbName)->(dbGoTop())
  do while !(dbName)->(EOF())
    // ? (dbName)->SHIFR
    dbSelectArea(dbSource)
    if dbSeek((dbName)->SHIFR)
      if (dbName)->(dbRLock())
        if (dbSource)->ACTUAL == 1
          (dbName)->DEND := CToD('  /  /    ')
        elseif (dbSource)->ACTUAL == 0
          (dbName)->DEND := CToD((dbSource)->DATE)
        endif
        (dbName)->(dbUnlock())
      endif
    else
      if Empty((dbName)->DEND)
        if lastNotFound != (dbName)->SHIFR
          lastNotFound := (dbName)->SHIFR
          aadd(aRemoved,{(dbName)->shifr,(dbName)->Name})
        endif
        if (dbName)->(dbRLock())
          (dbName)->DEND := CToD('28/02/2021')
          (dbName)->(dbUnlock())
        endif
      endif
    endif
    dbSelectArea(dbName)
    (dbName)->(dbSkip())
  end
  // fp := fcreate("notFoundMKB.txt")
  // for j := 1 to len(aRemoved)
  //   add_string(aRemoved[j,1] + " - " + aRemoved[j,2])
  // next
  // fclose(fp)

  dbSelectArea(dbName)
  index on SHIFR to (dbSource)

  dbSelectArea(dbSource)
  (dbSource)->(dbGoTop())
  do while !(dbSource)->(EOF())
    if ! empty((dbSource)->MKB_CODE)
      dbSelectArea(dbName)
      if ((dbSource)->ACTUAL == 1) .and. ! dbSeek((dbSource)->MKB_CODE)
        // TODO
        aadd(aAdded,{(dbSource)->MKB_CODE,(dbSource)->MKB_NAME})
      endif
      dbSelectArea(dbSource)
    endif
    (dbSource)->(dbSkip())
  end

  // fp := fcreate("newMKB.txt")
  // for j := 1 to len(aAdded)
  //   add_string(aAdded[j,1] + " - " + aAdded[j,2])
  // next
  // fclose(fp)
  
  
  (dbName)->(dbCloseArea())
  (dbSource)->(dbCloseArea())

  filedelete(dbName + '.ntx')
  filedelete(dbSource + '.ntx')

  if WriteToExcel(aAdded, aRemoved) != 0
    ? 'ERROR'
  endif

  // inkey(0)

  f_end()
  return
  
