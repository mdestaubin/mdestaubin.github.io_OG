int initialPopulationSize = 999;

ArrayList < Agent > population;
ArrayList < Agent > survivors;

int dayCounter = 0;

int framesPerDay = 60;

int currentPopulationSize = 0;

float popFluxRate = 0.001250;

PFont myFont;

PFont altFont;

PImage healthZone;

HScrollbar hs1;

//////////////////////// infection variables

int minDays = 3;

int maxDays = 7;

int spreadDistance = 5;

float infectionProbability;

float travelProbability;

int xStat = 1240;

int yTitle = 40;

int yDay = 80;

int yPop = 105;

int yHealthy = 140;

int ySick = 260;

int yInfected = 200;

int ySurvivors = 320;

int yDead = 380;

int yCFR = 490;

boolean isolate = false;

boolean isSetup = false;

int numDead = 0;

ArrayList<Float> sickHistory;

float xCord1 = 0;

boolean s1 = true;
boolean s2 = false;
boolean s3 = false;
boolean s4 = false;

boolean su1 = true;
boolean su2 = false;
boolean su3 = false;
boolean su4 = false;

int yPercent = 713;
int yPercent2 = 803;
int yPercent3 = 818;
int yButton1 = 690;
int yButton2 = 780;
int yButton3 = 805;
int yRvalue = 585;

void setup()

{
    size(1620,840);
    //fullScreen();

    frameRate(60);
    
    sickHistory =     new ArrayList<Float>();
    population = new ArrayList<Agent>();
    myFont = createFont("Arial Black", 32);
    altFont = createFont("Arial", 32);
    initailizePop();
    hs1 = new HScrollbar(xStat, yRvalue, 360, 6, 7);
}

void draw()

{
    background(38,38,38);
    fill(38,38,38);
    stroke(255);
    strokeWeight(2);
    rect(20,20,width-420,800,6); 
    line(xStat,yDead+80,xStat+360,yDead+80);
    line(xStat,yButton1-48,xStat+360,yButton1-48);
    //iline(xStat,yTitle+15,xStat+360,yTitle+15);
    line(xStat,yTitle-18,xStat+360,yTitle-18);

    for (Agent a: population) {
      if(isSetup){
        a.update(); 
      }
         }

///////////////////////////////////////////////////////////////////////////YEARLY CENSUS

    if (frameCount % framesPerDay == 0)

    {
        currentPopulationSize = population.size();
        dayCounter += 1;
        removeAgent();
    }

    infect();
    statsBar();
    scrollBar();
    //button01();
    
}

void scrollBar() {

  hs1.updateScroll();
  hs1.displayScroll();
  
  float xValue  = hs1.getPos();
  
  int    travel = round(map(xValue, xStat, xStat + 360, 0, 4));
  String travelPercent = nfc(travel);
  
  infectionProbability =  map(xValue, xStat, xStat + 360, 0, 0.2);
 
  
  textSize(16);
  textAlign(CENTER);
  fill(255);
  text("R", hs1.spos-5, hs1.ypos-18); 
  textSize(13);
  text(travelPercent, hs1.spos+10, hs1.ypos-18);  
  
}

void removeAgent() {
 for (int i = population.size() - 1; i >= 0; i--) {
          Agent d = population.get(i);
        if (d.dead == true) {
          population.remove(i);
          noStroke();
          fill(138, 43, 226,100);
          ellipse( d.loc.x, d.loc.y, 16, 16);
          numDead  += 1;
     } 
    // for (int len = population.size(), a = len; a-- != 0; )
    //if (population.get(a).dead) {
    //  population.set(a, population.get(--len));
    //  population.remove(len);
      //fill(138, 43, 226);
      //ellipse( a.loc.x, a.loc.y, 25, 25);
     
    //  for (Agent d : population){
    //  if (d.dead){
    //  numDead  += 1;
    //  }
    //redraw();
  // return;
      }
 
     
   } 
//}

