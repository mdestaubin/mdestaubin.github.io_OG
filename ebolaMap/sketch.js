// this table will contain the numbers and actual data
var table;

var margin = 855;

// this is an array that will contain all the data in form of javascript objects
var admins = [];

var leafletMap;

var slCountiesJSON;

var ginCountiesJSON;

var libCountiesJSON;

var libJSON;

var slJSON;

var ginJSON;

var libRoadJSON;

var myFontThin;

var myFontBlack;

var slOutline;

var CCCJSON;

var libHealthJSON;

var ginHealthJSON;

var slHealthJSON;

function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 
  table = loadTable("data/ebola_case_data.csv", "csv", "header");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}

function setup() {  
   var canvas = createCanvas(1600,800);  
   background(0);
   canvas.parent("container");
   createMap();
   textFont(myFontBlack);
   parseData();

   textSize(35);
   fill(255);
   text("EBOLA RESPONSE MAP", 855, 55);

  textSize(25);
  text("ABOUT", 855, 160);
  textFont(myFontThin);
  text("This interactive map was created with the intention of acting as a tool of research to visualize and understand the West Africa Ebola Outbreak Response. ", 855,170,375,400);
  text("+ Click on the counties to reveal statistical     information related to the outbreak.", 855,320,375,400);
  text("+ Click on the icons to learn about                  existing and temporary health facilities.", 855,410,375,400);

   stroke(255);
   strokeWeight(2);
   noFill();
   rect(22,27,805,725);
  
 }

// create the map using leaflet
function createMap(){
  leafletMap = L.map('map').setView([8.6, -11.5], 7);

  L.tileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', {
  //attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
  //subdomains: 'abcd',
  maxZoom: 19
  }).addTo(leafletMap);


////////////////////////////////////////////////////////// Country JSON

    slOutline = L.geoJson(slCountry, {
    style: countryStyle,
  }).addTo(leafletMap);  

  ////////////////////////////////////////////////////// Counties JSON

  slCountiesJSON = L.geoJson(slCounties, {
    style: style,
    onEachFeature: onEachFeature
  }).addTo(leafletMap);  

  ginCountiesJSON = L.geoJson(ginCounties, {
    style: style,
    onEachFeature: onEachFeature
  }).addTo(leafletMap);  

  libCountiesJSON = L.geoJson(libCounties, {
    style: style,
    onEachFeature: onEachFeature
  }).addTo(leafletMap);  


//////////////////////////////////////////////////////////// Roads

    libRoadJSON = L.geoJson(libROADS, {
    style: roadStyle,
  
  }).addTo(leafletMap);  

//////////////////////////////////////////////////// ETU JSON Files
  //libJSON = L.geoJson(libETUData, {
  libJSON = L.geoJson(libETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap); 

    slJSON = L.geoJson(slETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap); 

    ginJSON = L.geoJson(ginETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU 
}).addTo(leafletMap);  

    CCCJSON = L.geoJson(CCCData, {
      style: CCCstyle,
      pointToLayer : CCCpointToLayer,
      onEachFeature: onEachETU 
}).addTo(leafletMap);  


//////////////////////////////////////////////////////////// health centers    

//     ginHealthJSON = L.geoJson(ginHealth, {
//       style: ETUstyle,
//       pointToLayer : HpointToLayer,
//       onEachFeature: onEachETU
// }).addTo(leafletMap);     

//     libHealthJSON = L.geoJson(libHealth, {
//       style: ETUstyle,
//       pointToLayer : HpointToLayer,
//       onEachFeature: onEachETU
// }).addTo(leafletMap);      

//     slHealthJSON = L.geoJson(slHealth, {
//       style: ETUstyle,
//       pointToLayer : HpointToLayer,
//       onEachFeature: onEachETU 
// }).addTo(leafletMap);      
// }

