# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$(document).ready ->
  t = $('#sortableTable').DataTable(
    'lengthMenu': [ 
      [25, 50, -1], [25, 50, "All"]
     ]
    'order': [ [
      4 
      'desc'
    ] ]
    'language' : 
      'lengthMenu' : '表示件数 _MENU_'
      'zeroRecords': 'データが見つかりませんでした．'
      'info': '_PAGE_ / _PAGES_'
      'infoEmpty': '結果なし' 
    )
  t.on('order.dt search.dt', ->
    t.column(0,
      search: 'applied'
      order: 'applied').nodes().each (cell, i) ->
      cell.innerHTML = i + 1
      return
    return
  ).draw()

$(document).ready ->
  t = $('#sortableTable2').DataTable(
    'lengthMenu': [ 
      [25, 50, -1], [25, 50, "All"]
     ]
    'order': [ [
      4 
      'desc'
    ] ]
    'language' : 
      'lengthMenu' : '表示件数 _MENU_'
      'zeroRecords': 'データが見つかりませんでした．'
      'info': '_PAGE_ / _PAGES_'
      'infoEmpty': '結果なし' 
    )
  t.on('order.dt search.dt', ->
    t.column(0,
      search: 'applied'
      order: 'applied').nodes().each (cell, i) ->
      cell.innerHTML = i + 1
      return
    return
  ).draw()


