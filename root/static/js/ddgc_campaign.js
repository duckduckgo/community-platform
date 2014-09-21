$(document).ready(function() {
    var $headerlogin = $('.js-header-login'),
        $step1 = $("#loginprompt"),
        $login = $('#login-box'),
        $register = $('#register-box');

	$('#login').submit(function(e) {
		e.preventDefault();
		var data = $('#login').serialize();
		$.ajax({
			url:        '/share/login',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$login.trigger('reveal:close');
                $step1.addClass("hide");
                $headerlogin.addClass("hide");
                
				if (data.campaign_id > 0) {
					$("#mailform" + data.campaign_id).removeClass("hide");
				}
				else {
					$("#responded").removeClass("hide");
				}
			},
			error:      function(data) {
				console.log(data);
                $("#loginerr").text('<i class="icn icon-warning-sign"></i>'+data.responseJSON.errstr).addClass('notice');
			},
		});
	});

	$('#register').submit(function(e) {
		e.preventDefault();
		var data = $('#register').serialize();
		$.ajax({
			url:        '/share/register',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$register.trigger('reveal:close');
				$step1.addClass("hide");
                $headerlogin.addClass("hide");
                $("#mailform1").removeClass("hide");
			},
			error:      function(data) {
				$("#registererr").text('<i class="icn icon-warning-sign"></i>'+data.responseJSON.errstr).addClass('notice');
			},
		});
	});

	$('#mail1').submit(function(e) {
		e.preventDefault();
		var data = $('#mail1').serialize();
		$.ajax({
			url:        '/share/respond',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$("#mailform"  + data.campaign_id).addClass("hide");
				$("#returndate").html(data.return_on);
				$("#thankyou1").removeClass("hide");
			},
			error:      function(data) {
				$("#mailerr1").text('<i class="icn icon-warning-sign"></i>'+data.responseJSON.errstr).addClass('notice');
			},
		});
	});

	$('#mail2').submit(function(e) {
		e.preventDefault();
		var data = $('#mail2').serialize();
		$.ajax({
			url:        '/share/respond',
			data:       data,
			type:       'POST',
			success:    function(data) {
				$("#mailform"  + data.campaign_id).addClass("hide");
				$("#couponcode").html(data.coupon);
				$("#thankyou2").removeClass("hide");
			},
			error:      function(data) {
				$("#mailerr2").text('<i class="icn icon-warning-sign"></i>'+data.responseJSON.errstr).addClass('notice');
			},
		});
	});

});

