
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("createUserBeerInCloud", function(request, response) {

	var BeerObject = Parse.Object.extend("BeerObject");
	var query = new Parse.Query(BeerObject);
	query.equalTo("isActive", true);
	query.find({
	  success: function(results) {
	  
		var query = new Parse.Query(Parse.User);
		query.equalTo("username", request.params.user);
		query.find({
		
			success: function(results2) {
				for (var i = 0; i < results.length; ++i) {        
						var UserBeerObject = Parse.Object.extend("UserBeerObject");
						var userBeerObject = new UserBeerObject();
 
						userBeerObject.save({
						  drinkingUser: results2[0],
						  drank: false,
						  beer : results[i],
						  dateDrank : undefined,
						  checkingEmployee : undefined,
						  checkingEmployeeComments : undefined
						}, {
						  success: function(userBeerObject) {
						  },
						  error: function(gameScore, error) {
							// The save failed.
						  }
						});
					}
					response.success("Success!!!");
					
			},
			error: function(error) {
				alert("Error: " + error.code + " " + error.message);
				response.error("failed");
			}
	  		});
	  	},
	  error: function(error) {
		alert("Error: " + error.code + " " + error.message);
		}
	});
});

