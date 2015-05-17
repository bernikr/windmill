void setup() {
	size(500, 500);
	for(int i = 0; i < windmill.constants.numberOfStartingPoints; i++) {
		windmill.points.push({
			x: Math.random()*300 + 100,
			y: Math.random()*300 + 100,
		});
	}
	windmill.line.newPivot(windmill.points[(int)random(windmill.constants.numberOfStartingPoints)]);
	windmill.solve();
}

void draw() {
	display();
	if(!windmill.paused) mainLoop();
}

void mousePressed() {
	if(windmill.mouse.mode == 'point') {
		p = {
			x: mouseX,
			y: mouseY,
		};
		removed = false;
		for (int i = windmill.points.length - 1; i >= 0; i--) {
			if(windmill.helpers.distanceSq(p, windmill.points[i]) < 100) {
				windmill.points.splice(i, 1);
				removed = true;
				windmill.history.reset();

			}
		}
		if(!removed) windmill.points.add(p);
		windmill.relativeAngels.recalculate();
		windmill.history.reset();
	}
	windmill.mouse.relationToPivot.x = mouseX - windmill.line.pivot.x;
	windmill.mouse.relationToPivot.y = mouseY - windmill.line.pivot.y;
	windmill.mouse.relationToPivot.angle = atan2(mouseY - windmill.line.pivot.y, mouseX - windmill.line.pivot.x) - windmill.line.angle;
	windmill.mouse.clicked = true;
}

void mouseReleased() {
	windmill.mouse.clicked = false;
}

void mouseDragged() {
	if(windmill.mouse.clicked){
		if(windmill.mouse.mode == 'move') {
			windmill.line.pivot.x = mouseX - windmill.mouse.relationToPivot.x;
			windmill.line.pivot.y = mouseY - windmill.mouse.relationToPivot.y;
		} else if(windmill.mouse.mode == 'rotate') {
			windmill.line.angle = atan2(mouseY - windmill.line.pivot.y, mouseX - windmill.line.pivot.x) - windmill.mouse.relationToPivot.angle;
			windmill.line.angle = windmill.line.angle % PI;
			windmill.line.angle += 2*PI;
			windmill.line.angle = windmill.line.angle % PI;
		}
		windmill.relativeAngels.recalculate();
		windmill.history.reset();
	}
}


void display() {
	background(255);
	strokeWeight(5);
	stroke(0);
	for(i = 0; i < windmill.points.length; i++) {
		point(windmill.points[i].x, windmill.points[i].y);
	}

	if(windmill.history.show){
		for(int i = 0; i < windmill.history.data.length-1; i++) {
			strokeWeight(1);
			stroke(128);
			line(windmill.history.data[i].x,
			     windmill.history.data[i].y,
			     windmill.history.data[i+1].x,
			     windmill.history.data[i+1].y);

			stroke(0,255,0);
			strokeWeight(5);
			point(windmill.history.data[i].x, windmill.history.data[i].y);
		}
	}

	stroke(0);
	strokeWeight(2);
	line(windmill.line.pivot.x + cos(windmill.line.angle) * windmill.constants.lineLength,
	     windmill.line.pivot.y + sin(windmill.line.angle) * windmill.constants.lineLength,
	     windmill.line.pivot.x - cos(windmill.line.angle) * windmill.constants.lineLength,
	     windmill.line.pivot.y - sin(windmill.line.angle) * windmill.constants.lineLength);

	stroke(255,0,0);
	strokeWeight(5);
	point(windmill.line.pivot.x, windmill.line.pivot.y);
}

void mainLoop() {
	windmill.line.angle += windmill.speed;
	if(windmill.line.angle > PI) windmill.line.angle -= PI;

	for(float s = 0; s <= windmill.speed; s += windmill.resolution){
		for(int i = 0; i < windmill.points.length; i++) {
			if(windmill.relativeAngels[i] >= windmill.line.angle + s
			&& windmill.relativeAngels[i] <= windmill.line.angle + s + windmill.resolution)
			{
				windmill.line.newPivot(windmill.points[i]);
				break;
			}
		}
	}
}
