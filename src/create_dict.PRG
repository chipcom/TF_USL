/* �ணࠬ�� �������樨 XML-�ࠢ�筨��� ����� � "���᪨�" DBF-䠩��
   S_Subdiv.xml - ᯨ᮪ 11 ��०����� � ࠧ�묨 �஢�ﬨ ������
   S_Dep.xml    - ᯨ᮪ �⤥����� �� 11-� ��樮��ࠬ � ࠧ�묨 �஢�ﬨ ������
   SPRMU.xml    - �ࠢ�筨� ��� /������������, ��� ��㣨
   S_MOServ.xml - ���� ����⢨� ��㣨 �����
   S_Prices.xml - 業� � ��� ����⢨� �� �஢��
   S_LvlPay.xml - ��� �� � �஢��� ���
   SPRDS.xml    - 䥤�ࠫ�� �ࠢ�筨� ���
   SPRUNIT.xml  - �ࠢ�筨� ����� ����� /����-�����
   S_kiro.xml   - ��� ��� - ����
   SPRKSLP.xml  - ��� ��� - ����
   T006.xml     - ���
   V024.xml     - ��� ��� - ������ਨ
   V018.xml     - �����䨪��� ����� ��᮪��孮����筮� ����樭᪮� ����� (HVid)
   V019.xml     - �����䨪��� ��⮤�� ��᮪��孮����筮� ����樭᪮� ����� (HMet)
   V025.xml     - �����䨪��� 楫�� ���饭�� (KPC)
   V009.xml     - �����䨪��� १���⮢ ���饭�� �� ����樭᪮� ������� (Rezult)
   V010.xml     - �����䨪��� ᯮᮡ�� ������ ����樭᪮� ����� (Sposob)
   V012.xml     - �����䨪��� ��室�� ����������� (Ishod)
   V016.xml     - �����䨪��� ⨯�� ��ᯠ��ਧ�樨 (DispT)
   V017.xml     - �����䨪��� १���⮢ ��ᯠ��ਧ�樨 (DispR)
   
   V030.xml     - �奬� ��祭�� ����������� COVID-19 (TreatReg)
   V031.xml     - ��㯯� �९��⮢ ��� ��祭�� ����������� COVID-19 (GroupDrugs)
   V032.xml     - ���⠭�� �奬� ��祭�� � ��㯯� �९��⮢ (CombTreat)
   V033.xml     - ���⢥��⢨� ���� �९��� �奬� ��祭�� (DgTreatReg)
   V034.xml     - ������� ����७�� (UnitMeas)
   V035.xml     - ���ᮡ� �������� (MethIntro)
   V036.xml     - ���祭� ���, �ॡ���� ��������� ����樭᪨� ������� (ServImplDv)
   V037.xml     - ���祭� ��⮤�� ���, �ॡ���� ��������� ����樭᪨� �������

   OID 1.2.643.5.1.13.13.11.1006 - �⥯��� �殮�� ���ﭨ� ��樥��
   OID 1.2.643.5.1.13.13.11.1070 - ����������� ����樭᪨� ��� (�ᯮ������ � ��㣨� �ࠢ�筨���)
   OID 1.2.643.5.1.13.13.11.1079 - ���� ����樭᪨� �������, ��������㥬�� � �࣠���� 祫�����, � ���� ���ன�� ��� ��樥�⮢ � ��࠭�祭�묨 ����������ﬨ
   OID 1.2.643.5.1.13.13.11.1358.xml - ������� ����७��
   OID 1.2.643.5.1.13.13.11.1468.xml - ��� �������� ������⢥���� �९��⮢

//  �� ����砥� �� ��室� - ��� 䠩��

   _mo3usl    - _mo_usl  - �ࠢ�筨� ������������ ��� ���
   _mo3uslc   - _mo_uslc - �ࠢ�筨� ��� � 業��� ��� �������� ��
                           ��� ���

  _mo_t2_v1   - �ࠢ�筨� ᮮ⢥�ᢨ� ��� ����� ��㣠� �� ��
  _mo_V018    - �����䨪��� ����� ��᮪��孮����筮� ����樭᪮� ����� (HVid)
*/

#include 'dict_error.ch'

#include 'inkey.ch'
#include 'fileio.ch'
#include 'directry.ch'
#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

external errorsys

// 01.11.21
// ������ ��䨪� �ࠢ�筮�� 䠩�� ��� ����
function prefixFileName()
  return '_mo' + substr( CURENT_YEAR, 4, 1 )

