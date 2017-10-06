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
  var yGap = 60; 
  var textSizeLarge = 30;
  var textSizeSmall = 16;

  var m = month();
  var d = day();
  var y = year();

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
  var futureTemp = hourlyWeather.data[6].apparentTemperature
  var futureTempDescription = ""
  var sky = hourlyWeather.data[0].cloudCover
  var skyDescription = ""
  var rain = hourlyWeather.data[0].precipProbability
  var rainDescription = ""


 // Date and Location
  fill(255);
  textSize(textSizeSmall);
  text(m + "/" + d + "/" + y,20, yGap);
  yGap+=textSizeSmall;
  text("Cambridge, MA  " + sky,20, yGap);
  yPos+=yGap;


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

  else if(temp < 50 && temp > 40){tempDescription = "pretty chilly"} 

  else if(temp < 60 && temp > 50){tempDescription = "kind of chilly"}

  else if(temp < 70 && temp > 60){tempDescription = "basically the perfect temperature"}

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

  else if(futureTemp < 50 && futureTemp > 40){futureTempDescription = "pretty chilly"} 

  else if(futureTemp < 60 && futureTemp > 50){futureTempDescription = "kind of chilly"}

  else if(futureTemp < 70 && futureTemp > 60){futureTempDescription = "basically the perfect temperature"}

  else if(futureTemp < 80 && futureTemp > 70){futureTempDescription = "warm"}

  else if(futureTemp < 90 && futureTemp > 80){futureTempDescription = "pretty hot"}

  else if(futureTemp < 100 && futureTemp > 90){futureTempDescription = "insanely hot"}

  else if(futureTemp> 100){futureTempDescription = "it is way too fucking hot"}

  else{futureTempDescription = "I dont know what the hell the temperature is, sorry bro"}


if(sky > 0 && sky < .3){skyDescription = "little to no cloud cover. "}


if(rain > 0 && rain < .2){rainDescription = "There is no chance of rain."}


  text("Currently, it's " + tempDescription + " outside with " + skyDescription + rainDescription, 20, yPos, (width-30),300);

  text("Later, it's going to be " + futureTempDescription + " with " , 20, (height/2)+40, (width-30),200);


}