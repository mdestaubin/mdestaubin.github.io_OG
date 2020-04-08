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

float infectionProbability = .18;

float travelProbability;

int xStat = 1240;

int yTitle = 42;

int yDay = 535;

int yPop = 560;

int yHealthy = 615;

int ySick = 585;

int yInfect = 560;

int ySurvivors = 320;

int yDead = 380;

int yCFR = 820;

boolean isolate = false;

boolean isSetup = false;

int numDead = 0;

ArrayList<Float> sickHistory;

float xCord1;

boolean s1 = true;
boolean s2 = false;
boolean s3 = false;
boolean s4 = false;
boolean s5 = false;

boolean su1 = true;
boolean su2 = false;
boolean su3 = false;
boolean su4 = false;
boolean su5 = false;

int yPercent  = 312; //23+button
int yPercent2 = 385;
int yPercent3 = 457;
int yButton1  = 290;
int yButton2  = 364;
int yButton3  = 436;
int yRvalue   = 235;

int contactDays = 0;

int yAssumption = 80;

int yStats = 500;

int[] y;

boolean pause = false;
boolean about = false;
boolean play = true;

PImage virs;
PImage hhi;

boolean adjust = false;
boolean adjust2 = false;


void setup()

{
    size(1620,840);
    //size(1320,840);
    //fullScreen();

    frameRate(60);
    
    sickHistory =     new ArrayList<Float>();
    population = new ArrayList<Agent>();
    myFont = createFont("Arial Black", 32);
    altFont = createFont("Arial", 32);
    initailizePop();
    virs = loadImage("DATA/virslogo.png");
    hhi = loadImage("DATA/hhilogo.png");
    //hs1 = new HScrollbar(xStat, yRvalue, 360, 6, 7);
    
    //y = new int[360];
}

void draw()

