#include "function.ch"
#include "edit_spr.ch"

Static skod_volg := "18-4"
// УРОВЕНЬ-1 Ter (C-2) код территории
// Начало территории 18-000-000-000-1 - Наименоание территорий

// УРОВЕНЬ-2 РАЙОН ИЛИ ГОРОД областного подчинения
// Kod1 2XX-000-000-1 РАЙОН 200- шапка
// KOD1 4XX-000-000-1 ГОРОД 400- шапка
// 110-170 - автономные округа
// 200     - районы
// 400     - города
// 500-550 - города федерального подчинения
// фролово           18-428-000-000-1 ниже нет
// УРОВЕНЬ-3 (если есть)
// внутри городов (обл подчинения только РАЙОНЫ)
// KOD2 -ХХХ
// первая цифра в порядке kod2-не нужна
// центральный (в-д) 18-401-395-000-1
// для Районов области - сельсоветы.
//
// 5xx - ПОДЧИНЕННЫЕ ГОРОДА (ПОСЁЛКИ)



external errorsys

***** инициализация всех БД адресного реестра
Function main()
Local region := ; //  (регион)
  {;
   {"OKATO"  ,    "C",      2,      0},;   // идентификатор региона
   {"name",       "C",     72,      0};    // краткое наименование
  }
Local region1 := ; //  (регион)
  {;
   {"OKATO"  ,    "C",      2,      0},;   // идентификатор региона
   {"name",       "C",     72,      0},;    // краткое наименование
   {"kol",        "N",      5,      0};
  }
//
Local rajon := ; //  (район)
  {;
   {"OKATO"  ,    "C",      5,      0},;   // идентификатор региона обласной город/район области
   {"name",       "C",     72,      0},;   // краткое наименование
   {"fl_vibor",   "N",      1,      0},;   // 1-конец выбора
   {"fl_zagol",   "N",      1,      0},;   // 1-заголовок
   {"tip",        "N",      1,      0},;   // 1-округ/2-район/3-город/4-город фед
   {"selo",       "N",      1,      0};    // 0-село/1-город
   }
Local selsov := ; //  (район)
  {;
   {"OKATO"  ,    "C",     11,      0},;   // идентификатор региона
   {"name",       "C",     72,      0},;   // краткое наименование
   {"fl_vibor",   "N",      1,      0},;   // 1-конец выбора
   {"fl_zagol",   "N",      1,      0},;   // 1-заголовок
   {"tip",        "N",      1,      0},;   // 1-округ/2-район/3-город/4-город фед
   {"selo",       "N",      1,      0},;    // 0-село/1-город
   {"fl_n",       "N",      1,      0};
   }
//   {"name_f",     "C",    250,      0},;   // полное наименование


f_first()
Public sys_date := date()
cls

use okato new alias OKATO
go top
do while !eof()
  if alltrim(okato->kod1) == "0"
    rlock()
    okato->kod1 := "000"
    unlock
  endif
 if alltrim(okato->kod2) == "0"
    rlock()
    okato->kod2 := "000"
    unlock
  endif
 if alltrim(okato->kod3) == "0"
    rlock()
    okato->kod3 := "000"
    unlock
  endif

  if len(alltrim(okato->kod3)) < 3
    rlock()
    okato->kod3 := padl(alltrim(okato->kod3),3,"0")
    unlock
  endif
  if len(alltrim(okato->ter)) < 2
    rlock()
    okato->ter := padl(alltrim(okato->ter),2,"0")
    unlock
  endif

  select OKATO
  skip
