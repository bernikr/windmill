var windmill = {
	paused:	      false,
	speed:        0.01,
	resolution:   0.001,
	constants: {
		numberOfStartingPoints: 10,
		lineLength: 1000,
	},
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
		data: [],
	},
	mouse: {
		clicked: false,
		mode:   'point',
		relationToPivot: {
			x: 0,
			y: 0,
			angle: 0,
		},
	},
	points: [],
	relativeAngels: [],
	helpers: {},
}

windmill.line.newPivot = function(p){
	windmill.line.pivot = $.extend({}, p);
	windmill.relativeAngels.recalculate();
	i = windmill.history.data.length;
	if(i > 2){
		if(windmill.history.data[0].x == windmill.history.data[i-1].x
		&& windmill.history.data[0].y == windmill.history.data[i-1].y
		&& windmill.history.data[1].x == p.x
		&& windmill.history.data[1].y == p.y){
			windmill.history.record = false;
		}
	}
	if(windmill.history.record) windmill.history.data.push(p);
}

windmill.points.add = function(p){
	windmill.points.push(p);
	windmill.relativeAngels.recalculate();
	windmill.history.reset();
}

windmill.history.reset = function(){
	windmill.history.data = [];
	windmill.history.record = true;
}

windmill.relativeAngels.recalculate = function(){
	for(i = 0; i < windmill.points.length; i++) {
		windmill.relativeAngels[i] = Math.atan2(windmill.points[i].y - windmill.line.pivot.y, windmill.points[i].x - windmill.line.pivot.x);
		if(windmill.relativeAngels[i] < windmill.resolution) windmill.relativeAngels[i] += Math.PI;
	}
}

windmill.helpers.distanceSq = function(p1, p2){
	return Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2);
}

windmill.solve = function() {
	for(i = 0; i < windmill.points.length; i++) {
		windmill.relativeAngels[i] = Math.atan2(windmill.points[i].y - windmill.line.pivot.y, windmill.points[i].x - windmill.line.pivot.x);
		if(windmill.relativeAngels[i] < 0) windmill.relativeAngels[i] += 2 * Math.PI;
	}
	for(alpha = 0; alpha <= 2 * Math.PI; alpha += windmill.resolution){
		count = 0;
		for(i = 0; i < windmill.points.length; i++) {
			if(windmill.relativeAngels[i] > alpha
			&& windmill.relativeAngels[i] < alpha + Math.PI)
				count++;
			}
		if(count == Math.floor(windmill.points.length/2)){
			windmill.line.angle = alpha;
			if(windmill.line.angle > Math.PI) windmill.line.angle -= Math.PI;
			windmill.relativeAngels.recalculate();
			break;
		}
	}
	windmill.history.reset();
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
		windmill.mouse.mode = data;
		$('#btn-mode button').each(function(){
			$(this).toggleClass('active', data == $(this).data('mode'));
		});
	});
	$('#btn-solve').click(function(){
		windmill.solve();
	});
	$('#btn-color-toggle').click(function(){
		windmill.history.show = !windmill.history.show;
		$(this).toggleClass('active', windmill.history.show);
	});
	$('#btn-color-reset').click(function(){
		windmill.history.reset();
	});
});
