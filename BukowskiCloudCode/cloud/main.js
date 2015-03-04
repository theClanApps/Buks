
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
						  checkingEmployeeComments : undefined,
						  pendingUpdatesToUserDevice : false
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

Parse.Cloud.define("markBeerDrank", function(request, response) {
    var userQuery = new Parse.Query(Parse.User);	
	userQuery.get(request.params.userId, {
	  success: function(user) {
	  	var finished = user.get("finishedMugClub");
	  	var ranOutOfTime = user.get("ranOutOfTime");
		if(!finished && !ranOutOfTime) {
			var date = new Date();
			var startDate = user.get("mugClubStartDate");
			var timeLimit = 1000 * 60 * 60 * 24 * 7 * 2; // Two weeks in milliseconds  
		
			if(date - startDate > timeLimit) {
				console.log("You failed notification");
				saveUserRanOutOfTime(user, request, response);
			} else {
				console.log("trying to save beer");
				saveUserDrankBeer(request.params.beerId, request, response, user);
			}  
		}
	  }
	});
});

Parse.Cloud.job("checkIfAnyUserHasFinishedMugClub", function(request, status) {
  Parse.Cloud.useMasterKey();
  var counter = 0;
  var query = new Parse.Query(Parse.User);
  query.each(function(user) {
    var BeerObject = Parse.Object.extend("UserBeerObject");
	var query = new Parse.Query(BeerObject);
	query.equalTo("drinkingUser", user);
  
	query.count({
		success: function(allCount) {
			var BeerObject = Parse.Object.extend("UserBeerObject");
			var drankQuery = new Parse.Query(BeerObject);
			drankQuery.equalTo("drank", true);
            drankQuery.equalTo("drinkingUser", user);
						
			drankQuery.count({
			success: function(drankCount) {       
                var date = new Date();
                var startDate = user.get("mugClubStartDate");
                var timeLimit = 1000 * 60 * 60 * 24 * 7 * 2; // Two weeks in milliseconds  

				// If they are doing the mug club
                if(startDate) {
                	var ranOutOfTime = user.get("ranOutOfTime");
                    if(date - startDate > timeLimit && !ranOutOfTime) {
                    	user.save({
						ranOutOfTime: true,
					  }, {
						success: function(user) {
							console.log("you sent notification")
                        	sendPushNotificationForJob(0, user);
 						},
						error: function(user, error) {
							console.log("you failed to send notification");
						}
					  });
                    }
                    
                }
			}
			});
	}
    });
  });
});

function sendPushNotificationForJob(status, user) {
    
    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', user);
    
    var pushMessageString = "";
    if(status == 0) {
		pushMessageString = "You failed to finish the mug club!";
	} else if (status == 1) {
		pushMessageString = "You finished the mug club!";
	}
     
    Parse.Push.send({
        where: query,
        data: {
			alert: pushMessageString
        }
    }, {
        success: function() {
        },
        error: function(error) {
        }
    });
}

function sendPushNotification(status, request, response, user) {
                   
    var beerName = request.params.beerName;
    
    var userQuery = new Parse.Query(Parse.User);
    userQuery.equalTo('objectId', request.params.userId);
    
    var query = new Parse.Query(Parse.Installation);
    query.matchesQuery('user', userQuery);
    
    var pushMessageString = "";
    if(status == 0) {
		pushMessageString = "You failed to finish the mug club!";
	} else if (status == 1) {
		pushMessageString = "You finished the mug club!";
	} else {
		pushMessageString = "You drank " + beerName + "!";
	}
     
    Parse.Push.send({
        where: query,
        data: {
			alert: pushMessageString
        }
    }, {
        success: function() {            
            if(user) {
            console.log("user");
            var UserBeerObject = Parse.Object.extend("UserBeerObject");
            var beerQuery = new Parse.Query(UserBeerObject);
            beerQuery.equalTo("drinkingUser", user);
            beerQuery.count({
			  success: function(beerCount) {
				beerQuery.equalTo("drank", true);
				beerQuery.count({
				  success: function(drankCount) {
					saveUserFinishedMugClub(user, request, response);
				  }, error: function(error) {
				  	console.log(error);
				  } 
				});
			  }, error: function(error) {
				  	console.log(error);
				  }
			});
            }
        },
        error: function(error) {
            alert("Error: " + error.code + " " + error.message);
				response.error("failed");
        }
    });
}

function saveUserRanOutOfTime(user, request, response) {
    Parse.Cloud.useMasterKey();
	user.save({
		ranOutOfTime: true,
	  }, {
		success: function(user) {
			console.log("you sent failed to finish notification")
			sendPushNotification(0, request, response);
		},
		error: function(user, error) {
			console.log("you failed to send notification");
		}
	  });
}

function saveUserFinishedMugClub(user, request, response) {
    Parse.Cloud.useMasterKey();
	user.save({
		finishedMugClub: true,
	  }, {
		success: function(user) {
			console.log("you sent finished mug club notification")
			sendPushNotification(1, request, response);
		},
		error: function(user, error) {
			console.log("you failed to send notification");
		}
	  });
}

function saveUserDrankBeer(beerId, request, response, user) {
	var query = new Parse.Query("UserBeerObject");
	query.get(beerId, {
	  success: function(beer) {
		beer.save({
		drank: true,
		pendingUpdatesToUserDevice : true
	  }, {
		success: function(beer) {
			console.log("you sent drank beer notification");
			sendPushNotification(2, request, response, user);
		},
		error: function(beer, error) {
			console.log("you failed to send notification");
		}
	  });
	  },
	  error: function(object, error) {
		
	  }
	});
}


