(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['index'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n<tr>\n\n    <td style=\"width:2em; text-align:right; padding-right:1em;\">\n        "
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.index)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n    </td>\n\n    <!--<td style=\"width:20em;\">-->\n    <td>\n        <a href=\"http://russell2.duckduckgo.com:5000/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n    </td>\n\n    <td>\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.topic), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </td>\n\n    <td>\n        ";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n    </td>\n\n    <td style=\"padding-right: 1em\">\n        ";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n    </td>\n\n    <td style=\"padding-right: 1em\">\n        ";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n    </td>\n\n</tr>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += " <span class=\"ia_topic\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</span> ";
  return buffer;
  }

  buffer += "\n\n";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.ia), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
})();(function(env) {

    console.log("ia pages");

    env.DDH = {
        load_index: function(x) {
            DDH.ia = x;
            console.log("DDH loaded ia data");
        },

        current_sort: '',
        sort_asc: 1,

        sort_index: function(what) {
            console.log("sorting by %s, prev is %s", what, DDH.current_sort);

            // reverse
            if (DDH.current_sort == what) {
                DDH.sort_asc = 1 - DDH.sort_asc;
            }
            else {
                DDH.sort_asc = 1; // reset
            }

            DDH.ia.sort(function(l,r) {

                // sort direction
                if (DDH.sort_asc) {
                    var a=l, b=r;
                }
                else {
                    var a=r; b=l;
                }

                DDH.current_sort = what;
                
                if (a[what] > b[what]) {
                    return 1;
                }

                if (a[what] < b[what]) {
                    return -1;
                }

                return 0;
            });
            
            DDH.redraw_index();
        },

        redraw_index: function() {
            var iap = Handlebars.templates.index({ia: DDH.ia});
            $("#ia_index").html(iap);
        },


    };

    $(document).ready(function() {

        $.getJSON("/ia/json", function(x) {
            DDH.load_index(x);
            DDH.sort_index('name');

            $("#sort_name").on('click', DDH.sort_index.bind(DDH, 'name'));
            $("#sort_descr").on('click', DDH.sort_index.bind(DDH, 'description'));
            $("#sort_status").on('click', DDH.sort_index.bind(DDH, 'dev_milestone'));
            $("#sort_repo").on('click', DDH.sort_index.bind(DDH, 'repo'));
        });


    });

})(window);
