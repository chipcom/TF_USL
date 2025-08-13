#include 'common.ch'

// 12.08.25
function compare_version( new_version, old_version )
  // new_version - строка новой версии
  // old_version - строка старой версии
  // возвращает .t. если new_version старше old_version

  local ret := .f.
  local aNew, aOld

  if Empty( old_version ) .and. Empty( new_version )
    return .f.
  elseif ( ! Empty( old_version ) ) .and. Empty( new_version )
    return .t.
  elseif Empty( old_version ) .and. ( ! Empty( new_version ) )
    return .t.
  else
    aNew := Split( new_version, '.' )
    aOld := Split( old_version, '.' )
    if val( aNew[ 1 ] ) > val( aOld[ 1 ] )
      ret := .t.
    elseif val( aNew[ 1 ] ) == val( aOld[ 1 ] )
      if  val( aNew[ 2 ] ) > val( aOld[ 2 ] )
        ret := .t.
      endif
    endif
  endif
  return ret

// Разделить строку s на все подстроки, разделенные sep,
// и вернуть массив подстрок между этими разделителями.
// по умолчанию sep - "пробел"
Function Split(s, sep)
  // s - разделяемая строка
  // sep - строка разделитель
  return hb_ATokens( s, sep )

// 13.04.25
Function clear_name_table( table )

  table := Lower( AllTrim( table ) )

  Return hb_FNameName( table )

function about()

  OutStd( 'Утилита работы с сайтом ФФОМС http://nsi.ffoms.ru', hb_eol(), ;
    'Copyright (c) 2025, Vladimir G.Baykin', hb_eol(), hb_eol() )
  OutStd( 'Syntax:  nsi [options] ', hb_eol(), hb_eol() )
  OutStd( 'Опции:', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -help - помощь', hb_eol() )
//  '      -in=<source directory>', hb_eol(), ;
  
  Return nil

// 14.04.25
function dir_exe()
  
  static dir

  if isnil( dir )
    dir := hb_DirBase()
  endif
  return dir

function arrReference()

  Local arr := {}

  AAdd( arr, 'f006' )
  AAdd( arr, 'f010' )
  AAdd( arr, 'f011' )
  AAdd( arr, 'f014' )
  AAdd( arr, 'n001' )
  AAdd( arr, 'n002' )
  AAdd( arr, 'n003' )
  AAdd( arr, 'n004' )
  AAdd( arr, 'n005' )
  AAdd( arr, 'n006' )
  AAdd( arr, 'n007' )
  AAdd( arr, 'n008' )
  AAdd( arr, 'n009' )
  AAdd( arr, 'n010' )
  AAdd( arr, 'n011' )
  AAdd( arr, 'n012' )
  AAdd( arr, 'n013' )
  AAdd( arr, 'n014' )
  AAdd( arr, 'n015' )
  AAdd( arr, 'n016' )
  AAdd( arr, 'n017' )
  AAdd( arr, 'n018' )
  AAdd( arr, 'n019' )
  AAdd( arr, 'n020' )
  AAdd( arr, 'n021' )
  AAdd( arr, 'o001' )
  AAdd( arr, 'q015' )
  AAdd( arr, 'q016' )
  AAdd( arr, 'q017' )
  AAdd( arr, 'v002' )
  AAdd( arr, 'v004' )
  AAdd( arr, 'v009' )
  AAdd( arr, 'v010' )
  AAdd( arr, 'v012' )
  AAdd( arr, 'v015' )
  AAdd( arr, 'v016' )
  AAdd( arr, 'v017' )
  AAdd( arr, 'v018' )
  AAdd( arr, 'v019' )
  AAdd( arr, 'v020' )
  AAdd( arr, 'v021' )
  AAdd( arr, 'v022' )
  AAdd( arr, 'v024' )
  AAdd( arr, 'v025' )
  AAdd( arr, 'v030' )
  AAdd( arr, 'v031' )
  AAdd( arr, 'v032' )
  AAdd( arr, 'v033' )
  AAdd( arr, 'v036' )
  return arr