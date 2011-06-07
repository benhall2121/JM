// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}		
});

$(document).ready(function() {
	$('.questions').click(function() {
	  $(this).parent().nextAll('.answers').slideToggle('fast');	
	});
	
	$('.front_page_content a').live("click", function() {
	  $.getScript(this.href);
	  return false;
	});
	
	$('.boost_button_div a.boost_button').live("click", function(){
	  $.post(this.href, $(this).serialize(), null, "script");
	  return false;
	});
	
	$('.boost_button_div a.unboost_button').live("click", function(){
	  $.getScript(this.href);
	  return false;		
	});
	
	$('.delete_com').live("click", function(){
	  $.getScript(this.href);
	  return false;		
	});
	
	$("div.edit_fp_title").click(function() {
			
			//Create the HTML to insert into the div. Escape any " characters 
			var ahref = $(this).siblings('span.title').children('a').attr('href');
			var aText = $(this).siblings('span.title').children('a').text();
			var thisId = $(this).attr('id');
			var justId = thisId.substr(5);
			var inputbox = "<input type='text' class='inputbox text_field edit_fp_input' value=\""+ aText +"\">";
			
			//Insert the HTML into the div
			$(this).siblings('span.title').html(inputbox);
			$(this).siblings('div.delete_com_fp').hide();
			$(this).hide();
			//Immediately give the input box focus. The user
			//will be expecting to immediately type in the input box,
			//and we need to give them that ability
			$("input.inputbox").focus();
			
			//Once the input box loses focus, we need to replace the
			//input box with the current text inside of it.
			$("input.inputbox").blur(function() {
				var value = $(this).val();
				
				if (aText != value){
					$.post('/commentaries/update_fp', { "id": justId, "title": value }, function(response) {
				  // your js code that inserts data into the page
				 });
				}
				
				var newHtml = '<a href="' + ahref + '" class="c-links" target="blank">' + value + '</a>'
				$("#"+thisId).siblings('span.title').html(newHtml);
			        $("#"+thisId).siblings('div.delete_com_fp').show();
				$("#"+thisId).show();
			});
			return false;
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
	
	$.post('/commentaries/share_commentary', { "commentary_id": commentary_id, "where_to":to_where, "commentary_title": commentary_title }, null, "script");
	 
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
