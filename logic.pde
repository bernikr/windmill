
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
