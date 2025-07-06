#include 'common.ch'
#include 'inkey.ch'
#include 'fileio.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'dict_error.ch'

// 05.07.25
proc main( ... )

  local cParam, cParamL
  local aParams

  local source
  local destination
//  local curent_dir
  local time_start, total_time

  source := beforatnum( hb_ps(), exename() ) + hb_ps()
  destination := beforatnum( hb_ps(), exename() ) + hb_ps()
//  curent_dir := beforatnum( hb_ps(), exename() ) + hb_ps()

  aParams := hb_AParams()

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")

  REQUEST DBFNTX
  RDDSETDEFAULT("DBFNTX")

  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON
  setblink(.f.)

  FOR EACH cParam IN aParams
    cParamL := Lower( cParam )
    DO CASE
      CASE cParamL == '-help'
        About()
        RETURN
      CASE cParamL == '-quiet'
        // ? 'quiet'
      CASE cParamL == '-all'
      CASE hb_LeftEq( cParamL, '-in=' )
        source := SubStr( cParam, 4 + 1 )
      CASE hb_LeftEq( cParamL, '-out=' )
        destination := SubStr( cParam, 5 + 1 )
    endcase
  next

  if right(source, 1) != hb_ps()
    source += hb_ps()
  endif
  if right(destination, 1) != hb_ps()
    destination += hb_ps()
  endif

  time_start := seconds()

  //
  OutStd( '********' + hb_eol() )
  OutStd( '��ࠢ�筨�� ����� ���������.' + hb_eol() )
  OutStd( '********' + hb_eol() )

  make_oid_sootv( source, destination )
  make_oid_stad_TNM( source, destination )
  total_time := seconds() - time_start

  if total_time > 0
    OutStd( '�६� �������樨 - ' + sectotime( total_time ) + hb_eol() )
  endif

  SET KEY K_ALT_F4 TO
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X TO
  SET COLOR TO
  SET CURSOR ON
  return

//
PROCEDURE About()

  OutStd('�������� �ࠢ�筨��� ����� ୪������', hb_eol(), ;
      'Copyright (c) 2025, Vladimir G.Baykin', hb_eol(), ;
    hb_eol())
  OutStd('Syntax:  test_onko [options] ', hb_eol(), hb_eol())
  OutStd('��樨:', hb_eol(), ;
    '      -in=<source directory>', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -help - ������', hb_eol())
    
  RETURN

// 11.02.22
function obrabotka( nfile )

  @ row() + 1, 1 say '��ࠡ�⪠ 䠩�� ' + nfile + ' -'
  return Col()

// 13.02.22
function out_obrabotka( nfile )

  OutStd( '===== ��ࠡ�⪠ 䠩�� ' + nfile )
  return nil

// 15.02.22
function out_create_file( nfile )

  OutStd( '�������� 䠩�� ' + nfile )
  return nil

// 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

// 14.02.22
function out_obrabotka_count(j, k)

  OutStd( str(j / k * 100, 6, 2) + '%' )
  return nil

// 15.02.22
function out_error(nError, nfile, j, k)

  DO CASE
  CASE nError == FILE_NOT_EXIST
    OutErr('���� ' + nfile + ' �� �������', hb_eol())
  CASE nError == FILE_READ_ERROR
    OutErr('�訡�� � ����㧪� 䠩�� ' + nfile, hb_eol())
  CASE nError == FILE_RENAME_ERROR
    OutErr('�訡�� ��२��������� 䠩�� ' + nfile, hb_eol())
  CASE nError == DIR_IN_NOT_EXIST
    OutErr('��⠫�� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!', hb_eol())
  CASE nError == DIR_OUT_NOT_EXIST
    OutErr('��⠫�� ��� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!', hb_eol())
  CASE nError == TAG_YEAR_REPORT
      OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '". �����४⭮� ���祭�� ⥣� YEAR_REPORT ', j, hb_eol())
  CASE nError == TAG_PLACE_ERROR
      OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PLACE � �⤥�����: ', alltrim(j), hb_eol())
  CASE nError == TAG_PERIOD_ERROR
      OutErr('�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PERIOD � ��०�����: ', j, ' � ��㣥 ', k, hb_eol())
  CASE nError == TAG_VALUE_EMPTY
      OutErr('����砭�� �� �⥭�� 䠩�� "' + nfile + '" - ���⮥ ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k, hb_eol())
  CASE nError == TAG_VALUE_INVALID
      OutErr('����砭�� �� �⥭�� 䠩�� "' + nfile + '" - �����४⭮� ���祭�� ⥣� VALUE/LEVEL: ', j, ' � ��㣥 ', k, hb_eol())
  end case
  return nil

// ��ப� ���� ��� XML-䠩��
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' + ;
         strzero(month(mdate), 2) + '-' + ;
         strzero(day(mdate), 2)

// �ॡࠧ����� ���� �� "2002-02-01" � ⨯ "DATE"
Function xml2date(s)
  return stod(charrem('-', s))

// �஢���� ����稥 � XML-䠩�� �� � ������ ��� ���祭��
Function mo_read_xml_stroke(_node, _title, _aerr, _binding, _codepage)
  // _node - 㪠��⥫� �� 㧥�
  // _title - ������������ ��
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', oNode, yes_err := (valtype(_aerr) == 'A'), ;
      s_msg := '��������� ���祭�� ��易⥫쭮�� �� "' + _title + '"'

  DEFAULT _binding TO .t., _aerr TO {}

  DEFAULT _codepage TO 'WIN1251'
  // �饬 ����室��� "_title" �� � 㧫� "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr, s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  endif
  return ret

// ������ ���祭�� ��
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - 㪠��⥫� �� 㧥�
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'), ;
      s_msg := '��������� ���祭�� ��易⥫쭮�� �� "' + oNode:title + '"'
  local codepage := upper(_codepage)

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr, s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == 'C'
    if codepage == 'WIN1251'
      ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    elseif codepage == 'UTF8'
      ret := hb_Utf8ToStr( alltrim(oNode:aItems[1]), 'RU866' )	
    endif
  elseif yes_err
    aadd(_aerr, '������ ⨯ ������ � �� "' + oNode:title + '": "' + c + '"')
  endif
  return ret
