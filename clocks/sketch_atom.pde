//global variables
PVector e1 = new PVector();
PVector e2 = new PVector();
PVector e3 = new PVector();


void setup() {
  size(400, 400);
}

void draw() {
  background(255);
  drawAtomBG();
  drawLegend();
  
 /////////////////////////////////////////time
  float timeS = (float)second()/10;
  e1.x = 200 + (150 * cos(timeS)) ;
  e1.y = 200 + (50 * sin(timeS));

  
  //adding to time just starts the circle at a different location on the ellipse, i did it because it looks better
  float timeM = (float)minute()/10;
  e2.x = 200 + (150 * cos(timeM+2) * cos(-PI/3) - 50 * sin(timeM+2) * sin(-PI/3));
  e2.y = 200 + (150 * cos(timeM+2) * sin(-PI/3) + 50 * sin(timeM+2) * cos(-PI/3));
  
  float timeH = (float)hour()/4;
  e3.x = 200 + (150 * cos(timeH+1) * cos(-PI/1.5) - 50 * sin(timeH+1) * sin(-PI/1.5));
  e3.y = 200 + (150 * cos(timeH+1) * sin(-PI/1.5) + 50 * sin(timeH+1) * cos(-PI/1.5));
 
  noStroke();
  fill(255, 100, 100);
  ellipse(e1.x, e1.y, 20, 20);

  noStroke();
  fill(100, 255, 100);
  ellipse(e2.x, e2.y, 20, 20);
  
  noStroke();
  fill(100, 100, 255);
  ellipse(e3.x, e3.y, 20, 20);

}

void drawLegend()
{
  noStroke();
  fill(100, 100, 255);
  ellipse(360, 380, 20, 20);
  
  fill(100, 255, 100);
  ellipse(360, 355, 20, 20);
  
  fill(255, 100, 100);
  ellipse(360, 330, 20, 20); 
  
  textSize(10);
  fill(50);
  text("S", 375, 385); 
  text("M", 375, 360); 
  text("H", 375, 335); 
  
}

void drawAtomBG() {
  noStroke();
  fill(0);
  ellipse(200, 200, 50, 50);
  noFill();
  strokeWeight(2);

  pushMatrix();
  translate(200, 200);
  stroke(0);
  ellipse(0, 0, 300, 100);
  popMatrix();


  pushMatrix();
  translate(200, 200);
  rotate(PI/1.5);
  stroke(0);
  ellipse(0, 0, 300, 100);
  popMatrix();

  pushMatrix();
  translate(200, 200);
  rotate(PI/3);
  stroke(0);
  ellipse(0, 0, 300, 100);
  popMatrix();
}