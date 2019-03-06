//  Ebola Outbreak Response Simulator 
//  MDES Risk + Resilience Open Project
//  Michael de St. Aubin

//  Credits to: 
//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017 

//======================================================

Cost      cst;                 
int       ROADVALUE = 1;    
ASCgrid   roadASC; 
ASCgrid   DE;   
DEswatch deColors; 
Lattice DElat;

HScrollbar hs1;
HScrollbar hs2;
HScrollbar hs3;
HScrollbar hs4;

ArrayList<Lattice> ccs; 
ArrayList<Cost>    ccsIn;

ArrayList<PVector> targets;
ArrayList<HealthZone> healthZones;

ArrayList<Agent> population;
ArrayList<MultiTargetFinder> cars; 
ArrayList<Agent> survivor;
ArrayList<Agent> popRecord;

ArrayList<Float> sickHistory;
ArrayList<Float> survivorHistory;
ArrayList<Float> deathHistory;
ArrayList<Float> seekHistory;

PImage topo;
PImage topo2;

boolean recording  = false;
boolean isSetup    = false;
boolean imageFlip  = false;
boolean imageFlip2  = false;
boolean pop        = false;
boolean reset      = false;
boolean popRec     = false;
boolean adjust     = false;
boolean adjust2    = false;
boolean viz        = false;

//mangina
//float initPop                 =  0;
//int   populationHome5         =  1;   
//float birthProb5              =  0.0005;
//int   populationHome4         =  4;   
//float birthProb4              =  0.0005;
//int   populationHome3         =  3;   
//float birthProb3              =  0.007;
//int   populationHome2         =  2;   
//float birthProb2              =  0.007;

//north kivu region
float initPop                 =  0;
int   populationHome5         =  1;   
float birthProb5              =  0.0015;
int   populationHome4         =  4;   
float birthProb4              =  0.015;
int   populationHome3         =  3;   
float birthProb3              =  0.0075;
int   populationHome2         =  2;   
float birthProb2              =  0.0015;

//float initPop                 =  0;
//int   populationHome5         =  1;   
//float birthProb5              =  0.00075;
//int   populationHome4         =  4;   
//float birthProb4              =  0.006;
//int   populationHome3         =  3;   
//float birthProb3              =  0.0015;
//int   populationHome2         =  2;   
//float birthProb2              =  0.001;


//float birthProbLow                =  0.1;

int dayCounter             = 0;
int framesPerDay           = 16;
int burialTime             = 0;
int minDays                = 2;
int maxDays                = 21;

int spreadDistance         = 10;
int deadSpreadDistance     = 18;
float infectionProbability = 0.02; 
float deadInfectionProbability = 0;
float healProbability      = 0;
float healProbability2     = 0;


int currentPopulationSize  = 0;
int currentHealed          = 0;

float totalDeaths      = 0;
float numHealed        = 0;
float numHospHeal      = 0;
float numHospNoHeal    = 0;
float numIsolationHeal = 0;
float deathsPerDay     = 0;

float xCord  = 0;
float xCord1 = 0;
float xCord2 = 0;
float yCord  = 930;
float yCord2 = 1075;
int   h      = 0;
float prevX;
float prevYSick;
float seekLine;

int   rectX, rectY; 
int   rectWidth = 15;
int   rectHeight = 15;
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
boolean info = true;


int yTitle     = 959;
int xStat      = 1335;
int xStat2     = 1435;
int xStat3     = 1525;
int xStat4     = 1635;
int xStat5     = 1685;
int xStat6     = 1840;
int y1         = 985;
int y2         = 1010;
int y3         = 1035;
int y4         = 1060;

int xbar       = 1685;

//===========================================================//  setup

void setup()
{
  size(1920, 1080);
  //fullScreen();
  //background(0);
  frameRate(12);

  deColors = new DEswatch ();
  //DE = new ASCgrid ("DATA/newpopzoom3.asc");
    DE = new ASCgrid ("DATA/newpop5.asc");
  //DE = new ASCgrid ("DATA/pop8.asc");
  //DE = new ASCgrid ("DATA/mpop1.asc");
  //DE = new ASCgrid ("DATA/bp4.asc");
  //DE = new ASCgrid ("DATA/epicpop2.asc");
  //DE = new ASCgrid ("DATA/newregionpop.asc");
  DE.fitToScreen();
  DE.updateImage(deColors.getSwatch());

  DElat = new Lattice(DE.w, DE.h);
  fillLattice( DElat, DE );
    
  //topo  = loadImage( "DATA/newbackzoom.png" );
    topo  = loadImage( "DATA/newback.png" );
  //topo  = loadImage( "DATA/back3.png" );
  //topo  = loadImage( "DATA/mbback2.png" );
  //topo  = loadImage( "DATA/bikoroback2.png" );
  //topo  = loadImage( "DATA/epicback3.png" );
  //topo  = loadImage( "DATA/newregionback3.png" );
  //topo2  = loadImage( "DATA/newregionback_nolabels.png" );
  topo2  = loadImage( "DATA/newback_nolabel.png" );
    
  //roadASC = new ASCgrid("DATA/newroadzoom.asc");
    roadASC = new ASCgrid("DATA/newroad.asc");
  //roadASC = new ASCgrid("DATA/road1.asc");
  //roadASC = new ASCgrid("DATA/mroad2.asc");
  //roadASC = new ASCgrid("DATA/br8.asc");
  //roadASC = new ASCgrid("DATA/epicroad6.asc");
  //roadASC = new ASCgrid("DATA/newregion6.asc");
  roadASC.fitToScreen2();

  hs1 = new HScrollbar(xbar, 845, 200, 11, 14);
  hs2 = new HScrollbar(xbar, 905, 200, 11, 14);
  hs3 = new HScrollbar(xbar, 865, 200, 11, 14);
  hs4 = new HScrollbar(xbar, 885, 200, 11, 14);

  targets =   new ArrayList<PVector>();
  popRecord = new ArrayList<Agent>();
  ccs =       new ArrayList<Lattice>();
  ccsIn =     new ArrayList<Cost>();

  for ( PVector t : targets )
  {        
    cst = new Cost( roadASC, ROADVALUE ); 
    cst.moreOptimal = true;
    Lattice l = cst.getCostSurface( t );    
    ccs.add( l ); 
    cst.targetLocation = t;
    ccsIn.add(cst);
  }                         

  cars = new ArrayList<MultiTargetFinder>();
  createPopulation();
  
  healthZones = new ArrayList<HealthZone>();

  sickHistory =     new ArrayList<Float>();
  survivorHistory = new ArrayList<Float>();
  deathHistory =    new ArrayList<Float>();
  seekHistory =     new ArrayList<Float>();

  rectColor =     color(0);
  rectHighlight = color(255);
  rectX = xStat3-45;
  rectY = yTitle-6;
};

//===========================================================// DRAW LOOP

void draw()
{    
  background(0);

  visualization();
  dataViz();
  dataRecord();
  simulation();
  //fill(0);
  //noStroke();
  //rectMode(CORNER);
  //rect(0, yCord2-127, 6, -15);
  record();

  if (viz) {
    vizWindow();
  }

  if (frameCount%24 == 0) {
    //println("pop = " x+population.size());
    //println("cars = " +cars.size());
    //println("survivor = " +survivor.size());
    //println("poprecord = " +popRecord.size());
    //println("healthzones = " + healthZones.size());
    //println("targets = " + targets.size());
  }
};

//===========================================================// SIMULATION

void simulation()
{  
  //noStroke();
  //fill(0);
  //rect(0,0,width,951);
  ////tint(255, 210);

  if (imageFlip == false && imageFlip2 == false) {
    image(roadASC.getImage(), 0, 0);
  } else if (imageFlip == true && imageFlip2 == false) {
    image(topo, 0, 0);
  } else if (imageFlip == false && imageFlip2 == true) {
    image(topo2, 0, 0);
  }

  scrollBar();
  //drawTargets();

  ccsIn = new ArrayList<Cost>();

  for ( PVector t : targets )
  {        
    cst = new Cost( roadASC, ROADVALUE ); 
    cst.moreOptimal = true;
    cst.targetLocation = t;
    ccsIn.add(cst);
  }    

  for ( HealthZone h : healthZones)
  {
    h.drawCenter();
  }

  for ( Agent a : population )
  {
    if (isSetup)
    {
      float slope = 0.1;
      a.update(healthZones, slope);
    }

    if (pop)
    {
      a.drawAgent();
    }
  }

  for (Agent p : popRecord) {
    if (p.deceased) {
      float slope = 0.1;
      p.drawAgent(); 
      p.update(healthZones, slope);
    }
  }

  for ( MultiTargetFinder c : cars ) {
    c.pickTarget(ccsIn);
    //c.findTarget(healthZones);
    c.update(ccs);
    c.drawAgent();
    c.updateHealth();
  }

  infect();

  if ( frameCount % framesPerDay == 0 )
  {
    currentPopulationSize = population.size();
    removeDeadCar();
    removeDead();
    removeDeceased();
    dayCounter += 1;
  }

  button();

}


