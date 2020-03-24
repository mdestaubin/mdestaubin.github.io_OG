import java.util.Iterator;

class Agent {

  PVector loc;

  PVector vel;

  PVector accel;

  float topspeed;

  boolean dead = false;

  boolean sick = true;

  boolean healed = false;
  
  boolean survive = false;

  boolean infected = false;

  int haloGrowth = 0;

  PVector target;

  int rad;

  int perHealthy = 100;

  int days = 0;

  float t = frameCount;



  Agent(PVector L)

  {

    loc = L;

    vel = new PVector(random(-1, 1), random(-1, 1));

    topspeed = 1.3;

    accel = new PVector(0, 0);

    target = new PVector(random(width), random(height));

    if (random(0, 100) < perHealthy) { 

      sick = false;

    }

  }

  void update()

  {    

    if ( frameCount%framesPerDay == 0 && sick == true)

    {

      days -=1;

      if (days == 0 && prob(0.5)== true) { 
      
        dead = true;
        
      }
      
      else if (days == 0 && prob(0.5) == false){
        
      sick = false;

      infected = false;

      healed = true;

      fill(0, 255, 0);

      ellipse( loc.x, loc.y, 12, 12);

     if( healed ){
     survive = true;
     healed = false;
     
    }
 
      }

    }

    if (infected)

    { 

      t += 1;

      if (t >= random(72,336)) {    

        getSick(minDays, maxDays);

      }

    }

    vel.limit(topspeed);

    loc.add(vel);

   // recovered();

    bounce();

    drawAgent();

  }

  /////////////////////////////////////////////////////////////////// Check Environment Function

  boolean prob(float probRate)

{

    if (random(0, 1) <= probRate) {

        return true;

    } else {

        return false;

    }

}
  

  /////////////////////////////////////////////////////////////////////////////// DrawAgent Function

  void drawAgent()

  {     

    if ( sick ) {

      fill( 255, 0, 0 );

      rad = 10;

    } 

    if (infected) {

      fill(255, 255, 0); 

      rad = 10;

    } 

    else if (healed) {

      fill(0, 255, 0); 

      rad = 6;

    }
    
    else if (survive) {

      fill(69, 255, 150); 

      rad = 10;

    }

    else {

      fill(255); 

      rad = 6;

    }

    noStroke();

    ellipse( loc.x, loc.y, rad, rad);

    //add Halos

    if ( sick == true) {

      fill(255,0,0,100);

      stroke(255, 0, 0, 100);

      ellipse(loc.x, loc.y, 16, 16);

    }

    // if ( healed == true) {

    //  noFill();

    //  stroke(0, 255, 0, 100);

    //  ellipse(loc.x, loc.y, 12, 12);

    //}
    
    //if ( survive == true) {

    //  noFill();

    //  stroke(0, 255, 0, 100);

    //  ellipse(loc.x, loc.y, 16, 16);

    //}

     if (infected == true) {

      noFill();

      stroke(255, 255, 0, 100);

      ellipse(loc.x, loc.y, 16, 16);

    }
  }
  

  void drawHalo()
      {

          if( haloGrowth <= 48 )
          {
              float radius = haloGrowth;
              float alpha  = map(haloGrowth, 0, 48, 255, 0 );
              
              noFill();
              stroke(255, alpha);
              ellipse( loc.x, loc.y, radius, radius ); 
              
              haloGrowth += 1;
          }
      }

  void getInfected()

  {

    if(healed == false){

    infected = true;

    t = 0;

    }

  }

  

  
  void getSick(int minDay, int maxDay)

  {

    sick = true;

    infected = false;

    days = (int)random(minDay, maxDay);

  }



  ///////////////////////////////////////////////////////////////////////////// Bounce Function

  void bounce()

  {

    //bounce checks

    if (loc.x < 0 || loc.x >= width-400) {

      vel.x *= -1;

    }

    if (loc.y < 0 || loc.y >= height) {

      vel.y *= -1;

    }

  }


}//////////////////////////////////// End of Class



//////////////////////////////////////////////////////////////////////////////// Remove Dead

void removeDead()

{

  Iterator iter = population.iterator();

  Agent tempAgent;



  while ( iter.hasNext() )

  {    

    tempAgent = (Agent)iter.next();

    if ( tempAgent.dead == true )

    {

      fill(255, 0, 0);

      ellipse( tempAgent.loc.x, tempAgent.loc.y, 20, 20);

      iter.remove();
      numDead  += 1;

    }

  }

}


void removeSurvivor()

{

  Iterator iter = population.iterator();

  Agent tempAgent;



  while ( iter.hasNext() )

  {    

    tempAgent = (Agent)iter.next();

    if ( tempAgent.healed == true )

    {

      fill(0, 255, 0);

      ellipse( tempAgent.loc.x, tempAgent.loc.y, 40, 40);

      iter.remove();

    }

  }

}
