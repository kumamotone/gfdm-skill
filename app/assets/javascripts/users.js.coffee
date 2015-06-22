# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$ ->
  $('#sortableTable').dataTable({
        "lengthMenu": [[25, 50, -1], [25, 50, "All"]]
        "order": [[ 4, "desc" ]]
     })
$ ->
  $('#sortableTable2').dataTable({
        "lengthMenu": [[25, 50, -1], [25, 50, "All"]]
        "order": [[ 4, "desc" ]]
    })
