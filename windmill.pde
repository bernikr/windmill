//config
int sizeValue = 500;
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
    points.add(new Point(random(),random()));
  }
  newPivot(points.get((int)random(numberOfPoints+1)));
  phi = random(PI);
}

void draw() {
  display();
  if(!paused) mainLoop();
  
  if(mousePressed) paused = !paused;
}

void display() {
  background(255);
  strokeWeight(5);
  for(Point p : points) {
    point(p.x * sizeValue, p.y * sizeValue);
  }
 
  strokeWeight(2); 
  line(pivot.x * sizeValue + cos(phi) * lineLength,
       pivot.y * sizeValue + sin(phi) * lineLength,
       pivot.x * sizeValue - cos(phi) * lineLength,
       pivot.y * sizeValue - sin(phi) * lineLength);
}

void newPivot(Point p) {
  pivot = p;
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

class Point {
  public float x, y, angle;
  Point(float nx, float ny) {
    x = nx;
    y = ny;
  }
}
