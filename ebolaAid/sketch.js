// this table will contain the numbers and actual data
var table;

var margin = 1150;
var title  = 42;

var yTitle = 55;
var yTitle2 = 160;
var yLocation = 205;
var ypop = 235;
var yCases = 315;
var yDeaths = 375;
var yETU = 465;
var yCCC = 525;
var yHealth = 615;

// this is an array that will contain all the data in form of javascript objects
var states = [];
var leafletMap;
var worldJSON;

var m; 
var r;


var slider;


function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 

  table       = loadTable("data/newData.csv", "csv");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}


function setup() {  

   var canvas = createCanvas(1600,1475);  
   canvas.parent("container");
   parseData();  
   createMap();
   textFont(myFontThin);



  slider = createSlider(0, 144, 72);
  slider.position(57, 1450);
  slider.style('width', '1525px');

 // slider.style('color', 'white');


 }


function draw(){

   background(255);
   textFont(myFontThin);

   noStroke();
   textSize(40);
   fill('#3a913b');
   text("EBOLA  AID  FLOW  MAP",57, 55);
   text("AID DESTINATIONS",57, 790);
   
   
   // textFont(myFontBlack);
   // textSize(40);
   // fill('#3a913b');
   // text("2014 WEST AFRICA EBOLA OUTBREAK",900, 60);
   
   textSize(26);
   text("Click a Country",122, 635);


   fill(255,0,0);
     // var val = float(slider.value());
   text("slider value = " + slider.value(),80, 505);


   //rect(40,40,100,100);


 //   strokeWeight(51);
 //   line(112,610,800,610);

 //   if(mouseY > 580 && mouseY < 620){
 //   if (mouseIsPressed) 
 //   ellipse(mouseX,610,10,10);
 // }
 //   else  {
 //   ellipse(125,370,10,10);
 // }

   activeGraph();
   //scrollBar();

}


// create the map using leaflet

function createMap(){
  //var state = findStateByName(admin);

  leafletMap = L.map('map').setView([22, 0], 2);

  L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.{ext}', {
  //attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  //subdomains: 'abcd',
  minZoom: 0,
  maxZoom: 20,
  ext: 'png',
  opacity: 0.0,
  }).addTo(leafletMap);

  leafletMap._handlers.forEach(function(handler) {
    handler.disable();

});

  ////////////////////////////////////////////////////// World Map JSON

  worldJSON = L.geoJson(worldMap, {
    style: style,
   onEachFeature: onEachFeature
  }).addTo(leafletMap);  
}

/////////////////////////////////////////////////// Country Settings

function style(feature) {
  
    
    stateNow = findStateByName(feature.properties.admin);
      //  console.log(stateNow);
      var m = 0;
     if(stateNow!=undefined){ 
       var paid = float(stateNow.occupations[0].value);
       m = map(paid, 0, 150000000,.1,.6);

     }
//     console.log(m);

 // var m = map(state.occupations[1].value,0,359540696,0,1);

 // var m = map(state.occupations[1].value,0,359540696,0,1);

  return {
    weight: 1,
    opacity: .5,
    color: '#58a52e',
    dashArray: '1',
    fillOpacity: m,
    fillColor: '#58a52e'
  };
}

function onEachFeature(feature, layer) {
  layer.on({
    mouseover: highlightFeature,
    mouseout: resetHighlight,
    click: activateGraph,
  });
}

