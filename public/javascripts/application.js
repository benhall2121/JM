// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function poll_vote(){
  $.post('/history/poll_taken', { "poll_id":  $('input[name=poll]:checked').val() }, function(response) {
  // your js code that inserts data into the page
  //$('div#poll_div').attr('disabled', true);
  var history_count = $('#history_count').html();
	
  $('#history_count').html(parseInt(history_count) + 1);
  $('#ttp').addClass('finishedTodaysTasks');
  $('#poll_div').html("Thank you for taking today's poll");
 });
 
 return false;
 
}

function share(commentary_id, commentary_title, current_user_name, current_user_id){
	
	//var url = 'http://www.facebook.com/sharer.php?u=http://localhost:3000'
	var domain = document.domain;
	
	if(domain == "localhost"){ domain = "localhost:3000"; }
	
	var url = "http://www.facebook.com/sharer.php?u=http://" + domain + "/shared_commentary/" + current_user_name + "/" + commentary_title + '/' + create_unique_id(commentary_id, current_user_id);
	
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
  var unique_id = 'v='+version+'&com='+com_id+'&cu='+cu_id
  
  return unique_id;
}
