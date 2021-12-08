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

//  �� ����砥� �� ��室� - ��� 䠩��

   _mo1usl    - _mo_usl  - �ࠢ�筨� ������������ ��� ���
   _mo1uslc   - _mo_uslc - �ࠢ�筨� ��� � 業��� ��� �������� ��
                           ��� ���

  _mo_t2_v1   - �ࠢ�筨� ᮮ⢥�ᢨ� ��� ����� ��㣠� �� ��
  _mo_V018    - �����䨪��� ����� ��᮪��孮����筮� ����樭᪮� ����� (HVid)
*/

#include 'edit_spr.ch'
#include 'function.ch'
#include 'settings.ch'

external errorsys

// 01.11.21
// ������ ��䨪� �ࠢ�筮�� 䠩�� ��� ����
function prefixFileName()
  return '_mo' + substr(CURENT_YEAR,4,1)

proc main()
  Local _mo_usl := {;
    {"SHIFR",      "C",     10,      0},;
    {"NAME",       "C",    255,      0},;
    {"ST",         "N",      1,      0},;
    {"USL_OK",     "N",      1,      0},;
    {"USL_OKS",    "C",      4,      0},;
    {"UNIT_CODE",  "N",      3,      0},; // ���� -���� - �����
    {"UNITS",      "C",     16,      0},; // ���� -���� - �����
    {"BUKVA",      "C",     10,      0},; // �㪢� ⨯� ���
    {"VMP_F",      "C",      2,      0},;
    {"VMP_S",      "C",      8,      0},;
    {"IDSP",       "C",      2,      0},;
    {"IDSPS",      "C",      8,      0},;
    {"KSLP",       "N",      2,      0},;
    {"KSLPS",      "C",     10,      0},;
    {"KIRO",       "N",      2,      0},;
    {"KIROS",      "C",     10,      0},;
    {"UETV",       "N",      5,      2},; // ��� - ᥩ�� �� �ᯮ�������
    {"UETD",       "N",      5,      2},; // ��� - ᥩ�� �� �ᯮ�������
    {"DATEBEG",    "D",      8,      0},; // ��� ��砫� ����⢨� - �� 㬮�砭�� �.�
    {"DATEEND",    "D",      8,      0};  // ��� ����� ����⢨� - �� 㬮�砭�� �.�
  }

  local nameFileUsl := prefixFileName() + 'usl'
  local nameFileUslC := prefixFileName() + 'uslc'
  local nameFileIt := prefixFileName() + 'it'
  local nameFileK006 := prefixFileName() + 'k006'

  local k006dbf := nameFileK006 + '.dbf'
  local k006dbt := nameFileK006 + '.dbt'

  Local arr_err := {}

  delete file ttt.ttt
  f_first()
  Public sys_date := date(), sys_year := year(date())

  // make_TO01()
  work_V002()
  work_V021()

  InitSpravFFOMS()
  //
  read_spr_N00X()
  //
  // dbcreate("_mo1usl",_mo_usl)
  dbcreate(nameFileUsl, _mo_usl)
  work_Shema()
  work_SprSubDiv()
  work_SprDep()
  work_LvlPay()
  work_MOServ()
  work_Prices()
  work_mo_uslf()
  work_SprUnit()
  work_SprKslp()
  work_SprKiro()
  work_SprMU()
  work_SprDS()
  work_t006(_mo_usl)
  work_V015()
  work_V018()
  work_V019()
  work_V020()
  work_V022()
  work_V025()
  make_Q015()
  make_Q016()
  make_Q017()
  make_F006()
  make_F010()
  make_F011()
  make_F014()
  make_O001()
  close databases
  //
  rename t006_2.dbf to (k006dbf)
  rename file t006_2.dbt to (k006dbt)

  //
  // dbcreate("_mo1it",{{"ds","C",5,0},{"it","N",1,0}})
  dbcreate(nameFileIt, { {"ds","C",5,0}, {"it","N",1,0} } )

  // use _mo1it new alias IT
  use (nameFileIt) new alias IT
  index on ds+str(it,1) to tmp_it

  use (nameFileK006) new alias K6
  index on ds to tmp_k6 for lower(left(ad_cr,2)) == "it"
  go top
  do while !eof()
    lit := int(val(substr(ltrim(k6->ad_cr),3,1)))
    select IT
    find (padr(k6->ds,5)+str(lit,1))
    if !found()
      append blank
      replace ds with k6->ds, it with lit
    endif
    select K6
    skip
  enddo
  close databases

  // ������� ������������ ��� �� 2021 ���
  // use _mo1usl new alias LUSL
  use (nameFileUsl) new alias LUSL
  index on shifr to tmp_lusl

  use t006_u new alias T006
  index on fsort_usl(shifr) to tmp6
  go top
  do while !eof()
    ar := get_field()
    select LUSL
    find (t006->shifr)
    if found()
    endif
    append blank
    aeval(ar, {|x,i| fieldput(i,x) } )
    //
    // ���������
    //
    if left(t006->shifr,2) == "st"
      lusl->idsp := lusl->idsps := '33' // ��� � ��樮���
      lusl->unit_code := 29 ; lusl->units := "29"  // ��砩 ��ᯨ⠫���樨
      if left(t006->shifr,5) == "st37."
        lusl->unit_code := 142 ; lusl->units := "142" // ��砩 ��ᯨ⠫���樨 �� ॠ�����樨
      endif
    elseif alltrim(t006->shifr) == 'ds18.002' // ���.�࠯�� � ��樥�⮢ �� �������
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮��� ????
      lusl->unit_code := 259 ; lusl->units := "259" // ��砩 �������
    else
      lusl->idsp := lusl->idsps := '33' // ��� � ������� ��樮���
      lusl->unit_code := 143 ; lusl->units := "143" // ��砩 ��祭��
      if left(t006->shifr,5) == "ds37."
        // ॠ������� � ������� ��樮���
      endif
    endif
    select T006
    skip
  enddo
  close databases
  //
  work_uslc()
  //
  // use _mo1uslc new alias LUSLC
  use (nameFileUslC) new alias LUSLC
  go top
  do while !eof()
    if luslc->DATEEND == 0d20191231
      luslc->DATEEND := ctod("")
    endif
    skip
  enddo
  close databases
  //
  aup := {}
  use _mo_prof new alias PROF
  index on fsort_usl(shifr) to tmp_prof
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1]==prof->shifr.and.x[2]==prof->VZROS_REB}))== 0
      aadd(aup,{prof->shifr,prof->VZROS_REB,{}}) ; j := len(aup)
    endif
    if ascan(aup[j,3],prof->PROFIL) == 0
      aadd(aup[j,3],prof->PROFIL)
    endif
    skip
  enddo
  fp := fcreate("_mo_prof.txt") ; n_list := 1 ; tek_stroke := 0
  for j := 1 to len(aup)
    s := aup[j,1]+iif(aup[j,2] == 0, "���", "ॡ")+".{"
    asort(aup[j,3])
    for i := 1 to len(aup[j,3])
      s += lstr(aup[j,3,i])+"-"+inieditspr(A__MENUVERT,glob_V002,aup[j,3,i])
      if i < len(aup[j,3])
        s += ","
      endif
    next
    add_string(s+"}")
  next
  fclose(fp)
  //
  aup := {}
  use _mo_spec new alias SPEC
  index on fsort_usl(shifr) to tmp_spec
  go top
  do while !eof()
    if (j := ascan(aup, {|x| x[1]==spec->shifr.and.x[2]==spec->VZROS_REB}))== 0
      aadd(aup,{spec->shifr,spec->VZROS_REB,{}}) ; j := len(aup)
    endif
    if ascan(aup[j,3],spec->PRVS_NEW) == 0
      aadd(aup[j,3],spec->PRVS_NEW)
    endif
    skip
  enddo
  fp := fcreate("_mo_spec.txt") ; n_list := 1 ; tek_stroke := 0
  for j := 1 to len(aup)
    s := aup[j,1]+iif(aup[j,2] == 0, "���", "ॡ")+".{"
    asort(aup[j,3])
    for i := 1 to len(aup[j,3])
      s += lstr(aup[j,3,i])+"-"+inieditspr(A__MENUVERT,glob_V021,aup[j,3,i])
      if i < len(aup[j,3])
        s += ","
      endif
    next
    add_string(s+"}")
  next
  fclose(fp)
  close databases
  filedelete("tmp*.dbf")
  filedelete("tmp*.ntx")
  
  filedelete('t006_2.dbf')
  filedelete('t006_2.dbt')
  filedelete('t006_d.dbf')
  filedelete('t006_u.dbf')
  f_end()
  return

