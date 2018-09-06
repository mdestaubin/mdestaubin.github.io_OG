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
var townJSON;

var marker;

// var address;

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
   var canvas = createCanvas(800,800);  
   canvas.parent("container"); 
   createMap();
   textFont(myFontThin);
    
 }

// create the map using leaflet

function createMap(){
  background(255);
  //var state = findStateByName(admin);

  leafletMap = L.map('map').setView([32, 0], 2);

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

  townJSON = L.geoJson(townData, {
      style: townStyle,
      pointToLayer : TpointToLayer,
      onEachFeature: onEachTown
}).addTo(leafletMap); 

  }

/////////////////////////////////////////////////// Country Settings

function style(feature) {

  return {
    weight: .5,
    opacity: .75,
    color: '#000000',
    dashArray: '1',
    fillOpacity: '1',
    fillColor: 'white',
    background: 'blue'
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

      "<a href=' " + feature.properties.Lead_Donor + " '>" + "<br>"  +
      "<img src=" + feature.properties.Type + " width = '200px'/> </a>" + "<br>" + 
         feature.properties.Beds_Plan    
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

    // function pointToLayer(feature, latlng) {
    // return new L.icon(latlng,{
    // iconUrl: feature.properties.Type,

    // iconSize:     [50, 50], // size of the icon
    // // shadowSize:   [50, 64], // size of the shadow
    // iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
    // // shadowAnchor: [4, 62],  // the same for the shadow
    // popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
    // });
    // }

    function TpointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: 3, 
      weight: 3, 
      color: '#000000', 
      fillOpacity: 0
    });
    }

function ETUstyle(feature) {
  return {      
      radius: 2.0, 
      weight: 3.0, 
      color: '#000000', 
      fillOpacity: 0};
      }

function highlightETU(e) {
  var layer = e.target;

    layer.setStyle({
    radius: 10,
    weight: 3,
    color: '#000000',
    fillOpacity: 0,

  });

  if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
    layer.bringToFront();
  }
}

function townStyle(feature) {
  return {      
      radius: 2, 
      weight: 2, 
      color: 'red', 
      fillOpacity: 1};
      }

 function onEachTown(feature, layer) {
     layer.bindPopup( 
      feature.properties.title +
      feature.properties.line1 + 
      feature.properties.line2 + "<br>"  +
      feature.properties.updated  
          );
    layer.on({
    mouseover: highlightTown,
    mouseout: resetTOWN,
    //click: activateGraph
  });
    }

    function highlightTown(e) {
  var layer = e.target;

    layer.setStyle({
    radius: 4,
    weight: 3,
    color: 'red',
    fillOpacity: 1,
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

function resetTOWN(e) {
  townJSON.resetStyle(e.target);
}











 