void visualization() {

  //rectMode(CORNER);
  //noStroke();
  //fill(0);
  //rect(0, 930, width, 100);

  float popSize = population.size() + totalDeaths;
  float numSick = 0;
  float numInfected = 0;
  // float numHealed = 0;
  float numHealthy = 0;
  float numExZone   = 0;
  float numTempZone = 0;
  //float numIsolationHeal = 0;
  //float numHospHeal = 0;
  //float numHospNoHeal = 0;
  float numNoSeekNoHeal = 0;


  for ( HealthZone h : healthZones)
  {
    if (h.isTemporary == true) {
      numTempZone += 1;
    }
    if (h.isTemporary == false) {
      numExZone += 1;
    }
  }

  for (MultiTargetFinder person : cars) {
    if ( person.sick == true) { 
      numSick += 1;
    }
  }

  for (Agent person : population) {
    if ( person.sick == true) { 
      numSick += 1;
    }
  }

  for (MultiTargetFinder person : cars) {
    if (person.infected == true) { 
      numInfected += 1;
    }
  }
  for (Agent person : population) {
    if (person.infected == true) { 
      numInfected += 1;
    }
  }
  //for (Agent person : popRecord) {
  //  if ( person.returned == true) { 
  //    numHealed += 1;
  //  }
  //}

  for (Agent person : population) {
    if ( person.surviveNo == true) { 
      numIsolationHeal += 1;
    }
  }

  //for (Agent person : population) {
  //  if ( person.noSeek == true) { 
  //    numNoSeek += 1;
  //  }
  //}

  //for (MultiTargetFinder person : cars) {
  //  if (  person.seekHeal == true) { 
  //    numHospHeal += 1;
  //  }
  //}

  //for (MultiTargetFinder person : cars) {
  //  if (  person.seekNoHeal == true) { 
  //    numHospNoHeal += 1;
  //  }
  //}


  for (MultiTargetFinder person : cars) {
    if (  person.noSeekNoHeal == true) { 
      numNoSeekNoHeal += 1;
    }
  }

  for (Agent person : population) {
    if ( person.dead == false && person.healed == false && person.infected == false && person.sick == false) { 
      numHealthy += 1;
    }
  }
  //------------------------------------------------------------// bottom data bar  

  float xValue3 = hs3.getPos();
  float pub = round(map(xValue3, xbar+95, xbar + 305, 0, 100));

  seekLine = pub;

  sickHistory.add(yCord-(numSick*5));
  survivorHistory.add(yCord-((numHealed+totalDeaths))*2.5);
  deathHistory.add(yCord-(totalDeaths)*2.5);
  seekHistory.add(seekLine); 

  //fill(255);
  //rect(0,yCord2-120,15,-15);

  strokeWeight(1);
  fill(150);
  stroke(150);

  for ( int i = 0; i < 120; i += 20) {
    for ( int p = 0; p <= 100; p += 20) {
      stroke(70);
      line(0, yCord2-20-i, 1273, yCord2-20-i);
    }
  }

  for ( int i = 0; i < 1290; i += 67) { 
    for ( int p = 0; p <= 20; p += 1) {
      stroke(40);
      line(0+i, yCord2, 0+i, yCord2-145);
    }
  }

  for ( int i = 1; i < 1290; i += 67) {
    textAlign(CENTER);
    text(round((i/9)/7), 0+i, yCord2-127);
    textAlign(LEFT);
    noStroke();
    text("WEEK", 8, yCord2-127);
  }

  for ( int p = 0; p <= 110; p += 20) {
    textAlign(LEFT);
    if (!adjust && !adjust2) { 
      if (p > 0) { 
        text((p/5)*2, 1280, yCord2-p+5);
      }
    } else if (!adjust && adjust2) {
      text((p/5)*4, 1278, yCord2-p+5);
    }
  }

  fill(0);
  rectMode(CORNER);
  rect(0, yCord2-127, 6, -15);
  fill(150);

  xCord = 0;

  for (int i = 0; i < frameCount; i++) 
  {
    Float ySick   = sickHistory.get(i);

    if (numSick <= 40) { 
      adjust = false; 
      adjust2 = false;
      ySick   = (ySick+yCord)/2;
      //println( "ysick 1 =" + ySick);
    } else if (numSick > 40) {
      // adjust = false; 
      adjust2 = true;
      ySick   = (ySick*1.155 +yCord)/2;
      //println( "ysick 2 =" + ySick);
    }

    //simulation data// 
    strokeWeight(2);
    stroke(255, 48, 36);
    line(xCord, ySick+145, xCord, ySick+145);
    stroke(255, 48, 36, 20);
    line(xCord, ySick+145, xCord, yCord2);
    stroke(3, 191, 103);

    //existing data// 
    strokeWeight(1);

    stroke(200);
    line(67*8, yCord2-0, 67*8, yCord2-120); 

      stroke(70, 70, 70); 
    //if (!adjust && !adjust2) {
      //line(0, yCord2-0, 67*6, yCord2 - 40/2);  
      //line(67*6, yCord2 - 40/2, 67*7, yCord2 - 104/2);
      //line(67*7, yCord2 - 104/2, 67*8, yCord2 - 56/2);
      //line(67*8, yCord2 - 56/2, 67*9, yCord2 - 80/2);
      //line(67*9, yCord2 - 80/2, 67*10, yCord2 - 24/2);
      //line(67*10, yCord2 - 24/2, 67*11, yCord2 - 16/2);
      //line(67*11, yCord2 - 16/2, 67*12, yCord2);
      //line(67*12, yCord2, 67*13, yCord2-56/2);
      //line(67*13, yCord2-56/2, 67*14, yCord2);
      //line(67*14, yCord2, 67*19, yCord2);
    //}

    //else if(adjust && !adjust2){
    //line(0,yCord2 - 40/2, 67, yCord2 - 104/2);
    //line(67,yCord2 - 104/2, 67*2, yCord2 - 56/2);
    //line(67*2, yCord2 - 56/2, 67*3, yCord2 - 80/2);
    //line(67*3, yCord2 - 80/2, 67*4, yCord2 - 24/2);
    //line(67*4, yCord2 - 24/2, 67*5, yCord2 - 16/2);
    //line(67*5, yCord2 - 16/2, 67*6, yCord2);
    //line(67*6, yCord2, 67*7, yCord2-56/2);
    //line(67*7, yCord2-56/2, 67*8, yCord2);
    //line(67*8, yCord2, 67*19, yCord2);
    //} else if (adjust2 && !adjust) {
      //line(0, yCord2 - 40/4, 67, yCord2 - 104/4);
      //line(67, yCord2 - 104/4, 67*2, yCord2 - 56/4);
      //line(67*2, yCord2 - 56/4, 67*3, yCord2 - 80/4);
      //line(67*3, yCord2 - 80/4, 67*4, yCord2 - 24/4);
      //line(67*4, yCord2 - 24/4, 67*5, yCord2 - 16/4);
      //line(67*5, yCord2 - 16/4, 67*6, yCord2);
      //line(67*6, yCord2, 67*7, yCord2-56/4);
      //line(67*7, yCord2-56/4, 67*8, yCord2);
      //line(67*8, yCord2, 67*19, yCord2);
    //}

    xCord = xCord + 0.6;
  }

  fill(0);
  stroke(100);
  strokeWeight(2);
  line(0, 1074, width, 1074);
  stroke(200);
  //line(0, yCord, width, yCord);
  //line(0, yCord2-145, width, yCord2-145);
  strokeWeight(1);
  // line(0, height-125, width, height-125);
  //line(0,yCord-100,1215,yCord-100);
  noStroke();
  rect(0, 1075, 1308, 5);

  float numAffected = numHealed + totalDeaths + numInfected + numSick;
  float caseFatalityRate = totalDeaths/(numHealed+totalDeaths) * 100;

  float percentSick = numSick / popSize * 100;
  float percentInfected = numInfected / popSize * 100;
  float percentHealed = numHealed / popSize * 100;
  float percentDead = totalDeaths / popSize * 100;
  float percentHealthy = numHealthy / popSize * 100;
  float percentAffected = numAffected / popSize * 100;
  float percentIncidence = numAffected / dayCounter;  
  float popDensity = popSize / 22000 * 10;
  //float percentHospHeal = 100-caseFatalityRate;
  float percentIsolationHeal = numIsolationHeal/(numIsolationHeal+numNoSeekNoHeal);
  float percentHospHeal = numHospHeal/(numHospHeal+numHospNoHeal);


  noStroke();
  fill(0);
  rect(1308, yCord, 800, 800);
  fill(255);
  strokeWeight(1);
  stroke(150);
 // line(0, yCord, width, yCord);
  line(1308, yCord, 1308, yCord+150);
  
  textAlign(LEFT);
  textSize(15);
  text("EBOLA OUTBREAK", xStat, yTitle);
  textSize(13);

  text( "DAY", xStat, y1);
  text(  ":  " + dayCounter, xStat2, y1);

  text( "POPULATION", xStat, y2);
  text(  ":  " + round(popSize), xStat2, y2);

  text( "HOSPITAL", xStat, y3);
  text(  ":  " + nf(numExZone, 0, 0), xStat2, y3);

  text( "ETU", xStat, y4);
  text( ":  " + nf(numTempZone, 0, 0), xStat2, y4);

  // text( "HEALTHY   ", xStat3, yTitle);
  //text( nf(numHealthy, 0, 0), xStat2, yHealthy);

  text( "INCUBATION  ", xStat3, y1);
  text(  ":  " + nf(numInfected, 0, 0), xStat4, y1);

  text( "SYMPTOMATIC ", xStat3, y2);
  text(  ":  " + nf(numSick, 0, 0), xStat4, y2);

  //text( "IN TREATMENT : ", xStat, yTreatment);
  //text(  nf(numTreatment, 0, 0), xStat2, yTreatment);

  text( "SURVIVOR", xStat3, y3);
  text(  ":  " + nf(numHealed, 0, 0), xStat4, y3);

  text( "DEATHS", xStat3, y4);
  text( ":  " + nf(totalDeaths, 0, 0), xStat4, y4);

  text( "TOTAL AFFECTED", xStat5, y1  );
  text(  ":  " + nf(numAffected, 0, 0), xStat6, y1 );

  text( "PREVALANCE", xStat5, y2);
  text(  ":  " + nf(percentAffected, 0, 3)+"%", xStat6, y2);

  text( "INCIDENCE RATE", xStat5, y3);
  text( ":  " + nf(percentIncidence, 0, 2), xStat6, y3);

  text( "CASE FATALITY RATE", xStat5, y4);
  text(  ":  " + nf(caseFatalityRate, 0, 2)+"%", xStat6, y4); 

  fill(255);
  strokeWeight(5);
  //  noStroke();
  //ellipse(xStat3-10, yTitle-5, 4, 4);
  stroke(255, 48, 36, 150);
  ellipse(xStat3-12, y2-5, 4, 4);
  stroke(254, 184, 1, 150);
  ellipse(xStat3-12, y1-5, 4, 4);
  stroke(3, 191, 103, 150);
  ellipse(xStat3-12, y3-5, 4, 4);
  stroke(138, 43, 226, 150);
  ellipse(xStat3-12, y4-5, 4, 4);

  noStroke();
  fill(255, 100);
  ellipse(xStat-12, y3-5, 9, 9);
  fill(0, 255, 0);
  ellipse(xStat-12, y3-5, 3, 3);
  fill(255, 100);
  ellipse(xStat-12, y4-5, 9, 9);
  fill(0, 255, 255, 120);
  ellipse(xStat-12, y4-5, 3, 3);


  //if (numSick == 0 && numInfected == 0 && dayCounter > 200) {
  //  if (looping) {
  //    recording = !recording;
  //    noLoop();
  //  } else {
  //    loop();
  //  }
  //}
}
//--------------------------------------------------------------//

void fillLattice( Lattice latIn, ASCgrid DEin ) // fill Lattice
{
  for ( int x = 0; x < DEin.w; x += 1 ) {
    for ( int y = 0; y < DEin.h; y += 1 ) {

      float value = DEin.get(x, y);
      latIn.put(x, y, value  );
    }
  }
}
//===========================================================//

void drawTargets()
{
  for ( PVector t : targets )
  {
    noStroke();
    fill( 255 );
    ellipse( t.x, t.y, 3, 3 );
  }
};

//--------------------------------------------------------------//

void scrollBar() {

  hs1.updateScroll();
  hs1.displayScroll();

  hs2.updateScroll();
  hs2.displayScroll2();

  hs3.updateScroll();
  hs3.displayScroll3();

  hs4.updateScroll();
  hs4.displayScroll4();

  float xValue = hs1.getPos();
  float xValue2 = hs2.getPos();
  float xValue3 = hs3.getPos();
  float xValue4 = hs4.getPos();

  int    aid = round(map(xValue, xbar+95, xbar + 305, 0, 100));
  String aidMoney = nfc(aid);
  int    aid2 = round(map(xValue2, xbar+95, xbar + 305, 0, 100));
  String aidMoney2 = nfc(aid2);
  int    pub = round(map(xValue3, xbar+95, xbar + 305, 0, 100));
  String pubAwarness = nfc(pub);
  int    vac = round(map(xValue4, xbar+95, xbar + 305, 0, 100));
  String vacPercent = nfc(vac);

  fill(0, 255, 255, 120);
  //rect(55, hs2.ypos, hs2.spos-55, 10);

  textSize(9);
  textAlign(LEFT);
  fill(255);
  text("% " + aidMoney, hs1.spos+8, hs1.ypos+9);
  text("% " + aidMoney2, hs2.spos+8, hs2.ypos+9);
  text("% " + pubAwarness, hs3.spos+8, hs3.ypos+9); 
  text("% " + vacPercent, hs4.spos+8, hs4.ypos+9); 

  fill(255);
  textSize(12);
  text("INTERVENTION TOOL BARS", xStat5, hs1.ypos-15);
  strokeWeight(1);
  stroke(255, 100);
  line(xStat5, hs1.ypos-9, xStat5+200, hs1.ypos-9);
  noStroke();

  textSize(10);
  textAlign(RIGHT);
  text("HOSPITAL CAPACITY", xStat5 - 5, hs1.ypos+9);
  text("SAFE BURIAL", xStat5 - 5, hs2.ypos+9);
  text("SEEK TREATMENT", xStat5 - 5, hs3.ypos+9);
  text("VACCINATION", xStat5 - 5, hs4.ypos+9);

  //scale
  textAlign(LEFT);
  stroke(250);
  strokeWeight(2);
  textSize(10);
  //text("10 KM", 164, 911);
  //line(25, 910, 158, 910);
  //line(25, 910, 25, 905);
  //line(158, 910, 158, 905);
  textSize(13);
}

//--------------------------------------------------------------//

void createPopulation() // Create Population
{
  population = new ArrayList<Agent>();
  //population.add(new Agent(100,100));


  for ( int x = 0; x < DElat.w; x += 1 ) {
    for ( int y = 0; y < DElat.h; y += 1 ) {

      int val =  (int) DElat.get(x, y);
      if ( val == populationHome4 && random(1.0) <= birthProb4 || val == populationHome5  && random(1.0) <= birthProb5 || val == populationHome3 && random(1.0) <= birthProb3 ||  val == populationHome2 && random(1.0) <= birthProb2)
      {
        Agent temp2 =  new Agent(x, y);
        Agent temp3 = new Agent(x, y);
        Agent temp4 = new Agent(x, y);
        Agent temp5 = new Agent(x, y);
        temp5.setHomeClass(populationHome5);
        temp4.setHomeClass(populationHome4);
        temp3.setHomeClass(populationHome3);
        temp2.setHomeClass(populationHome2);
        if (temp5.loc.y < 920 && temp4.loc.y <930 && temp3.loc.y <920 && temp2.loc.y <920) {
          population.add( temp5 );
          population.add( temp4 );
          population.add( temp3 );
          population.add( temp2 );
        }
        initPop = population.size();
      }
    }
  }
}

//===========================================================//
void mousePressed()
{ 
  if (rectOver) {
    if (!info) {
      info = true;
    } else if (info) {
      info = false;
    }
  }
};

//===========================================================//
void keyPressed()
{   
  if ( key == 't' )
  {  
    // pressing the 't' key adds a new target location 
    // to the mouse location

    PVector  tt = new PVector( mouseX, mouseY );      // create a target PVector
    cst = new Cost( roadASC, ROADVALUE );     // init the Cost function
    cst.moreOptimal = true;                  // right now, less optimal paths

    Lattice l = cst.getCostSurface( tt );           // get the cost surface lattice for new target
    ccs.add( l  );                                   // add the lattice to the rest of the cost surfaces
    targets.add( tt );      // add the new target to the target list

    // Health Zone

    int x = 0;
    int y = 0;

    HealthZone newZone = new HealthZone(x, y, isSetup);

    newZone.loc.x = mouseX;
    newZone.loc.y = mouseY;

    healthZones.add(newZone);  
    for (MultiTargetFinder a : cars) { 
      a.target = null;
    }
  }

  if ( key == 'w') {    // primary image
    if (imageFlip == false) {
      imageFlip = true;
      imageFlip2 = false;
    } else if (imageFlip == true) {
      imageFlip = false;
    }
  }

  if ( key == 'e') {    // primary image
    if (imageFlip == true) {
      imageFlip = false;
      imageFlip2 = true;
    } else if (imageFlip2 == false) {
      imageFlip2 = true;
    }
  }

  if (key == 'r') {
    if (recording == false) {
      recording = true;
    } else if (recording == true) {
      recording = false;
    }
  }

  if (key == 'q') {
    if (popRec == false) {
      popRec = true;
    } else if (popRec == true) {
      popRec = false;
    }
  }

  if (key == 'x') {
    if (!pop) {
      pop = true;
    } else if (pop) {
      pop = false;
    }
  }

  if (key == 'a') {
    if (!viz) {
      viz = true;
    } else if (viz) {
      viz = false;
    }
  }

  if (key == 'n') {
    fill(0);
    rect(0, 0, width, height);
    population.clear();
    healthZones.clear();
    cars.clear();
    //sickHistory.clear();
    createPopulation();

    isSetup = false;
    dayCounter = 0;
    totalDeaths = 0;

    loop();
  }

  if ( key == ' ') // run simulation
  {
    isSetup = true;
    dayCounter = 0;
    xCord = 0;
    xCord1 = 0;
    xCord2 = 0;

    //sickHistory.clear();
  }

  if ( key == 's') // sick agent
  {
    sickAgent(mouseX, mouseY);
  }

  if ( key == 'c') // sick agent
  {
    newPathFinder(mouseX, mouseY);
  }
}

//===============================================================================// Infect