// 10.06.25
proc main( ... )
  Local _mo_usl := { ;
    {'SHIFR',      'C',     10,      0}, ;
    {'NAME',       'C',    255,      0}, ;
    {'ST',         'N',      1,      0}, ;
    {'USL_OK',     'N',      1,      0}, ;
    {'USL_OKS',    'C',      4,      0}, ;
    {'UNIT_CODE',  'N',      3,      0}, ; // ���� -���� - �����
    {'UNITS',      'C',     16,      0}, ; // ���� -���� - �����
    {'BUKVA',      'C',     10,      0}, ; // �㪢� ⨯� ���
    {'VMP_F',      'C',      2,      0}, ;
    {'VMP_S',      'C',      8,      0}, ;
    {'IDSP',       'C',      2,      0}, ;
    {'IDSPS',      'C',      8,      0}, ;
    {'KSLP',       'N',      2,      0}, ;
    {'KSLPS',      'C',     30,      0}, ;
    {'KIRO',       'N',      2,      0}, ;
    {'KIROS',      'C',     15,      0}, ;
    {'UETV',       'N',      5,      2}, ; // ��� - ᥩ�� �� �ᯮ�������
    {'UETD',       'N',      5,      2}, ; // ��� - ᥩ�� �� �ᯮ�������
    {'DATEBEG',    'D',      8,      0}, ; // ��� ��砫� ����⢨� - �� 㬮�砭�� �.�
    {'DATEEND',    'D',      8,      0} ;  // ��� ����� ����⢨� - �� 㬮�砭�� �.�
  }

  local cParam, cParamL
  local aParams

  local nameFileUsl := prefixFileName() + 'usl'
  local nameFileUslC := prefixFileName() + 'uslc'
  local nameFileIt := prefixFileName() + 'it'
  local nameFileK006 := prefixFileName() + 'k006'

  local k006dbf := nameFileK006 + '.dbf'
  local k006dbt := nameFileK006 + '.dbt'
  local nResult
  local lFlag

  local source
  local destination
  local curent_dir
  local lExists
  local os_sep := hb_osPathSeparator()
  local t1, t2


  Public sys_date := date() // ctod('31/12/2021') //date()
  Public sys_year := year(date()) // 2021 // year(date())

  t1 := seconds()

//  source := upper(beforatnum(os_sep, exename())) + os_sep
//  destination := upper(beforatnum(os_sep, exename())) + os_sep
//  curent_dir := upper(beforatnum(os_sep, exename())) + os_sep
  source := beforatnum( hb_ps(), exename() ) + hb_ps()
  destination := beforatnum( hb_ps(), exename() ) + hb_ps()
  curent_dir := beforatnum( hb_ps(), exename() ) + hb_ps()

  aParams := hb_AParams()

