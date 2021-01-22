// переменные, используемые внутри ф-ии F_EDIT_SPR
#define A__NAME     1
#define A__TYPE     2
#define A__LEN      3
#define A__DEC      4
#define A__PICTURE  5
#define A__BLOCK    6
#define A__INIT     7
#define A__FIND     8
#define A__SAY      9
#define A__VALID   10
#define A__WHEN    11

// переменные для ф-ии F_EDIT_SPR
#define A__VIEW     1
#define A__EDIT     2
#define A__APPEND   3
#define A__DELETE   4

// переменные для ф-ии MENU_READER
#define A__MENUHORIZ    0  // горизонтаьное меню из массива
#define A__MENUVERT     1  // вертикальное меню из массива
#define A__MENUBIT      2  // битовое меню
#define A__POPUPBASE    3  // меню из БД - добавление и возврат кода
                           // и по пробелу возврат {0,""}
#define A__POPUPBASE1  31  // меню из БД - добавление и возврат кода
#define A__POPUPEDIT    4  // меню из БД - возврат кода
                           // и по пробелу возврат {0,""}
#define A__FUNCTION     5  // вызов функции через блок кода
#define A__POPUPMENU    6  // меню из БД - просто возврат кода (как из popup)

// переменные для ф-ии popup_edit (__regim_edit)
#define PE_EDIT       1 // (или по умолчанию) - добавление, ред-ие и удаление
#define PE_APP_SPACE  2 // добавление и возврат кода и по пробелу возврат {0,""}
#define PE_APP      2.5 // добавление и возврат кода
#define PE_SPACE      3 // возврат кода и по пробелу возврат {0,""}
                        // (в режиме редактирования f_edit_spr)
#define PE_RETURN     4 // просто возврат кода (как из popup)
#define PE_VIEW       5 // просмотр

// макрос, используемый внутри ф-ии F_EDIT_SPR
#xtranslate is_element(<mas>,<n>) => ;
         if(valtype(<mas>) == "A" .and. len(<mas>) >= <n>, <mas>\[<n>], NIL)

// переменные, используемые внутри ф-ии EDIT_BROWSE
#define BR_TOP              1   // |
#define BR_BOTTOM           2   // |
#define BR_LEFT             3   // |
#define BR_RIGHT            4   // габариты окна
#define BR_OPEN             5   // блок кода для открытия БД
#define BR_CLOSE            6   // блок кода для закрытия БД
#define BR_SEMAPHORE        7   // строка семафора (если необходимо)
#define BR_COLOR            8   // цвет TBrowse
#define BR_TITUL            9   // заголовок
#define BR_TITUL_COLOR     10   // цвет заголовка
#define BR_FL_INDEX        11   // проиндексирована ли БД по алфавиту
#define BR_FL_NOCLEAR      12   // восстанавливать ли экран
#define BR_ARR_BLOCK       13   // массив блоков кода (Top, Bottom, Skip)
#define BR_STEP_FUNC       14   // блок кода, выполняемый на каждом шаге
#define BR_ARR_MOUSE       15   // массив областей для мыши
#define BR_ARR_BROWSE      16   // массив других параметров для TBrowse
#define BR_COLUMN          17   // массив (по 4 эл-та) для столбцов
#define BR_STAT_MSG        18   // блок кода - после отрисовки TBrowse
#define BR_EDIT            19   // блок кода для редактирования
#define BR_ENTER           20   // блок кода - после нажатия ENTER в меню
#define BR_FREEZE          21   // количество замороженных столбцов
#define BR_LEN             21   // общая длина массива

// переменные, используемые внутри ф-ии EDIT_U_SPR
#define US_TOP              1   // "N" |
#define US_BOTTOM           2   // "N" |
#define US_LEFT             3   // "N" |
#define US_RIGHT            4   // "N" габариты окна
#define US_BASE             5   // "C" имя БД
#define US_SEMAPHORE        6   // "C" строка семафора (если необходимо)
#define US_COLOR            7   // "C" цвет TBrowse
#define US_TITUL            8   // "C" заголовок
#define US_TITUL_COLOR      9   // "C" цвет заголовка
#define US_FL_INDEX        10   // "L" проиндексирована ли БД по алфавиту
#define US_ARR_BROWSE      11   // массив других параметров для TBrowse
#define US_COLUMN          12   // "A" (по 4 эл-та) для столбцов
#define US_EDIT_SPR        13   // "A" массив переменных для редактирования
#define US_BLK_DEL         14   // "B" проверка на удаление
#define US_BLK_DUBL        15   // "B" удаление дубликатов в других БД
#define US_ADD_MENU        16   // "A" массив добавочных меню {{pmt,msg,fun},...}
#define US_IM_PADEG        17   // "C" именительный падеж
#define US_ROD_PADEG       18   // "C" родительный падеж
#define US_FUNC_INPUT      19   // "C" имя ф-ии для выборки строки
#define US_BLK_INDEX       20   // блок кода для индексирования БД
#define US_BLK_FILTER      21   // блок кода фильтрации БД
#define US_BLK_WRITE       22   // блок кода для записи других полей
#define US_LEN             22   // общая длина массива
