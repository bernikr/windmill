var mouseMode = 'point';
var paused = false;

$(function(){
    $('#btn-pause').click(function(){
        paused = !paused;
        $('#btn-pause i')
            .toggleClass('fa-play', paused)
            .toggleClass('fa-pause', !paused);
    });
    $('#btn-mode button').click(function(){
        data = $(this).data('mode');
        mouseMode = data;
        $('#btn-mode button').each(function(){
            $(this).toggleClass('active', data == $(this).data('mode'));
        });
    });
});
