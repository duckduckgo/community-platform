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
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("new-wrap");
	    $(".site-main").addClass("developer-main");
            $(".breadcrumb-nav").remove();

             $("body").on("click", "#create-ia-from-pr", function(evt) {
                $("#create-ia-from-pr-form, #create-ia-from-pr-bg").removeClass("hide");
            });

            $("body").on('click', "#create-ia-from-pr-cancel, #signup-cancel, #login-cancel", function(evt) {
                var prefix = "#" + $(this).attr("id").replace("-cancel", "");
                var $modal = $(prefix + "-form");
                $modal.addClass("hide");
                $(prefix + "-bg").addClass("hide");
                $modal.find("input, textarea").val("").removeClass("not_saved");
            });

            $("body").keypress(function(evt) {
                if (evt.which === 13) {
                    if (!$("#signup-form").hasClass("hide")) {
                        $("#signup-save").trigger("click");
                    } else if (!$("#login-form").hasClass("hide")) {
                        $("#login-save").trigger("click");
                    }
                }
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
                
                $(".error-msg").addClass("hide");
                
                if (username.length && (pwd.length >= 8)) {
                    login(username, pwd);
                } else {
                   if (!username.length) {
                      $("#login-username-error").removeClass("hide");
                   }

                   if (pwd.length < 8) {
                      $("#login-pwd-error").removeClass("hide");
                   }
                }
            });

            $("#signup-save").click(function(evt) {
                var prefix = "#signup-";
                var username = $(prefix + "username-input").val();
                var pwd = $(prefix + "pwd-input").val();
                var email = $(prefix + "email-input").val();
                
                $(".error-msg").addClass("hide");
                
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
		        } else {
                            $("#signup-undef-error").removeClass("hide");
                        }
		    });
                } else {
                    if (!username.length) {
                        $("#signup-username-error").removeClass("hide");
                    }

                    if (pwd.length < 8) {
                        $("#signup-pwd-error").removeClass("hide");
                    }
                }
            });
            
            $("#new_ia_wizard_save").click(function(evt) {
                var data = getData();
                if (data.id && username.length) {
                    create_ia(data);
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
	            } else {
                      $("#login-undef-error").removeClass("hide");
                    }
	        });
            }

            function getData() {
                var data = {};
                $(".wizard_field").each(function(idx) {
                    var $temp_el = $(this).find(".wizard_field_insert");
                    var temp_id = $temp_el.attr("id");
                    var temp_field = temp_id.replace(/\-[^\-]+$/, "");
                    var temp_type = temp_id.replace(/^.+\-/, "");
                    var temp_val = (temp_type === "radio")? $.trim($temp_el.find('input[type="radio"]:checked').val()) : $.trim($temp_el.val());

                    if (temp_field) {
                        temp_field = temp_field.replace(/^.+\-/, "");
                        data[temp_field] = temp_val;

                        if (temp_field === "example_query") {
                            var queries = temp_val.replace(/((\s(?:\,)\s)|((\s(?:\,))|((?:\,)\s)))/g, ",").split(",");
                            data.example_query = queries.shift();
                            data.other_queries = JSON.stringify(queries);
                        }
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
