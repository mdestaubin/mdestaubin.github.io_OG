//  GSD 6349 Mapping II : Geosimulation
//  Havard University Graduate School of Design
//  Professor Robert Gerard Pietrusko
//  <rpietrusko@gsd.harvard.edu>
//  (c) Fall 2017 
//  Please cite author and course 
//  when using this library in any 
//  personal or professional project.

//  WEEK 10 : LAND USE LAND COVER (LULC) + AGENTS

ASCgrid   LU;
NLCDswatch nlcdColors;        // a simple swatch of standard land cover colors
Lattice LUlat;
PFont txt;
boolean mouseOverText = false;

int populationHomeNLCD = 23; // evergreen forest
int targetAdjacency = 24; // emergent herbaceous wetlands
float birthProb     = 0.15;

ArrayList<Agent> population;
//ArrayList<PVector> healthZones;

/////////////////////////////////////////////// Code Merge Variables
int initialPopulationSize = 1000;
int dayCounter             = 0;
int framesPerDay           = 24;
int currentPopulationSize  = 0;
int minDays                = 2;
int maxDays                = 21;
int spreadDistance         = 6;
float infectionProbability = 0.5;

///////////////////////////////////////////////////////////////////////
void setup()
{
    size(800,800);
    frameRate(30);
    
    txt = loadFont( "HelveticaNeue-14.vlw" );
    textFont(txt,12);

    nlcdColors = new NLCDswatch();
    LU = new ASCgrid( "rastert_landcov4.asc" );
    LU.fitToScreen();
    LU.updateImage( nlcdColors.getSwatch() );
    
    LUlat = new Lattice(LU.w,LU.h);
    fillLattice( LUlat, LU );
    
 // create a new instance of our Land Cover Code Color swatch
 // this is used to color the land cover ascii grid      
     nlcdColors = new NLCDswatch();  
     
     createPopulation();
  
    // fill the healthzones array
}


///////////////////////////////////////////////////////////////////////
void draw()
{
    background(0);
    image( LU.getImage(),0,0 );

    //image( LU.getImage(),-200,0 );
    //LU.getImage().resize(0,800);
    
    for( Agent a : population )
    {
        a.update(LUlat, targetAdjacency);
        a.drawAgent();
    }
    
    texter();

}


///////////////////////////////////////////////////////////////////////
void texter()
{
    if( mouseOverText )
    {
        int LUcode = (int) LUlat.get(mouseX, mouseY );
        fill(255,0,0,255);
        text(LUcode, mouseX+5, mouseY-5 );
    }
}

///////////////////////////////////////////////////////////////////////
void keyPressed()
{
    if( key == 't' ){
      mouseOverText = !mouseOverText;
    }
}


void mousePressed()
{
    targetAdjacency = (int)LUlat.get(mouseX,mouseY);
    for( Agent a : population )
    {
          a.foundTarget = false;
          a.vel = new PVector( random(-2,2), random( -2, 2 ) );
    }

}


///////////////////////////////////////////////////////////////////////
void fillLattice( Lattice latIn, ASCgrid LUin )
{
      for( int x = 0; x < LUin.w; x += 1 ){
        for( int y = 0; y < LUin.h; y += 1 ){
        
              float value = LUin.get(x,y);
              latIn.put(x,y, value  );
        }}
}

void createPopulation()
{
    population = new ArrayList<Agent>();

    for( int x = 0; x < LUlat.w; x += 1 ){
       for( int y = 0; y < LUlat.h; y += 1 ){
          
             int val =  (int) LUlat.get(x,y);
             if( val == populationHomeNLCD  && random(1.0) <= birthProb )
             {
                 Agent temp = new Agent(x,y);
                 temp.setHomeClass( populationHomeNLCD );
                 temp.findTarget( LUlat, targetAdjacency);
                 population.add( temp );            
             }
        
    }}
    
    println( "added " + population.size() + " new agents." );
}