void infect()
{

  //--------------------------------------------------------------// person to person

  for ( int i = 0; i < population.size(); i += 1) {

    Agent person1 = population.get(i);

    for ( int j = i + 1; j < population.size(); j += 1) 
    {
      Agent person2 = population.get(j);

      float distance = dist( person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

      float xVacValue = hs4.getPos();
      float vacPercent = map(xVacValue, xbar+95, xbar + 305, 0, 100); 

      //vacProbability = infectionProbability - vacPercent;

      //if (vacPercent < 20) {
      //  infectionProbability = 0.0225;
      //} else if (vacPercent >= 20 && vacPercent < 40) {  
      //  infectionProbability = 0.0175;
      //} else if (vacPercent >= 40 && vacPercent < 60) {  
      //  infectionProbability = 0.0125;
      //} else if (vacPercent >= 60 && vacPercent < 80) {  
      //  infectionProbability = 0.0075;
      //} else if (vacPercent >= 80) {  
      //  infectionProbability = 0.0005;
      //}
      
      if (vacPercent < 20) {
        infectionProbability = 0.0225;
      } else if (vacPercent >= 20 && vacPercent < 40) {  
        infectionProbability = 0.0175;
      } else if (vacPercent >= 40 && vacPercent < 60) {  
        infectionProbability = 0.0125;
      } else if (vacPercent >= 60 && vacPercent < 80) {  
        infectionProbability = 0.0075;
      } else if (vacPercent >= 80) {  
        infectionProbability = 0.0005;
      }

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

      if (person1.seek) {
        removeSick();
        newPathFinder(person1.loc.x, person1.loc.y);
      }

      if (person2.seek) {
        removeSick();
        newPathFinder(person2.loc.x, person2.loc.y);
      }
    }
  }



  //--------------------------------------------------------------// person to person
  for ( int i = 0; i < popRecord.size(); i += 1) {

    Agent deadPerson = popRecord.get(i);

    for ( int j = i + 1; j < population.size(); j += 1) 
    {
      Agent person2 = population.get(j);

      float distance = dist( deadPerson.loc.x, deadPerson.loc.y, person2.loc.x, person2.loc.y);

      float xValue3 = hs2.getPos();
      float pubAware = map(xValue3, xbar+95, xbar + 305, 0, .015); 

      deadInfectionProbability = .015-pubAware;

      // first condition
      if ( distance <= deadSpreadDistance && deadPerson.deceased && !person2.sick)
      {
        //person 1 makes person 2 sick
        if (prob(deadInfectionProbability) == true && deadPerson.infectiousBody == true ) {
          person2.getInfected();
        }
      } 
      if (person2.seek) {
        removeSick();
        newPathFinder(person2.loc.x, person2.loc.y);
      }
    }
  }


  //--------------------------------------------------------------// car to person
  for ( int i = 0; i < cars.size(); i += 1) {

    MultiTargetFinder car1 =cars.get(i);

    for ( int j = 0; j < population.size(); j += 1) 
    {
      Agent person = population.get(j);

      float distance = dist( car1.loc.x, car1.loc.y, person.loc.x, person.loc.y);

      // Infection probability in healthcare 
      if (car1.atTarget) {
        infectionProbability = 0.0001;
      } else {  
        infectionProbability = 0.0175;
      }

      // first condition
      if ( distance <= spreadDistance && car1.sick && !person.sick)
      {
        //car makes person sick
        if (prob(infectionProbability) == true) {
          person.getInfected();
        }
      } 

      //remove + insert seeking car
      if (person.seek) {
        removeSick();
        newPathFinder(person.loc.x, person.loc.y);
      }
      //
      if (person.noSeek) {
        //removeSick();
        //newPathFinder(person.loc.x, person.loc.y);  
        //numNoSeek += 1;
      }
    }
  }
}

//===============================================================================//  probability function

boolean prob( float probRate )
{
  if (random(0, 1) <= probRate) {
    return true;
  } else {
    return false;
  }
  
}

//===============================================================================// record functions

void record() {
  
  //sim record
 if (recording) {
    //saveFrame("output/#####.png");
    fill(255, 0, 0);
  } else if (!recording) {
    noFill();
  }
  
  stroke(255, 0, 0);
  strokeWeight(4);
  ellipse(width-30, 15, 10, 10);
  
}

// Data Output
void dataRecord() {         
  if (recording) {
    //saveFrame("outputData/#####.png");
  } else if (!recording) {
    noFill();
  }
  
}

//===============================================================================//  new agents 

void newPathFinder(float x, float y) {  
  MultiTargetFinder car = new MultiTargetFinder( x, y);
  car.findRoad(ccs);
  cars.add(car); 
  car.getSick(2, 21);
}

void sickAgent(float x, float y) {  
  Agent infectedPerson = new Agent( x, y);
  population.add(infectedPerson); 
  infectedPerson.getInfected();
}

//--------------------------------------------------------------// survivor agent
void newAgent(float x, float y) {
  Agent survivor = new Agent(x, y);
  survivor.loc.x = x;
  survivor.loc.y = y;
  popRecord.add(survivor);
  survivor.drawAgent();
  survivor.getReturned();
  if(survivor.returned){
    numHealed += 1;
  }
}

//--------------------------------------------------------------// dead agent
void deadAgent(float x, float y) {
  Agent dead = new Agent(x, y);
  dead.loc.x = x;
  dead.loc.y = y;
  dead.vel.x  = 0;
  dead.vel.y  = 0;
  popRecord.add(dead);
  dead.drawAgent();
  dead.getDeceased();
}

//===============================================================================// background data viz

void dataViz() {

  float numSick = 0;

  for (MultiTargetFinder person : cars) {
    if ( person.sick == true) { 
      numSick += 1;
    }
  }

  for (Agent person : population) {
    if ( person.sick == true && person.noSeek) { 
      numSick += 1;
    }
  }

  //--------------------------------------------------------// grid lines
  fill(0, 100);
  noStroke();
  rectMode(CORNER);
  rect(0, yCord, width, -yCord);
  strokeWeight(1);

  // horizontal lines
  for ( int i = 25; i < 920; i += 25) {
    for ( int p = 0; p <= 100; p += 20) {
      stroke(70);
      line(0, yCord-i, 1885, yCord-i);
    }
  }

  // verticle lines
  for ( int i = 0; i < 1900; i += 67) { 
    for ( int p = 0; p <= 20; p += 1) {
      stroke(40);
      line(0+i, yCord, 0+i, -900);
    }
  }

  fill(155);
  // verticle text
  for ( int p = 25; p <= 920; p += 25) {
    textAlign(LEFT);
    text(p/2.5, 1890, yCord-p+5);
  }

  //for ( int p = 25; p <= 290; p += 25) {
  //  textAlign(LEFT);
  //  text(p, 1890, yCord-325-p+5);
  //}

  //for ( int p = 25; p <= 250; p += 25) {
  //  textAlign(LEFT);
  //  text(nf(p/2.5, 0, 0), 1890, yCord-650-p+5);
  //}


  //--------------------------------------------------------// titles
  //fill(250);
  //textSize(14);
  //textAlign(RIGHT);
  //text("CURRENT CASES", width-5, yCord-307);
  //text("DEATHS VS SURVIVORS", width-5, yCord-632);
  //text("PERCENT SEEKING TREATMENT", width-5, yCord-906);

  //--------------------------------------------------------// border lines
  fill(0);
  stroke(200);
  strokeWeight(2);
  line(0, yCord, width, yCord);
  //line(0, yCord-650, width, yCord-650);

  //----------------------------in----------------------------// data lines
  strokeWeight(2);
  xCord1 = 0;
  for (int i = 0; i < frameCount; i++) 
  {
    Float ySick   = sickHistory.get(i);
    Float yHealed = survivorHistory.get(i);
    Float yDeaths = deathHistory.get(i);
    Float ySeek   = seekHistory.get(i);
    ySeek = ySeek* 2.5;

    stroke(160);
    strokeWeight(1);
    line(xCord1, yHealed, xCord1, yCord);
    strokeWeight(3);
    stroke(240);
    line(xCord1, yHealed, xCord1, yHealed);

    stroke(191, 142, 237);
    strokeWeight(1);
    line(xCord1, yDeaths, xCord1, yCord);
    stroke(138, 43, 226);
    strokeWeight(3);
    line(xCord1, yDeaths, xCord1, yDeaths);

    //existing data
    //strokeWeight(1);
    //stroke(120, 120, 120);
    //line(0, yCord-(21*0), 67*8, yCord-(43*2.5));
    //line(67*8, yCord-(43*2.5), 67*9, yCord-(57*2.5));
    //line(67*9, yCord-(57*2.5), 67*10, yCord-(102*2.5));
    //line(67*10, yCord-(102*2.5), 67*11, yCord-(111*2.5));
    //line(67*11, yCord-(111*2.5), 67*12, yCord-(122*2.5));
    
    //fill(120, 120, 120);
    //textSize(15);
    //text("122 Total Cases", 67*12+5, yCord-(122*2.5)+5);


    //stroke(156, 130, 181);
    //line(0, yCord-(17*0), 67*8, yCord-(34*2.5));
    //line(67*8, yCord-(34*2.5), 67*9, yCord-(41*2.5));
    //line(67*9, yCord-(41*2.5), 67*10, yCord-(59*2.5));
    //line(67*10, yCord-(59*2.5), 67*11, yCord-(75*2.5));
    //line(67*11, yCord-(75*2.5), 67*12, yCord-(82*2.5));
    //fill(156, 130, 181);
    //text("82 Total Deaths [67% CFR]", 67*12+5, yCord-(82*2.5)+5);
    
    // Mangina //////////////////////////////////////////////////
    strokeWeight(1);
    stroke(120, 120, 120);
    line(0, yCord-(21*0), 67*8, yCord-(36*2.5));
    line(67*8, yCord-(36*2.5), 67*9, yCord-(48*2.5));
    line(67*9, yCord-(48*2.5), 67*10, yCord-(91*2.5));
    line(67*10, yCord-(91*2.5), 67*11, yCord-(94*2.5));
    line(67*11, yCord-(94*2.5), 67*12, yCord-(96*2.5));

    fill(120, 120, 120);
    textSize(15);
    text("96 Total Cases", 67*12+5, yCord-(96*2.5)+5);


    stroke(156, 130, 181);
    line(0, yCord-(17*0), 67*8, yCord-(30*2.5));
    line(67*8, yCord-(30*2.5), 67*9, yCord-(35*2.5));
    line(67*9, yCord-(35*2.5), 67*10, yCord-(51*2.5));
    line(67*10, yCord-(51*2.5), 67*11, yCord-(63*2.5));
    line(67*11, yCord-(63*2.5), 67*12, yCord-(65*2.5));
    fill(156, 130, 181);
    text("65 Total Deaths [67% CFR]", 67*12+5, yCord-(65*2.5)+5);

    stroke(200);
    line(67*8, yCord, 67*8, yCord-950);

    xCord1 = xCord1 + 0.6;
  }

  //--------------------------------------------------------// data text
  strokeWeight(1);
  noStroke();

  float ySeek = map(seekLine, 0, 100, 0, 250); 
  ySeek = ySeek* 2.5;

  float ySick   = yCord - numSick;
  float yAware  = yCord-650-(seekLine*2.5);
  float percent = map(ySeek, 0, 250, 0, 100);
  float yDeaths = yCord-(totalDeaths);
  float yTotal =  yCord-(totalDeaths+numHealed);

  fill(255);
  textAlign(LEFT);
  text(nfc(numSick, 0), xCord1+2, ySick);
  // text(round(percent/2.5) + " % Seeking Treatment", xCord1+2, yAware);
  fill(138, 43, 226);
  text(nfc(totalDeaths, 0) + "Deaths", xCord1+2, yDeaths);
  fill(120, 120, 120);
  text(nfc((totalDeaths+numHealed), 0) + "Total", xCord1+2, yTotal);
}


//===============================================================================// window data viz

void vizWindow() {

  float numSick = 0;

  for (MultiTargetFinder person : cars) {
    if ( person.sick == true) { 
      numSick += 1;
    }
  }

  for (Agent person : population) {
    if ( person.sick == true && person.noSeek) { 
      numSick += 1;
    }
  }

  //--------------------------------------------------------// grid lines
  fill(0, 100);
  noStroke();
  rectMode(CORNER);
  rect(0, yCord, width, -yCord);
  strokeWeight(1);

  // horizontal lines
  for ( int i = 25; i < 920; i += 25) {
    for ( int p = 0; p <= 100; p += 20) {
      stroke(70);
      line(0, yCord-i, 1885, yCord-i);
    }
  }

  // verticle lines
  for ( int i = 0; i < 1900; i += 67) { 
    for ( int p = 0; p <= 20; p += 1) {
      stroke(40);
      line(0+i, yCord, 0+i, -900);
    }
  }

  fill(155);
  // verticle text
  for ( int p = 25; p <= 900; p += 25) {
    textAlign(LEFT);
    text(p/2.5, 1890, yCord-p+5);
  }

  //for ( int p = 25; p <= 290; p += 25) {
  //  textAlign(LEFT);
  //  text(p, 1890, yCord-325-p+5);
  //}

  //for ( int p = 25; p <= 250; p += 25) {
  //  textAlign(LEFT);
  //  text(nf(p/2.5, 0, 0), 1890, yCord-650-p+5);
  //}


  //--------------------------------------------------------// titles
  //fill(250);
  //textSize(14);
  //textAlign(RIGHT);
  //text("CURRENT CASES", width-5, yCord-307);
  //text("DEATHS VS SURVIVORS", width-5, yCord-632);
  //text("PERCENT SEEKING TREATMENT", width-5, yCord-906);

  //--------------------------------------------------------// border lines
  fill(0);
  stroke(200);
  strokeWeight(2);
  line(0, yCord, width, yCord);
  //line(0, yCord-650, width, yCord-650);

  //--------------------------------------------------------// data lines
  strokeWeight(2);
  xCord2 = 0;
  for (int i = 0; i < frameCount; i++) 
  {
    Float ySick   = sickHistory.get(i);
    Float yHealed = survivorHistory.get(i);
    Float yDeaths = deathHistory.get(i);
    Float ySeek   = seekHistory.get(i);
    ySeek = ySeek* 2.5;

    stroke(160);
    strokeWeight(1);
    line(xCord2, yHealed, xCord2, yCord);
    strokeWeight(3);
    stroke(240);
    line(xCord2, yHealed, xCord2, yHealed);

    stroke(191, 142, 237);
    strokeWeight(1);
    line(xCord2, yDeaths, xCord2, yCord);
    stroke(138, 43, 226);
    strokeWeight(3);
    line(xCord2, yDeaths, xCord2, yDeaths);
    
    //existing data
    //strokeWeight(1);
    //stroke(120, 120, 120);
    //line(0, yCord-(21*0), 67*8, yCord-(43*2.5));
    //line(67*8, yCord-(43*2.5), 67*9, yCord-(57*2.5));
    //line(67*9, yCord-(57*2.5), 67*10, yCord-(102*2.5));
    //line(67*10, yCord-(102*2.5), 67*11, yCord-(111*2.5));
    //line(67*11, yCord-(111*2.5), 67*12, yCord-(122*2.5));
    
    //fill(120, 120, 120);
    //textSize(15);
    //text("122 Total Cases", 67*12+5, yCord-(122*2.5)+5);


    //stroke(156, 130, 181);
    //line(0, yCord-(17*0), 67*8, yCord-(34*2.5));
    //line(67*8, yCord-(34*2.5), 67*9, yCord-(41*2.5));
    //line(67*9, yCord-(41*2.5), 67*10, yCord-(59*2.5));
    //line(67*10, yCord-(59*2.5), 67*11, yCord-(75*2.5));
    //line(67*11, yCord-(75*2.5), 67*12, yCord-(82*2.5));
    //fill(156, 130, 181);
    //text("82 Total Deaths [67% CFR]", 67*12+5, yCord-(82*2.5)+5);
    
    //Mangina//
    strokeWeight(1);
    stroke(120, 120, 120);
    line(0, yCord-(21*0), 67*8, yCord-(36*2.5));
    line(67*8, yCord-(36*2.5), 67*9, yCord-(48*2.5));
    line(67*9, yCord-(48*2.5), 67*10, yCord-(91*2.5));
    line(67*10, yCord-(91*2.5), 67*11, yCord-(94*2.5));
    line(67*11, yCord-(94*2.5), 67*12, yCord-(96*2.5));

    fill(120, 120, 120);
    textSize(15);
    text("96 Total Cases", 67*12+5, yCord-(96*2.5)+5);


    stroke(156, 130, 181);
    line(0, yCord-(17*0), 67*8, yCord-(30*2.5));
    line(67*8, yCord-(30*2.5), 67*9, yCord-(35*2.5));
    line(67*9, yCord-(35*2.5), 67*10, yCord-(51*2.5));
    line(67*10, yCord-(51*2.5), 67*11, yCord-(63*2.5));
    line(67*11, yCord-(63*2.5), 67*12, yCord-(65*2.5));
    fill(156, 130, 181);
    text("65 Total Deaths [67% CFR]", 67*12+5, yCord-(65*2.5)+5);

    stroke(200);
    line(67*8, yCord, 67*8, yCord-950); 

    xCord2 = xCord2 + 0.6;
  }

  //--------------------------------------------------------// data text
  strokeWeight(1);
  noStroke();

  float ySeek = map(seekLine, 0, 100, 0, 250); 
  ySeek = ySeek* 2.5;

  float ySick   = yCord - numSick;
  float yAware  = yCord-650-(seekLine*2.5);
  float percent = map(ySeek, 0, 250, 0, 100);
  float yDeaths = yCord-(totalDeaths*5);
  float yTotal =  yCord-((totalDeaths+numHealed)*5);


  textAlign(LEFT);
  //text(nfc(numSick, 0) + " Cases", xCord2+2, ySick);
  // text(round(percent/2.5) + " % Seeking Treatment", xCord2+2, yAware);
  text(nfc((totalDeaths+numHealed), 0), xCord2+2, yTotal);
  fill(156, 130, 181);
  text(nfc(totalDeaths, 0), xCord2+2, yDeaths);
}

//===============================================================================// button functions

void button() {
  
  if (!info) {
    fill(255);
    strokeWeight(1);
    textAlign(LEFT);
    text("x  add population", xStat3-60, 775);
    text("t  add health center", xStat3-60, 795);
    text("_  start simulation", xStat3-60, 815);
    text("c  add sick agent", xStat3-60, 835);
    text("w  background", xStat3-50, 855);
    text("n  refresh", xStat3-60, 875);
    text("r  record", xStat3-60, 895);
    text("a  graphs", xStat3-60, 915);
  }

  buttonUpdate(mouseX, mouseY);

  if (rectOver) {
    fill(rectHighlight);
  } else {
    noFill();
  }

  strokeWeight(1);
  stroke(255);
  ellipseMode(CENTER);
  ellipse(rectX+7, rectY, rectWidth, rectHeight); 

  if (rectOver) { 
    fill(0);
  } else {
    fill(255);
  }
  textAlign(CENTER);
  text("i", rectX+(rectWidth/2), rectY+5);
}

void buttonUpdate(float x, float y) {

  rectOver = false;
  if ( overRect(rectX, rectY, rectWidth, rectHeight) ) {
    rectOver = true;
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


// class ASC

// CREDITS : ROBERT PIETRUSKO

class ASCgrid
{
     int ncols;
     int nrows;
     double xllcorner;
     double yllcorner;
     double cellsize;
     long NODATA_value;
     String NODATA;
     String delimmer = " ";
     String[] projectionFile;
     boolean prjFileExists = true;
    
    
    protected float[][] cells;
    
     int HEAD_SIZE = 6;
    
      int h, w;
      float minValue, maxValue;
      boolean wrap = true;
      PImage img;
      boolean imageLoaded = false;
    
    ////////////////////////////////////////////////////////////////////////////
    ASCgrid()
    {
        // creates a blank ASCgrid   
        println( "Blank ASC Grid " + this.w + " x " + this.h + " with no parameters");
    }
    
    ////////////////////////////////////////////////////////////////////////////
    ASCgrid( String fileName)
    {
        String[] ascFile = loadStrings(fileName);    
        
        parseProjection(fileName);
        
        parseHeader( ascFile );
        parseBody( ascFile );
        println( "ASC Grid " + this.w + " x " + this.h + ". Min: " + minValue + " Max: " + maxValue );
    }
 
     ////////////////////////////////////////////////////////////////////////////
     ASCgrid( ASCgrid ag )
     {
         copyGridStructure( ag );
     }
 
    ////////////////////////////////////////////////////////////////////////////
     void copyGridStructure( String fileName )
    {
       String[] ascFile = loadStrings(fileName);    
        parseHeader( ascFile );
        parseProjection( fileName );
         cells     = new float[ w ][ h ];
        println( "Blank ASC Grid " + this.w + " x " + this.h);
    }
    
    ////////////////////////////////////////////////////////////////////////////
     void copyGridStructure( ASCgrid ag )
    {
           ncols      = ag.ncols;
           nrows      = ag.nrows;
       xllcorner      = ag.xllcorner;
       yllcorner      = ag.yllcorner;
       cellsize       = ag.cellsize;
       NODATA_value   = ag.NODATA_value;
       NODATA         = ag.NODATA;
       h              = ag.h;
       w              = ag.w; 
       projectionFile = ag.projectionFile;
       prjFileExists  = ag.prjFileExists;

         cells        = new float[ w ][ h ];
        println( "Blank ASC Grid " + this.w + " x " + this.h + " y ");
    }  
    
    //////////////////////////////////////////////////////////////////////////// 
     void parseProjection( String fileName )
    {
      
        try
        {
           String[] filenameBits = split(fileName, "." );
           projectionFile        = loadStrings( filenameBits[0] + ".prj" );
        
        }
        catch ( Exception e)
        {
            ;
        }
        
        if( projectionFile == null )
        { 
            prjFileExists = false; 
            println( "WARNING: no *.prj file found. Will not be able to write a new ASC file with projection." );        
        }        
    };
    
    ////////////////////////////////////////////////////////////////////////////   
     void parseHeader( String[] ascFile )
    {
        ncols          = Integer.parseInt( split(ascFile[0].replaceAll("\\s+", ","), ",")[1] );
        nrows          = Integer.parseInt( split(ascFile[1].replaceAll("\\s+", ","), ",")[1] );
        xllcorner      = Double.parseDouble( split(ascFile[2].replaceAll("\\s+", ","), ",")[1] );
        yllcorner      = Double.parseDouble( split(ascFile[3].replaceAll("\\s+", ","), ",")[1] );
        cellsize       = Double.parseDouble( split(ascFile[4].replaceAll("\\s+", ","), ",")[1] );
        NODATA_value   = Long.parseLong( split(ascFile[5].replaceAll("\\s+", ","), ",")[1] );
        NODATA         = split(ascFile[5].replaceAll("\\s+", ","), ",")[1];
        
        this.h = nrows;
        this.w = ncols;  
    }
    
    ////////////////////////////////////////////////////////////////////////////
     void parseBody( String[] ascFile )
    {
        cells     = new float[ w ][ h ];    
        minValue  =  999999999;
        maxValue  = -999999999;
        
        
        for( int i = HEAD_SIZE; i < ascFile.length; i++ )
        {    
                  ascFile[i] = ascFile[i].trim(); // get rid of last white space
                  
              String[] rower = split( ascFile[i].replaceAll( NODATA, "0" ), delimmer);
              
              for( int j = 0; j < rower.length; j++)
              {
                  cells[ j ][ i-HEAD_SIZE ] = Float.parseFloat( rower[j] );
                  minValue = min( minValue,   Float.parseFloat( rower[j] ) );
                  maxValue = max( maxValue,   Float.parseFloat( rower[j] ) );           
              }
        }    
    };
    
    ////////////////////////////////////////////////////////////////////////////
    void minimum()
    {
        minValue  =  999999999;
          for( int x = 0; x < cells.length; x++ ){
            for( int y = 0; y < cells[0].length; y++){
              
                  minValue = min( minValue, cells[x][y] );
            }}
    };
    
    ////////////////////////////////////////////////////////////////////////////
    void maximum()
    {
        maxValue  = -999999999;
          for( int x = 0; x < cells.length; x++ ){
            for( int y = 0; y < cells[0].length; y++){
              
                  maxValue = max( maxValue, cells[x][y] );
            }}
    };
    
    ////////////////////////////////////////////////////////////////////////////
     void fitToScreen()
    {
        fit(1973, 1014);
    };
    
     void fitToScreen2()
    {
        fit(1973, 1009);
    };
    
    ////////////////////////////////////////////////////////////////////////////
     void fit( int wIn, int hIn )
    {
             if( w < wIn || h < hIn ){   scaleUpNearest(wIn, hIn); }
        else if( w > wIn || h > hIn ){ scaleDownNearest(wIn, hIn); }
        println("ASC Grid now sized: " + w + " x " + h );
    };
    
    ////////////////////////////////////////////////////////////////////////////
     void scaleUpNearest( int wIn, int hIn )
    {
        println( "scaling up is not yet implemented."); 
    };
    
    ////////////////////////////////////////////////////////////////////////////
     void scaleDownNearest( int wIn, int hIn )
    {
        int wScl = floor( w / wIn );
        int hScl = floor( h / hIn );
       
        //println( "wScl " + wScl );
        //println( "hScl " + hScl );
        
        int wRes = w - (wIn * wScl);
        int hRes = h - (hIn * wScl);
        
        //println( "wRes " + wRes );
        //println( "hRes " + hRes );
       
        float[][] temp = new float[ wIn ][ hIn ];
        
         for( int x = 0; x < wIn; x ++ ){
         for( int y = 0; y < hIn; y ++ ){
              
               temp[x][y] = cells[x * wScl][y * hScl];
         }}
          
         cells = new float[wIn][hIn];
          
         for( int x = 0; x < wIn; x ++ ){
         for( int y = 0; y < hIn; y ++ ){
              
               cells[x][y] = temp[x][y];
         }} 
         
         //////////////////////////
         // update stats
         //////////////////////////
         w = cells.length;
         h = cells[0].length;
         nrows = h;
         ncols = w;
         minimum();
         maximum();
         yllcorner = yllcorner + (hRes * cellsize);
         cellsize  *= hScl;
    };
     
    ////////////////////////////////////////////////////////////////////////////
     void put( int _x, int _y, float val )
    {
        if(wrap)
        {
            _x = wrapX(_x);
            _y = wrapY(_y);
        }
        
        cells[_x][_y] = val;
    };
    
    ////////////////////////////////////////////////////////////////////////////
     void put( float[][] vals )
    {
        int xDim = min(    vals.length, w );
        int yDim = min( vals[0].length, h );
    
        for( int x = 0; x < xDim; x++ ){
          for( int y = 0; y < yDim; y++ ){
            
                cells[x][y] = vals[x][y];
          }}
    };
    
    ////////////////////////////////////////////////////////////////////////////
     float get( int _x, int _y )
    {
        if(wrap)
        {
            _x = wrapX(_x);
            _y = wrapY(_y);
        }
        
        return cells[_x][_y];
    };
   
    ////////////////////////////////////////////////////////////////////////////
     float[][] get()
    {
        return cells;
    };
   
    ////////////////////////////////////////////////////////////////////////////
     PImage updateImage()
    {
         img = new PImage(w, h);
    
        for( int i = 0; i < this.w; i++ ){
          for( int j = 0; j < this.h; j++){
            
                int px = floor( map( this.get(i,j), minValue, maxValue, 0, 255) );
                int pxc = color(px,px,px);
                img.set(i,j,pxc);          
          }}
        
        imageLoaded = true;  
        return img;   
    };
     
    ////////////////////////////////////////////////////////////////////////////   
     PImage updateImage( color[] swatch )
    {
         img = new PImage(w, h);
    
        for( int i = 0; i < this.w; i++ ){
          for( int j = 0; j < this.h; j++){
            
                int px = (int)this.get(i,j);                
                img.set(i,j,swatch[px]);          
          }}
        
        imageLoaded = true;  
        return img;   
    };
    
    ////////////////////////////////////////////////////////////////////////////
     PImage updateImage( color[] swatch, String _stretched )
    {
         img = new PImage(w, h);
         boolean stretched = false;
         
         if( _stretched.toUpperCase().equals( "STRETCHED") ) stretched = true;
         
    
        for( int i = 0; i < this.w; i++ ){
          for( int j = 0; j < this.h; j++){
            
                int px = (int)this.get(i,j);
                if( stretched ) // use this for a color map that has values 0-255
                      px = floor( map( this.get(i,j), minValue, maxValue, 0, 255) );
                
                img.set(i,j,swatch[px]);          
          }}
        
        imageLoaded = true;  
        return img;   
    };
    
    ////////////////////////////////////////////////////////////////////////////
     PImage getImage()
    {
        return imageLoaded ? img : updateImage();
    }
    
     PVector[] getPVectors()
    {
        PVector[] values = new PVector[ w * h ];
        
        for( int x = 0; x < w; x++ ){
          for( int y = 0; y < h; y++ ){
            
                values[ y*w+x ] = new PVector( x, y, cells[x][y] );
          }}
        
        return values;
    };
    
    ////////////////////////////////////////////////////////////////////////////
     float[][] getNeighborhood( int _x, int _y)
    {
        if(wrap)
        {
            _x = wrapX(_x);
            _y = wrapY(_y);
        } 
    
        float[][] kernel = new float[3][3];
        
        for( int i = -1; i <= 1; i++ ){
        for( int j = -1; j <= 1; j++ ){
        
              kernel[i+1][j+1] = this.get( wrapX(_x+i), wrapY(_y+j) );
          
        }}
        
        return kernel;
    };
    
    
    ////////////////////////////////////////////////////////////////////////////
     void write( String fileName )
    {
        String[] rowStream = new String[ HEAD_SIZE + nrows ] ;
        
        rowStream[ 0 ] = "ncols" + delimmer + ncols;
        rowStream[ 1 ] = "nrows" + delimmer + nrows;
        rowStream[ 2 ] = "xllcorner" + delimmer + xllcorner;
        rowStream[ 3 ] = "yllcorner" + delimmer + yllcorner;
        rowStream[ 4 ] = "cellsize" + delimmer + cellsize;
        rowStream[ 5 ] = "NODATA_value" + delimmer + NODATA;
        
        for( int n = HEAD_SIZE; n < rowStream.length; n++)
        {
            String rowEntries = "";
            
            for( int m = 0; m < this.w; m++)
            {
            
                rowEntries += cells[m][n-HEAD_SIZE] + delimmer;        
            }
            rowEntries += delimmer;
            rowStream[n] = rowEntries;
        }
        
        saveStrings( fileName, rowStream );   
        println( "ASC Grid " + this.w + " x " + this.h + ". Min: " + minValue + " Max: " + maxValue + " written to " + fileName ); 
      
        // if there is a *.prj file associated with the the asc
        // copy it into a new prj 
        if( prjFileExists)
        {
          String prjFileName = split(fileName, ".")[0] + ".prj";
          saveStrings( prjFileName, projectionFile );
        }
        else{ println( "ASC file contains no *.prj file." ); }
    };
    
    ////////////////////////////////////////////////////////////////////////////
     int wrapX( int _x)
    {
          int xx = _x;
          
           if( xx < 0 ) xx = w-xx;            
            xx = xx % this.w;
        
            return xx;
    };

    ////////////////////////////////////////////////////////////////////////////
     int wrapY( int _y)
    {
          int yy = _y;
          
           if( yy < 0 ) yy = h-yy;            
            yy = yy % this.h;
        
            return yy;
    }
    
};

// class agent

import java.util.Iterator;

class Agent {

  PVector loc;
  PVector oLoc;
  PVector vel;
  PVector Accel;
  PVector target;
  int     LUhome;
  float   mag;
  int     kernelSize = 700; 
  float   slope;
  float   slopeVel = 1;
  float   maxVel = 2;
  float   minVel = 0 ;

  float num = random(0, 1);
  float treatmentProb;
  float surviveNoTreatment = 0.25;

  Kernel         k;            // each agent has a kernel
  boolean foundRoad = false;   // once the agent is on the road->true
  boolean  atTarget = false;   // once the agent is on the road pixel that is closest to target->true
  int         speed = 15;       

  /////////////////////////////////////////// merge variables
  boolean dead      = false;
  boolean sick      = false;
  boolean healed    = false;
  boolean infected  = false;
  boolean healthy   = true;
  boolean seek      = false;
  boolean noSeek    = false;
  boolean surviveNo = false;
  boolean hospHeal  = false;
  boolean seekNoHeal = false;
  boolean seekHeal = false;
  boolean noSeekNoHeal = false;
  boolean treatment = false;
  boolean treatment2 = false;
  boolean returned  = false;
  boolean deceased  = false;
  boolean plusNoSeek = false;
  boolean infectiousBody = true;

  int rad;
  int days = 0;
  float t = frameCount;
  float incubationPeriod = random(32, 300);
  int burialTimePeriod = 1;
  int burialTime = 0;
  int burialTime2 = 0;
  
  float offset = random(-10,10);

  ////////////////////////////////////////////////////////////

  Agent()
  {
    loc = new PVector( random(width), random(height) );
    vel = new PVector( random(-0.1, 0.1), random(-0.1, 0.1) );
    mag = 0.1;
  }

  Agent( float x, float y)
  {
    loc  = new PVector(x,y);
    oLoc = new PVector(x,y);
    vel  = new PVector(random(-0.1, 0.1), random(-0.1, 0.1) );
    mag  = 0.1;

    k = new Kernel();
    k.setNeighborhoodDistance(speed);
    k.isNotTorus();
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------//   

  void findRoad( Lattice l, int non_road )
  {
    k.setNeighborhoodDistance(40); // just very big
    // to find the nearest road point

    float minDist = width*2; // just make it big to start
    int   argMinX = 0;
    int   argMinY = 0;

    // 1. opens a very big kernel around the agent's location
    // 2. stores neighbors in an ArrayList of PVectors
    // 3. looks through all neighbors and finds the closest one
    //    that has a pixel with the road value in it
    // 4. updates its location to that road pixel
    // 5. sets the boolean that says it has found the road
    // 6. resizes the kernel to a normal range

    ArrayList<PVector> pv = k.getPVList(l, loc);
    for ( PVector p : pv )
    {
      if ( p.z > 0  && p.z != non_road ) { // finds a road pixel
        float thisDist = dist( loc.x, loc.y, p.x, p.y );

        if ( thisDist < minDist ) { // checks to see if it is the closest so far enountered
          minDist = thisDist;
          argMinX = (int)p.x;
          argMinY = (int)p.y;
        }
      }
    }//end for()

    foundRoad = true;

    loc = new PVector( argMinX, argMinY);
    k.setNeighborhoodDistance(speed);
  };

  void update( Lattice l )
  {
    minimize(l);
    checkTarget(l);
  };

  void minimize( Lattice l )
  {
    // look at all of the neighbors in the current kernel 
    // (of size, 'speed' above)
    // find the pixel with the smallest value and move there
    // this is how the cost surface is structured. road pixel
    // values increase as they move away from the target.
    // non-road pixels have the largest value in the lattice
    // therefore, the location on the road that gets an agent
    // closer to the target is always the smallest valued one.
    // ... so move there.

    loc = k.getMin(l, loc);
  };

  void checkTarget( Lattice l )
  {
    // the closest road pixel to the target always
    // has a value of 1. if the road pixel that the
    // agent is currently sitting on has the value of 1
    // it has arrived at its destination
    // set 'atTarget' == true

    PVector test = k.getMin(l, loc);
    if ( test.z == 1){
      atTarget = true;
    }
  };    

  //---------------------------------------------------------------//   

  void setHomeClass( int LUclass )
  {
    LUhome = LUclass;
  }

  void findTarget( ArrayList<HealthZone> healthZones )
  {         
    float minDistance = MAX_FLOAT;
    boolean isTemporarySeen = false;
    boolean targetIsTemporary = false;
    if (target != null) return;
    else target = null;

    for (HealthZone z : healthZones) 
    {
      if (isTemporarySeen && !z.isTemporary) continue;
      if (z.isTemporary) isTemporarySeen = true;
      if (!z.isTemporary && z.healProbability <= .35) continue;
      if (z.isTemporary && z.healProbability2 <= .35) continue;
      float distance = loc.dist(z.loc);
      if (distance < minDistance || (!targetIsTemporary && z.isTemporary)) 
      {
        minDistance = distance;
        //float offset = random(-5,5);
        //PVector off = new PVector(offset,offset);
        target = z.loc;
        //targetIsTemporary = z.isTemporary;
      }
    }
  }

  void update( ArrayList<HealthZone> healthZones, float slope )
  {    

    slopeVel = map(slope, 0, 45, 0.5, 0); // find max slope val

    updateVelocityMagnitude();

    float xValue3  = hs3.getPos();;
    float pubAwarness = map(xValue3,  xbar+95, xbar + 305, 0, 1);


    for ( HealthZone h : healthZones){
      float ETUdistance = dist(h.loc.x,h.loc.y,loc.x,loc.y);
      if (h.isTemporary && ETUdistance < 130){
        
        if (pubAwarness < .25 ){
      pubAwarness = pubAwarness*3;
        }
        else if (pubAwarness >= .25 && pubAwarness < .45 ){
      pubAwarness = pubAwarness*2;
        }
        else if (pubAwarness >= .45){
      pubAwarness = pubAwarness*1.5;
        }     
      }
    }
      
    treatmentProb = pubAwarness;

    if ( target != null)
    {
      updateVelocityDirection();
    }

    if (infected)
    { 
      t += 1;
     
      if (t >= incubationPeriod) {    
        getSick(minDays, maxDays);
      }
      
      if(frameCount % 100 == 0){
      vel.x *= -3;
      vel.y *= -3;
      }
    }
    
    if (deceased) {
    if (frameCount%16 == 0) {
      burialTime += 1;
    } 
      if (burialTime < burialTimePeriod){
        infectiousBody = true;
        //println("true");
      }  
      
      else if (burialTime >= burialTimePeriod){
        infectiousBody = false;
        
        //println("false");
      }
      
    }
    
    
    //if (deceased) {
    //if (frameCount % 16 == 0) {
      
    //  burialTime += 1;
     
    //  if (burialTime <= burialTimePeriod){
    //    infectiousBody = true;
    //  }  
    //  else if (burialTime > burialTimePeriod){
    //    infectiousBody = false;
    //  }  
    // }
    //}
    
    if (sick)
    {
      if (num < treatmentProb) {     
        //findTarget(healthZones);
        seek = true; 
      } 
      
      else {
        noSeek = true;
      }
    }

    if (healthy && frameCount % 100 == 0) {
      vel.x *= -3;
      vel.y *= -3;
    }

    if ( frameCount%framesPerDay == 0 && sick == true)
    {
      days -=1;
     
      if (days == 0 ) { 
        
        if (treatment) {
          if (num < constrain(healProbability, 30, 100)) {
            getHealed();
          }
        }

        if (treatment2) {
          if (num < constrain(healProbability2, 30, 100)) {
            getHealed();
          }
        }

        if (num < surviveNoTreatment) {
          getHealed();
          surviveNo = true;
        } 
        
        else {
          dead = true;
        }
      }
    }

    loc.add(vel);
    bounce();
    stats();
  }

  void stats() {

    if (seek && healed) {
      seekHeal = true;
    }

    if (seek && dead) {
      seekNoHeal = true;
    }

    if (noSeek && dead) {
      noSeekNoHeal = true;
    }
  }

  void updateVelocityDirection()
  {
    float originalMag = vel.mag();
    vel = new PVector(target.x - loc.x, target.y - loc.y);
    vel.setMag(originalMag);
  }

  void updateVelocityMagnitude()
  {
    float newMag = maxVel * slopeVel*slopeVel; // change this to be what you want
    newMag = constrain(newMag, minVel, maxVel);
    vel.setMag(newMag);
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
      seek = true;
      noSeek   = false;
      healed = true;
      target = null;
      dead = false;
      treatment = false;
    }
  }
  
  void getReturned(){
    if(healthy){
    returned = true;
    sick     = false;
    healed   = false;
    dead     = false;
    seek     = false;
    noSeek   = false;
  }
  }
  
    void getDeceased(){
    if(healthy){
    deceased = true;
    returned = false;
    sick     = false;
    healed   = false;
    dead     = false;
    seek     = false;
    noSeek   = false;
  }
  
 }

  void getTreatment() {
    if (sick) {
      treatment = true;
      vel = new PVector(0, 0);
    }
  }

  void getTreatment2() {
    if (sick) {
      treatment2 = true;
      vel = new PVector(0, 0);
    }
  }

  void getDead()
  {
    if (sick) 
    {
      sick = false;
      dead = true;
    }
    if (seek) {
      seek = true;
    }
    if (noSeek){
     noSeek = true;
    }
  }

  void drawAgent()
  {
    if (sick) {
      fill(255);
      rad = 3;
      speed = 10;
    } 

    if (infected) {
      fill(255);
      rad = 3;
      speed = 5;
    } 

    if (healed) {
      fill(255); 
      rad = 3;
    }
    
    if (returned) {
      fill(255); 
      rad = 4; 
    }
    
    if (deceased) {
      fill(255);
      rad = 4;
    }

    if (healthy) {
      fill(255,90); 
      rad = 2;
    }

    noStroke();
    ellipseMode( CENTER );
    ellipse( loc.x+offset, loc.y+offset, rad, rad );

    strokeWeight(2);
    if ( sick ) {
      noFill();
      stroke(255, 48, 36,170);
      ellipse(loc.x+offset, loc.y+offset, 10, 10);
    }
    
    if(returned){
      noStroke();
      fill(3, 191, 103);
      ellipse(loc.x+offset, loc.y+offset, 5, 5);
    }
    
    if(deceased){
      
      noStroke();
      fill(138, 43, 226);

//      if (frameCount%framesPerDay == 0) {
//      burialTime2 += 1;
//    } 
//      if (burialTime2 < burialTimePeriod){
        
        ellipse(loc.x+offset, loc.y+offset, 5, 5);
        noFill();
        stroke(138, 43, 226);
      //}  
      //else if (burialTime2 >= burialTimePeriod){
      //  noFill();
      //  noStroke();
      //}
      
    ellipse(loc.x+offset, loc.y+offset, 20, 20);
      
    }
    
    if(infected) {
      noFill();
      stroke(254, 184, 1,170);
      ellipse(loc.x+offset, loc.y+offset, 10, 10);
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
    if (loc.y < 0 || loc.y >= height) {
      vel.y *= -1;
    }
  }
}

void removeSick()
{
  Iterator iter = population.iterator();
  Agent tempAgent;

  while ( iter.hasNext() )
  {    
    tempAgent = (Agent)iter.next();
    if ( tempAgent.sick == true && tempAgent.noSeek == true)
    {
      //numNoSeek += 1;
    }
    
    if ( tempAgent.sick == true && tempAgent.seek == true)
    {
      iter.remove();
     // numSeek += 1;
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
    if ( tempAgent.dead == true)
    {
      deadAgent(tempAgent.oLoc.x, tempAgent.oLoc.y);
      noStroke();
      fill(138, 43, 226);
      ellipse( tempAgent.loc.x, tempAgent.loc.y, 35, 35);
      iter.remove();
      totalDeaths  += 1;
    }
  }
}

void removeDeceased()
{
  Iterator iter = popRecord.iterator();
  Agent tempAgent;

  while ( iter.hasNext() )
  {    
    tempAgent = (Agent)iter.next();
    if ( tempAgent.deceased == true && !tempAgent.infectiousBody)
    {
      iter.remove();
    }
  }
}

void removeDeadCar()
{
  Iterator iter = cars.iterator();
  MultiTargetFinder tempCar;

  while ( iter.hasNext() )
  {    
    tempCar = (MultiTargetFinder)iter.next();
      
    if ( tempCar.dead == true)
    {
      deadAgent(tempCar.oLoc.x, tempCar.oLoc.y);
      noStroke();
      fill(138, 43, 226);
      ellipse( tempCar.loc.x, tempCar.loc.y, 35, 35);
      iter.remove();
      totalDeaths  += 1;
      deathsPerDay += 1;
      
      if (tempCar.atTarget){
        numHospNoHeal += 1;
      }
    }
      
      if (tempCar.healed == true)
      { 
      numHealed += 1;  
      //newAgent(tempCar.oLoc.x, tempCar.oLoc.y);  
      noStroke();
      fill(0, 255, 0);
      ellipse( tempCar.loc.x, tempCar.loc.y, 40, 40);
      iter.remove();
      
      if (tempCar.atTarget){
        numHospHeal += 1;
     }  
     
   }

      if(frameCount % 48 == 0){
       deathsPerDay = 0; 
     }
    }

  }

  //class cost

import java.util.Stack;

class Cost{



  //You do not need to know how this class works in order to use it.
  //The functions in the main program are all you need to operate it.
  //But you are welcome to peek through it if you like.
  
  Kernel   k;
  Lattice cs;
   int  EMPTY_ROAD =   -99;
   int    NON_ROAD =     0;
         int    roadCode =     1;
     boolean moreOptimal =  false;
     
   PVector targetLocation;     
   
//---------------------------------------------------//
  Cost( Lattice l, int _roadCode )
  {
       roadCode = _roadCode;
             cs = new Lattice( l.w,l.h );
              k = new Kernel();
              k.isNotTorus();
        
        for( int x = 0; x < cs.w; x += 1 ){
        for( int y = 0; y < cs.h; y += 1 ){
          
              int val = (int) l.get(x,y);
              
              if( val == roadCode ){
                  cs.put(x,y,EMPTY_ROAD);
              }
              else{
                  cs.put(x,y,NON_ROAD);
              }
        }}
        
        calculateCost( new PVector(width/2, height/2)  );        
  };
    
//---------------------------------------------------//
  Cost( PImage pi, int _roadCode )
  {
       roadCode = _roadCode;
             cs = new Lattice(pi.width,pi.height);
              k = new Kernel();
              k.isNotTorus();
        
        for( int x = 0; x < cs.w; x += 1 ){
        for( int y = 0; y < cs.h; y += 1 ){
          
              int val = (int)red( pi.get(x,y) );
              
              if( val == roadCode ){
                  cs.put(x,y,EMPTY_ROAD);
              }
              else{
                  cs.put(x,y,NON_ROAD);
              }
        }}
        
        calculateCost( new PVector(width/2, height/2)  );

  };
  
//---------------------------------------------------//
  Cost( ASCgrid asc, int _roadCode )
  {
       roadCode = _roadCode;
             cs = new Lattice( asc.w,asc.h );
              k = new Kernel();
              k.isNotTorus();
        
        for( int x = 0; x < cs.w; x += 1 ){
        for( int y = 0; y < cs.h; y += 1 ){
          
              int val = (int) asc.get(x,y);
              
              if( val == roadCode ){
                  cs.put(x,y,EMPTY_ROAD);
              }
              else{
                  cs.put(x,y,NON_ROAD);
              }
        }}
        
        calculateCost( new PVector(width/2, height/2)  );

  };  
  
//---------------------------------------------------//  
  void initCostSurface()
  {
        for( int x = 0; x < cs.w; x += 1 ){
        for( int y = 0; y < cs.h; y += 1 ){
        
              int val = (int) cs.get(x,y);
              
              if( val != NON_ROAD ){
                  cs.put(x,y,EMPTY_ROAD);
              }
        }}
        
  }; 
  
//---------------------------------------------------//  
  Lattice getCostSurface()
  {
      return cs;
  };
  
//---------------------------------------------------//  
  Lattice getCostSurface( PVector target )
  {
      targetLocation = target;
      calculateCost( target );
      return cs;
  };
  
//---------------------------------------------------//  
  void calculateCost( PVector target )
  {
       if( moreOptimal ){ 
           println("* * * * CALCULATING COST SURFACE USING MULTIPLE PASSES * * * * ");
           println("This takes significantly more time to process");
           println("Set moreOptimal == false to reduce processing time");
           println("if less efficient routes are not an issue");
       };
    
       initCostSurface();
       int valAtTarget = (int)cs.get( (int) target.x, (int) target.y );

      if( valAtTarget == EMPTY_ROAD ){

          target.z = 1;
          costIterate( target );
      }else{
        
          PVector tt = findClosest(target);
          tt.z = 1;
          costIterate( tt );
      }
      
      // find maximum /////////////////////////////////////
      int maxVal = -1;
      for( int x = 0; x < cs.w; x += 1 ){
      for( int y = 0; y < cs.h; y += 1 ){
            maxVal = (int)max( maxVal, cs.get(x,y) );
      }}
      
      for( int x = 0; x < cs.w; x += 1 ){
      for( int y = 0; y < cs.h; y += 1 ){
           if( cs.get(x,y) == NON_ROAD ) 
                   cs.put(x,y,maxVal);
      }}
      NON_ROAD = maxVal;
      //////////////////////////////////////////////////////

  };
  
 //---------------------------------------------------//  
 void costIterate( PVector t )
  {
      Stack<PVector> cellList= new Stack<PVector>(); 

      cellList.push(t);
      
      while( !cellList.isEmpty() )
      {
          PVector   tmp = cellList.pop();
          int currDepth = (int)tmp.z; 
          cs.put((int)tmp.x, (int)tmp.y, currDepth );
          
          
          ArrayList<PVector> pv = k.getPVList( cs, tmp );
          
          for( PVector p : pv )
          {
              if( (int)p.z == EMPTY_ROAD )
              {     
                  cellList.push( new PVector( p.x, p.y, currDepth + 1 ) );
              }
              else if( moreOptimal && (int)p.z != NON_ROAD && (int)p.z != EMPTY_ROAD && (int)p.z > currDepth+1  )
              {
                  //cs.put((int)tmp.x, (int)tmp.y, currDepth+1 );
                  cellList.push( new PVector( p.x, p.y, currDepth + 1 ) );
              }
          } 
      }
      
      cellList.clear();
  }
  

//---------------------------------------------------//  
PVector findClosest( PVector tIn )
{
    float minDist = 99999;
    int argMinX = 0;
    int argMinY = 0;
                    
    for( int x = 0; x < cs.w; x++ ){
      for( int y = 0; y < cs.h; y++ ){
        

           if( cs.get(x,y) == EMPTY_ROAD ){ 
                 float thisDist = dist( tIn.x,tIn.y, x,y );  
                 if( thisDist < minDist )
                 {
                     minDist = thisDist;
                     argMinX = x;
                     argMinY = y;
                 }
           }
        
      }}
      
      return new PVector( argMinX, argMinY );
};


};

//class deswatch

class DEswatch
{
      
      color[] DE;
  
      DEswatch()
      {
           DE = new color [100];
           
           DE[5] = (int) color(8,81,156);     // degree 0.0 - 7.0
           DE[4] = (int) color(224, 172, 100);   // degree 7.0 - 11.0
           DE[3] = (int) color(183, 135, 67);  // degree 11.0-18.0
           DE[2] = (int) color(224, 172, 100);  // degree 18.0-25.0
           DE[1] = (int) color(255,255,255);        // degree 25.0-45.0
           DE[0] = (int) color(0,0,0);  // degree 45.0-90.0  not accessible 

      };

      color getColor( int DEcode )
      {  
            color defaultColor = color(239,243,255); // enter an invalid code number and
                                               // get K back.
            
            return (DEcode <= 255 && DEcode > 0)? DE[ DEcode ] : defaultColor;
      }
  
      color[] getSwatch()
      {
          return DE;
      }
}

// Class hscrollbar

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth;
    loose = l;
  }

  void updateScroll() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void displayScroll() {
    noStroke();
    fill(255,80);
    rect(xpos, ypos, swidth, sheight);
    fill(0,255,0,80);
    rect(xpos,ypos,spos-xbar,sheight);
    if (over || locked) {
      fill(0, 255, 0);
    } else {
      fill(0, 255, 0);
     
    }
    rect(spos, ypos, 2, sheight);   
  }
  
  void displayScroll2() {
    noStroke();
    fill(255,80);
    rect(xpos, ypos, swidth, sheight);
    fill(138, 43, 226, 80); 
    rect(xpos,ypos,spos-xbar,sheight);
    if (over || locked) {
      fill(138, 43, 226);
    } else {
      fill(138, 43, 226);
    }
    rect(spos, ypos, 2, sheight);   
  }
  
  void displayScroll3() {
    noStroke();
    fill(255,80);
    rect(xpos, ypos, swidth, sheight);
    fill(252, 193, 83, 120);
    rect(xpos,ypos,spos-xbar,sheight);
    if (over || locked) {
      fill(252, 193, 83);
    } else {
      fill(252, 193, 83);
    }
    rect(spos, ypos, 2, sheight);   
  }
  
    void displayScroll4() {
    noStroke();
    fill(255,80);
    rect(xpos, ypos, swidth, sheight);
    fill(78, 131, 201, 120);
    rect(xpos,ypos,spos-xbar,sheight);
    if (over || locked) {
      fill(78, 131, 201);
    } else {
      fill(78, 131, 201);
    }
    rect(spos, ypos, 2, sheight);   
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

// class healthzone

class HealthZone {
  PVector loc;
  boolean isTemporary;
  float r;
  float catchmentRadius;
  float magSickRate = 1.8;
  float healProb;
  float healProb2;
  float healProbability;
  float healProbability2;

  HealthZone(float x, float y, boolean t) { 
    loc = new PVector(x, y);
    isTemporary = t;
  }

  void drawCenter() {

    if (isTemporary) {
      drawHealthZone2();
    } else {
      drawHealthZone();
    }
    healthZonePer();
  }

  void drawHealthZone () {

    r = constrain(map(healProbability, 0, 0.8, 10, 40), 10,40);
    catchmentRadius = 100;

    stroke(0,255,0);
    strokeWeight(1);
    //noStroke();
    fill(0, 255, 0, 120);
    ellipse( loc.x, loc.y, r, r);
    noStroke();
    fill(255);
    rectMode(CENTER);
    rect( loc.x, loc.y, 8, 2);
    rect( loc.x, loc.y, 2, 8);
    fill(255, 25);
    stroke(255,50);
    strokeWeight(1);
    ellipse(loc.x, loc.y, catchmentRadius, catchmentRadius);
  }   

  void drawHealthZone2 () {

    r = constrain(map(healProbability2, 0, 0.8, 10, 30), 10, 30);
    catchmentRadius = 70;

    stroke(0, 255, 255);
    strokeWeight(1);
    fill(0, 255, 255, 120);
    ellipse( loc.x, loc.y, r, r);
    fill(255);
    rectMode(CENTER);
    rect( loc.x, loc.y, 8, 3);
    rect( loc.x, loc.y, 3, 8);
    fill(255, 25);
    stroke(255,50);
    strokeWeight(1);
    ellipse(loc.x, loc.y, catchmentRadius, catchmentRadius);
  }  

  void healthZonePer() {
    float xValue  = hs1.getPos();
    float xValue2 = hs2.getPos();
    float aidFactor  = map(xValue,xbar+95, xbar + 305, 0,2);
   // float aidFactor2 = map(xValue2,xbar+95, xbar + 305,0,2);
    float aidFactor2 = 1.5;
    int numTemp = 0;
    int numExist = 0;

      int catchmentPop = 0;
      int sickPop = 0;
      for (MultiTargetFinder a : cars) {
        float d = loc.dist(a.loc);
        if (d < catchmentRadius/2 ) {
          catchmentPop += 1;
          if (a.sick) sickPop += 1;
        }
      }
      
  for ( HealthZone h : healthZones)
    {
     if(h.isTemporary == true){
      numTemp += 1; 
     }
     if(h.isTemporary == false){
      numExist += 1; 
     }
    }
  
    if(numTemp < 2){ 
      numTemp = 1;
      }
      
      if(numExist < 2){ 
      numExist = 1;
      }
   
      float existBudget = 1-((100 / numExist) * 0.01);
      float tempBudget  = 1-((100 / numTemp) * 0.01);
      float perSick     = (float) sickPop * magSickRate / 100 * 100;
      
      healProb  = map(perSick, 0, 100, 0, 2);
      healProb2 = map(perSick, 0, 100, 0, 1);
      healProbability   = ((1 - healProb)  * aidFactor)/2;
      healProbability2  = ((1 - healProb2) * aidFactor2)/2 ;
      int healPercent   = constrain(round(healProbability * 100), 30, 100);
      int healPercent2  = constrain(round(healProbability2 * 100), 30, 100);

      fill(255);
      textSize(14);
      textAlign(CENTER);
      if (isTemporary == false) {
        text(healPercent + " %", loc.x+5, loc.y - 28 );
      }
      if (isTemporary == true) {
        text(healPercent2 + " %", loc.x+5, loc.y - 19 );
      }
      noStroke();
    }
  }


// class kernel


import java.util.Map;

class Kernel
{


  
////////////////////////////////////////////////////////////////
      int ringSize     = 1;
       boolean torus    = false;
       int kernelType   = 1;  // 1 - Moore, 2 - von Neumann
  
     int hoodSize     = 8; // size of neighborhood (moore = 8, Neumann = 4)
     float NaN        = -9999;

////////////////////////////////////////////////////////////////
    Kernel()
    {
        kernelType = 1; // default to Moore 
        if( kernelType == 1 ) hoodSize = 8;
        if( kernelType == 2 ) hoodSize = 4;
    }

////////////////////////////////////////////////////////////////    
    Kernel( int hoodtype )
    {
        if( hoodtype != 1 && hoodtype != 2 )
        {
            println( "ERROR: INVALID NEIGHBORHOOD. SETTING AS MOORE BY DEFAULT" );
            hoodtype = 1;
        }
        
        kernelType = hoodtype;
        if( kernelType == 1 ) hoodSize = 8;
        if( kernelType == 2 ) hoodSize = 4;
    }    
    
////////////////////////////////////////////////////////////////
    void setNeighborhoodDistance( int num ){  ringSize = max(1,num);   };

//////////////////////////////////////////////////////////////// 
    void isTorus(){  torus = true;   };
    
////////////////////////////////////////////////////////////////
    void isNotTorus(){ torus = false;  };
    
////////////////////////////////////////////////////////////////
    float getSum(float[][] matrix, int x, int y)
    {
        float[][] nHood = get(matrix, x, y);
        float summation = 0;
        
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
          
            if( nHood[i][j] != NaN)
            { summation += nHood[i][j]; }
        }}
        
        return summation;
    };
    
////////////////////////////////////////////////////////////////
    float getMean(float[][] matrix, int x, int y)
    {
        float[][] nHood = get(matrix, x, y);
        int     div = 0;
        float summation = 0;
        
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
          
            if( nHood[i][j] != NaN ){
              summation += nHood[i][j];
              div++;
            }
        }}
        
        return (summation / div );
    };
    
    ////////////////////////////////////////////////////////////////
    float getMin(float[][] matrix, int x, int y)
    {
        float[][] nHood = get(matrix, x, y);
        float minVal = -NaN;
            
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
            
            if( minVal != NaN )
                minVal = min( minVal, nHood[i][j]);
        }}
        
        return minVal;
    };
    
