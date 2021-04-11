/* displaying a multiline browse.

Since in the last time there were some questions about a multiline browse on
Clipper and ClipGer forum, and since I couldn't find an example, I wrote one
by myself.

Maybe there may be some glitches in this example, but correcting them will
help you to write better code than I do <g>.

It is intended just to display two lines in a browse, but after you got the
clue, you will be able to adjust it to more lines.

One main reason for me to write these functions is Frankie.LIB. I migrated
all my interface work to Frankie, except one module that handles access to
databases displayed in tables, since this module uses a two-line browse, and
Frankie doesn't handles this (BUT: Frankie handles of lot of other things
very well, and if you don't use Frankie, you really should have a look at
it, escpecially if you are looking for a good mousing library for Clipper!)
Now I can integrate the last module with Frankie, and every interface has now
real mouse control.

This code is postcard-ware: you may use it, modify it and earn lots of money
with it. But before you should send me a postcard from your home town. My last
posted postcard-ware resulted in a lot of downloads, but in NO postcard.

My address is:

George S. Lorrig
Auf dem Fuerling 12
53937 Schleiden
Germany

CIS-ID: 100063,1127
*/

#include "function.ch"
#include "inkey.ch"
#include "edit_spr.ch"
#include 'chip_mo.ch'

/* nShowRow tells which line is active and has two possible values, 1 or 2 */
/* nShowRow сообщает, какая строка активна и имеет два возможных значения: 1 или 2. */
static nShowRow := 1

function Main
  local oTB, nKey := 0, oCol
  local iStep
  
  f_first()
  
  /* clear screen */
  /* очистим экран */
  scroll()
  /* open database */
  /* открыть БД */
  use _mo_mkb alias DIAG new
  /* draw a frame */
  /* рисуем рамку */
  @ 02, 01 to maxrow() - 2, maxcol() - 2 double
  /* create a TBrowse object, modify it the long way <g> */
  /* URGENT: the browse area must be a multiple of the number of lines
     you will display as a whole! */
  /* создаем объект TBrowse, изменяем его долгим путем <g> */
  /* СРОЧНО: область просмотра должна быть кратной количеству строк
    вы будете отображать в целом! */     
  oTB := TBrowseDB(03, 02, maxrow() - 3, maxcol() - 3)
  oTB:SkipBlock := {|n| Skipper(n) }

  f1_10diag(oTB)

  // oCol := TBColumnNew("Headerline for Multi-Line Browse", {|| ShowBlock() })
  // oTB:addColumn(oCol)
  /* start displaying the browse */
  /* начать отображение обзора */
  while nKey != K_ESC
    dispbegin()                                  // to avoid screen flicker // чтобы избежать мерцания экрана
    while !oTB:stabilize()                       // while highlightening    // при выделении
      /* */                                      // two lines in the browse // две строки в обзоре
    end
    ShowCoord(oTB)                               // do highlightening       // делать выделение
    dispend()
    nKey := inkey(0)
    do case
    case nKey = K_LEFT
      oTB:left()
    case nKey = K_RIGHT
      oTB:right()
    case nKey = K_UP                             // notice:
      for iStep := 1 to DIAG->KOL
        oTB:up()                                   // do up() twice, since  // сделать up() дважды, так как
      next
      // oTB:up()                                   // do up() twice, since
      // oTB:up()                                   // it's a two-line browse // это двухстрочный просмотр
    case nKey = K_DOWN                           // see note for K_UP <g>     // см. примечание для K_UP
      for iStep := 1 to DIAG->KOL
        oTB:down()
      next
      // oTB:down()
      // oTB:down()
    case nKey = K_PGUP
      oTB:PageUp()
    case nKey = K_PGDN
      oTB:PageDown()
    case nKey = K_ESC
    otherwise
      tone(100, 10)
    endcase
  end
  use
  
  f_end()
  
return (Nil)

Function f1_10diag(oBrow)
  Local oColumn, blk, n := 65

  blk := {|| iif(! dateInRange(diag->dbegin,diag->dend), {3,4}, iif(!empty(diag->pol), {5,6}, {1,2})) }
  oColumn := TBColumnNew("Шифр",{|| padr(if(ks==0,shifr+diag->pol,""),7) })
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  oColumn := TBColumnNew(center("Наименование диагнозов заболеваний",n),{||name})
  oColumn:colorBlock := blk
  oBrow:addColumn(oColumn)
  // if uregim > 0
  //   status_key("^<Esc>^ - выход;  ^<F2>^ - поиск по шифру;  ^<F3>^ - поиск по подстроке"+;
  //                             iif(uregim==1,"",";  ^<Enter>^ - выбор"))
  // endif

  return nil
  
******************************************************************************
/* this function displays the values for the two lines. nShowRow tells which
line to display.
*/
/* эта функция отображает значения для двух строк. nShowRow сообщает, какой
строка для отображения.
*/
function ShowBlock
  do case
  case nShowRow = 1
    retu(pad(fieldget(1), 50) + " " + str(recno()))
  case nShowRow = 2
    retu(pad(fieldget(2), 50) + " " + str(recno()))
  endcase
