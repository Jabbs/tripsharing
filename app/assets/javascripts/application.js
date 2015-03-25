// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require placeholder
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require scrollReveal
//= require jquery.countdown
//= require_tree .


$('document').ready(function() {
	
	// http://parsleyjs.org/doc/index.html#validators
	// signup form
	$('#new_user_form').parsley();
	$('#edit_user_form').parsley();
	$('#edit_user_password_form').parsley();
	$('#pass_reset_email').parsley();
	$('#join_req_form').parsley();
	
	// https://bootstrap-datepicker.readthedocs.org/en/release/
	$('.datepicker').datepicker()
	
	$('.signuplink').click(function() {
		$("#survey_form").hide();
		$("#tagline").hide();
		$("#signup").fadeIn(400);
		$("#tagline2").empty();
		$("#tagline2").append("Signup to join a trip or start your own!");
		$("#tagline2").fadeIn(400);
	});
	$('.cancelsignuplink').click(function() {
		$("#survey_form").fadeIn(400);
		$("#tagline").fadeIn(400);
		$("#signup").hide();
		$("#tagline2").empty();
	});
	
	$('#myTab a').click(function (e) {
	  e.preventDefault();
	  $(this).tab('show');
	});
	
	$(".sidebar_list_item").click(function() {
		var url = $(this).find("a").attr('href');
		if (url) {window.location = url};
	});
	
	$("#passreset-link").click(function() {
		$("#login-modal-content").hide();
		$("#passreset-modal-content").fadeIn(400); 
	});      
	$("#login-link ").click(function() {
		$("#login-modal-content").show();
		$("#passreset-modal-content").hide(); 
	});                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	
	$('#go-to-top').click(function () {
	    $(window.opera ? 'html' : 'html, body').animate({
	        scrollTop: 0
	    }, 1000); // scroll takes 1 second
	});
	
	var page = document.getElementById('page-static_pages-home');
	if (page != null) {
		$(window).load(function(){
			function swapSpinner() {
				$('#spinner').hide();
			}	
			swapSpinner()
		});
	};
	
	// http://ubilabs.github.io/geocomplete/
	$(".add-geocomplete").geocomplete();
	
	window.scrollReveal = new scrollReveal();
});