////////////////////////////////////////////////////////////////
    float getMax(float[][] matrix, int x, int y)
    {
        float[][] nHood = get(matrix, x, y);
    
        float maxVal = NaN;
        
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
            
            maxVal = max( maxVal, nHood[i][j]);
        }}
        
        return maxVal;
    };
   
////////////////////////////////////////////////////////////////
    float getRand(float[][] matrix, int x, int y)
    {
        ArrayList<Float> valList = new ArrayList<Float>();
        float[][] nHood = get(matrix, x, y);
        
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
            
           if( nHood[i][j] != NaN )
                valList.add(nHood[i][j]);
        }}
        
        return valList.get( floor( random(valList.size()) )    );
     }
     
////////////////////////////////////////////////////////////////
    float getMajority(float[][] matrix, int x, int y)
    {
        HashMap<Float,Integer> histo = new HashMap<Float,Integer>();
        float[][] nHood = get(matrix, x, y);
      
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
           
           float nVal = nHood[i][j];
           if( nVal != NaN)
           {
             if( histo.containsKey(nVal) ){ histo.put(nVal,histo.get(nVal)+1 ); }
             else{  histo.put(nVal,1); }
           }
           
        }}
                    
        float valMaj=-1;
        int maxCount = 0;
        for( Map.Entry kk : histo.entrySet() )
        {
            int cnt = (int)kk.getValue();
            if( cnt > maxCount )
            {  
                maxCount = cnt;
                valMaj   = (float)kk.getKey();
            }
        
        }
      return valMaj;

    }; 
    
