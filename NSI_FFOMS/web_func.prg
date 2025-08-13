#include 'fileio.ch'
#include 'common.ch'
  
function GetVersions( code )

  local hArr, aRet
  local cUrl, HTTPQuery, result, status, bodyJSON, nLengthDecoded
  local timeout := 5

  cUrl := hb_StrFormat( 'http://nsi.ffoms.ru/nsi-int/api/versions?identifier=%s', code )

  HTTPQuery := CreateObject( 'WinHttp.WinHttpRequest.5.1' )
  HTTPQuery:Option( 2, 'utf-8' )

  HTTPQuery:SetTimeouts( 15000, 15000, 15000, 15000 )
  HTTPQuery:Open( 'GET', cURL, 0 )
  HTTPQuery:SetRequestHeader( 'Accept-Charset', 'utf-8' )
  HTTPQuery:SetRequestHeader( 'Content-Type', 'application/json; charset=utf-8' )
  HTTPQuery:Send()
  result := HTTPQuery:WaitForResponse( timeout )

  if result
    status := HTTPQuery:status()
    if status == 200
      bodyJSON := AllTrim( HTTPQuery:ResponseText() )
      nLengthDecoded := hb_jsonDecode( bodyJSON, @hArr )
      aRet := hArr[ 'list' ]
    endif
  endif
  HTTPQuery := nil
  return aRet

function GetStructure( code )

  local hArr
  local cUrl, HTTPQuery, result, status, bodyJSON, nLengthDecoded
  local timeout := 5

	cUrl := hb_StrFormat( 'http://nsi.ffoms.ru/nsi-int/api/structure?identifier=%s', code )

  HTTPQuery := CreateObject( 'WinHttp.WinHttpRequest.5.1' )
  HTTPQuery:Option( 2, 'utf-8' )

  HTTPQuery:SetTimeouts( 15000, 15000, 15000, 15000 )
  HTTPQuery:Open( 'GET', cURL, 0 )
  HTTPQuery:SetRequestHeader( 'Accept-Charset', 'utf-8' )
  HTTPQuery:SetRequestHeader( 'Content-Type', 'application/json; charset=utf-8' )
  HTTPQuery:Send()
  result := HTTPQuery:WaitForResponse( timeout )

  if result
		status := HTTPQuery:status()
    if status == 200
      bodyJSON := AllTrim( HTTPQuery:ResponseText() )
      nLengthDecoded := hb_jsonDecode( bodyJSON, @hArr )
//    aRet := aDict[ 'list' ]
    endif
  endif
  HTTPQuery := nil

  return hArr

// 12,08,25 GetFile загружает zip-архив последней версии справочника в формате XML
function GetFile( hDict, destination )

  local lReturn := .f., s, id, version
  local cUrl, HTTPQuery, result, status, body
  local timeout := 5, headers
  local st, zipFile, nameZIP

  if isnil( destination ) .or. Empty( destination )
    destination := '.\'
  endif
  s := Split( hDict[ 'providerParam' ], 'v' )
  id := AllTrim( s[ 1 ] )
  version := AllTrim( s[ 2 ] )

//	cUrl := hb_StrFormat( 'http://nsi.ffoms.ru/refbook?type=XML&id=%s&version=%s', id, version)
	cUrl := 'http://nsi.ffoms.ru/refbook?type=XML&' + 'id=' + id + '&' + 'version=' + version

  HTTPQuery := CreateObject( 'WinHttp.WinHttpRequest.5.1' )
  HTTPQuery:Option( 2, 'utf-8' )

  HTTPQuery:SetTimeouts( 15000, 15000, 15000, 15000 )
  HTTPQuery:Open( 'GET', cURL, 0 )
  HTTPQuery:SetRequestHeader( 'Content-Type', 'application/zip' )
  HTTPQuery:Send()
  result := HTTPQuery:WaitForResponse( timeout )

  if result
    headers := HTTPQuery:getAllResponseHeaders()
		status := HTTPQuery:status()
    if status == 200
      body := HTTPQuery:ResponseBody()
      nameZIP := hDict[ 'd' ][ 'code' ] + '_' + hDict[ 'user_version' ] + '_XML.zip'
      zipFile := destination + nameZIP
      hb_MemoWrit( zipFile, body )

      st := hb_Utf8ToStr( 'Загрузка справочника ' + nameZIP, 'RU866' )	
      OutStd( hb_eol() + st + hb_eol() )
      lReturn := .t.
    endif
  endif
  HTTPQuery := nil
  return lReturn

// FindDictionary получает последнюю версию справочника по его коду
function FindDictionary( code )

  local collection := GetDictionaryListFFOMS()
  local hValues, arr, v

  code := Upper( code )
	for each v in collection
    arr := hb_hValues( v )
    if arr[ 6 ][ 'code' ] == code
      hValues := v
    endif
  next
  return hValues

// GetDictionaryList получает список справочников с сайта ФФОМС
function GetDictionaryListFFOMS()

  local aDict, aRet
  local HTTPQuery, result, timeout := 5
  local status, statusText, bodyJSON, nLengthDecoded
  local cURL := 'http://nsi.ffoms.ru/data?pageId=refbookList&containerId=refbookList&size=110'

  HTTPQuery := CreateObject( 'WinHttp.WinHttpRequest.5.1' )
  HTTPQuery:Option( 2, 'utf-8' )

  HTTPQuery:SetTimeouts( 15000, 15000, 15000, 15000 )
  HTTPQuery:Open( 'GET', cURL, 0 )
  HTTPQuery:SetRequestHeader( 'Accept-Charset', 'utf-8' )
  HTTPQuery:SetRequestHeader( 'Content-Type', 'application/json; charset=utf-8' )
  HTTPQuery:Send()
  result := HTTPQuery:WaitForResponse( timeout )

  if result
		status := HTTPQuery:status()
    statusText := HTTPQuery:statusText()
    bodyJSON := AllTrim( HTTPQuery:ResponseText() )
    nLengthDecoded := hb_jsonDecode( bodyJSON, @aDict )
    aRet := aDict[ 'list' ]
  endif

  HTTPQuery := nil
  return aRet
