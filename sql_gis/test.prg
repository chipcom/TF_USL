#require "rddsql"
#require "sddsqlt3"

#include "simpleio.ch"
#include "dbinfo.ch"

REQUEST SDDSQLITE3, SQLMIX

PROCEDURE Main()

   LOCAL tmp

#if defined( __HBSCRIPT__HBSHELL )
   rddRegister( "SQLBASE" )
   rddRegister( "SQLMIX" )
   hb_SDDSQLITE3_Register()
#endif

  Request HB_CODEPAGE_RU866
  hb_cdpSelect( 'RU866' )
  Request HB_LANG_RU866
  hb_langSelect( 'RU866' )

   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )

   rddSetDefault( "SQLMIX" )

   AEval( rddList(), {| X | QOut( X ) } )

   ? "-1-"
//   ? "Connect:", tmp := rddInfo( RDDI_CONNECT, { "SQLITE3", hb_DirBase() + "test.sq3" } )
   ? "Connect:", tmp := rddInfo( RDDI_CONNECT, { "SQLITE3", hb_DirBase() + "gis_mo.db" } )
   IF tmp == 0
      ? "Unable connect to the server"
   ENDIF
   ? "-2-"
//   ? "Use:", dbUseArea( .T., , "select * from t1", "t1" )
   ? "Use:", dbUseArea( .T., , "select * from f031", "f031" )
   ? "-3-"
   ? "Alias:", Alias()
   ? "-4-"
   ? "DB struct:", hb_ValToExp( dbStruct() )
   ? "-5-"
   FOR tmp := 1 TO FCount()
      ? FieldName( tmp ), hb_FieldType( tmp )
   NEXT
   ? "-6-"
   Inkey( 0 )
   Browse()

//   INDEX ON FIELD->AGE TO age
//   dbGoTop()
//   Browse()
   dbCloseArea()

   RETURN
