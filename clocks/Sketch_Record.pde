int cx, cy;
float hoursRadius;
float clockDiameter;

void setup() {
  size(400, 360);
  stroke(255);
  
  int radius = min(width, height) / 2;
  hoursRadius = 166;
  clockDiameter = radius * 1.8;
  
  cx = width / 2;
  cy = height / 2;
}

void draw() {
  
  ////////////////////////////////////////////////////clock background
  background(188);
  fill(1);
  noStroke();
  ellipse(cx, cy, clockDiameter, clockDiameter);
  
  float n = map(hour()+ norm(minute(), 0, 60), 0, 24, 0, QUARTER_PI) + HALF_PI;
  
   fill(255);
   ellipse(345,43,35,35);
   
   fill(255);
   ellipse(365,305,20,20);
   ellipse(365,335,20,20);
  
  ///////////////////////////////////////////////////////Clock layers
  
  for (float i=320; i>0; i=i-10){
    if(i>300) 
    {
     fill(20);
   }
   if( i <=300)
   {
    fill(114); 
   }
   if (i <= 60){
     fill(0);
   }
   if(i <= 20){
     fill(255);
     stroke(255);
   } 
    stroke(0);
    strokeWeight(1);
    ellipse(width/2,height/2,i,i);
  }
  
  fill(255);
  ellipse(width/2,height/2,25,25);
  
  fill(0);
  ellipse(width/2,height/2,5,5);
  
  ///////////////////////////////////////////////////////Hour Needle
  stroke(0);
  strokeCap(SQUARE);
  strokeWeight(6);
  line(345, 43, 345 + cos(n) * hoursRadius, 43 + sin(n) * hoursRadius);
  
}