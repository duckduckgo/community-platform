(function(env) {

    DDH.IAPageNew = function() {
        this.init();
    };

    DDH.IAPageNew.prototype = {

        init: function() {
            // console.log("IAPageNew init()");
            var page_new = this;
            var username = $(".user-name").text();
                
            // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
            $(".breadcrumb-nav").remove();

             $("body").on("click", "#create-ia-from-pr", function(evt) {
                $("#create-ia-from-pr").addClass("hide");
                $("#create-ia-from-pr-form, #create-ia-from-pr-bg").removeClass("hide");
            });

            $("body").on('click', "#create-ia-from-pr-cancel", function(evt) {
                var $modal = $("#create-ia-from-pr-form");
                $modal.addClass("hide");
                $("#create-ia-from-pr-bg").addClass("hide");
                $modal.find("input, textarea").val("").removeClass("not_saved");
                $("#create-ia-from-pr").removeClass("hide");
            });

            $("body").on("click", "#create-ia-from-pr-save", function(evt) {
                var $pr_input = $("#pr-input");
                var pr = $.trim($pr_input.val());
                if (pr.length) {
                    var jqxhr = $.post("/ia/create_from_pr", {
                        pr : pr
                    })
                    .done(function(data) {
                        console.log(data);
                        checkRedirect(data, $pr_input);
                    });
                }
            });

            $(".login_newia").click(function(evt) {
                $("#signup-bg, #signup-form").addClass("hide");
                $("#login-bg, #login-form").removeClass("hide");
            });

            $("#login-save").click(function(evt) {
                var prefix = "#login-";
                var username = $(prefix + "username-input").val();
                var pwd = $(prefix + "pwd-input").val();
                
                if (username.length && (pwd.length >= 8)) {
                    login(username, pwd);
                }
            });

            $("#signup-save").click(function(evt) {
                var prefix = "#signup-";
                var username = $(prefix + "username-input").val();
                var pwd = $(prefix + "pwd-input").val();
                var email = $(prefix + "email-input").val();
                
                if (username.length && (pwd.length >= 8)) {
		    var req = $.post("/my/register_from_ia_wizard", {
		        username: username,
		        password: pwd,
		        email: email,
		        action_token: $('input[name="action_token"]').val()
		    })
		    .done(function(data) {
		        if (data && data.result) {
		    	    $("#signup-bg, #signup-form").addClass("hide");
                            login(username, pwd);
		        }
		    });
                }
            });
            
            $("#new_ia_wizard_save").click(function(evt) {
                var data = getData();
                if (data.id && username.length) {
                    create_ia();
                } else if (!username.length) {
                    $("#signup-bg, #signup-form").removeClass("hide");
                }
            });

            function login(username, pwd) {
	        var req = $.post("/my/login_from_ia_wizard", {
	            username: username,
	            password: pwd,
	            action_token: $('input[name="action_token"]').val()
	        })
	        .done(function(data) {
	            if (data && data.result) {
	                $("#login-bg, #login-form").addClass("hide");
	                var data = getData();
	                create_ia(data);
	            }
	        });
            }

            function getData() {
                var data = {};
                $(".wizard_field").each(function(idx) {
                    var $temp_el = $(this).find(".wizard_field_insert");
                    var temp_id = $temp_el.attr("id");
                    var temp_field = temp_id.replace(/\-[^\-]+$/, "");
                    console.log(temp_field);
                    var temp_type = temp_id.replace(/^.+\-/, "");
                    var temp_val = (temp_type === "radio")? $.trim($temp_el.find('input[type="radio"]:checked').val()) : $.trim($temp_el.val());

                    if (temp_field) {
                        temp_field = temp_field.replace(/^.+\-/, "");
                        data[temp_field] = temp_val;
                    }
                });

                data.id = data.name;
                return data;
            }

            function create_ia(data) {
                var jqxhr = $.post("/ia/create", {
                   data : JSON.stringify(data)
                })
                .done(function(data) {
                   console.log(data);
                   if (data.result && data.id) {
                       window.location = '/ia/view/' + data.id;
                   }
               });
            }
            
            function checkRedirect(data, $input) {
                if (data.result && data.id) {
                    window.location = '/ia/view/' + data.id;
                } else {
                    $input.addClass("not_saved");
                }
            }
        }
    };
})(DDH); 
