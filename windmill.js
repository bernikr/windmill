var windmill = {
	status: {
		mouseMode:   'point',
		paused:	  false,
		showHistory: false,
	}
}

$(function(){
	$('#btn-pause').click(function(){
		windmill.status.paused = !windmill.status.paused;
		$('#btn-pause i')
			.toggleClass('fa-play', windmill.status.paused)
			.toggleClass('fa-pause', !windmill.status.paused);
		console.log(windmill);
	});
	$('#btn-mode button').click(function(){
		data = $(this).data('mode');
		windmill.status.mouseMode = data;
		$('#btn-mode button').each(function(){
			$(this).toggleClass('active', data == $(this).data('mode'));
		});
	});
	$('#btn-solve').click(function(){
		Processing.getInstanceById('windmill').solve();
	});
	$('#btn-color-toggle').click(function(){
		windmill.status.showHistory = !windmill.status.showHistory;
		$(this).toggleClass('active', windmill.status.showHistory);
	});
	$('#btn-color-reset').click(function(){
		Processing.getInstanceById('windmill').resetHistory();
	});
});
