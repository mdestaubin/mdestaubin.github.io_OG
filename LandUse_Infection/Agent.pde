class Agent{

      Kernel  k;
      PVector loc;
      PVector vel;
      PVector target;
      int     LUhome;
      float   mag;
      int     kernelSize = 700; 
      boolean foundTarget = false;
  
      Agent()
      {
          loc = new PVector( random(width), random(height) );
          vel = new PVector( random(-2,2) , random(-2,2)   );
          mag = 1;
          
          k = new Kernel();
          k.isNotTorus();
          k.setNeighborhoodDistance(kernelSize);
      }
      
      Agent( int x, int y)
      {
          loc = new PVector( x, y );
          vel = new PVector( random(-1,1) , random(-1,1)   );
          mag = 1;
          
          k = new Kernel();
          k.isNotTorus();
          k.setNeighborhoodDistance(kernelSize);
      }
      
      void setHomeClass( int LUclass )
      {
          LUhome = LUclass;
      }
      
      void findTarget( Lattice l, int targetLU, ArrayList<PVector> healthZones )
      {
         //k.setNeighborhoodDistance( kernelSize );
          //target = k.getNearest( l, loc, targetLU );
          //if( target != null ) foundTarget = true; 
         
          float minDistance = MAX_FLOAT;
         
          for (PVector z : healthZones) {
              float distance = loc.dist(z);
              if (distance < minDistance) {
                minDistance = distance;
                target = z;
            }
          }
    }

      void update(Lattice l, int targetLU, ArrayList<PVector> healthZones )
      {
          if( foundTarget == false ){
            findTarget(l,targetLU, healthZones );
          }
          if( foundTarget == true ) 
          {
              updateVelocity();
          }
         
          loc.add(vel);
      }
      
      void updateVelocity()
      {
           float    angle = calcRadians( target );
           int   distance = (int)dist( loc.x, loc.y, target.x, target.y);
           float      mag = distance * 0.05; // speed dependent on distance
                                             // slows down as it gets closer
                 
           // use trig to convert from polar (mag, angle) to cartesian (x,y) coordinates      
           // or decompose an angle into x,y velocity components
           float xVel =  mag*cos( angle );
           float yVel = -mag*sin( angle );
           
           vel = new PVector(xVel, yVel);              
      }
      
      void drawAgent()
      {
          fill(255);
          rectMode(CENTER);
          noStroke();
          pushMatrix();
            translate( loc.x, loc.y );
            rect(0,0,3,3);
            noFill();
            stroke(255, 50);
            rect(0,0,kernelSize,kernelSize);
            
          popMatrix();
      
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


}