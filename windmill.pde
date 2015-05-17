//config
int numberOfPoints = 10;
int lineLength = 1000;
float resolution = 0.001;

// status variables
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Point> history = new ArrayList<Point>();
Point mousePivotDif;
boolean locked = false;

void setup() {
	size(500, 500);
	for(int i = 0; i < numberOfPoints; i++) {
		points.add(new Point(random(100,400),random(100,400)));
	}
	newPivot(points.get((int)random(numberOfPoints)));
	solve();
	mousePivotDif = new Point(0, 0);
}

void draw() {
	display();
	if(!windmill.paused) mainLoop();
}

void mousePressed() {
	if(windmill.mouseMode == 'point') {
		p = new Point(mouseX, mouseY);
		removed = false;
		for (int i = points.size() - 1; i >= 0; i--) {
			if(p.distanceSq(points.get(i)) < 100) {
				points.remove(i);
				removed = true;
				resetHistory();

			}
		}
		if(!removed) addPoint(p);
		recalculate();
		resetHistory();
	}
	mousePivotDif.x = mouseX - windmill.line.pivot.x;
	mousePivotDif.y = mouseY - windmill.line.pivot.y;
	mousePivotDif.angle = atan2(mouseY - windmill.line.pivot.y, mouseX - windmill.line.pivot.x) - windmill.line.angle;
	locked = true;
}

void mouseReleased() {
	locked = false;
}

void mouseDragged() {
	if(locked){
		if(windmill.mouseMode == 'move') {
			windmill.line.pivot.x = mouseX - mousePivotDif.x;
			windmill.line.pivot.y = mouseY - mousePivotDif.y;
		} else if(windmill.mouseMode == 'rotate') {
			windmill.line.angle = atan2(mouseY - windmill.line.pivot.y, mouseX - windmill.line.pivot.x) - mousePivotDif.angle;
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
	for(Point p : points) {
		point(p.x, p.y);
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
	line(windmill.line.pivot.x + cos(windmill.line.angle) * lineLength,
	     windmill.line.pivot.y + sin(windmill.line.angle) * lineLength,
	     windmill.line.pivot.x - cos(windmill.line.angle) * lineLength,
	     windmill.line.pivot.y - sin(windmill.line.angle) * lineLength);

	stroke(255,0,0);
	strokeWeight(5);
	point(windmill.line.pivot.x, windmill.line.pivot.y);
}

void newPivot(Point p) {
	windmill.line.pivot.x = p.x;
	windmill.line.pivot.y = p.y;
	recalculate();
	i = history.size();
	if(i>2){
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
	for(Point p : points) {
		p.angle = atan2(p.y - windmill.line.pivot.y, p.x - windmill.line.pivot.x);
		if(p.angle < resolution) p.angle += PI;
	}
}

void mainLoop() {
	windmill.line.angle += windmill.speed;
	if(windmill.line.angle > PI) windmill.line.angle -= PI;

	for(float s = 0; s <= windmill.speed; s += resolution){
		for(Point p : points) {
			if(p.angle >= windmill.line.angle + s
			&& p.angle <= windmill.line.angle + s + resolution)
			{
				newPivot(p);
				break;
			}
		}
	}
}

void addPoint(Point p){
	points.add(p);
	recalculate();
	resetHistory();
}

void solve(){
	float step = 0.01;
	for(Point p : points) {
		p.angle = atan2(p.y - windmill.line.pivot.y, p.x - windmill.line.pivot.x);
		if(p.angle < 0) p.angle += 2*PI;
	}
	for(float alpha = 0; alpha <= 2*PI; alpha += step){
		int count = 0;
		for(Point p : points) {
			if(p.angle > alpha
			&& p.angle < alpha + PI)
				count++;
			if(count == (int)(points.size()/2)){
				windmill.line.angle = alpha;
				if(windmill.line.angle > PI) windmill.line.angle -= PI;
				recalculate();
				break;
			}
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