function highlightFeature(e) {
  var layer = e.target;

layer.setStyle({
    weight: 2,
    color: 'white',
    dashArray: '',
    // fill: false,
    fillColor: '#58a52e',
    fillOpacity: 0.6
  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }
  
}

function resetHighlight(e) {
  worldJSON.resetStyle(e.target);

}

function activateGraph(e) {

  //leafletMap.fitBounds(e.target.getBounds());
  var layer = e.target;

  var countryName = layer.feature.properties.admin;
  var region = layer.feature.properties.region_wb;
  
  //var center = layer.feature.geometry.coordinates.getCenter();

   fill(255);
   noStroke(0);
   rect(118,488,500,160);
   noStroke();
   textFont(myFontThin);
   textSize(26);
   fill('#3a913b');
   textAlign(LEFT);
   // text(countryName,122, 635);
   // textFont(myFontThin);
   // textSize(16);
   // text(region, 122, 470);
   // text("Pledged: XXX", 122, 500);
   // text("Paid Contribution: XXX", 122, 525);
   // text("Total Aid: XXX", 122, 550);
  

     console.log(countryName);
     //createGraph(layer.feature.properties.admin);
     playTimeline(layer.feature.properties.admin);

 }


function parseData(){
   //this is the key at the top, we will need it later
   var keyRow = table.getRow(0);
   var metaRow = table.getRow(1);

    // cycle through each item in that column, ignoring the first two items which are the headers
    for(var i=2;i<table.getRowCount(); i++){    

      //get each row for each id, hence the data for one state at a time
      var stateRow = table.getRow(i);

      // create an empty object for each state
      // we will attach all the information to this object
      var state = {};
      state.id = stateRow.getString(0);
      state.id2 = stateRow.getString(1);
      state.name = stateRow.getString(2);

      // this array will hold all occupation data
      state.occupations = [];
      
      for(var j=3; j<table.getColumnCount(); j++){
        // create an empty object that holds the occupation data for one category
        var item = {};
        item.label = metaRow.getString(j);
        item.key = keyRow.getString(j);
        item.value = stateRow.getString(j);
        
        // attach the item object to the "occupation" array
        append(state.occupations, item);
      }
      // attach the state object to the "states" array
      append(states, state);
   }

}



//  function createGraph(admin){
  
//   //var state = findStateByName(admin);
//   console.log(admin);

//   var runningTotal;
//   var state;
//   for(var i=0; i<states.length; i++){
//     if(states[i].name == admin){
//       state = states[i];
//     }
//   }
  
// //   // // first let's find the highest value for this state
//   var maxValue =200000000;

//   // for(var i=1; i<country.values.length; i++){
//   //   if(country.values[i].value>maxValue)
//   //     maxValue = country.values[i].value;
//   // }

//   console.log("maxValue: " + maxValue);

//   fill(255);
//   rect(width-550,0,width/2,height);
//   fill('#3a913b');

//   var xPos = 100;
//   var yPos = 1600;

//   //go through all states
//   // for(var i =0; i<70; i++){
//   //   // Display the state name
//   //   var stateDiv = createDiv(states[i].name);
//   //   stateDiv.position(xPos, yPos);
//   //   stateDiv.style("font-size", "50%");
//   //   stateDiv.style("color", "#c6c6c6");

//   //   // Display the population count (the first name in the array)
//   //   // var popDiv = createDiv(states[i].occupations[0].value);
//   //   // popDiv.position(xPos + 200, yPos);
//   //   // popDiv.style("width", "100px");
//   //   // popDiv.style("text-align", "right")
//   //   yPos +=8;

//   //   var rectX = map(states[i].occupations[0].value,0, 300000000, 1, 400);
//   //   rect(100,yPos,rectX,5);

    
//   // }


//     if(float(state.occupations[1].value) >= 200000000){
//        var h = 500;
//     }
//     else {
//       var h = map(float(state.occupations[1].value),0, maxValue, 3, 1000);
//     }

//     var rX = width-235;
//     var rY = 325;
    
//     // fill(0,255,0,100);
//     // triangle(mouseX,mouseY,rX,rY+h/2,rX,rY-h/2);
//     fill('#3a913b');
//     ellipse(rX,rY,h, h);
//    //  //stroke('#3a913b');
//    //  //line(mouseX,mouseY,rX,rY);
//    // // noStroke();
   
//    var str = map(float(state.occupations[1].value),0, 100000000, 1, 8);
//    strokeWeight(str);
//    stroke(58, 145, 59,180);
//    noFill();
//    bezier(mouseX,mouseY, 500, -200, 550, 525, 547,417);
//    noStroke();
   
//     fill('#3a913b');
//     textSize(26);
//     textAlign(CENTER);
//     var paid = nfc(float(state.occupations[1].value));
//     text("Paid Contribution: $" + paid,rX,rY + h/2 + 30);



//  }

  function playTimeline(admin){
  
  //var state = findStateByName(admin);
  console.log(admin);

  var runningTotal = 0.0;
  var state;
  var tempX = mouseX;
  var tempY = mouseY;
  var paidList = [];
  var count = 0;


  for(var i=0; i<states.length; i++){
    if(states[i].name == admin){
      state = states[i];
      paidList[count] = float(state.occupations[1].value);

      count++;

    }
  }

  for(var i=0; i<states.length; i++){
    if(states[i].name == admin){
      state = states[i];
      var paidDollars = float(state.occupations[1].value);
      runningTotal += paidDollars;
      console.log(runningTotal);
  
//   // // first let's find the highest value for this state
  var maxValue =200000000;

  fill(255);
  rect(width-550,50,width/2,height);
  fill('#3a913b');

  textSize(26);
  text("Click a Country",122, 635);

  var xPos = 100;
  var yPos = 1000;

  // //go through all states
  // for(var i=0; i<states.length; i++){
  //   // Display the state name
  //   var stateDiv = createDiv(states[i].name);
  //   stateDiv.position(xPos, yPos);
  //   stateDiv.style("font-size", "50%");
  //   stateDiv.style("color", "#c6c6c6");

  //   // Display the population count (the first name in the array)
  //   // var popDiv = createDiv(states[i].occupations[0].value);
  //   // popDiv.position(xPos + 200, yPos);
  //   // popDiv.style("width", "100px");
  //   // popDiv.style("text-align", "right")
  //   yPos +=8;
    
   
  // //  var rectX = map(runningTotal,0, maxValue, 1, 400);
  // //  rect(100,yPos,rectX,5);
  //    }
    

    if(runningTotal >= 200000000){
       var h = 300;
    }
    else {
      var h = map(runningTotal,0, 200000000, 3, 600);
    }

    var rX = width-225;
    var rY = 325;
    
    // fill(0,255,0,100);
    // triangle(mouseX,mouseY,rX,rY+h/2,rX,rY-h/2);
    fill('#3a913b');
    ellipse(rX,rY,h, h);
   //  //stroke('#3a913b');
   //  //line(mouseX,mouseY,rX,rY);
   // // noStroke();
   
   var str = map(runningTotal,0, 100000000, 1, 7);
   strokeWeight(str);
   stroke(58, 145, 59,40);
   noFill();
   bezier(tempX,tempY, 500, -200, 550, 525, 547,417);
   noStroke();
   
    fill('#3a913b');
    textSize(26);
    textAlign(CENTER);
    var paid = nfc(runningTotal);
    text("Paid Contribution: $" + paid,rX,rY + h/2 + 90);
    text(states[i].name,rX,rY + h/2 + 60);
    textAlign(LEFT);

    fill(255,0,0);
     // var val = float(slider.value());
    text("slider value = " + slider.value(),80, 505);

    var countValue = count;
    text("total payment counts = " + countValue, 80, 535);
    
    fill('#3a913b');
    var xPos2 = 80;
    var yPos2 = 830;
    rect(xPos2,yPos2,100,map(238168759, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(19415212, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(1028025604, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(753460487, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(103121737, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(153964272, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(1262994929, 0, 1262994929, 0, 600));
    xPos2 += 200;
    rect(xPos2,yPos2,100,map(58802154, 0, 1262994929, 0, 600));
  }
 }



 }

// helper function to find a state by name
function findStateByName(admin){
  var state;
  for(var i=0; i<states.length; i++){
    if(states[i].name == admin){
      state = states[i];
      return state;
    }
  }
}

 
