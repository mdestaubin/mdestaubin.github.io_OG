int h;
ArrayList<Ball> balls;
int ballWidth = 5;
int time;

void setup()
{
    size(500,720);
    
    noFill();
    noStroke();
    
      // Create an empty ArrayList (will store Ball objects)
  balls = new ArrayList<Ball>();
  
  // Start by adding one element
  balls.add(new Ball(width/2, 0, ballWidth));
}

void draw(){
  background(255);
    int h = (hour()*60*60) + (minute()*60) + second();    
    float H = map(h,0,86399,0,720);
    
    
    
    for (int i = balls.size()-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Ball ball = balls.get(i);
    ball.move();
    ball.display();
   if (ball.finished()) {
      //Items can be deleted with remove()
      balls.remove(i);
    }
    
    if( (second()) - time > 1)
    {
    balls.add(new Ball(random(0,width), 0, ballWidth));
    time = second();
    }
    
    fill(0);
    rect(0,height,width,H*-1);

   
    fill(100);
    text("11 PM",0,30);
    text("10 PM",0,60);
    text("9 PM",0,90);
    text("8 PM",0,120);
    text("7 PM",0,150);
    text("6 PM",0,180);
    text("5 PM",0,210);
    text("4 PM",0,240);
    text("3 PM",0,270);
    text("2 PM",0,300);
    text("1 PM",0,330);
    text("12 PM",0,360);
    text("11 AM",0,390);
    text("10 AM",0,420);
    text("9 AM",0,450);
    text("8 AM",0,480);
    text("7 AM",0,510);
    text("6 AM",0,540);
    text("5 AM",0,570);
    text("4 AM",0,600);
    text("3 AM",0,630);
    text("2 AM",0,660);
    text("1 AM",0,690);
    text("12 AM",0,720);
  }
}
    
class Ball {
  
  float x;
  float y;
  float speed;
  float gravity;
  float w;
  float life = 255;
  
  Ball(float tempX, float tempY, float tempW) {
    x = tempX;
    y = tempY;
    w = tempW;
    speed = 0;
    gravity = 0.1;
  }
  
    void move() {
    // Add gravity to speed
    speed = speed + gravity;
    // Add speed to y location
    y = y + speed;

  }
  
  boolean finished() {
    // Balls fade out
    life--;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    // Display the circle
    fill(0,life);
    //stroke(0,life);
    ellipse(x,y,w,w);
  }
}  