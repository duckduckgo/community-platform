$(document).ready(function() {

	$('#mail1').submit(function(e) {
		e.preventDefault();
		var data = $('#mail1').serialize();
		$.ajax({
			url:        '/campaign/respond',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$("#mailform"  + data.campaign_id).addClass("hide");
				$("#returndate").html(data.return_on);
				$("#thankyou1").removeClass("hide");
			},
			error:      function(data) {
				jsondata = jQuery.parseJSON( data.responseText );
				if (typeof jsondata.errstr == 'undefined') {
					$("#mailerr1").html('<i class="icn icon-warning-sign"></i>Sorry, an unknown error occurred. Please try again later.').addClass('notice');
				}
				else {
					$("#mailerr1").html('<i class="icn icon-warning-sign"></i>'+jsondata.errstr).addClass('notice');
				}
			},
		});
	});

	$('#mail2').submit(function(e) {
		e.preventDefault();
		var data = $('#mail2').serialize();
		$.ajax({
			url:        '/campaign/respond',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$("#mailform"  + data.campaign_id).addClass("hide");
				$("#couponcode").html(data.coupon);
				$("#thankyou2").removeClass("hide");
			},
			error:      function(data) {
				jsondata = jQuery.parseJSON( data.responseText );
				if (typeof jsondata.errstr == 'undefined') {
					$("#mailerr2").html('<i class="icn icon-warning-sign"></i>Sorry, an unknown error occurred. Please try again later.').addClass('notice');
				}
				else {
					$("#mailerr2").html('<i class="icn icon-warning-sign"></i>'+jsondata.errstr).addClass('notice');
				}
			},
		});
	});

});

