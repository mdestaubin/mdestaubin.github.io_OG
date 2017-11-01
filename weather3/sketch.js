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
  var textSizeLarge = 16;
  var textSizeSmall = 20;
  var textSizeDegrees = 38;

  var iconRadiusBig = 120;
  var iconRadiusSmall = 50;

  var m = month();
  var d = day();
  var y = year();
  var h = hour();

   var sun = color(255,255,0);
   var night = 80;
   var cloud = 200;
   var rain = color(36,91,142);

  var temp1 = Math.floor(hourlyWeather.data[1].temperature);
  var temp2 = Math.floor(hourlyWeather.data[2].temperature);
  var temp3 = Math.floor(hourlyWeather.data[3].temperature);
  var temp4 = Math.floor(hourlyWeather.data[4].temperature);
  var temp5 = Math.floor(hourlyWeather.data[5].temperature);
  var temp6 = Math.floor(hourlyWeather.data[6].temperature);
  var temp7 = Math.floor(hourlyWeather.data[7].temperature);
  var temp8 = Math.floor(hourlyWeather.data[8].temperature);
  var temp9 = Math.floor(hourlyWeather.data[9].temperature);
  var temp10 = Math.floor(hourlyWeather.data[10].temperature);
  var temp11 = Math.floor(hourlyWeather.data[11].temperature);
  var temp12 = Math.floor(hourlyWeather.data[12].temperature);

  // List relevant items of information
  fill(50);
  textAlign(CENTER);

  // Date and Location
  textSize(textSizeLarge);
  text(m + "/" + d + "/" + y, xPos2, yPos);
  yPos+=textSizeSmall;
  text("Cambridge, MA", xPos2, yPos);