enddo
close databases
iii := 0
//use okato new alias OKATO
//
//use okato1 new alias OKATO1
//
//выполняем добавление и изменение из okato1
/*select okato
index on ter+kod1+kod2+kod3 to tmp1
select OKATO1
go top
do while !eof()
  t_poisk := okato1->ter+okato1->kod1+okato1->kod2+okato1->kod3
  select OKATO
  find (t_poisk)
  if !found()
    @ 19,1 say iii
    iii++
    append blank
    okato->ter  := okato1->ter
    okato->kod1 := okato1->kod1
    okato->kod2 := okato1->kod2
    okato->kod3 := okato1->kod3
    okato->razdel := okato1->razdel
    okato->name1  := okato1->name1
  endif
  //rlock()
  //okato->razdel := okato1->razdel
  //okato->name1  := okato1->name1
  //unlock
  select OKATO1
  skip
enddo

*/
//close databases
//
reconstruct("_okatod",region1,,,.t.)
//
reconstruct("_okator",region,,,.t.)
//
reconstruct("_okatoo",rajon,,,.t.)
reconstruct("_okatoo8",rajon,,,.t.)
//
reconstruct("_okatos",selsov,,,.t.)
reconstruct("_okatos8",selsov,,,.t.)
//
use okato new alias OKATO
//
use _okatoR new alias REGION
//
select OKATO
go top
do while !eof()
  @ 20,1 say "РЕГИОНЫ  "+str(recno()/lastrec()*100,6,2)+" %"
  if okato->kod1=="000" .and.;
     okato->kod2=="000" .and.;
     okato->kod3=="000" .and.;
      alltrim(okato->razdel) == "1"
    select REGION
    append blank
    region->okato  := okato->ter
    //region->name_f := charrem("/",okato->name1)
    region->name   := padr(charrem("/",okato->name1),72)
  endif
  select OKATO
  skip
enddo
//
//quit
//
use _okatoo new alias RAJON
use _okatoo8 new alias RAJON8
//
select OKATO
go top
do while !eof()
  @ 21,1 say "РАЙОНЫ  "+str(recno()/lastrec()*100,6,2)+" %"
  if okato->kod2=="000" .and.;
     okato->kod3=="000"  .and.;
     alltrim(okato->razdel) == "1" .and.;
     okato->kod1 != "000"
    select RAJON
    append blank
    rajon->okato  := okato->ter+okato->kod1
    //rajon->name_f := charrem("/",okato->name1)
    rajon->name   := padr(charrem("/",okato->name1),72)
    if eq_any(alltrim(okato->kod1),"110","120","130","140","150","170","200",;
                        "400" ,"500","550")
      rajon->fl_zagol := 1
    endif
    if val(okato->kod1) < 200     // округа
      rajon->tip := 1
    elseif val(okato->kod1) < 400 // районы
      rajon->tip := 2
    elseif val(okato->kod1) < 500 // города пос гор типа
      rajon->tip := 3
      // ВЫЯСНЯЕМ ВОЗМОЖНОСТЬ ВЫБОРА
      t := okato->kod1
      select OKATO
      skip
      if okato->kod1 == t .and. val(okato->kod2) > 500
        //у города есть подчинённые нас. пункты
        rajon->fl_vibor := 2
      elseif okato->kod1 != t
        //выбор только города
        rajon->fl_vibor := 1
      endif
      select OKATO
      skip -1
    elseif val(okato->kod1) < 500 // города пос гор типа
      rajon->tip := 3
      // ВЫЯСНЯЕМ ВОЗМОЖНОСТЬ ВЫБОРА
      t := okato->kod1
      select OKATO
      skip
      if okato->kod1 == t .and. val(okato->kod2) > 500
        //у города есть подчинённые нас. пункты
        rajon->fl_vibor := 2
      elseif okato->kod1 != t
        //выбор только города
        rajon->fl_vibor := 1
      endif
      select OKATO
      skip -1

    else                          //федеральные города
      rajon->tip := 4
    endif
    if val(okato->kod1) < 200     // округа
      rajon->selo := 0
    elseif val(okato->kod1) < 400 // районы
      rajon->selo := 0
    elseif val(okato->kod1) < 500 // пос гор типа
      rajon->selo := 1
    else                          // федеральные города
      rajon->selo := 1
    endif
    if okato->ter == "18"
      select RAJON8
      append blank
      rajon8->okato    := rajon->okato
      //rajon8->name_f   := rajon->name_f
      rajon8->name     := rajon->name
      rajon8->fl_zagol := rajon->fl_zagol
      rajon8->fl_vibor := rajon->fl_vibor
      rajon8->tip      := rajon->tip
      rajon8->SELO     := rajon->selo
    endif
  endif
  select OKATO
  skip
