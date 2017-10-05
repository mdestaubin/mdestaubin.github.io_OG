var queryResult;



function setup() 
{
  //pixelDensity(3.0);
  createCanvas(375,667);
  background(255);
 
  query();
}

// Run the API call
function query() 
{

  // URL for querying
  var url= 'https://api.darksky.net/forecast/c62627d15e64486ca08975f6b55df8be/42.361936, -71.097309';

  // Query the URL, set a callback
  // 'jsonp' is needed for security
  loadJSON(url, gotData, 'jsonp');
}

// Request is completed
function gotData(data)
 {
  // console.log(data);
  queryResult = data;

  // only look at current results:
  var currentWeather = queryResult.currently;
  var hourlyWeather = queryResult.hourly;
  var dailyWeather = queryResult.daily;

  
  // a few variables for text formatting
  var xPos1 = (width/2)-110; 
  var xPos2 = width/2;
  var xPos3 = (width/2)+110;
  var yPos1 = 270;
  var yPos2 = 380;
  var yPos3 = 490;
  var yPos4 = 600;

  var yPos = 40;
  var yGap = 60; 
  var textSizeLarge = 20;
  var textSizeSmall = 16;
  var textSizeDegrees = 30;

  var iconRadiusBig = 120;
  var iconRadiusSmall = 50;

  var m = month();
  var d = day();
  var y = year();

  // List relevant items of information
  fill(50);
  textAlign(CENTER);

  // Date and Location
  textSize(textSizeSmall);
  text(m + "/" + d + "/" + y, xPos2, yPos);
  yPos+=textSizeSmall;
  text("Cambridge, MA", xPos2, yPos);
  //yPos+=yGap; 

 
  // Current Weather
   noStroke();
   fill(50,50,200,50);
   ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);

   fill(0);
   textSize(textSizeDegrees);
   textAlign(CENTER);
   text(Math.round(hourlyWeather.data[0].temperature), xPos2,150);

 
  // future weather ellipses
  fill(50);
  ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);

  ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);

  ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);

  ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
  ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);
  

  // settings and arrow

  strokeWeight(3);
  stroke(0);
  line(width-25,(height-20)+5,width-15,(height-20));
  line(width-25,(height-20)-5,width-15,(height-20));


  // border outline
  noFill();
  stroke(0);
  strokeWeight(2);
  rect(0,0,width,height);

    // image load

  //image(img, 0, 0);
  //img.resize(0, 20);

  // Rain Summary
  
  /*
  textSize(textSizeSmall);
  text("Temperature",20, yPos);
  yPos+=textSizeLarge;
  textSize(textSizeLarge);
  text(currentWeather.temperature + "º",20, yPos);
  yPos+=yGap;
  
  textSize(textSizeSmall);
  text("Precipitation",20, yPos);
  yPos+=textSizeLarge;
  textSize(textSizeLarge);
  text(currentWeather.precipIntensity + "%",20, yPos);
  yPos+=yGap;
  
  textSize(textSizeSmall);
  text("Humidity",20, yPos);
  yPos+=textSizeLarge;
  textSize(textSizeLarge);
  text(currentWeather.humidity + "%",20, yPos);
  yPos+=yGap;

  */

 



}