/////////////////////////////////////////////////////////////////////////////// Current time
  fill(night);

      if(currentWeather.icon == "clear-day")
    {
         noStroke();
         fill(sun);
         ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);
    }  

      else if(currentWeather.icon == "partly-cloudy-day")
    {
         noStroke();
         fill(sun);
         ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);
      
         fill(cloud);
         arc(xPos2, 140, iconRadiusBig, iconRadiusBig, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
    }

     else if(currentWeather.icon == "partly-cloudy-night")
    {
 
  noStroke();
  fill(night);
  ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);
  fill(cloud);
  arc(xPos2, 140, iconRadiusBig, iconRadiusBig, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(currentWeather.icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);

if(currentWeather.precipProbability < .25){
  fill(rain);
  arc(xPos2, 140, iconRadiusBig, iconRadiusBig, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(currentWeather.precipProbability > .25 && currentWeather.precipProbability < .75)
{
  fill(rain);
  arc(xPos2, 140, iconRadiusBig, iconRadiusBig, 0, PI, CHORD);
}

if(currentWeather.precipProbability > .75){
 fill(rain);
 ellipse(xPos2,140,iconRadiusBig,iconRadiusBig);
}
}



   fill(25);
   textStyle(BOLD);
   textSize(textSizeDegrees);
   textAlign(CENTER);
   text(Math.round(hourlyWeather.data[0].temperature), xPos2,154);

 
  // future weather ellipses
  fill(night);

///////////////////////////////////////////////////////////////////////////////////// hour 1
   if(hourlyWeather.data[1].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[1].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[1].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[1].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);

     if(hourlyWeather.data[1].precipProbability < .25){
  fill(rain);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[1].precipProbability > .25 && hourlyWeather.data[1].precipProbability < .75){
  fill(rain);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[1].precipProbability > .75){
fill(rain);
ellipse(xPos1,yPos1,iconRadiusSmall,iconRadiusSmall);
}

}

///////////////////////////////////////////////////////////////////////////////////// hour 2

   if(hourlyWeather.data[2].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[2].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[2].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[2].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);

  if(hourlyWeather.data[2].precipProbability < .25){
  fill(rain);
  arc(xPos2, yPos1, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[2].precipProbability > .25 && hourlyWeather.data[2].precipProbability < .75){
  fill(rain);
  arc(xPos2, yPos1, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[2].precipProbability > .75){
fill(rain);
ellipse(xPos2,yPos1,iconRadiusSmall,iconRadiusSmall);
}

}

///////////////////////////////////////////////////////////////////////////////////// hour 3

   if(hourlyWeather.data[3].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[3].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[3].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos1, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[3].icon == "rain")
{
  noStroke();
  fill(cloud);
   ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);

   if(hourlyWeather.data[3].precipProbability < .25){
  fill(rain);
  arc(xPos3, yPos1, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[3].precipProbability > .25 && hourlyWeather.data[3].precipProbability < .75){
  fill(rain);
  arc(xPos3, yPos1, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[3].precipProbability > .75){
fill(rain);
ellipse(xPos3,yPos1,iconRadiusSmall,iconRadiusSmall);
}

}
 
///////////////////////////////////////////////////////////////////////////////////// hour 4

   if(hourlyWeather.data[4].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[4].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[4].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[4].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);

  if(hourlyWeather.data[4].precipProbability < .25){
  fill(rain);
  arc(xPos1, yPos2, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[4].precipProbability > .25 && hourlyWeather.data[4].precipProbability < .75){
  fill(rain);
  arc(xPos1, yPos2, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[4].precipProbability > .75){
fill(rain);
ellipse(xPos1,yPos2,iconRadiusSmall,iconRadiusSmall);
}

}

///////////////////////////////////////////////////////////////////////////////////// hour 5


   if(hourlyWeather.data[5].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[5].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[5].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[5].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);

  if(hourlyWeather.data[5].precipProbability < .25){
  fill(rain);
  arc(xPos2, yPos2, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[5].precipProbability > .25 && hourlyWeather.data[5].precipProbability < .75){
  fill(rain);
  arc(xPos2, yPos2, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[5].precipProbability > .75){
fill(rain);
ellipse(xPos2,yPos2,iconRadiusSmall,iconRadiusSmall);
}
}



///////////////////////////////////////////////////////////////////////////////////// hour 6

   if(hourlyWeather.data[6].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[6].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[6].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos2, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[6].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);

    if(hourlyWeather.data[6].precipProbability < .25){
  fill(rain);
  arc(xPos3, yPos2, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[6].precipProbability > .25 && hourlyWeather.data[6].precipProbability < .75){
  fill(rain);
  arc(xPos3, yPos2, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[6].precipProbability > .75){
fill(rain);
ellipse(xPos3,yPos2,iconRadiusSmall,iconRadiusSmall);
}

}


///////////////////////////////////////////////////////////////////////////////////// hour 7

   if(hourlyWeather.data[7].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[7].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[7].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[7].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);

  if(hourlyWeather.data[7].precipProbability < .25){
  fill(rain);
  arc(xPos1, yPos3, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[7].precipProbability > .25 && hourlyWeather.data[7].precipProbability < .75){
  fill(rain);
  arc(xPos1, yPos3, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[7].precipProbability > .75){
fill(rain);
ellipse(xPos1,yPos3,iconRadiusSmall,iconRadiusSmall);
}

}

///////////////////////////////////////////////////////////////////////////////////// hour 8

   if(hourlyWeather.data[8].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[8].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[8].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[8].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);

  if(hourlyWeather.data[8].precipProbability < .25){
  fill(rain);
  arc(xPos2, yPos3, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[8].precipProbability > .25 && hourlyWeather.data[8].precipProbability < .75){
  fill(rain);
  arc(xPos2, yPos3, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[8].precipProbability > .75){
fill(rain);
ellipse(xPos2,yPos3,iconRadiusSmall,iconRadiusSmall);
}
}

///////////////////////////////////////////////////////////////////////////////////// hour 9

   if(hourlyWeather.data[9].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[9].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[9].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos3, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[9].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);

   if(hourlyWeather.data[9].precipProbability < .25){
  fill(rain);
  arc(xPos3, yPos3, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[9].precipProbability > .25 && hourlyWeather.data[9].precipProbability < .75){
  fill(rain);
  arc(xPos3, yPos3, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[9].precipProbability > .75){
fill(rain);
ellipse(xPos3,yPos3,iconRadiusSmall,iconRadiusSmall);
 }
}

///////////////////////////////////////////////////////////////////////////////////// hour 10

   if(hourlyWeather.data[10].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[10].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[10].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos1, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[10].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);

 if(hourlyWeather.data[10].precipProbability < .25){
  fill(rain);
  arc(xPos1, yPos4, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[10].precipProbability > .25 && hourlyWeather.data[10].precipProbability < .75){
  fill(rain);
  arc(xPos1, yPos4, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[10].precipProbability > .75){
fill(rain);
ellipse(xPos1,yPos4,iconRadiusSmall,iconRadiusSmall);
 }
}

///////////////////////////////////////////////////////////////////////////////////// hour 11

   if(hourlyWeather.data[11].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[11].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[11].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos2, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);

}

   else if(hourlyWeather.data[11].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
 
if(hourlyWeather.data[11].precipProbability < .25){
  fill(rain);
  arc(xPos2, yPos4, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[11].precipProbability > .25 && hourlyWeather.data[11].precipProbability < .75){
  fill(rain);
  arc(xPos2, yPos4, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[11].precipProbability > .75){
fill(rain);
ellipse(xPos2,yPos4,iconRadiusSmall,iconRadiusSmall);
 }

}

///////////////////////////////////////////////////////////////////////////////////// hour 12

    if(hourlyWeather.data[12].icon == "clear-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);
}

   else if(hourlyWeather.data[12].icon == "partly-cloudy-day")
{
  noStroke();
  fill(sun);
  ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[12].icon == "partly-cloudy-night")
{
  noStroke();
  fill(night);
  ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);
  fill(cloud);
  arc(xPos3, yPos4, iconRadiusSmall, iconRadiusSmall, 0-QUARTER_PI, PI-QUARTER_PI, CHORD);
}

   else if(hourlyWeather.data[12].icon == "rain")
{
  noStroke();
  fill(cloud);
  ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);

 if(hourlyWeather.data[12].precipProbability < .25){
  fill(rain);
  arc(xPos3, yPos4, iconRadiusSmall, iconRadiusSmall, 0+QUARTER_PI, PI-QUARTER_PI, CHORD);
}

if(hourlyWeather.data[12].precipProbability > .25 && hourlyWeather.data[12].precipProbability < .75){
  fill(rain);
  arc(xPos3, yPos4, iconRadiusSmall, iconRadiusSmall, 0, PI, CHORD);
}

if(hourlyWeather.data[12].precipProbability > .75){
fill(rain);
ellipse(xPos3,yPos4,iconRadiusSmall,iconRadiusSmall);
 }
  
}

  // Future Temps
  fill(0);
  textSize(textSizeSmall);
  textStyle(BOLD);
  text(temp1,xPos1,yPos1+8);
  text(temp2,xPos2,yPos1+8);
  text(temp3,xPos3,yPos1+8);
  text(temp4,xPos1,yPos2+8);
  text(temp5,xPos2,yPos2+8);
  text(temp6,xPos3,yPos2+8);
  text(temp7,xPos1,yPos3+8);
  text(temp8,xPos2,yPos3+8);
  text(temp9,xPos3,yPos3+8);
  text(temp10,xPos1,yPos4+8);
  text(temp11,xPos2,yPos4+8);
  text(temp12,xPos3,yPos4+8);

  // time
  fill(200);
  textSize(12);
  textStyle(NORMAL);

  var i = h

  text((i+1),xPos1,yPos1+45);
  text((i+2),xPos2,yPos1+45);
  text((i+3),xPos3,yPos1+45);
  text((i+4),xPos1,yPos2+45);
  text((i+5),xPos2,yPos2+45);
  text((i+6),xPos3,yPos2+45);
  text((i+7),xPos1,yPos3+45);
  text((i+8),xPos2,yPos3+45);
  text((i+9),xPos3,yPos3+45);
  text((i+10),xPos1,yPos4+45);
  text((i+11),xPos2,yPos4+45);
  text((i+12),xPos3,yPos4+45);
  
  // border outline
  noFill();
  stroke(100);
  strokeWeight(2);
  rect(0,0,width,height);


}