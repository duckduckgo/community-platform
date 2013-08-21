$(document).ready(function() {
	$('.no-js').addClass('js').removeClass('no-js');
	
	$('.js-remove').remove();
	
	$('.comment_add_title + .comment_reply').removeClass('js-hide');
	
	$('.text').addPlaceholder(); 
	$('.token-input').addPlaceholder();
	
	$('select.language_grade').select2({
		placeholder: $(this).data('placeholder')
	});
	$('select.language_select').select2({
		placeholder: $(this).data('placeholder')
	});
	$('.paging-menu select').select2({
		minimumResultsForSearch: 99
	});
	
	$('.hide-translations').click(function(e) {
		$(this).parent().addClass('hide').siblings('.current-translations-min').removeClass('hide');		
		e.preventDefault();
	});
	$('.add-translations').click(function(e) {
		$(this).parent().addClass('hide').siblings('.current-translations-min').removeClass('hide');
		$(this).parents('fieldset.row').children('.user-translation').removeClass('js-hide');
		$('.token-submit').removeClass('js-hide');
		e.preventDefault();
	});
	$('.show-translations').click(function(e) {
		$(this).parent().addClass('hide').siblings('.current-translations').removeClass('hide');
		$(this).parents('fieldset.row').children('.user-translation').addClass('js-hide');
		$('.token-submit').addClass('js-hide');
		e.preventDefault();
	});
	// Nested Comment toggle
	$('.comment-toggle').click(function(e) {
		$(this).closest('.comment').toggleClass("min").toggleClass("max");
		e.preventDefault();
	});
	
	// All external links in new window
	$("a[href^='http']").each(function(){
		if(this.href.indexOf(location.hostname) == -1) {
			$(this).attr('target', '_blank');
		}
	});

	// general autosubmit class
	$('.autosubmit').change(function(){
		$(this).parents('form').submit();
	});

	
	$('.js-toggle-sibling').click(function(e){
		e.preventDefault();
		var target = $(this).parent().find('.is-closed, .is-open');
		target.toggleClass('is-closed').toggleClass('is-open');		
	});

	$('.content-box-toggleclick').each(function(){
		var cb = $(this).toggleClass('is-closed');		
		var body = $(this).children('.body').hide();
		
		$(this).children('.head').click(function(){
			if (cb.hasClass('only')) {
				$('.content-box-toggleclick').each(function(){
					if (!$(this).is(cb)) {
						$(this).removeClass('is-open').addClass('is-closed')
						$(this).children('.body').hide('fast');
					}
				});
			}
			body.toggle('fast');
			cb.toggleClass('is-closed');
			cb.toggleClass('is-open');
		});
	});
	
	$('.content-box-click').addClass('is-open').toggleClass('is-closed');
	$('.content-box-click').children('.body').toggle();

	//
	// Feedback page
	//
	$('.js-fb-step--deactivate').parent().removeClass('fb-step--active');
		
	// input binding
	$('.js-fb-step').on("change, click", function () {
		$(this).find('.js-fb-step__input').focus();
	});
	$('.js-fb-step__input').change(function () {
		var str = "";
		str = $(this).val();		
		$(this).parents('.js-fb-step').find('.js-fb-step__output').html(str);
	});
	$('.js-fb-step__input').blur(function() {	
		if ($(this).val() != '') {
			var parent = $(this).parents('.js-fb-step');
			parent.removeClass('fb-step--active');
			parent.removeClass('fb-step--error');
			parent.find('.js-fb-step__toggle').toggleClass('fb-step__toggle--hide');			
			parent.find('.js-fb-step__arrow').toggleClass('ddgi-arrow-left').toggleClass('ddgi-arrow-up');
			parent.bind('click', function() {
				var my = $(this);
				feedback_edit_toggle(my);
			});
		}
	});
	$('.js-fb-step--toggle').click(function() {	
		var my = $(this);
		feedback_edit_toggle(my);
	});
	
	function feedback_edit_toggle(my) {	
		my.not('.fb-step--optional').addClass('fb-step--active');
		my.find('.js-fb-step__toggle').toggleClass('fb-step__toggle--hide');
		my.find('.js-fb-step__input').focus();
		my.find('.js-fb-step__arrow').toggleClass('ddgi-arrow-left').toggleClass('ddgi-arrow-up');	
		my.unbind('click');		
	}
	
	//
	// account page
	//

	// TODO make this a real widget and being part of the HTML code, there cant be text in the JavaScript lib
	/*
	$('a.removeLanguage').click(function() {
		return confirm("Are you sure you want to remove this language?");
	});
	// this is depreciated, and can now be done with a modal box
	*/
	// Gravatar
	$('div#set_gravatar_email').hide();
	$('a#add_gravatar_email').click(function() {
		$('div#set_gravatar_email').show();
	});

	$('a.vote_link').click(function(e){
		e.preventDefault();
		var vote_count = $(this).siblings().first();
		var parent = $(this).parent();
		var checkmark = $(this);
		$.ajax({
			url: $(this).attr('href'),
			beforeSend: function(xhr) {				
				parent.append(
					'<img class="loading-image"' +
					'src="/static/images/ajax-loader.gif"/>');
			},
			success: function(data) {				
				parent.children('.loading-image').hide();
				parent.toggleClass('voted');
				checkmark.children(":first").toggleClass('checked');
				if (checkmark.attr('href').match(/1$/))
					checkmark.attr('href', checkmark.attr('href').replace(/1$/, '0'));
				else if (checkmark.attr('href').match(/0$/))
					checkmark.attr('href', checkmark.attr('href').replace(/0$/, '1'));
				vote_count.html(data.vote_count);				
			}
		});
	});

	$('a.finishwizard').click(function(e){
		e.preventDefault();
		var me = $(this);
		$.ajax({
			url: me.attr('href'),
			beforeSend: function(xhr) {				
				me.replaceWith(
					'<img class="loading-image"' +
					'src="/static/images/ajax-loader.gif"/>'
				);
			},
			success: function(data) {
				$('#wizard_running_info').remove();
			}
		});
	});

	$('a.checkfalse_link').click(function(e){
		e.preventDefault();
		var parent = $(this).parent();
		$.ajax({
			url: $(this).attr('href'),
			beforeSend: function(xhr) {				
				parent.html(
					'<img class="loading-image"' +
					'src="/static/images/ajax-loader.gif"/>');
			},
			success: function(data) {				
				var text = data.check_result
					? 'VALID'
					: 'INVALID';
				parent.html('<div class="button">'+text+'</div>');
			}
		});
	});


	$('a.comment_reply_link').click(function(e){
		e.preventDefault();
		$(this).next('.comment_reply_cancel_link').fadeIn();
		$(this).parents().children('.comment-body .comment_reply').addClass('hide').removeClass('js-hide').fadeIn();
		$(this).hide();
	});

	$('a.comment_reply_cancel_link').click(function(e){
		e.preventDefault();
		$(this).prev('.comment_reply_link').fadeIn();
		$(this).parents().children('.comment-body .comment_reply').fadeOut();
		$(this).hide();
	});

	$('a.comment_expand_link').click(function(e){
		e.preventDefault();
		$(this).parent().html($(this).next('.comment_expanded_content').html());
	});


	$('div').on('click', '.notice .close', function (e){		
		$(this).parent().fadeOut();
	});

	if (typeof(userHasLanguages) != "undefined") {
		if (userHasLanguages) {
			$('#btnAddNewLanguage').show();
			$('#formAddUserLanguage').hide();
			$('table.account-table [id^=update_]').hide();
		}
	}

	$('table.account-table').each(function() {
		$(this).on('change', 'select', function(){
			grade = $('option:selected',this).val();
			language = $(this).attr('id').substring(6);
			href = '?add_user_language=' + language;
			href += '&grade=' + grade;
			$("#update_"+language).fadeIn();
			$("#update_"+language).attr('href', href);
		});
	});

	if(typeof(breadcrumb_right) != "undefined") {
		if (breadcrumb_right == 'language') {
			$('#languageBox').hide();
		}
	}
});

