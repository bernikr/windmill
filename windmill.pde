// status variables
ArrayList<Point> history = new ArrayList<Point>();

void setup() {
	size(500, 500);
	for(int i = 0; i < windmill.constants.numberOfStartingPoints; i++) {
		windmill.points.push({
			x: Math.random()*300 + 100,
			y: Math.random()*300 + 100,
		});
	}
	newPivot(windmill.points[(int)random(windmill.constants.numberOfStartingPoints)]);
	solve();
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
			if(distanceSq(p, windmill.points[i]) < 100) {
				windmill.points.splice(i, 1);
				removed = true;
				resetHistory();

			}
		}
		if(!removed) addPoint(p);
		recalculate();
		resetHistory();
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
		recalculate();
		resetHistory();
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
		for(int i = 0; i < history.size()-1; i++) {
			strokeWeight(1);
			stroke(128);
			line(history.get(i).x,
			     history.get(i).y,
			     history.get(i+1).x,
			     history.get(i+1).y);

			stroke(0,255,0);
			strokeWeight(5);
			point(history.get(i).x, history.get(i).y);
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

void newPivot(p) {
	windmill.line.pivot = $.extend({}, p);
	recalculate();
	i = history.size();
	if(i > 2){
		if(history.get(0).x == history.get(i-1).x
		&& history.get(0).y == history.get(i-1).y
		&& history.get(1).x == p.x
		&& history.get(1).y == p.y){
			windmill.history.record = false;
		}
	}
	if(windmill.history.record) history.add(p);
}

void recalculate() {
	for(int i = 0; i < windmill.points.length; i++) {
		windmill.points[i].angle = atan2(windmill.points[i].y - windmill.line.pivot.y, windmill.points[i].x - windmill.line.pivot.x);
		if(windmill.points[i].angle < windmill.resolution) windmill.points[i].angle += PI;
	}
}

void mainLoop() {
	windmill.line.angle += windmill.speed;
	if(windmill.line.angle > PI) windmill.line.angle -= PI;

	for(float s = 0; s <= windmill.speed; s += windmill.resolution){
		for(int i = 0; i < windmill.points.length; i++) {
			if(windmill.points[i].angle >= windmill.line.angle + s
			&& windmill.points[i].angle <= windmill.line.angle + s + windmill.resolution)
			{
				newPivot(windmill.points[i]);
				break;
			}
		}
	}
}

void addPoint(Point p){
	windmill.points.push(p);
	recalculate();
	resetHistory();
}

void solve(){
	float step = 0.01;
	for(int i = 0; i < windmill.points.length; i++) {
		windmill.points[i].angle = atan2(windmill.points[i].y - windmill.line.pivot.y, windmill.points[i].x - windmill.line.pivot.x);
		if(windmill.points[i].angle < 0) windmill.points[i].angle += 2*PI;
	}
	for(float alpha = 0; alpha <= 2*PI; alpha += step){
		int count = 0;
		for(int i = 0; i < windmill.points.length; i++) {
			if(windmill.points[i].angle > alpha
			&& windmill.points[i].angle < alpha + PI)
				count++;
			}
		if(count == Math.floor(windmill.points.length/2)){
			windmill.line.angle = alpha;
			if(windmill.line.angle > PI) windmill.line.angle -= PI;
			recalculate();
			break;
		}
	}
	resetHistory();
}

void resetHistory(){
	history = new ArrayList<Point>();
	windmill.history.record = true;
}

class Point {
	public float x, y, angle;
	Point(float nx, float ny) {
		x = nx;
		y = ny;
	}
	Point(Point p){
		x = p.x;
		y = p.y;
		angle = p.angle;
	}
	float distanceSq(Point p) {
		return sq(this.x - p.x) + sq(this.y - p.y);
	}
}

float distanceSq(p, q) {
	return sq(q.x - p.x) + sq(q.y - p.y);
}