//  f_first()
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
 
  //
  OutStd( '********' + hb_eol() )
  OutStd( '��ࠢ�筨�� �����.' + hb_eol() )
  OutStd( '********' + hb_eol() )

  lFlag := make_uslugi_mz(source, destination)  // ��ࠢ�筨� �����ࠢ� ��� �ନ஢���� 䠩��� �����
  // ��ࠢ�筨�� �����
  dbcreate(destination + nameFileUsl, _mo_usl)
  // work_Shema(source, destination)
  lFlag := work_SprKslp(source, destination)
  lFlag := work_SprKiro(source, destination)
  lFlag := work_SprSubDiv(source, destination)
  lFlag := work_SprDep(source, destination)
  lFlag := work_LvlPay(source, destination)
  lFlag := work_MOServ(source, destination)
  lFlag := work_Prices(source, destination)
  lFlag := work_mo_uslf(source, destination)
  lFlag := work_SprUnit(source, destination)
  lFlag := work_SprMU(source, destination)
  lFlag := work_SprDS(source, destination)
  lFlag := work_t006(source, destination)
  close databases
  //
  HB_VFERASE(destination + k006dbf)
  nResult := FRename(destination + 't006_2.dbf', destination + k006dbf)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbf')
  endif

  HB_VFERASE(destination + k006dbt)
  nResult := FRename(destination + 't006_2.dbt', destination + k006dbt)
  if nResult != 0
    out_error(FILE_RENAME_ERROR, 't006_2.dbt')
  endif
  if upper(source) != upper(destination)
    // filecopy(source + 'onko_napr' + '.dbf', destination + 'onko_napr' + '.dbf')
    // filecopy(source + 'onko_ksg' + '.dbf', destination + 'onko_ksg' + '.dbf')
    // filecopy(source + 'telemed' + '.dbf', destination + 'telemed' + '.dbf')
    filecopy(source + 'par_org' + '.dbf', destination + 'par_org' + '.dbf')
  endif

  //
  dbcreate(destination + nameFileIt, { {'ds', 'C', 5, 0}, {'it', 'N', 1, 0} } )

  use (destination + nameFileIt) new alias IT
  index on ds+str(it, 1) to tmp_it

  use (destination + nameFileK006) new alias K6
  index on ds to tmp_k6 for lower(left(ad_cr, 2)) == 'it'
  go top
  do while !eof()
    lit := int(val(substr(ltrim(k6->ad_cr), 3, 1)))
    select IT
    find (padr(k6->ds, 5) + str(lit, 1))
    if !found()
      append blank
      replace ds with k6->ds, it with lit
    endif
    select K6
    skip
  enddo
  close databases

  // ������� ������������ ��� �� 2022 ���
  use (destination + nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use (destination + 't006_u') new alias T006
  index on fsort_usl(shifr) to tmp6
  go top
  do while !eof()
    ar := get_field()
    select LUSL
    find (t006->shifr)
    if found()
    endif
    append blank
    aeval(ar, {|x, i| fieldput(i, x) } )
    //
    // ���������
    //
    if left(t006->shifr, 2) == 'st'
      lusl->idsp := lusl->idsps := '33' // ��� � ��樮���
      lusl->unit_code := 29
      lusl->units := '29'  // ��砩 ��ᯨ⠫���樨
      if left(t006->shifr, 5) == 'st37.'
        lusl->unit_code := 142
        lusl->units := '142' // ��砩 ��ᯨ⠫���樨 �� ॠ�����樨
      endif
    elseif alltrim(t006->shifr) == 'ds18.002' // ���.�࠯�� � ��樥�⮢ �� �������
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮��� ????
      lusl->unit_code := 259
      lusl->units := '259' // ��砩 �������
    else
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮���
      lusl->unit_code := 143
      lusl->units := '143' // ��砩 ��祭��
      if left(t006->shifr, 5) == 'ds37.'
        // ॠ������� � ������� ��樮���
      endif
    endif
    select T006
    skip
  enddo
  close databases
  //
  work_uslc(source, destination)
  //
  // use (destination + nameFileUslC) new alias LUSLC
  // go top
  // do while !eof()
  //   if luslc->DATEEND == 0d20191231
  //     luslc->DATEEND := ctod('')
  //   endif
  //   skip
  // enddo
  close databases
  //
  aup := {}
  use (destination + '_mo_prof') new alias PROF
  index on fsort_usl(shifr) to tmp_prof
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1]==prof->shifr .and. x[2] == prof->VZROS_REB})) == 0
      aadd(aup,{prof->shifr, prof->VZROS_REB, {}})
      j := len(aup)
    endif
    if ascan(aup[j, 3], prof->PROFIL) == 0
      aadd(aup[j, 3], prof->PROFIL)
    endif
    skip
  enddo
  aup := {}
  use (destination + '_mo_spec') new alias SPEC
  index on fsort_usl(shifr) to tmp_spec
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1] == spec->shifr .and. x[2] == spec->VZROS_REB})) == 0
      aadd(aup, {spec->shifr, spec->VZROS_REB, {}})
      j := len(aup)
    endif
    if ascan(aup[j, 3], spec->PRVS_NEW) == 0
      aadd(aup[j, 3], spec->PRVS_NEW)
    endif
    skip
  enddo
  close databases
  HB_VFERASE(curent_dir + 'tmp*.dbf')
  HB_VFERASE(curent_dir + 'tmp*.ntx')
  HB_VFERASE(curent_dir + 'tmp_it.ntx')
  HB_VFERASE(curent_dir + 'tmp_k6.ntx')
  HB_VFERASE(curent_dir + 'tmp_lusl.ntx')
  HB_VFERASE(curent_dir + 'tmp_lvlpay.ntx')
  HB_VFERASE(curent_dir + 'tmp_ok.ntx')
  HB_VFERASE(curent_dir + 'tmp_on.ntx')
  HB_VFERASE(curent_dir + 'tmp_po.ntx')
  HB_VFERASE(curent_dir + 'tmp_prices.ntx')
  HB_VFERASE(curent_dir + 'tmp_prof.ntx')
  HB_VFERASE(curent_dir + 'tmp_shema.ntx')
  HB_VFERASE(curent_dir + 'tmp_spec.ntx')
  HB_VFERASE(curent_dir + 'tmp_tel.ntx')
  HB_VFERASE(curent_dir + 'tmp_unit.ntx')
  HB_VFERASE(curent_dir + 'tmp_usl.ntx')
  HB_VFERASE(curent_dir + 'tmp1.ntx')
  HB_VFERASE(curent_dir + 'tmp6.ntx')
  // HB_VFERASE(curent_dir + 'not_lev.ntx')
  // HB_VFERASE(curent_dir + 'not_usl.ntx')
  
  HB_VFERASE(destination + 't006_2.dbf')
  HB_VFERASE(destination + 't006_2.dbt')
  HB_VFERASE(destination + 't006_d.dbf')
  HB_VFERASE(destination + 't006_u.dbf')

  t2 := seconds() - t1

  if t2 > 0
    OutStd( '�६� �������樨 - ' + sectotime(t2) + hb_eol() )
  endif

  SET KEY K_ALT_F4 TO
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X TO
  SET COLOR TO
  SET CURSOR ON

  return