//////////////////////////////////////////////////////////////// 
  float getWeightedSum( float[][] matrix, int x, int y, float[] weightArray )
  {
        int storeRingSize = ringSize;  // weight array length determins num rings,                 
        ringSize = weightArray.length; // so store the current ringSize state first.
        
        float[][] nHood = get(matrix, x, y);
        float weightedSum = 0;
        
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
          
            if( nHood[i][j] != NaN)
                weightedSum += (nHood[i][j]*weightArray[i]);
                
        }}
    
        ringSize = storeRingSize; // reinstate ring size
        return weightedSum;
  };
  
//////////////////////////////////////////////////////////////// 
    float[][] get( float[][] matrix, int x, int y)
    {
            float[][] kernel = new float[ringSize][hoodSize];
            for( int i = 1; i <= ringSize; i++)
            {    
               kernel[i-1] = getBand(matrix,i,x,y);  
            }
        
            return kernel;
    };

////////////////////////////////////////////////////////////////    

    float[] getBand( float[][] matrix, int band, int x, int y)
    {
        if( kernelType == 1 )
        {
            return getMooreBand( matrix, band, x, y);
        }
        else
        {
            return getNeumannBand( matrix, band, x, y);
        }
    }
    
////////////////////////////////////////////////////////////////    
    float[] getMooreBand( float[][] matrix, int band, int x, int y)
    {
        // this is a hacky way of doing this:
        // 11111111
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 11111111
        // but it works.
        
                band      = max(band,1);
        int     latWidth  = matrix.length;
        int    latHeight  = matrix[0].length;
        int     bandSize  = hoodSize * band;
        float[] thisBand  = new float[ bandSize ];
        int     cellIncr  = 0;
               
        for( int j=-band; j<=band; j++ ){ // y
        for( int i=-band; i<=band; i++ ){ // x
            
            if( (j==-band) || (j==band) )
            {  
               int xIndx = (torus)? wrap(x+i, latWidth)  : x+i;
               int yIndx = (torus)? wrap(y+j*1, latHeight) : y+j*1;
           float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);

              thisBand[ cellIncr ] = cellVal; 
             cellIncr++;
            }
            else if( (i==-band ) || (i==band) )
            {
                int xIndx = (torus)? wrap(x+i, latWidth)  : x+i;
                int yIndx = (torus)? wrap(y+j*1, latHeight) : y+j*1;
            float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);

                thisBand[ cellIncr ] = cellVal;
             cellIncr++;
            }
            
        }}         
        return thisBand;
    };

