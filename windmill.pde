//config
float speed = 0.02;
int numberOfPoints = 10;
int lineLength = 1000;
float resolution = 0.001;

// status variables
float phi;
Point pivot;
ArrayList<Point> points = new ArrayList<Point>();
int currentPivotId;
Point mousePivotDif;
boolean locked = false;

void setup() {
  size(500, 500);
  for(int i = 0; i < numberOfPoints; i++) {
    points.add(new Point(random(100,400),random(100,400)));
  }
  newPivot(points.get((int)random(numberOfPoints+1)));
  solve();
  mousePivotDif = new Point(0, 0);
}

void draw() {
  display();
  if(!paused) mainLoop();
}

void keyPressed() {

}

void mousePressed() {
    if(mouseMode == 'point') {
        p = new Point(mouseX, mouseY);
        removed = false;
        for (int i = points.size() - 1; i >= 0; i--) {
            if(p.distanceSq(points.get(i)) < 100) {
                points.remove(i);
                removed = true;
            }
        }
        if(!removed) addPoint(p);
        recalculate();
    }
    mousePivotDif.x = mouseX - pivot.x;
    mousePivotDif.y = mouseY - pivot.y;
    mousePivotDif.angle = atan2(mouseY - pivot.y, mouseX - pivot.x) - phi;
    locked = true;
}

void mouseReleased() {
  locked = false;
}

void mouseDragged() {
    if(locked){
        if(mouseMode == 'move') {
            pivot.x = mouseX - mousePivotDif.x;
            pivot.y = mouseY - mousePivotDif.y;
        } else if(mouseMode == 'rotate') {
            phi = atan2(mouseY - pivot.y, mouseX - pivot.x) - mousePivotDif.angle;
            phi = phi % PI;
            phi += 2*PI;
            phi = phi % PI;
        }
        recalculate();
    }
}




void display() {
  background(255);
  strokeWeight(5);
  stroke(0);
  for(Point p : points) {
    point(p.x, p.y);
  }

  strokeWeight(2);
  line(pivot.x + cos(phi) * lineLength,
       pivot.y + sin(phi) * lineLength,
       pivot.x - cos(phi) * lineLength,
       pivot.y - sin(phi) * lineLength);

  stroke(255,0,0);
  strokeWeight(5);
  point(pivot.x, pivot.y);
}

void newPivot(Point p) {
  pivot = new Point(p);
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

  for(float s = 0; s <= speed; s += resolution){
      for(Point p : points) {
        if(   p.angle >= phi + s
           && p.angle <= phi + s + resolution)
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
}

void solve(){
  float step = 0.01;
  for(Point p : points) {
    p.angle = atan2(p.y - pivot.y, p.x - pivot.x);
    if(p.angle < 0) p.angle += 2*PI;
  }
  for(float alpha = 0; alpha <= 2*PI; alpha += step){
    int count = 0;
    for(Point p : points) {
      if(p.angle > alpha
      && p.angle < alpha + PI) {
        count++;
      } else if(p.angle < alpha - PI
             && p.angle > alpha - 3*PI) {

      }
    }
    if(count == (int)points.size()/2){
      phi = alpha;
      if(phi > PI) phi -= PI;
      recalculate();
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
  Point(Point p){
    x = p.x;
    y = p.y;
    angle = p.angle;
  }
  float distanceSq(Point p) {
    return sq(this.x - p.x) + sq(this.y - p.y);
  }
}
