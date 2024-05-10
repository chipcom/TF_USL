// программа конвертации справочников ФОМС N00...XML в DBF-файлы
#include "dict_error.ch"
#include "edit_spr.ch"
#include "function.ch"

// 10.02.22
FUNCTION read_spr_N00X( source, destination )
   local nfile, nameRef, nameArr

   // N001 Классификатор противопоказаний и отказов (OnkPrOt)
   private _mo_N001 := {;
      { "ID_PrOt",    "N",  1, 0 }, ; // Идентификатор противопоказания или отказа
      { "PrOt_NAME",  "C", 250, 0 }, ; // Наименование противопоказания или отказа
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N002 Классификатор стадий (OnkStad)
   private _mo_N002 := {;
      { "ID_St",      "N",  4, 0 }, ; // Идентификатор стадии
      { "DS_St",      "C",  5, 0 }, ; // Диагноз по МКБ
      { "KOD_St",     "C",  5, 0 }, ; // Стадия
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N003 Классификатор Tumor (OnkT)
   private _mo_N003 := {;
      { "ID_T",       "N",  4, 0 }, ; // Идентификатор T
      { "DS_T",       "C",  5, 0 }, ; // Диагноз по МКБ
      { "KOD_T",      "C",  5, 0 }, ; // Обозначение T для диагноза
      { "T_NAME",     "C", 250, 0 }, ; // Расшифровка T для диагноза
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N004 Классификатор Nodus (OnkN)
   private _mo_N004 := {;
      { "ID_N",       "N",  4, 0 }, ; // Идентификатор N
      { "DS_N",       "C",  5, 0 }, ; // Диагноз по МКБ
      { "KOD_N",      "C",  5, 0 }, ; // Обозначение N для диагноза
      { "N_NAME",     "C", 250, 0 }, ; // Расшифровка N для диагноза
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N005 Классификатор Metastasis (OnkM)
   private _mo_N005 := {;
      { "ID_M",       "N",  4, 0 }, ; // Идентификатор M
      { "DS_M",       "C",  5, 0 }, ; // Диагноз по МКБ
      { "KOD_M",      "C",  5, 0 }, ; // Обозначение M
      { "M_NAME",     "C", 250, 0 }, ; // Расшифровка M
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N006 Справочник соответствия стадий TNM (OnkTNM) <1>
   private _mo_N006 := {;
      { "ID_gr",      "N",  4, 0 }, ; // Идентификатор строки
      { "DS_gr",      "C",  5, 0 }, ; // Диагноз по МКБ
      { "ID_St",      "N",  4, 0 }, ; // Идентификатор стадии
      { "ID_T",       "N",  4, 0 }, ; // Идентификатор T
      { "ID_N",       "N",  4, 0 }, ; // Идентификатор N
      { "ID_M",       "N",  4, 0 }, ; // Идентификатор M
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N007 Классификатор гистологических признаков (OnkMrf)
   private _mo_N007 := {;
      { "ID_Mrf",     "N",  2, 0 }, ; // Идентификатор гистологического признака
      { "Mrf_NAME",   "C", 250, 0 }, ; // Наименование гистологического признака
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N008 Классификатор результатов гистологических исследований (OnkMrfRt)
   private _mo_N008 := {;
      { "ID_R_M",     "N",  3, 0 }, ; // Идентификатор записи
      { "ID_Mrf",     "N",  2, 0 }, ; // Идентификатор гистологического признака в соответствии с N007
      { "R_M_NAME",   "C", 250, 0 }, ; // Наименование результата гистологического исследования
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N009 Классификатор соответствия гистологических признаков диагнозам (OnkMrtDS)
   private _mo_N009 := {;
      { "ID_M_D",     "N",  2, 0 }, ; // Идентификатор строки
      { "DS_Mrf",     "C",  3, 0 }, ; // Диагноз по МКБ
      { "ID_Mrf",     "N",  2, 0 }, ; // Идентификатор гистологического признака в соответствии с N007
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N010 Классификатор маркеров (OnkIgh)
   private _mo_N010 := {;
      { "ID_Igh",     "N",  2, 0 }, ; // Идентификатор маркера
      { "KOD_Igh",    "C", 250, 0 }, ; // Обозначение маркера
      { "Igh_NAME",   "C", 250, 0 }, ; // Наименование маркера
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N011 Классификатор значений маркеров (OnkIghRt)
   private _mo_N011 := {;
      { "ID_R_I",     "N",  3, 0 }, ; // Идентификатор записи
      { "ID_Igh",     "N",  2, 0 }, ; // Идентификатор маркера в соответствии с N010
      { "KOD_R_I",    "C", 250, 0 }, ; // Обозначение результата
      { "R_I_NAME",   "C", 250, 0 }, ; // Наименование результата
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N012 Классификатор соответствия маркеров диагнозам (OnkIghDS)
   private _mo_N012 := {;
      { "ID_I_D",     "N",  2, 0 }, ; // Идентификатор строки
      { "DS_Igh",     "C",  3, 0 }, ; // Диагноз по МКБ
      { "ID_Igh",     "N",  2, 0 }, ; // Идентификатор маркера в соответствии с N010
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N013 Классификатор типов лечения (OnkLech)
   private _mo_N013 := {;
      { "ID_TLech",   "N",  1, 0 }, ; // Идентификатор типа лечения
      { "TLech_NAME", "C", 250, 0 }, ; // Наименование типа лечения
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N014 Классификатор типов хирургического лечения (OnkHir)
   private _mo_N014 := {;
      { "ID_THir",    "N",  1, 0 }, ; // Идентификатор типа хирургического лечения
      { "THir_NAME",  "C", 250, 0 }, ; // Наименование типа хирургического лечения
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N015 Классификатор линий лекарственной терапии (OnkLek_L)
   private _mo_N015 := {;
      { "ID_TLek_L",  "N",  1, 0 }, ; // Идентификатор линии лекарственной терапии
      { "TLek_NAMEL", "C", 250, 0 }, ; // Наименование линии лекарственной терапии
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N016 Классификатор циклов лекарственной терапии (OnkLek_V)
   private _mo_N016 := {;
      { "ID_TLek_V",  "N",  1, 0 }, ; // Идентификатор цикла лекарственной терапии
      { "TLek_NAMEV", "C", 250, 0 }, ; // Наименование цикла лекарственной терапии
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N017 Классификатор типов лучевой терапии (OnkLuch)
   private _mo_N017 := {;
      { "ID_TLuch",   "N",  1, 0 }, ; // Идентификатор типа лучевой терапии
      { "TLuch_NAME", "C", 250, 0 }, ; // Наименование типа лучевой терапии
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N018 Классификатор поводов обращения (OnkReas)
   private _mo_N018 := {;
      { "ID_REAS",    "N",  1, 0 }, ; //
      { "REAS_NAME",  "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N019 Классификатор целей консилиума (OnkCons)
   private _mo_N019 := {;
      { "ID_CONS",    "N",  1, 0 }, ; //
      { "CONS_NAME",  "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N020 Классификатор лекарственных препаратов, применяемых при проведении лекарственной терапии (OnkLekp)
   private _mo_N020 := {;
      { "ID_LEKP",    "C",  6, 0 }, ; //
      { "MNN",        "C", 250, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
   }
   // N021 Классификатор соответствия лекарственного препарата схеме лекарственной терапии (OnkLpsh)
   private _mo_N021 := {;
      { "ID_ZAP",     "N",  4, 0 }, ; //
      { "CODE_SH",    "C", 10, 0 }, ; //
      { "ID_LEKP",    "C",  6, 0 }, ; //
      { "DATEBEG",    "D",  8, 0 }, ; // Дата начала действия записи
      { "DATEEND",    "D",  8, 0 };  // Дата окончания действия записи
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
                     sd->KOD_R_I := "да"
                  ELSEIF s == "-"
                     sd->KOD_R_I := "нет"
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
