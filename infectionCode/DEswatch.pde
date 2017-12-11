public class DEswatch
{
      
      color[] DE;
  
      public DEswatch()
      {
           DE = new color [100];
   
           DE[0] = (int) color(175, 229, 94); // degree 0.01- 3.31
           DE[1] = (int) color(48, 193, 81); // degree 3.31- 6.41


      };

      color getColor( int DEcode )
      {  
            color defaultColor = color(0,0,0); // enter an invalid code number and
                                               // get K back.
            
            return (DEcode <= 255 && DEcode > 0)? DE[ DEcode ] : defaultColor;
      }
  
      color[] getSwatch()
      {
          return DE;
      }
}