int H = hour();
int M = minute();
int S = second();

float spring = .001;
float gravity = 0.001;
float friction = -0.9;
Ball[] secondBalls = new Ball[60];
Ball[] minuteBalls = new Ball[60];
Ball[] hourBalls = new Ball[24];

void setup(){
  size(900,600);
  noStroke();

  for (int i = 0; i < 60; i++){
    minuteBalls[i] = new Ball(random(300,520), random(300,400), 30, i, map(i, 0, 60, 140, 0), 
    0, map(i, 0.0, 60.0, 100, 255), 60, minuteBalls);
    }  
  for (int i = 0; i < 24; i++){
    hourBalls[i] = new Ball(random(650,860), random(0,400), 50, i, map(i, 0.0, 24, 50, 0), 
    map(i, 0.0, 24, 230, 0), map(i, 0.0, 24, 255, 0), 24, hourBalls);
    
    }
  }
 
void draw(){
  background(255);
  fill(0);
  H = hour();
  M = minute();
  float S = map(second(),0,59,430,260);
  
  rect(0,height, 250,-150);
  fill(52,117,136);
  rect(250,height,650,-140);
  
  stroke(181,168,79);
  strokeWeight(6);
  strokeCap(SQUARE);
  line(1,250,290,250);
  
  noFill();
  stroke(130,129,119);
  strokeWeight(3);
  arc(406, 301, 310, 304, 0, PI);
  
  noStroke();
  fill(159,87,200);
  ellipse(250,233,30,30);
  
 
  fill(242,97,33);
  triangle(30, 450, 60, S, 90, 450);
  triangle(50, 450, 80, S, 110, 450);
  triangle(70, 450, 100, S, 130, 450);
  triangle(90, 450, 120, S, 150, 450);
  triangle(110, 450, 140, S, 170, 450);
  triangle(130, 450, 160, S, 190, 450);
  
  for (int i = 0; i < M; i++){
   // minuteBalls[i].collide();
    minuteBalls[i].display();
   // minuteBalls[i].move();   
     }
   
  for (int i = 0; i < H; i++){
    hourBalls[i].collide();
    hourBalls[i].display();
    hourBalls[i].move(); 
  }

}

class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  float r, g, b;
  int id;
  int arraySize;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, float ir, float ig, float ib, int iarraySize, Ball[] oin) {
    x = xin;
    y = yin;
    r = ir;
    g = ig;
    b = ib;
    arraySize = iarraySize;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = 0; i < arraySize; i++) {
      if(id != i){
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }


  /////ball constraints

     if (x < 300) {
      vx *= friction; 
    }
    else if (x > 520) {
      vx *= friction; 
  }
     else if (y < 300) {
      vy *= friction; 
    }
    else if (y > 400) {
      vy *= friction; 
  }
  
 //////bubble constraints
 
    if (x < 650) {
      vx *= friction; 
    }
    else if (x > 860) {
      vy *= friction; 
  }
    else if (y < 0) {
      vy *= friction; 
    }
    else if (y > 400) {
      vy *= friction; 
  }
  
  
  }
  
  void display() {
    fill(r, g, b, 150);
    ellipse(x, y, diameter, diameter);
  }
}