////////////////////////////////////////////////////////////////////////////// STATS BAR  

void statsBar() {

    float popSize = population.size();
    
    float totalPop= popSize + numDead;

    float numSick = 0;

    float numInfected = 0;

    float numHealed = 0;

    float numHealthy = 0;
    
    

    for (Agent person: population) {

        if (person.sick == true) {

            numSick += 1;

        }

    }

    for (Agent person: population) {

        if (person.infected == true) {

            numInfected += 1;

        }

    }

    for (Agent person: population) {

        if (person.recovered == true) {

            numHealed += 1;

        }

    }

    //for (Agent person: population) {
    //    if (person.dead == true) {
    //        int x = 1;
    //        numDead = x++;
    //    }
    //}

    for (Agent person: population) {
        if (person.dead == false && person.recovered == false && person.infected == false && person.sick == false) {
            numHealthy += 1;
        }
    }
    
    float numAffected = numHealed + numDead + numInfected + numSick;
    
    //println("num" + numAffected);
    
    float percentSick = numSick / totalPop * 100;
    float percentInfected = numInfected / totalPop * 100;
    float percentHealed = numHealed / totalPop * 100;
    float percentDead = numDead / totalPop * 100;
    float percentCFR = (numDead / (numHealed + numDead)) * 100;
    float percentHealthy = numHealthy / popSize * 100;
    float percentAffected = numAffected / totalPop * 100;
    
    //println("percent" + percentAffected);
    
    fill(255);
    textAlign(LEFT);
    textFont(myFont);
    textSize(24);
    //text("COVID-19", xStat, yTitle, 360, 100);
    
    textFont(altFont);
    textSize(24);
    //text("SCENARIO SIMULATOR", xStat, yTitle+33, 360, 100);
    textSize(16);

    if(!isSetup){
     textAlign(CENTER);
     text("CLICK TO START", (width-420)/2, (height-40)/2);
     dayCounter = 0;
    }
    
    textAlign(RIGHT);
    
    text("FATALITY RATE: " + nf(percentCFR, 0, 2) + "%", xStat+360, yDead);
    
    text("INCUBATION PERIOD: 4-6" , xStat+360, yDead+105);
    
    text("INFECTION PERIOD: 3-7" , xStat+360, yDead+133);
    
    textAlign(LEFT);
    
    text("DAY: " + dayCounter, xStat, yDay);    

    text("POP: " + int(popSize), xStat, yPop);

    text("PREVELANCE: " + nf(percentAffected, 0, 2) + "%", xStat, yHealthy);

    text("ACTIVE INFECTED: " + int(numSick), xStat, ySick);

    text("ACTIVE EXPOSED: " + int(numInfected), xStat, yInfected);

    text("TOTAL RECOVERED: " + int(numHealed), xStat, ySurvivors);

    text("TOTAL DEATHS: " + int(numDead), xStat, yDead);
    
    text("SICK ISOLATION", xStat, yButton1-20);
    
    text("TRANSMISSION", xStat, yRvalue-45);
    
    text("SOCIAL DISTANCING", xStat, yButton2-20);
    
    //text("CONTACTS TRACED", xStat, yButton3-20);
    
    //textFont(myFont);
    textSize(18);
    
    text("ASSUMPTIONS", xStat, yDead+70);

    text("INTERVENTIONS", xStat, yButton1-58);
    
   // textAlign(CENTER);
    textSize(22);
    text("ViRS | COVID-19 SIM", xStat+3, yTitle+12);

    //fill(255,255,255,100);
    //rect(width/2-355,height-40,325,20);

    //fill(0,0,0);
    textAlign(CENTER);

    textFont(altFont);
    textSize(20);

    //String[] fontList = PFont.list();
    //println(fontList);

    //if(frameCount < 200){
   // text(" CLICK TO ADD EXPOSED AGENT  | |  SPACE BAR TO RESET", width / 2 - 200, height - 20);
    //}
    fill(255, 255, 255);


    float xScale = 100;

    float xHealthy = map(percentAffected, 0, xScale, 0, 360);

    float xSick = map(percentSick, 0, xScale, 0, 360);

    float xInfected = map(percentInfected, 0, xScale, 0, 360);

    float xSurvivors = map(percentHealed, 0, xScale, 0, 360);

    float xDead = map(percentDead, 0, xScale, 0, 360);
    
    //float xCFR = map(percentCFR, 0, xScale, 0, 360);

       textAlign(CENTER);
       textSize(16);
       noFill();
       stroke(255);
       if(s1){
         fill(180);
       }
       rect(xStat,yButton1,80,35, 7);
       fill(0);
       if(!s1){
       fill(200);
       }
       
       text("25%", xStat+42,yPercent);
       
       noFill();
       if(s2){
         fill(180);
       }
       rect(xStat+92,yButton1,80,35, 7);
       fill(0);
       if(!s2){
       fill(200);
       }
       
       text("50%", xStat+134,yPercent);
       
       noFill();
       if(s3){
         fill(180);
       }
       rect(xStat+184,yButton1,80,35, 7);
       fill(0);
       if(!s3){
       fill(200);
       }
       
       text("75%", xStat+226,yPercent);
       
       noFill();
       if(s4){
         fill(180);
       }
       rect(xStat+276,yButton1,80,35, 7);
       fill(0);
       if(!s4){
       fill(200);
       }
       
       text("100%", xStat+318,yPercent);
       noFill();
      
       if(su1){
         fill(180);
       }
       rect(xStat,yButton2,80,35, 7);
       fill(0);
       if(!su1){
       fill(200);
       }
       
       text("0%", xStat+42,yPercent2);
       
       noFill();
       if(su2){
         fill(180);
       }
       rect(xStat+92,yButton2,80,35, 7);
       fill(0);
       if(!su2){
       fill(200);
       }
       
       text("25%", xStat+134,yPercent2);
       
       noFill();
       if(su3){
         fill(180);
       }
       rect(xStat+184,yButton2,80,35, 7);
       fill(0);
       if(!su3){
       fill(200);
       }
       
       text("50%", xStat+226,yPercent2);
       
       noFill();
       if(su4){
         fill(180);
       }
       rect(xStat+276,yButton2,80,35, 7);
       fill(0);
       if(!su4){
       fill(200);
       }
       
       text("75%", xStat+318,yPercent2);
       
       

    noStroke();

    fill(25);

    rect(xStat, yHealthy + 10, 360, 25);

    rect(xStat, ySick + 10, 360, 25);

    rect(xStat, yInfected + 10, 360, 25);

    rect(xStat, ySurvivors + 10, 360, 25);

    rect(xStat, yDead + 10, 360, 25);
    
    //rect(xStat, yCFR + 10, 360, 25);



    fill(180,180);

    rect(xStat, yHealthy + 10, xHealthy, 25);

    fill(238, 109, 3, 150);

    rect(xStat, ySick + 10, xSick, 25);

    fill(255, 255, 0, 150);

    rect(xStat, yInfected + 10, xInfected, 25);

    fill(0, 255, 0, 100);

    rect(xStat, ySurvivors + 10, xSurvivors, 25);

    fill(138, 43, 226,150);

    rect(xStat, yDead + 10, xDead, 25);
    
    fill(255,100);

    //rect(xStat, yCFR + 10, xCFR, 25);



    //fill(255);

    //rect(0,height-30,xxHealthy, 30);

    //fill(255,0,0,150);

    //rect(xxHealthy,height-30,xxSick, 30);

    //fill(255,255,0,150);

    //rect(xxSick+ xxHealthy,height-30, xxInfected, 30);

    //fill(0,255,0,150);

    //rect(xxInfected + xxSick + xxHealthy,height-30,xxSurvivors, 30);

    //fill(255);

    //rect(xxSurvivors + xxInfected + xxSick + xxHealthy,height-30,xxDead, 30);


   //epi curve...
   
   // sickHistory.add(yCFR-(numSick/5));
   // strokeWeight(2);
   // xCord1 = xStat;
    
   // if (isSetup){
   // for (int i = 0; i < frameCount; i++) 
   // {
   // Float yInfected = sickHistory.get(i);
   //// Float yTotal = prevHistory.get(i);
   // strokeWeight(1);

   // stroke(100,10);
   // line(xCord1,yCFR,xCord1,yCFR-100);
   // noFill();
   // stroke(238, 109, 3, 30);
   // line(xCord1, yInfected, xCord1, yCFR);
    
   // //stroke(100,10);
   // //line(xCord1,yDead,xCord1,yDead+200);
   // //noFill();
   // //stroke(180,180);
   // //line(xCord1, yTotal, xCord1, yDead);

   // xCord1 = xCord1 + .08;

   //  }
   // }

    
    stroke(255);

    strokeWeight(1);

    //line(0, height-35, width, height-35);

    //line(1200, 0, 1200, height);
    
      if (numSick == 0 && numInfected == 0 && dayCounter > 2) {
    if (looping) {
      noLoop();
    } else {
      loop();
    }
  }

}

