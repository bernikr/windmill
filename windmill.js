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
	graph: {
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
	i = windmill.graph.data.length;
	if(i > 2){
		if(windmill.graph.data[0].x == windmill.graph.data[i-1].x
		&& windmill.graph.data[0].y == windmill.graph.data[i-1].y
		&& windmill.graph.data[1].x == p.x
		&& windmill.graph.data[1].y == p.y){
			windmill.graph.record = false;
		}
	}
	if(windmill.graph.record) windmill.graph.data.push(p);
}

windmill.points.add = function(p){
	windmill.points.push(p);
	windmill.relativeAngels.recalculate();
	windmill.graph.reset();
}

windmill.graph.reset = function(){
	windmill.graph.data = [];
	windmill.graph.record = true;
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
	windmill.graph.reset();
}

windmill.restart = function(n){
	windmill.points.length = 0;
	for(i = 0; i < n; i++) {
		windmill.points.push({
			x: Math.random()*300 + 100,
			y: Math.random()*300 + 100,
		});
	}
	windmill.line.newPivot(windmill.points[Math.floor(Math.random() * n)]);
	windmill.solve();
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
	$('#btn-graph-toggle').click(function(){
		windmill.graph.show = !windmill.graph.show;
		$(this).toggleClass('active', windmill.graph.show);
	});
	$('#btn-graph-reset').click(function(){
		windmill.graph.reset();
	});
	$('#btn-reset button').click(reset);
	function reset(){
		windmill.restart($('#btn-reset input').val());
	}
});
