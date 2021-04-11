#include "function.ch"

external errorsys

proc main()
  local sys_date := date(), sys_year := year(date())
  local dbName := '_mo_mkb'
  local dbTFOMS := 'mkb_10_tf'
  local aResult

  f_first()

  // MKB-10 �����䨪��� ���������
  dbcreate( dbName, { ;
    { 'SHIFR', 'C',  6, 0 },; // ���� ��������
    { 'NAME',  'C', 65, 0 },; // ������������ ��������
    { 'KS',    'N',  1, 0 },; // ����� ��ப� ��� ������� ���������
    { 'DBEGIN','D',  8, 0 },; // ��� ��砫� ����⢨� ��������
    { 'DEND',  'D',  8, 0 },; // ��� ����砭�� ����⢨� ��������
    { 'POL',   'C',  1, 0 },; // ��� �� ����� �����࠭���� �������
    { 'KOL',   'N',  1, 0 };  // ��᫮ ��ப � ������������
  })

  dbUseArea( .t.,, dbTFOMS, dbTFOMS, .t., .f. )
  index on CODED to (dbTFOMS)

  dbUseArea( .t.,, dbName, dbName, .t., .f. )

  (dbTFOMS)->(dbGoTop())
  do while ! (dbTFOMS)->(EOF())
    aResult := splitStrToArray( alltrim((dbTFOMS)->NAMED), 65 )
    lenResult := len(aResult)

    for i := 1 to lenResult
      (dbName)->(dbAppend())
      (dbName)->SHIFR := (dbTFOMS)->CODED
      (dbName)->NAME  := aResult[i]
      (dbName)->KS    := i - 1
      (dbName)->DBEGIN:= (dbTFOMS)->DATE_B
      (dbName)->DEND  := (dbTFOMS)->DATE_E
      if ! empty((dbTFOMS)->W)
        (dbName)->POL   := iif((dbTFOMS)->W == '1', '�', '�')
      endif
      (dbName)->KOL   := lenResult
    next

    (dbTFOMS)->(dbSkip())
  end

  filedelete(dbTFOMS + '.ntx')

  f_end()
  return
