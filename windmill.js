var mouseMode = 'point';
var paused = false;
var colored = false;


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
    $('#btn-solve').click(function(){
        Processing.getInstanceById('windmill').solve();
    });
    $('#btn-color-toggle').click(function(){
        colored = !colored;
        $(this).toggleClass('active', colored);
    });
    $('#btn-color-reset').click(function(){
        Processing.getInstanceById('windmill').resetHistory();
    });
});
