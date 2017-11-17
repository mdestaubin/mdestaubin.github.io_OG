int boxsize = 20;
int boxsizeBig = 200;
PFont f;
int cols, rows;
int colsBig, rowsBig;
 
void setup() {
  size(800, 720); // Always first call in setup()!
//  f = loadFont("ArialNarrow-48.vlw");
  f = createFont("Arial", 48); // Previous line OK, this one is just more convenient for tests
  textFont(f, 8); // No need to call it on each cell, if you don't change it
  textAlign(CENTER);
  cols = width/boxsize;
  rows = height/boxsize;
  colsBig = width/boxsizeBig;
  rowsBig = height/boxsizeBig;
}
 
void draw() {
  background(255);
    
      int s = second();// Values from 0 - 59
      float S = map(s,0,59,0,20);
      int m = minute();  // Values from 0 - 59
      float M = map(m,0,60,0,800);
      int h = hour();
      
      fill(80,200,150,90);
      noStroke();
      rect(0,20,S,20);
      
      fill(200,80,150,90);
      noStroke();
      rect(0,0,M,20);
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      
      noFill();
      strokeWeight(1);
      rect(x, y, boxsize, boxsize);
     
      fill(50);
      text(str(j * cols + i + 1), x + boxsize / 2, y + boxsize/1.5);
    }
  }
  
outlines();  
    
}





void outlines()
{
 stroke(0);
  strokeWeight(2);
  line(200,0,200,height);
  line(400,0,400,height);
  line(600,0,600,height);
  
  line(0,120,width,120);
  line(0,240,width,240);
  line(0,360,width,360);
  line(0,480,width,480);
  line(0,600,width,600); 
}