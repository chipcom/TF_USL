
// http://clipper.borda.ru/?1-4-0-00000749-000-10001-0-1451935634

Function Read_XLS
  Local cFile := 'TEST.XLS'
  
  oConection = todbc():new("Driver={Microsoft Excel Driver (*.xls)};DriverId=790;Dbq="+ cFile + ";DefaultDir="+GetCurrentFolder()+";")
  oConection:Setsql("SELECT * FROM [‹ˆ‘’1$]")
  
  if !oConection:Open()
  ? " Error connection "
  return
  endif
  
  for n := 1 to len(oConexion:aRecordSet)
  for j := 1 to len(oConection:aRecordSet[n])
  do case
  case valtype(oConection:aRecordSet[n][j]) == "C"
  ? alltrim(oConection:aRecordSet[n][j])
  case valtype(oConection:aRecordSet[n][j]) == "N"
  ? alltrim(str(oConection:aRecordSet[n][j]))
  case valtype(oConection:aRecordSet[n][j]) == "D"
  ? alltrim(DtoC(oConection:aRecordSet[n][j]))
  case valtype(oConection:aRecordSet[n][j]) == "L"
  ? alltrim(oConection:aRecordSet[n][j])
  end case
  next
  next
  
  oConection:Close()
  oConection:Destroy()
  Return