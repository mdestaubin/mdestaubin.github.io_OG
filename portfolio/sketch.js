// this table will contain the numbers and actual data
var table;
var table2;

var margin = 1150;
var title  = 42;

// this is an array that will contain all the data in form of javascript objects
var leafletMap;
var worldJSON;
var path;

var libJSON;

function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 
  table       = loadTable("data/newData.csv", "csv");
  table2      = loadTable("data/testData.csv", "csv");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}


function setup() {  
   background(255);
   // var canvas = createCanvas(1600,800);  
   // canvas.parent("container"); 
   createMap();
   textFont(myFontThin);
    
 }

// create the map using leaflet

function createMap(){
  background(255);
  //var state = findStateByName(admin);

  leafletMap = L.map('map').setView([25, 0], 2);

  L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.{ext}', {

  minZoom: 0,
  maxZoom: 20,
  ext: 'png',
  opacity: 0.0,
  }).addTo(leafletMap);



  worldJSON = L.geoJson(worldMap, {
    style: style,
   onEachFeature: onEachFeature
  }).addTo(leafletMap);  


  libJSON = L.geoJson(libETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap); 
  }

/////////////////////////////////////////////////// Country Settings

function style(feature) {

  return {
    weight: .5,
    opacity: .5,
    color: '#000000',
    dashArray: '1',
    fillOpacity: '0',
    fillColor: '#58a52e'
  };
}


function onEachFeature(feature, layer) {
  layer.on({
    // mouseover: highlightFeature,
    // mouseout: resetHighlight,
    // click: activateGraph,
  });
}

function highlightFeature(e) {
  var layer = e.target;

    layer.setStyle({
    weight: 3,
    color: '#000000',
    fillOpacity: 0,
  });
  }


 function onEachETU(feature, layer) {
     layer.bindPopup(
           feature.properties.Type+ "<br>" + 
           feature.properties.Beds_Plan  + "<br>" + 
           feature.properties.Partner + "<br>" + 
           feature.properties.Lead_Donor
          );
    layer.on({
    mouseover: highlightETU,
    mouseout: resetETU,
    //click: activateGraph
  });
    }

function pointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: 6, 
      weight: 3, 
      color: '#a52222', 
      fillOpacity: 0
    });
    }

function ETUstyle(feature) {
  return {      
      radius: 3, 
      weight: 3, 
      color: '#000000', 
      fillOpacity: 0};
      }

function highlightETU(e) {
  var layer = e.target;

    layer.setStyle({
    radius: 7,
    weight: 3,
    color: '#000000',
    fillOpacity: 0,
  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }
}

function resetHighlight(e) {

  libJSON.resetStyle(e.target);
}


function resetETU(e) {

  libJSON.resetStyle(e.target);
}



 







 