// ��ப� ���� ��� XML-䠩��
Function date2xml(mdate)
  return strzero(year(mdate), 4) + '-' + ;
         strzero(month(mdate), 2) + '-' + ;
         strzero(day(mdate), 2)

// �ॡࠧ����� ���� �� "2002-02-01" � ⨯ "DATE"
Function xml2date(s)
  return stod(charrem('-', s))

// �஢���� ����稥 � XML-䠩�� ���� � ������ ��� ���祭��
Function mo_read_xml_stroke(_node, _title, _aerr, _binding, _codepage)
  // _node - 㪠��⥫� �� 㧥�
  // _title - ������������ ����
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', oNode, yes_err := (valtype(_aerr) == 'A'), ;
      s_msg := '��������� ���祭�� ��易⥫쭮�� ���� "' + _title + '"'

  DEFAULT _binding TO .t., _aerr TO {}

  DEFAULT _codepage TO 'WIN1251'
  // �饬 ����室��� "_title" ��� � 㧫� "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr, s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  endif
  return ret

// ������ ���祭�� ����
Function mo_read_xml_tag(oNode, _aerr, _binding, _codepage)
  // oNode - 㪠��⥫� �� 㧥�
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  // _codepage - ����஢�� ��।����� ��ப�
  Local ret := '', c, yes_err := (valtype(_aerr) == 'A'), ;
      s_msg := '��������� ���祭�� ��易⥫쭮�� ���� "' + oNode:title + '"'
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
    aadd(_aerr, '������ ⨯ ������ � ���� "' + oNode:title + '": "' + c + '"')
  endif
  return ret

// �������� �� date1 (�������� date1-date2) � �������� _begin_date-_end_date
Function between_date(_begin_date, _end_date, date1, date2)
  // _begin_date - ��砫� ����⢨�
  // _end_date   - ����砭�� ����⢨�
  // date1 - �஢��塞�� ���
  // date2 - ���� ��� ��������� (�᫨ = NIL, � �஢��塞 ⮫쪮 �� date1)
  Local fl := .f., fl2

  DEFAULT date1 TO sys_date  // �� 㬮�砭�� �஢��塞 �� ᥣ����譨� ������
  if empty(_begin_date)
    _begin_date := stod('19930101')  // �᫨ ��砫� ����⢨� = ����, � 01.01.1993
  endif
  // �஢�ઠ ���� date1 �� ��������� � ��������
  if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
    fl := (date1 <= _end_date)
  endif
  // �஢�ઠ ��������� date1-date2 �� ����祭�� � ����������
  if valtype(date2) == 'D'
    if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
      fl2 := (date2 <= _end_date)
    endif
    fl := (fl .or. fl2)
  endif
  return fl

// ������ � ���ᨢ� ������ ���� ������
Function get_field()
  Local arr := array(fcount())

  aeval(arr, {|x, i| arr[i] := fieldget(i) }  )
  return arr

// 15.01.14 �㭪�� ���஢�� ��஢ ��� �� �����⠭�� (��� ������� INDEX)
Function fsort_usl(sh_u)
  Static _sg := 5
  Local i, s := '', flag_z := .f., flag_0 := .f., arr

  if left(sh_u, 1) == '*'
    flag_z := .t.
  elseif left(sh_u, 1) == '0'
    flag_0 := .t.
  endif
  arr := usl2arr(sh_u)
  for i := 1 to len(arr)
    if i == 2 .and. flag_z
      s += '9' + strzero(arr[i], _sg)  // ��� 㤠������ ��㣨
    elseif i == 1 .and. flag_0
      s += ' ' + strzero(arr[i], _sg)  // �᫨ ���।� �⮨� 0
    else
      s += strzero(arr[i], 1 + _sg)
    endif
  next
  return s

