// this table will contain the numbers and actual data
var table;
var table2;

var margin = 1150;
var title  = 42;

// this is an array that will contain all the data in form of javascript objects
var leafletMap;
var worldJSON;
var path;



function preload() {
  //my table is comma separated value "csv"
  //I'm ignoring the header 
  // table       = loadTable("data/newData.csv", "csv");
  // table2      = loadTable("data/testData.csv", "csv");
  myFontThin  = loadFont('Text/frutiger-thin.otf');
  myFontBlack = loadFont('Text/frutiger-black.otf');
}


function setup() {  

   var canvas = createCanvas(1600,800);  
   canvas.parent("container"); 
   createMap();
   textFont(myFontThin);
    
 }

// create the map using leaflet

function createMap(){
  background(255);
  //var state = findStateByName(admin);

  leafletMap = L.map('map').setView([25, 0], 2);

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

  worldJSON = L.geoJson(worldMap, {
    style: style,
   onEachFeature: onEachFeature
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
    // fill: false,
    fillColor: '#000000',
    fillOpacity: 0.3
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



 







 