// function onEachHealth(feature, layer) {
//      layer.bindPopup(
//            feature.properties.Type 
//           );
//     }

  //   function HpointToLayer(feature, latlng) {
  // return new L.CircleMarker(latlng,{
  //     radius: .5, 
  //     weight: .5, 
  //     color: 'white', 
  //     fillOpacity: .7
  //   });
    }

//     function heatlhStyle(feature) {
//   return {fillColor: 'white'};
//       }


///////////////////////////////////////////////////// ETU SETTINGS

function onEachETU(feature, layer) {
     layer.bindPopup(
           feature.properties.Type + "<b></b><br>" + 
           feature.properties.ECF_Name + "<b></b><br>" + 
          "Status: " + feature.properties.Status + "<b></b><br>" + "<b></b><br>" +
          "Partner: " + feature.properties.Partner + "<b></b><br>" + 
          "Lead Donor: " + feature.properties.Lead_Donor + "<b></b><br>" + 
          "Bed Capacity: " +  feature.properties.Beds_Plan  + "<b></b><br>" +
          "Lab Present: " + feature.properties.LabPresent
          + "<b></b><br>" + "<b></b><br>" +
          "Comments: " + feature.properties.Comment
          );
    layer.on({
    mouseover: highlightETU,
    mouseout: resetETU,
    //click: activateGraph
  });
    }

function pointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: 4, 
      weight: 2, 
      color: 'white', 
      fillOpacity: .7
    });
    }

function ETUstyle(feature) {
  return {fillColor: '##ffffff'};
      }

///////////////////////////////////////////////////////// CCC Specific
function CCCpointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: 4, 
      weight: 2, 
      color: 'white', 
      fillOpacity: .7
    });
    }

function CCCstyle(feature) {
  return {fillColor: '##ffffff'};
      }

/////////////////////////////////////////////////////////////////////

