void setup(){
  size(550,550);
  smooth();
  noFill();
 strokeCap(SQUARE);
}




void draw(){
  background(240);
  noFill();
  float s = map(second(),0,60,0,TWO_PI)-HALF_PI;
  float m = map(minute(),0,60,0,TWO_PI)-HALF_PI;
  float h = map(hour(),0,24,0,TWO_PI)-HALF_PI;
  float ss=0-HALF_PI;
  strokeWeight(60);
  stroke(50);
  arc(width/2, height/2, 100,100,ss,s);
  strokeWeight(60);
  stroke(110);
  arc(width/2, height/2,250,250,ss,m);
  strokeWeight(60);
  stroke(170);
  arc(width/2, height/2,400,400,ss,h);
  
}