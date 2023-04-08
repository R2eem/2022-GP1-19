const sidemenu = document.querySelector("aside");
const menuBtn = document.querySelector("#menu-btn");
const closeBtn = document.querySelector("#close-btn");


function menuFunction() {
    sidemenu.style.display='block';
  }

closeBtn.addEventListener('click',()=>{
    sidemenu.style.display='none';
})
