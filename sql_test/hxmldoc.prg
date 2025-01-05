/*
 * hxmldoc.prg,v 1.10 2004/08/02 09:28:54
 *
 * Harbour XML Library
 * HXmlDoc class
 *
 * Copyright 2003-2006 Alexander S.Kresin <alex@belacy.belgorod.su>
 * www - http://kresin.belgorod.su
*/

#include "hbclass.ch"
#include "fileio.ch"
#include "i_xml.ch"

#define EOS chr(13)+chr(10)

/*
 *  CLASS DEFINITION
 *  HXMLNode
 */

Class HXMLNode

  Data title
  Data Type
  Data aItems  Init {}
  Data aAttr   Init {}

  Method new( cTitle, type, aAttr )
  Method add( xItem )
  Method getattribute( cName )
  Method setattribute( cName, cValue )
  Method save( handle, level )
  Method find( cTitle, nStart )

Endclass

Method new( cTitle, type, aAttr, cValue ) Class HXMLNode

  If cTitle != Nil ; ::title := cTitle ; Endif
  If aAttr  != Nil ; ::aAttr := aAttr  ; Endif
  ::type := iif( type != Nil, type, HBXML_TYPE_TAG )
  If cValue != Nil
    ::add( cValue )
  Endif

  Return Self

Method add( xItem ) Class HXMLNode

  AAdd( ::aItems, xItem )

  Return xItem

Method getattribute( cName ) Class HXMLNode

  Local i := AScan( ::aAttr, {| a| a[ 1 ] == cName } )

  Return iif( i == 0, Nil, ::aAttr[ i, 2 ] )

Method setattribute( cName, cValue ) Class HXMLNode

  Local i := AScan( ::aAttr, {| a| a[ 1 ] == cName } )

  If i == 0
    AAdd( ::aAttr, { cName, cValue } )
  Else
    ::aAttr[ i, 2 ] := cValue
  Endif

  Return .t.

Method save( handle, level ) Class HXMLNode

  Local i, s, lNewLine

  s := Space( level * 2 ) + '<'
  IF ::type == HBXML_TYPE_COMMENT
    s += '!--'
  ELSEIF ::type == HBXML_TYPE_CDATA
    s += '![CDATA['
  ELSEIF ::type == HBXML_TYPE_PI
    s += '?' + ::title
  Else
    s += ::title
  Endif
  IF ::type == HBXML_TYPE_TAG .or. ::type == HBXML_TYPE_SINGLE
    For i := 1 To Len( ::aAttr )
      s += ' ' + ::aAttr[ i, 1 ] + '="' + hbxml_transform( ::aAttr[ i, 2 ] ) + '"'
    Next
  Endif
  IF ::type == HBXML_TYPE_COMMENT
    s += '-->' + EOS
  ELSEIF ::type == HBXML_TYPE_PI
    s += '?>' + EOS
  ELSEIF ::type == HBXML_TYPE_SINGLE
    s += '/>' + EOS
  ELSEIF ::type == HBXML_TYPE_TAG
    s += '>'
    If Len( ::aItems ) == 1 .and. ValType( ::aItems[ 1 ] ) == "C"
      lNewLine := .f.
    Else
      s += EOS
      lNewLine := .t.
    Endif
  Endif
  If handle >= 0
    FWrite( handle, s )
  Endif

  For i := 1 To Len( ::aItems )
    If ValType( ::aItems[ i ] ) == "C"
      If handle >= 0
        IF ::type == HBXML_TYPE_CDATA
          FWrite( handle, ::aItems[ i ] )
        Else
          FWrite( handle, hbxml_transform( ::aItems[ i ] ) )
        Endif
      Else
        IF ::type == HBXML_TYPE_CDATA
          s += ::aItems[ i ]
        Else
          s += hbxml_transform( ::aItems[ i ] )
        Endif
      Endif
    Else
      s += ::aItems[ i ]:save( handle, level + 1 )
    Endif
  Next
  If handle >= 0
    IF ::type == HBXML_TYPE_TAG
      FWrite( handle, iif( lNewLine, Space( level * 2 ), "" ) + '</' + ::title + '>' + EOS )
    ELSEIF ::type == HBXML_TYPE_CDATA
      FWrite( handle, ']]>' + EOS )
    Endif
  Else
    IF ::type == HBXML_TYPE_TAG
      s += iif( lNewLine, Space( level * 2 ), "" ) + '</' + ::title + '>' + EOS
    ELSEIF ::type == HBXML_TYPE_CDATA
      s += ']]>' + EOS
    Endif
    Return s
  Endif

  Return ""

Method find( cTitle, nStart, block ) Class HXMLNode

  Local i

  If nStart == Nil
    nStart := 1
  Endif
  Do While .t.
    i := AScan( ::aItems, {| a| ValType( a ) != "C" .and. ;
      Upper( a:title ) == Upper( cTitle ) }, nStart )
    If i == 0
      Exit
    Else
      nStart := i
      If block == Nil .or. Eval( block, ::aItems[ i ] )
        Return ::aItems[ i ]
      Else
        nStart++
      Endif
    Endif
  Enddo

  Return Nil


/*
 *  CLASS DEFINITION
 *  HXMLDoc
 */

Class HXMLDoc Inherit HXMLNode

  Method new( encoding )
  Method read( fname )
  Method readstring( buffer )  INLINE ::read( , buffer )
  Method save( fname, lNoHeader )
  Method save2string()  INLINE ::save()

Endclass

Method new( encoding ) Class HXMLDoc

  If encoding == Nil
    encoding := "Windows-1251"
  Endif
  AAdd( ::aAttr, { "version", "1.0" } )
  AAdd( ::aAttr, { "encoding", encoding } )

  Return Self

Method read( fname, buffer ) Class HXMLDoc

  Local han

  If fname != Nil
    han := FOpen( fname, FO_READ )
    If han != -1
      hbxml_getdoc( Self, han )
      FClose( han )
    Endif
  Elseif buffer != Nil
    hbxml_getdoc( Self, buffer )
  Else
    Return Nil
  Endif

  Return Self

Method save( fname, lNoHeader ) Class HXMLDoc

  Local handle := -2
  Local cEncod, i, s

  If fname != Nil
    handle := FCreate( fname )
  Endif
  If handle != -1
    If lNoHeader == Nil .or. !lNoHeader
      If ( cEncod := ::getattribute( "encoding" ) ) == Nil
        cEncod := "Windows-1251"
      Endif
      s := '<?xml version="1.0" encoding="' + cEncod + '"?>' + EOS
      If fname != Nil
        FWrite( handle, s )
      Endif
    Else
      s := ""
    Endif
    For i := 1 To Len( ::aItems )
      s += ::aItems[ i ]:save( handle, 0 )
    Next
    If fname != Nil
      FClose( handle )
    Else
      Return s
    Endif
  Endif

  Return .t.
