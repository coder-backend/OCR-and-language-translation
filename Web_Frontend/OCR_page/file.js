var loader=function(e){
	let file=e.target.files;
	let show="<span>Selected file:</span>"+file[0].name;
	let output=document.getElementById("selector");
	output.innerHTML=show;
	output.classList.add("active");
};
let fileInput=document.getElementById("file");
fileInput.addEventListener("change",loader);
function nextpage(){
window.location.replace("D:/Web_Testing/My_Way/Navigation_and_Homepage/Nav.html");
}