////////////////////////////////////////////////////////////////    
    float[] getNeumannBand( float[][] matrix, int band, int x, int y)
    {
        // this is a hacky way of doing this:
        //
        // 00100
        // 0   0
        // 1   1
        // 0   0
        // 00100
        //
        // but does it works?
        
                band      = max(band,1);
        int     latWidth  = matrix.length;
        int    latHeight  = matrix[0].length;
        int     bandSize  = hoodSize * band;
        float[] thisBand  = new float[ bandSize ];
        int     cellIncr  = 0;
               
        for( int j=-band; j<=band; j++ ){ // y
        for( int i=-band; i<=band; i++ ){ // x
            
            if( (j==-band && i==x) || (j==band && i==x) )
            {  
               int xIndx = (torus)? wrap(x+i, latWidth)  : x+i;
               int yIndx = (torus)? wrap(y+j*1, latHeight) : y+j*1;
           float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);
           
              thisBand[ cellIncr ] = cellVal; 
             cellIncr++;
            }
            else if( (i==-band && j==y ) || (i==band && j==y) )
            {
                int xIndx = (torus)? wrap(x+i, latWidth)  : x+i;
                int yIndx = (torus)? wrap(y+j*1, latHeight) : y+j*1;
            float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);

                thisBand[ cellIncr ] = cellVal;
             cellIncr++;
            }
            
        }}         
        return thisBand;
    };
    
    
