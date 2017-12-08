var queryResult;
var LatLong = "42.361936, -71.097309"


function setup() {
  createCanvas(320, 568);
  background(0);
 
query();
}

// Run the API call
function query() {

  // URL for querying
  var url= 'https://api.darksky.net/forecast/c62627d15e64486ca08975f6b55df8be/' + LatLong;

  // Query the URL, set a callback
  // 'jsonp' is needed for security
  loadJSON(url, gotData, 'jsonp');
}

// Request is completed
function gotData(data) {
  // console.log(data);
  queryResult = data;

  // only look at current results:
  var currentWeather = queryResult.currently;
  var hourlyWeather  = queryResult.hourly;
  var dailyWeather   = queryResult.daily;

  
  // a few variables for text formatting
  var xPos = 20;  
  var yPos = 40;
  var yPos2 = 75;
  var boxLength = 230;
  var yGap = 60; 
  var textSizeLarge = 32;
  var textSizeSmall = 12;

  var m = month();
  var d = day();
  var y = year();
  var h = hour();


  // Audio Play Button
   // noFill();
   // stroke(255);
   // strokeWeight(2);
   // triangle(xPos,(yGap+15),xPos+13,(yGap+23),xPos,(yGap+31));
   // //yPos+=yPos;
  
  // description variables
  var hourlySummary = "It's " + hourlyWeather.data[0].summary.toLowerCase() + " at the moment and "
  var tempDescription = ""
  var temp = hourlyWeather.data[0].apparentTemperature
  var futureTemp = hourlyWeather.data[5].apparentTemperature
  var futureTempDescription = ""
  var sky = hourlyWeather.data[0].cloudCover
  var skyDescription = ""
  var futureSky = hourlyWeather.data[5].cloudCover
  var fSkyDescription = ""
  var rain = float(hourlyWeather.data[0].precipProbability)
  var rainDescription = ""
  var futureRain = float(hourlyWeather.data[5].precipProbability)
  var fRainDescription = ""

  var intro = ""

  if(h >= 0 && h <= 6 ){intro = "This morning "}

  else if(h > 6 && h <= 12 ){intro = "This afternoon "}
  
  else if(h > 12 && h <= 18 ){intro = "This evening "}

  else if(h > 18 && h < 22 ){intro = "Tonight "}

  else if(h >= 22 && h <= 24 ){intro = "In the wee hours it "}


 // Date and Location
  fill(150);
  textSize(textSizeSmall);
  text(m + "/" + d + "/" + y + "  |  Cambridge, MA  ",20, yGap);
  yGap+=textSizeSmall;
  //text("Cambridge, MA  " + rain,20, yGap);
  //yPos+=yGap;


  // Temperature Summary
   fill(255);
   noStroke();
   textSize(textSizeLarge);
   textStyle(BOLD);
///////////////////////////////////////////////////////////////////////////////////////////////// current temp

if(futureTemp < 0){tempDescription = "it is way too fucking cold"}

  else if(temp < 10 && temp > 0){tempDescription = "insanely cold"}
  
  else if(temp < 20 && temp > 10){tempDescription = "very cold"}

  else if(temp < 30 && temp > 20){tempDescription = "cold"}

  else if(temp < 40 && temp > 30){tempDescription = "pretty cold"} 

  else if(temp < 50 && temp > 40){tempDescription = "very chilly"} 

  else if(temp < 60 && temp > 50){tempDescription = "kind of chilly"}

  else if(temp < 70 && temp > 60){tempDescription = "pleasant"}

  else if(temp < 80 && temp > 70){tempDescription = "warm"}

  else if(temp < 90 && temp > 80){tempDescription = "pretty hot"}

  else if(temp < 100 && temp > 90){tempDescription = "insanely hot"}

  else if(temp > 100){tempDescription = "it is way too fucking hot"}

  else{tempDescription = "I dont know what the hell the temperature is, sorry bro"}

  ///////////////////////////////////////////////////////////////////////////////////////////////// future temp

  if(futureTemp < 0){futureTempDescription = "it is way too fucking cold, sorry bro"}

  else if(futureTemp < 10 && futureTemp > 0){futureTempDescription = "insanely cold"}
  
  else if(futureTemp < 20 && futureTemp > 10){futureTempDescription = "very cold"}

  else if(futureTemp < 30 && futureTemp > 20){futureTempDescription = "cold"}

  else if(futureTemp < 40 && futureTemp > 30){futureTempDescription = "pretty cold"} 

  else if(futureTemp < 50 && futureTemp > 40){futureTempDescription = "very chilly"} 

  else if(futureTemp < 60 && futureTemp > 50){futureTempDescription = "kind of chilly"}

  else if(futureTemp < 70 && futureTemp > 60){futureTempDescription = "pleasant"}

  else if(futureTemp < 80 && futureTemp > 70){futureTempDescription = "warm"}

  else if(futureTemp < 90 && futureTemp > 80){futureTempDescription = "pretty hot"}

  else if(futureTemp < 100 && futureTemp > 90){futureTempDescription = "insanely hot"}

  else if(futureTemp> 100){futureTempDescription = "it is way too fucking hot"}

  else{futureTempDescription = "I dont know what the hell the temperature is, sorry bro"}

///////////////////////////////////////////////////////////////////////////////////////////////////// current sky

if(sky > 0 && sky <= .3){skyDescription = "little to no cloud cover "}

  else if(sky > .3 && sky <= .6){skyDescription = "partly cloudy skies "}

  else if(sky > .6 && sky <= .8){skyDescription = "mostly cloudy skies "}

  else if(sky > .8 && sky <= 1){skyDescription = "overcast skies "}

  else if(sky == 0){skyDescription = "clear skies "}

///////////////////////////////////////////////////////////////////////////////////////////////////// future sky

if(futureSky > 0 && futureSky <= .3){fSkyDescription = "little to no cloud cover "}

  else if(futureSky > .3 && futureSky <= .6){fSkyDescription = "partly cloudy skies "}

  else if(futureSky > .6 && futureSky <= .8){fSkyDescription = "mostly cloudy skies "}

  else if(futureSky > .8 && futureSky <= 1){fSkyDescription = "overcast skies "}

  else if(futureSky == 0){fSkyDescription = "clear skies "}


///////////////////////////////////////////////////////////////////////////////////////////////////// current rain


if(rain >= 0 && rain <= .2){rainDescription = "and no chance of rain."}

  else if(rain > .2 && rain <= .5){rainDescription = "and little chance of rain."}

  else if(rain > .5 && rain <= .75){rainDescription = "and a chance of rain."}

  else if(rain > .75 && rain <= 1){rainDescription = "and it will for sure rain."}

// else{rainDescription = "gon rain fool"}

///////////////////////////////////////////////////////////////////////////////////////////////////// future rain

if(futureRain >= 0 && futureRain <= .2){fRainDescription = "and no chance of rain."}

  else if(futureRain > .2 && futureRain <= .5){fRainDescription = "and little chance of rain."}

  else if(futureRain > .5 && futureRain <= .75){fRainDescription = "and a chance of rain."}

  else if(futureRain > .75 && futureRain <= 1){fRainDescription = "and it will for sure rain."}

 // else{fRainDescription = "gon rain fool"}

//////////////////////////////////////////////////////////////////////////////////////////////////////// Text


  text("Currently, it's " + tempDescription + " outside with " + skyDescription + rainDescription, 15, yPos2+10, (width-20),boxLength);

  text(intro +"is expected to be " + futureTempDescription + " with " + fSkyDescription + fRainDescription, 15, (yPos2 + 2 + boxLength), (width-20),boxLength);


} 