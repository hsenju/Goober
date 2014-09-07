Parse.initialize("GVHlANVgkCCANB6RdW8InlAMtU6FqG86EZC6gxel", "tZr9rIEilQDb6od8Lyr8lYjqahRqhFZoC9114P68");
var Venue = Parse.Object.extend("Venue");
var query = new Parse.Query(Venue);

var res = [];
for (i = 0; i < 5; i++) {
  query.skip(i * 100);
  query.find({
    success: function(ans) {
      console.log("Success!!");
      res = res.concat(ans);
      console.log("Got res len: " + res.length);
    },
    error: function(ans) {
      console.log("Something went wrong.");
    }
  })
}
