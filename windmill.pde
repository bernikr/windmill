void setup() {
	size(500, 500);
	windmill.restart(windmill.constants.numberOfStartingPoints);
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
				windmill.graph.reset();

			}
		}
		if(!removed) windmill.points.add(p);
		windmill.relativeAngels.recalculate();
		windmill.graph.reset();
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
		windmill.graph.reset();
	}
}


void display() {
	background(255);
	strokeWeight(5);
	stroke(0);
	for(i = 0; i < windmill.points.length; i++) {
		point(windmill.points[i].x, windmill.points[i].y);
	}

	if(windmill.graph.show){
		for(int i = 0; i < windmill.graph.data.length-1; i++) {
			strokeWeight(1);
			stroke(128);
			line(windmill.graph.data[i].x,
			     windmill.graph.data[i].y,
			     windmill.graph.data[i+1].x,
			     windmill.graph.data[i+1].y);

			stroke(0,255,0);
			strokeWeight(5);
			point(windmill.graph.data[i].x, windmill.graph.data[i].y);
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
