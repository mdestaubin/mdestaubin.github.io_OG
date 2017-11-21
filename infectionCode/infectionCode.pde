// Michael de St. Aubin
// Mengze Xu

//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017 

//  WEEK 11: LU + Health Zones + Infection

ASCgrid   LU;
NLCDswatch nlcdColors;        
Lattice LUlat;
PFont txt;

int populationHomeNLCD = 42;   // low density birthplace
int targetAdjacency = 11;      // IS THIS NEEDED ANYMORE?
float birthProb     = 0.005;

ArrayList<Agent> population;
ArrayList<PVector> healthZones;

boolean isSetup = false;

float totalDeaths = 0;
float initPop = 0;

/////////////////////////////////////////////// Code Merge Variables
int initialPopulationSize = 1000;
int dayCounter             = 0;
int framesPerDay           = 72;
int currentPopulationSize  = 0;
int minDays                = 2;
int maxDays                = 21;
int spreadDistance         = 6;
float infectionProbability = 0.1;
float healProbability      = 0.7;

PImage topo;
PImage topo2;
///////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
void setup()
{
  size(841, 800);
  frameRate(24);
  topo  = loadImage( "DATA/haiti2.png" );
  topo2 = loadImage( "DATA/haiti1.png" );
  
  txt = loadFont( "HelveticaNeue-14.vlw" );
  textFont(txt, 12);

  nlcdColors = new NLCDswatch();
  LU = new ASCgrid( "rastert_landcov4.asc" );
  LU.fitToScreen();
  LU.updateImage( nlcdColors.getSwatch() );

  LUlat = new Lattice(LU.w, LU.h);
  fillLattice( LUlat, LU );

  nlcdColors = new NLCDswatch();  

  createPopulation();

  healthZones = new ArrayList<PVector>();
}


///////////////////////////////////////////////////////////////////////
void draw()
{
  background(0);
  image( LU.getImage(), 0, 0 );
  image(topo,0,0);

  for ( PVector P : healthZones) {
    noStroke();
    fill(255,180);
    ellipse( P.x, P.y, 18, 18);
    fill(255,0,0);
    ellipse( P.x, P.y, 5, 5);
  }

  for ( Agent a : population )
  {

    if (isSetup)
    {
      a.update(healthZones);
    }

    a.drawAgent();
  }

  for ( PVector s : healthZones) {
    for ( Agent n : population ) {  
      if (n.loc.x > s.x-5 && n.loc.x < s.x+5 && n.loc.y > s.y-5 && n.loc.y < s.y+5 ) {
        
        if (prob(healProbability) == true) {
           n.getHealed();
        }
        else if(prob(healProbability) == false) {
           n.getDead();
        } 
      }
    }
  }

  if ( frameCount % framesPerDay == 0 )
  {
    currentPopulationSize = population.size();
    removeDead();
    dayCounter += 1;
  }

  infect();
  statsBar();
  
}////////////////////////////////////////////////////// End of Draw Loop


void keyPressed()
{
  ////////////////////////////////////////// Space bar to start simulation
  if ( key == ' ')
  {
    isSetup = true;
    dayCounter = 0;
  }
  
    if ( key == 'x')
  {
    background(0);
    image(topo2,0,0);
  }
  //////////////////////////////////////////// 's' key to add a new Agent
  if ( key == 's')
  {
    Agent infectedPerson = new Agent();
    infectedPerson.getInfected();
    infectedPerson.loc.x = mouseX;
    infectedPerson.loc.y = mouseY;

    population.add(infectedPerson);
  }
  ////////////////////////// 'r' key to reset population and health zones   
  if ( key == 'r')
  {
    population.clear();
    healthZones.clear();
    createPopulation();
    isSetup = false;
    dayCounter = 0;
    totalDeaths = 0;
    loop();
  }
}

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

boolean prob( float probRate )
{
  if (random(0, 1) <= probRate) {
    return true;
  } else {
    return false;
  }
}



void mousePressed()/////////////////////////// click to add Health Zone
{
  healthZones.add(new PVector(mouseX, mouseY));
}

///////////////////////////////////////////////////////////////////////
void fillLattice( Lattice latIn, ASCgrid LUin )
{
  for ( int x = 0; x < LUin.w; x += 1 ) {
    for ( int y = 0; y < LUin.h; y += 1 ) {

      float value = LUin.get(x, y);
      latIn.put(x, y, value  );
    }
  }
}

void createPopulation()
{
  population = new ArrayList<Agent>();
  
  for ( int x = 0; x < LUlat.w; x += 1 ) {
    for ( int y = 0; y < LUlat.h; y += 1 ) {

      int val =  (int) LUlat.get(x, y);
      if ( val == populationHomeNLCD  && random(1.0) <= birthProb )
      {
        Agent temp = new Agent(x, y);
        temp.setHomeClass( populationHomeNLCD );
        population.add( temp );
        initPop = population.size();
      }
    }
  }

  println( "added " + population.size() + " new agents." );
}

/////////////////////////////////////////////////////////
///////////////////////////////////////////////////////// Stats

int xStat      = 30;
int xStat2     = 300;
int xBar       = 760;
int xBar2      = 250;

int yTitle     = 582;
int yDay       = 620;
int yPop       = 640;
int yHealthy   = 735;
int yHealthy2  = 680;
int ySick      = 735;
int ySick2     = 700;
int yInfected  = 735;
int yInfected2  = 720;
int ySurvivors = 630;
int yDead      = 690;
int yHealth    = 660;
int yStaff     = 630;

