/*
 * SQLite3 Demo. Using sqlite3_commit_hook(), sqlite3_rollback_hook()
 *
 * Copyright 2009 P.Chornyj <myorg63@mail.ru>
 *
 *
 */

#require "hbsqlit3"

PROCEDURE Main()

   LOCAL cSQLTEXT, cFile := ":memory:"
   LOCAL pDb, cb := @CallBack()

   IF Empty( pDb := PrepareDB( cFile ) )
      ErrorLevel( 1 )
      RETURN
   ENDIF

   sqlite3_commit_hook( pDb, "HookCommitY" )

   ? cSQLTEXT := "SELECT * FROM person WHERE name == 'Andy'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT, cb ) )

   ? cSQLTEXT := "BEGIN EXCLUSIVE TRANSACTION"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "DELETE FROM person WHERE name == 'Andy'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "END TRANSACTION"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "SELECT * FROM person WHERE name == 'Andy'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT, cb ) )

   ? Replicate( "-", Len( cSQLTEXT ) )

   sqlite3_sleep( 10000 )

   sqlite3_commit_hook( pDb, @HookCommitN() )
   sqlite3_rollback_hook( pDb, @HookRollback() )

   ? cSQLTEXT := "SELECT * FROM person WHERE name == 'Ivet'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT, cb ) )

   ? cSQLTEXT := "BEGIN EXCLUSIVE TRANSACTION"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "DELETE FROM person WHERE name == 'Ivet'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "END TRANSACTION"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   ? cSQLTEXT := "SELECT * FROM person WHERE name == 'Ivet'"
   ? "return value: ", cErrorMsg( sqlite3_exec( pDb, cSQLTEXT, cb ) )

   pDb := NIL

   sqlite3_sleep( 10000 )

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

FUNCTION HookCommitY()

   LOCAL oldColor := SetColor( "R+/N" )

   ? "!! COMMIT"

   SetColor( oldColor )

   RETURN 0

FUNCTION HookCommitN()

   LOCAL oldColor := SetColor( "B+/N" )

   ? "?? COMMIT or ROLLBACK"

   SetColor( oldColor )

   RETURN 1 // not 0

FUNCTION HookRollback()

   LOCAL oldColor := SetColor( "R+/N" )

   ? "!! ROLLBACK"

   SetColor( oldColor )

   RETURN 1

/**
*/
STATIC FUNCTION cErrorMsg( nError, lShortMsg )

   hb_default( @lShortMsg, .T. )

   RETURN iif( lShortMsg, hb_sqlite3_errstr_short( nError ), sqlite3_errstr( nError ) )

/**
*/

STATIC FUNCTION PrepareDB( cFile )

   LOCAL cSQLTEXT, cMsg
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

   ? cSQLTEXT := "CREATE TABLE person( name TEXT, age INTEGER )"
   cMsg := cErrorMsg( sqlite3_exec( pDb, cSQLTEXT ) )

   IF !( cMsg == "SQLITE_OK" )
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

   ? sqlite3_sql( pStmt )
   ? Replicate( "-", Len( cSQLTEXT ) )

   FOR EACH enum IN hPerson
      sqlite3_reset( pStmt )
      sqlite3_bind_text( pStmt, 1, enum:__enumKey() )
      sqlite3_bind_int( pStmt, 2, enum:__enumValue() )
      sqlite3_step( pStmt )
   NEXT

   sqlite3_clear_bindings( pStmt )
   sqlite3_finalize( pStmt )

   RETURN pDb
