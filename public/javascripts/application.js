// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function poll_vote(){
 // $.post('/history/poll_taken', { "poll_id":  $('input[name=poll]:checked').val() }, function(response) {
  // your js code that inserts data into the page
  $('div#poll_div').attr('disabled', true);
  var history_count = $('#history_count').html();
	
  $('#history_count').html(parseInt(history_count) + 1);	
 //});
 
 return false;
 
}

function share(commentary_id){
	//var url = 'http://www.facebook.com/sharer.php?u=http://localhost:3000'
	var domain = document.domain;
	
	if(domain == "localhost"){ domain = "localhost:3000"; }
	
	var url = "http://www.facebook.com/sharer.php?u=http://" + domain + "/commentaries/" + commentary_id;
	window.open(url);
	
	$.post('/commentaries/share_commentary', { "commentary_id": commentary_id }, function(response) {
	  // your js code that inserts data into the page
	 });
	 
	 return false;
}
