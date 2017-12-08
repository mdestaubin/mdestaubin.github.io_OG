// this table will contain the numbers and actual data
var table;
var table2;

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
var states2 = [];
var leafletMap;
var worldJSON;
var path;

var m; 
var r;

var slider;
var sliderValue;

var button;


function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 

  table       = loadTable("data/newData.csv", "csv");
  table2      = loadTable("data/testData.csv", "csv");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}


function setup() {  

   var canvas = createCanvas(1600,1475);  
   canvas.parent("container");
   parseData();
   parseData2();  
   createMap();
   textFont(myFontThin);
   aidDestination();


   var numRows = table.getRowCount(); 

   console.log("rows = " + numRows);

  slider = createSlider(0, numRows, 1);
  slider.position(57, 1450);
  slider.style('width', '1525px');
  slider.style('height', '2px');

   textFont(myFontThin);
   noStroke();
   textSize(40);
   fill('#3a913b');
   text("EBOLA  AID  FLOW  MAP",57, 55);
   text("AID DESTINATIONS",57, 790);
    
 }

 function draw(){

  dateUpdate();
 
}
// create the map using leaflet

function createMap(){
  background(255);
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

  // var pointA = L.LatLng(45,28.520507812500004);
  // var pointB = L.LatLng(10, -10);

  // var path = L.curve(['M',[45,28.520507812500004],
  //         'C',[80,0],
  //           [60,-10],
  //           [10,-10]],
  //         {
  //         color:'green',
  //         fill:false,

  //       }).addTo(leafletMap);

  //      path2 = L.curve(['M',[45,-90],
  //         'C',[100,-20],
  //           [60,-10],
  //           [10,-10]],
  //         {color:'green',fill:false}).addTo(leafletMap);

//   var arcedPolyline = L.ArcedPolyline([45,28.520507812500004], {
//   color: '#FF00000',
//   weight: 4
// }).addTo(leafletMap);

// var arcedPolyline = L.ArcedPolyline([45,28.520507812500004, 0, 0], {
//   distanceToHeight: L.LinearFunction([0, 0], [4000, 400]),
//   color: '#FF00000',
//   weight: 4,
// });
// leafletMap.addLayer(arcedPolyline);

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
       var paid = float(stateNow.occupations[1].value);
       m = map(paid, 0, 50000000,.2,.8);
     }

