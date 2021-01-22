#ifndef _FUNCTION_CH
#define _FUNCTION_CH

#define eos chr(13)+chr(10)   // жесткий возврат каретки
#define Hos chr(141)+chr(10)  // мягкий возврат каретки
#define name_help "help.hlp"  // имя файла помощи

// удалить i-ый эл-т массива (и уменьшить его длину)
#xtranslate Del_Array( <array>, <i> ) ;
    => ADEL ( <array>, <i> )          ;
    ;  ASIZE( <array>, LEN( <array> ) - 1 )
// удалить последний эл-т массива (и уменьшить его длину)
#xtranslate Del_Array( <array> ) ;
    => ADEL ( <array>, LEN( <array> ) )        ;
    ;  ASIZE( <array>, LEN( <array> ) - 1 )
// добавить в массив i-ый эл-т
#xtranslate Ins_Array( <array>, <i>, <element> ) ;
    => AADD ( <array>, nil )        ;
    ;  AINS ( <array>, <i> )        ;
    ;  <array>\[<i>\] := <element>

// выделить на экране цветом <color> все строки из массива <arr>
#xtranslate mark_keys( <arr> ) => ;
               aeval( <arr>, {|x| screenmark(x,cColorSt2Msg,.t.,.t.) } )
#xtranslate mark_keys( <arr>, <color> ) => ;
               aeval( <arr>, {|x| screenmark(x,<color>,.t.,.t.) } )

#xtranslate padl(<List,...>)  => padleft(<List>)
#xtranslate padr(<List,...>)  => padright(<List>)
#xtranslate padc(<s>,<l>)     => center(<s>,<l>,,.t.)
#xtranslate padc(<s>,<l>,<c>) => center(<s>,<l>,<c>,.t.)

#xtranslate lstr(<List,...>) =>  ltrim(str(<List>))

#xtranslate lpad(<s>,<m>)    =>  padleft(<s>,<m>)

// проверка четности числа
#translate EVEN( <number> )   =>  ( (<number> % 2) == 0 )

// проверка нечетности числа
#translate ODD( <number> )    =>  ( (<number> % 2) != 0 )

// увеличение числовой переменной на заданную величину
#xtranslate Inc(<v>)      =>  ( ++<v> )
#xtranslate Inc(<v>,<n>)  =>  ( <v> += <n> )

// уменьшение числовой переменной на заданную величину
#xtranslate Dec(<v>)      =>  ( --<v> )
#xtranslate Dec(<v>,<n>)  =>  ( <v> -= <n> )