***** ��ப� ���� ��� XML-䠩��
Function date2xml(mdate)
  return strzero(year(mdate),4)+'-'+;
         strzero(month(mdate),2)+'-'+;
         strzero(day(mdate),2)

***** �ॡࠧ����� ���� �� "2002-02-01" � ⨯ "DATE"
Function xml2date(s)
  return stod(charrem("-",s))

***** �஢���� ����稥 � XML-䠩�� ���� � ������ ��� ���祭��
Function mo_read_xml_stroke(_node,_title,_aerr,_binding)
  // _node - 㪠��⥫� �� 㧥�
  // _title - ������������ ����
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  Local ret := "", oNode, yes_err := (valtype(_aerr) == "A"),;
        s_msg := '��������� ���祭�� ��易⥫쭮�� ���� "'+_title+'"'
  
  DEFAULT _binding TO .t., _aerr TO {}
  // �饬 ����室��� "_title" ��� � 㧫� "_node"
  oNode := _node:Find(_title)
  if oNode == NIL .and. _binding .and. yes_err
    aadd(_aerr,s_msg)
  endif
  if oNode != NIL
    ret := mo_read_xml_tag(oNode,_aerr,_binding)
  endif
  return ret

***** ������ ���祭�� ����
Function mo_read_xml_tag(oNode,_aerr,_binding)
  // oNode - 㪠��⥫� �� 㧥�
  // _aerr - ���ᨢ ᮮ�饭�� �� �訡���
  // _binding - ��易⥫�� �� ��ਡ�� (��-㬮�砭�� .T.)
  Local ret := "", c, yes_err := (valtype(_aerr) == "A"),;
        s_msg := '��������� ���祭�� ��易⥫쭮�� ���� "'+oNode:title+'"'

  if empty(oNode:aItems)
    if _binding .and. yes_err
      aadd(_aerr,s_msg)
    endif
  elseif (c := valtype(oNode:aItems[1])) == "C"
    ret := hb_AnsiToOem(alltrim(oNode:aItems[1]))
  elseif yes_err
    aadd(_aerr,'������ ⨯ ������ � ���� "'+oNode:title+'": "'+c+'"')
  endif
  return ret