////////////////////////////////////////////////////////////////    
    
              ////////////////////////////
             // PVECTOR INPUT METHODS  //
            ////////////////////////////

////////////////////////////////////////////////////////////////    
 
    float getSum( float[][] matrix, PVector loc)
    {
        return getSum( matrix, (int)loc.x, (int)loc.y );
    }; 

////////////////////////////////////////////////////////////////
    PVector getMin(float[][] matrix, PVector loc)
    {
        
        PVector[][] nHood = get(matrix, loc);
        float minVal      = -NaN;
        int minValx       =  (int) NaN;
        int minValy       =  (int) NaN;
        
            
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
            
            if( nHood[i][j].z < minVal && nHood[i][j].z != NaN )
            {
                minVal  = nHood[i][j].z;
                minValx = (int)nHood[i][j].x;
                minValy = (int)nHood[i][j].y;

            }
        }}
        
        // RETURNS VALUE(Z) AND LOCATION OF MIN CELL (X,Y)
        return new PVector( minValx, minValy, minVal );
    };   
    
////////////////////////////////////////////////////////////////
    PVector getMax(float[][] matrix, PVector loc )
    {
        PVector[][] nHood =   get(matrix, loc);
        float maxVal      =   NaN;
        int maxValx       =  (int) NaN;
        int maxValy       =  (int) NaN;
 
        for( int i = 0; i < nHood.length; i++ ){
        for( int j = 0; j < nHood[i].length; j++){
            
            if( nHood[i][j].z > maxVal && nHood[i][j].z != NaN )
            {
                maxVal  = nHood[i][j].z;
                maxValx = (int)nHood[i][j].x;
                maxValy = (int)nHood[i][j].y;

            }
        }}
 
        // RETURNS VALUE(Z) AND LOCATION OF MAX CELL (X,Y)
        return new PVector( maxValx, maxValy, maxVal );      
    };
    
////////////////////////////////////////////////////////////////
    float getMean(float[][] matrix, PVector loc )
    {
        return getMean(matrix, (int)loc.x, (int)loc.y );
    };

////////////////////////////////////////////////////////////////
    PVector getRand(float[][] matrix, PVector loc )
    {
//        println( "x " + loc.x + " y " + loc.y );
        
        ArrayList<PVector> valList = new ArrayList<PVector>();
        PVector[][]          nHood = get(matrix, loc);
        
        for( int i = 0; i < nHood.length; i++ ){   // rings
        for( int j = 0; j < nHood[i].length; j++){ // entities in ring
            
//            println( "i,j: " + i + "," + j + " x,y: " + nHood[i][j].x + " " + nHood[i][j].y );
            
            valList.add(nHood[i][j]);
        }
//          println();
        }
        
        return valList.get( floor( random(valList.size()) )    );
    };     
    
////////////////////////////////////////////////////////////////
    float getMajority(float[][] matrix, PVector loc )
    {
        return getMajority(matrix, (int)loc.x, (int)loc.y );
    }; 
      
////////////////////////////////////////////////////////////////
    float getWeightedSum(float[][] matrix, PVector loc, float[] weightArray )
    {
        return getWeightedSum(matrix, (int)loc.x, (int)loc.y, weightArray );
    };    
    
//////////////////////////////////////////////////////////////// 
    PVector[][] get( float[][] matrix, PVector loc )
    {
            PVector[][] kernel = new PVector[ringSize][hoodSize];
            for( int i = 1; i <= ringSize; i++)
            {    
               kernel[i-1] = getBand(matrix,i,loc);  
            }
        
            return kernel;
    };
    
////////////////////////////////////////////////////////////////    
    PVector[] getBand( float[][] matrix, int band, PVector loc )
    {
        // this is a hacky way of doing this:
        // 11111111
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 10000001
        // 11111111
        // but it works.
        
                  band      = max(band,1);
        int       latWidth  = matrix.length;
        int      latHeight  = matrix[0].length;
        int       bandSize  = hoodSize * band;
        PVector[] thisBand  = new PVector[ bandSize ];
        int       cellIncr  = 0;
        int       x         = (int)loc.x;
        int       y         = (int)loc.y;
        
               
        for( int j=-band; j<=band; j++ ){
        for( int i=-band; i<=band; i++ ){
            
            if( (j==-band) || (j==band) )
            {  
               int xIndx     = (torus)? wrap(x+i, latWidth)  : x+i;
               int yIndx     = (torus)? wrap(y+j*1, latHeight) : y+j*1;
               float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);

               thisBand[ cellIncr ] = new PVector( xIndx, yIndx, cellVal ); 
               cellIncr++;
            }
            else if( (i==-band ) || (i==band) )
            {
                int xIndx     = (torus)? wrap(x+i,       latWidth) : x+i;
                int yIndx     = (torus)? wrap(y+j*1, latHeight) : y+j*1;
                float cellVal = (torus)? matrix[xIndx][yIndx] : edge(matrix, xIndx, yIndx);
                
                thisBand[ cellIncr ] = new PVector (xIndx, yIndx, cellVal); 
                cellIncr++;
            }
            
        }}
              
        return thisBand;
    };
    
 ////////////////////////////////////////////////////////////////    
    
              ////////////////////////////
             // LATTICE INPUT METHODS  //
            ////////////////////////////

////////////////////////////////////////////////////////////////    
    float getSum(Lattice lat, int x, int y)
    {
        return getSum(lat.getlattice(), x, y);
    }
    
////////////////////////////////////////////////////////////////    
    float getMean(Lattice lat, int x, int y)
    {
        return getMean(lat.getlattice(), x, y);
    }
    
////////////////////////////////////////////////////////////////    
    float getMin(Lattice lat, int x, int y)
    {
        return getMin(lat.getlattice(), x, y);
    } 

////////////////////////////////////////////////////////////////    
    float getMax(Lattice lat, int x, int y)
    {
        return getMax(lat.getlattice(), x, y);
    } 
    
////////////////////////////////////////////////////////////////    
    float getRand(Lattice lat, int x, int y)
    {
        return getRand(lat.getlattice(), x, y);
    } 

////////////////////////////////////////////////////////////////    
    float getMajority(Lattice lat, int x, int y)
    {
        return getMajority(lat.getlattice(), x, y);
    } 
 
////////////////////////////////////////////////////////////////    
    float getWeightedSum(Lattice lat, int x, int y, float[] weightArray)
    {
        return getWeightedSum(lat.getlattice(), x, y, weightArray);
    } 

////////////////////////////////////////////////////////////////    
    float[][] get(Lattice lat, int x, int y)
    {
        return get(lat.getlattice(), x, y);
    } 

////////////////////////////////////////////////////////////////    
    PVector   getMin( Lattice lat, PVector loc )
    {
        return getMin( lat.getlattice(), loc );
    }

////////////////////////////////////////////////////////////////    
    PVector   getMax( Lattice lat, PVector loc )
    {
        return getMax( lat.getlattice(), loc );
    }
    
////////////////////////////////////////////////////////////////    
    PVector   getRand( Lattice lat, PVector loc )
    {
        return getRand( lat.getlattice(), loc );
    }
    
////////////////////////////////////////////////////////////////
    ArrayList<PVector> getPVList(float[][] matrix, PVector loc )
    {
//        println( "x " + loc.x + " y " + loc.y );
        
        ArrayList<PVector> valList = new ArrayList<PVector>();
        PVector[][]          nHood = get(matrix, loc);
        
        for( int i = 0; i < nHood.length; i++ ){   // rings
        for( int j = 0; j < nHood[i].length; j++){ // entities in ring
            
//            println( "i,j: " + i + "," + j + " x,y: " + nHood[i][j].x + " " + nHood[i][j].y );
            
            valList.add(nHood[i][j]);
        }
//          println();
        }
        
        return valList;
    }; 
    
////////////////////////////////////////////////////////////////
    ArrayList<PVector> getPVList(Lattice matrix, PVector loc )
    {
//        println( "x " + loc.x + " y " + loc.y );
        
        ArrayList<PVector> valList = new ArrayList<PVector>();
        PVector[][]          nHood = get(matrix.getlattice(), loc);
        
        for( int i = 0; i < nHood.length; i++ ){   // rings
        for( int j = 0; j < nHood[i].length; j++){ // entities in ring
            
//            println( "i,j: " + i + "," + j + " x,y: " + nHood[i][j].x + " " + nHood[i][j].y );
            
            valList.add(nHood[i][j]);
        }
//          println();
        }
        
        return valList;
    }; 
////////////////////////////////////////////////////////////////
    PVector getNearest(Lattice matrix, PVector loc, float val )
    {
        ArrayList<PVector> hd = getPVList(matrix,loc);
        
        ArrayList<PVector> values = new ArrayList<PVector>(); 
        int valueCount = 0;
        
        for( PVector h : hd )
        {
            if( h.z == val )
            {
                values.add( h );
                valueCount++;
            }
        }
        
        if( valueCount == 0 )
        {
          return null;
        }
        
        
        float minDist = width * height; // arbitrarily large
        int    argMin = 0;
        for( int n = 0; n < values.size(); n ++ )
        {
            float thisDist = dist( loc.x, loc.y, values.get(n).x, values.get(n).y );
            if( thisDist < minDist )
            {
                minDist = thisDist;
                argMin  = n;
            }
        }
        return values.get(argMin);
    }

    
////////////////////////////////////////////////////////////////
        int wrap( int index, int iSize)
        {
            if( index < 0 )           index = iSize + index; //N.B. index is negative here
            else if( index >= iSize ) index = index - iSize;
            
            return index;
        };
        
////////////////////////////////////////////////////////////////   
        float edge( float[][] matrix, int x, int y)
        {
            int       latWidth  = matrix.length;
            int      latHeight  = matrix[0].length;
            
            float val = ((x>=0 && x<latWidth) && (y>=0 && y<latHeight))? matrix[x][y] : NaN;
            return val;
        }
    

};