//     console.log(m);

  return {
    weight: .5,
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

     console.log(countryName);
    // createGraph(layer.feature.properties.admin);
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

function parseData2(){
   //this is the key at the top, we will need it later
   var keyRow = table2.getRow(0);
   var metaRow = table2.getRow(1);

    // cycle through each item in that column, ignoring the first two items which are the headers
    for(var i=2;i<table2.getRowCount(); i++){    

      //get each row for each id, hence the data for one state at a time
      var stateRow = table2.getRow(i);

      // create an empty object for each state
      // we will attach all the information to this object
      var state2 = {};
      state2.id = stateRow.getString(0);
      state2.id2 = stateRow.getString(1);
      state2.name = stateRow.getString(2);

      // this array will hold all occupation data
      state2.occupations = [];
      
      for(var j=3; j<table.getColumnCount(); j++){
        // create an empty object that holds the occupation data for one category
        var item2 = {};
        item2.label = metaRow.getString(j);
        item2.key = keyRow.getString(j);
        item2.value = stateRow.getString(j);
        
        // attach the item object to the "occupation" array
        append(state2.occupations, item2);
      }
      // attach the state object to the "states" array
      append(states2, state2);
   }

}

  function playTimeline(admin){
  
  //var state = findStateByName(admin);
  console.log(admin);

  var runningTotal = 0.0;
  var state;
  var tempX = mouseX;
  var tempY = mouseY;
  var paidList = [];
  var count = 0;
  var maxTime = slider.value();


  for(var i=0; i<states.length; i++){
    if(states[i].name == admin){
      state = states[i];
      paidList[count] = float(state.occupations[1].value);

      count++;

    }
  }
   
  for(var i=0; i<maxTime; i++){
    if(states[i].name == admin){
      var state = states[i];
      var paidDollars = float(state.occupations[1].value);
      runningTotal += paidDollars;

      console.log(runningTotal);

  fill(255);
  rect(width-550,50,width/2,height/2);
  fill('#3a913b');

  var xPos = 100;
  var yPos = 1000;
    
    if(runningTotal >= 200000000){
       var h = 400;
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
   stroke(58, 145, 59,100);
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
  }
 }
}

// helper function to find a state by name
function findStateByName(admin){
  var state2;
  for(var i=0; i<states2.length; i++){
    if(states2[i].name == admin){
      state2 = states2[i];
      return state2;
    }
  }
}

function aidDestination(){
    
    noStroke();
    textSize(16);
    textAlign(CENTER);
    fill(58, 145, 59,200);
    var xPos2 = 100;
    var yPos2 = 900;
    var yPos3 = 1200;
    ellipse(xPos2,yPos2,map(238168759, 0, 1262994929, 0, 400),map(238168759, 0, 1262994929, 0, 400));
    text("National Government",xPos2,yPos2+map(238168759, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos3,map(1028025604, 0, 1262994929, 0, 400),map(1028025604, 0, 1262994929, 0, 400));
    text("NGO",xPos2,yPos3+map(1028025604, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos2,map(19415212, 0, 1262994929, 0, 400),map(19415212, 0, 1262994929, 0, 400));
    text("Inter-Governmental",xPos2,yPos2+map(19415212, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2 + 60,yPos3,map(753460487, 0, 1262994929, 0, 400),map(753460487, 0, 1262994929, 0, 400));
    text("Not Specified",xPos2+ 60,yPos3+map(753460487, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos2,map(103121737, 0, 1262994929, 0, 400),map(103121737, 0, 1262994929, 0, 400));
    text("Private Organization",xPos2,yPos2+map(103121737, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos2,map(153964272, 0, 1262994929, 0, 400),map(153964272, 0, 1262994929, 0, 400));
    text("Red Cross/Red Crescent",xPos2,yPos2+map(153964272, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos3,map(1262994929, 0, 1262994929, 0, 400),map(1262994929, 0, 1262994929, 0, 400));
    text("UN Agency",xPos2,yPos3+map(1262994929, 0, 1262994929, 0, 400)/2 +20);
    xPos2 += 200;
    ellipse(xPos2,yPos2,map(58802154, 0, 1262994929, 0, 400),map(58802154, 0, 1262994929, 0,400));
    text("Multiple Organization Types",xPos2,yPos2+map(58802154, 0, 1262994929, 0, 400)/2 +20);

   noFill();
   var rX = width-225;
   var rY = 325;
   var h = 400;
   stroke('#3a913b');
   strokeWeight(.5);
   ellipse(rX,rY,h,h);
   noStroke();
   fill('#3a913b');
   text("COUNTRY DATA", rX, rY);
   textAlign(LEFT);
}

function dateUpdate(){

   textSize(22);
   var val = slider.value();

   if(val > 0 && val <= 35){
   fill(255);
   rect(55,650,200,30);
   fill(50);
   text("January 2014", 57, 670);
 }
  else if(val > 35 && val <= 37){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("February 2014", 57, 670);
 }

  else if(val > 37 && val <= 59){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("March 2014", 57, 670);
 }

  else if(val > 59 && val <= 70){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("April 2014", 57, 670);
 }

  else if(val > 70 && val <= 77){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("May 2014", 57, 670);
 }

  else if(val > 77 && val <= 92){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("June 2014", 57, 670);
 }

  else if(val > 92 && val <= 105){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("July 2014", 57, 670);
 }

 else if(val > 105 && val <= 113){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("August 2014", 57, 670);
 }

 else if(val > 113 && val <= 120){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("September 2014", 57, 670);
 }

  else if(val > 120 && val <= 132){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("October 2014", 57, 670);
 }

  else if(val > 132 && val <= 152){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("November 2014", 57, 670);
 }

  else if(val > 132 && val <= 163){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("December 2014", 57, 670);
 }

  else if(val > 163 && val <= 165){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("January 2015", 57, 670);
 }

  else if(val > 165 && val <= 165){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("February 2015", 57, 670);
 }

 else if(val > 165 && val <= 170){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("March 2015", 57, 670);
 }

  else if(val > 170 && val <= 200){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("April 2015", 57, 670);
 }

  else if(val > 200 && val <= 230){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("May 2015", 57, 670);
 }

  else if(val > 230 && val <= 260){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("June 2015", 57, 670);
 }

  else if(val > 260 && val <= 300){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("July 2015", 57, 670);
 }

 else if(val > 300 && val <= 330){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("August 2015", 57, 670);
 }

 else if(val > 330 && val <= 360){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("September 2015", 57, 670);
 }

  else if(val > 360 && val <= 390){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("October 2015", 57, 670);
 }

  else if(val > 390 && val <= 420){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("November 2015", 57, 670);
 }

  else if(val > 420 && val <= 439){
   fill(255);
   rect(55,650,200,30); 
   fill(50);
   text("December 2015", 57, 670);
 }



}

 
