var windmill = {
	mouseMode:   'point',
	paused:	      false,
	speed:        0.01,
	line: {
		pivot: {
			x: 0,
			y: 0,
		},
		angle: 0,
	},
	history: {
		show: false,
		record: true,
	},
}

$(function(){
	$('#btn-pause').click(function(){
		windmill.paused = !windmill.paused;
		$('#btn-pause i')
			.toggleClass('fa-play', windmill.paused)
			.toggleClass('fa-pause', !windmill.paused);
	});
	$('#btn-mode button').click(function(){
		data = $(this).data('mode');
		windmill.mouseMode = data;
		$('#btn-mode button').each(function(){
			$(this).toggleClass('active', data == $(this).data('mode'));
		});
	});
	$('#btn-solve').click(function(){
		Processing.getInstanceById('windmill').solve();
	});
	$('#btn-color-toggle').click(function(){
		windmill.history.show = !windmill.history.show;
		$(this).toggleClass('active', windmill.history.show);
	});
	$('#btn-color-reset').click(function(){
		Processing.getInstanceById('windmill').resetHistory();
	});
});