return (space(61))
******************************************************************************
/* this function is for two purposes:
1. help in debugging by showing the value of nShowRow, recno(), bof() and
eof() on the last line of the screen;
2. alter the display so that both of the two lines that belong to a record
are displayed in the highlight color.
*/
/* эта функция предназначена для двух целей:
1. помочь в отладке, показывая значение nShowRow, recno(), bof() и
eof() в последней строке экрана;
2. измените отображение так, чтобы обе строки, принадлежащие записи
отображаются выделенным цветом.
*/
function ShowCoord (oTBO)
  local nTop, nRight, nLeft, nBot
  /* get screen coordinates */
  /* получаем координаты экрана */
  nTop := nBot := oTBO:RowPos
  nRight := oTBO:RightVisible
  nLeft := oTBO:ColPos
  /* clear entire browse area, since the record pointer could have been
     moved, and that could leave a highlightened area that's wrong */
  /* очищаем всю область просмотра, так как указатель записи мог быть
    перемещен, и это может привести к тому, что подсвеченная область окажется неправильной */
  oTBO:ColorRect({1, 1, oTBO:RowCount, oTBO:ColCount}, {1, 2})
  /* check which area is to highlight: */
  /* проверяем, какую область выделить: */
  if nShowRow = 1
    /* browse is on the first line for this record, so highlight it and
       the following line: */
    /* просмотр находится на первой строке этой записи, поэтому выделите его и
      следующая строка: */
    oTBO:ColorRect({nTop    , nLeft, nBot    , nRight}, {2, 1})
    oTBO:ColorRect({nTop + 1, nLeft, nBot + 1, nRight}, {2, 1})
  else
    /* browse is on the second line for this record, so highlight it and
       the previous line: */
    /* просмотр находится на второй строке этой записи, поэтому выделите его и
      предыдущая строка: */
    oTBO:ColorRect({nTop    , nLeft, nBot    , nRight}, {2, 1})
    oTBO:ColorRect({nTop - 1, nLeft, nBot - 1, nRight}, {2, 1})
  endif
  /* debugging code, easier to control as with MrDebug (which is a great
     product also!), can be left out if your familiar with the program: */
  /* код отладки, проще контролировать, как с MrDebug (что отлично
    продукт тоже!), можно не указывать, если вы знакомы с программой: */
  @ maxrow(), 00 say nShowRow pict "#"
  @ maxrow(), 10 say recno()
  @ maxrow(), col() + 2 say bof()
  @ maxrow(), col() + 2 say eof()
return (Nil)
******************************************************************************
/* function to skip one record forward a time. if lNoCount is true, eof() was
reached, and nShowRow has to be corrected.
*/
/* функция для пропуска одной записи вперед за раз. если lNoCount истинно, eof() был
достиг, и nShowRow нужно исправить.
*/
function SkipForw (lNoCount)
  if lNoCount = NIL
    lNoCount := .F.
  endif
  if lNoCount
    nShowRow := 1
  else
    do case
    case nShowRow = 1
      nShowRow ++
    case nShowRow = 2
      nShowRow := 1
      dbSkip()
    otherwise
      nShowRow := 1
    endcase
  endif
return (Nil)
******************************************************************************
/* function to skip one record back a time. if lNoCount is true, bof() was
reached, and nShowRow has to be corrected.
*/
/* функция для пропуска одной записи назад за раз. если lNoCount истинно, bof() был
достиг, и nShowRow нужно исправить.
*/
function SkipBack (lNoCount)
  if lNoCount = NIL
    lNoCount := .F.
  endif
  if lNoCount
    dbSkip(-1)
    nShowRow := 2
  else
    if nShowRow = 1
      dbSkip(-1)
      nShowRow ++
    else
      nShowRow := 1
    endif
  endif
return (Nil)
******************************************************************************
/* this function is taken from the examples for tbrowse that came with the
clipper upgrade to 5.2e. it is modified to let the skipping be done by
SkipForw() or SkipBack() to hold control of the multi-line browse.
*/
/* эта функция взята из примеров для tbrowse, поставляемых с
clipper обновление до 5.2e. он модифицирован, чтобы позволить пропускать
SkipForw() или SkipBack(), чтобы удерживать контроль над многострочным просмотром.
*/
STATIC FUNCTION Skipper( nRequest )
  LOCAL nActually := 0
  IF (nRequest == 0)
    DBSKIP(0)
  ELSEIF (nRequest > 0) .AND. (!EOF())
    WHILE (nActually < nRequest)
      SkipForw()
      IF EOF()
        SkipBack(.T.)
        EXIT
      ENDIF
      nActually++
    END
  ELSEIF (nRequest < 0)
    WHILE (nActually > nRequest)
      SkipBack()
      IF BOF()
        SkipForw(.T.)
        EXIT
      ENDIF
      nActually--
    END
  ENDIF
RETURN (nActually)
******************************************************************************
******************************************************************************