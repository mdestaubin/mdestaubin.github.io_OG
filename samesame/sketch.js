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

 var black      = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner-background/{z}/{x}/{y}{r}.{ext}', {
                  attribution: '',
                  subdomains: 'abcd',
                  ext: 'png'
                }),
     satelite   = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
                attribution: ''
                });


 var leafletMap = L.map('map',{
       center: [42.369, -71.109419],
       zoom: 14,
       layers: [black,satelite]
});

 var baseMaps = {
    "Satelite": satelite,
    "Black": black
};
  

 L.control.layers(baseMaps).addTo(leafletMap);

  libJSON = L.geoJson(libETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU
}).addTo(leafletMap); 

  }

/////////////////////////////////////////////////// Country Settings


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
      color: 'red', 
      fillOpacity: 0
    });
    }

function ETUstyle(feature) {
  return {      
      radius: 2.0, 
      weight: 3.0, 
      color: 'red', 
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











 
