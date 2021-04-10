
#include "hblibxlsxwriter.ch"

function WriteToExcel(aAdded, aRemoved)
  local workbook, header
  local worksheetAdded, worksheetRemoved
  local nfile := 'MKB10.xlsx'
  local sCode := 'МКБ-10', sName := 'Наименование диагноза'
  local merge_format, merge_cell_name_format
  local cell_code_format

  lxw_init() 

  if hb_FileExists(nfile)  
    filedelete(nfile)
  endif

  workbook  := lxw_workbook_new('MKB10.xlsx')
  worksheetAdded := lxw_workbook_add_worksheet(workbook, 'добавлены' )
  worksheetRemoved := lxw_workbook_add_worksheet(workbook, 'удалены' )

  /* Set up some formatting and text to highlight the panes. */
  header = lxw_workbook_add_format(workbook)
  lxw_format_set_align(header, LXW_ALIGN_CENTER)
  lxw_format_set_align(header, LXW_ALIGN_VERTICAL_CENTER)
  lxw_format_set_fg_color(header, 0xD7E4BC)
  lxw_format_set_bold(header)
  lxw_format_set_border(header, LXW_BORDER_THIN)

  cell_code_format = lxw_workbook_add_format(workbook)
  lxw_format_set_border(cell_code_format, LXW_BORDER_THIN)
  lxw_format_set_bold(cell_code_format)
  lxw_format_set_font_size(cell_code_format, 13)

  merge_format := lxw_workbook_add_format(workbook)
  /* Configure a format for the merged range. */
  lxw_format_set_align(merge_format, LXW_ALIGN_CENTER)
  lxw_format_set_align(merge_format, LXW_ALIGN_VERTICAL_CENTER)
  lxw_format_set_bold(merge_format)
  lxw_format_set_font_size(merge_format, 14)
  lxw_format_set_bg_color(merge_format, LXW_COLOR_YELLOW)
  lxw_format_set_border(merge_format, LXW_BORDER_THIN)

  merge_cell_name_format := lxw_workbook_add_format(workbook)
  /* Configure a format for the merged range. */
  // lxw_format_set_align(merge_cell_name_format, LXW_ALIGN_CENTER)
  lxw_format_set_align(merge_cell_name_format, LXW_ALIGN_VERTICAL_CENTER)
  // lxw_format_set_bold(merge_cell_name_format)
  lxw_format_set_font_size(merge_cell_name_format, 13)
  // lxw_format_set_bg_color(merge_cell_name_format, LXW_COLOR_YELLOW)
  lxw_format_set_border(merge_cell_name_format, LXW_BORDER_THIN)

  merge_cell_code_format := lxw_workbook_add_format(workbook)
  /* Configure a format for the merged range. */
  // lxw_format_set_align(merge_cell_code_format, LXW_ALIGN_CENTER)
  lxw_format_set_align(merge_cell_code_format, LXW_ALIGN_VERTICAL_CENTER)
  // lxw_format_set_bg_color(merge_cell_code_format, LXW_COLOR_YELLOW)
  lxw_format_set_border(merge_cell_code_format, LXW_BORDER_THIN)

  /* Установим цвета закладок. */
  lxw_worksheet_set_tab_color(worksheetRemoved, LXW_COLOR_RED)
  lxw_worksheet_set_tab_color(worksheetAdded, LXW_COLOR_GREEN)

  /* Объединить 2 ячейки одной колонки и две строки. */
  lxw_worksheet_merge_range(worksheetRemoved, 0, 0, 1, 0, sCode, merge_format)
  /* Объединить 18 ячейки  две строки. */
  lxw_worksheet_merge_range(worksheetRemoved, 0, 1, 1, 18, sName, merge_format)

  /* Объединить 2 ячейки одной колонки и две строки. */
  lxw_worksheet_merge_range(worksheetAdded, 0, 0, 1, 0, sCode, merge_format)
  /* Объединить 18 ячейки  две строки. */
  lxw_worksheet_merge_range(worksheetAdded, 0, 1, 1, 18, sName, merge_format)

  /* Установить ширину первой колонки */
  lxw_worksheet_set_column(worksheetRemoved, 0, 0, 10.0)
  lxw_worksheet_set_column(worksheetAdded, 0, 0, 10.0)

  /* Заморозим 2-е верхние строки на закладке. */
  lxw_worksheet_freeze_panes(worksheetRemoved, 2, 0)
  lxw_worksheet_freeze_panes(worksheetAdded, 2, 0)

  for row := 1 to len(aAdded)
    lxw_worksheet_write_string(worksheetAdded, row+1, 0, alltrim(aAdded[row,1]), cell_code_format)
    lxw_worksheet_merge_range(worksheetAdded, row+1, 1, row+1, 18, hb_StrToUtf8( aAdded[row,2] ), merge_cell_name_format)
  next

  for row := 1 to len(aRemoved)
    lxw_worksheet_write_string(worksheetRemoved, row+1, 0, alltrim(aRemoved[row,1]), cell_code_format)
    lxw_worksheet_merge_range(worksheetRemoved, row+1, 1, row+1, 18, hb_StrToUtf8( aRemoved[row,2] ), merge_cell_name_format)
  next
  
  return lxw_workbook_close(workbook)
