var queryResult;
var img;


function setup() {
  createCanvas(320, 568);
  background(255);
  img = loadImage('http://c8.alamy.com/comp/E4P5YP/colorful-fall-leaves-on-a-sunny-day-near-harvard-university-campus-E4P5YP.jpg');
  query();
}

// Run the API call
function query() {

  // URL for querying
  var url= 'https://api.darksky.net/forecast/c62627d15e64486ca08975f6b55df8be/42.361936, -71.097309';

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
  var hourlyWeather = queryResult.hourly;
  var dailyWeather = queryResult.daily;



  
  // a few variables for text formatting
  var xPos = 20;  
  var yPos = 40;
  var yGap = 60; 
  var textSizeLarge = 20;
  var textSizeSmall = 16;
  var textSizeDegrees = 30;

  var m = month();
  var d = day();
  var y = year();

  var boxY = 150;

  // List relevant items of information
  fill(50);
  textStyle(BOLD);

  // Date and Location
  textSize(textSizeSmall);
  text(m + "/" + d + "/" + y,15, yGap);
  //yGap+=textSizeSmall;
  //text("Cambridge, MA",20, yGap);
  yPos+=yGap;

  // Temperature Summary
 
  //text("Don't you know it's going to be " + hourlyWeather.summary + " You fool.",20, (yPos+10), (width-40),100);
  // yPos+=yGap;


    // Blocks
  noStroke();
  fill(0,0,200,90);
  rect(0,70,width,boxY);
  rect(0,225,width,boxY);
  rect(0,380,width,boxY);

  
 
  // temperature ellipses
  fill(255,50);
  ellipse(80,145,80,80);
  ellipse(80,300,80,80);
  ellipse(80,455,80,80);

  fill(255);
  rect((width-110),70,110,25);
  rect((width-110),225,110,25);
  rect((width-110),380,110,25); 



  // Time Text
  fill(0);
  textSize(textSizeLarge);
  textAlign(RIGHT);
  text("Morning", (width-10), 90);
  text("Afternoon", (width-10), 245);
  text("Evening", (width-10), 400);

  textSize(textSizeDegrees);
  textAlign(CENTER);
  text(Math.round(hourlyWeather.data[0].temperature), 80,155);

  textSize(textSizeLarge);
  const dateTime = Date.now();
  const timestamp = Math.floor(dateTime/ 1000);

  text(timestamp + ' ' + hourlyWeather.data[0].time, width/2,height/2);

  // settings and arrow
  noFill();
  strokeWeight(3);
  stroke(0);
  ellipseMode(CENTER);
  ellipse(20,549,14,14);
  line(width-25,556,width-15,549);
  line(width-25,542,width-15,549);


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