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
		$(this).parents('fieldset.row').children('.user-translation').removeClass('hide');
		e.preventDefault();
	});
	$('.show-translations').click(function(e) {
		$(this).parent().addClass('hide').siblings('.current-translations').removeClass('hide');
		$(this).parents('fieldset.row').children('.user-translation').addClass('hide');
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
	$('select,input').on('change', '.autosubmit', function(){
		$(this).parents('form').submit();
	});

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
		var checkmark = $(this)
		$.ajax({
			url: $(this).attr('href'),
			beforeSend: function(xhr) {				
				parent.append(
					'<img class="loading-image"' +
					'src="/static/images/ajax-loader.gif"/>');
			},
			success: function(data) {				
				parent.children('.loading-image').hide();
				parent.addClass('voted');
				vote_count.html(data.vote_count);				
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