void statsBar(){
  
  float popSize = population.size() + totalDeaths;
  float numSick = 0;
  float numInfected = 0;
  float numHealed = 0;
  float numHealthy = 0;
  float numZones = healthZones.size();
  
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
    if ( person.dead == false && person.healed == false && person.infected == false && person.sick == false) { 
      numHealthy += 1;
    }
  }
  
  float percentSick = numSick / popSize * 100;
  float percentInfected = numInfected / popSize * 100;
  float percentHealed = numHealed / popSize * 100;
  float percentDead = totalDeaths / popSize * 100;
  float percentHealthy = numHealthy / popSize * 100;
  
  
  fill(255);  
  textAlign(LEFT);
  textSize(24);
  text( "Sud, Haiti",xStat-2, yTitle,360,100);
  textSize(12);
  text( "DAY: " + dayCounter,xStat, yDay);
  text( "POPULATION: " + popSize + " | " + initPop, xStat, yPop);
  text( "NUMBER HEALTHY: " + numHealthy + " | " + nf(percentHealthy, 0, 2)+"%", xStat, yHealthy2);
  text( "NUMBER SICK: " + numSick + " | " + nf(percentSick, 0, 2)+"%", xStat, ySick2);
  text( "NUMBER INFECTED: " + numInfected+ " | " + nf(percentInfected, 0, 2)+"%", xStat, yInfected2);
  text( "SURVIVORS: " + numHealed + " | " + nf(percentHealed, 0, 2)+"%", xStat2, ySurvivors);
  text( "DEATHS: " + totalDeaths + " | " + nf(percentDead, 0, 2)+"%", xStat2, yDead);
  text( "HEALTH ZONES: " + numZones, xStat, yHealth);
  //text( "HEALTH CAPACITY: " + healProbability,xStat, yStaff);
  
  textAlign(LEFT);
  text( "   INSTRUCTIONS", width-240, 630);
  text( "-  PRESS SPACE BAR TO START", width-240, 655);
  text( "-  CLICK TO ADD HEALTH ZONE", width-240, 675);
  text( "- 's' KEY TO ADD SICK AGENT", width-240, 695);
  text( "- 'r' KEY TO RESET SIMULATION", width-240, 715);
  
  
  float xH   = map(percentHealthy,0,100,0,TWO_PI)-HALF_PI;
  float xSi  = map(percentSick,0,100,0,TWO_PI)-HALF_PI;
  float xI   = map(percentInfected,0,100,0,TWO_PI)-HALF_PI;
  float xSu  = map(percentHealed,0,100,0,TWO_PI)-HALF_PI;
  float xD   = map(percentDead,0,100,0,TWO_PI)-HALF_PI;
  float ss   = 0-HALF_PI;
  
  smooth();
  noFill();
  strokeCap(SQUARE); 
  strokeWeight(60);
  stroke(255,150);
  arc(width/2, height/2, 300, 300, ss, xH);
  stroke(255,255,0,150);
  arc(width/2, height/2, 300, 300, ss, xI+xH);
  stroke(255,0,0,150);
  arc(width/2, height/2, 300, 300, ss, xSi+xH+xI);
  stroke(0,255,0,150);
  arc(width/2, height/2, 300, 300, ss, xSu+xH+xI+xSi);
  stroke(138,43,226,150);
  arc(width/2, height/2, 300, 300, ss, xD+xH+xI+xSi+xSu);
  
  
  //float xScale = 100;
    
  //  float xHealthy = map(percentHealthy,0,xScale,0,xBar);
  //  float xSick = map(percentSick,0,xScale,0,xBar);
  //  float xInfected = map(percentInfected,0,xScale,0,xBar);
  //  float xSurvivors = map(percentHealed,0,xScale,0,xBar2);
  //  float xSurvivors2 = map(percentHealed,0,xScale,0,xBar);
  //  float xDead = map(percentDead,0,xScale,0,xBar2);
  //  float xDead2 = map(percentDead,0,xScale,0,xBar);

    //noStroke();
    //fill(255,50);
    //rect(xStat2,ySurvivors+10,xBar2, 20);
    //rect(xStat2,yDead+10,xBar2, 20);
    //rect(xStat,yHealthy+10,xBar, 35);
    
    //fill(255,150);
    //rect(xStat,yHealthy+10,xHealthy, 35);
    //fill(255,0,0,150);
    //rect(xStat+xHealthy+xInfected,ySick+10,xSick, 35);
    //fill(255,255,0,150);
    //rect(xStat+xHealthy,yInfected+10, xInfected, 35);
    //fill(0,255,0,150);
    //rect(xStat+xHealthy+xInfected+xSick,yInfected+10, xSurvivors2, 35);
    //fill(138,43,226,150);
    //rect(xStat+xHealthy+xInfected+xSick+xSurvivors2,yInfected+10, xDead2, 35);
    
    //fill(0,255,0,150);
    //rect(xStat2,ySurvivors+10,xSurvivors, 20);
    //fill(138,43,226,150);
    //rect(xStat2,yDead+10,xDead, 20);
    
      if(numSick == 0 && numInfected == 0 && dayCounter > 10){
    if (looping){
      noLoop();
    } 
      else {
       loop(); 
      }
  }
  
}