/////////////////////////////////////////////////////////////////////////// Infect

void infect()

{

    for (int i = 0; i < population.size(); i += 1) {

        Agent person1 = population.get(i);

        for (int j = i + 1; j < population.size(); j += 1)

        {

            Agent person2 = population.get(j);
            
            
            if (person1.sick || person2.sick){
            float distance = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);


            // first condition

            if (distance <= spreadDistance && person1.sick && !person2.sick && !person2.recovered)

            {

                ////////////////////// delay getting sick for X nbr of days? ////////////////////////

                //person 1 makes person 2 sick

                if (prob(infectionProbability) == true) {

                    person2.getInfected();
                    
                }

            } else if (distance <= spreadDistance && person2.sick && !person1.sick && !person1.recovered)

            {

                //person2 makes person1 sick

                if (prob(infectionProbability) == true) {

                    person1.getInfected();      
                  
                }
                
            }
                        }
            
            infectionLine(person1,person2);
                  //if (prob(infectionProbability) == true && person1.infected){
                  // stroke(255, 40);
                  // strokeWeight(3);
                  // line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
                  //}
                  //if(person2.infected){
                  // stroke(255, 40);
                  // strokeWeight(3);
                  // line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
                  //}

            
            //if(person1.recovered || person2.recovered){
            //removeSurvivor();
            //newSurvivor()
            //}
        }
    }
}



