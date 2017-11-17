char  selected;  // what is selected (h,m,s)
int   gap;       // gap between digits


void setup() {
  size(600, 600);

  selected = '0';
  gap = 180;
  noStroke();
}

void draw() {
  background(255);
  stroke(0);
  strokeWeight(1);
  noFill();
  ellipse(width/2 - gap, height/2, 130, 130);
  ellipse(width/2, height/2, 130, 130);
  ellipse(width/2 + gap, height/2, 130, 130);
 
  // draw h, m, s
  float secsPos = map(second(), 0, 60, 0 , TWO_PI);
  float minsPos = map(minute(), 0, 60, 0 , TWO_PI);
  float hrsPos = map(hour(), 0, 24, 0 , TWO_PI);
  color c = color(selected == 'h' ? 255 : 0, selected == 'm' ? 255 : 0, selected == 's' ? 255 : 0);
  drawNumber(hour(), selected == 'h', -gap, 0, hrsPos, c);
  drawNumber(minute(), selected == 'm', 0, 0, minsPos, c);
  drawNumber(second(), selected == 's', gap, 0, secsPos, c);
  dots();
  dotsLeft();
  dotsRight();
}

/*
 * drawNumber
 * takes an integer and draws it offset from the centre of the screen by
 * offsetX and offsetY. If big is true then use a big size for the type.
 *
 */
void drawNumber(int number, boolean big, float offsetX, float offsetY, float position, color c) 
{
  String theText = str(number); // convert number to string
  if (big){
    textSize(25); // set big font size
    fill(0);
  }
  else{
    textSize(15);  // normal font size
    fill(0);}
  float textWidthfoo = textWidth(theText) * 0.5;
  float textAscentfoo = textAscent() * 0.375;

  float xLine = (width/2 + offsetX) + 65* cos(position-HALF_PI);
  float yLine = (height/2 + offsetY) + 65* sin(position-HALF_PI);
   
  // draw text offset from the centre of the screen
  text(theText, width/2 - textWidthfoo + offsetX, height/2 + textAscentfoo + offsetY);
  ellipse(xLine, yLine,10,10);
}

void dots() { 
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+= (360/60)) { //for loop adds 360/60 = 6 - per cycle. Putting a point 60 times around the clock face at regular intervals
    float angle = radians(a);
    float x = (width/2) + cos(angle) * ((width/2)*0.217); //note 0.72 again, to match the position of the second hand
    float y = (height/2) + sin(angle) * ((width/2)*0.217);
    vertex(x, y);
  }
  
}

void dotsLeft() { 
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+= (360/60)) { //for loop adds 360/60 = 6 - per cycle. Putting a point 60 times around the clock face at regular intervals
    float angle = radians(a);
    float x = (width/2-gap) + cos(angle) * ((width/2)*0.217); //note 0.72 again, to match the position of the second hand
    float y = (height/2) + sin(angle) * ((width/2)*0.217);
    vertex(x, y);
  }
}

void dotsRight() {
  strokeWeight(2);
  beginShape(POINTS);
  for (int a = 0; a < 360; a+= (360/60)) { 
    float angle = radians(a);
    float x = (width/2+gap) + cos(angle) * ((width/2)*0.217); //note 0.72 again, to match the position of the second hand
    float y = (height/2) + sin(angle) * ((width/2)*0.217);
    vertex(x, y);
  }
  
}