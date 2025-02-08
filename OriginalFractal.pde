int layerPetalCount = 8;

int initOuterPetalSize = 100;
int outerPetalSize = initOuterPetalSize;

int minInnerPetalSize = (int) (outerPetalSize * 0.75);
int maxInnerPetalSize = 100;
int initInnerPetalSize = (int) (outerPetalSize * 0.75);
int innerPetalSize = initInnerPetalSize;
boolean innerFlip = false;

float outmostAngle = 0;

int screenCenterX;
int screenCenterY;

void setup() {
  size(800, 800);
  background(0);
  
  screenCenterX = width/2;
  screenCenterY = height/2;
  
  ellipse(screenCenterX, screenCenterY, 10, 10);
  
  //drawPetalLevels(100, 0, true, 0.75, (180/layerPetalCount));
}

void draw() {
  background(0);
  // draw outer fake petal layer
  drawPetalLevels(outerPetalSize, outmostAngle + (180/layerPetalCount), !innerFlip, 0.75, (180/layerPetalCount), false);
  // draw the real movable petal layers
  drawPetalLevels(innerPetalSize, outmostAngle, innerFlip, 0.75, (180/layerPetalCount), true);
}

void mouseWheel(MouseEvent event) {
  float direction = event.getCount();
  
  if (direction < 0)
    if (innerPetalSize + direction*2 <= minInnerPetalSize)
      return;
  
  innerPetalSize += direction*2;
  outerPetalSize -= direction;
  
  if (innerPetalSize > maxInnerPetalSize) {
    outerPetalSize = initOuterPetalSize;
    innerPetalSize = initInnerPetalSize;
    innerFlip = !innerFlip;
    outmostAngle = ( outmostAngle + (180/layerPetalCount) ) % 360;
  }
}

void keyPressed() {
  int op = 0;
  if (key=='w')
    op = 1;
  else if (key=='s')
    op = -1;
    
  float direction = op;
  
  if (direction < 0)
    if (innerPetalSize + direction*2 <= minInnerPetalSize)
      return;
  
  innerPetalSize += direction*2;
  outerPetalSize -= direction;
  
  if (innerPetalSize > maxInnerPetalSize) {
    outerPetalSize = initOuterPetalSize;
    innerPetalSize = initInnerPetalSize;
    innerFlip = !innerFlip;
    outmostAngle = ( outmostAngle + (180/layerPetalCount) ) % 360;
  }
}

void drawPetalLevels(int radius, float angleOffset, boolean colorFlag, float layerDecay, int angleDiff, boolean recursive) {
  // prevent infinite loop
  if (radius <= 0)
    return;
  
  // draw the petals
  for(int i=0;i<layerPetalCount;i++) {
    float angle = i * (360/layerPetalCount) + angleOffset;
    int xOffset = (int) ( sin(radians(angle)) * radius * 1.2 );
    int yOffset = (int) ( cos(radians(angle)) * radius * 1.2 );
    
    stroke(0);
    
    if (colorFlag)
      fill(255,0,50);
    else
      fill(255,140,0);
    
    ellipse(screenCenterX + xOffset, screenCenterY + yOffset, radius*2, radius*2);
  }
  
  if (recursive)
    drawPetalLevels((int)(radius*layerDecay), angleOffset+angleDiff, !colorFlag, layerDecay, angleDiff, recursive);
}
