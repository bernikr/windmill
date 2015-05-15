//config
float speed = 0.01;
int numberOfPoints = 10;
int lineLength = 1000;

// status variables
float phi;
Point pivot;
ArrayList<Point> points = new ArrayList<Point>();
int currentPivotId;
boolean paused = false;

void setup() {
  size(500, 500);
  for(int i = 0; i < numberOfPoints; i++) {
    points.add(new Point(random(500),random(500)));
  }
  newPivot(points.get((int)random(numberOfPoints+1)));
  phi = random(PI);
}

void draw() {
  display();
  if(!paused) mainLoop(); 
}

void keyPressed() {
  paused = !paused;
}

void mousePressed() {
  p = new Point(mouseX, mouseY);
  removed = false;
  for (int i = points.size() - 1; i >= 0; i--) {
    if(p.distanceSq(points.get(i)) < 100) {
      points.remove(i);
      removed = true;
    }
  }
  if(!removed) addPoint(p);
}

void display() {
  background(255);
  strokeWeight(5);
  for(Point p : points) {
    point(p.x, p.y);
  }
 
  strokeWeight(2); 
  line(pivot.x + cos(phi) * lineLength,
       pivot.y + sin(phi) * lineLength,
       pivot.x - cos(phi) * lineLength,
       pivot.y - sin(phi) * lineLength);
}

void newPivot(Point p) {
  pivot = p;
  recalculate();
}

void recalculate() {
  for(Point p : points) {
    p.angle = atan2(p.y - pivot.y, p.x - pivot.x);
    if(p.angle < 0) p.angle += PI;
  }
}

void mainLoop() {
  phi += speed;
  if(phi > PI) phi -= PI;
  
  for(Point p : points) {
    if(   p.angle >= phi
       && p.angle <= phi + speed)
    {
      newPivot(p);
      break;
    }
  }
}

void addPoint(Point p){
  points.add(p);
  recalculate();
}

class Point {
  public float x, y, angle;
  Point(float nx, float ny) {
    x = nx;
    y = ny;
  }
  float distanceSq(Point p) {
    return sq(this.x - p.x) + sq(this.y - p.y);
  }
}