***** �������� �� date1 (�������� date1-date2) � �������� _begin_date-_end_date
Function between_date(_begin_date,_end_date,date1,date2)
  // _begin_date - ��砫� ����⢨�
  // _end_date   - ����砭�� ����⢨�
  // date1 - �஢��塞�� ���
  // date2 - ���� ��� ��������� (�᫨ = NIL, � �஢��塞 ⮫쪮 �� date1)
  Local fl := .f., fl2

  DEFAULT date1 TO sys_date  // �� 㬮�砭�� �஢��塞 �� ᥣ����譨� ������
  if empty(_begin_date)
    _begin_date := stod("19930101")  // �᫨ ��砫� ����⢨� = ����, � 01.01.1993
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

***** ������ � ���ᨢ� ������ ���� ������
Function get_field()
  Local arr := array(fcount())

  aeval(arr, {|x,i| arr[i] := fieldget(i) }  )
  return arr

***** 15.01.14 �㭪�� ���஢�� ��஢ ��� �� �����⠭�� (��� ������� INDEX)
Function fsort_usl(sh_u)
  Static _sg := 5
  Local i, s := "", flag_z := .f., flag_0 := .f., arr

  if left(sh_u,1) == "*"
    flag_z := .t.
  elseif left(sh_u,1) == "0"
    flag_0 := .t.
  endif
  arr := usl2arr(sh_u)
  for i := 1 to len(arr)
    if i == 2 .and. flag_z
      s += "9"+strzero(arr[i],_sg)  // ��� 㤠������ ��㣨
    elseif i == 1 .and. flag_0
      s += " "+strzero(arr[i],_sg)  // �᫨ ���।� �⮨� 0
    else
      s += strzero(arr[i],1+_sg)
    endif
  next
  return s

***** 28.01.17
Function usl2arr(sh_u,/*@*/j)
  Local i, k, c, ascc, arr := {}, cDelimiter := ".", s := alltrim(sh_u), ;
        s1 := "", is_all_digit := .t.
  
  if left(s,1) == "*"
    s := substr(s,2)
  endif
  for i := 1 to len(s)
    c := substr(s,i,1) ; ascc := asc(c)
    if between(ascc,48,57) // ?????
      s1 += c
    elseif ISLETTER(c) // ?????
      is_all_digit := .f.
      if len(s1) > 0 .and. right(s1,1) != cDelimiter
        s1 += cDelimiter // ???????????? ??????? ???????????
      endif
      s1 += lstr(ascc)
    else // ????? ???????????
      is_all_digit := .f.
      s1 += cDelimiter
    endif
  next
  if is_all_digit .and. eq_any((k := len(s1)),7,8)  // ???
    if k == 8
      aadd(arr, int(val(substr(s1,1,1))))
      aadd(arr, int(val(substr(s1,2,1))))
      aadd(arr, int(val(substr(s1,3,1))))
      aadd(arr, int(val(substr(s1,6,3))))
      aadd(arr, int(val(substr(s1,4,1))))
    else
      aadd(arr, int(val(substr(s1,1,1))))
      aadd(arr, int(val(substr(s1,2,1))))
      aadd(arr, int(val(substr(s1,3,1))))
      aadd(arr, int(val(substr(s1,5,3))))
      aadd(arr, int(val(substr(s1,4,1))))
    endif
  else // ????????? ??????
    k := numtoken(alltrim(s1),cDelimiter)
    for i := 1 to k
      j := int(val(token(s1,cDelimiter,i)))
      aadd(arr,j)
    next
    if (j := len(arr)) < 5
      for i := j+1 to 5
        aadd(arr,0)
      next
    endif
  endif
  return arr