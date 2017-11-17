void setup() {
  size(600, 600);
  background(0);

  smooth();
  noStroke();

}

void draw() 
{
  background(0);

  int ih = hour();
  float fh = float(ih);
  
  fill(200);
  ellipse(width/2, height/2, 400, 400);
  
  fill(0);
  arc(width/2, height/2, 400, 400, TWO_PI - PI/2, TWO_PI - PI/2 + TWO_PI*(fh/24));
}