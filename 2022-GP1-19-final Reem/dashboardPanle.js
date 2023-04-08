// Initialize Parse
Parse.initialize("0RlD4YgWV75gUlCXVcHr33pzfYN3ilb1qrFWyUy5",
"kJ7mcY3FfZ35jn4unoEATfZCbQQBVz3LvPJKTLCW"); 
Parse.serverURL = "https://parseapi.back4app.com/";
       

let NumOfCustomers = 0;
let NumOfPharmacies = 0;
let NumOfOrders = 0;
let NumOfJoinReq=0

//Total number of pharmacies
async function totalPharmacies(){
    NumOfPharmacies =0;
   const query = new Parse.Query("Pharmacist");
   query.equalTo("JoinRequest","accepted");
   const results = await query.find();
   for (let i = 0; i < results.length; i++) {
       var pharmacies = results[i];
       NumOfPharmacies = NumOfPharmacies+1;
   }
   document.getElementById('TotalPharmacies').innerHTML = NumOfPharmacies;

}

totalPharmacies();

//Total number of customers
async function totalCustomers(){
    NumOfCustomers =0;
   const query = new Parse.Query("Customer");

   const results = await query.find();
   for (let i = 0; i < results.length; i++) {
       var customers = results[i];
       NumOfCustomers = NumOfCustomers+1;
   }
   document.getElementById('TotalCustomers').innerHTML = NumOfCustomers;
 
}
totalCustomers();


//Total number of orders
async function totalOrders(){
   var NumOfOrders =0;
   const query = new Parse.Query("Orders");

   const results = await query.find();
   for (let i = 0; i < results.length; i++) {
       var orders = results[i];
       NumOfOrders = NumOfOrders+1;
   }
   document.getElementById('TotalOrders').innerHTML = NumOfOrders;

}

totalOrders();

//Total number of pharmacies join request
async function totalPharmaciesJoinReq(){
    NumOfJoinReq =0;
   const query = new Parse.Query("Pharmacist");
   query.equalTo("JoinRequest","Under processing");
   const results = await query.find();
   for (let i = 0; i < results.length; i++) {
       var pharmacies = results[i];
       NumOfJoinReq = NumOfJoinReq+1;
   }
   document.getElementById('NumOfJoinReq').innerHTML = NumOfJoinReq;
}

totalPharmaciesJoinReq();