{
    background(38,38,38);
    fill(38,38,38);
    stroke(255);
    strokeWeight(2);
    rect(20,20,width-420,800,6); 
    stroke(150);
    line(xStat,yAssumption+10,xStat+360,yAssumption+10);
    line(xStat,yButton1-43,xStat+360,yButton1-43);
    line(xStat,yStats+10,xStat+360,yStats+10);

    for (Agent a: population){
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
   // scrollBar();
}

void scrollBar() {

  hs1.updateScroll();
  hs1.displayScroll();
  
  float xValue  = hs1.getPos();
  
  int    travel = round(map(xValue, xStat, xStat + 360, 0, 4));
  String travelPercent = nfc(travel);
  
  //infectionProbability =  map(xValue, xStat, xStat + 360, 0, 0.2);
//  infectionProbability =  0.12;
  
  textSize(16);
  textAlign(CENTER);
  fill(255);
  text("R", hs1.spos-3, hs1.ypos-18); 
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

      }
    } 

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
    
    float xScale = 100;

    float xHealthy = map(percentAffected, 0, xScale, 0, 360);

    float xSick = map(percentSick, 0, xScale, 0, 360);

    float xInfected = map(percentInfected, 0, xScale, 0, 360);

    float xSurvivors = map(percentHealed, 0, xScale, 0, 360);

    float xDead = map(percentDead, 0, xScale, 0, 360);
    
    fill(255);
    textAlign(LEFT);
    textFont(altFont);
    textSize(14);

    if(!isSetup){
    // fill(0,100);
     //rect(20,20,width-420,800,6); 
     noStroke();
     fill(255);
     textAlign(CENTER);
     //text("CLICK TO START SIMULATION", (width-420)/2, ((height-40)/2)-35);
     
     
     textAlign(CENTER);
     stroke(255);
     //strokeWeight(3);
     noFill();
     //ellipse(((width-420)/2)-20,((height-40)/2)-123,12,12);
    // ellipse(((width-420)/2)-85,((height-40)/2)-105,26,26);
     fill(255);
     virs.resize(0,150);
     hhi.resize(0,60);
     image(hhi,50,50);
     image(virs,((width-420)/2)-82,((height-40)/2)-220);
     
     //text("V",(width-420)/2,((height-40)/2)-75);
     textFont(altFont);
     textSize(18);
     if(!about){
     //virs.resize(0,120);
     //image(virs,((width-420)/2)-85,((height-40)/2)-220);
     text("START SIMULATION",(width-420)/2,((height-40)/2)-35);
     text("INSTRUCTIONS", (width-420)/2,((height-40)/2));
     text("ABOUT", (width-420)/2,((height-40)/2)+35);
     }
     if(about){
     // hhi.resize(0,60);
     // image(hhi,50,50);
      //image(virs,((width-420)/2)-70,((height-40)/2)-210);
    //   textFont(myFont);
    // textSize(50);
    //  text("ViRS",(width-420)/2,((height-40)/2)-80);
     textFont(altFont);
     textSize(15);
     text("The Visual Response Simulator | ViRS | is an agent-based modeling project designed to explore", (width-420)/2,((height-40)/2)-35);
     text("and visualize how disease dynamics and social behaviors interact over space and time.",(width-420)/2,((height-40)/2)-15);
     text("Originating as an individual thesis project at the Harvard Graduate School of Design,", (width-420)/2,((height-40)/2)+5);
     text("ViRS is now a collaborative, cross-disciplinary research effort at the Harvard Humanitarian Initiative.", (width-420)/2,((height-40)/2)+25);
     
     text("This particular simulation of ViRS is a spatially abstract COVID-19 transmission study model.", (width-420)/2,((height-40)/2)+65);
     text("It intends to demonstrate the level of impact non-clinical public health measures have on", (width-420)/2,((height-40)/2)+85);
     text("containing and stopping a COVID-19 outbreak within a population of agents.", (width-420)/2,((height-40)/2)+105);
     
     text("Note this is not a prediction model, its primary purpose is to act as an educational tool that", (width-420)/2,((height-40)/2)+145);
     text("gives the user the ability to control certain parameters and visualize their effects on an outbreak.", (width-420)/2,((height-40)/2)+165);
     text("This model is part of an ongoing project and will be updated with improvements periodically.", (width-420)/2,((height-40)/2)+185);
     
     text("For any questions or comments, please email", (width-420)/2,((height-40)/2)+225);
     text("Michael de St. Aubin, mdestaubin@hsph.harvard.edu", (width-420)/2,((height-40)/2)+245);
    
     textSize(18);
     text("BACK", (width-420)/2,((height-40)/2)+335);
     }

     dayCounter = 0;
    }
    
    //if(!looping){
    // textAlign(CENTER);
    // text("Restart", (width-420)/2, (height-40)/2);
     //dayCounter = 0;
   // }
    textSize(14);
    textAlign(CENTER);
    text(nf(percentAffected, 0, 2) + "%", xStat+xInfected+xSurvivors+xDead+xSick+10, yHealthy);
    
    textAlign(RIGHT);
    //textSize(17);
    text(int(popSize) +"  AGENTS", xStat+360, yAssumption);
    text(dayCounter+ " DAYS" , xStat+360, yStats); 
    
    //textSize(14);
    text("FATALITY RATE: " + nf(percentCFR, 0, 2) + "%", xStat+360, ySick);
    
    text("RECOVERED: " + int(numHealed), xStat+360, yDay);

    text("DEATHS: " + int(numDead), xStat+360, yInfect);

    textAlign(LEFT);
    
    text("INCUBATION PERIOD: 4-6 DAYS" , xStat, yAssumption+35);
    
    text("INFECTION PERIOD: 3-7 DAYS" , xStat, yAssumption+60);
    
    text("SUSCEPTIBILITY: "+ (100-map(numHealed,0, 1000, 0, 100)) + "%" , xStat, yAssumption+85);

    text("SYMPTOMATIC: " + int(numSick), xStat, yInfect);
    
    text("EPI CURVE ", xStat, yCFR-130);

    text("EXPOSED: " + int(numInfected), xStat, yDay);
    
    text("R 0: 2", xStat, yRvalue-45);

    text("INFECTED IN ISOLATION", xStat, yButton1-15);
    
    text("SOCIAL DISTANCING", xStat, yButton2-15);
    
    fill(120);
    
    text("CONTACTS TRACED | NA", xStat, yButton3-15);
    
    text("ASYMPTOMATIC: NA", xStat, ySick);
   
    textSize(17);
    fill(255);
    
    text("ASSUMPTIONS", xStat, yAssumption);

    text("INTERVENTIONS", xStat, yButton1-55);
    
    text("RESULTS", xStat, yStats);

    fill(255);

   // textFont(myFont);
    textSize(23);
    text("COVID-19 SIMULATOR", xStat, yTitle+2);

    textAlign(CENTER);

    textFont(altFont);
    textSize(20);

    fill(255, 255, 255);

    
    //float xCFR = map(percentCFR, 0, xScale, 0, 360);

       textAlign(CENTER);
       textSize(16);
       noFill();
       stroke(255);
       strokeWeight(1);
       if(s1){
         fill(180);
       }
       rect(xStat,yButton1,65,30, 7);
       fill(0);
       if(!s1){
       fill(200);
       }
       
       text("0%", xStat+34,yPercent);
       
       noFill();
       if(s2){
         fill(180);
       }
       rect(xStat+74,yButton1,65,30, 7);
       fill(0);
       if(!s2){
       fill(200);
       }
       
       text("25%", xStat+109,yPercent);
       
       noFill();
       if(s3){
         fill(180);
       }
       rect(xStat+149,yButton1,65,30, 7);
       fill(0);
       if(!s3){
       fill(200);
       }
       
       text("50%", xStat+184,yPercent);
       
       noFill();
       if(s4){
         fill(180);
       }
       rect(xStat+223,yButton1,65,30, 7);
       fill(0);
       if(!s4){
       fill(200);
       }
       
       text("75%", xStat+259,yPercent);
       noFill();
       
       noFill();
       if(s5){
         fill(180);
       }
       rect(xStat+297,yButton1,65,30, 7);
       fill(0);
       if(!s5){
       fill(200);
       }
       
       text("100%", xStat+329,yPercent);
       noFill();
      
       if(su1){
         fill(180);
       }
       rect(xStat,yButton2,65,30, 7);
       fill(0);
       if(!su1){
       fill(200);
       }
       
       text("0%", xStat+34,yPercent2);
       
       noFill();
       if(su2){
         fill(180);
       }
       rect(xStat+74,yButton2,65,30, 7);
       fill(0);
       if(!su2){
       fill(200);
       }
       
       text("25%", xStat+109,yPercent2);
       
       noFill();
       if(su3){
         fill(180);
       }
       rect(xStat+149,yButton2,65,30, 7);
       fill(0);
       if(!su3){
       fill(200);
       }
       
       text("50%", xStat+184,yPercent2);
       
       noFill();
       if(su4){
         fill(180);
       }
       rect(xStat+223,yButton2,65,30, 7);
       fill(0);
       if(!su4){
       fill(200);
       }
       
       text("75%", xStat+259,yPercent2);
       noFill();
       
       noFill();
       if(su5){
         fill(180);
       }
       rect(xStat+297,yButton2,65,30, 7);
       fill(0);
       if(!su5){
       fill(200);
       }
       
       text("100%", xStat+329,yPercent2);
       

       noFill();
       stroke(100);
       rect(xStat,yButton3,65,30, 7);
       fill(100);
       text("0%", xStat+30,yPercent3);
       
       noFill();
       rect(xStat+74,yButton3,65,30, 7);
       fill(100);
       text("25%", xStat+109,yPercent3);
       
       noFill();
       rect(xStat+149,yButton3,65,30, 7);
       fill(100);
       text("50%", xStat+184,yPercent3);

       noFill();
       rect(xStat+223,yButton3,65,30, 7);
       fill(100);
       text("75%", xStat+259,yPercent3);

       noFill();
       rect(xStat+297,yButton3,65,30, 7);
       fill(100);
       text("100%", xStat+329,yPercent3);


     if(isSetup){
     stroke(225);
     noFill();
     rect(xStat+335,25,5,20);
     rect(xStat+345,25,5,20);
     }
     
    if(mouseX > xStat && mouseX < xStat+125 && mouseY > yAssumption+35-20 && mouseY < yAssumption+35){
    noStroke();
    fill(255,150);
    rect(xStat-40,yAssumption+19,-350,56,7);
    fill(0);
    textAlign(LEFT);
    text("The incubation period is the time elapsed",xStat-380,yAssumption+43);
    text("between exposure to infection and symptoms.",xStat-380,yAssumption+63);
    }
    
    if(mouseX > xStat && mouseX < xStat+125 && mouseY > yStats-20 && mouseY < yStats){
    noStroke();
    fill(255,100);
    rect(xStat-40,yStats-16,-350,350,7);
    }
    
    if(mouseX > xStat && mouseX < xStat+125 && mouseY > yButton1-55-20 && mouseY < yButton1-55){
    noStroke();
    fill(255,100);
    rect(xStat-40,yButton1-55-16,-350,350,7);
    }

    //triangle(xStat+298, 25, xStat+316, 35, xStat+298, 45);

    noStroke();

    fill(25);

    rect(xStat, yHealthy + 10, 360, 35,7);
    
    rect(xStat, yCFR, 360, -120);

    fill(238, 109, 3, 150);

    rect(xStat+xInfected+xSurvivors+xDead, yHealthy + 10, xSick, 35);

    fill(255, 255, 0, 150);

    rect(xStat+xSurvivors+xDead, yHealthy + 10, xInfected, 35);

    fill(88, 150, 255,150); 

    rect(xStat+xDead, yHealthy + 10, xSurvivors, 35);;

    fill(138, 43, 226, 100);

    rect(xStat, yHealthy + 10, xDead, 35);
    
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


    //epiCurve();
   
    sickHistory.add(yCFR-(numSick));
    strokeWeight(2);
     xCord1 = xStat;
    
    if (isSetup){
    for (int i = 0; i < frameCount; i++) 
    {
    
    if (i < sickHistory.size() && sickHistory.get(i) != null){
    float yInfected = sickHistory.get(i);
    
    if (numSick >= 120) { 
        adjust = true; 
    } 
    if(adjust){
    yInfected   = (yInfected+yCFR)/2;
    }
    //else if (numSick > 40) {
    //  // adjust = false; 
    //  adjust2 = true;
    //  ySick   = (ySick*2 +yCFR)/2;

    //}
    
    strokeWeight(1);

    stroke(100,10);
    line(xCord1,yCFR,xCord1,yCFR-120);
    noFill();
    stroke(238, 109, 3, 30);
    line(xCord1, yInfected, xCord1, yCFR);
    
    //stroke(100,10);
    //line(xCord1,yDead,xCord1,yDead+200);
    //noFill();
    //stroke(180,180);
    //line(xCord1, yTotal, xCord1, yDead);

   xCord1 = xCord1 + .06;

     }
    }
  }

  
    stroke(200);

    strokeWeight(2);
    
    line(xStat+xInfected+xSurvivors+xDead+xSick, yHealthy+8,xStat+xInfected+xSurvivors+xDead+xSick,yHealthy+45);

    
   if ((numSick == 0 && numInfected == 0 && dayCounter > 9) || dayCounter > 99) {
     fill(0,100);
     noStroke();
     rect(20,20,width-420,800,6); 
     fill(250);
        textSize(17);
     text("SIMULATION OVER",(width-420)/2,((height-40)/2)-35);
     text("PRESS SPACE BAR TO RETURN TO MAIN MENU", (width-420)/2,((height-40)/2));
    // text("MENU", (width-420)/2,((height-40)/2)+35);

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
            
            if ((person1.sick || person2.sick)){
            float distance = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

            // first condition

            if (distance <= spreadDistance && person1.sick && !person2.sick && !person2.recovered)

            {

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

        PVector L = new PVector(random(25, width - 407), random(27, height-26));        

        population.add(new Agent(L));

    }
    
    //infectedAgent();

}
    
void infectionLine(Agent person1, Agent person2) {
  
  float spreadDist = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

   if ((person2.sick) || (person1.sick)) {

      if (spreadDist < 25){

        stroke(255,70);

        strokeWeight(3);
        
        if((person1.vel.x == 0 || person2.vel.x == 0)){
        noStroke();
     }

        line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
      }
     }

}



////////////////////////////////////////////////////////// cool effect
//void infectionLine(Agent person1, Agent person2) {
  
//  float spreadDist = dist(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);

//   if ((person2.sick || person1.sick) && !person1.sickIsolate || !person2.sickIsolate) {
     
//     if(contactDays <= 1){
      
//      if (spreadDist < 30){

//        stroke(255,60);

//        strokeWeight(3);

//        line(person1.loc.x, person1.loc.y, person2.loc.x, person2.loc.y);
//      }
//     }
//    }

//}

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
    if(mouseX<width-420 && mouseY<height-30){
    if(mouseX >= ((width-420)/2)-90 && mouseX <= ((width-420)/2)+90 && mouseY >= ((height-40)/2)-50 && mouseY <= ((height-40)/2)-35){
    if(!isSetup){
            isSetup = true;
            population.clear();

        for (int i = 0; i < initialPopulationSize; i += 1)

        { 
            PVector R = new PVector(random(28, width - 408), random(28, height-28));
            population.add(new Agent(R));
            dayCounter = 0;
            numDead = 0;
            xCord1 = 0;
        }
        
        sickHistory.clear();
      }
    }

    infectedPerson.loc.x = mouseX;

    infectedPerson.loc.y = mouseY;

    population.add(infectedPerson);

    loop();
    }
 

    //text("INSTRUCTIONS", (width-420)/2,((height-40)/2)-05);
    if(!isSetup){
    if (mouseX > 50 && mouseX < 200 && mouseY > 50 && mouseY < 120) { 
    link("https://hhi.harvard.edu/");
  }
 }
        
    if(mouseX >= ((width-420)/2)-30 && mouseX <= ((width-420)/2)+30 && mouseY >= ((height-40)/2)+20 && mouseY <= ((height-40)/2)+35){
      if(!about){
       about = true; 
      }
    }
    
    if(mouseX >= ((width-420)/2)-30 && mouseX <= ((width-420)/2)+30 && mouseY >= ((height-40)/2)+325 && mouseY <= ((height-40)/2)+335){
      if(about){
       about = false; 
    }
    }
    
    if(mouseX >= xStat+335 && mouseX <= (xStat+355) && mouseY >= 25 && mouseY <= (45)){
       pause = !pause;
      
      if(pause){
      noLoop();
      }
      else {
        loop();
      }
     
      //looping = !looping;
    }

   if(mouseX >= xStat && mouseX <= (xStat+65) && mouseY >= yButton1 && mouseY <= (yButton1+35)){
      s1 = true;
      s2 = false;
      s3 = false;
      s4 = false;
      s5 = false;
    }
    
    if(mouseX >= xStat+74 && mouseX <= (xStat+139) && mouseY >= yButton1 && mouseY <= (yButton1+35)){
      s1 = false;
      s2 = true;
      s3 = false;
      s4 = false;
      s5 = false;
    }
    
    if(mouseX >= xStat+149 && mouseX <= (xStat+214) && mouseY >= yButton1 && mouseY <= (yButton1+35)){
      s1 = false;
      s2 = false;
      s3 = true;
      s4 = false;
      s5 = false;
    }
    
    if(mouseX >= xStat+223 && mouseX <= (xStat+288) && mouseY >= yButton1 && mouseY <= (yButton1+35)){
      s1 = false;
      s2 = false;
      s3 = false;
      s4 = true;
      s5 = false;
    }
    
    if(mouseX >= xStat+297 && mouseX <= (xStat+362) && mouseY >= yButton1 && mouseY <= (yButton1+35)){
      s1 = false;
      s2 = false;
      s3 = false;
      s4 = false;
      s5 = true;
    }

    
    if(mouseX >= xStat && mouseX <= (xStat+65) && mouseY >= yButton2 && mouseY <= (yButton2+35)){
      su1 = true;
      su2 = false;
      su3 = false;
      su4 = false;
      su5 = false;
    }
    
    if(mouseX >= xStat+74 && mouseX <= (xStat+139) && mouseY >= yButton2 && mouseY <= (yButton2+35)){
      su1 = false;
      su2 = true;
      su3 = false;
      su4 = false;
      su5 = false;
    }
    
    if(mouseX >= xStat+149 && mouseX <= (xStat+214) && mouseY >= yButton2 && mouseY <= (yButton2+35)){
      su1 = false;
      su2 = false;
      su3 = true;
      su4 = false;
      su5 = false;
    }
    if(mouseX >= xStat+223 && mouseX <= (xStat+288) && mouseY >= yButton2 && mouseY <= (yButton2+35)){
      su1 = false;
      su2 = false;
      su3 = false;
      su4 = true;
      su5 = false;
    }
    if(mouseX >= xStat+297 && mouseX <= (xStat+362) && mouseY >= yButton2 && mouseY <= (yButton2+35)){
      su1 = false;
      su2 = false;
      su3 = false;
      su4 = false;
      su5 = true;
    }

}