///////////////////////////////////////////////////////////////////////Probability Rate

boolean prob(float probRate)

{

    if (random(0, 1) <= probRate) {

        return true;

    } else {

        return false;

    }

}

/////////////////////////////////////////////////////////////////////// Initailize Pop

void initailizePop() {

    population = new ArrayList < Agent > ();

    for (int i = 0; i < initialPopulationSize; i += 1)

    {

        PVector L = new PVector(random(25, width - 407), random(25, height-26));        

        population.add(new Agent(L));

    }
    
    //infectedAgent();

}


void infectionLine(Agent person1, Agent person2) {
  
  float spreadDist = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

   if ((person1.infected && person2.sick) || (person2.infected && person1.sick)) {
      
      if (spreadDist < 100){

        stroke(255, 40);

        strokeWeight(2);

        line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
      }
    }

}

void infectedAgent(){
  
  PVector L = new PVector(random(0, width - 400), random(0, height));

    Agent infectedPerson = new Agent(L);

    infectedPerson.getInfected();

    infectedPerson.loc.x = (width-400)/2;

    infectedPerson.loc.y = (height-180)/2;

    population.add(infectedPerson);
}

////////////////////////////////////////////////////////////////////////////////Pop Flux

void popFlux()

{

    int numberToFlux = round(popFluxRate * currentPopulationSize);

    PVector H = new PVector(random(0, width), random(0, height - 35));

    while (numberToFlux > 0)

    {

        Agent parent = population.get((int) random(population.size()));

        Agent child = new Agent(H);

        // Child gets velocity from "parent" rather than

        // having it randomly assigned.

        child.vel = new PVector(parent.vel.x, parent.vel.y);

        population.add(child);

        numberToFlux -= 1;

    }

}