// 28.01.17
Function usl2arr(sh_u, /*@*/j)
  Local i, k, c, ascc, arr := {}, cDelimiter := '.', s := alltrim(sh_u), ;
        s1 := '', is_all_digit := .t.
  
  if left(s, 1) == '*'
    s := substr(s, 2)
  endif
  for i := 1 to len(s)
    c := substr(s, i, 1)
    ascc := asc(c)
    if between(ascc, 48, 57) // ?????
      s1 += c
    elseif ISLETTER(c) // ?????
      is_all_digit := .f.
      if len(s1) > 0 .and. right(s1, 1) != cDelimiter
        s1 += cDelimiter // ???????????? ??????? ???????????
      endif
      s1 += lstr(ascc)
    else // ????? ???????????
      is_all_digit := .f.
      s1 += cDelimiter
    endif
  next
  if is_all_digit .and. eq_any((k := len(s1)), 7, 8)  // ???
    if k == 8
      aadd(arr, int(val(substr(s1, 1, 1))))
      aadd(arr, int(val(substr(s1, 2, 1))))
      aadd(arr, int(val(substr(s1, 3, 1))))
      aadd(arr, int(val(substr(s1, 6, 3))))
      aadd(arr, int(val(substr(s1, 4, 1))))
    else
      aadd(arr, int(val(substr(s1, 1, 1))))
      aadd(arr, int(val(substr(s1, 2, 1))))
      aadd(arr, int(val(substr(s1, 3, 1))))
      aadd(arr, int(val(substr(s1, 5, 3))))
      aadd(arr, int(val(substr(s1, 4, 1))))
    endif
  else // ????????? ??????
    k := numtoken(alltrim(s1), cDelimiter)
    for i := 1 to k
      j := int(val(token(s1, cDelimiter, i)))
      aadd(arr, j)
    next
    if (j := len(arr)) < 5
      for i := j + 1 to 5
        aadd(arr, 0)
      next
    endif
  endif
  return arr

//
PROCEDURE About()

  OutStd('�������� �ࠢ�筨��� ��易⥫쭮�� ����樭᪮�� ���客����', hb_eol(), ;
      'Copyright (c) 2022, Vladimir G.Baykin', hb_eol(), ;
    hb_eol())
  OutStd('Syntax:  create_dict [options] ', hb_eol(), hb_eol())
  OutStd('��樨:', hb_eol(), ;
    '      -in=<source directory>', hb_eol(), ;
    '      -out=<destination directory>', hb_eol(), ;
    '      -all - �������஢��� ��', hb_eol(), ;
    '      -help - ������', hb_eol())
    
  RETURN
 
// 11.02.22
function obrabotka(nfile)

  @ row() + 1, 1 say '��ࠡ�⪠ 䠩�� ' + nfile + ' -'
  return Col()

// 13.02.22
function out_obrabotka(nfile)

  OutStd('===== ��ࠡ�⪠ 䠩�� ' + nfile )
  return nil

// 15.02.22
function out_create_file(nfile)

  OutStd('�������� 䠩�� ' + nfile )
  return nil

// 14.02.22
function out_obrabotka_eol()

  OutStd(hb_eol())
  return nil

// 14.02.22
function out_obrabotka_count(j, k)

  // OutStd( str(j / k * 100, 6, 2) + '%' )
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

// ������ ����� equalany(...)
Function eq_any
Local fl := .f., i, n, mvar
parameters mval,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,;
                v11,v12,v13,v14,v15,v16,v17,v18,v19,v20,;
                v21,v22,v23,v24,v25,v26,v27,v28,v29,v30
if (n := pcount()-1) > 30
  n := 30
endif
for i := 1 to n
  mvar := "v"+lstr(i)
  if &mvar == mval
    fl := .t. ; exit
  endif
next
return fl

function eq_any_new( mval, ... )
  
  local fl := .f., i
  local n := pcount()
  local mType := ValType(mval)

  if n < 2
    return fl
  endif
  for i := 2 to n
    mvar := hb_PValue( i )
    if mType != ValType( mvar)
      loop
    endif
    if mval == mvar
    // if &mvar == mval
      fl := .t. ; exit
    endif
  next
  return fl