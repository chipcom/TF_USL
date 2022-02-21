#include "function.ch"

#require 'hbsqlit3'

// #define TRACE

/*
 * 21.02.2022
*/
procedure main( ... )
  local cParam, cParamL
  local aParams
  local nResult

  local source
  local destination
  local lExists
  local os_sep := hb_osPathSeparator()
  local fp, i, s

  LOCAL lCreateIfNotExist := .T.
  LOCAL db

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")
  
  // REQUEST DBFNTX
  // RDDSETDEFAULT('DBFNTX')
  
  // SET SCOREBOARD OFF
  // SET EXACT ON
  // SET DATE GERMAN
  // SET WRAP ON
  // SET CENTURY ON
  // SET EXCLUSIVE ON
  // SET DELETED ON
  // setblink(.f.)
  
  
  // READINSERT(.T.)        // ०�� ।���஢���� �� 㬮�砭�� Insert
  // KEYBOARD ''
  // ksetnum(.t.)
  // SETCURSOR(0)
  // SETCLEARB(' ')
  // SET COLOR TO
  
  source := upper(beforatnum(os_sep, exename())) + os_sep
  destination := upper(beforatnum(os_sep, exename())) + os_sep

  aParams := hb_AParams()
  FOR EACH cParam IN aParams
    cParamL := Lower( cParam )
    DO CASE
      CASE cParamL == "-help"
        About()
        RETURN
      CASE cParamL == "-quiet"
        // ? 'quiet'
      CASE cParamL == "-all"
        if HB_VFEXISTS(source + FILE_HASH)
          HB_VFERASE(source + FILE_HASH)
        endif
      CASE hb_LeftEq( cParamL, "-in=" )
        source := SubStr( cParam, 4 + 1 )
      CASE hb_LeftEq( cParamL, "-out=" )
        destination := SubStr( cParam, 5 + 1 )
    endcase
  next

  if right(source, 1) != os_sep
    source += os_sep
  endif
  if right(destination, 1) != os_sep
    destination += os_sep
  endif
  
  if !(lExists := hb_vfDirExists( source ))
    out_error(DIR_IN_NOT_EXIST, source)
    quit
  endi

  if !(lExists := hb_vfDirExists( destination ))
    out_error(DIR_OUT_NOT_EXIST, destination)
    quit
  endi

  ? sqlite3_libversion()
  // sqlite3_sleep( 3000 )

  IF sqlite3_libversion_number() < 3005001
     RETURN
  ENDIF

  db := sqlite3_open( destination + "chip_mo.s3db", lCreateIfNotExist )

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile( db, .T. ) // ����稬 ��䠩���
         sqlite3_trace( db, .T. )   // ����稬 ����஢騪
    #endif

    sqlite3_exec( db, "PRAGMA auto_vacuum=0" )
    sqlite3_exec( db, "PRAGMA page_size=4096" )

    // �ࠢ�筨�� ��㯯� F___
    // make_f005( db, source )
    // make_f006( db, source )
    // make_f007( db, source )
    // make_f008( db, source )
    // make_f009( db, source )
    // make_f010( db, source )
    // make_f011( db, source )
    // make_f014( db, source )
    // make_f015( db, source )
    // // �ࠢ�筨�� ��㯯� O___
    // make_o001( db, source )
    // // �ࠢ�筨�� ��㯯� Q___
    // make_q015( db, source )
    // make_q016( db, source )
    // make_q017( db, source )
    // �ࠢ�筨�� ��㯯� V___
    make_v002( db, source )
    // make_v005( db, source )
    // make_v006( db, source )
    // make_v008( db, source )
    make_v009( db, source )
    make_v010( db, source )
    make_v012( db, source )
    // make_v013( db, source )
    // make_v014( db, source )
    make_v015( db, source )
    make_v016( db, source )
    make_v017( db, source )
    make_v018( db, source )
    make_v019( db, source )
    make_v020( db, source )
    make_v021( db, source )
    make_v022( db, source )
    // make_v023( db, source )
    make_v024( db, source )
    make_v025( db, source )
    // make_v026( db, source )
    // make_v027( db, source )
    // make_v028( db, source )
    // make_v029( db, source )

  endif
  return

***** ��ப� ���� ��� XML-䠩��
Function date2xml(mdate)
  return strzero(year(mdate),4)+'-'+;
       strzero(month(mdate),2)+'-'+;
       strzero(day(mdate),2)

***** �ॡࠧ����� ���� �� "2002-02-01" � ⨯ "DATE"
Function xml2date(s)
  return stod(charrem("-",s))