enddo
//
use _okatos new alias SELO
use _okatos8 new alias SELO8
//
select OKATO
go top
do while !eof()
  @ 22,1 say str(recno()/lastrec()*100,6,2)+" %"
  if okato->kod2 !="000" .and. okato->kod1 != "000"
    if okato->kod3 != "000" .or.(okato->kod3 == "000" .and. alltrim(okato->razdel) == "1";
       .and. val(okato->kod2)<600).or.(okato->kod3 == "000" .and. alltrim(okato->razdel) == "1";
       .and. val(okato->kod2)==800)
      //(val(okato->kod2)>500.and.val(okato->kod2)<600))
      select SELO
      append blank
      selo->okato    := okato->ter+okato->kod1+okato->kod2+okato->kod3
      if val(okato->kod2)==800
        selo->name     := padr(atrepl("Сельсоветы",charrem("/",okato->name1),"Населённые пункты"),60)
      else
        //selo->name     := padr(charrem("/",okato->name1),72)
        selo->name     := alltrim(charrem("/",okato->name1))+iif(len(alltrim(okato->centrum))> 2 ,"/"+alltrim(okato->centrum),"")
      endif
      selo->fl_vibor := 1
      if eq_any(okato->kod2,"360","500","550","600","800")
         selo->fl_zagol := 1
      endif
      if val(okato->kod1) < 200     // округа
        selo->tip := 1
      elseif val(okato->kod1) < 400 // районы
        selo->tip := 2
      elseif val(okato->kod1) < 500 // города пос гор типа
        selo->tip := 3
      else                          // федеральные города
        selo->tip := 4
      endif
      if val(okato->kod1) < 200     // округа
        selo->selo := 0
      elseif val(okato->kod1) < 400 // районы
        selo->selo := 0
      elseif val(okato->kod1) < 500 // города пос гор типа
        selo->selo := 1
      else                          // федеральные города
        selo->selo := 1
      endif
      if selo->selo == 0  //selo
        if val(okato->kod2) > 500 .and. val(okato->kod2) < 600
          selo->selo := 1
        endif
      endif
      if okato->ter == "18"
        select SELO8
        append blank
        selo8->okato    := selo->okato
        selo8->name     := selo->name
        selo8->fl_zagol := selo->fl_zagol
        selo8->fl_vibor := selo->fl_vibor
        selo8->selo     := selo->selo
      endif
    endif
  endif
  select OKATO
  skip
enddo
// сверяем насел пункты с предыдущей версией
region->(dbclosearea())
use _okatod new alias REGION
//
select OKATO
go top
do while !eof()
  @ 23,1 say str(recno()/lastrec()*100,6,2)+" %"
  if okato->kod1=="000".and. okato->kod2=="000" .and.;
     okato->kod3=="000" .and. okato->razdel == "1"
    select REGION
    append blank
    region->okato  := okato->ter
    region->name   := padr(charrem("/",okato->name1),72)
  endif
  select OKATO
  skip
enddo
select OKATO

close databases
//
use _okatoR new alias REGION
index on okato to tmp22
find ("55")
if !found()
  append blank
  region->okato := "55"
  region->name  := "г.Байконур"
endif
close databases
//
/*use _okatod new alias SELON
index on okato to tmp2
use _okatos new alias SELO
use _okatoso new alias SELOO
index on okato to tmp1
select SELO
go top
do while !eof()
  @ 23,20 say str(recno()/lastrec()*100,6,2)+" %"
  t_poisk := selo->okato
  select SELOO
  find (t_poisk)
  if !found()
    select SELON
    find(substr(selo->okato,1,2))
    rlock()
    selon->kol := selon->kol+1
    unlock
  endif
  select SELO
  skip
enddo
*/
close databases

use _okatos new alias SELO
index on okato to tmp2
use _okato new alias SELOO
select SELOO
go top
do while !eof()
  select selo
  find(SELOO->ter+SELOO->kod1+SELOO->kod2+SELOO->kod3)
  if !found()
    rlock()
    seloo->fl_n := 1
    unlock
  endif   
  select SELOO
  skip
enddo
return NIL
