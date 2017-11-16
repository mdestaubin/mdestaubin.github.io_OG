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
var admins = [];
var leafletMap;
var worldJSON;

var m; 

function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 

  table = loadTable("data/finData.csv", "csv", "header");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}


function setup() {  

   var canvas = createCanvas(1600,1500);  
   canvas.parent("container");
   createMap();
   textFont(myFontThin);
   parseData();

   var m = map(0,0,0,0,0);
   var moneyScale = m/100;
 }


function draw(){
   background(255);
   textFont(myFontThin);
   
   noStroke();
   textSize(title);
   fill('#3a913b');
   text("EBOLA  AID  FLOW.",122, 40);

   strokeWeight(1.25);
   stroke(58, 145, 59,180);
   line(125,610,1155,610);
   
   fill('white');  
   strokeWeight(1.5);
  

   if(mouseY > 580 && mouseY < 620){
   if (mouseIsPressed) 
   ellipse(mouseX,610,10,10);
   else  
   ellipse(125,610,10,10);
}
   else  
   ellipse(125,610,10,10);

 activateGraph();

}

// create the map using leaflet

function createMap(){

  leafletMap = L.map('map').setView([20, 0], 2);

  L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.{ext}', {
  attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  subdomains: 'abcd',
  minZoom: 0,
  maxZoom: 20,
  ext: 'png',
  opacity: 0.0,
  }).addTo(leafletMap);


  ////////////////////////////////////////////////////// World Map JSON

  worldJSON = L.geoJson(worldMap, {
    style: style,
   onEachFeature: onEachFeature
  }).addTo(leafletMap);  

/////////////////////////////////////////////////// Country Settings

function style(feature) {
  return {
    weight: 2,
    opacity: .5,
    color: '#58a52e',
    dashArray: '1',
    fillOpacity: 0,
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

  // if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
  //   layer.bringToFront();
  // }
  
}

function resetHighlight(e) {
  worldJSON.resetStyle(e.target);

}

function activateGraph(e) {

  //leafletMap.fitBounds(e.target.getBounds());
  var layer = e.target;

  var countryName = layer.feature.properties.admin;
  var region = layer.feature.properties.region_wb;
   
   fill(255);
   noStroke(0);
   rect(118,388,500,200);
   noStroke();
   textFont(myFontBlack);
   textSize(22);
   fill('#3a913b');
   text(countryName,120, 410);
   textFont(myFontThin);
   textSize(16);
   text(region,120, 430);
  
//   var yGap = 15;



//   fill('#a52222'); 
   // background(255);
   // noStroke();
   // textFont(myFontThin);
   // fill(58, 145, 59);
   // textSize(title);
   // text("EBOLA  AID  FLOW",122, 40);

//   fill(255);
//   textSize(25);
//   text(countryName, margin, yTitle2);
   
//   //text("Admin Level 3: " +admin3Name, 35, 240);
//   console.log(admin1Name);
//   createGraph(layer.feature.properties.ADM1_NAME);
    
   // stroke(58, 145, 59);
   // line(125,600,1155,600);
   // fill('white');  
   // ellipse(mouseX,600,10,10);

 }
 



////////////////////////////////////////////////// ACTIVATE GRAPH



// /////////////////////////////////////////////////// PARSE DATA

}

function parseData(){
//    //this is the key at the top, we will need it later
     var keyRow = table.getRow(0);
     var metaRow = table.getRow(1);

//     // cycle through each item in that column, ignoring the first two items which are the headers
//     for(var i=1;i<table.getRowCount(); i++){    

//       //get each row for each id, hence the data for one state at a time
//       var adminRow = table.getRow(i);

//       // create an empty object for each state
//       // we will attach all the information to this object
//       var admin = {};
//       //state.id = stateRow.getString(0);
//       //state.id2 = stateRow.getString(1);
//       admin.ADM1_NAME = adminRow.getString(0);

//       // this array will hold all occupation data
//       admin.values = [];
      
//       for(var j=1; j<table.getColumnCount(); j++){
//         // create an empty object that holds the occupation data for one category
//         var item = {};
//         //item.label = metaRow.getString(j);
//         item.label = keyRow.getString(j);
//         item.value = adminRow.getNum(j);
        
//         // attach the item object to the "occupation" array
//         append(admin.values, item);
//       }
//       // attach the state object to the "states" array
//       append(admins, admin);
//    }
 }


 // function createGraph(admn){
  
 //  var admin = findStateByName(admn);
 //  console.log(admin);
  
//   // // first let's find the highest value for this state
//  var maxValue =0;

//   for(var i=1; i<admin.values.length; i++){
//     if(admin.values[i].value>maxValue)
//       maxValue = admin.values[i].value;
//   }

//    console.log("maxValue: " + maxValue);

//   // // now draw the bars and the labels
//   // background(245);
//   // noStroke();
//   // textAlign(LEFT);
//   // textSize(16);
  
//   textSize(20);
//   text("Population: " + admin.values[4].value,margin,ypop);

//   text("Confirmed Cases: " + admin.values[0].value,margin,yCases);
//   text("Confirmed Deaths: " + admin.values[1].value,margin,yDeaths);

//   text("Ebola Treatment Units: " + admin.values[2].value,margin,yETU);
//   text("Community Care Centers: " + admin.values[3].value,margin,yCCC);
  
//   text("Exisiting Health Facilities: ",margin,yHealth);

 
//     // draw the bars
    
//     var x = map(admin.values[0].value,0,4866,0,400);
//     var x2 = map(admin.values[1].value,0,2026,0,170);
//     var x3 = map(admin.values[2].value,0,10,0,400);
//     var x4 = map(admin.values[3].value,0,10,0,400);


//     fill(255,50);
//     rect(margin,yCases+9,400, 25);
//     rect(margin,yDeaths+9,170, 25);
//     rect(margin,yETU+9,400, 25);
//     rect(margin,yCCC+9,400, 25);

//     fill(255);
//     rect(margin,yCases+9,x, 25);
//     rect(margin,yDeaths+9,x2, 25);
//     rect(margin,yETU+9,x3, 25);
//     rect(margin,yCCC+9,x4, 25);

//     image(img, margin, yETU+9);
//     image(img, margin, yCCC+9);
// }

// helper function to find a state by name
//  function findStateByName(admn){
//   var admin;
//   for(var i=0; i<admins.length; i++){
//     if(admins[i].ADM1_NAME == ADM1_NAME){
//       admin = admins[i];
//       return admin;
//     }
//   }
// }

 