// class lattice 

import java.util.Map;

class Lattice
{



    int w = 0;
    int h = 0;
    float[][] lattice;
    boolean[][] cellLock; //toggle whether a cell can be altered 

////////////////////////////////////////////////////////////////
     Lattice( int _w, int _h, float val )
    {
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
        lattice = new float[w][h];
       cellLock = new boolean[w][h];

        
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
       
             lattice[i][j] = val;  
            cellLock[i][j] = false;
        }} 
    };

////////////////////////////////////////////////////////////////
     Lattice(int _w, int _h)
    {
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
        lattice = new float[w][h];
       cellLock = new boolean[w][h];

        
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
       
            lattice[i][j] = 0;  
           cellLock[i][j] = false;
        }}
    }

////////////////////////////////////////////////////////////////    
     Lattice(int _w, int _h, float _min, float _max )
    {
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
         lattice = new float[w][h];
        cellLock = new boolean[w][h];
        
          for( int i = 0; i < lattice.length; i++){
          for( int j = 0; j < lattice[0].length; j++){
         
              lattice[i][j] = random(_min,_max);
             cellLock[i][j] = false;
          }}    
    };
    
////////////////////////////////////////////////////////////////
     Lattice(int _w, int _h, float _min, float _max, String _flag )
    {
        String Round = "ROUND";
        String Bind  = "BIND";
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
         lattice = new float[w][h];
        cellLock = new boolean[w][h];
        
          for( int i = 0; i < lattice.length; i++){
          for( int j = 0; j < lattice[0].length; j++){
         
            if( Round.equals(_flag.toUpperCase()) )
            {
                   lattice[i][j] = round(random(_min,_max));
            }
            else if(Bind.equals(_flag.toUpperCase()))
            {
              lattice[i][j] = random(0,1.0)<=0.5 ? _min : _max;
            }
            else
            { 
              lattice[i][j] = random(_min,_max); 
              println( "WARNING: Lattice Method " + _flag+ " not recognize.");
              println( "         Lattice will be filled with random numbers between " + _min + " and " + _max );
            }
             
            cellLock[i][j] = false;
          }}    
    };
    
 ////////////////////////////////////////////////////////////////   
     Lattice(int _w, int _h, int _min, int _max )
    {  // random binary lattice with either min OR max value

        println( "This Method DEPRECIATED. Use Lattice(int _w, int _h, float _min, float _max, \"BIND\" ) instead.");
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
         lattice = new float[w][h];
        cellLock = new boolean[w][h];
        
          for( int i = 0; i < lattice.length; i++){
          for( int j = 0; j < lattice[0].length; j++){
         
              lattice[i][j] = random(0,1.0)<=0.5 ? _min : _max;
             cellLock[i][j] = false;
          }}    
    };


////////////////////////////////////////////////////////////////
     Lattice(int _w, int _h, float _min, float _max, float prob )
    {  // random binary lattice with either min OR max value 
       // where max is assigned with probability of prob, and min is assigned
       // with a probability of (1-prob)

        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
         lattice = new float[w][h];
        cellLock = new boolean[w][h];
        
          for( int i = 0; i < lattice.length; i++){
          for( int j = 0; j < lattice[0].length; j++){
         
              lattice[i][j] = random(0,1.0)<=prob ? _max : _min;
             cellLock[i][j] = false;
          }}    
    };
    
////////////////////////////////////////////////////////////////
     Lattice(int _w, int _h, int _min, int _max, float prob )
    {  // random binary lattice with either min OR max value 
       // where max is assigned with probability of prob, and min is assigned
       // with a probability of (1-prob)
       
        w = PApplet.max(0, _w);
        h = PApplet.max(0, _h); 
         lattice = new float[w][h];
        cellLock = new boolean[w][h];
        
          for( int i = 0; i < lattice.length; i++){
          for( int j = 0; j < lattice[0].length; j++){
         
              lattice[i][j] = random(0,1.0)<=prob ? _max : _min;
             cellLock[i][j] = false;
          }}
    } 
    
////////////////////////////////////////////////////////////////
    void replaceWith( Lattice l )
    {    
       w = l.w;
       h = l.h;
       lattice = new float[w][h];
      
        for( int xx = 0; xx < w; xx++){
          for( int yy = 0; yy < h; yy++){
            
                lattice[xx][yy] = l.lattice[xx][yy];  
          }}
    }
    
////////////////////////////////////////////////////////////////
    void put( int x, int y, float val )
    {    
        if( !cellLock[ testX(x) ][ testY(y) ] )
             lattice[ testX(x) ][ testY(y) ] = val;
    };
    
////////////////////////////////////////////////////////////////
    void put( PVector pv )
    {
        if( !cellLock[testX( (int)pv.x )][testY( (int)pv.y )] )
                put( testX( (int)pv.x ), testY( (int)pv.y ), pv.z );
    };
    
 ////////////////////////////////////////////////////////////////   
    float get( int x, int y )
    {
        return lattice[testX(x)][ testY(y)];
    };
    
////////////////////////////////////////////////////////////////    
    float getNorm( int x, int y)
    {
        float minval = this.min();
        float maxval = this.max(); 
        if( minval != maxval )
        {  return map( lattice[testX(x)][ testY(y)], minval, maxval, 0, 1.0); }
        else return 0;
    };

 ////////////////////////////////////////////////////////////////   
    PVector getcell( int x, int y)
    {
        return new PVector(testX(x), testY(y), get(testX(x), testY(y)) );
    };
    
////////////////////////////////////////////////////////////////    
    float[][] getlattice()
    {
        return lattice;
    };

////////////////////////////////////////////////////////////////
    void lock( int x, int y)
    {
        cellLock[testX(x)][testY(y)] = true;
    }
    
////////////////////////////////////////////////////////////////
    void unlock( int x, int y)
    {
        cellLock[testX(x)][testY(y)] = false;
    }
    
////////////////////////////////////////////////////////////////    
    void lockAll()
    {
        for( int i = 0; i < cellLock.length; i++){
        for( int j = 0; j < cellLock[0].length; j++){
    
              cellLock[i][j] = true;         
        }}
    };
    
////////////////////////////////////////////////////////////////
    void unlockAll()
    {
        for( int i = 0; i < cellLock.length; i++){
        for( int j = 0; j < cellLock[0].length; j++){
    
              cellLock[i][j] = false;         
        }}
    };
    
////////////////////////////////////////////////////////////////    
    float max()
    {
        float maxval = -9999;
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
    
              maxval = PApplet.max(maxval, lattice[i][j] );          
        }}
        
        return maxval;
    };
    
////////////////////////////////////////////////////////////////    
    float min()
    {
        float minVal = 9999;
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
    
              minVal = PApplet.min(minVal, lattice[i][j] );
          
        }}      
        return minVal;
    };
    
////////////////////////////////////////////////////////////////    
    float average()
    {    
        int   cnt = 0;
        float sum = 0;
        
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
    
              sum += lattice[i][j];
              cnt++;
        }}      
        
        return sum / cnt;
    };
    
////////////////////////////////////////////////////////////////
    PVector[] histogram()
    {
        HashMap<Float,Integer> histo = new HashMap<Float,Integer>();
        int numEntries = 0;
        PVector[] histReturn;
        
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
    
             float val = lattice[i][j];     
             if( histo.containsKey(val) ){ histo.put(val,histo.get(val)+1 ); }
             else{  histo.put(val,1); numEntries++; }
        }}
        
        
        histReturn = new PVector[ numEntries ];
        int k = 0;
        
        for( Map.Entry kk : histo.entrySet() )
        {
            histReturn[k] = new PVector( (float)kk.getKey(), (int)kk.getValue()) ;
            k++;
        }
        
        return histReturn;
    };
    
////////////////////////////////////////////////////////////////    
    PImage getPImage()
    {
        PImage img = new PImage(w,h);
        
        int minny = floor( this.min() );
        int maxxy = floor( this.max() );
        
        for( int i = 0; i < lattice.length; i++){
        for( int j = 0; j < lattice[0].length; j++){
    
              int val = round( map( lattice[i][j], minny, maxxy, 0, 255) );
              color c = color(val,val,val);
              img.set(i,j, c);
        }}
        
        return img;
    };
    
 ////////////////////////////////////////////////////////////////   
    int testX( int x )
    {
        if( x < 0 )
        {
           x = constrain(x,0, lattice.length-1); 
           println( "WARNING: X index out of bounds, negative number ");
        }
        
        else if(  x >= lattice.length)
        {
            x = constrain(x,0, lattice.length-1);
            println( "WARNING: X index out of bounds, too big! ");
        }
        
        return x;
    };
    
////////////////////////////////////////////////////////////////    
    int testY( int y )
    {
        if( y < 0 )
        {
            y = constrain(y,0, lattice[0].length-1);
            println( "WARNING: Y index out of bounds, negative number!");
        }
        
        else if( y >= lattice[0].length)
        {
            y = constrain(y,0, lattice[0].length-1);
            println( "WARNING: Y index out of bounds, too big!");
        }
        
        return y;
    };
       
};

// class multitarget

class MultiTargetFinder extends Agent {

  // MultiTargetFinder has all of the functions of PathFinder with a few new tricks
  // It can read in an ArrayList of costsurfaces (i.e. paths to multiple targets )
  // it spends a certain amount of time at a target before moving on to the next one
  // in a continuous loop...

  int currentTarget = 0;       // this holds the number of the current cost surface it is reading
  int timeCounter   = 0;       // this counter is used to calculate how long it has been at a target, once there  
  int timerCutOff   = 90;      // sit at each target roughly 3 seconds
  
  //---------------------------------------------------//
  MultiTargetFinder( float x, float y )
  {
    super(x, y);
  };
  
//---------------------------------------------------//
 
//void pickTarget( ArrayList<Cost> ccsIn )
//  {
//      //println("Current target: " + currentTarget);
//      float minDist = MAX_FLOAT;
//      int   argMin  = 0;
//      int   rand = 0;
      
//      boolean isTemporarySeen = false;
//      boolean targetIsTemporary = false;  

//      if (target != null) return;
//      else target = null; 

//      for( int i = 0; i < ccsIn.size(); i++ )
//      {
//        rand = (int)random(0,i);  
//        //println("rand value = " + rand);
        
//      for (HealthZone z : healthZones){
//            if (isTemporarySeen && !z.isTemporary) continue;
//            if (z.isTemporary) isTemporarySeen = true;
      
//          PVector targetLoc = ccsIn.get(i).targetLocation;
//          float   thisDistance = dist( loc.x, loc.y, targetLoc.x, targetLoc.y);
          
//           if( thisDistance <= minDist || (!targetIsTemporary && z.isTemporary)) 
//           {
//              minDist = thisDistance;
//              argMin  = i;
//              targetIsTemporary = z.isTemporary;
//          }
//      }
//  }

//if( random(0,1) < 1.0 ){ 
//  currentTarget = argMin;
// }
//else{
//currentTarget = rand; 
// }
//}

void pickTarget( ArrayList<Cost> ccsIn )
  {
      //println("Current target: " + currentTarget);
      float minDist = MAX_FLOAT;
      int   argMin  = 0;
      
      boolean isTemporarySeen = false;
      boolean targetIsTemporary = false;  
      if (target != null) return;
      else target = null;
      
      for( int i = 0; i < ccsIn.size(); i++ )
      {
        
      for (HealthZone z : healthZones){
            if (isTemporarySeen && !z.isTemporary) continue;
            if (z.isTemporary) isTemporarySeen = true;
            
          PVector targetLoc = ccsIn.get(i).targetLocation;
          float   thisDistance = dist( loc.x, loc.y, targetLoc.x, targetLoc.y);
           if( thisDistance <= minDist || (!targetIsTemporary && z.isTemporary)) 
           {
              minDist = thisDistance;
              argMin  = i;
              targetIsTemporary = z.isTemporary;
          }
       }
  }
  
  currentTarget = argMin; 
  
  }
 

  //---------------------------------------------------//
  void findRoad(  ArrayList<Lattice> costSurfaces ) 
  {
    // passes the first lattice from the ArrayList to PathFider.findRoad()
    // uses the max() function to get the NON_ROAD value, since NON_ROAD pixels
    // have the maximum "cost" in the cost surface

    findRoad( costSurfaces.get(currentTarget), (int) costSurfaces.get(currentTarget).max() );
  };

  //---------------------------------------------------//
  void update( ArrayList<Lattice> costSurfaces )
  {
    // currentTarget holds the number of the current cost surface / target path
    // the agent is working on. This is passed to the minimize and check target functions
    // as usual 
    minimize( costSurfaces.get( currentTarget )  );
    checkTarget( costSurfaces.get( currentTarget )  );

    // this is the new function that helps an agent step through
    // the various cost surfaces / target paths
    
  //countTimeAtTarget( costSurfaces );
    
  };
  
    void countTimeAtTarget( ArrayList<Lattice> csrf )
  {
    // once an agent gets to a target, it stays there for "timerCutOff" number of frames
    // it then updates the cost surface it is following and goes to the next target
    // it cycles through all of the target cost surfaces in the arrayList

    if ( atTarget == true ) // if it is at its current target, start counting
    {                      // on every frame
      timeCounter += 1;
    }
         
    if ( timeCounter >= timerCutOff )
    {
      // if the counter goes above a threshold (in this case, about 3 seconds)
      // it is time to move on, so... 
      timeCounter = 0;       // reset counter;
      atTarget = true;   // reset target flag
      
      // cycle through to the next target cost surface.
      // we use the % to make sure the index never gets bigger
      // than the size of the arrayList 

    //  currentTarget = (currentTarget+1) % csrf.size();
      // in the update, currentTarget will now index the next cost surface
    }
  };
  
  //---------------------------------------------------//
  
  void updateHealth() {

    //dead percentage 
   for ( HealthZone s : healthZones) {  
    if ( frameCount%framesPerDay == 0 && sick == true)
      {
      days -=1;
      if (days == 0 ) { 

        
        if (atTarget & !s.isTemporary) {
          if (num < constrain(s.healProbability, .3, 1)) {
            getHealed();  
          }
          else {
          dead = true;
        }
       }

        if (atTarget & s.isTemporary) {
          if (num < constrain(s.healProbability2, .3, 1)) {
            getHealed();
          }
          else {
          dead = true;
        }
        }
        
        if (!atTarget){
        if (num < surviveNoTreatment) {
          getHealed();
          surviveNo = true;
        } 
         else {
          dead = true;
        }
      
        }
      }
    }
  }
 }

};
