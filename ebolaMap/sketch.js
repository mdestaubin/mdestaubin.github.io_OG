// this table will contain the numbers and actual data
var table;

var margin = 150;

// this is an array that will contain all the data in form of javascript objects
var states = [];

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
  //table       = loadTable("data/ACS_15_5YR_S2401_with_ann_Clean.csv", "csv");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}

function setup() {  
   var canvas = createCanvas(1600,800);  
   background(0);
   canvas.parent("container");
   createMap();
   textFont(myFontBlack);
   //parseData();

   textSize(70);
   fill(255);
   text("EBOLA RESPONSE MAP", 855, 80);

  textSize(30);
  text("ABOUT", 855, 140);
  textFont(myFontThin);
  text("This interactive map was created with the intention of acting as a tool of research to visualize and understand the West Africa Ebola Outbreak Response. ", 855,170,630,400);
  text("Click on the counties to reveal statistical information related to the outbreak.", 855,310,630,400);
  text("Click on the icons to learn about existing and temporary health facilities.", 855,410,630,400);

   stroke(255);
   strokeWeight(3);
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

    ginHealthJSON = L.geoJson(ginHealth, {
      style: ETUstyle,
      pointToLayer : HpointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap);     

    libHealthJSON = L.geoJson(libHealth, {
      style: ETUstyle,
      pointToLayer : HpointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap);      

    slHealthJSON = L.geoJson(slHealth, {
      style: ETUstyle,
      pointToLayer : HpointToLayer,
      onEachFeature: onEachETU 
}).addTo(leafletMap);      
}

// function onEachHealth(feature, layer) {
//      layer.bindPopup(
//            feature.properties.Type 
//           );
//     }

    function HpointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: .5, 
      weight: .5, 
      color: 'white', 
      fillOpacity: .7
    });
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
    fillOpacity: 0.7
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
  textSize(70);
  text("EBOLA RESPONSE MAP", 855, 80);

  textSize(30);
  text(countryName, 855, 140);
  textFont(myFontThin);
  text("Admin Level 1: " + admin1Name, 855, 170);
  text("Admin Level 2: " + admin2Name, 855, 200);
  //text("Admin Level 3: " +admin3Name, 35, 240);
  console.log(admin1Name);
  createGraph(layer.feature.properties.name);


}

/////////////////////////////////////////////////// PARSE DATA

// function parseData(){
//    //this is the key at the top, we will need it later
//    var keyRow = table.getRow(0);
//    var metaRow = table.getRow(1);

//     // cycle through each item in that column, ignoring the first two items which are the headers
//     for(var i=2;i<table.getRowCount(); i++){    

//       //get each row for each id, hence the data for one state at a time
//       var stateRow = table.getRow(i);

//       // create an empty object for each state
//       // we will attach all the information to this object
//       var state = {};
//       state.id = stateRow.getString(0);
//       state.id2 = stateRow.getString(1);
//       state.name = stateRow.getString(2);

//       // this array will hold all occupation data
//       state.occupations = [];
      
//       for(var j=3; j<table.getColumnCount(); j++){
//         // create an empty object that holds the occupation data for one category
//         var item = {};
//         item.label = metaRow.getString(j);
//         item.key = keyRow.getString(j);
//         item.value = stateRow.getNum(j);
        
//         // attach the item object to the "occupation" array
//         append(state.occupations, item);
//       }
//       // attach the state object to the "states" array
//       append(states, state);
//    }
// }



// function createGraph(name){
  
//   //var county = findStateByName(name);
//   //console.log(state);
  
//   // first let's find the highest value for this state
//   var maxValue =0;

//   for(var i=1; i<county.values.length; i++){
//     if(county.values[i].value>maxValue)
//       maxValue = county.values[i].value;
//   }

//   console.log("maxValue: " + maxValue);

//   // now draw the bars and the labels
//   background(245);
//   noStroke();
//   textAlign(LEFT);
//   textSize(16);

//   text(state.occupations[3].label,200,200 );

  // textSize(8);

  // for(var i=1; i<state.occupations.length; i++){
  //   // draw the bars
  //   fill(120);
  //   var x = map(i,1, state.occupations.length-1, margin+10, width-margin);
  //   var y = map(state.occupations[i].value,0, maxValue, height-margin, margin);
  //   var h = map(state.occupations[i].value,0, maxValue, 0, height-(margin*2));
  //   rect(x,y,10, h);

  //    // add the labels
  //   fill(0);
  //   push();
  //   translate(x+5,height-margin+10);
  //   rotate(PI/5.0);
  //   text(state.occupations[i].label,0,0 );
  //   pop();

  // }
  // // add labels to the y axis
  // stroke(0);
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
// }

// // helper function to find a state by name
// function findStateByName(name){
//   var county;
//   for(var i=0; i<counties.length; i++){
//     if(counties[i].name == name){
//       county = counties[i];
//       return county;
//     }
//   }
// }








