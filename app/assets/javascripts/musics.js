$(document).ready(function() {
return $('#sTable_musics').dataTable({
  'pagingType': 'full_numbers',
  "lengthMenu": [[-1], ["All"]]
});
});

$(function () {
    $( '#benry' ).keypress( function ( e ) {
        if ( e.which == 13 ) {
            $( '#benrybtn' ).click();
            return false;
        }
    });
    $( '#benrybtn' ).click( function ( e ) {
        // preventDefault();
        var str = $('#benry').val();
        var splits = str.split(/\s+/, 12);
        $('#music_d_bsc').val(splits[0]);
        $('#music_d_adv').val(splits[1]);
        $('#music_d_ext').val(splits[2]);
        $('#music_d_mas').val(splits[3]);
        $('#music_g_bsc').val(splits[4]);
        $('#music_g_adv').val(splits[5]);
        $('#music_g_ext').val(splits[6]);
        $('#music_g_mas').val(splits[7]);
        $('#music_b_bsc').val(splits[8]);
        $('#music_b_adv').val(splits[9]);
        $('#music_b_ext').val(splits[10]);
        $('#music_b_mas').val(splits[11]);
        return false;
    });
});
