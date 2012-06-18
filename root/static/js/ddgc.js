$(function() {

	// All external links in new window
	$("a[href^='http']").each(function(){
		if(this.href.indexOf(location.hostname) == -1) {
			$(this).attr('target', '_blank');
		}
	});

	$('#userbox_content').hide();
	$('#languagebox_content').hide();
	
	$('#userbox').hover(function(){
		$('#userbox_content').show('fast');
	},function(){
		$('#userbox_content').hide('fast');
	});

	$('#languagebox').hover(function(){
		$('#languagebox_content').show('fast');
	},function(){
		$('#languagebox_content').hide('fast');
	});

	$('select.autosubmit,input.autosubmit').change(function(){
		$(this).parents('form').submit();
	});

	$('a.vote_link').live('click',function(e){
		e.preventDefault();
		var parent = $(this).parent();
		$.ajax({
			url: $(this).attr('href'),
			beforeSend: function(xhr) {
				parent.html('<img src="/static/images/ajax-loader.gif"/>');
			},
			success: function(data) {
				parent.html(data);
			}
		});
	});

        $('a.comment_reply_link').live('click', function(e){
                e.preventDefault();
                $(this).next('.comment_reply_cancel_link').fadeIn();
                $(this).parent().parent().children('.comment_reply').fadeIn();
                $(this).hide();
        });

        $('a.comment_reply_cancel_link').live('click', function(e){
                e.preventDefault();
                $(this).prev('.comment_reply_link').fadeIn();
                $(this).parent().parent().children('.comment_reply').fadeOut();
                $(this).hide();
        });
        
        $('a.comment_expand_link').live('click', function(e){
                e.preventDefault();
                $(this).parent().html($(this).next('.comment_expanded_content').html());
        });




});
