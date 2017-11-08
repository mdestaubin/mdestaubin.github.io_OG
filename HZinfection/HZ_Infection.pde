//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017
//  Please cite author and course 
//  when using this library in any 
//  personal or professional project.

//  WEEK 05 : SIMPLE POPULATION MODEL WITH "EVOLUTION"

int initialPopulationSize = 850;
ArrayList<Agent> population;
int dayCounter = 0;
int framesPerDay = 24;
int currentPopulationSize = 0;
float popFluxRate = 0.001250;

PVector H1 = new PVector(180, 172);
PVector H2 = new PVector(1017, 642);
PVector H3 = new PVector(600, 400);
PVector H4 = new PVector(180, 642);
PVector H5 = new PVector(1017, 172);

PImage healthZone;
//////////////////////// infection variables
int   minDays              = 2;
int   maxDays              = 21;
int   spreadDistance       = 6;
float infectionProbability = 0.5;


void setup()
{
  size(1200, 800);
  frameRate( 24 );
  population = new ArrayList<Agent>();
  healthZone  = loadImage( "DATA/zones4.png" ); 

  initailizePop();
}

void draw()
{
  background( 0 );
  image( healthZone, 0, 0 );

  for ( Agent a : population ) {

    PVector I = new PVector(a.loc.x, a.loc.y);

    float h1 = PVector.dist(I, H1); 
    float h2 = PVector.dist(I, H2);
    float h3 = PVector.dist(I, H3);
    float h4 = PVector.dist(I, H4);
    float h5 = PVector.dist(I, H5);

    if (h1 < h2 && h1 < h3 && h1 < h4  && h1 < h5) {
      a.update(H1);
    }
    if (h2 < h1 && h2 < h3 && h2 < h4 && h2 < h5) {
      a.update(H2);
    }
    if (h3 < h1 && h3 < h2 && h3 < h4 && h3 < h5) {
      a.update(H3);
    }
    if (h4 < h1 && h4 < h2 && h4 < h3 && h4 < h5) {
      a.update(H4);
    }   
    if (h5 < h1 && h5 < h2 && h5 < h3 && h5 < h4) {
      a.update(H5);
    }
  }



  ///////////////////////////////////////////////////////////////////////////YEARLY CENSUS

  if ( frameCount % framesPerDay == 0 )
  {
    currentPopulationSize = population.size();
    removeDead();
    //popFlux();  
    //println( "DAY: " + dayCounter + "  POP: " + currentPopulationSize );
    dayCounter += 1;
  }

  infect();
  statsBar();
}
////////////////////////////////////////////////////////////////////////////// STATS BAR  
void statsBar() {

  float popSize = population.size();
  float numSick = 0;
  float numInfected = 0;
  float numHealed = 0;
  float numDead = 0;
  
  for (Agent person : population) {
    if ( person.sick == true) { 
      numSick += 1;
    }
  }
  for (Agent person : population) {
    if ( person.infected == true) { 
      numInfected += 1;
    }
  }
  for (Agent person : population) {
    if ( person.healed == true) { 
      numHealed += 1;
    }
  }
  for (Agent person : population) {
    if ( person.dead == true) { 
      numDead += 1;
    }
  }
  float percentSick = numSick / popSize * 100;
  float percentInfected = numInfected / popSize * 100;
  float percentHealed = numHealed / popSize * 100;
  float percentDead = numDead / popSize * 100;


  fill(255);  
  textAlign(LEFT);
  text( "DAY: " + dayCounter +"  |  POPULATION: " + currentPopulationSize + " / " + initialPopulationSize + "  |  NUMBER SICK: " + numSick + " (" + nf(percentSick, 0, 2)+"%)"+  "  |  NUMBER INFECTED: " + numInfected+ " (" + nf(percentInfected, 0, 2)+"%)" +  "  |  SURVIVORS: " + numHealed + " (" + nf(percentHealed, 0, 2)+"%)" +  "  |  NON SURVIVORS: " + numDead + " (" + nf(percentDead, 0, 2)+"%)", 12, height - 12);
  textAlign(RIGHT);
  text("HEALTH ZONES: 5       HEALTH STAFF: 20", width-23, height -12);
  textAlign(CENTER);

  text( " CLICK TO ADD SICK AGENT  | |  SPACE BAR TO RESET", width/2, height -55);

  stroke(255);
  strokeWeight(1);
  line(0, height-35, width, height-35);
  line(1200, 0, 1200, height-35);
}
/////////////////////////////////////////////////////////////////////////// Infect
void infect()
{

  for ( int i = 0; i < population.size(); i += 1) {

    Agent person1 = population.get(i);

    for ( int j = i + 1; j < population.size(); j += 1) 
    {
      Agent person2 = population.get(j);
      float distance = dist( person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

      // first condition
      if ( distance <= spreadDistance && person1.sick && !person2.sick)
      {

        ////////////////////// delay getting sick for X nbr of days? ////////////////////////

        //person 1 makes person 2 sick
        if (prob(infectionProbability) == true) {
          person2.getInfected();
        }
      } else if ( distance <= spreadDistance && person2.sick && !person1.sick)
      {
        //person2 makes person1 sick
        if ( prob(infectionProbability) == true) {
          person1.getInfected();
        }
      }
      //infectionLine(person1, person2);
    }
  }
}

///////////////////////////////////////////////////////////////////////Probability Rate
boolean prob( float probRate )
{
  if (random(0, 1) <= probRate) {
    return true;
  } else {
    return false;
  }
}
/////////////////////////////////////////////////////////////////////// Initailize Pop
void initailizePop() {
  for ( int i = 0; i < initialPopulationSize; i += 1 )
  {
    PVector L = new PVector(random(0, width), random(0, height-35));    
    population.add(  new Agent(L)  );
  }
}

void infectionLine(Agent person1, Agent person2) {

  if (person1.infected && person2.infected) {
    stroke(255, 40);
    strokeWeight(1);
    line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
  }
}

////////////////////////////////////////////////////////////////////////////////Pop Flux
void popFlux()
{
  int numberToFlux = round( popFluxRate * currentPopulationSize );
  PVector H = new PVector(random(0, width), random(0, height-35));

  while ( numberToFlux > 0 )
  {
    Agent parent = population.get( (int)random( population.size() ) );
    Agent child  = new Agent(H);

    // Child gets velocity from "parent" rather than
    // having it randomly assigned.
    child.vel    = new PVector( parent.vel.x, parent.vel.y );

    population.add( child );
    numberToFlux -= 1;
  }
}

//============================================================//
void mousePressed()
{
  PVector L = new PVector(random(0, width), random(0, height-35));

  Agent infectedPerson = new Agent(L);
  infectedPerson.getInfected();
  infectedPerson.loc.x = mouseX;
  infectedPerson.loc.y = mouseY;

  population.add( infectedPerson);
}

////////////////////////////////////////////////////////////////////////////////// Reset
void keyPressed()
{
  if ( key == ' ') {  

    population.clear();
    for ( int i = 0; i < initialPopulationSize; i += 1 )
    {
      PVector L = new PVector(random(0, width), random(0, height-35));    
      population.add(  new Agent(L)  ); 
      dayCounter = 0;
    }
  }
}

import java.util.Iterator;

class Agent {

  PVector loc;
  PVector vel;
  PVector accel;
  float topspeed;
  boolean dead = false;
  boolean sick = true;
  boolean healed = false;
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


  void update(PVector T)
  {    
    if (sick) {
      target = T;
      PVector dir = PVector.sub(target, loc);  // Find vector pointing towards mouse
      dir.normalize();     // Normalize
      //dir.mult(10);        // Scale 
      accel = dir;  // Set to acceleration

      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      vel.add(accel);
    } else {
      accel = new PVector(0, 0);
    }

    if ( frameCount%framesPerDay == 0 && sick == true)
    {
      days -=1;
      if (days == 0 ) { 
        dead = true;
      }
    }

    if (infected)
    { 
      t += 1;
      if (t >= random(72,504)) {    
        getSick(minDays, maxDays);
      }
    }

    vel.limit(topspeed);
    loc.add(vel);

    checkEnvironment( healthZone );
    bounce();
    drawAgent();
  }

  /////////////////////////////////////////////////////////////////// Check Environment Function
  void checkEnvironment(PImage healthZone )
  {
    int pixelValue = healthZone.get( (int)loc.x, (int)loc.y );
    float healthValue = red( pixelValue );
    // float deathProbability = map( deathValue, 0, 255, 0.0, 1.0 );

    if ( healthValue >= 230 && sick == true )
    {
      sick = false;
      infected = false;
      healed = true;
      vel.x *= -2;
      vel.y *= -2;

      fill(0, 255, 0);
      ellipse( loc.x, loc.y, 12, 12);
    }
    /////////////////////////////////////////////////////////////////// Death Zones //////////////
 if (loc.x > 177 && loc.x < 182 && loc.y > 169 && loc.y <175 && sick == true) 
    {
      dead = true;
      fill(255, 0, 0,150);
      noStroke();
      ellipse(loc.x, loc.y, 20, 20);
    }
    if (loc.x > 1015 && loc.x < 1020 && loc.y > 639 && loc.y < 645 && sick == true )
    {
      dead = true;
      fill(255, 0, 0,150);
      noStroke();
      ellipse(loc.x, loc.y, 20, 20);
    }
    if (loc.x > 600 && loc.x < 602 && loc.y > 397 && loc.y < 402 && sick == true)
    {
      dead = true;
      fill(255, 0, 0,150);
      noStroke();
      ellipse(loc.x, loc.y, 20, 20);
    }
    if (loc.x > 1015 && loc.x < 1020 && loc.y > 169 && loc.y <175 && sick == true)
    {
      dead = true;
      fill(255, 0, 0,150);
      noStroke();
      ellipse(loc.x, loc.y, 20, 20);
    }
    if (loc.x > 177 && loc.x < 182 && loc.y > 639 && loc.y < 645 && sick == true )
    {
      dead = true;
      fill(255, 0, 0,150);
      noStroke();
      ellipse(loc.x, loc.y, 20, 20);
    }
  }

  /////////////////////////////////////////////////////////////////////////////// DrawAgent Function
  void drawAgent()
  {     
    if ( sick ) {
      fill( 255, 0, 0 );
      rad = 3;
    } 
    if (infected) {
      fill(255, 255, 0); 
      rad = 3;
    } 
    else if (healed) {
      fill(0, 255, 0); 
      rad = 3;
    }
    else {
      fill(255); 
      rad = 3;
    }

    noStroke();
    ellipse( loc.x, loc.y, rad, rad);

    //add Halos
    if ( sick == true) {
      fill(255,0,0,150);
      stroke(255, 0, 0, 100);
      ellipse(loc.x, loc.y, 10, 10);
    }
     if ( healed == true) {
      noFill();
      stroke(0, 255, 0, 100);
      ellipse(loc.x, loc.y, 10, 10);
    }
     if (infected == true) {
      noFill();
      stroke(255, 255, 0, 100);
      ellipse(loc.x, loc.y, 10, 10);
    }
  }
  //////////////////////////////////////////////////////////////////////////// get sick

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
    if (loc.x < 0 || loc.x >= width) {
      vel.x *= -1;
    }
    if (loc.y < 0 || loc.y >= height-35) {
      vel.y *= -1;
    }
  }

  //void drawHalo()
  //  {

  //    if ( haloGrowth <= 15)
  //    {
  //      float radius = haloGrowth;
  //      float alpha  = map(haloGrowth, 0, 20, 255, 0 );

  //      noFill();
  //      stroke(0, 255, 0,alpha);
  //      ellipse( loc.x, loc.y, radius, radius ); 

  //      haloGrowth += 1;
  //    }
  //  }
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
    }
  }
}