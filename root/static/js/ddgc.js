$(document).ready(function() {
	$('.no-js').addClass('js').removeClass('no-js');
	
	$('.js-remove').remove();
	
	$('.comment.tier1-new .comment_reply, .thread-wrap .comment_reply').removeClass('js-hide');
    $('.thread-wrap .comment_reply').toggleClass('hide');
	
	$('.text').addPlaceholder(); 
	$('.token-input').addPlaceholder();
	$('.token-input').change(function(){
		$('.token-submit').removeClass('js-hide');
	});
	
	$('.js-bbcode').bbcode();
	
	$('select.language_grade, select.language_select, select.js-select').select2({
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
		if ($(target).hasClass('is-open')) {
			target.addClass('is-closed').removeClass('is-open');		
		}
		else {
			if ($(this).hasClass('is-exclusive')) {
				$(this).parent().parent().find('.is-open')
				  .addClass('is-closed').removeClass('is-open');
			}
			target.toggleClass('is-closed').toggleClass('is-open');	
		}
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

	$('a.vote_link, .js-vote-link').click(function(e){
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

/* TODO - these next four are way too similar - they should be abstracted to a function/plugin */
    
    $('.js-thread-reply').click(function(e){
        e.preventDefault();
        $(this).siblings('.js-thread-cancel').toggleClass('hide');
        $(this).parents('.thread').parent().children('.comment_reply').removeClass('hide');
		$(this).toggleClass('hide');
    });
    
    $('.js-thread-cancel').click(function(e){
        e.preventDefault();
		$(this).siblings('.js-thread-reply').toggleClass('hide');
		$(this).parents('.thread').parent().children('.comment_reply').addClass('hide');
		$(this).toggleClass('hide');
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
	
	/*
	 * BBCode Insertion Plugin
	 */	
	function insertbb(start, end, element) {		
		var elementvalue = element.val();		
		if (document.selection) {		   
		   element.focus();
		   sel = document.selection.createRange();
		   sel.text = start + sel.text + end;
		} else if (element[0].selectionStart || element[0].selectionStart == '0') {		  
		   element.focus();
		   var startPos = element[0].selectionStart;
		   var endPos = element[0].selectionEnd;
		   elementvalue = elementvalue.substring(0, startPos) + start + elementvalue.substring(startPos, endPos) + end + elementvalue.substring(endPos, elementvalue.length);		   
		} else {		  
		  elementvalue += start + end;	
		}		
		element.val(elementvalue);
		element.focus();
	}
	 
	$('*[data-bbcode]').click(function(e) {
		e.preventDefault();
		var target = $(this).parent().parent().find('textarea');
		var tagtype = $(this).attr("data-bbcode");
		var start = '['+tagtype+']';
		var end = '[/'+tagtype+']';

		var param="";
		if (tagtype=='img')
		{
		 param=prompt("Enter image URL","http://");
		 if (param)
			start+=param;
		 }
		else if (tagtype=='url')
		{
			param=prompt("Enter URL","http://");
			if (param) 
				start = '[url href=' + param + ']';
		 }
		insertbb(start, end, target);
	});
	 
	// hotkeys 
	
	$('.has-bbcode').keyup(function (e){ if(e.which == 17) isCtrl=false; }).keydown(function (e) { 
		if(e.which == 17) isCtrl=true; 
		if (e.which == 66 && isCtrl == true) { 
			// CTRL + B, bold			
			insertbb("[b]","[/b]",$(this));
			return false;
		} 
		else if (e.which == 73 && isCtrl == true) { 
			// CTRL + I, italic			
			insertbb("[i]","[/i]",$(this));
			return false;
		} 
		else if (e.which == 85 && isCtrl == true) { 
			// CTRL + U, underline			
			insertbb("[u]","[/u]",$(this));
			return false;
		}
	});
	

	/*
	 * Modified jQuery Reveal Plugin
	 * Changted from ZURB's original code to use fixed positioning and the newer 'click' function as the trigger
	*/
	(function($) {
	/* Listener for data-reveal-id attributes */
		$('.js-reveal, a[data-reveal-id]').on('click', function(e) {		
			e.preventDefault();
			console.log('hi');
			if ($(this).attr('data-reveal-id')){
				var modalLocation = $(this).attr('data-reveal-id');
				$('#'+modalLocation).reveal($(this).data());
			}
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
 
});
	
(function($){
	$.fn.bbcode = function(options){
		// default settings
		var options = $.extend({
		  tag_bold: true,
		  tag_italic: true,
		  tag_underline: true,
		  tag_link: true,
		  tag_image: true,
		  tag_code: true,
		  button_icon: true
		},options||{});
		//  panel 
		var text = '<div class="comment-controls  button-group">'
		if(options.tag_bold){
		  text = text + '<button class="button" title="Bold Text (Ctrl+B)" data-bbcode="b">';
		  if(options.button_icon){
			text = text + '<i class="icon-bold"></i>';
		  }else{
			text = text + 'Bold';
		  }
		  text = text + '</button>';
		}
		if(options.tag_italic){
		  text = text + '<button class="button" title="Italic Text (Ctrl+I)" data-bbcode="i">';
		  if(options.button_icon){
			text = text + '<i class="icon-italic"></i>';
		  }else{
			text = text + 'Italic';
		  }
		  text = text + '</button>';
		}
		if(options.tag_underline){
		  text = text + '<button class="button" title="Underline Text (Ctrl+U)" data-bbcode="u">';
		  if(options.button_icon){
			text = text + '<i class="icon-underline"></i>';
		  }else{
			text = text + 'Undescore';
		  }
		  text = text + '</button>';
		}
		if(options.tag_image){
		  text = text + '<button class="button" title="Add an Image" data-bbcode="img">';
		  if(options.button_icon){
			text = text + '<i class="icon-picture"></i>';
		  }else{
			text = text + 'Image';
		  }
		  text = text + '</button>';
		}
		if(options.tag_link){
		  text = text + '<button class="button" title="Add a Link" data-bbcode="url">';
		  if(options.button_icon){
			text = text + '<i class="icon-link"></i>';
		  }else{
			text = text + 'Link';
		  }
		  text = text + '</button>';
		}
		if(options.tag_code){
		  text = text + '<button class="button" title="Add Example Code (Ctrl+ALT+DEL) --haha just hidding" data-bbcode="code">';
		  if(options.button_icon){
			text = text + '<i class="icon-code"></i>';
		  }else{
			text = text + 'Code';
		  }
		  text = text + '</button>';
		}
		text = text + '</div>';
		
		$(this).addClass('has-bbcode');
		$(this).after(text);
	}
})(jQuery);

/* random functions gogo */

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