/*
 * SQLite3 Demo. Using sqlite3_backup_*()
 *
 * Copyright 2009 P.Chornyj <myorg63@mail.ru>
 *
 
/*
 * Using sqlite3_backup_*()
 *
 * This API is used to overwrite the contents of one database with that
 * of another. It is useful either for creating backups of databases or
 * for copying in-memory databases to or from persistent files.
 *
 * sqlite3_backup_init() is called once to initialize the backup,
 * sqlite3_backup_step() is called one or more times to transfer the data
 *                       between the two databases, and finally
 * sqlite3_backup_finish() is called to release all resources associated
 *                       with the backup operation.
 */

#require "hbsqlit3"

PROCEDURE Main()

   LOCAL cFileSource := ":memory:", cFileDest := "backup.db", cSQLTEXT
   LOCAL pDbSource, pDbDest, pBackup, cb, nDbFlags

   IF sqlite3_libversion_number() < 3006011
      ErrorLevel( 1 )
      RETURN
   ENDIF

   IF Empty( pDbSource := PrepareDB( cFileSource ) )
      ErrorLevel( 1 )
      RETURN
   ENDIF

   nDbFlags := SQLITE_OPEN_CREATE + SQLITE_OPEN_READWRITE + ;
      SQLITE_OPEN_EXCLUSIVE
   pDbDest := sqlite3_open_v2( cFileDest, nDbFlags )

   IF Empty( pDbDest )
      ? "Can't open database : ", cFileDest
      ErrorLevel( 1 )
      RETURN
   ENDIF

   sqlite3_trace( pDbDest, .T., "backup.log" )

   pBackup := sqlite3_backup_init( pDbDest, "main", pDbSource, "main" )
   IF Empty( pBackup )
      ? "Can't initialize backup"
      ErrorLevel( 1 )
      RETURN
   ELSE
      ? "Start backup.."
   ENDIF

   IF sqlite3_backup_step( pBackup, -1 ) == SQLITE_DONE
      ? "Backup successful."
   ENDIF

   sqlite3_backup_finish( pBackup ) /* !!! */

   pDbSource := NIL /* close :memory: database */

   /* Little test for sqlite3_exec with callback  */
   ?
   ? cSQLTEXT := "SELECT * FROM main.person WHERE age BETWEEN 20 AND 40"
   cb := @CallBack() // "CallBack"
   ? cErrorMsg( sqlite3_exec( pDbDest, cSQLTEXT, cb ) )

   pDbDest := NIL // close database

   sqlite3_sleep( 3000 )

   RETURN

/**
*/

FUNCTION CallBack( nColCount, aValue, aColName )

   LOCAL nI
   LOCAL oldColor := SetColor( "G/N" )

   FOR nI := 1 TO nColCount
      ? PadR( aColName[ nI ], 5 ), " == ", aValue[ nI ]
   NEXT

   SetColor( oldColor )

   RETURN 0

/**
*/

STATIC FUNCTION cErrorMsg( nError, lShortMsg )

   hb_default( @lShortMsg, .T. )

   RETURN iif( lShortMsg, hb_sqlite3_errstr_short( nError ), sqlite3_errstr( nError ) )

/**
*/

STATIC FUNCTION PrepareDB( cFile )

   LOCAL cSQLTEXT
   LOCAL pDb, pStmt
   LOCAL hPerson := { ;
      "Bob" => 52, ;
      "Fred" => 32, ;
      "Sasha" => 17, ;
      "Andy" => 20, ;
      "Ivet" => 28 ;
      }, enum

   pDb := sqlite3_open( cFile, .T. )
   IF Empty( pDb )
      ? "Can't open/create database : ", cFile

      RETURN NIL
   ENDIF

   sqlite3_trace( pDb, .T., "backup.log" )

   cSQLTEXT := "CREATE TABLE person( name TEXT, age INTEGER )"
   IF sqlite3_exec( pDb, cSQLTEXT ) != SQLITE_OK
      ? "Can't create table : person"
      pDb := NIL // close database

      RETURN NIL
   ENDIF

   cSQLTEXT := "INSERT INTO person( name, age ) VALUES( :name, :age )"
   pStmt := sqlite3_prepare( pDb, cSQLTEXT )
   IF Empty( pStmt )
      ? "Can't prepare statement : ", cSQLTEXT
      pDb := NIL

      RETURN NIL
   ENDIF

   FOR EACH enum IN hPerson
      sqlite3_reset( pStmt )
      sqlite3_bind_text( pStmt, 1, enum:__enumKey() )
      sqlite3_bind_int( pStmt, 2, enum:__enumValue() )
      sqlite3_step( pStmt )
   NEXT

   sqlite3_clear_bindings( pStmt )
   sqlite3_finalize( pStmt )

   RETURN pDb