////////////////////////////////////////////////////////////////////////////////// Reset

void keyPressed()

{


    if (key == ' ') {
      
      isSetup = false;
      population.clear();
      
      for (int i = 0; i < initialPopulationSize; i += 1)

        { 
            PVector L = new PVector(random(27, width - 406), random(25, height-26));
            population.add(new Agent(L));
            dayCounter = 0;
            numDead = 0;
            xCord1 = 0;
        }
        
        sickHistory.clear();
        
        if(!looping){
          loop();
        }
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
  
  float deathRate = 0.035;

  PVector target;

  int rad;

  int perHealthy = 100;

  int days = 0;

  float t = frameCount;
  
  float randomNum = random(0, 1);

  float sickIsolateRate;
  
  float travelIsolate;
  
  boolean sickIsolate = false;
  
  boolean socialDistance = false;
  
  boolean susceptible = true;
  

  Agent(PVector L)

  {

    loc = L;

    vel = new PVector(random(-1,1), random(-1, 1));

    noVel = new PVector(0, 0);
    
    topspeed = 2;

    accel = new PVector(0, 0);

    target = new PVector(random(width), random(height));

    if (random(0, 100) < perHealthy) { 

      sick = false;
      susceptible = true;

    }
    
    else{
     susceptible = false;
     recovered = true;
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
    
    if(socialDistance){
    
    loc.add(noVel);
    
    }
    
    if(!socialDistance) {
    loc.add(vel);
    }

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
      if(su5){
        travelIsolate = 1.0;
      }
    if (susceptible || infected || sick){
      if (randomNum < travelIsolate){
         socialDistance = true;
        // bounce2();
      }
      else { socialDistance = false; }
    }
      

    if ( sick ) {

      fill(238, 90, 30);
      susceptible = false;
      rad = 5;
      if(s1){
        sickIsolateRate = 0.0;
      }
      if(s2){
        sickIsolateRate = 0.25;
      }
      if(s3){
        sickIsolateRate = 0.5;
      }
      if(s4){
        sickIsolateRate = 0.75;
      }
      if(s5){
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
      fill(88, 150, 255); 
      rad = 6;

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
    
    strokeWeight(1);
    noFill();
      

    if ( sick ) {
      noFill();
      stroke(238, 90, 30);
      ellipse(loc.x, loc.y, 15, 15);
      //drawHalo();

    }

    if (infected) {

      stroke(255, 255, 0, 100);

      ellipse(loc.x, loc.y, 13, 13);

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
    
   // contactDays =+1;

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


    if (loc.x < 28 || loc.x >= width-407) {
      vel.x *= -1;
    }
    if (loc.y < 30 || loc.y >= height-26) {
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
