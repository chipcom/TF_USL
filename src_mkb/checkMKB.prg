// #include "edit_spr.ch"
// #include "function.ch"

external errorsys

proc main()

  local sys_date := date(), sys_year := year(date())
  local dbName := '_mo_mkb', dbSource := 'm001'
  local notFound := 0, aup := {}
  f_first()

  // use (dbSource) new alias (dbSource)
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
        notFound++
        aadd(aup,{(dbName)->shifr,(dbName)->Name})
        if (dbName)->(dbRLock())
          (dbName)->DEND := CToD('28/02/2021')
          (dbName)->(dbUnlock())
        endif
      endif
    endif
    dbSelectArea(dbName)
    (dbName)->(dbSkip())
  end
  fp := fcreate("notFoundMKB.txt") ; n_list := 1 ; tek_stroke := 0
  for j := 1 to len(aup)
    // for i := 1 to len(aup[j,3])
    //   s += lstr(aup[j,3,i])+"-"+inieditspr(A__MENUVERT,glob_V021,aup[j,3,i])
    //   if i < len(aup[j,3])
    //     s += ","
    //   endif
    // next
    add_string(aup[j,1] + " - " + aup[j,2])
  next
  fclose(fp)
  
  // ? notFound
  // inkey(0)
  
  (dbName)->(dbCloseArea())
  (dbSource)->(dbCloseArea())
  f_end()
  return
  