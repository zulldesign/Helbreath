function UpdateTime(){
var d = new Date();

utc = d.getTime() + (d.getTimezoneOffset() * 60000);

nd = new Date(utc + (3600000*-5));

document.getElementById("Time").innerHTML = nd.toLocaleTimeString();

setTimeout("UpdateTime()",1000);
}

$(document).ready(function(){
   $('#gameplaymenu').hoverAccordion({
	keepHeight : false,
        onClickOnly : true
   }); 
});

(function(d, s, id) {
	var js, fjs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) return;
	js = d.createElement(s); js.id = id;
	js.src = "//connect.facebook.net/en_GB/all.js#xfbml=1";
	fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
	
function preload(images) {
    if (document.images) {
        var imageArray = images.split(',');
        var imageObj = new Image();
        for(var i = 0; i <= imageArray.length-1; i++) {
            imageObj.src = imageArray[i];
        }
    }
}