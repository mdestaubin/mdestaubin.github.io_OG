// Michael de St. Aubin
// Mengze Xu

//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017 

//  Title: Infection Code with Slope

HScrollbar hs1;
HScrollbar hs2;

ASCgrid   DE;   
DEswatch deColors; 
Lattice DElat;

PFont txt;

int populationHomeDE = 1;   // low density birthplace
int targetAdjacency  = 11;      // IS THIS NEEDED ANYMORE?
float birthProb      = 0.03;

ArrayList<Agent> population;
ArrayList<HealthZone> healthZones;

boolean isSetup = false;
boolean imageFlip = false;

float totalDeaths = 0;
float initPop = 0;

int dayCounter             = 0;
int framesPerDay           = 72;
int currentPopulationSize  = 0;
int minDays                = 2;
int maxDays                = 21;
int spreadDistance         = 6;
float infectionProbability = 0.1;
float healProbability      = 0;
float healProbability2     = 0;

PImage topo;
PImage topo2;
PImage scale1;

boolean recording = false;

///////////////////////////////////////////////////////////////////////

void setup()
{
  size(840, 765);
  frameRate(24);
  topo  = loadImage( "DATA/haiti2.png" );
  
  hs1 = new HScrollbar(55, 550, 175, 14, 14);
  hs2 = new HScrollbar(55, 530, 175, 14, 14);

  txt = loadFont( "HelveticaNeue-14.vlw" );
  textFont(txt, 12);

  deColors = new DEswatch ();
  DE = new ASCgrid ("slope_de.asc");
  DE.fitToScreen();
  DE.updateImage(deColors.getSwatch());
 
  DElat = new Lattice(DE.w,DE.h);
  fillLattice( DElat, DE );
  
  deColors = new DEswatch(); 

  createPopulation();

  healthZones = new ArrayList<HealthZone>();
}

///////////////////////////////////////////////////////////////////////

