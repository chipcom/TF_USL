REQUEST FCOMMA

function Exfcm()

   local mArr, aYear := {}
   local mYear

   USE test.csv VIA "FCOMMA"
   dbGoTop()
   DO WHILE ! Eof()
      mArr := split( FIELD->LINE, ',' )
      mYear := val( mArr[ 1 ] )
      if ( AScan( aYear, mYear ) ) == 0
         AAdd( aYear, mYear )
      endif
      dbSkip()
   ENDDO
altd()
   RETURN nil
