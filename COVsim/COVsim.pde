int initialPopulationSize = 999;

ArrayList < Agent > population;
ArrayList < Agent > survivors;

int dayCounter = 0;

int framesPerDay = 24;

int currentPopulationSize = 0;

float popFluxRate = 0.001250;

PFont myFont;

PFont altFont;

PImage healthZone;

//////////////////////// infection variables

int minDays = 2;

int maxDays = 14;

int spreadDistance = 5;

float infectionProbability = 0.15;

int xStat = 1240;

int yTitle = 5;

int yDay = 35;

int yPop = 60;

int yHealthy = 100;

int ySick = 220;

int yInfected = 160;

int ySurvivors = 280;

int yDead = 340;

int yCFR = 490;

boolean isolate = false;

boolean isSetup = false;



int numDead = 0;

void setup()

{
    size(1620, 1000);
    //fullScreen();

    frameRate(24);

    population = new ArrayList<Agent>();
    myFont = createFont("Arial Black", 32);
    altFont = createFont("Arial", 32);

    initailizePop();
}

void draw()

{
    background(38,38,38);
    fill(38,38,38);
    stroke(255);
    strokeWeight(2);
    rect(20,20,width-420,height-200); 

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
    textSize(15);

    if(!isSetup){
     textAlign(CENTER);
     text("PRESS SPACE TO START", (width-420)/2, (height-180)/2);
     dayCounter = 0;
    }
    
    textAlign(LEFT);
    
    text("DAY: " + dayCounter, xStat, yDay);

    text("POPULATION: " + int(popSize), xStat, yPop);

    text("PREVELANCE: " + nf(percentAffected, 0, 2) + "%", xStat, yHealthy);

    text("ACTIVE INFECTED: " + int(numSick), xStat, ySick);

    text("ACTIVE EXPOSED: " + int(numInfected), xStat, yInfected);

    text("TOTAL RECOVERED: " + int(numHealed), xStat, ySurvivors);

    text("TOTAL DEATHS: " + int(numDead), xStat, yDead);
    
    text("FATALITY RATE: " + nf(percentCFR, 0, 2) + "%", xStat+200, yDead);


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



    //float xxHealthy = map(percentHealthy,0,xScale,0,1200);

    //float xxSick = map(percentSick,0,xScale,0,1200);

    //float xxInfected = map(percentInfected,0,xScale,0,1200);

    //float xxSurvivors = map(percentHealed,0,xScale,0,1200);

    //float xxDead = map(percentDead,0,xScale,0,1200);



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

        PVector L = new PVector(random(25, width - 407), random(25, height-186));        

        population.add(new Agent(L));

    }
    
    infectedAgent();

}

//void removeTest() {
  
//   Iterator iter = population.iterator();

//  Agent tempAgent;

//  while ( iter.hasNext() )

//  {    

//    tempAgent = (Agent)iter.next();

//    if ( tempAgent.dead == true )
  
  
//}


void infectionLine(Agent person1, Agent person2) {
  
  float spreadDist = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

   if ((person1.infected && person2.sick) || (person2.infected && person1.sick)) {
      
      if (spreadDist < 100){

        stroke(255, 40);

        strokeWeight(3);

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

    infectedPerson.loc.x = mouseX;

    infectedPerson.loc.y = mouseY;

    population.add(infectedPerson);

}



////////////////////////////////////////////////////////////////////////////////// Reset

void keyPressed()

{


    if (key == ' ') {

        population.clear();

        for (int i = 0; i < initialPopulationSize; i += 1)

        { 
          if(!isSetup){
            isSetup = true;
          }

            PVector L = new PVector(random(25, width - 406), random(25, height-186));

            population.add(new Agent(L));
            dayCounter = 0;
            numDead = 0;

        }
        
        isolate = false;
        infectedAgent();
        loop();
    }
    
    if (key == 'i') {
      
      isolate = true;
    }
    
    if (key == 'n') {
     
      isolate = false;
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

  float sickIsolateRate = 0.3;
  
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

      if (t >= random(72,336)) {    

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

    if ( sick ) {

      fill(238, 109, 3);
      susceptible = false;
      rad = 5;
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
      rad = 3;

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
      stroke(238, 109, 3, 200);
      ellipse(loc.x, loc.y, 16, 16);
      //drawHalo();

    }

    if (infected) {

      noFill();
      
      strokeWeight(1);
      
      stroke(255, 255, 0, 100);

      ellipse(loc.x, loc.y, 12, 12);

    }
    
    if (recovered) {

      noFill();
      
      strokeWeight(1);

      stroke(0, 255, 0,100);

      ellipse(loc.x, loc.y, 8, 8);

    }
    
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

    if (loc.y < 30 || loc.y >= height-180) {
      

      vel.y *= -1;

    }

  }


}//////////////////////////////////// End of Class
