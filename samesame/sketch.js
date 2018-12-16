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
var marker;

var cambuild;
var mapLayerGroups = [];


function setup() {  
   background(0);
   var canvas = createCanvas(800,800);  
   canvas.parent("container"); 
   createMap();
   textFont(myFontThin);
 }

// create the map using leaflet

function createMap(){
  background(0);

 var black      = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner-background/{z}/{x}/{y}{r}.{ext}', {
                  attribution: '',
                  subdomains: 'abcd',
                  ext: 'png'
                });
     // satelite   = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
     //            attribution: ''
     //            });


 var leafletMap = L.map('map',{
       center: [42.369, -71.109419],
       zoom: 14,
       layers: [black]
});

 var baseMaps = {
    // "Satelite": satelite,
    "Black": black
};
  
 L.control.layers(baseMaps).addTo(leafletMap);

  libJSON = L.geoJson(libETUData, {
      style: ETUstyle,
      pointToLayer : pointToLayer,
      onEachFeature: onEachETU
// }); 
}).addTo(leafletMap); 

  //  cambuild = L.geoJson(cambuild, {
  //  style: style,
  //  onEachFeature: onEachFeature
  // }).addTo(leafletMap);  

  }

// showLayer("a");

// function showLayer(id) {
//     var lg = mapLayerGroups[id];
//     map.addLayer(lg);   
// }

// function hideLayer(id) {
//     var lg = mapLayerGroups[id];
//     map.removeLayer(lg);   
// }

/////////////////////////////////////////////////// Country Settings

 function getColor(d) {
  switch (d) {
    case 'a':
      return '#540D6E';
    case 'b':
      return '#EE4266';
    case 'c':
      return '#3BCEAC';
    case 'd':
      return '#0EAD69';
    case 'e':
      return '#FFD23F';
    default:
      return 'black';
  }
}

 function style(feature) {

  return {
    weight: .5,
    opacity: .75,
    color: '#000000',
    fillOpacity: '1',
    fillColor: 'blue',
    background: 'blue'
  };
}

 function onEachETU(feature, layer, featureLayer) {
    // var lg = mapLayerGroups[feature.properties.Class];

    // if (lg === undefined) {
    //     lg = new L.layerGroup();
    //     //add the layer to the map
    //     lg.addTo(leafletMap);
    //     //store layer
    //     mapLayerGroups[feature.properties.Class] = lg;
    // }

    // lg.addLayer(featureLayer); 

    layer.bindPopup( 
      "<img src=" + feature.properties.Type + " width = '200px'/>" + "<br>" + 
       feature.properties.Beds_Plan 
          );
    layer.on({
    mouseover: highlightETU,
    mouseout: resetETU,
  });
}

function pointToLayer(feature, latlng) {
  return new L.CircleMarker(latlng,{
      radius: 4, 
      weight: 2, 
      color: 'red', 
      fillOpacity: 0
    });
    }

function ETUstyle(feature) {
  return {      
      radius: 1.5, 
      weight: 3.0, 
      color: getColor(feature.properties.Class), 
      fillOpacity: 0};
      }

function highlightETU(e) {
  var layer = e.target;

    layer.setStyle({
    radius: 7,
    weight: 2,
    color: getColor(feature.properties.Class),
    fillOpacity: .4,

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












 