***** �஢���� ����稥 � XML-䠩�� �� � ������ ��� ���祭��
Function mo_read_xml_stroke(_node,_title,_aerr,_binding)
  // _node - 㪠��⥫� �� 㧥�
  // _title - ������������ ��
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  Local ret := "", oNode, yes_err := (valtype(_aerr) == "A"),;
      s_msg := '��������� ���祭�� ��易⥫쭮�� �� "'+_title+'"'
  DEFAULT _binding TO .t., _aerr TO {}
  // �饬 ����室��� "_title" �� � 㧫� "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr,s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag1251(oNode,_aerr,_binding)
  endif
  return ret

***** ������ ���祭�� ��
Function mo_read_xml_tag1251(oNode,_aerr,_binding)
  // oNode - 㪠��⥫� �� 㧥�
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  Local ret := "", c, yes_err := (valtype(_aerr) == "A"),;
      s_msg := '��������� ���祭�� ��易⥫쭮�� �� "'+oNode:title+'"'
  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr,s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == "C"
    // ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
    ret := alltrim(oNode:aItems[1])
  elseif yes_err
    aadd(_aerr,'������ ⨯ ������ � �� "'+oNode:title+'": "'+c+'"')
  endif
  return ret

PROCEDURE About()

  OutStd( ;
      "�������� �ࠢ�筨��� ��易⥫쭮�� ����樭᪮�� ���客����" + hb_eol() + ;
        "Copyright (c) 2022, Vladimir G.Baykin" + hb_eol() + ;
      hb_eol() )
   
  OutStd( ;
      "Syntax:  create_dict [options] " + hb_eol() + hb_eol() )
  OutStd( ;
      "��樨:" + hb_eol() + ;
      "      -in=<source directory>" + hb_eol() + ;
      "      -out=<destination directory>" + hb_eol() + ;
      "      -all - �������஢��� ��" + hb_eol() + ;
      "      -help - ������" + hb_eol() ;
  )
      
  RETURN
   
****** 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say "��ࠡ�⪠ 䠩�� " + nfile + " -"
  return Col()

****** 13.02.22
function out_obrabotka(nfile)

  OutStd( ;
    "===== ��ࠡ�⪠ 䠩�� " + nfile )
  return nil

****** 15.02.22
function out_create_file(nfile)

  OutStd( ;
    "�������� 䠩�� " + nfile )
  return nil

****** 14.02.22
function out_obrabotka_eol()

  OutStd( hb_eol() )
  return nil

****** 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + "%" )
  return nil

****** 15.02.22
function out_error(nError, nfile, j, k)

  DO CASE
  CASE nError == FILE_NOT_EXIST
    OutErr( ;
      "���� " + nfile + " �� �������" + hb_eol() )
  CASE nError == FILE_READ_ERROR
    OutErr( ;
      "�訡�� � ����㧪� 䠩�� " + nfile + hb_eol() )
  CASE nError == FILE_RENAME_ERROR
    OutErr( ;
      "�訡�� ��२��������� 䠩�� " + nfile + hb_eol() )
  CASE nError == DIR_IN_NOT_EXIST
    OutErr( ;
      '��⠫�� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!' + hb_eol() )
  CASE nError == DIR_OUT_NOT_EXIST
    OutErr( ;
      '��⠫�� ��� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!' + hb_eol() )
  CASE nError == TAG_YEAR_REPORT
      OutErr( ;
        '�訡�� �� �⥭�� 䠩�� "' + nfile + '". �����४⭮� ���祭�� ⥣� YEAR_REPORT ' + j + hb_eol() )
  CASE nError == TAG_PLACE_ERROR
      OutErr( ;
        '�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PLACE � �⤥�����: ' + alltrim(j) + hb_eol() )
  CASE nError == TAG_PERIOD_ERROR
      OutErr( ;
        '�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PERIOD � ��०�����: ' + j + " � ��㣥 " + k + hb_eol() )
  CASE nError == TAG_VALUE_EMPTY
      OutErr( ;
        '����砭�� �� �⥭�� 䠩�� "' + nfile + '" - ���⮥ ���祭�� ⥣� VALUE/LEVEL: ' + j + " � ��㣥 " + k + hb_eol() )
  CASE nError == TAG_VALUE_INVALID
      OutErr( ;
        '����砭�� �� �⥭�� 䠩�� "' + nfile + '" - �����४⭮� ���祭�� ⥣� VALUE/LEVEL: ' + j + " � ��㣥 " + k + hb_eol() )
  CASE nError == TAG_ROW_INVALID
      OutErr( ;
      '�訡�� �� ����㧪� ��ப� - ' + j + ' �� 䠩�� ' +nfile + hb_eol() )
  end case

  return nil
