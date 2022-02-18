/*
   MD5 digest (based on RFC 1321 only). Harbour implementation

   PRG functions:

   hb_MD5( <cString> ) --> <cMD5>
         Calculates RFC 1321 MD5 digest (128-bit checksum)
      Parameters:
         <cString>   - string variable to calculate MD5
      Returns:
         ASCII hex MD5 digest as 32-byte string
         empty string on error

   hb_MD5File( <cFileName> ) --> <cMD5>
         Calculates RFC 1321 MD5 digest (128-bit checksum) of a file contents
         (file size is limited by OS limits only)
      Parameters:
         <cFileName> - file name
      Returns:
         ASCII hex MD5 digest as 32-byte string
         empty string on error

 */

 func main()
  local cStr

  cStr := hb_MD5File( '_mo_dbb.DBF' )
  ? cStr
  cStr := hb_MD5File( '_mo_mo.DBF' )
  ? cStr
  cStr := hb_MD5File( '_mo1mo.DBF' )
  ? cStr
  wait

  return nil