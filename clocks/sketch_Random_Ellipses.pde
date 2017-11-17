
int H = hour();
int M = minute();
int S = second();

Ball[] secondBalls = new Ball[60];
Ball[] minuteBalls = new Ball[60];
Ball[] hourBalls = new Ball[24];

void setup(){
  size(600,600);
  noStroke();
  for (int i = 0; i < 60; i++) {
    secondBalls[i] = new Ball(random(width), random(height), 10, i, 140, 60, secondBalls);
    }
  for (int i = 0; i < 60; i++){
    minuteBalls[i] = new Ball(random(width), random(height), 40, i, 90, 60, minuteBalls);
    }  
  for (int i = 0; i < 24; i++){
    hourBalls[i] = new Ball(random(width), random(height), 90, i, 1, 24, hourBalls);
    }
  }
 
void draw(){
  background(255);
  fill(0);
  H = hour();
  M = minute();
  S = second();
  
  for (int i = 0; i < S; i ++){
  
    secondBalls[i].display();
    
  }
  
  for (int i = 0; i < M; i++){
  
   minuteBalls[i].display();
   
  }
   
  for (int i = 0; i < H; i++){
   
    hourBalls[i].display(); 
  }

}

class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  float r;
  int id;
  int arraySize;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, float ir, int iarraySize, Ball[] oin) {
    x = xin;
    y = yin;
    r = ir;
    arraySize = iarraySize;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  
  void display() {
    fill(r, 200);
    ellipse(x, y, diameter, diameter);
  }
}