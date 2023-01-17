const sideMenu = document.querySelector("aside");
const menuBtn = document.querySelector("#menu-btn");
const closeBtn = document.querySelector("#close-btn")
const themeToggler = document.querySelector(".theme-toggler");

//Show sidbar
menuBtn.addEventListener('click',() =>{
    sideMenu.style.display='block';
})

//close sidbar
closeBtn.addEventListener('click',() =>{
    sideMenu.style.display='none';
})

//change theme 
themeToggler.addEventListener('click',() =>{
    document.body.classList.toggle('dark-theme-variables');

    themeToggler.querySelector('i:nth-child(1)').classList.toggle('active');
    themeToggler.querySelector('i:nth-child(2)').classList.toggle('active');



})



