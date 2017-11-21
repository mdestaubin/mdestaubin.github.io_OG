public class NLCDswatch
{
      // a very simple class that holds the standard color
      // values for the National Land Cover Dataset (NLCD)
      // it is nothing more than an array of color variables
      // accessed by the Land Cover codes.
      
      int healthZone;
      int developed;
      int landscape;
      color[] NLCD;
  
      public NLCDswatch()
      {
           NLCD = new color[100];
           landscape = (int) color(113,175,87);
           developed = (int) color(196, 185, 111); 
           healthZone = (int) color(255,0,0);
   
           NLCD[11] = landscape; // open water
           NLCD[12] = landscape; // ice
           NLCD[21] = landscape; // developed, open land
           NLCD[22] = developed; // developed, low intensity
           NLCD[23] = developed; // developed, medium intensity
           NLCD[24] = developed; // developed, high intensity
           NLCD[31] = landscape; // barren land       
           NLCD[41] = landscape; // deciduous forest       
           NLCD[42] = landscape; // evergreen forest
           NLCD[43] = landscape; // mixed forest
           NLCD[51] = landscape; // dwarf scrub 
           NLCD[52] = landscape; // shrub
           NLCD[71] = landscape; // grassland
           NLCD[72] = landscape; // sedge
           NLCD[73] = landscape; // lichens
           NLCD[74] = landscape; // moss
           NLCD[81] = landscape; // pasture
           NLCD[82] = landscape; // cultivated crops
           NLCD[90] = landscape; // woody wetlands
           NLCD[95] = landscape; // emergent herbaceous wetlands   
      };

      color getColor( int NLCDcode )
      {  
            color defaultColor = color(0,0,0); // enter an invalid code number and
                                               // get K back.
            
            return (NLCDcode >= 11 && NLCDcode <= 95)? NLCD[ NLCDcode ] : defaultColor;
      }
  
      color[] getSwatch()
      {
          return NLCD;
      }
  
}