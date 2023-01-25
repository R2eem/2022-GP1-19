//Paste your Application Key and JavaScript Key, respectively
Parse.initialize("0RlD4YgWV75gUlCXVcHr33pzfYN3ilb1qrFWyUy5", "kJ7mcY3FfZ35jn4unoEATfZCbQQBVz3LvPJKTLCW");
Parse.serverURL = "https://parseapi.back4app.com/";

signUp();

function signUp() {
    // Create a new instance of the user class
    var user = new Parse.User();
    user.set("username", "Lama.a.baabdullah7@gmail.com");
    user.set("password", "Lamaabdullah05599@");
    user.set("email", "Lama.a.baabdullah7@gmail.com");
  
    // other fields can be set just like with Parse.Object
    //user.set("phone", "0559948146");
  
    user.signUp().then(function(user) {
        console.log('User created successful with name: ' + user.get("username") + ' and email: ' + user.get("email"));
    }).catch(function(error){
        console.log("Error: " + error.code + " " + error.message);
    });
}


