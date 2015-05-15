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


