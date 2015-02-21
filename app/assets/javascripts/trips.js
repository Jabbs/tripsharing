// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
	
$('document').ready(function() {
	$('#onboarding-hide-group-details').click(function() {
		$("#onboarding-group-details").hide();
		$("#onboarding-purpose").fadeIn(400);
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