// точное сравнение на равенство чисел с плавающей точкой
#xtranslate FPEqual(<nVal1>,<nVal2>)  => ;
           ( VAL(STR(<nVal1>)) == VAL(STR(<nVal2>) )
*******************************************************************************
*┌──────────────────┐
*│ MAX(a, b, c,...) │ Вычисление максимума
*└──────────────────┘

*  (1а) от 3 до 5 аргументов - вложенные вызовы MAX()

#translate MAX(<a>,<b>,<c>)         => MAX(MAX(<a>,<b>),<c>)
#translate MAX(<a>,<b>,<c>,<d>)     => MAX(MAX(MAX(<a>,<b>),<c>),<d>)
#translate MAX(<a>,<b>,<c>,<d>,<e>) => MAX(MAX(MAX(MAX(<a>,<b>),<c>),<d>),<e>)

*  (1б) более 5 аргументов - посредством AEVAL

#translate MAX( <xV1>, <xV2>, <xV3>, <xV4>, <xV5>, <xV6> [, <xV7,...> ] ) ;
       => ;
  (temp__arr_ := { <xV1>, <xV2>, <xV3>, <xV4>, <xV5>, <xV6> [, <xV7> ] }, ;
   temp__var_ := temp__arr_\[1\],  ;
   AEVAL( temp__arr_,  ;
          { |e,eNum| temp__var_ := IF(e>temp__var_, e, temp__var_) }  ;
        ),  ;
   temp__var_ )
*******************************************************************************
*┌──────────────────┐
*│ MIN(a, b, c,...) │ Вычисление минимума
*└──────────────────┘

*  (1а) от 3 до 5 аргументов - вложенные вызовы MIN()

#translate MIN(<a>,<b>,<c>)         => MIN(MIN(<a>,<b>),<c>)
#translate MIN(<a>,<b>,<c>,<d>)     => MIN(MIN(MIN(<a>,<b>),<c>),<d>)
#translate MIN(<a>,<b>,<c>,<d>,<e>) => MIN(MIN(MIN(MIN(<a>,<b>),<c>),<d>),<e>)

*  (1б) более 5 аргументов- посредством AEVAL()

#translate MIN( <xV1>, <xV2>, <xV3>, <xV4>, <xV5>, <xV6> [, <xV7,...> ] ) ;
       => ;
  (temp__arr_ := { <xV1>, <xV2>, <xV3>, <xV4>, <xV5>, <xV6> [, <xV7> ] }, ;
   temp__var_ := temp__arr_\[1\],  ;
   AEVAL( temp__arr_,  ;
          { |e,eNum| temp__var_ := IF(e \< temp__var_, e, temp__var_) }  ;
        ),  ;
   temp__var_ )
*******************************************************************************

// установка высокой интенсивности экрана
#xtranslate HighVideo() => SETBLINK(.F.)

// установка низкой (обычной) интенсивности экрана
#xtranslate LowVideo() => SETBLINK(.T.)

/*===================== Заполнение экрана или строки =======================*/

// заполнение экрана требуемым символом текущего или заданного цвета
#xtranslate  FillScreen(<char>[,<color>]) ;
 =>;
  DispBox(0, 0, MAXROW(), MAXCOL(), REPLICATE(<char>,9), <color>)

// заполнение области экрана требуемым символом текущего или заданного цвета
#xtranslate  FillScrArea(<rowtop>,<coltop>,<rowbot>,<colbot>,<char>[,<color>]) ;
 =>;
  DispBox(<rowtop>,<coltop>,<rowbot>,<colbot>, REPLICATE(<char>,9), <color>)

// заполнение строки экрана требуемым символом текущего или заданного цвета
#xtranslate  FillScrLine(<row>,<char>[,<color>]) ;
 =>;
  DispBox(<row>, 0, <row>, MAXCOL(), REPLICATE(<char>,9), <color>)


// преобразовать секунды в строку "ЧЧ:ММ"
#xtranslate hour_min(<n>)    =>  padr(sectotime(<n>),5)

// вернуть имя файла без пути
#xtranslate StripPath(<f>)   =>  ;
            Upper( If("\" $ <f>, SUBSTR(<f>,RAT("\",<f>)+1), <f>) )

// вернуть путь без имени файла
#xtranslate KeepPath(<f>)    =>  ;
            Upper( If("\" $ <f>, SUBSTR(<f>,1,RAT("\",<f>)-1), "") )

// установить курсор "подчеркивание" для <Ins> и нижний полублок для <Ovr>
#xtranslate SETCURSOR() => SETCURSOR(2, .F.) ; SETCURSOR(1, .T.)

// очистка со строки top до конца экрана
#xtranslate myclear(<top>) => Scroll( <top>, 0 ) ; SetPos( <top>, 0 )

// звонок
#xtranslate MyBell()     =>  QQOut(CHR(7))
#xtranslate MyBell(<k>)  =>  QQOut(CHR(7)) ; INKEY(<k>)
#xtranslate MyBell(<k>,<x:OK,ERROR,ERR,&>)  =>  music_m(<(x)>) ; INKEY(<k>)

//   компиляция символьного представления кодового блока
#define COMPILE(ExpC)   &( "{|| " + ExpC + "}" )

// проверка вхождения значения переменной в заданный диапазон
// (без контроля типа переменной)
#xtranslate BETWEEN( <V>, <L>, <H> ) => ( <V> \>= <L> .and. <V> \<= <H> )
// попадание чмсла в диапазон
#define Range( xVar, xExpr1, xExpr2 ) ;
    ( xVar >= MIN( xExpr1, xExpr2 ) .AND. xVar <= MAX( xExpr1, xExpr2 ) )

// очистка всей строки экрана текущим или заданным цветом
#xtranslate ClrLine(<row>[,<color>]) ;
 => ;
  ( IF(<.color.>, ;
       EVAL( {|_c| _c:=SETCOLOR(<color>), Scroll(<row>,0,<row>), SETCOLOR(_c)} ),;
       SCROLL(<row>,0,<row>)     ;
      ),                         ;
    SETPOS(<row>,0)              ;
  )

// очистка указанных смежных строк экрана текущим или заданным цветом
#xtranslate ClrLines(<row1>, <row2> [,<color>]) ;        // row1 <= row2 !
 => ;
  ( IF(<.color.>, ;
       EVAL( {|_c| _c:=SETCOLOR(<color>), Scroll(<row1>,0,<row2>,MAXCOL()), SETCOLOR(_c)} ),;
       SCROLL(<row1>,0,<row2>,MAXCOL()) ;
      ),                                ;
    SETPOS(<row1>,0)                    ;
  )

// Проверка типа одной или нескольких переменных

* проверка принадлежности каждой из заданных переменных к символьному типу
#xtranslate ISCHAR( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'C' [ .and. VALTYPE( <x2> ) == 'C' ] )

* проверка принадлежности каждой из заданных переменных к числовому типу
#xtranslate ISNUMBER( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'N' [ .and. VALTYPE( <x2> ) == 'N' ] )

* проверка принадлежности каждой из заданных переменных к логическому типу
#xtranslate ISLOGIC( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'L' [ .and. VALTYPE( <x2> ) == 'L' ] )

* проверка принадлежности каждой из заданных переменных к типу "дата"
#xtranslate ISDATE( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'D' [ .and. VALTYPE( <x2> ) == 'D' ] )

* проверка принадлежности каждой из заданных переменных к типу "массив"
#xtranslate ISARRAY( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'A' [ .and. VALTYPE( <x2> ) == 'A' ] )

* проверка принадлежности каждой из заданных переменных к типу "блок кода"
#xtranslate ISBLOCK( <x1> [, <x2> ] ) => ( VALTYPE( <x1> ) == 'B' [ .and. VALTYPE( <x2> ) == 'B' ] )

* проверка принадлежности первого символа строки к русскому алфавиту
#xtranslate ISRALPHA( <s> ) => ;
    EVAL( { |_c| _c:=ASC(<s>), ( BETWEEN(_c,128,175) .or. BETWEEN(_c,224,241) ) } )

* проверка наличия буквы (лат/рус) в первом символе строки
#xtranslate ISLETTER( <s> ) => ( ISALPHA( <s> ) .or. ISRALPHA( <s> ) )


// Проверка на пустоту значения одной или нескольких переменных

* проверка одновременного наличия пустого значения в заданных переменных
#xtranslate EMPTYALL( <x1> [, <x2> ] ) => ( EMPTY(<x1>) [ .and. EMPTY(<x2>) ] )

* проверка наличия пустого значения в одной из заданных переменных
#xtranslate EMPTYANY( <x1> [, <x2> ] ) => ( EMPTY(<x1>) [ .or. EMPTY(<x2>) ] )

* проверка равенства переменной одному из заданных значений
#xtranslate EQUALANY( <v>, <x1> [, <x2> ] ) => ( <v> == <x1> [ .or. <v> == <x2> ] )

#xcommand SAVE GETS TO <array>       =>  <array> := GetList; GetList := {}
#xcommand RESTORE GETS FROM <array>  =>  GetList := <array>

#xcommand DEFAULT <p> TO <v> [, <p2> TO <v2> ] => ;
          <p> := IF(<p> == NIL, <v>, <p>) ;
          [; <p2> := IF(<p2> == NIL, <v2>, <p2>) ]

#xcommand VALDEFAULT <p1>,<t1> TO <v1> [, <p2>,<t2> TO <v2> ] => ;
                     <p1> := IF(valtype(<p1>) != <t1>, <v1>, <p1>) ;
                  [; <p2> := IF(valtype(<p2>) != <t2>, <v2>, <p2>) ]

// собственная реализация MENU TO
#command @ <PrRow>, <PrCol> PROMPT <Prompt>             ;
                            [MESSAGE <Message> ]        ;
                            [MSGROW <MsgRow> ]          ;
                            [MSGCOL <MsgCol> ]          ;
                            [MSGCOLOR <MsgColor> ]      ;
                            [UP <Up> ]                  ;
                            [DOWN <Down> ]              ;
                            [RIGHT <Right> ]            ;
                            [LEFT <Left> ]              ;
      => FT_Prompt( <PrRow>, <PrCol>, <Prompt>,         ;
         <MsgRow>, <MsgCol>, <Message>, <(MsgColor)>,   ;
         <Up>, <Down>, <Right>, <Left> )

#command MENU TO <v> [REGION <r> ] [BLOCK <b>];
      => <v> := FT_MenuTo({|_1| IF(_1==NIL, <v>, <v>:=_1)}, #<v>, <r>, <b>)

// reader для обычного GET'а
#command  @ <row>, <col> GET <var>                                ;
                         [<clauses,...>]                          ;
                         READER <mreader>                         ;
                         [<moreClauses,...>]                      ;
       => @ <row>, <col> GET <var>                                 ;
                         [<clauses>]                               ;
                         [<moreClauses>]                           ;
       ; ATail(GetList):reader := <mreader>

// реализация LOCATE c отображением процесса поиска объектом GAUGE
#command LOCATE                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
         PROGRESS [<color>]                                       ;
         [<p: NUMPROCENT>]                                        ;
         [AT <row>, <col> ]                                       ;
         [COLOR <color>]                                          ;
      => dbLocateProgress( <{for}>, <{while}>, <next>, <rec>, <.rest.>, ;
                           if( <.p.>, .T., NIL ),                       ;
                           [<row>], [<col>] [,<color>] )

// реализация INDEX ON c отображением процесса индексации объектом GAUGE

#command INDEX ON <key> [TAG <(cOrderName)> ] TO <(cOrderBagName)>      ;
         [FOR <for>]                                                    ;
         [<all:ALL>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [EVAL <eval>]                                                  ;
         [EVERY <every>]                                                ;
         [<unique: UNIQUE>]                                             ;
         [<ascend: ASCENDING>]                                          ;
         [<descend: DESCENDING>]                                        ;
         PROGRESS [<color>]                                       ;
         [<p: NUMPROCENT>]                                        ;
         [AT <row>, <col> ]                                       ;
         [COLOR <color>]                                          ;
 => db1IndexProgress(                                         ;
                     <"for">, <{for}>,                                  ;
                     [<.all.>],                                         ;
                     <{while}>,                                         ;
                     <{eval}>, <every>,                                 ;
                     RECNO(), <next>, <rec>,                            ;
                     [<.rest.>], [<.descend.>],                         ;
                   <(cOrderBagName)>, <(cOrderName)>,                   ;
                   <"key">, <{key}>, [<.unique.>],                      ;
                      if( <.p.>, .T., NIL ),                   ;
                      [<row>],[<col>][,<color>]                ;
                     )

#command INDEX ON <key> TAG <(cOrderName)> [TO <(cOrderBagName)>]       ;
         [FOR <for>]                                                    ;
         [<all:ALL>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [EVAL <eval>]                                                  ;
         [EVERY <every>]                                                ;
         [<unique: UNIQUE>]                                             ;
         [<ascend: ASCENDING>]                                          ;
         [<descend: DESCENDING>]                                        ;
         PROGRESS [<color>]                                       ;
         [<p: NUMPROCENT>]                                        ;
         [AT <row>, <col> ]                                       ;
         [COLOR <color>]                                          ;
 => db1IndexProgress(                                         ;
                     <"for">, <{for}>,                                  ;
                     [<.all.>],                                         ;
                     <{while}>,                                         ;
                     <{eval}>, <every>,                                 ;
                     RECNO(), <next>, <rec>,                            ;
                     [<.rest.>], [<.descend.>],                         ;
                   <(cOrderBagName)>, <(cOrderName)>,                   ;
                   <"key">, <{key}>, [<.unique.>],                      ;
                      if( <.p.>, .T., NIL ),                   ;
                      [<row>],[<col>][,<color>]                ;
                     )

// сохранение экрана в переменной
#xtranslate savescreen() => savescreen(0,0,24,79)
// просто восстановление экрана
#xtranslate restscreen(<buf>)  => restscreen(0,0,24,79,<buf>)
// восстановление экрана с разными эффектами (по очереди в цикле)
#xtranslate restscreen(<buf>,0)  => myrestscr(<buf>)
// восстановление экрана с разворотом от центра
#xtranslate restscreen(<buf>,1)  =>     SCRROTATE1(<buf>)
// восстановление экрана с разворотом от центров 2-х половин экрана
#xtranslate restscreen(<buf>,2)  =>     SCRROTATE2(<buf>)
// восстановление экрана с разворотом по диагонали
#xtranslate restscreen(<buf>,3)  =>     SCRDROTATE(<buf>)
// восстановление экрана сверху вних (с помехами)
#xtranslate restscreen(<buf>,4)  =>     SCRSHIFVER(<buf>)
// восстановление экрана слева направо (с помехами)
#xtranslate restscreen(<buf>,5)  =>     SCRSHIFHOR(<buf>)
// восстановление экрана сверху вних (без помех)
#xtranslate restscreen(<buf>,6)  =>     SCROVERVER(<buf>)
// восстановление экрана слева направо (без помех)
#xtranslate restscreen(<buf>,7)  =>     SCROVERHOR(<buf>)
// восстановление экрана - вертикальные линейки
#xtranslate restscreen(<buf>,8)  =>     SCRSTRPVER(<buf>)
// восстановление экрана - горизонтальные линейки
#xtranslate restscreen(<buf>,9)  =>     SCRSTRPHOR(<buf>)
// восстановление экрана - "широкая кисть" сверху вниз слева направо
#xtranslate restscreen(<buf>,10) =>     SCRCOLUMNS(<buf>)

#command @ <row>, <col> VSAY <sayxpr>                                   ;
                        [<sayClauses,...>]                              ;
                        VGET <var>                                      ;
                        [<getClauses,...>]                              ;
                                                                        ;
      => @ <row>, <col> VSAY <sayxpr> [<sayClauses>]                    ;
       ; @ <row>, VCOL() VGET <var> [<getClauses>]

#command @ <row>, <col> VSAY <sayxpr>                                   ;
                        [COLOR <color>]                                 ;
                                                                        ;
      => _1s := <sayxpr>                                                ;
       ; _1l := len(_1s)                                                ;
       ;  AAdd( vGetBG, { <row>, <col>, _1s, [<color>] } )              ;
       ; vGetCol := <col> + _1l + 1

#command @ <row>, <col> VGET <var>                                      ;
                        [PICTURE <pic>]                                 ;
                        [READER <mreader>]                              ;
                        [VALID <valid>]                                 ;
                        [WHEN <when>]                                   ;
                        [COLOR <color>]                                 ;
                        [SEND <msg>]                                    ;
                                                                        ;
      =>  AAdd(                                                         ;
            vGetlist,                                                   ;
            GetNew( <row>, <col>,                                       ;
                    {|_nv| iif(_nv == NIL, <var>, <var> := _nv) },      ;
                    <(var)>, <pic>, <color>)                            ;
             )                                                          ;
       ; vGetCol := <col> + varlen( <var>, <pic> )                      ;
      [; ATail(vGetlist):PostBlock := <{valid}>]                        ;
      [; ATail(vGetlist):PreBlock  :=  <{when}>]                        ;
      [; ATail(vGetList):reader := <mreader>   ]                        ;
      [; ATail(vGetlist):<msg>]

#endif
