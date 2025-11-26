let hscore=document.getElementById("home-score")
let gscore=document.getElementById("guest-score")
let thescore=0
let thescoreg=0
function plusone(){
    thescore+=1
    hscore.textContent=thescore
}
function plustwo(){
    thescore+=2
    hscore.textContent=thescore      
}
function plusthree(){
    thescore+=3
    hscore.textContent=thescore
}
function plusoneg(){
    thescoreg+=1
    gscore.textContent=thescoreg
}
function plustwog(){
    thescoreg+=2
    gscore.textContent=thescoreg
}   

function plusthreeg(){
    thescoreg+=3
    gscore.textContent=thescoreg
}