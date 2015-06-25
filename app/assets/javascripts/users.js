$(document).ready(function() {
  return $('#sTable').dataTable({
    'pagingType': 'full_numbers'
  });
});

$(document).ready(function() {
  var t;
  t = $('#sortableTable').DataTable({
    'lengthMenu': [[25, 50, -1], [25, 50, "All"]],
    'order': [[4, 'desc']],
    'language': {
      'lengthMenu': '表示件数 _MENU_',
      'zeroRecords': 'データが見つかりませんでした．',
      'info': '_PAGE_ / _PAGES_',
      'infoEmpty': '結果なし'
    }
  });
  return t.on('order.dt search.dt', function() {
    t.column(0, {
      search: 'applied',
      order: 'applied'
    }).nodes().each(function(cell, i) {
      cell.innerHTML = i + 1;
    });
  }).draw();
});

$(document).ready(function() {
  var t;
  t = $('#sortableTable2').DataTable({
    'lengthMenu': [[25, 50, -1], [25, 50, "All"]],
    'order': [[4, 'desc']],
    'language': {
      'lengthMenu': '表示件数 _MENU_',
      'zeroRecords': 'データが見つかりませんでした．',
      'info': '_PAGE_ / _PAGES_',
      'infoEmpty': '結果なし'
    }
  });
  return t.on('order.dt search.dt', function() {
    t.column(0, {
      search: 'applied',
      order: 'applied'
    }).nodes().each(function(cell, i) {
      cell.innerHTML = i + 1;
    });
  }).draw();
});

