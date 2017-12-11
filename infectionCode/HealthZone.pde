class HealthZone {
  PVector loc;
  boolean isTemporary;
  float r;
  float catchmentRadius;
  float magSickRate = 1.4;
  
  HealthZone(float x, float y, boolean t) { 
    loc = new PVector(x, y);
    isTemporary = t;
  }
  
  void drawCenter(){
   
   if(isTemporary){
    drawHealthZone2(); 
   }
   else{
    drawHealthZone(); 
   }
   
   healthZonePer();
   
  }
  
  void drawHealthZone (){
    
     r = map(healProbability, 0, 0.8, 1, 75);
     catchmentRadius = 200;

    noStroke();
    fill(0,255,0, 120);
    ellipse( loc.x, loc.y, r, r);
    fill(255);
    ellipse( loc.x, loc.y, 4, 4);
    fill(255, 50);
    ellipse(loc.x, loc.y, catchmentRadius, catchmentRadius);
    
  }   
  
    void drawHealthZone2 (){
    
     r = map(healProbability2, 0, 0.8, 1, 45);
     catchmentRadius = 100;
    
    noStroke();
    fill(0,255,255, 120);
    ellipse( loc.x, loc.y, r, r);
    fill(255);
    ellipse( loc.x, loc.y, 6, 6);
    fill(255, 50);
    ellipse(loc.x, loc.y, catchmentRadius, catchmentRadius);
    
  }  
  
  void healthZonePer(){
  
  float xValue = hs1.getPos();
  float xValue2 = hs2.getPos();
  float aidFactor = map(xValue,55,230,0, 2); 
  float aidFactor2 = map(xValue2,55,230,0, 2);
  
  for ( HealthZone P : healthZones) {
    int catchmentPop = 0;
    int sickPop = 0;
    for (Agent a : population) {
      float d = P.loc.dist(a.loc);
      if (d < catchmentRadius/2 ) {
        catchmentPop += 1;
        if (a.sick) sickPop += 1;
      }
    }

    float   perSick  = (float) sickPop * magSickRate / catchmentPop * 100;
    float   healProb = map(perSick, 0, 100, 0, 1);
    healProbability  = ((1 - healProb) * aidFactor)/2 ;
    healProbability2  = ((1 - healProb) * aidFactor2)/2 ;
    int healPercent  = round(healProbability * 100);
    int healPercent2  = round(healProbability2 * 100);
    
    fill(255);
    textSize(13);
    textAlign(CENTER);
    if (P.isTemporary == false){
    text(healPercent + " %", P.loc.x+5, P.loc.y - 25 );
    }
    if (P.isTemporary == true){
    text(healPercent2 + " %", P.loc.x+5, P.loc.y - 25 );
    }
    noStroke(); 
  }
  }
  
 }  