function showFormAddUserLanguage() {
	$('#formAddUserLanguage').fadeIn();
	$('#btnAddNewLanguage').fadeOut();
}

function validateFormAddUserLanguage() {
	selectedLanguage=$('#language_id :selected').text().substring(16,21);
	if ($.inArray(selectedLanguage, userLanguages) != -1) {
		return false;
	}
	return true;
}

function validateFormGravatar() {
	if ($('#gravatar_email').val() == '') {
		$('#error_gravatar_invalid_email').fadeIn();
		return false;
	}
	return true;
}

function validateFormLogin() {
	//console.log($('#username'));
	if ($('#username').val() === '' || $('#password').val() === '') {
		$('#invalidForm').fadeIn();
		return false;
	}
	return true;
}

function showLanguageBox() {
	if($('#languageBox').css('display') == 'none') {
		$('#languageBox').slideDown();
		$('#btnChooseLanguage').html('&#9650;');
	} else {
		$('#languageBox').slideUp();
		$('#btnChooseLanguage').html('&#9660;');
	}
	return false;
}

/*
 * Modified jQuery Reveal Plugin
 * Changted from ZURB's original code to use fixed positioning and the newer 'click' function as the trigger
*/

(function($) {
/* Listener for data-reveal-id attributes */
	$('a[data-reveal-id]').click(function(e) {
		e.preventDefault();
		var modalLocation = $(this).attr('data-reveal-id');
		$('#'+modalLocation).reveal($(this).data());
	});
/* Extend and Execute */
    $.fn.reveal = function(options) {      
        
        var defaults = {  
	    	animation: 'fadeAndPop', //fade, fadeAndPop, none
		    animationspeed: 300, //how fast animtions are
		    closeonbackgroundclick: true, //if you click background will modal close?
		    dismissmodalclass: 'close-modal' //the class of a button or element that will close an open modal
    	}; 
    	
        //Extend dem' options
        var options = $.extend({}, defaults, options); 
	
        return this.each(function() {        
/* Global Variables */
        	var modal = $(this),
        		topMeasure  = parseInt(modal.css('top')),
				topOffset = modal.height() + topMeasure,
          		locked = false,
				modalBG = $('.reveal-modal-bg');
/* Create Modal BG */
			if(modalBG.length == 0) {
				modalBG = $('<div class="reveal-modal-bg" />').insertAfter(modal);
			}     
/* Open & Close Animations */
			//Entrance Animations
			modal.bind('reveal:open', function () {
			  modalBG.unbind('click.modalEvent');
				$('.' + options.dismissmodalclass).unbind('click.modalEvent');
				if(!locked) {
					lockModal();
					if(options.animation == "fadeAndPop") {
						modal.css({'opacity' : 0, 'visibility' : 'visible'});
						modalBG.fadeIn(options.animationspeed/2);
						modal.delay(options.animationspeed/2).animate({
							"top": '20%',
							"opacity" : 1
						}, options.animationspeed,unlockModal());					
					}
					if(options.animation == "fade") {
						modal.css({'opacity' : 0, 'visibility' : 'visible'});
						modalBG.fadeIn(options.animationspeed/2);
						modal.delay(options.animationspeed/2).animate({
							"opacity" : 1
						}, options.animationspeed,unlockModal());					
					} 
					if(options.animation == "none") {
						modal.css({'visibility' : 'visible'});
						modalBG.css({"display":"block"});	
						unlockModal()				
					}
				}
				modal.unbind('reveal:open');
			}); 	
			//Closing Animation
			modal.bind('reveal:close', function () {
			  if(!locked) {
					lockModal();
					if(options.animation == "fadeAndPop") {
						modalBG.delay(options.animationspeed).fadeOut(options.animationspeed);
						modal.animate({
							"top":  '-1000px',
							"opacity" : 0
						}, options.animationspeed/2, function() {
							modal.css({'top':topMeasure, 'opacity' : 1, 'visibility' : 'hidden'});
							unlockModal();
						});					
					}  	
					if(options.animation == "fade") {
						modalBG.delay(options.animationspeed).fadeOut(options.animationspeed);
						modal.animate({
							"opacity" : 0
						}, options.animationspeed, function() {
							modal.css({'opacity' : 1, 'visibility' : 'hidden', 'top' : topMeasure});
							unlockModal();
						});					
					}  	
					if(options.animation == "none") {
						modal.css({'visibility' : 'hidden', 'top' : topMeasure});
						modalBG.css({'display' : 'none'});	
					}		
				}
				modal.unbind('reveal:close');
			});        	
/* Open and add Closing Listeners */
        	//Open Modal Immediately
			modal.trigger('reveal:open')
			
			//Close Modal Listeners
			var closeButton = $('.' + options.dismissmodalclass).bind('click.modalEvent', function () {
			  modal.trigger('reveal:close')
			});
			
			if(options.closeonbackgroundclick) {
				modalBG.css({"cursor":"pointer"})
				modalBG.bind('click.modalEvent', function () {
				  modal.trigger('reveal:close')
				});
			}
			$('body').keyup(function(e) {
        		if(e.which===27){ modal.trigger('reveal:close'); } // 27 is the keycode for the Escape key
			});
/* Animations Locks */
			function unlockModal() { 
				locked = false;
			}
			function lockModal() {
				locked = true;
			}	
			
        });//each call
    }
})(jQuery);
        
