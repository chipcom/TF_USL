#include 'function.ch'
#include 'dict_error.ch'

****** 15.02.22
function out_error(nError, nfile, j, k)

  do case
    case nError == FILE_NOT_EXIST
      OutErr( ;
        '���� ' + nfile + ' �� �������' + hb_eol() )
    case nError == FILE_READ_ERROR
      OutErr( ;
        '�訡�� � ����㧪� 䠩�� ' + nfile + hb_eol() )
    case nError == FILE_RENAME_ERROR
      OutErr( ;
        '�訡�� ��२��������� 䠩�� ' + nfile + hb_eol() )
    case nError == DIR_IN_NOT_EXIST
      OutErr( ;
        '��⠫�� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!' + hb_eol() )
    case nError == DIR_OUT_NOT_EXIST
      OutErr( ;
        '��⠫�� ��� ��室��� ������ "' + nfile + '" �� �������. �த������� ࠡ��� �� ��������!' + hb_eol() )
    case nError == TAG_YEAR_REPORT
        OutErr( ;
          '�訡�� �� �⥭�� 䠩�� "' + nfile + '". �����४⭮� ���祭�� ⥣� YEAR_REPORT ' + j + hb_eol() )
    case nError == TAG_PLACE_ERROR
        OutErr( ;
          '�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PLACE � �⤥�����: ' + alltrim(j) + hb_eol() )
    case nError == TAG_PERIOD_ERROR
        OutErr( ;
          '�訡�� �� �⥭�� 䠩�� "' + nfile + '" - ����� ������ ⥣� PERIOD � ��०�����: ' + j + " � ��㣥 " + k + hb_eol() )
    case nError == TAG_VALUE_EMPTY
        OutErr( ;
          '����砭�� �� �⥭�� 䠩�� "' + nfile + '" - ���⮥ ���祭�� ⥣� VALUE/LEVEL: ' + j + " � ��㣥 " + k + hb_eol() )
    case nError == TAG_VALUE_INVALID
        OutErr( ;
          '����砭�� �� �⥭�� 䠩�� "' + nfile + '" - �����४⭮� ���祭�� ⥣� VALUE/LEVEL: ' + j + " � ��㣥 " + k + hb_eol() )
    case nError == TAG_ROW_INVALID
        OutErr( ;
          '�訡�� �� ����㧪� ��ப� - ' + j + ' �� 䠩�� ' +nfile + hb_eol() )
    case nError == UPDATE_TABLE_ERROR
        OutErr( ;
          '�訡�� ���������� ����ᥩ � ⠡��� - ' + nfile + hb_eol() )
    case nError == PACK_ERROR
        OutErr( ;
          '�訡�� �� ���⪨ �� - ' + nfile + hb_eol() )
    end case

  return nil
