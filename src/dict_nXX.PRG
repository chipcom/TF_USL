// �ணࠬ�� �������樨 �ࠢ�筨��� ���� N00...XML � DBF-䠩��
#include "dict_error.ch"
#include "edit_spr.ch"
#include "function.ch"

// 10.02.22
FUNCTION read_spr_N00X( source, destination )
   local nfile, nameRef, nameArr

   // N001 �����䨪��� ��⨢���������� � �⪠��� (OnkPrOt)
   private _mo_N001 := {;
      { "ID_PrOt",    "N",  1, 0 }, ; // �����䨪��� ��⨢���������� ��� �⪠��
      { "PrOt_NAME",  "C", 250, 0 }, ; // ������������ ��⨢���������� ��� �⪠��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N002 �����䨪��� �⠤�� (OnkStad)
   private _mo_N002 := {;
      { "ID_St",      "N",  4, 0 }, ; // �����䨪��� �⠤��
      { "DS_St",      "C",  5, 0 }, ; // ������� �� ���
      { "KOD_St",     "C",  5, 0 }, ; // �⠤��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N003 �����䨪��� Tumor (OnkT)
   private _mo_N003 := {;
      { "ID_T",       "N",  4, 0 }, ; // �����䨪��� T
      { "DS_T",       "C",  5, 0 }, ; // ������� �� ���
      { "KOD_T",      "C",  5, 0 }, ; // ������祭�� T ��� ��������
      { "T_NAME",     "C", 250, 0 }, ; // �����஢�� T ��� ��������
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N004 �����䨪��� Nodus (OnkN)
   private _mo_N004 := {;
      { "ID_N",       "N",  4, 0 }, ; // �����䨪��� N
      { "DS_N",       "C",  5, 0 }, ; // ������� �� ���
      { "KOD_N",      "C",  5, 0 }, ; // ������祭�� N ��� ��������
      { "N_NAME",     "C", 250, 0 }, ; // �����஢�� N ��� ��������
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N005 �����䨪��� Metastasis (OnkM)
   private _mo_N005 := {;
      { "ID_M",       "N",  4, 0 }, ; // �����䨪��� M
      { "DS_M",       "C",  5, 0 }, ; // ������� �� ���
      { "KOD_M",      "C",  5, 0 }, ; // ������祭�� M
      { "M_NAME",     "C", 250, 0 }, ; // �����஢�� M
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N006 ��ࠢ�筨� ᮮ⢥��⢨� �⠤�� TNM (OnkTNM) <1>
   private _mo_N006 := {;
      { "ID_gr",      "N",  4, 0 }, ; // �����䨪��� ��ப�
      { "DS_gr",      "C",  5, 0 }, ; // ������� �� ���
      { "ID_St",      "N",  4, 0 }, ; // �����䨪��� �⠤��
      { "ID_T",       "N",  4, 0 }, ; // �����䨪��� T
      { "ID_N",       "N",  4, 0 }, ; // �����䨪��� N
      { "ID_M",       "N",  4, 0 }, ; // �����䨪��� M
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N007 �����䨪��� ���⮫����᪨� �ਧ����� (OnkMrf)
   private _mo_N007 := {;
      { "ID_Mrf",     "N",  2, 0 }, ; // �����䨪��� ���⮫����᪮�� �ਧ����
      { "Mrf_NAME",   "C", 250, 0 }, ; // ������������ ���⮫����᪮�� �ਧ����
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N008 �����䨪��� १���⮢ ���⮫����᪨� ��᫥������� (OnkMrfRt)
   private _mo_N008 := {;
      { "ID_R_M",     "N",  3, 0 }, ; // �����䨪��� �����
      { "ID_Mrf",     "N",  2, 0 }, ; // �����䨪��� ���⮫����᪮�� �ਧ���� � ᮮ⢥��⢨� � N007
      { "R_M_NAME",   "C", 250, 0 }, ; // ������������ १���� ���⮫����᪮�� ��᫥�������
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N009 �����䨪��� ᮮ⢥��⢨� ���⮫����᪨� �ਧ����� ��������� (OnkMrtDS)
   private _mo_N009 := {;
      { "ID_M_D",     "N",  2, 0 }, ; // �����䨪��� ��ப�
      { "DS_Mrf",     "C",  3, 0 }, ; // ������� �� ���
      { "ID_Mrf",     "N",  2, 0 }, ; // �����䨪��� ���⮫����᪮�� �ਧ���� � ᮮ⢥��⢨� � N007
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N010 �����䨪��� ��થ஢ (OnkIgh)
   private _mo_N010 := {;
      { "ID_Igh",     "N",  2, 0 }, ; // �����䨪��� ��થ�
      { "KOD_Igh",    "C", 250, 0 }, ; // ������祭�� ��થ�
      { "Igh_NAME",   "C", 250, 0 }, ; // ������������ ��થ�
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N011 �����䨪��� ���祭�� ��થ஢ (OnkIghRt)
   private _mo_N011 := {;
      { "ID_R_I",     "N",  3, 0 }, ; // �����䨪��� �����
      { "ID_Igh",     "N",  2, 0 }, ; // �����䨪��� ��થ� � ᮮ⢥��⢨� � N010
      { "KOD_R_I",    "C", 250, 0 }, ; // ������祭�� १����
      { "R_I_NAME",   "C", 250, 0 }, ; // ������������ १����
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N012 �����䨪��� ᮮ⢥��⢨� ��થ஢ ��������� (OnkIghDS)
   private _mo_N012 := {;
      { "ID_I_D",     "N",  2, 0 }, ; // �����䨪��� ��ப�
      { "DS_Igh",     "C",  3, 0 }, ; // ������� �� ���
      { "ID_Igh",     "N",  2, 0 }, ; // �����䨪��� ��થ� � ᮮ⢥��⢨� � N010
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N013 �����䨪��� ⨯�� ��祭�� (OnkLech)
   private _mo_N013 := {;
      { "ID_TLech",   "N",  1, 0 }, ; // �����䨪��� ⨯� ��祭��
      { "TLech_NAME", "C", 250, 0 }, ; // ������������ ⨯� ��祭��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N014 �����䨪��� ⨯�� ���ࣨ�᪮�� ��祭�� (OnkHir)
   private _mo_N014 := {;
      { "ID_THir",    "N",  1, 0 }, ; // �����䨪��� ⨯� ���ࣨ�᪮�� ��祭��
      { "THir_NAME",  "C", 250, 0 }, ; // ������������ ⨯� ���ࣨ�᪮�� ��祭��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N015 �����䨪��� ����� ������⢥���� �࠯�� (OnkLek_L)
   private _mo_N015 := {;
      { "ID_TLek_L",  "N",  1, 0 }, ; // �����䨪��� ����� ������⢥���� �࠯��
      { "TLek_NAMEL", "C", 250, 0 }, ; // ������������ ����� ������⢥���� �࠯��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N016 �����䨪��� 横��� ������⢥���� �࠯�� (OnkLek_V)
   private _mo_N016 := {;
      { "ID_TLek_V",  "N",  1, 0 }, ; // �����䨪��� 横�� ������⢥���� �࠯��
      { "TLek_NAMEV", "C", 250, 0 }, ; // ������������ 横�� ������⢥���� �࠯��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N017 �����䨪��� ⨯�� ��祢�� �࠯�� (OnkLuch)
   private _mo_N017 := {;
      { "ID_TLuch",   "N",  1, 0 }, ; // �����䨪��� ⨯� ��祢�� �࠯��
      { "TLuch_NAME", "C", 250, 0 }, ; // ������������ ⨯� ��祢�� �࠯��
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N018 �����䨪��� ������� ���饭�� (OnkReas)
   private _mo_N018 := {;
      { "ID_REAS",    "N",  1, 0 }, ; //
      { "REAS_NAME",  "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N019 �����䨪��� 楫�� ���ᨫ�㬠 (OnkCons)
   private _mo_N019 := {;
      { "ID_CONS",    "N",  1, 0 }, ; //
      { "CONS_NAME",  "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N020 �����䨪��� ������⢥���� �९��⮢, �ਬ��塞�� �� �஢������ ������⢥���� �࠯�� (OnkLekp)
   private _mo_N020 := {;
      { "ID_LEKP",    "C",  6, 0 }, ; //
      { "MNN",        "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }
   // N021 �����䨪��� ᮮ⢥��⢨� ������⢥����� �९��� �奬� ������⢥���� �࠯�� (OnkLpsh)
   private _mo_N021 := {;
      { "ID_ZAP",     "N",  4, 0 }, ; //
      { "CODE_SH",    "C", 10, 0 }, ; //
      { "ID_LEKP",    "C",  6, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // ��� ��砫� ����⢨� �����
      { "DATEEND",    "D",  8, 0 };  // ��� ����砭�� ����⢨� �����
   }

   FOR i := 1 TO 21
      nameRef := 'N' + StrZero( i, 3 ) + '.xml'
      nfile := source + nameRef
      if ! hb_vfExists( nfile )
         out_error(FILE_NOT_EXIST, nfile)
         loop
      endif

      nameArr := "_mo_n" + StrZero( i, 3 )
      dbcreate(destination + nameArr, &nameArr)
        
      USE ( destination + nameArr ) NEW ALIAS SD
      oXmlDoc := HXMLDoc():Read( nfile )
      IF Empty( oXmlDoc:aItems )
         out_error(FILE_READ_ERROR, nfile)
         CLOSE databases
         loop
      ELSE
         out_obrabotka(nfile)         
         k := Len( oXmlDoc:aItems[ 1 ]:aItems )
         FOR j := 1 TO k
            oXmlNode := oXmlDoc:aItems[ 1 ]:aItems[ j ]
            IF "ZAP" == Upper( oXmlNode:title )
               out_obrabotka_count(j, k)
               mDATEEND := CToD( mo_read_xml_stroke( oXmlNode, "DATEEND", ) )
               IF !Empty( mDATEEND ) .AND. Year( mDATEEND ) < 2019
                  LOOP
               ENDIF
               SELECT SD
               APPEND BLANK
               DO CASE
               CASE i == 1
                  sd->ID_PrOt   := Val( mo_read_xml_stroke( oXmlNode, "ID_PrOt", ) )
                  sd->PrOt_NAME := sss( mo_read_xml_stroke( oXmlNode, "PrOt_NAME", ) )
               CASE i == 2
                  sd->ID_St  := Val( mo_read_xml_stroke( oXmlNode, "ID_St", ) )
                  sd->DS_St  := sss( mo_read_xml_stroke( oXmlNode, "DS_St", ) )
                  sd->KOD_St := sss( mo_read_xml_stroke( oXmlNode, "KOD_St", ) )
               CASE i == 3
                  sd->ID_T   := Val( mo_read_xml_stroke( oXmlNode, "ID_T", ) )
                  sd->DS_T   := sss( mo_read_xml_stroke( oXmlNode, "DS_T", ) )
                  sd->KOD_T  := sss( mo_read_xml_stroke( oXmlNode, "KOD_T", ) )
                  sd->T_NAME := sss( mo_read_xml_stroke( oXmlNode, "T_NAME", ) )
               CASE i == 4
                  sd->ID_N   := Val( mo_read_xml_stroke( oXmlNode, "ID_N", ) )
                  sd->DS_N   := sss( mo_read_xml_stroke( oXmlNode, "DS_N", ) )
                  sd->KOD_N  := sss( mo_read_xml_stroke( oXmlNode, "KOD_N", ) )
                  sd->N_NAME := sss( mo_read_xml_stroke( oXmlNode, "N_NAME", ) )
               CASE i == 5
                  sd->ID_M   := Val( mo_read_xml_stroke( oXmlNode, "ID_M", ) )
                  sd->DS_M   := sss( mo_read_xml_stroke( oXmlNode, "DS_M", ) )
                  sd->KOD_M  := sss( mo_read_xml_stroke( oXmlNode, "KOD_M", ) )
                  sd->M_NAME := sss( mo_read_xml_stroke( oXmlNode, "M_NAME", ) )
               CASE i == 6
                  sd->ID_gr := Val( mo_read_xml_stroke( oXmlNode, "ID_gr", ) )
                  sd->DS_gr := sss( mo_read_xml_stroke( oXmlNode, "DS_gr", ) )
                  sd->ID_St := Val( mo_read_xml_stroke( oXmlNode, "ID_St", ) )
                  sd->ID_T  := Val( mo_read_xml_stroke( oXmlNode, "ID_T", ) )
                  sd->ID_N  := Val( mo_read_xml_stroke( oXmlNode, "ID_N", ) )
                  sd->ID_M  := Val( mo_read_xml_stroke( oXmlNode, "ID_M", ) )
               CASE i == 7
                  sd->ID_Mrf   := Val( mo_read_xml_stroke( oXmlNode, "ID_Mrf", ) )
                  sd->Mrf_NAME := sss( mo_read_xml_stroke( oXmlNode, "Mrf_NAME", ) )
               CASE i == 8
                  sd->ID_R_M   := Val( mo_read_xml_stroke( oXmlNode, "ID_R_M", ) )
                  sd->ID_Mrf   := Val( mo_read_xml_stroke( oXmlNode, "ID_Mrf", ) )
                  sd->R_M_NAME := sss( mo_read_xml_stroke( oXmlNode, "R_M_NAME", ) )
               CASE i == 9
                  sd->ID_M_D  := Val( mo_read_xml_stroke( oXmlNode, "ID_M_D", ) )
                  sd->DS_Mrf  := sss( mo_read_xml_stroke( oXmlNode, "DS_Mrf", ) )
                  sd->ID_Mrf  := Val( mo_read_xml_stroke( oXmlNode, "ID_Mrf", ) )
               CASE i == 10
                  sd->ID_Igh   := Val( mo_read_xml_stroke( oXmlNode, "ID_Igh", ) )
                  sd->KOD_Igh  := sss( mo_read_xml_stroke( oXmlNode, "KOD_Igh", ) )
                  sd->Igh_NAME := sss( mo_read_xml_stroke( oXmlNode, "Igh_NAME", ) )
               CASE i == 11
                  sd->ID_R_I   := Val( mo_read_xml_stroke( oXmlNode, "ID_R_I", ) )
                  sd->ID_Igh   := Val( mo_read_xml_stroke( oXmlNode, "ID_Igh", ) )
                  sd->KOD_R_I  := sss( mo_read_xml_stroke( oXmlNode, "KOD_R_I", ) )
                  IF ( s := AllTrim( sd->KOD_R_I ) ) == "+"
                     sd->KOD_R_I := "��"
                  ELSEIF s == "-"
                     sd->KOD_R_I := "���"
                  ENDIF
                  sd->R_I_NAME := sss( mo_read_xml_stroke( oXmlNode, "R_I_NAME", ) )
               CASE i == 12
                  sd->ID_I_D := Val( mo_read_xml_stroke( oXmlNode, "ID_I_D", ) )
                  sd->DS_Igh := sss( mo_read_xml_stroke( oXmlNode, "DS_Igh", ) )
                  sd->ID_Igh := Val( mo_read_xml_stroke( oXmlNode, "ID_Igh", ) )
               CASE i == 13
                  sd->ID_TLech   := Val( mo_read_xml_stroke( oXmlNode, "ID_TLech", ) )
                  sd->TLech_NAME := sss( mo_read_xml_stroke( oXmlNode, "TLech_NAME", ) )
               CASE i == 14
                  sd->ID_THir   := Val( mo_read_xml_stroke( oXmlNode, "ID_THir", ) )
                  sd->THir_NAME := sss( mo_read_xml_stroke( oXmlNode, "THir_NAME", ) )
               CASE i == 15
                  sd->ID_TLek_L  := Val( mo_read_xml_stroke( oXmlNode, "ID_TLek_L", ) )
                  sd->TLek_NAMEL := sss( mo_read_xml_stroke( oXmlNode, "TLek_NAME_L", ) )
               CASE i == 16
                  sd->ID_TLek_V  := Val( mo_read_xml_stroke( oXmlNode, "ID_TLek_V", ) )
                  sd->TLek_NAMEV := sss( mo_read_xml_stroke( oXmlNode, "TLek_NAME_V", ) )
               CASE i == 17
                  sd->ID_TLuch   := Val( mo_read_xml_stroke( oXmlNode, "ID_TLuch", ) )
                  sd->TLuch_NAME := sss( mo_read_xml_stroke( oXmlNode, "TLuch_NAME", ) )
               CASE i == 18
                  sd->ID_REAS    := Val( mo_read_xml_stroke( oXmlNode, "ID_REAS", ) )
                  sd->REAS_NAME  := sss( mo_read_xml_stroke( oXmlNode, "REAS_NAME", ) )
               CASE i == 19
                  sd->ID_CONS    := Val( mo_read_xml_stroke( oXmlNode, "ID_CONS", ) )
                  sd->CONS_NAME  := sss( mo_read_xml_stroke( oXmlNode, "CONS_NAME", ) )
               CASE i == 20
                  sd->ID_LEKP    :=     mo_read_xml_stroke( oXmlNode, "ID_LEKP", )
                  sd->MNN        := sss( mo_read_xml_stroke( oXmlNode, "MNN", ) )
               CASE i == 21
                  sd->ID_ZAP     := Val( mo_read_xml_stroke( oXmlNode, "ID_ZAP", ) )
                  sd->CODE_SH    :=     mo_read_xml_stroke( oXmlNode, "CODE_SH", )
                  sd->ID_LEKP    :=     mo_read_xml_stroke( oXmlNode, "ID_LEKP", )
               ENDCASE
               sd->DATEBEG := CToD( mo_read_xml_stroke( oXmlNode, "DATEBEG", ) )
               sd->DATEEND := CToD( mo_read_xml_stroke( oXmlNode, "DATEEND", ) )
            ENDIF
         NEXT j
      ENDIF
      out_obrabotka_eol()
      CLOSE databases
   NEXT i

   RETURN NIL

// 
FUNCTION sss( s )
   RETURN LTrim( CharRem( eos, CharOne( " ", s ) ) )
