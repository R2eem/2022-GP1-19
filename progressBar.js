// Initialize Parse
Parse.initialize("0RlD4YgWV75gUlCXVcHr33pzfYN3ilb1qrFWyUy5",
"kJ7mcY3FfZ35jn4unoEATfZCbQQBVz3LvPJKTLCW"); 
Parse.serverURL = "https://parseapi.back4app.com/";


//to reach the elements 
const progress_customer = document.querySelector(".progress-done-Cusotmer");
const progress_pharmacies = document.querySelector(".progress-done-pharmacies");
const progress_orders = document.querySelector(".progress-done-orders");        

let NumOfCustomers = 0;
let NumOfPharmacies = 0;
let NumOfOrders = 0;

//Total number of pharmacies
async function totalPharmacies(){
    NumOfPharmacies =0;
   const query = new Parse.Query("Pharmacist");

   const results = await query.find();
   for (let i = 0; i < results.length; i++) {
       var pharmacies = results[i];
       NumOfPharmacies = NumOfPharmacies+1;
   }
   document.getElementById('TotalPharmacies').innerHTML = NumOfPharmacies;
   changeWidth(progress_pharmacies,NumOfPharmacies);
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
   changeWidth(progress_customer,NumOfCustomers);
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
   changeWidth(progress_orders,NumOfOrders);
}

totalOrders();


//function to change the width of the progress bar 
function changeWidth(progress,count){
    progress.style.width=`${(count / 100) * 100}%`;
    progress.innerText=`${Math.ceil((count / 100) * 100)}%`;
}