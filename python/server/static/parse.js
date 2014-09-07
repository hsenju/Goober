function initParse() {

  Parse.initialize("GVHlANVgkCCANB6RdW8InlAMtU6FqG86EZC6gxel", "tZr9rIEilQDb6od8Lyr8lYjqahRqhFZoC9114P68");
}

function objToHeatPoint(obj) {
  console.log("obj = " + JSON.stringify(obj));
  console.log("loc = " + obj.get('location'));;
  console.log("pop = " + obj.get('pop'));
  var loc = obj.get('location');
  return {lat: loc.latitude,
          lng: loc.longitude,
          value: obj.get('pop')};
}

function getParseData(callback) {
  var Venue = Parse.Object.extend("Venue");
  var query = new Parse.Query(Venue);

  var res = [];

  var promises = _.map(_.range(5), function(i) {
                   query.skip(i * 100);
                   return query.find().then(
                     function(ans) {
                       console.log("Success!!");
                       console.log("Got ans len: " + ans.length);
                       return _.map(ans, objToHeatPoint);
                     });
                 });
  console.log("About to pass callback");
  Promise.all(promises).then(function(res) {
    console.log("Got res len " + res.length);
    callback(res);
  })
}
