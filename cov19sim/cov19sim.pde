int initialPopulationSize = 100;

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

int spreadDistance = 6;

float infectionProbability = 0.5;

int xStat = 1220;

int yTitle = 40;

int yDay = 140;

int yPop = 170;

int yHealthy = 230;

int ySick = 290;

int yInfected = 350;

int ySurvivors = 410;

int yDead = 470;

int yHealth = 600;

int yStaff = 630;

int numDead = 0;

void setup()

{
    size(1600, 800);

    frameRate(24);

    //population = new ArrayList<Agent>();

    //healthZone  = loadImage( "DATA/zones4.png" ); 

    myFont = createFont("Arial Black", 32);
    altFont = createFont("Arial", 32);

    initailizePop();
}

void draw()

{
    clear();
    background(0);

    for (Agent a: population) {
        a.update();
    }

///////////////////////////////////////////////////////////////////////////YEARLY CENSUS

    if (frameCount % framesPerDay == 0)

    {
        currentPopulationSize = population.size();
        removeDead();
        //popFlux();  
        println( "DAY: " + dayCounter + "  POP: " + currentPopulationSize );
        dayCounter += 1;

    }

    infect();
    //surviveState();
    statsBar();
    println(numDead);
}

////////////////////////////////////////////////////////////////////////////// STATS BAR  

void statsBar() {

    float popSize = population.size();

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

        if (person.survive == true) {

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
        if (person.dead == false && person.healed == false && person.infected == false && person.sick == false) {
            numHealthy += 1;
        }
    }
    
    float percentSick = numSick / popSize * 100;
    float percentInfected = numInfected / popSize * 100;
    float percentHealed = numHealed / popSize * 100;
    float percentDead = numDead / popSize * 100;
    float percentHealthy = numHealthy / popSize * 100;
    
    fill(255);
    textAlign(LEFT);
    textFont(myFont);
    textSize(24);
    text("COVID-19 SIMULATOR", xStat, yTitle, 360, 100);
    textFont(altFont);
    textSize(15);


    text("DAY: " + dayCounter, xStat, yDay);

    text("POPULATION: " + popSize + " / " + initialPopulationSize, xStat, yPop);

    text("NUMBER HEALTHY: " + numHealthy + " | " + nf(percentHealthy, 0, 2) + "%", xStat, yHealthy);

    text("NUMBER SICK: " + numSick + " | " + nf(percentSick, 0, 2) + "%", xStat, ySick);

    text("NUMBER INFECTED: " + numInfected + " (" + nf(percentInfected, 0, 2) + "%)", xStat, yInfected);

    text("SURVIVORS: " + numHealed + " | " + nf(percentHealed, 0, 2) + "%", xStat, ySurvivors);

    text("DEATHS: " + numDead + " | " + nf(percentDead, 0, 2) + "%", xStat, yDead);

    text("HEALTH ZONES: 5", xStat, yHealth);

    text("HEALTH STAFF: 20", xStat, yStaff);

    //fill(255,255,255,100);
    //rect(width/2-355,height-40,325,20);

    //fill(0,0,0);
    textAlign(CENTER);

    textFont(altFont);
    textSize(20);

    //String[] fontList = PFont.list();
    //println(fontList);

    //if(frameCount < 200){
    text(" CLICK TO ADD EXPOSED AGENT  | |  SPACE BAR TO RESET", width / 2 - 200, height - 20);
    //}
    fill(255, 255, 255);


    float xScale = 100;



    float xHealthy = map(percentHealthy, 0, xScale, 0, 360);

    float xSick = map(percentSick, 0, xScale, 0, 360);

    float xInfected = map(percentInfected, 0, xScale, 0, 360);

    float xSurvivors = map(percentHealed, 0, xScale, 0, 360);

    float xDead = map(percentDead, 0, xScale, 0, 360);



    //float xxHealthy = map(percentHealthy,0,xScale,0,1200);

    //float xxSick = map(percentSick,0,xScale,0,1200);

    //float xxInfected = map(percentInfected,0,xScale,0,1200);

    //float xxSurvivors = map(percentHealed,0,xScale,0,1200);

    //float xxDead = map(percentDead,0,xScale,0,1200);



    noStroke();

    fill(255, 50);

    rect(xStat, yHealthy + 10, 360, 25);

    rect(xStat, ySick + 10, 360, 25);

    rect(xStat, yInfected + 10, 360, 25);

    rect(xStat, ySurvivors + 10, 360, 25);

    rect(xStat, yDead + 10, 360, 25);



    fill(255);

    rect(xStat, yHealthy + 10, xHealthy, 25);

    fill(255, 0, 0, 150);

    rect(xStat, ySick + 10, xSick, 25);

    fill(255, 255, 0, 150);

    rect(xStat, yInfected + 10, xInfected, 25);

    fill(0, 255, 0, 150);

    rect(xStat, ySurvivors + 10, xSurvivors, 25);

    fill(255);

    rect(xStat, yDead + 10, xDead, 25);



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

}

/////////////////////////////////////////////////////////////////////////// Infect

void infect()

{

    for (int i = 0; i < population.size(); i += 1) {

        Agent person1 = population.get(i);

        for (int j = i + 1; j < population.size(); j += 1)

        {

            Agent person2 = population.get(j);

            float distance = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

            // first condition

            if (distance <= spreadDistance && person1.sick && !person2.sick)

            {

                ////////////////////// delay getting sick for X nbr of days? ////////////////////////

                //person 1 makes person 2 sick

                if (prob(infectionProbability) == true) {

                    person2.getInfected();

                }

            } else if (distance <= spreadDistance && person2.sick && !person1.sick)

            {

                //person2 makes person1 sick

                if (prob(infectionProbability) == true) {

                    person1.getInfected();

                }

            }


            //infectionLine(person1, person2);
            //if(person1.healed || person2.healed){
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

        PVector L = new PVector(random(0, width - 400), random(0, height));

        population.add(new Agent(L));

    }

}

//focus here next 4_11
void surviveState() {

    for (int i = 0; i < population.size(); i += 1) {

        Agent person1 = population.get(i);

        if (person1.healed) {
            removeSurvivor();

            survivors = new ArrayList < Agent > ();
            PVector G = new PVector(5, 5);

            survivors.add(new Agent(G));
            println(survivors.size());
        }

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

            PVector L = new PVector(random(0, width - 400), random(0, height));

            population.add(new Agent(L));

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