function highlightETU(e) {
  var layer = e.target;

layer.setStyle({
    radius: 6,
    weight: 2,
    color: 'white',
    fillColor: '##ffffff',
    fillOpacity: .5,
  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }

}

function resetETU(e) {
  ginJSON.resetStyle(e.target);
  slJSON.resetStyle(e.target);
  libJSON.resetStyle(e.target);
  CCCJSON.resetStyle(e.target);
  
}

////////////////////////////////////////////////// Country Settings

function countryStyle(feature) {
  return {
    weight: 1.5,
    opacity: .7,
    color: 'white',
    //dashArray: '4',
    fillOpacity: 0
  };
}

/////////////////////////////////////////////////// County Settings

function style(feature) {
  return {
    weight: 2,
    opacity: .5,
    color: 'white',
    dashArray: '4',
    fillOpacity: 0,
    //fillColor: '##ffffff'
  };
}

function roadStyle(feature) {
  return {
    weight: .75,
    opacity: .5,
    color: 'yellow',
    dashArray: '0',
    //fillOpacity: 0.4,
    //fillColor: '##ffffff'
  };
}

function onEachFeature(feature, layer) {
  layer.on({
    mouseover: highlightFeature,
    mouseout: resetHighlight,
    click: activateGraph
  });
}

function highlightFeature(e) {
  var layer = e.target;

layer.setStyle({
    weight: 5,
    color: 'white',
    dashArray: '',
    fillColor:'black',
    fillOpacity: 0
  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }
  
}

function resetHighlight(e) {
  slCountiesJSON.resetStyle(e.target);
  ginCountiesJSON.resetStyle(e.target);
  libCountiesJSON.resetStyle(e.target);
}


////////////////////////////////////////////////// ACTIVATE GRAPH

function activateGraph(e) {
  // leafletMap.fitBounds(e.target.getBounds());
  
  var layer = e.target;

  var countryName = layer.feature.properties.CNTRY_NAME;
  var admin1Name = layer.feature.properties.ADM1_NAME;
  var admin2Name = layer.feature.properties.ADM2_NAME;
  var admin3Name = layer.feature.properties.ADM3_NAME;

  var yGap = 15;

  background(0);

  stroke(255);
  strokeWeight(3);
  noFill();
  rect(22,27,805,725);

  fill(255); 
  noStroke();
  textFont(myFontBlack);
  textSize(35);
  text("EBOLA RESPONSE MAP", 855, 55)


  textSize(25);
  text(countryName, 855, 135);
  textFont(myFontThin);
  text("Admin Level 1: " + admin1Name, 855, 165);
  text("Admin Level 2: " + admin2Name, 855, 195);
  //text("Admin Level 3: " +admin3Name, 35, 240);
  console.log(admin1Name);
  createGraph(layer.feature.properties.ADM1_NAME);


}

/////////////////////////////////////////////////// PARSE DATA

function parseData(){
   //this is the key at the top, we will need it later
   var keyRow = table.getRow(0);
   //var metaRow = table.getRow(1);

    // cycle through each item in that column, ignoring the first two items which are the headers
    for(var i=1;i<table.getRowCount(); i++){    

      //get each row for each id, hence the data for one state at a time
      var adminRow = table.getRow(i);

      // create an empty object for each state
      // we will attach all the information to this object
      var admin = {};
      //state.id = stateRow.getString(0);
      //state.id2 = stateRow.getString(1);
      admin.ADM1_NAME = adminRow.getString(0);

      // this array will hold all occupation data
      admin.values = [];
      
      for(var j=1; j<table.getColumnCount(); j++){
        // create an empty object that holds the occupation data for one category
        var item = {};
        //item.label = metaRow.getString(j);
        item.label = keyRow.getString(j);
        item.value = adminRow.getNum(j);
        
        // attach the item object to the "occupation" array
        append(admin.values, item);
      }
      // attach the state object to the "states" array
      append(admins, admin);
   }
}


function createGraph(ADM1_NAME){
  
  var admin = findStateByName(ADM1_NAME);
  console.log(admin);
  
  // // first let's find the highest value for this state
  // var maxValue =0;

  // for(var i=1; i<admin.values.length; i++){
  //   if(admin.values[i].value>maxValue)
  //     maxValue = admin.values[i].value;
  // }

  // console.log("maxValue: " + maxValue);

  // // now draw the bars and the labels
  // background(245);
  // noStroke();
  // textAlign(LEFT);
  // textSize(16);

  text("Admins" + admin.ADM1_NAME, 855,300);  

  // textSize(8);

  // for(var i=1; i<admin.values.length; i++){
  //   // draw the bars
  //   fill(255);
  //   var x = map(i,1, admin.values.length-1, margin+10, width-margin);
  //   var y = map(admin.values[i].value,0, maxValue, height-margin, margin);
  //   var h = map(admin.values[i].value,0, maxValue, 0, height-(margin*2));
  //   rect(x,y,10, h);

  //    // add the labels
  //   fill(255);
  //   push();
  //   translate(x+5,height-margin+10);
  //   rotate(PI/5.0);
  //   text(admin.values[i].label,0,0 );
  //   pop();

  // }
  // // add labels to the y axis
  // stroke(255);
  // line(margin, margin, margin, height-margin);
  // noStroke();
  // textAlign(RIGHT);
  // textStyle(NORMAL);
  // var increment = maxValue/5;
  // increment = Math.round(increment/500)*500;
  // for(var i=0; i<maxValue; i+=increment){
  //   var xLabel = margin-10;
  //   var yLabel = map(i,0, maxValue,height-margin, margin);
  //   noStroke();
  //   fill(0);
  //   text(i, xLabel, yLabel+5);
  //   stroke(0);
  //   line(xLabel+5,yLabel,xLabel+10,yLabel);
  // }
}

// helper function to find a state by name
function findStateByName(ADM1_NAME){
  var admin;
  for(var i=0; i<admins.length; i++){
    if(admins[i].ADM1_NAME == ADM1_NAME){
      admin = admins[i];
      return admin;
    }
  }
}








