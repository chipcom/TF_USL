/*
 * SQLite3 Demo
 *
 * Copyright 2007 P.Chornyj <myorg63@mail.ru>
 *
 */

#require "hbsqlit3"

PROCEDURE Main()

   LOCAL db := sqlite3_open_v2( "new.s3db", SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )

   IF ! Empty( db )
      IF sqlite3_exec( db, "VACUUM" ) == SQLITE_OK
         ? "PACK - Done"

         sqlite3_sleep( 3000 )
      ENDIF
   ENDIF

   RETURN
