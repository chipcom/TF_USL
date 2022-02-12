procedure main( ... )
  local cParam, cParamL

  local tmp

  aParams := hb_AParams()

  // hb_default( @aArgs, {} )

  FOR EACH cParam IN aParams

    cParamL := Lower( cParam )

    DO CASE
      CASE cParamL == "-help"
        ? 'Help'
      CASE cParamL == "-quiet"
        ? 'quiet'
      CASE hb_LeftEq( cParamL, "-in=" )
        tmp := SubStr( cParam, 4 + 1 )
        ? tmp
      CASE hb_LeftEq( cParamL, "-out=" )
        tmp := SubStr( cParam, 5 + 1 )
        ? tmp
    endcase
  next

  wait
  return