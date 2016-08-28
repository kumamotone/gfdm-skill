$(function () {
    $(".1000").css("color", "#ff9");
    $(".2000").css("color", "#ff0");
    $(".2500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#ff0", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".3000").css("color", "#3f0");
    $(".3500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#3f0", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".4000").css("color", "#36f");
    $(".4500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#36f", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".5000").css("color", "#f0f");
    $(".5500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#f0f", "#fff"],
        dir: "y" // direction. x or y
    });

    $(".6000").css("color", "#f00");
    $(".6500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#f00", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".7000").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#d84", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".7500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#c0c0c0", "#fff"],
        dir: "y" // direction. x or y
    });
    $(".8000").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#ffd700", "#fff"],
        dir: "y" // direction. x or y
    });

    $(".8500").pxgradient({ // any jQuery selector
        step: 2,
        colors: ["#fc0", "#0fc", "#00f"], // hex (#4fc05a or #333)
        dir: "y" // direction. x or y
    });
});

$(function () {
    $(".c1000").css("color", "#ff9");
    $(".c2000").css("color", "#ff0");
    $(".c2500").css("color", "#ff8");
    $(".c3000").css("color", "#3f0");
    $(".c3500").css("color", "#3f8");
    $(".c4000").css("color", "#36f");
    $(".c4500").css("color", "#6bf");
    $(".c5000").css("color", "#f0f");
    $(".c5500").css("color", "#f8f");
    $(".c6000").css("color", "#f00");
    $(".c6500").css("color", "#f88");
    $(".c7000").css("color", "#d84");
    $(".c7500").css("color", "#c0c0c0");
    $(".c8000").css("color", "#ffd700");
    $(".c8500").css("color", "#0ff");
});

$(document).ready(function () {
    return $('#sTable').dataTable({
        'bDeferRender': true,
        //"bProcessing": true,
        //"bServerSide": true,
        'pagingType': 'full_numbers',
        "bSortClasses": false,// ソート行を強調（cssクラスを指定）するかを設定
        'lengthMenu': [[100, 200, 500, -1], [100, 200, 500, "All"]],
        "bProcessing": true,
        //"bServerSide": true,
        "sAjaxSource": "api/userlist",
        "sServerMethod": "GET",
        "sAjaxDataProp": "users",
        "fnServerData": function (sSource, aoData, fnCallback) {
            $.getJSON(sSource, aoData, function (json) {
                $(json.users).each(function () {
                    var fontColor = "#fff";
                    if (Math.max(this[2], this[3]) < 2000) {
                        fontColor = "#ff9";
                    } else if (Math.max(this[2], this[3]) < 2500) {
                        fontColor = "#ff0";
                    } else if (Math.max(this[2], this[3]) < 3000) {
                        fontColor = "#ff8";
                    } else if (Math.max(this[2], this[3]) < 3500) {
                        fontColor = "#3f0";
                    } else if (Math.max(this[2], this[3]) < 5000) {
                        fontColor = "#3f8";
                    } else if (Math.max(this[2], this[3]) < 4500) {
                        fontColor = "#36f";
                    } else if (Math.max(this[2], this[3]) < 5000) {
                        fontColor = "#6bf";
                    } else if (Math.max(this[2], this[3]) < 5500) {
                        fontColor = "#f8f";
                    } else if (Math.max(this[2], this[3]) < 6000) {
                        fontColor = "#f00";
                    } else if (Math.max(this[2], this[3]) < 6500) {
                        fontColor = "#ff0";
                    } else if (Math.max(this[2], this[3]) < 7000) {
                        fontColor = "#f88";
                    } else if (Math.max(this[2], this[3]) < 7500) {
                        fontColor = "#d84";
                    } else if (Math.max(this[2], this[3]) < 8000) {
                        fontColor = "#c0c0c0";
                    } else if (Math.max(this[2], this[3]) < 8500) {
                        fontColor = "#ffd700";
                    } else if (Math.max(this[2], this[3]) > 8500) {
                        fontColor = "#0ff";
                    }

                    this[1] = '<a href="users/' + this[0] + '" target="_blank" >' + this[1].fontcolor(fontColor) + '</a>'
                });

                $(json.users).each(function () {
                    var fontColor = "#fff";
                    if (this[2] < 2000) {
                        fontColor = "#ff9";
                    } else if (this[2] < 2500) {
                        fontColor = "#ff0";
                    } else if (this[2] < 3000) {
                        fontColor = "#ff8";
                    } else if (this[2] < 3500) {
                        fontColor = "#3f0";
                    } else if (this[2] < 5000) {
                        fontColor = "#3f8";
                    } else if (this[2] < 4500) {
                        fontColor = "#36f";
                    } else if (this[2] < 5000) {
                        fontColor = "#6bf";
                    } else if (this[2] < 5500) {
                        fontColor = "#f8f";
                    } else if (this[2] < 6000) {
                        fontColor = "#f00";
                    } else if (this[2] < 6500) {
                        fontColor = "#ff0";
                    } else if (this[2] < 7000) {
                        fontColor = "#f88";
                    } else if (this[2] < 7500) {
                        fontColor = "#d84";
                    } else if (this[2] < 8000) {
                        fontColor = "#c0c0c0";
                    } else if (this[2] < 8500) {
                        fontColor = "#ffd700";
                    } else if (this[2] > 8500) {
                        fontColor = "#0ff";
                    }

                    if (this[2] != "0.00") {
                        this[2] = '<a href="users/' + this[0] + '/drum" target="_blank" >' + this[2].toFixed(2).fontcolor(fontColor) + '</a>'
                    } else {
                        this[2] = "";
                    }
                });
                $(json.users).each(function () {
                    var fontColor = "#fff";
                    if (this[3] < 2000) {
                        fontColor = "#ff9";
                    } else if (this[3] < 2500) {
                        fontColor = "#ff0";
                    } else if (this[3] < 3000) {
                        fontColor = "#ff8";
                    } else if (this[3] < 3500) {
                        fontColor = "#3f0";
                    } else if (this[3] < 5000) {
                        fontColor = "#3f8";
                    } else if (this[3] < 4500) {
                        fontColor = "#36f";
                    } else if (this[3] < 5000) {
                        fontColor = "#6bf";
                    } else if (this[3] < 5500) {
                        fontColor = "#f8f";
                    } else if (this[3] < 6000) {
                        fontColor = "#f00";
                    } else if (this[3] < 6500) {
                        fontColor = "#ff0";
                    } else if (this[3] < 7000) {
                        fontColor = "#f88";
                    } else if (this[3] < 7500) {
                        fontColor = "#d84";
                    } else if (this[3] < 8000) {
                        fontColor = "#c0c0c0";
                    } else if (this[3] < 8500) {
                        fontColor = "#ffd700";
                    } else if (this[3] > 8500) {
                        fontColor = "#0ff";
                    }

                    if (this[3] != "0.00") {
                        this[3] = '<a href="users/' + this[0] + '/guitar" target="_blank" >' + this[3].toFixed(2).fontcolor(fontColor) + '</a>';
                    } else {
                        this[3] = "";
                    }
                });
                fnCallback(json);
            });
        },
        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
            $(nRow).addClass("black");
        },


        'order': [[4, 'desc']],
        "language": {
            "sProcessing": "処理中...",
            "sLengthMenu": "_MENU_ 件表示",
            "sZeroRecords": "データはありません。",
            "sInfo": "_START_件～_END_件を表示（全_TOTAL_ 件中）",
            "sInfoEmpty": " 0 件中 0 から 0 まで表示",
            "sInfoFiltered": "（全 _MAX_ 件より抽出）",
            "sInfoPostFix": "",
            "sSearch": "検索フィルター:",
            "sUrl": "",
            "oPaginate": {
                "sFirst": "先頭",
                "sPrevious": "前ページ",
                "sNext": "次ページ",
                "sLast": "最終"
            }
        }
    });
});

