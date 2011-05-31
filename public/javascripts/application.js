// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	$('.questions').click(function() {
	  $(this).parent().nextAll('.answers').slideToggle('fast');	
	});
 });

function poll_vote(){
  $.post('/history/poll_taken', { "poll_id":  $('input[name=poll]:checked').val() }, function(response) {
  // your js code that inserts data into the page
  //$('div#poll_div').attr('disabled', true);
  var history_count = $('#history_count a').html();
	
  $('#history_count').html(parseInt(history_count) + 1);
  $('img#poll_check_box').attr('src','/images/checked.png');
  $('#ttp').addClass('finishedTodaysTasks');
  $('#poll_div').html("Thank you for taking today's poll");
 });
 
 return false;
 
}

function share(commentary_id, commentary_title, current_user_name, current_user_id, to_where){
	
	if(to_where == undefined || to_where == ""){
	 to_where = "facebook";
	}
	//var url = 'http://www.facebook.com/sharer.php?u=http://localhost:3000'
	var domain = 'http://' + document.domain;
	
	if(domain == "http://localhost"){ domain = "http://localhost:3000"; }
	
	if (to_where == "twitter"){
	  var url = "http://twitter.com/share?text=I am currently reading:&url=" + domain + "/shared_commentary/" + current_user_name + "/" + create_unique_id(commentary_id, current_user_id);
	} else {
	  var url = "http://www.facebook.com/sharer.php?u=" + domain + "/shared_commentary/" + current_user_name + "/" + create_unique_id(commentary_id, current_user_id) + "/" + commentary_title + "&t=" + commentary_title;
	}
	
	window.open(encodeURI(url));
	
	$.post('/commentaries/share_commentary', { "commentary_id": commentary_id }, function(response) {
	  // your js code that inserts data into the page
	 });
	 
	 return false;
}

function create_unique_id(commentary_id, current_user_id){	
	
  var version = '1';
  var com_id = Math.pow(2,commentary_id);
  var cu_id = Math.pow(3,current_user_id);
  var unique_id = 'v!!'+version+'$com!!'+com_id+'$cu!!'+cu_id
  
  return unique_id;
}

function clear_add_content(){
 $('#scraper_input_id').val('');	
 $('#site_title').html('');
 $('#site_link').html('');
 $('#site_desc').html('');
 $('#preview').hide('fast');
 
 $('#save_preview div.link_shareable').html('');
 $('#save_preview div.commentary_links_fp').html('');
 $('#save_preview div.fb_tw_fp').html('');
 $('#save_preview').hide('fast');
 
 $("img#check").hide();
}
