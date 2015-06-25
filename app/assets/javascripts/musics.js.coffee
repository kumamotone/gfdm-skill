# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#sTable_musics').dataTable 'pagingType': 'full_numbers',        "lengthMenu": [[-1], ["All"]]