//============================================================//

void mousePressed()

{

    PVector L = new PVector(random(0, width - 400), random(0, height));

    Agent infectedPerson = new Agent(L);

    infectedPerson.getInfected();
    
    if(mouseY < (height-180) && mouseX  < (width-400)){
    
    if(!isSetup){
            isSetup = true;
          }

    infectedPerson.loc.x = mouseX;

    infectedPerson.loc.y = mouseY;

    population.add(infectedPerson);
    
    }

}

//void button01()
//{
//    if(mouseX>xStat && mouseX <xStat+70 && mouseY>0 && mouseY <height){
//     if(mousePressed){
//       if(!r1){
//       fill(255);
//       rect(xStat,600,70,30);
//       r1 = true; 
//       }
//       }
//      if(r1) {
//       noFill();
//       rect(xStat,600,70,30);
//       r1 = false; 
//       }

//  }
  
//}




////////////////////////////////////////////////////////////////////////////////// Reset

void keyPressed()

{

    if(key== '1'){
      s1 = true;
      s2 = false;
      s3 = false;
      s4 = false;
    }
    
    if(key== '2'){
      s1 = false;
      s2 = true;
      s3 = false;
      s4 = false;
    }
    
    if(key== '3'){
      s1 = false;
      s2 = false;
      s3 = true;
      s4 = false;
    }
    if(key== '4'){
      s1 = false;
      s2 = false;
      s3 = false;
      s4 = true;
    }
    
    if(key== 'q'){
      su1 = true;
      su2 = false;
      su3 = false;
      su4 = false;
    }
    
    if(key== 'w'){
      su1 = false;
      su2 = true;
      su3 = false;
      su4 = false;
    }
    
    if(key== 'e'){
      su1 = false;
      su2 = false;
      su3 = true;
      su4 = false;
    }
    if(key== 'r'){
      su1 = false;
      su2 = false;
      su3 = false;
      su4 = true;
    }

    if (key == ' ') {

        population.clear();
        //sickHistory.clear();

        for (int i = 0; i < initialPopulationSize; i += 1)

        { 
          
            PVector L = new PVector(random(25, width - 406), random(25, height-26));
            population.add(new Agent(L));
            dayCounter = 0;
            numDead = 0;
        }
        
        isolate = false;
        infectedAgent();
        loop();
    }
    
}

class Agent {

  PVector loc;

  PVector vel;
  
  PVector noVel;

  PVector accel;

  float topspeed;

  boolean dead = false;

  boolean sick = false;

  boolean recovered = false;

  boolean infected = false;

  int haloGrowth = 0;
  
  float deathRate = 0.1;

  PVector target;

  int rad;

  int perHealthy = 100;

  int days = 0;

  float t = frameCount;
  
  float randomNum = random(0, 1);

  float sickIsolateRate;
  
  float travelIsolate;
  
  boolean sickIsolate = false;
  
  boolean susceptible = true;

  Agent(PVector L)

  {

    loc = L;

    vel = new PVector(random(-2, 2), random(-2, 2));

    topspeed = 1.3;

    accel = new PVector(0, 0);

    target = new PVector(random(width), random(height));

    if (random(0, 100) < perHealthy) { 

      sick = false;
      susceptible = true;

    }

  }

  void update()

  {    

    if ( frameCount%framesPerDay == 0 && sick)

    {

      days -=1;

      if (days == 0){ 
        if(randomNum > deathRate){
         survive();
      }
      else {
      dead = true; 
         
      }
    }
   }
    
    if (infected)

    { 

      t += 1;

      if (t >= random(240,360)) {    

        getSick(minDays, maxDays);

      }

  }

    //vel.limit(topspeed);
    
    loc.add(vel);


   // recovered();

    bounce();

    drawAgent();

  }

