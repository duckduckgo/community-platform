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

});
