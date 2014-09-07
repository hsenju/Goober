window.onload = function() {
  initParse();

  var baseLayer = L.tileLayer(
    'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
      maxZoom: 18
    }
  );

  var cfg = {
    // radius should be small ONLY if scaleRadius is true (or small radius is intended)
    "blur": 1,
    "radius": .007,
    "maxOpacity": .75,
    "minOpacity": 0,
    // scales the radius based on map zoom
    "scaleRadius": true,
    // if set to false the heatmap uses the global maximum for colorization
    // if activated: uses the data maximum within the current map boundaries
    //   (there will always be a red spot with useLocalExtremas true)
    "useLocalExtrema": true,
    // which field name in your data represents the latitude - default "lat"
    latField: 'lat',
    // which field name in your data represents the longitude - default "lng"
    lngField: 'lng',
    // which field name in your data represents the data value - default "value"
    // valueField: 'pop'
  };


  heatmapLayer = new HeatmapOverlay(cfg);

  map = new L.Map('map-canvas', {
    center: new L.LatLng(40.75, -73.87),
    zoom: 12,
    layers: [baseLayer, heatmapLayer]
  });

  var DELAY_MS = 5000;

  function updateWindow() {
    getParseData(function(query_results) {
      console.log("getParseData called");
      console.log("Query result len: " + query_results.length);
      var flattened = _.reduce(query_results,
                               function(left, right) {
                                 return left.concat(right);
                               });
      console.log("Flattened to length " + flattened.length);
      // var asHeatPoints = _.map(flattened, objsToHeatPoints);

      heatmapLayer.setData({
        max: 100,
        data: flattened
      });
    });
  };

  updateWindow();
  window.setInterval(updateWindow, DELAY_MS);
};