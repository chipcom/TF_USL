
#include "hblibxlsxwriter.ch"

function main_ex(aup) 
  local workbook, header
  local worksheetAdded, worksheetRemoved
  local nfile := 'MKB10.xlsx'
  local sCodepageIN

  lxw_init() 

  if hb_FileExists(nfile)  
    filedelete(nfile)
  endif

  workbook  := lxw_workbook_new('MKB10.xlsx')
  worksheetAdded := lxw_workbook_add_worksheet(workbook, 'added' )
  worksheetRemoved := lxw_workbook_add_worksheet(workbook, 'removed' )

  /* Set up some formatting and text to highlight the panes. */
  header = lxw_workbook_add_format(workbook)
  lxw_format_set_align(header, LXW_ALIGN_CENTER)
  lxw_format_set_align(header, LXW_ALIGN_VERTICAL_CENTER)
  lxw_format_set_fg_color(header, 0xD7E4BC)
  lxw_format_set_bold(header)
  lxw_format_set_border(header, LXW_BORDER_THIN)

  /* Установим цвета закладок. */
  lxw_worksheet_set_tab_color(worksheetRemoved, LXW_COLOR_RED)
  lxw_worksheet_set_tab_color(worksheetAdded, LXW_COLOR_GREEN)

  /* Заморозим верхнюю строку на закладке. */
  lxw_worksheet_freeze_panes(worksheetRemoved, 1, 0)
  lxw_worksheet_freeze_panes(worksheetAdded, 1, 0)


  /* Some worksheet text to demonstrate scrolling. */
  // for col = 0 to 8
  //   // lxw_worksheet_write_string(worksheetRemoved, 0, col, "Scroll down", header)
  //   lxw_worksheet_write_string(worksheetRemoved, 0, col, "Scroll down", nil)
  // next
  lxw_worksheet_write_string(worksheetRemoved, 0, 0, 'МКБ-10', header)
  lxw_worksheet_write_string(worksheetRemoved, 0, 1, 'Наименование диагноза', header)
  lxw_worksheet_write_string(worksheetAdded, 0, 0, 'МКБ-10', header)
  lxw_worksheet_write_string(worksheetAdded, 0, 1, 'Наименование диагноза', header)

  // for row = 1 to 99
  //   for col = 0 to 1 //8
  //     // lxw_worksheet_write_number(worksheet1, row, col, row + 1, center)
  //     lxw_worksheet_write_number(worksheetRemoved, row, col, row + 1, nil)
  //   next
  // next
  for row := 1 to len(aup)
    // add_string(aup[j,1] + " - " + aup[j,2])
    hb_StrToUtf8( aup[row,2], sCodepageIN )
    lxw_worksheet_write_number(worksheetAdded, row, 0, aup[row,1], nil)
    // lxw_worksheet_write_number(worksheetAdded, row, 1, sCodepageIN, nil)
  next


  // lxw_worksheet_write_string(worksheet, 0, 0, "Hello", NIL)
  // lxw_worksheet_write_number(worksheet, 1, 0, 123, NIL)

  lxw_workbook_close(workbook)
  return 0
