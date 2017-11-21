import java.util.Iterator;

class Agent {

  Kernel  k;
  PVector loc;
  PVector vel;
  PVector target;
  int     LUhome;
  float   mag;
  int     kernelSize = 700; 
  boolean foundTarget = false;

  /////////////////////////////////////////// merge variables
  boolean dead = false;
  boolean sick = false;
  boolean healed = false;
  boolean infected = false;
  boolean healthy = true;

  int rad;
  //int perHealthy = 100;
  int days = 0;
  float t = frameCount;
  ////////////////////////////////////////////////////////////

  Agent()
  {
    loc = new PVector( random(width), random(height) );
    vel = new PVector( random(-1, 1), random(-1, 1)   );
    mag = 1;

    k = new Kernel();
    k.isNotTorus();
    k.setNeighborhoodDistance(kernelSize);
  }

  Agent( int x, int y)
  {
    loc = new PVector( x, y );
    vel = new PVector( random(-1, 1), random(-1, 1)   );
    mag = 1;

    k = new Kernel();
    k.isNotTorus();
    k.setNeighborhoodDistance(kernelSize);
  }

  void setHomeClass( int LUclass )
  {
    LUhome = LUclass;
  }

  void findTarget( ArrayList<PVector> healthZones )
  {         
    float minDistance = MAX_FLOAT;

    for (PVector z : healthZones) 
    {
      float distance = loc.dist(z);
      if (distance < minDistance) 
      {
        minDistance = distance;
        target = z;
      }
    }
  }

  void update( ArrayList<PVector> healthZones )
  {   

    if ( sick )
    {
      findTarget(healthZones);
    }

    if ( target != null)
    {
      updateVelocity();
    }

    if (infected)
    { 
      t += 1;
      if (t >= random(72, 504)) {    
        getSick(minDays, maxDays);
      }
    }

    if ( frameCount%framesPerDay == 0 && sick == true)
    {
      days -=1;
      if (days == 0 ) { 
        dead = true;
      }
    }

    loc.add(vel);
    bounce();
  }

  void updateVelocity()
  {
    float    angle = calcRadians( target );
    float      mag = 1;

    // use trig to convert from polar (mag, angle) to cartesian (x,y) coordinates      
    // or decompose an angle into x,y velocity components
    float xVel =  mag*cos( angle );
    float yVel = -mag*sin( angle );

    vel = new PVector(xVel, yVel);
  }

  void getInfected()
  {
    if (healed == false) {
      healthy = false;  
      infected = true;
      t = 0;
    }
  }

  void getSick(int minDay, int maxDay)
  {
    sick = true;
    infected = false;
    healthy = false;  
    days = (int)random(minDay, maxDay);
  }

  void getHealed()
  {
    if (sick) {
      sick = false;
      healed = true;
      target = null;
      dead = false;
      vel = new PVector( random(-1, 1), random(-1, 1)   );
    }
  }
  
    void getDead()
  {
    if (sick) 
    {
    sick = false;
    dead = true;
    }
  }

  void drawAgent()
  {
    if (sick) {
      fill(255);
      rad = 2;
    } 

    if (infected) {
      fill(255); 
      rad = 2;
    } 

    if (healed) {
      fill(0,255,0); 
      rad = 3;
    }

    if (healthy) {
      fill(255); 
      rad = 2;
    }

    noStroke();
    ellipse( loc.x, loc.y, rad, rad);
    
    strokeWeight(5);
    if ( sick ) {
      noFill();
      stroke(255, 0, 0, 150);
      ellipse(loc.x, loc.y, 6, 6);
    }
    if ( healed ) {
      noFill();
      stroke(0, 255, 0, 150);
      ellipse(loc.x, loc.y, 3, 3);
    }
    if ( infected ) {
      noFill();
      stroke(255, 255, 0, 150);
      ellipse(loc.x, loc.y, 6, 6);
    }
  }

  float calcRadians( PVector target )
  {
    float xDiff =  target.x -  loc.x;
    float yDiff = -target.y - -loc.y; // remember positive y on screen is opposite from mathematics

    // doing this in degrees to make it legible
    // SOH CAH TOA , we want TOA. Tan(angle_radians) = opposite/adjacent
    // therefore arctan, or atan(), to find angle
    // need if() statements to acount for all of the obtuse angles (>90_degrees)
    float angle_d = degrees(atan( yDiff / xDiff )); 
    angle_d = (xDiff < 0 ) ? 180+angle_d : (yDiff < 0 ) ? 360+angle_d : angle_d;

    return radians( angle_d );
  }

  void bounce()
  {
    if (loc.x < 0 || loc.x >= width) {
      vel.x *= -1;
    }
    if (loc.y < 0 || loc.y >= height-238) {
      vel.y *= -1;
    }
  }
}

void removeDead()
{
  Iterator iter = population.iterator();
  Agent tempAgent;

  while ( iter.hasNext() )
  {    
    tempAgent = (Agent)iter.next();
    if ( tempAgent.dead == true )
    {
      noStroke();
      fill(138,43,226);
      ellipse( tempAgent.loc.x, tempAgent.loc.y, 25, 25);
      iter.remove();
      totalDeaths += 1;
    }
  }
}