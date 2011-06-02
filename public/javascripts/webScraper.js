var present_slide=0;
var images = [];
objImage = new Image();
var call; 
var old_url = '';

var first=true;

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function(){
   
   $("#scraper_input_id").keyup(function(inputValue) {
		scrap_input = $("#scraper_input_id").val();
		
		if(scrap_input == old_url){ return; }
		old_url = scrap_input;
		
		$('#preview').hide('fast');
		
		//Hide the check box if the url is blank
		if(scrap_input != ''){ $("#check").show(); } else { $("#check").hide(); }
		
		//Make the check box red if there is an invalid url
		if(!isUrl(scrap_input)){
			$("img#check").attr('src','/images/redbutton-check48.png');
			$("#loader").hide('fast');
			return;
		} else {
			$("img#check").attr('src','/images/greenbutton-check48.png');
			$("#loader").show('fast');
		}
		
		if(!scrap_input.match(/^(http)/i)) {
			scrap_input = 'http://' + scrap_input;
		}
		
		$.post("/commentaries/get_link_info", "link_address=" + scrap_input, null, "script");
		
		//reset_link_input();
	 return false;
  })
})

function isUrl(s) {
	//var regexp = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
	var regexp = /(.com|.net|.org|.mobi|.info|.biz|.tel|.eu|.co.uk|.de|.us|.us.com|.tv|.pro|.asia)/
	return regexp.test(s);
}


function download(img_src){
// preload the image file
  objImage.src=images[img_src];
}

function displaynext(shift){
  present_slide=present_slide + shift;
  
  if(images.length > present_slide && present_slide >= 0){
    document.images['im'].src = images[present_slide];
    
    var next_slide=present_slide + 1;
    download(next_slide); // Download the next image 
  }
  
  if(present_slide+1 >= images.length ){
    $("#NextSlide").attr('disabled', 'disabled');
    present_slide=images.length-1;
  }else{$("#NextSlide").attr('disabled', '');}
  
  if(present_slide<=0 ){
    $("#PrevSlide").attr('disabled', 'disabled');
    present_slide=0;
  }else{
    $("#PrevSlide").attr('disabled', '');}
}

function reset_link_input(){
  images.length = 0;
  present_slide = 0;
  $('#preview').hide('fast');
  $('#scraper_input_id').val('');
  $('#im').attr('src', '');
  $('#site_title').html('');
  $('#site_link').html('');
  $('#site_desc').html('');
  $('#notes_textarea').val('');
  $("#check").fadeOut('fast');
  old_url = '';
}

function check_if_valid(){
	$.post("/commentaries/create", { "commentary" : {
	  "title": $('#site_title').html(),
	  "links": $('#site_link').html(),
	  "body": $('#site_desc').html(),
	  "image_url": $('#site_image').html() }
	}, null, "script");	
}