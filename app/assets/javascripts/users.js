$(document).ready(function() {
  return $('#sTable').dataTable({
    'bDeferRender': true,
    'pagingType': 'full_numbers',
    'lengthMenu': [[100,200,500, -1], [100,200,500, "All"]],
    'order': [[4, 'desc']],
     "language" : {
         "sProcessing":   "処理中...",
         "sLengthMenu":   "_MENU_ 件表示",
         "sZeroRecords":  "データはありません。",
         "sInfo":         "_START_件～_END_件を表示（全_TOTAL_ 件中）",
         "sInfoEmpty":    " 0 件中 0 から 0 まで表示",
         "sInfoFiltered": "（全 _MAX_ 件より抽出）",
         "sInfoPostFix":  "",
         "sSearch":       "検索フィルター:",
         "sUrl":          "",
         "oPaginate": {
             "sFirst":    "先頭",
             "sPrevious": "前ページ",
             "sNext":     "次ページ",
             "sLast":     "最終"
         }}
  });
});

$(document).ready(function() {
  var t;
  t = $('#sortableTable').DataTable({
        "bJQueryUI": false,
        "bScrollCollapse": true,
        "bPaginate": false,  
        "bInfo": false,  
        "bFilter": true,
        "bSortClasses": false,// ソート行を強調（cssクラスを指定）するかを設定
//        "aoColumns" : [
//            { sWidth: '50px' },
//            { sWidth: '200px' },
//            { sWidth: '120px' },
//            { sWidth: '100px' },
//            { sWidth: '100px' },
//            { sWidth: '100px' },
//            { sWidth: '300px' }
//        ],
    'lengthMenu': [[25, 50, -1], [25, 50, "All"]],
    'order': [[4, 'desc']],
     "language" : {
         "sProcessing":   "処理中...",
         "sLengthMenu":   "_MENU_ 件表示",
         "sZeroRecords":  "データはありません。",
         "sInfo":         "_START_件～_END_件を表示（全_TOTAL_ 件中）",
         "sInfoEmpty":    " 0 件中 0 から 0 まで表示",
         "sInfoFiltered": "（全 _MAX_ 件より抽出）",
         "sInfoPostFix":  "",
         "sSearch":       "検索フィルター:",
         "sUrl":          "",
         "oPaginate": {
             "sFirst":    "先頭",
             "sPrevious": "前ページ",
             "sNext":     "次ページ",
             "sLast":     "最終"
         }}
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
        "bJQueryUI": false,
        "bScrollCollapse": true,
        "bPaginate": false,  
        "bInfo": false,  
        "bFilter": true,
        "bSortClasses": false,// ソート行を強調（cssクラスを指定）するかを設定
    'lengthMenu': [[25, 50, -1], [25, 50, "All"]],
    'order': [[4, 'desc']],
     "language" : {
         "sProcessing":   "処理中...",
         "sLengthMenu":   "_MENU_ 件表示",
         "sZeroRecords":  "データはありません。",
         "sInfo":         "_START_件～_END_件を表示（全_TOTAL_ 件中）",
         "sInfoEmpty":    " 0 件中 0 から 0 まで表示",
         "sInfoFiltered": "（全 _MAX_ 件より抽出）",
         "sInfoPostFix":  "",
         "sSearch":       "検索フィルター:",
         "sUrl":          "",
         "oPaginate": {
             "sFirst":    "先頭",
             "sPrevious": "前ページ",
             "sNext":     "次ページ",
             "sLast":     "最終"
         }}
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