$(document).ready(function () {
    var t;
    t = $('#sortableTable').DataTable({
        "bJQueryUI": false,
        "bScrollCollapse": true,
        "bPaginate": false,
        "bInfo": false,
        "bFilter": true,
        "bSortClasses": false,// ソート行を強調（cssクラスを指定）するかを設定
        "columnDefs": [{"type": "currency", "targets": 3}],
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
        "language": {
            "sProcessing": "処理中...",
            "sLengthMenu": "_MENU_ 件表示",
            "sZeroRecords": "データはありません。",
            "sInfo": "_START_件～_END_件を表示（全_TOTAL_ 件中）",
            "sInfoEmpty": " 0 件中 0 から 0 まで表示",
            "sInfoFiltered": "（全 _MAX_ 件より抽出）",
            "sInfoPostFix": "",
            "sSearch": "検索フィルター:",
            "sUrl": "",
            "oPaginate": {
                "sFirst": "先頭",
                "sPrevious": "前ページ",
                "sNext": "次ページ",
                "sLast": "最終"
            }
        }
    });
    return t.on('order.dt search.dt', function () {
        t.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            if (i < 25) {
                cell.innerHTML = "<span style=color:red;font-weight:bold>" + (i + 1) + "</span>";
            } else {
                cell.innerHTML = i + 1;
            }
        });
    }).draw();
});

$(document).ready(function () {
    var t;
    t = $('#sortableTable2').DataTable({
        "bJQueryUI": false,
        "bScrollCollapse": true,
        "bPaginate": false,
        "bInfo": false,
        "bFilter": true,
        "bSortClasses": false,// ソート行を強調（cssクラスを指定）するかを設定
        "columnDefs": [{"type": "currency", "targets": 3}],
        'lengthMenu': [[25, 50, -1], [25, 50, "All"]],
        'order': [[4, 'desc']],
        "language": {
            "sProcessing": "処理中...",
            "sLengthMenu": "_MENU_ 件表示",
            "sZeroRecords": "データはありません。",
            "sInfo": "_START_件～_END_件を表示（全_TOTAL_ 件中）",
            "sInfoEmpty": " 0 件中 0 から 0 まで表示",
            "sInfoFiltered": "（全 _MAX_ 件より抽出）",
            "sInfoPostFix": "",
            "sSearch": "検索フィルター:",
            "sUrl": "",
            "oPaginate": {
                "sFirst": "先頭",
                "sPrevious": "前ページ",
                "sNext": "次ページ",
                "sLast": "最終"
            }
        }
    });
    return t.on('order.dt search.dt', function () {
        t.column(0, {
            search: 'applied',
            order: 'applied'
        }).nodes().each(function (cell, i) {
            if (i < 25) {
                cell.innerHTML = "<span style=color:red;font-weight:bold>" + (i + 1) + "</span>";
            } else {
                cell.innerHTML = i + 1;
            }
        });
    }).draw();
});

