//config
int sizeValue = 500;
float speed = 0.01;
int numberOfPoints = 10;
int lineLength = 1000;

// status variables
float phi;
PVector pivot;
PVector[] points = new PVector[numberOfPoints];
float[] pivotToPointAngles = new float[numberOfPoints];
int currentPivotId;
boolean paused = false;

void setup() {
  size(500, 500);
  for(int i = 0; i < numberOfPoints; i++) {
    points[i] = new PVector(random(),random());
  }
  newPivot((int)random(numberOfPoints+1));
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
  for(int i = 0; i < numberOfPoints; i++) {
    point(points[i].x * sizeValue, points[i].y * sizeValue);
  }
 
  strokeWeight(2); 
  line(pivot.x * sizeValue + cos(phi) * lineLength,
       pivot.y * sizeValue + sin(phi) * lineLength,
       pivot.x * sizeValue - cos(phi) * lineLength,
       pivot.y * sizeValue - sin(phi) * lineLength);
}

void newPivot(int pivotId) {
  pivot = points[pivotId];
  currentPivotId = pivotId;
  for(int i = 0; i < numberOfPoints; i++) {
    pivotToPointAngles[i] = atan2(points[i].y - pivot.y, points[i].x - pivot.x);
    if(pivotToPointAngles[i] < 0) pivotToPointAngles[i] += PI;
  }
}
void mainLoop() {
  phi += speed;
  if(phi > PI) phi -= PI;
  
  for(int i = 0; i < numberOfPoints; i++) {
    if(   pivotToPointAngles[i] >= phi
       && pivotToPointAngles[i] <= phi + speed
       && i != currentPivotId)
    {
      newPivot(i);
      break;
    }
  }
}
