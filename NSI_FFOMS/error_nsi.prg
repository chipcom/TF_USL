#include 'nsi.ch'

// 13.04.25
Function out_error( nError, nfile, j, k )

  Do Case
  Case nError == FILE_NOT_EXIST
    OutErr( '���� ', nfile, ' �� ����������', hb_eol() )
//  Case nError == FILE_READ_ERROR
//    OutErr( '������ � �������� ����� ', nfile, hb_eol() )
//  Case nError == FILE_RENAME_ERROR
//    OutErr( '������ �������������� ����� ', nfile, hb_eol() )
//  Case nError == DIR_IN_NOT_EXIST
//    OutErr( '������� �������� ������ "', nfile, '" �� ����������. ����������� ������ �� ��������!', hb_eol() )
//  Case nError == DIR_OUT_NOT_EXIST
//    OutErr( '������� ��� �������� ������ "', nfile, '" �� ����������. ����������� ������ �� ��������!', hb_eol() )
//  Case nError == TAG_YEAR_REPORT
//    OutErr( '������ ��� ������ ����� "', nfile, '". ������������ �������� ���� YEAR_REPORT ', j, hb_eol() )
//  Case nError == TAG_PLACE_ERROR
//    OutErr( '������ ��� ������ ����� "', nfile, '" - ����� ������ ���� PLACE � ���������: ', AllTrim( j ), hb_eol() )
//  Case nError == TAG_PERIOD_ERROR
//    OutErr( '������ ��� ������ ����� "', nfile, '" - ����� ������ ���� PERIOD � ����������: ', j, ' � ������ ', k, hb_eol() )
//  Case nError == TAG_VALUE_EMPTY
//    OutErr( '��������� ��� ������ ����� "', nfile, '" - ������ �������� ���� VALUE/LEVEL: ', j, ' � ������ ', k, hb_eol() )
//  Case nError == TAG_VALUE_INVALID
//    OutErr( '��������� ��� ������ ����� "', nfile, '" - ������������ �������� ���� VALUE/LEVEL: ', j, ' � ������ ', k, hb_eol() )
//  Case nError == TAG_ROW_INVALID
//    OutErr( '������ ��� �������� ������ - ', j, ' �� ����� ', nfile, hb_eol() )
//  Case nError == UPDATE_TABLE_ERROR
//    OutErr( '������ ���������� ������� � ������� - ', nfile, hb_eol() )
  Case nError == PACK_ERROR
    OutErr( '������ ��� ������� �� - ', nfile, hb_eol() )
//  Case nError == INVALID_COMMAND_LINE
//    OutErr( '���������� ������������� ����� -all � -update �����������', hb_eol() )
  End Case
  Return Nil