  /////////////////////////////////////////////////////////////////// Check Environment Function

void survive()
{
  if (sick){
      sick = false;

      infected = false;

      recovered = true;

      fill(0, 255, 0);

      ellipse( loc.x, loc.y, 12, 12);
      
      if (recovered && sickIsolate){
         vel = new PVector(-2, 2);
  }
 }
}

void dead()
{
 sick = false; 
 recovered = false;
 dead = true;
}
  

  /////////////////////////////////////////////////////////////////////////////// DrawAgent Function

void drawAgent()

  {   
    if (isolate) {
      vel = new PVector(0, 0);  
    }

    if (susceptible){
      dead = false;
      fill(255); 
      rad = 3;
    }
    
    if (susceptible || infected || recovered){
    if(su1){
        travelIsolate = 0.0;
      }
      if(su2){
        travelIsolate = 0.25;
      }
      if(su3){
        travelIsolate = 0.50;
      }
      if(su4){
        travelIsolate = .75;
      }
      if (randomNum < travelIsolate){
       // travelIsolate = true;
     vel = new PVector(0, 0);
      }
    } 

    if ( sick ) {

      fill(238, 90, 30);
      susceptible = false;
      rad = 5;
      if(s1){
        sickIsolateRate = 0.25;
      }
      if(s2){
        sickIsolateRate = 0.5;
      }
      if(s3){
        sickIsolateRate = 0.75;
      }
      if(s4){
        sickIsolateRate = 1;
      }
      if (randomNum < sickIsolateRate){
        sickIsolate = true;
     vel = new PVector(0, 0);
      }
    } 
    
    
    
    if (infected) {
      susceptible = false;
      fill(255, 255, 0); 
      rad = 5 ;

    } 

    if (recovered) {
      susceptible = false;
      fill(0, 255, 0); 
      rad = 4;

    }
    
    if (dead) {
      susceptible = false;
      noFill();
      vel = new PVector(0,0);
      rad = 0;
      //drawHalo();
    }
    

    noStroke();

    ellipse( loc.x, loc.y, rad, rad);

    //add Halos

    if ( sick ) {
      noFill();
      stroke(238, 90, 30);
      ellipse(loc.x, loc.y, 16, 16);
      //drawHalo();

    }

    if (infected) {

      noFill();
      
      strokeWeight(1);
      
      stroke(255, 255, 0, 100);

      ellipse(loc.x, loc.y, 14, 14);

    }
    
    //if (recovered) {

    //  noFill();
      
    //  strokeWeight(1);

    //  stroke(0, 255, 0,100);

    //  ellipse(loc.x, loc.y, 8, 8);

    //}
    
  }
  

  void drawHalo()
      {
        
        

          if( haloGrowth <= 500 )
          {
              float radius = haloGrowth;
              float alpha  = map(haloGrowth, 0, 200, 180, 10 );
              
              fill(255, 0, 0,alpha);
              stroke(255, 0, 0,alpha);
              if(dead){
              stroke(138, 43, 226,alpha);
              fill(138, 43, 226,alpha);
              }

              strokeWeight(1);
              ellipse( loc.x, loc.y, radius, radius ); 
              
              haloGrowth += 4;
              if (haloGrowth == 400){
                  haloGrowth = 0; 
                }
            }
        }

  void getInfected()

  {

    if(recovered == false){

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

    if (loc.x < 25 || loc.x >= width-405) {

      vel.x *= -1;

    }

    if (loc.y < 30 || loc.y >= height-24) {
      

      vel.y *= -1;

    }

  }


}//////////////////////////////////// End of Class

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
    fill(0,100);
    rect(xpos, ypos, swidth, sheight);
    fill(255,50);
    rect(xpos,ypos,spos-xStat,sheight);
    fill(200);

    rect(spos, ypos-10, 8, sheight+20);   
  }
  
 

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
