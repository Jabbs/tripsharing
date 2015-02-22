// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
	
$('document').ready(function() {
	
	function hideOnbardingPartials() {
		$("#onboarding-who").hide();
		$("#onboarding-when").hide();
		$("#onboarding-stops").hide();
		$("#onboarding-purpose").hide();
		$("#onboarding-profile").hide();
		$(".trip-category").removeClass("active");
	};
	var fadeInSpeed = 400;
	$('.onboarding-goto-who').click(function() { hideOnbardingPartials(); $(".travel-companions").addClass("active"); $("#onboarding-who").fadeIn(fadeInSpeed); });
	$('.onboarding-goto-when').click(function() { hideOnbardingPartials(); $(".travel-details").addClass("active"); $("#onboarding-when").fadeIn(fadeInSpeed); });
	$('.onboarding-goto-stops').click(function() { hideOnbardingPartials(); $(".travel-details").addClass("active"); $("#onboarding-stops").fadeIn(fadeInSpeed); });
	$('.onboarding-goto-purpose').click(function() { hideOnbardingPartials(); $(".travel-details").addClass("active"); $("#onboarding-purpose").fadeIn(fadeInSpeed); });
	$('.onboarding-goto-profile').click(function() { hideOnbardingPartials(); $(".about-you").addClass("active"); $("#onboarding-profile").fadeIn(fadeInSpeed); });

	$(".form-fancy").on("keypress", function (e) {
	    if (e.keyCode == 13) {
	        return false;
	    }
	});

});

// 
// jQuery ->
//   $('form').on 'click', '.remove_fields', (event) ->
//     $(this).prev('input[type=hidden]').val('1')
//     $(this).closest('fieldset').hide()
//     $('.add_fields').show()
//     event.preventDefault()
//     
//   $('form').on 'click', '.add_fields', (event) ->
//     time = new Date().getTime()
//     regexp = new RegExp($(this).data('id'), 'g')
//     $(this).before($(this).data('fields').replace(regexp, time))
//     $(this).hide()
//     event.preventDefault()