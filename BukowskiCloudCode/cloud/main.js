
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {

var BeerObject = Parse.Object.extend("BeerObject");

var beerObject = new BeerObject();
beerObject.set("beerName", "stupidGoodBeer");
beerObject.save(null, {
  success: function(beerObject) {
    // Execute any logic that should take place after the object is saved.
    alert('New object created with objectId: ' + beerObject.id);
  },
  error: function(beerObject, error) {
    // Execute any logic that should take place if the save fails.
    // error is a Parse.Error with an error code and message.
    alert('Failed to create new object, with error code: ' + error.message);
  }
});

  response.success("Hello world!");
});
