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

});