void draw()
{
  background(0);
  tint(255, 150);
  
  if(imageFlip == false){
    image(DE.getImage(), 0, 0);
  }
   else{
    image(topo , 0, 0 );
  }
  
  scrollBar();
  
  for ( HealthZone h : healthZones)
  {
   h.drawCenter();
  }

  for ( Agent a : population )
  {
    if (isSetup)
    {
      float slope = DElat.get((int)a.loc.x, (int)a.loc.y);
      a.update(healthZones, slope);
    }
    a.drawAgent();
  }
  
  for ( HealthZone s : healthZones) {
    for ( Agent n : population ) {  

      if (n.loc.x > s.loc.x-5 && n.loc.x < s.loc.x+5 && n.loc.y > s.loc.y-5 && n.loc.y < s.loc.y+5 ) {
        
        if(s.isTemporary == false){
        if (prob(healProbability) == true) {
          n.getHealed();
        } else if (prob(healProbability) == false) {
          n.getDead();
        }
       }
       
      if(s.isTemporary == true){
        if (prob(healProbability2) == true) {
          n.getHealed();
        } else if (prob(healProbability2) == false) {
          n.getDead();
        }
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
  record();
}////////////////////////////////////////////////////// End of Draw Loop


void scrollBar() {
  
  hs1.updateScroll();
  hs1.displayScroll();
  
  hs2.updateScroll();
  hs2.displayScroll();
  
  float xValue = hs1.getPos();
  float xValue2 = hs2.getPos();
  
  int    aid = round(map(xValue,60,235,0, 100));
  String aidMoney = nfc(aid);
  int    aid2 = round(map(xValue2,60,235,0, 100));
  String aidMoney2 = nfc(aid2);
  
  textSize(12);
  textAlign(LEFT);
  text("% " + aidMoney, hs1.spos+7, hs1.ypos+12);
  text("% " + aidMoney2, hs2.spos+7, hs2.ypos+12);
  fill(255,180);  
  
  text("Aid", 55, hs2.ypos-5);
  text("HZ 1", 25, hs1.ypos+11);
  text("HZ 2", 25, hs2.ypos+11);
  
}

void keyPressed()
{
  if ( key == ' ') // run simulation
  {
    isSetup = true;
    dayCounter = 0;
  }

  if ( key == 'R' ) // record
  {
    recording = !recording;
  }

  if ( key == 's') // sick agent
  {
    Agent infectedPerson = new Agent();
    infectedPerson.getInfected();
    infectedPerson.loc.x = mouseX;
    infectedPerson.loc.y = mouseY;

    population.add(infectedPerson);
  }

  if ( key == 'r') // reset
  {
    population.clear();
    healthZones.clear();
    createPopulation();
    isSetup = false;
    dayCounter = 0;
    totalDeaths = 0;
    loop(); 
  }
  
   if ( key == 'e'){     // alternate image
     imageFlip = true;
  }
     if ( key == 'w'){   // primarey image
     imageFlip = false;
  }
}

void mousePressed() // click to add Health Zone
{
  if(mouseY < 520){
    int x = 0;
    int y = 0;
    
    HealthZone newZone = new HealthZone(x, y, isSetup);

    newZone.loc.x = mouseX;
    newZone.loc.y = mouseY;
    
    healthZones.add(newZone);  
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

void fillLattice( Lattice latIn, ASCgrid DEin ) // fill Lattice
{
  for ( int x = 0; x < DEin.w; x += 1 ) {
    for ( int y = 0; y < DEin.h; y += 1 ) {

      float value = DEin.get(x, y);
      latIn.put(x, y, value  );
    }
  }
}

void createPopulation() // Create Population
{
  population = new ArrayList<Agent>();

  for ( int x = 0; x < DElat.w; x += 1 ) {
    for ( int y = 0; y < DElat.h; y += 1 ) {

      int val =  (int) DElat.get(x, y);
      if ( val == populationHomeDE  && random(1.0) <= birthProb )
      {
        Agent temp = new Agent(x, y);
        temp.setHomeClass( populationHomeDE );
        population.add( temp );
        initPop = population.size();
      }
    }
  }
}

void record() {         // Record Function
  if (recording) {
    saveFrame("output/test_####.png");
    fill(255, 0, 0, 180);
    textSize(18);
    textAlign(RIGHT);
    text("Recording", width-47, 35);
  } else {
    noFill();
  }
  ellipse(width-30, 30, 17, 17);
}

//////////////////////////// Stats Bar

int xStat      = 55;
int xStat2     = 315;
int xBar       = 841;
int xBar2      = 250;

int yTitle     = 577;
int yDay       = 605;
int yPop       = 625;
int yHealthy   = 542;
int yHealthy2  = 680;
int ySick2     = 700;
int yInfected  = 542;
int yInfected2 = 720;
int ySurvivors = 760;
int yDead      = 740;
int yHealth    = 655;
int yStaff     = 615;

void statsBar() {
  
  fill(10);
  noStroke();
  rect(0,567,width,233);

  float popSize = population.size() + totalDeaths;
  float numSick = 0;
  float numInfected = 0;
  float numHealed = 0;
  float numHealthy = 0;
  float numExZone   = 0;
  float numTempZone = 0;
  
  
 for ( HealthZone h : healthZones)
  {
   if(h.isTemporary == true){
    numTempZone += 1; 
   }
   if(h.isTemporary == false){
    numExZone += 1; 
   }
  }

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
  
  float numAffected = numHealed + totalDeaths + numInfected + numSick;
  float caseFatalityRate = totalDeaths/numAffected * 100;
  
  float percentSick = numSick / popSize * 100;
  float percentInfected = numInfected / popSize * 100;
  float percentHealed = numHealed / popSize * 100;
  float percentDead = totalDeaths / popSize * 100;
  float percentHealthy = numHealthy / popSize * 100;
  float percentAffected = numAffected / popSize * 100;
  
  fill(255);  
  textAlign(LEFT);
  textSize(24);
  //text( "Sud, Haiti",xStat-2, yTitle,360,100);
  textSize(12);
  text( "DAY:  " + dayCounter, xStat, yDay+8);
  text( "POPULATION:  " + popSize + " | " + initPop, xStat, yPop+8);
  text( "[HZ 1] EXISTING HEALTH ZONES:  " + numExZone, xStat2, ySick2+3);
  text( "[HZ 2] TEMPORARY HEALTH ZONES:  " + numTempZone, xStat2, yInfected2+3);
  text( "HEALTHY:   " + numHealthy + " | " + nf(percentHealthy, 0, 2)+"%", xStat, yHealth+8);
  text( "SICK:                     " + numSick + " | " + nf(percentSick, 0, 2)+"%", xStat, ySick2+3);
  text( "INFECTED:         " + numInfected+ " | " + nf(percentInfected, 0, 2)+"%", xStat, yHealthy2+3 );
  text( "SURVIVORS:     " + numHealed + " | " + nf(percentHealed, 0, 2)+"%", xStat, yInfected2+3);
  text( "DEATHS:             " + totalDeaths + " | " + nf(percentDead, 0, 2)+"%", xStat, yInfected2+22);
  text( "TOTAL AFFECTED:      " + numAffected + " | " + nf(percentAffected, 0, 2)+"%", xStat2, yHealthy2+3 );
  text( "CASE FATALITY RATE:  " +  nf(caseFatalityRate, 0, 2)+"%", xStat2, yHealth+8);
  
  noStroke();
  ellipse(xStat-15, yHealth+3, 4, 4);
  stroke(255, 48, 36, 150);
  ellipse(xStat-15, ySick2-2, 4, 4);
  stroke(254, 184, 1, 150);
  ellipse(xStat-15, yHealthy2-2, 4, 4);
  stroke(3,191,103,150);
  ellipse(xStat-15, yInfected2-2, 4, 4);
  
  
  textAlign(LEFT);
  text( "    INSTRUCTIONS", width-220, yHealth-32);
  text( "-  Press space bar to start", width-220, yHealth-12);
  text( "-  Click to add Health Zone", width-220, yHealth+8);
  text( "- 's' Key to add Sick Agent", width-220, yHealthy2+3);
  text( "- 'r' Key to reset simulation", width-220, ySick2+3);
  text( "- 'R' Key to record video", width-220, yInfected2+22);
  text( "- 'e + w' Keys to toggle maps", width-220, yInfected2+3);


  //float xH   = map(percentHealthy,0,100,0,TWO_PI)+HALF_PI;
  //float xSi  = map(percentSick,0,100,0,TWO_PI)+HALF_PI;
  //float xI   = map(percentInfected,0,100,0,TWO_PI)+HALF_PI;
  //float xSu  = map(percentHealed,0,100,0,TWO_PI)+HALF_PI;
  //float xD   = map(percentDead,0,100,0,TWO_PI)+HALF_PI;
  //float ss   = HALF_PI;

  //float healthRadian = radians(xH);
  //float infectedRadian = radians(xI);
  //float sickRadian = radians(xSi);
  //float surviveRadian = radians(xSu);
  //float deadRadian = radians(xD);

  //beginShape();
  //smooth();
  //noFill();
  //strokeCap(SQUARE); 
  //strokeWeight(10);
  //stroke(255,150);
  //arc(width-120, height-340, 130, 130, ss, xH);
  //stroke(255,255,0);
  //arc(width-120, height-340, 110, 110, ss, xI);
  //stroke(255,0,0,150);
  //arc(width-120, height-340, 90, 90, ss, xSi);
  //stroke(0,255,0,150);
  //arc(width-120, height-340, 70, 70, ss, xSu);
  //stroke(138,43,226,150);
  //arc(width-120, height-340, 50, 50, ss, xD) ;
  //endShape();

  float xScale = 100;

  float xHealthy = map(percentHealthy, 0, xScale, 0, xBar);
  float xSick = map(percentSick, 0, xScale, 0, xBar);
  float xInfected = map(percentInfected, 0, xScale, 0, xBar);
  // float xSurvivors = map(percentHealed, 0, xScale, 0, xBar2);
  float xSurvivors2 = map(percentHealed, 0, xScale, 0, xBar);
  // float xDead = map(percentDead, 0, xScale, 0, xBar2);
  float xDead2 = map(percentDead, 0, xScale, 0, xBar);

  noStroke();
  fill(255,50);
  rect(0, yHealthy+25, xHealthy, 15);
  fill(255, 48, 36);
  rect(xHealthy+xInfected, yInfected+25, xSick, 15);
  fill(254, 184, 1);
  rect(xHealthy, yInfected+25, xInfected, 15);
  fill(3,191,103);
  rect(xHealthy+xInfected+xSick, yInfected+25, xSurvivors2, 15);
  fill(250, 0, 149);
  rect(xHealthy+xInfected+xSick+xSurvivors2, yInfected+25, xDead2, 15);

  if (numSick == 0 && numInfected == 0 && dayCounter > 10) {
    if (looping) {
      recording = !recording;
      noLoop();
    } else {
      loop();
    }
  }
}