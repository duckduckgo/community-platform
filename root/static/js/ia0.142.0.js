this["Handlebars"] = this["Handlebars"] || {};
this["Handlebars"]["templates"] = this["Handlebars"]["templates"] || {};

this["Handlebars"]["templates"]["advanced"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program3(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <div class=\"ia-single--details ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" tabindex=\"0\" id=\"ia-single--details\">\n        <h3 class=\"ia-single--header\">Details\n            <a href=\"#\" class=\"devpage-commit-details sep--after ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "details", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"devpage-commit-details\">Commit Changes</a>\n            <a href=\"#\" class=\"devpage-cancel-details ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "details", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"devpage-cancel-details\">Revert All</a>\n        </h3>\n\n        <div class=\"section-group\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n\n        <!-- Spice -->\n        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(12, program12, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        <!-- Goodies -->\n        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(44, program44, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "goodies", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "goodies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(46, program46, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        <!-- Longtail -->\n        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(114, program114, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "longtail", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        </div>\n    </div>\n    ";
  return buffer;
  }
function program4(depth0,data) {
  
  
  return "wicked-border";
  }

function program6(depth0,data) {
  
  
  return "hide";
  }

function program8(depth0,data) {
  
  
  return "id=\"answerbar-group\"";
  }

function program10(depth0,data) {
  
  
  return "id=\"src_options-group\"";
  }

function program12(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Perl Module</span>\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input perl_module\" id=\"perl_module-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(17, program17, data),fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_module", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_module", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Template\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input template\" id=\"template-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(21, program21, data),fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "template", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "template", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n            </div>\n\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        Perl Dependencies\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(25, program25, data),fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_dependencies", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_dependencies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"comma-separated js-autocommit frm__input perl_dependencies\" id=\"perl_dependencies-input\">\n                </div>\n                ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(27, program27, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n\n            <div class=\"gw\">\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        API Documentation\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(34, program34, data),fn:self.program(32, program32, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_api_documentation", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_api_documentation", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_api_documentation\" id=\"src_api_documentation-input\">\n                </div>\n\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        API Status Page\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(38, program38, data),fn:self.program(36, program36, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "api_status_page", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "api_status_page", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input api_status_page\" id=\"api_status_page-input\">\n                </div>\n\n                <div class=\"third g\">\n                    <ul>\n                        <li>\n                            <label class=\"details__label\">Fallback Timeout (ms):</label>\n                            <input type=\"number\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(42, program42, data),fn:self.program(40, program40, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "fallback_timeout", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "fallback_timeout", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"fallback_timeout-input\" class=\"js-autocommit frm__input fallback_timeout section-group__item\">\n                        </li>\n                    </ul>\n                </div>\n            </div>\n        ";
  return buffer;
  }
function program13(depth0,data) {
  
  
  return "class=\"asterisk\"";
  }

function program15(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.perl_module)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program17(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.perl_module) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_module); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program19(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.template)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program21(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program23(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program25(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.perl_dependencies) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_dependencies); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program27(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <div class=\"third g\">\n                        <label class=\"details__label\">\n                            Tab Name\n                        </label>\n                        <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(30, program30, data),fn:self.program(28, program28, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "tab", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "tab", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input tab\" id=\"tab-input\">\n                    </div>\n                ";
  return buffer;
  }
function program28(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.tab)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program30(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.tab) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.tab); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program32(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_api_documentation)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program34(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.src_api_documentation) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_api_documentation); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program36(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.api_status_page)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program38(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.api_status_page) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.api_status_page); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program40(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program42(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program44(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Perl Module</span>\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input perl_module\" id=\"perl_module-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(17, program17, data),fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_module", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_module", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Template\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input template\" id=\"template-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(21, program21, data),fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "template", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "template", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n            </div>\n\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        Perl Dependencies\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(25, program25, data),fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_dependencies", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_dependencies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"comma-separated js-autocommit frm__input perl_dependencies\" id=\"perl_dependencies-input\">\n                </div>\n                ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(27, program27, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n        ";
  return buffer;
  }

function program46(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <div class=\"gw\">\n                <div class=\"twothird g\">\n                    <div>\n                        <label class=\"details__label\">\n                            <span class=\"";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(47, program47, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">Perl Module</span>\n                        </label>\n                        <input type=\"text\" class=\"js-autocommit frm__input perl_module\" id=\"perl_module-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(17, program17, data),fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_module", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_module", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                    </div>\n                    <div>\n                        <label class=\"details__label\">\n                            Template\n                        </label>\n                        <input type=\"text\" class=\"js-autocommit frm__input template\" id=\"template-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(21, program21, data),fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "template", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "template", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                    </div>\n\n                    <div class=\"half\">\n                        <label  class=\"details__label\">\n                            Source ID\n                        </label>\n                        <input type=\"number\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(51, program51, data),fn:self.program(49, program49, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_id", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_id\" id=\"src_id-input\">\n                    </div>\n                    <div class=\"half g\">\n                        <label class=\"details__label\">\n                            Directory\n                        </label>\n                        <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(55, program55, data),fn:self.program(53, program53, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "directory", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "directory", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input directory clearfix section-group__item\" id=\"directory-input\">\n                    </div>\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Options\n                    </label>\n                    <ul>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"skip_abstract-check\" class=\"skip_abstract section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(60, program60, data),fn:self.program(57, program57, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "skip_abstract", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "skip_abstract", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Skip Abstract</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"skip_abstract_paren-check\" class=\"skip_abstract_paren section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(64, program64, data),fn:self.program(62, program62, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "skip_abstract_paren", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "skip_abstract_paren", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Skip Abstract Parent</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"skip_icon-check\" class=\"skip_icon section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(68, program68, data),fn:self.program(66, program66, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "skip_icon", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "skip_icon", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Skip Icon</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"skip_image_name-check\" class=\"skip_image_name section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(72, program72, data),fn:self.program(70, program70, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "skip_image_name", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "skip_image_name", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Skip Image Name</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"is_wikipedia-check\" class=\"is_wikipedia section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(76, program76, data),fn:self.program(74, program74, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "is_wikipedia", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "is_wikipedia", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Is Wikipedia</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"is_mediawiki-check\" class=\"is_mediawiki section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(80, program80, data),fn:self.program(78, program78, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "is_mediawiki", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "is_mediawiki", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Is MediaWiki</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label class=\"frm__label\">\n                                <input id=\"is_fanon-check\" class=\"is_fanon section-group__item frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(84, program84, data),fn:self.program(82, program82, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "is_fanon", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "is_fanon", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                <span class=\"frm__label__txt\">Is Fanon</span>\n                            </label>\n                        </li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"gw\">\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Source Name\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(88, program88, data),fn:self.program(86, program86, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_name", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_name", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_name\" id=\"src_name-input\">\n                </div>\n\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Minimum Abstract Length\n                    </label>\n                    <input type=\"number\" step=\"1\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(92, program92, data),fn:self.program(90, program90, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "min_abstract_length", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "min_abstract_length", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input min_abstract_length clearfix section-group__item\" id=\"min_abstract_length-input\">\n                </div>\n\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Source Skip\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(96, program96, data),fn:self.program(94, program94, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_skip", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_skip", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_skip clearfix section-group__item\" id=\"src_skip-input\">\n                </div>\n            </div>\n            <div class=\"gw\">\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Source Domain\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(100, program100, data),fn:self.program(98, program98, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_domain", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_domain", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_domain\" id=\"src_domain-input\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Language\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(104, program104, data),fn:self.program(102, program102, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "language", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "language", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input language clearfix section-group__item\" id=\"language-input\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Source Info\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(108, program108, data),fn:self.program(106, program106, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_info", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_info", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_info clearfix section-group__item\" id=\"src_info-input\">\n                </div>\n            </div>\n            <div>\n                <label class=\"details__label\">\n                    Skip Query\n                </label>\n                <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(112, program112, data),fn:self.program(110, program110, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "skip_qr", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "skip_qr", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input skip_qr clearfix section-group__item\" id=\"skip_qr\">\n            </div>\n        ";
  return buffer;
  }
function program47(depth0,data) {
  
  
  return "asterisk";
  }

function program49(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program51(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.src_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program53(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program55(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program57(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program58(depth0,data) {
  
  
  return "checked=\"checked\"";
  }

function program60(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program62(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program64(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program66(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program68(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program70(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program72(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program74(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program76(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program78(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program80(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program82(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program84(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program86(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program88(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.src_name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program90(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program92(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program94(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program96(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program98(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_domain)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program100(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.src_domain) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_domain); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program102(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program104(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program106(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program108(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program110(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program112(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program114(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Perl Module</span>\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input perl_module\" id=\"perl_module-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(17, program17, data),fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_module", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_module", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Template\n                    </label>\n                    <input type=\"text\" class=\"js-autocommit frm__input template\" id=\"template-input\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(21, program21, data),fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "template", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "template", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                </div>\n            </div>\n\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        Perl Dependencies\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(25, program25, data),fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "perl_dependencies", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "perl_dependencies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"comma-separated js-autocommit frm__input perl_dependencies\" id=\"perl_dependencies-input\">\n                </div>\n                ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(27, program27, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n\n            <div class=\"gw\">\n                <div class=\"twothirds g\">\n                    <label class=\"details__label\">\n                        Source Domain\n                    </label>\n                    <input type=\"text\" value=\"";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(100, program100, data),fn:self.program(98, program98, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "src_domain", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "src_domain", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" class=\"js-autocommit frm__input src_domain\" id=\"src_domain-input\">\n                </div>\n                <div class=\"third g\">\n                    <label class=\"details__label\">\n                        Is StackExchange\n                    </label>\n                    <label class=\"frm__label\">\n                        <input id=\"is_stackexchange-check\" class=\"is_stackexchange frm__label__chk js-autocommit\" type=\"checkbox\" ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(117, program117, data),fn:self.program(115, program115, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "details", "is_stackexchange", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "details", "is_stackexchange", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                        <span class=\"frm__label__txt\">Is StackExchange</span>\n                    </label>\n                </div>\n            </div>\n        ";
  return buffer;
  }
function program115(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options) : helperMissing.call(depth0, "is_true", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.details)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program117(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.is_stackexchange), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.is_stackexchange), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

  stack1 = helpers['if'].call(depth0, (depth0 && depth0.repo), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["breadcrumbs"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "\n    <a href=\"/ia\">Instant Answers</a>\n";
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(6, program6, data),fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "deprecated", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.dev_milestone), "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program4(depth0,data) {
  
  
  return "\n        <a href=\"/ia/dev/deprecated\">Deprecated IAs</a>\n    ";
  }

function program6(depth0,data) {
  
  
  return "\n        <a href=\"/ia/dev/pipeline\">Dev Pipeline</a>\n    ";
  }

  buffer += "<a href=\"/\">Home</a>\n<span class=\"less-than\">&gt;</span>\n";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.dev_milestone), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n<span class=\"less-than\">&gt;</span>\n";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["commit_page"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Name</th>\n\n                <td name=\"name\" id=\"name_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"name\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</td>\n            </tr>\n        ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>ID</th>\n\n                <td name=\"id\" id=\"id_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"id\">";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</td>\n            </tr>\n        ";
  return buffer;
  }

function program5(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Status</th>\n\n                <td name=\"status\" id=\"status_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.status)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"status\">";
  if (helper = helpers.status) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.status); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</td>\n            </tr>\n        ";
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Description</th>\n\n                <td name=\"description\"  id=\"description_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"description\">\n                    ";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Type</th>\n\n                <td name=\"repo\"  id=\"repo_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"repo\">\n                    ";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program11(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Template</th>\n\n                <td name=\"template\"  id=\"template_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.template)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"template\">\n                    ";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program13(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>API Documentation</th>\n\n                <td name=\"src_api_documentation\"  id=\"src_api_documentation_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_api_documentation)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"src_api_documentation\">\n                    ";
  if (helper = helpers.src_api_documentation) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_api_documentation); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program15(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>API Status Page</th>\n\n                <td name=\"api_status_page\"  id=\"api_status_page_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.api_status_page)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"api_status_page\">\n                    ";
  if (helper = helpers.api_status_page) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.api_status_page); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program17(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Is Stack Exchange</th>\n\n                <td name=\"is_stackexchange\"  id=\"is_stackexchange_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"is_stackexchange\">\n                    ";
  if (helper = helpers.is_stackexchange) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.is_stackexchange); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program19(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Unsafe</th>\n\n                <td name=\"unsafe\"  id=\"unsafe_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"unsafe\">\n                    ";
  if (helper = helpers.unsafe) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.unsafe); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program21(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Answerbar</th>\n\n                <td name=\"answerbar\"  id=\"answerbar_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"answerbar\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program23(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Tab</th>\n\n                <td name=\"tab\"  id=\"tab_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.tab)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"tab\">\n                    ";
  if (helper = helpers.tab) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.tab); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program25(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Producer</th>\n\n                <td name=\"producer\"  id=\"producer_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.producer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"producer\">\n                    ";
  if (helper = helpers.producer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.producer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program27(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Designer</th>\n\n                <td name=\"designer\"  id=\"designer_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.designer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"designer\">\n                    ";
  if (helper = helpers.designer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.designer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program29(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Developer</th>\n\n                <td name=\"developer\"  id=\"developer_original\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.developer), {hash:{},inverse:self.noop,fn:self.program(30, program30, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n                <td name=\"developer\">\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(30, program30, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n            </tr>\n        ";
  return buffer;
  }
function program30(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                        <li data-type=\"";
  if (helper = helpers.type) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.type); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                            <a href=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                                ";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                            </a>\n                        </li>\n                    ";
  return buffer;
  }

function program32(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Perl Module</th>\n\n                <td name=\"perl_module\"  id=\"perl_module_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.perl_module)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"perl_module\">\n                    ";
  if (helper = helpers.perl_module) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_module); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program34(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Topic</th>\n\n                <td name=\"topic\"  id=\"topic_original\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.topic), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n                <td name=\"topic\">\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.topic), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n            </tr>\n        ";
  return buffer;
  }
function program35(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li>"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</li>\n                    ";
  return buffer;
  }

function program37(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Example Query</th>\n\n                <td name=\"example_query\"  id=\"example_query_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.example_query)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"example_query\">\n                    ";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program39(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Other Queries</th>\n\n                <td name=\"other_queries\"  id=\"other_queries_original\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n                <td name=\"other_queries\">\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program41(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Trigger Words</th>\n\n                <td name=\"triggers\"  id=\"triggers_original\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n                <td name=\"triggers\">\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program43(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Perl Dependencies</th>\n\n                <td name=\"perl_dependencies\"  id=\"perl_dependencies_original\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n                <td name=\"perl_dependencies\">\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program45(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Source ID</th>\n\n                <td name=\"src_id\"  id=\"src_id_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"src_id\">\n                    ";
  if (helper = helpers.src_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program47(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Source Name</th>\n\n                <td name=\"src_name\"  id=\"src_name_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"src_name\">\n                    ";
  if (helper = helpers.src_name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program49(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Source Domain</th>\n\n                <td name=\"src_domain\"  id=\"src_domain_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_domain)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"src_domain\">\n                    ";
  if (helper = helpers.src_domain) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_domain); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program51(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Source Options</th>\n\n                <td name=\"src_options\"  id=\"src_options_original\">\n                    <ul class=\"section-group src_options-group\">\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_abstract\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_abstract_paren\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract parent\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_icon\"/>\n                            <span class=\"check-txt\">\n                                Skip icon\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_image_name\"/>\n                            <span class=\"check-txt\">\n                                Skip image name\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_wikipedia\"/>\n                            <span class=\"check-txt\">\n                                Is Wikipedia\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_mediawiki\"/>\n                            <span class=\"check-txt\">\n                                Is MediaWiki\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options) : helperMissing.call(depth0, "is_false", ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_fanon\"/>\n                            <span class=\"check-txt\">\n                                Is Fanon\n                            </span>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source skip</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"source_skip\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.source_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip query</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"skip_qr\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Directory</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"directory\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Minimum abstract length</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"min_abstract_length\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source info</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"src_info\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip end</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"skip_end\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_end)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Language</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"language\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                    </ul>\n                </td>\n                <td name=\"src_options\">\n                    <ul class=\"section-group src_options-group\">\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_abstract\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_abstract_paren\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract parent\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_icon\"/>\n                            <span class=\"check-txt\">\n                                Skip icon\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"skip_image_name\"/>\n                            <span class=\"check-txt\">\n                                Skip image name\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_wikipedia\"/>\n                            <span class=\"check-txt\">\n                                Is Wikipedia\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_mediawiki\"/>\n                            <span class=\"check-txt\">\n                                Is MediaWiki\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-field=\"is_fanon\"/>\n                            <span class=\"check-txt\">\n                                Is Fanon\n                            </span>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source skip</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"source_skip\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.source_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip query</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"skip_qr\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Directory</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"directory\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Minimum abstract length</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"min_abstract_length\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source info</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"src_info\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip end</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"skip_end\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_end)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Language</label>\n                            <div class=\"clearfix section-group__item\" data-field=\"language\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                    </ul>\n                </td>\n            </tr>\n        ";
  return buffer;
  }
function program52(depth0,data) {
  
  
  return "-empty";
  }

function program54(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Dev Milestone</th>\n\n                <td name=\"dev_milestone\"  id=\"dev_milestone_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.dev_milestone)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"dev_milestone\">\n                    ";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program56(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Blockgroup</th>\n\n                <td name=\"blockgroup\"  id=\"blockgroup_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.blockgroup)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"blockgroup\">\n                    ";
  if (helper = helpers.blockgroup) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.blockgroup); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

function program58(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <tr class=\"updates_list\">\n                <th>Deployment State</th>\n\n                <td name=\"deployment_statee\"  id=\"deployment_state_original\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.deployment_state)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </td>\n                <td name=\"deployment_state\">\n                    ";
  if (helper = helpers.deployment_state) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.deployment_state); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </td>\n            </tr>\n        ";
  return buffer;
  }

  buffer += "<h2>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " - Staged Edits</h2>\n<p>Click on the version you want to commit for each field</p>\n<table class=\"staged_edits\">\n    <thead>\n        <tr>\n            <th class=\"empty_th\"></th>\n            <th>Live</th>\n            <th>Edited</th>\n         </tr>\n    </thead>\n    \n    <tbody>\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.name), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        \n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.id), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.id), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.status), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.status), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.description), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.description), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.repo), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.template), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.template), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.src_api_documentation), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.src_api_documentation), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.api_status_page), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.api_status_page), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.is_stackexchange), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.is_stackexchange), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.unsafe), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout), options) : helperMissing.call(depth0, "not_null", ((stack1 = (depth0 && depth0.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.tab), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.tab), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(25, program25, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.producer), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.producer), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(27, program27, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.designer), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.designer), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(29, program29, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.developer), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.developer), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(32, program32, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.perl_module), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.perl_module), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(34, program34, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.topic), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(37, program37, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.example_query), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.example_query), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n       ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(39, program39, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.other_queries), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n       ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(41, program41, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.triggers), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.triggers), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n       ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(43, program43, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.perl_dependencies), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.perl_dependencies), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(45, program45, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.src_id), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.src_id), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(47, program47, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.src_name), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.src_name), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(49, program49, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.src_domain), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.src_domain), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n       ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(51, program51, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.src_options), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.src_options), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(54, program54, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), options) : helperMissing.call(depth0, "not_null", (depth0 && depth0.dev_milestone), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(56, program56, data),data:data},helper ? helper.call(depth0, depth0, "blockgroup", options) : helperMissing.call(depth0, "exists", depth0, "blockgroup", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, depth0, "deployment_state", options) : helperMissing.call(depth0, "exists", depth0, "deployment_state", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </tbody>\n</table>\n\n<span class=\"clearfix\"></span>\n<div class=\"button disabled\" id=\"commit\">Commit</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["description"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program2(depth0,data) {
  
  
  return "class=\"asterisk\"";
  }

function program4(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program5(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <a href=\"#\" class=\"devpage-edit ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-edit-description\">Edit</a>\n            <a href=\"#\" class=\"devpage-commit sep--after ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-commit-description\">Commit</a>\n            <a href=\"#\" class=\"devpage-cancel ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-cancel-description\">Cancel</a>\n        ";
  return buffer;
  }
function program6(depth0,data) {
  
  
  return "hide";
  }

function program8(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <a href=\"/ideas/idea/";
  if (helper = helpers.forum_link) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.forum_link); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Forum Thread</a>\n        ";
  return buffer;
  }
function program9(depth0,data) {
  
  
  return "class=\"sep--before devpage-forum\"";
  }

function program11(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            ";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n        ";
  return buffer;
  }

function program13(depth0,data) {
  
  
  return "\n            <span class=\"no-available\">No description provided.</span>\n        ";
  }

function program15(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <textarea class=\"";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " frm__text description js-autocommit hidden-toshow\" id=\"description-textarea\">";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.program(18, program18, data),fn:self.program(16, program16, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</textarea>\n    ";
  return buffer;
  }
function program16(depth0,data) {
  
  var buffer = "", stack1;
  buffer += escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  return buffer;
  }

function program18(depth0,data) {
  
  var buffer = "", stack1, helper;
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1);
  return buffer;
  }

  buffer += "<div id=\"big-description\">\n    <h3 class=\"ia-single--header\">\n            <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Description</span>\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.forum_link), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </h3>\n\n    <p  class=\"readonly--info ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "description", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "description", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"description--readonly\">\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.description), {hash:{},inverse:self.program(13, program13, data),fn:self.program(11, program11, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </p>\n\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["dev_pipeline"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, functionType="function";

function program1(depth0,data) {
  
  
  return "\n          <span class=\"pipeline-filter right\" id=\"filter-mentioned\" title=\"Filter by mentions\">\n            <i class=\"platform-at-mention\"></i>\n            <span class=\"filter-count\" id=\"count-mentioned\"></span>\n          </span>\n      ";
  }

function program3(depth0,data) {
  
  
  return "\n        <span class=\"pipeline-filter right\" id=\"filter-attention\" title=\"Filter by last activity author\">\n            <i class=\"platform-warning\"></i>\n            <span class=\"filter-count\" id=\"count-attention\"></span>\n        </span>\n      ";
  }

function program5(depth0,data) {
  
  
  return "filter-logged-out";
  }

function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      <span class=\"right frm__select\" id=\"sort_pipeline\">\n        <select>\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.by_priority), {hash:{},inverse:self.program(10, program10, data),fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </select>\n      </span>\n    ";
  return buffer;
  }
function program8(depth0,data) {
  
  
  return "\n                <option value=\"0\">Sort by Priority</option>\n                <option value=\"1\">Sort by Recently Updated</option>\n            ";
  }

function program10(depth0,data) {
  
  
  return "\n                <option value=\"1\">Sort by Recently Updated</option>\n                <option value=\"0\">Sort by Priority</option>\n            ";
  }

function program12(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n\n<div class=\"dev_pipeline-column quarter g\" id=\"pipeline-planning\">\n  <div class=\"dev_pipeline-column--container\">\n    <h2 class=\"dev_pipeline-column__title\">\n        <span class=\"left\">Planning </span> <span class=\"milestone-count right\">"
    + escapeExpression((helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), options) : helperMissing.call(depth0, "length", (depth0 && depth0.planning), options)))
    + "</span>\n        <span class=\"clearfix\"></span>\n    </h2>\n    <ul class=\"dev_pipeline-column__list\" id=\"pipeline-planning__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.planning), {hash:{},inverse:self.noop,fn:self.programWithDepth(13, program13, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    </div>\n</div>\n\n<div class=\"dev_pipeline-column quarter g\" id=\"pipeline-development\">\n  <div class=\"dev_pipeline-column--container\">\n    <h2 class=\"dev_pipeline-column__title\">\n        <span class=\"left\">Development </span> <span class=\"milestone-count right\">"
    + escapeExpression((helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), options) : helperMissing.call(depth0, "length", (depth0 && depth0.development), options)))
    + "</span>\n        <span class=\"clearfix\">\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" id=\"pipeline-development__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.development), {hash:{},inverse:self.noop,fn:self.programWithDepth(13, program13, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    </div>\n</div>\n\n<div class=\"dev_pipeline-column quarter g\" id=\"pipeline-testing\">\n  <div class=\"dev_pipeline-column--container\">\n    <h2 class=\"dev_pipeline-column__title\">\n        <span class=\"left\">Testing </span> <span class=\"milestone-count right\"> "
    + escapeExpression((helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), options) : helperMissing.call(depth0, "length", (depth0 && depth0.testing), options)))
    + " </span>\n        <span class=\"clearfix\"></span>\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" id=\"pipeline-testing__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.testing), {hash:{},inverse:self.noop,fn:self.programWithDepth(13, program13, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    </div>\n</div>\n\n<div class=\"dev_pipeline-column quarter g\" id=\"pipeline-complete\">\n   <div class=\"dev_pipeline-column--container\">\n    <h2 class=\"dev_pipeline-column__title\">\n        <span class=\"left\">Complete </span> <span class=\"milestone-count right\"> "
    + escapeExpression((helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), options) : helperMissing.call(depth0, "length", (depth0 && depth0.complete), options)))
    + " </span>\n        <span class=\"clearfix\"></span>\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" id=\"pipeline-complete__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.complete), {hash:{},inverse:self.noop,fn:self.programWithDepth(13, program13, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    </div>\n</div>\n";
  return buffer;
  }
function program13(depth0,data,depth2) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <li id=\"pipeline-list__";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id), {hash:{},inverse:self.noop,fn:self.program(14, program14, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.can_edit), {hash:{},inverse:self.noop,fn:self.program(24, program24, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " producer-";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.producer), {hash:{},inverse:self.noop,fn:self.program(26, program26, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " designer-";
  if (helper = helpers.designer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.designer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.program(31, program31, data),fn:self.program(28, program28, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n             ";
  stack1 = (helper = helpers.is_false_array || (depth0 && depth0.is_false_array),options={hash:{},inverse:self.noop,fn:self.program(33, program33, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.perl_module), (depth0 && depth0.name), (depth0 && depth0.repo), (depth0 && depth0.example_query), (depth0 && depth0.producer), (depth0 && depth0.developer), options) : helperMissing.call(depth0, "is_false_array", (depth0 && depth0.perl_module), (depth0 && depth0.name), (depth0 && depth0.repo), (depth0 && depth0.example_query), (depth0 && depth0.producer), (depth0 && depth0.developer), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n             ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.at_mentions), {hash:{},inverse:self.noop,fn:self.programWithDepth(35, program35, data, depth2),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                <div class=\"item-name pipeline__stamp-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n		  <span class=\"invisible-link\" style=\"position:absolute\"><a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></a></span>\n                  <span class=\"item-title\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n                    <div class=\"right item-activity\">\n                      ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.program(40, program40, data),fn:self.program(38, program38, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.pr), "issue_id", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.pr), "issue_id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </div>\n                </div>\n                <span class=\"clearfix\"></span>\n                <div class=\"activity-details hide\">\n                    ";
  stack1 = (helper = helpers.is_before || (depth0 && depth0.is_before),options={hash:{},inverse:self.noop,fn:self.program(46, program46, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.date), ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.date), options) : helperMissing.call(depth0, "is_before", ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.date), ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.date), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.last_comment), {hash:{},inverse:self.noop,fn:self.program(48, program48, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </div>\n            </li>\n        ";
  return buffer;
  }
function program14(depth0,data) {
  
  var buffer = "", stack1;
  buffer += " ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.last_update), {hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.tags), {hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer;
  }
function program15(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += " ";
  stack1 = (helper = helpers.is_before || (depth0 && depth0.is_before),options={hash:{},inverse:self.program(19, program19, data),fn:self.program(16, program16, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.date), ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.date), options) : helperMissing.call(depth0, "is_before", ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.date), ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.date), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  return buffer;
  }
function program16(depth0,data) {
  
  var buffer = "", stack1;
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  return buffer;
  }
function program17(depth0,data) {
  
  
  return " attention ";
  }

function program19(depth0,data) {
  
  var buffer = "", stack1;
  buffer += " ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  return buffer;
  }

function program21(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options));
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(22, program22, data),data:data},helper ? helper.call(depth0, stack1, "priorityhigh", options) : helperMissing.call(depth0, "eq", stack1, "priorityhigh", options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program22(depth0,data) {
  
  
  return " important ";
  }

function program24(depth0,data) {
  
  
  return "can_edit";
  }

function program26(depth0,data) {
  
  var helper, options;
  return escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.producer), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.producer), options)));
  }

function program28(depth0,data) {
  
  var stack1;
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(29, program29, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program29(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "developer-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + " ";
  return buffer;
  }

function program31(depth0,data) {
  
  
  return "developer-";
  }

function program33(depth0,data) {
  
  
  return " missing ";
  }

function program35(depth0,data,depth3) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.eq || (depth3 && depth3.eq),options={hash:{},inverse:self.noop,fn:self.program(36, program36, data),data:data},helper ? helper.call(depth0, (depth3 && depth3.username), (depth0 && depth0.name), options) : helperMissing.call(depth0, "eq", (depth3 && depth3.username), (depth0 && depth0.name), options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program36(depth0,data) {
  
  
  return " mentioned ";
  }

function program38(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                          <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"one-line\" id=\"pr\" title=\""
    + escapeExpression((helper = helpers.format_time || (depth0 && depth0.format_time),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), options) : helperMissing.call(depth0, "format_time", (depth0 && depth0.last_update), options)))
    + "\">\n                            "
    + escapeExpression((helper = helpers.timeago || (depth0 && depth0.timeago),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), 0, options) : helperMissing.call(depth0, "timeago", (depth0 && depth0.last_update), 0, options)))
    + "\n                          </a>\n                      ";
  return buffer;
  }

function program40(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                          ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.last_update), {hash:{},inverse:self.noop,fn:self.program(41, program41, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                          <span class=\"no-pr\" title=\""
    + escapeExpression((helper = helpers.format_time || (depth0 && depth0.format_time),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), options) : helperMissing.call(depth0, "format_time", (depth0 && depth0.last_update), options)))
    + "\">\n                            "
    + escapeExpression((helper = helpers.timeago || (depth0 && depth0.timeago),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), 0, options) : helperMissing.call(depth0, "timeago", (depth0 && depth0.last_update), 0, options)))
    + "\n                          </span>\n                      ";
  return buffer;
  }
function program41(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<i class=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.pr_merged), {hash:{},inverse:self.program(44, program44, data),fn:self.program(42, program42, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"></i>";
  return buffer;
  }
function program42(depth0,data) {
  
  
  return " platform-pr-merged ";
  }

function program44(depth0,data) {
  
  
  return " platform-pr-closed ";
  }

function program46(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        <div class=\"new-commit one-line\">\n                            <i class=\"icon icon-circle\" />\n                            New commit: <a href=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.diff)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.last_commit)),stack1 == null || stack1 === false ? stack1 : stack1.message)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</a>\n                        </div>\n                    ";
  return buffer;
  }

function program48(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                        <div class=\"last-comment one-line\">\n                            <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "#issuecomment-"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                                <i class=\"icon icon-bubbles\" />\n                                Last comment by "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.last_comment)),stack1 == null || stack1 === false ? stack1 : stack1.user)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </a>\n                       </div>\n                    ";
  return buffer;
  }

  buffer += "<div class=\"filters-bar clearfix\">\n  <div class=\"left search-container\">\n    <i class=\"ddgsi-loupe\"></i>\n    <input type=\"text\" class=\"search-thing\" placeholder=\"Filter by title or description\">\n  </div>\n\n    <div class=\"right\">\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.username), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      <span class=\"pipeline-filter right\" id=\"filter-important\" title=\"Filter by priority\">\n        <i class=\"icon-star\"></i>\n        <span class=\"filter-count\" id=\"count-important\"></span>\n      </span>\n\n\n      <span class=\"pipeline-filter right ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"filter-missing\" title=\"Filter by missing info\">\n          <span class=\"platform-no-info\">\n	    <svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"15\" height=\"15\" viewBox=\"0 0 15 15\">\n	      <g id=\"icon-no_info\">\n		<path id=\"circle-slash\" d=\"M11.895,9.461 C11.639,10.065 11.294,10.585 10.860,11.019 C10.425,11.454 9.909,11.800 9.310,12.059 C8.712,12.318 8.083,12.448 7.422,12.448 C6.470,12.448 5.586,12.183 4.770,11.653 C4.770,11.653 11.502,4.930 11.502,4.930 C12.020,5.727 12.279,6.605 12.279,7.564 C12.279,8.224 12.151,8.857 11.895,9.461 zM2.565,7.564 C2.565,6.683 2.782,5.867 3.217,5.117 C3.651,4.367 4.240,3.775 4.985,3.340 C5.729,2.906 6.541,2.689 7.422,2.689 C8.404,2.689 9.297,2.960 10.101,3.501 C10.101,3.501 3.360,10.233 3.360,10.233 C2.830,9.418 2.565,8.528 2.565,7.564 C2.565,7.564 2.565,7.564 2.565,7.564 zM12.275,2.698 C11.665,2.085 10.935,1.596 10.087,1.233 C9.239,0.870 8.351,0.689 7.422,0.689 C6.494,0.689 5.605,0.870 4.757,1.233 C3.909,1.596 3.179,2.085 2.569,2.698 C1.959,3.311 1.473,4.041 1.110,4.890 C0.746,5.738 0.565,6.629 0.565,7.564 C0.565,8.498 0.746,9.391 1.110,10.242 C1.473,11.093 1.959,11.826 2.569,12.439 C3.179,13.052 3.909,13.540 4.757,13.903 C5.605,14.266 6.494,14.448 7.422,14.448 C8.351,14.448 9.239,14.266 10.087,13.903 C10.935,13.540 11.665,13.052 12.275,12.439 C12.885,11.826 13.371,11.093 13.735,10.242 C14.098,9.391 14.279,8.498 14.279,7.564 C14.279,6.629 14.098,5.738 13.735,4.890 C13.371,4.041 12.885,3.311 12.275,2.698 z\" fill=\"#DDDDDD\" />\n		<path id=\"i\" d=\"M8.766,9.247 C8.709,9.190 8.642,9.162 8.565,9.162 C8.565,9.162 8.279,9.162 8.279,9.162 C8.279,9.162 8.279,6.590 8.279,6.590 C8.279,6.513 8.251,6.446 8.194,6.390 C8.138,6.333 8.071,6.305 7.993,6.305 C7.993,6.305 6.279,6.305 6.279,6.305 C6.202,6.305 6.135,6.333 6.078,6.390 C6.022,6.446 5.993,6.513 5.993,6.590 C5.993,6.590 5.993,7.162 5.993,7.162 C5.993,7.239 6.022,7.306 6.078,7.363 C6.135,7.419 6.202,7.448 6.279,7.448 C6.279,7.448 6.565,7.448 6.565,7.448 L6.565,9.162 C6.565,9.162 6.279,9.162 6.279,9.162 C6.202,9.162 6.135,9.190 6.078,9.247 C6.022,9.303 5.993,9.370 5.993,9.448 C5.993,9.448 5.993,10.019 5.993,10.019 C5.993,10.096 6.022,10.163 6.078,10.220 C6.135,10.276 6.202,10.305 6.279,10.305 C6.279,10.305 8.565,10.305 8.565,10.305 C8.642,10.305 8.709,10.276 8.766,10.220 C8.822,10.163 8.851,10.096 8.851,10.019 C8.851,10.019 8.851,9.448 8.851,9.448 C8.851,9.370 8.822,9.303 8.766,9.247 zM8.194,4.104 C8.138,4.047 8.071,4.019 7.993,4.019 C7.993,4.019 6.851,4.019 6.851,4.019 C6.773,4.019 6.706,4.047 6.650,4.104 C6.593,4.160 6.565,4.227 6.565,4.305 C6.565,4.305 6.565,5.162 6.565,5.162 C6.565,5.239 6.593,5.306 6.650,5.363 C6.706,5.419 6.773,5.448 6.851,5.448 C6.851,5.448 7.993,5.448 7.993,5.448 C8.071,5.448 8.138,5.419 8.194,5.363 C8.251,5.306 8.279,5.239 8.279,5.162 C8.279,5.162 8.279,4.305 8.279,4.305 C8.279,4.227 8.251,4.160 8.194,4.104 z\" fill=\"#999999\" />\n	      </g>\n	    </svg>\n          </span>\n          <span class=\"filter-count right\" id=\"count-missing\"></span>\n      </span> \n\n      \n      <!--- <span class=\"toggle-details right\">\n        <i class=\"icon-check-empty\"></i>\n        Show activity details\n      </span> --->\n\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n          \n      <span class=\"button fix-float\"></span>\n    </span>\n  </div>\n</div>\n\n<div class=\"gw\">\n  ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.dev_milestones), {hash:{},inverse:self.noop,fn:self.programWithDepth(12, program12, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["dev_pipeline_actions"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div class=\"pipeline-actions\">\n            <span class=\"left count-txt\">\n	      <span>";
  if (helper = helpers.selected) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.selected); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span> <span> Selected </span>\n	    </span>\n            <span class=\"deselect-all right\"> <i class=\"deselect ddgsi ddgsi-close\"></i> </span>\n            \n            <span class=\"clearfix\"></span>\n\n            <div class=\"field-section\">\n                <div class=\"primary-label\"> Assign </div>\n                <div class=\"frm__label\"> Producer </div>\n                <input class=\"pipeline-actions__input frm__input\" id=\"input-producer\" />\n            </div>\n\n            <div class=\"field-section\">\n                <div class=\"primary-label\">Update </div>\n                <div class=\"frm__label overlap\"> Dev Milestone </div>\n		<span class=\"frm__select\">\n                  <select class=\"pipeline-actions__select\" id=\"select-dev_milestone\">\n                    <option value=\"0\">planning</option>\n                    <option value=\"1\">development</option>\n                    <option value=\"2\">testing</option>\n                    <option value=\"3\">complete</option>\n                    <option value=\"4\">ghosted</option>\n                  </select>\n		</span>\n            </div>\n\n            <div class=\"field-section\">\n              <div class=\"frm__label overlap\"> Type </div>\n		<span class=\"frm__select\">\n                  <select class=\"pipeline-actions__select\" id=\"select-repo\">\n                    <option value=\"0\">fathead</option>\n                    <option value=\"1\">goodies</option>\n                    <option value=\"2\">longtail</option>\n                    <option value=\"3\">spice</option>\n                  </select>\n		</span>\n            </div>\n\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.got_prs), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <div class=\"frm__label field-label\"> Dev Machine </div>\n                <div class=\"field-section\">\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta), {hash:{},inverse:self.program(5, program5, data),fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </div>\n            ";
  return buffer;
  }
function program3(depth0,data) {
  
  
  return "\n                        <p>Installed on <a href=\"https://beta.duckduckgo.com\">beta</a></p>\n                        <div class=\"pipeline-actions__button button btn--primary\" id=\"beta_install\">\n                            Re-install on beta\n                        </div>\n                    ";
  }

function program5(depth0,data) {
  
  
  return "\n                        <div class=\"pipeline-actions__button button btn--primary\" id=\"beta_install\">\n                            Install on beta\n                        </div>\n                    ";
  }

  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["dev_pipeline_deprecated"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <li >\n                <a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n            </li>\n        ";
  return buffer;
  }

  buffer += "<div class=\"dev_pipeline-column repo-none left\">\n    <h2 class=\"dev_pipeline-column__title\">\n        None\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" >\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.none), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"dev_pipeline-column repo-fathead left\" >\n    <h2 class=\"dev_pipeline-column__title\">\n        Fathead\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" >\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.fathead), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"dev_pipeline-column repo-goodies left\" >\n    <h2 class=\"dev_pipeline-column__title\">\n        Goodies\n    </h2>\n\n\n    <ul class=\"dev_pipeline-column__list\" >\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.goodies), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"dev_pipeline-column repo-longtail left\" >\n    <h2 class=\"dev_pipeline-column__title\">\n        Longtail\n    </h2>\n\n\n    <ul class=\"dev_pipeline-column__list\" >\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.longtail), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"dev_pipeline-column repo-spice left\" >\n    <h2 class=\"dev_pipeline-column__title\">\n        Spice\n    </h2>\n\n    <ul class=\"dev_pipeline-column__list\" >\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.spice), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["dev_pipeline_detail"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helperMissing=helpers.helperMissing, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "sidebar-logged-out";
  }

function program3(depth0,data) {
  
  var stack1;
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.tags), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program4(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options));
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data},helper ? helper.call(depth0, stack1, "priorityhigh", options) : helperMissing.call(depth0, "eq", stack1, "priorityhigh", options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program5(depth0,data) {
  
  
  return " \n        <span class=\"sep--after\">\n            <i class=\"icon-star-empty\" />\n        </span>\n    ";
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n	<span class=\"sep--after\">\n          <span class=\"edit-sidebar frm__select\" id=\"edit-sidebar-repo\">\n            <select>\n              <option value=\"0\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n              ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n              ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "goodies", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "goodies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n              ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(12, program12, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "longtail", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n              ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(14, program14, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </select>\n          </span>\n	</span>\n\n        <span class=\"edit-sidebar frm__select\" id=\"edit-sidebar-dev_milestone\" style=\"width: 9em\">\n            <select>\n                <option value=\"0\">";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(16, program16, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "planning", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(18, program18, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "development", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(20, program20, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "testing", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "testing", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(22, program22, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "complete", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "complete", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                <option value=\"5\">live</option>\n                <option value=\"6\">ghosted</option>\n            </select>\n        </span>\n    ";
  return buffer;
  }
function program8(depth0,data) {
  
  
  return "<option value=\"1\">fathead</option>";
  }

function program10(depth0,data) {
  
  
  return "<option value=\"2\">goodies</option>";
  }

function program12(depth0,data) {
  
  
  return "<option value=\"3\">longtail</option>";
  }

function program14(depth0,data) {
  
  
  return "<option value=\"4\">spice</option>";
  }

function program16(depth0,data) {
  
  
  return "<option value=\"1\">planning</option>";
  }

function program18(depth0,data) {
  
  
  return "<option value=\"2\">development</option>";
  }

function program20(depth0,data) {
  
  
  return "<option value=\"3\">testing</option>";
  }

function program22(depth0,data) {
  
  
  return "<option value=\"4\">complete</option>";
  }

function program24(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.repo), {hash:{},inverse:self.noop,fn:self.program(25, program25, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        <span> ";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n    ";
  return buffer;
  }
function program25(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <span class=\"sep--after\"> ";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n            \n        ";
  return buffer;
  }

function program27(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n\n    <h2 id=\"sidebar-name\">\n        <input class=\"edit-sidebar\" data-focus-class=\"frm__input\" id=\"edit-sidebar-name\" value=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n    </h2>\n\n    <input class=\"edit-sidebar\" style=\"height: initial\" id=\"edit-sidebar-id\" value=\"";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Description </div>\n        <textarea rows=\"3\" cols=\"50\" data-focus-class=\"frm__text\" class=\"edit-sidebar\" id=\"edit-sidebar-description\">";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</textarea>\n    </div>\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Example Query </div>\n        <input class=\"edit-sidebar\" data-focus-class=\"frm__input\" id=\"edit-sidebar-example_query\" value=\"";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n    </div>\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Perl Module </div>\n        <input class=\"edit-sidebar\" data-focus-class=\"frm__input\" id=\"edit-sidebar-perl_module\" value=\"";
  if (helper = helpers.perl_module) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_module); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n    </div>\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Producer </div>\n        <input class=\"edit-sidebar\" data-focus-class=\"frm__input\" id=\"edit-sidebar-producer\" value=\"";
  if (helper = helpers.producer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.producer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n    </div>\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Template </div>\n        <input class=\"edit-sidebar\" data-focus-class=\"frm__input\" id=\"edit-sidebar-template\" value=\"";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n    </div>\n\n    <div class=\"sidebar-field\">\n        <div class=\"field-label primary-label\"> Asana Tasks </div>\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.asana), {hash:{},inverse:self.program(30, program30, data),fn:self.program(28, program28, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n    \n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id), {hash:{},inverse:self.noop,fn:self.program(32, program32, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.priority_msg), {hash:{},inverse:self.noop,fn:self.program(39, program39, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program28(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <span class=\"readonly\">\n                <a href=\"https://app.asana.com/0/0/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.asana)),stack1 == null || stack1 === false ? stack1 : stack1.asana_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">One open task</a>\n            </span>\n        ";
  return buffer;
  }

function program30(depth0,data) {
  
  
  return "\n            <div class=\"button btn--primary\" id=\"asana-create\">Create Task</div>\n        ";
  }

function program32(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <div class=\"sidebar-field\">\n            <div class=\"field-label primary-label\"> Dev Machine </div>\n            ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(36, program36, data),fn:self.program(33, program33, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.beta_install), "success", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.beta_install), "success", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n    ";
  return buffer;
  }
function program33(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <p>Installed on <a href=\"http://beta.duckduckgo.com/";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta_query), {hash:{},inverse:self.noop,fn:self.program(34, program34, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">beta</a></p>\n                <div class=\"button btn--primary\" id=\"beta-single\">Re-install on beta</div>\n            ";
  return buffer;
  }
function program34(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "?q=";
  if (helper = helpers.beta_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.beta_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1);
  return buffer;
  }

function program36(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta_install), {hash:{},inverse:self.noop,fn:self.program(37, program37, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                <div class=\"button btn--primary\" id=\"beta-single\">Install on beta</div>\n            ";
  return buffer;
  }
function program37(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "Install on beta failed: <div class=\"readonly\">";
  if (helper = helpers.beta_install) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.beta_install); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>";
  return buffer;
  }

function program39(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "\n        <div class=\"sidebar-field\">\n            <div class=\"field-label primary-label\">Priority</div>\n            <span class=\"readonly\">"
    + escapeExpression((helper = helpers.newlines || (depth0 && depth0.newlines),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.priority_msg), options) : helperMissing.call(depth0, "newlines", (depth0 && depth0.priority_msg), options)))
    + "</span>\n        </div>\n    ";
  return buffer;
  }

function program41(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.name), {hash:{},inverse:self.noop,fn:self.program(42, program42, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.id), {hash:{},inverse:self.noop,fn:self.program(44, program44, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.description), {hash:{},inverse:self.noop,fn:self.program(46, program46, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(48, program48, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.perl_module), {hash:{},inverse:self.noop,fn:self.program(50, program50, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program42(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n      <h2 id=\"sidebar-name\"> ";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </h2>\n    ";
  return buffer;
  }

function program44(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div id=\"sidebar-id\">\n            <span> ";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n        </div>\n    ";
  return buffer;
  }

function program46(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div id=\"sidebar-desc\" class=\"sidebar-field\">\n            <div class=\"field-label primary-label\"> Description </div>\n            <span class=\"readonly\"> ";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n        </div>\n    ";
  return buffer;
  }

function program48(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div id=\"sidebar-example\" class=\"sidebar-field\">\n            <div class=\"field-label primary-label\"> Example Query </div>\n            <span class=\"readonly\"> ";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n        </div>\n    ";
  return buffer;
  }

function program50(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div id=\"sidebar-perl_module\" class=\"sidebar-field\">\n            <div class=\"field-label primary-label\"> Perl Module </div>\n            <span class=\"readonly\"> ";
  if (helper = helpers.perl_module) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_module); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " </span>\n        </div>\n    ";
  return buffer;
  }

function program52(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <hr />\n\n    <div id=\"sidebar-pr\">\n        <div class=\"left\">\n            <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"one-line\" id=\"pr\">\n                PR #"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </a>\n        </div>\n        <div class=\"right\" title=\""
    + escapeExpression((helper = helpers.format_time || (depth0 && depth0.format_time),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), options) : helperMissing.call(depth0, "format_time", (depth0 && depth0.last_update), options)))
    + "\">\n            <i class=\"ddgsi ddgsi-clock\" />\n            "
    + escapeExpression((helper = helpers.timeago || (depth0 && depth0.timeago),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.last_update), options) : helperMissing.call(depth0, "timeago", (depth0 && depth0.last_update), options)))
    + "\n        </div>\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.last_comment), {hash:{},inverse:self.noop,fn:self.program(53, program53, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        <span class=\"clearfix\"></span>\n        \n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.all_comments), {hash:{},inverse:self.noop,fn:self.programWithDepth(55, program55, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>        \n";
  return buffer;
  }
function program53(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "\n            <div class=\"right\" id=\"all_comments\">\n                <i class=\"ddgsi ddgsi-comment\" />\n                "
    + escapeExpression((helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.all_comments), options) : helperMissing.call(depth0, "length", (depth0 && depth0.all_comments), options)))
    + "\n            </div>\n        ";
  return buffer;
  }

function program55(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <p class=\"comment\">\n                <a href=\"https://github.com/duckduckgo/zeroclickinfo-"
    + escapeExpression(((stack1 = (depth1 && depth1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/issues/"
    + escapeExpression(((stack1 = ((stack1 = (depth1 && depth1.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "#issuecomment-";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                    ";
  if (helper = helpers.text) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.text); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                </a>\n            </p>\n            <div>by <a href=\"https://github.com/";
  if (helper = helpers.user) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.user); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.user) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.user); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a> "
    + escapeExpression((helper = helpers.timeago || (depth0 && depth0.timeago),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.date), 1, options) : helperMissing.call(depth0, "timeago", (depth0 && depth0.date), 1, options)))
    + "</div>\n        ";
  return buffer;
  }

  buffer += "<div id=\"sidebar-top\" class=\"clearfix ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n  <span class=\"left\">\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.pr), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.program(24, program24, data),fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </span>\n\n    <span id=\"sidebar-close\" class=\"right\"> <i class=\"ddgsi ddgsi-close\"></i> </span>\n</div>\n\n";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.program(41, program41, data),fn:self.program(27, program27, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.issue_id), {hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["dev_pipeline_stats"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, stack3, stack4, helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


  buffer += "<!--<h1>";
  stack1 = (helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), options) : helperMissing.call(depth0, "length", (depth0 && depth0.complete), options));
  stack2 = (helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), options) : helperMissing.call(depth0, "length", (depth0 && depth0.development), options));
  stack3 = (helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), options) : helperMissing.call(depth0, "length", (depth0 && depth0.testing), options));
  stack4 = (helper = helpers.length || (depth0 && depth0.length),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), options) : helperMissing.call(depth0, "length", (depth0 && depth0.planning), options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + " Instant Answers in progress </h1>-->\n\n<h1>Developer Pages</h1>\n\n<a href=\"/ia/dev\" class=\"pipeline__toggle-view__button\" id=\"pipeline_toggle-home\">\n  Home\n</a>\n<a href=\"#\" class=\"pipeline__toggle-view__button button-nav-current disabled\" id=\"pipeline_toggle-dev\">\n  Dev Pipeline\n</a>\n<a href=\"/ia/dev/issues\" class=\"pipeline__toggle-view__button\" id=\"pipeline_toggle-live\">\n  Issues\n</a>\n<a href=\"/ia/dev/deprecated\" class=\"pipeline__toggle-view__button\" id=\"pipeline_toggle-deprecated\">\n  Deprecated\n</a>\n\n\n<!--\n<div class=\"pipeline-stats__created\" id=\"created-stats\">\n<span>Created Today: \n    ";
  stack1 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), 1, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.complete), 1, "less-than", options));
  stack2 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), 1, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.testing), 1, "less-than", options));
  stack3 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), 1, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.development), 1, "less-than", options));
  stack4 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), 1, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.planning), 1, "less-than", options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + "\n</span>\n<span class=\"sep--before\">Created This week: \n    ";
  stack1 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), 7, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.complete), 7, "less-than", options));
  stack2 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), 7, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.testing), 7, "less-than", options));
  stack3 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), 7, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.development), 7, "less-than", options));
  stack4 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), 7, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.planning), 7, "less-than", options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + "\n</span>\n<span class=\"sep--before\">Created in last 30 days: \n    ";
  stack1 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), 30, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.complete), 30, "less-than", options));
  stack2 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), 30, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.testing), 30, "less-than", options));
  stack3 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), 30, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.development), 30, "less-than", options));
  stack4 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), 30, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.planning), 30, "less-than", options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + "\n</span>\n<span class=\"sep--before\">Created in last 60 days: \n    ";
  stack1 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), 60, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.complete), 60, "less-than", options));
  stack2 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), 60, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.testing), 60, "less-than", options));
  stack3 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), 60, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.development), 60, "less-than", options));
  stack4 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), 60, "less-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.planning), 60, "less-than", options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + "\n</span>\n<span class=\"sep--before\">Older than 60 days: \n    ";
  stack1 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.complete), 60, "greater-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.complete), 60, "greater-than", options));
  stack2 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.testing), 60, "greater-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.testing), 60, "greater-than", options));
  stack3 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.development), 60, "greater-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.development), 60, "greater-than", options));
  stack4 = (helper = helpers.stats_from_day || (depth0 && depth0.stats_from_day),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.planning), 60, "greater-than", options) : helperMissing.call(depth0, "stats_from_day", (depth0 && depth0.planning), 60, "greater-than", options));
  buffer += escapeExpression((helper = helpers.sum || (depth0 && depth0.sum),options={hash:{},data:data},helper ? helper.call(depth0, stack4, stack3, stack2, stack1, options) : helperMissing.call(depth0, "sum", stack4, stack3, stack2, stack1, options)))
    + "\n</span>\n</div>\n-->\n";
  return buffer;
  });

this["Handlebars"]["templates"]["devinfo"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <div class=\"ia-single--info\">\n        <h3 class=\"ia-single--header\">\n            <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">ID</span>\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </h3>\n\n        <span class=\"readonly--info ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"id--readonly\">\n            ";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n        </span>\n\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.pr), {hash:{},inverse:self.noop,fn:self.program(14, program14, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    <div class=\"ia-single--info\">\n        <h3 class=\"ia-single--header\">Dev Machine</h3>\n\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.program(30, program30, data),fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program3(depth0,data) {
  
  
  return "class=\"asterisk\"";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program6(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                <a href=\"#\" class=\"devpage-edit ";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-edit-id\">Edit</a>\n                <a href=\"#\" class=\"devpage-commit sep--after ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-commit-id\">Commit</a>\n                <a href=\"#\" class=\"devpage-cancel ";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-cancel-id\">Cancel</a>\n            ";
  return buffer;
  }
function program7(depth0,data) {
  
  
  return "hide";
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <input type=\"text\" class=\"";
  stack1 = (helper = helpers.n_exists || (depth0 && depth0.n_exists),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "n_exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " frm__input id js-autocommit hidden-toshow\" id=\"id-input\" value=\"";
  stack1 = (helper = helpers.exists || (depth0 && depth0.exists),options={hash:{},inverse:self.program(12, program12, data),fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "id", options) : helperMissing.call(depth0, "exists", (depth0 && depth0.staged), "id", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" />\n            <span class=\"error-notification hide\">ID can't be empty</span>\n        ";
  return buffer;
  }
function program10(depth0,data) {
  
  var stack1;
  return escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  }

function program12(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program14(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div class=\"ia-single--info\">\n            <h3 class=\"ia-single--header\">PR #</h3>\n            <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"one-line\" id=\"pr\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </a>\n        </div>\n    ";
  return buffer;
  }

function program16(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(23, program23, data),fn:self.program(17, program17, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.beta_install), "success", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.beta_install), "success", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program17(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <p>Installed on <a href=\"http://beta.duckduckgo.com/";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta_query), {hash:{},inverse:self.noop,fn:self.program(18, program18, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">beta</a></p>\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.noop,fn:self.program(20, program20, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program18(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "?q=";
  if (helper = helpers.beta_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.beta_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1);
  return buffer;
  }

function program20(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    <div class=\"button btn--primary ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.beta), {hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"beta-install\">Re-install on beta</div>\n                ";
  return buffer;
  }
function program21(depth0,data) {
  
  
  return "disabled";
  }

function program23(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta_install), {hash:{},inverse:self.noop,fn:self.program(24, program24, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.pr)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.program(28, program28, data),fn:self.program(26, program26, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program24(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    <p class=\"not-saved\">Install on beta failed: ";
  if (helper = helpers.beta_install) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.beta_install); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</p>\n                ";
  return buffer;
  }

function program26(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    <div class=\"button btn--primary ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.beta), {hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"beta-install\">Install on beta</div>\n                ";
  return buffer;
  }

function program28(depth0,data) {
  
  
  return "\n                    <p> Can't install on beta without a PR </p>\n                ";
  }

function program30(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <span class=\"readonly--info\" id=\"test_machine--readonly\">\n                ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(33, program33, data),fn:self.program(31, program31, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.beta_install), "success", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.beta_install), "success", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </span>\n        ";
  return buffer;
  }
function program31(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    Installed on <a href=\"http://beta.duckduckgo.com/";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.beta_query), {hash:{},inverse:self.noop,fn:self.program(18, program18, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">beta</a>\n                ";
  return buffer;
  }

function program33(depth0,data) {
  
  
  return "\n                    <span class=\"no-available\">\n                        Not yet installed on beta\n                    </span>\n                ";
  }

function program35(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(36, program36, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program36(depth0,data) {
  
  
  return "\n            <a href=\"#\" class=\"devpage-edit-popup\" id=\"dev-edit-contributors\">Edit</a>\n            <div id=\"edit-modal\" class=\"hide\"></div>\n        ";
  }

function program38(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(39, program39, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n      ";
  return buffer;
  }
function program39(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n          <li><a href=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"one-line\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></li>\n        ";
  return buffer;
  }

function program41(depth0,data) {
  
  
  return "\n        <span class=\"no-available\">No contributors yet.</span>\n      ";
  }

function program43(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <h3 class=\"ia-single--header\">Back-End Files</h3>\n    <ul>\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.back_end), {hash:{},inverse:self.noop,fn:self.programWithDepth(44, program44, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n  ";
  return buffer;
  }
function program44(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <li>\n        <a class=\"one-line\" href=\"https://github.com/duckduckgo/zeroclickinfo-"
    + escapeExpression(((stack1 = (depth1 && depth1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/tree/master/"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\">"
    + escapeExpression((helper = helpers.final_path || (depth0 && depth0.final_path),options={hash:{},data:data},helper ? helper.call(depth0, depth0, options) : helperMissing.call(depth0, "final_path", depth0, options)))
    + "</a>\n        </li>\n      ";
  return buffer;
  }

function program46(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <h3 class=\"ia-single--header\">Front-End Files</h3>\n    <ul>\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.front_end), {hash:{},inverse:self.noop,fn:self.programWithDepth(44, program44, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n  ";
  return buffer;
  }

function program48(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div class=\"producer-contributor\">\n            <h3 class=\"second-header\">Producer</h3>\n            <div class=\"half half--screen-s frm__input\">\n                <input type=\"text\" class=\"producer js-autocommit hidden-toshow team-input\" id=\"producer-input\" value=\"";
  if (helper = helpers.producer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.producer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n                <span class=\"pull-right hide\"><i class=\"ddgsi-check-sign\"></i></span>\n                <span class=\"pull-right hide\"><i class=\"ddgsi ddgsi-warning\"></i></span>\n            </div>\n            <div class=\"half half--screen-s g\">\n              <div class=\"js-autocommit hidden-toshow assign-button btn eighty\" id=\"producer-button\">\n                Assign to me\n              </div>\n            </div>\n        </div>\n    ";
  return buffer;
  }

function program50(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(51, program51, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program51(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                <li class=\"js-autocommit hidden-toshow developer\">\n                    <div class=\"half half--screen-s frm__input\">\n                        <span class=\"developer_username type-";
  if (helper = helpers.type) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.type); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                            <input type=\"text\" class=\"group-vals\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(54, program54, data),fn:self.program(52, program52, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "legacy", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "legacy", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "/>\n                        </span>\n                        <span class=\"pull-right hide\"><i class=\"ddgsi-check-sign\"></i></span>\n                        <span class=\"pull-right hide\"><i class=\"ddgsi-warning\"></i></span>\n                    </div>\n                    <div class=\"half half--screen-s g\">\n                        <span class=\"frm__select eighty\">\n                            <select class=\"available_types left\" tabindex=\"-1\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(56, program56, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "legacy", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "legacy", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.type), {hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(60, program60, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "duck.co", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "duck.co", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(62, program62, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "github", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "github", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(64, program64, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "ddg", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "ddg", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            </select>\n                        </span>\n                        <span class=\"delete twenty g\"><i class=\"ddgsi-close\"></i></span>\n                    </div>\n                </li>\n            ";
  return buffer;
  }
function program52(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "value=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" disabled=\"disabled\"";
  return buffer;
  }

function program54(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "value=\""
    + escapeExpression((helper = helpers.final_path || (depth0 && depth0.final_path),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.url), options) : helperMissing.call(depth0, "final_path", (depth0 && depth0.url), options)))
    + "\"";
  return buffer;
  }

function program56(depth0,data) {
  
  
  return "disabled=\"disabled\"";
  }

function program58(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "<option value=\"0\">";
  if (helper = helpers.type) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.type); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>";
  return buffer;
  }

function program60(depth0,data) {
  
  
  return "<option value=\"1\">duck.co</option>";
  }

function program62(depth0,data) {
  
  
  return "<option value=\"2\">github</option>";
  }

function program64(depth0,data) {
  
  
  return "<option value=\"3\">ddg</option>";
  }

  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n<div class=\"ia-attribution ia-single--info\">\n    <h3 class=\"ia-single--header\">Contributors\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </h3>\n    <ul>\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.program(41, program41, data),fn:self.program(38, program38, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"ia-single--info\">\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.back_end), {hash:{},inverse:self.noop,fn:self.program(43, program43, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n\n<div class=\"ia-single--info\">\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.front_end), {hash:{},inverse:self.noop,fn:self.program(46, program46, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n\n<div class=\"hide edit-popup\" id=\"contributors-popup\">\n    <h3 class=\"ia-single--header\">Contributors</h3>\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(48, program48, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    <span class=\"clearfix\"></span>\n\n    <h3 class=\"second-header\">Developer</h3>\n    <ul class=\"parent-group\" id=\"developer-group\">\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(50, program50, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        <li class=\"hide new_input js-autocommit hidden-toshow developer\">\n            <div class=\"half half--screen-s frm__input\">\n                <span class=\"developer_username\">\n                    <input class=\"group-vals\" type=\"text\"/>\n                </span>\n                <span class=\"pull-right hide\"><i class=\"ddgsi-check-sign\"></i></span>\n                <span class=\"pull-right hide\"><i class=\"ddgsi-warning\"></i></span>\n            </div>\n            <div class=\"half half--screen-s g\">\n                <span class=\"frm__select eighty\">\n                  <select class=\"available_types\" tabindex=\"-1\">\n                    <option value=\"0\">duck.co</option>\n                    <option value=\"1\">github</option>\n                    <option value=\"3\">ddg</option>\n                  </select>\n                </span>\n                <span class=\"delete twenty g\"><i class=\"ddgsi-close\"></i></span>\n            </div>\n        </li>\n        <li id=\"add_developer\">\n            <a href=\"#\" class=\"one-line add_input left\" id=\"add_developer\" title=\"Add developer\">\n               Add Developer\n            </a>\n        </li>\n    </ul>\n\n    <span class=\"clearfix\"></span>\n\n    <div class=\"cancel-save\">\n        <div class=\"btn pull-left cancel-button-popup\">Cancel</div>\n        <div class=\"btn btn--primary pull-right save-button-popup\">Save</div>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_answerbar"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-answerbar\">\n    <div class=\"column-right-edits__child js-editable\" id=\"answerbar\" name=\"answerbar\">\n        <input type=\"number\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"column-right-edits__child__input js-input\" name=\"answerbar\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_api_status_page"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-api_status_page\">\n    <div class=\"column-right-edits__child js-editable\" id=\"api_status_page\" name=\"api_status_page\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.api_status_page) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.api_status_page); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"api_status_page\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_blockgroup"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-blockgroup\">\n    <div class=\"column-right-edits__child js-editable\" id=\"blockgroup\" blockgroup=\"blockgroup\">\n        <div class=\"ia_blockgroup left\">\n            <span class=\"editable left\" name=\"blockgroup\">\n                <select class=\"available_blockgroups\" tabindex=\"-1\">\n                    <option value=\"0\">";
  if (helper = helpers.blockgroup) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.blockgroup); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                </select>\n            </span>\n        </div>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_buttons"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.asana), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <a href=\"https://app.asana.com/0/0/"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.asana)),stack1 == null || stack1 === false ? stack1 : stack1.asana_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">One open task</a>\n    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n        <div class=\"btn btn--wire--hero\" id=\"asana_button\">\n            Create a task\n        </div>\n     ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.program(15, program15, data),fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.edit_count), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program8(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <div class=\"preview-edits\">\n                <span class=\"";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " pending-edits\">";
  if (helper = helpers.edit_count) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.edit_count); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " Pending "
    + escapeExpression((helper = helpers.plural || (depth0 && depth0.plural),options={hash:{
    'plural': ("Edits"),
    'singular': ("Edit")
  },data:data},helper ? helper.call(depth0, (depth0 && depth0.edit_count), options) : helperMissing.call(depth0, "plural", (depth0 && depth0.edit_count), options)))
    + "</span>\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </div>\n            <div class=\"preview-switch ";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.preview), options) : helperMissing.call(depth0, "is_false", (depth0 && depth0.preview), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                <span class=\"preview-switch__label pull-left\">Edited</span>\n                <a class=\"switch js-switch\" href=\"#\">\n                    <div class=\"switch__bar\"></div>\n                    <span class=\"switch__knob\"></span>\n                </a>\n                <span class=\"preview-switch__label\">Live</span>\n            </div>\n        ";
  return buffer;
  }
function program9(depth0,data) {
  
  
  return "sep--after";
  }

function program11(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    <a href=\"/ia/commit/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">Commit</a>\n                ";
  return buffer;
  }

function program13(depth0,data) {
  
  
  return "is-on";
  }

function program15(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div class=\"view-json\">\n            <a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/json\">View JSON</a>\n        </div>\n        <div class=\"action-buttons\">\n            <div class=\"";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields), {hash:{},inverse:self.noop,fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " btn btn--wire--hero btn--inline left\" id=\"js-top-details-submit\">Submit</div>\n            <div class=\"";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields), {hash:{},inverse:self.noop,fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " btn btn--wire--hero btn--inline left\" id=\"js-top-details-cancel\">Cancel</div>\n            <span class=\"clearfix\"></span>\n        </div>\n    ";
  return buffer;
  }
function program16(depth0,data) {
  
  
  return "is-disabled";
  }

  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_deployment_state"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "<option value=\"1\"> --- </option>";
  }

function program3(depth0,data) {
  
  
  return "<option value=\"2\">live</option>";
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-deployment_state\">\n    <div class=\"column-right-edits__child js-editable\" id=\"deployment_state\" deployment_state=\"deployment_state\">\n        <div class=\"ia_deployment_state left\">\n            <span class=\"editable left\" name=\"deployment_state\">\n                <select class=\"available_deployment_states\" tabindex=\"-1\">\n                    <option value=\"0\">";
  if (helper = helpers.deployment_state) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.deployment_state); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.deployment_state), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.deployment_state), "live", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.deployment_state), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </select>\n            </span>\n        </div>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_description"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-description\">\n    <div class=\"column-right-edits__child js-editable\" id=\"description\" name=\"description\">\n      <textarea placeholder=\"Add description ...\">";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</textarea>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_designer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-designer\">\n    <div class=\"column-right-edits__child js-editable\" id=\"designer\" name=\"designer\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.designer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.designer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"designer\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_dev_milestone"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-dev_milestone\">\n    <div class=\"column-right-edits__child js-editable\" id=\"dev_milestone\" dev_milestone=\"dev_milestone\">\n        <div class=\"ia_dev_milestone left\">\n            <span class=\"editable left\" name=\"dev_milestone\">\n                <select class=\"available_dev_milestones\" tabindex=\"-1\">\n                    <option value=\"0\">";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                    <option value=\"1\">planning</option>\n                    <option value=\"2\">development</option>\n                    <option value=\"3\">testing</option>\n                    <option value=\"4\">complete</option>\n                    <option value=\"5\">live</option>\n                    <option value=\"6\">deprecated</option>\n                    <option value=\"7\">ghosted</option>\n                </select>\n            </span>\n        </div>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_developer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <li class=\"editpage left\">\n                        <div class=\"button delete listbutton left\" name=\"developer\" title=\"Remove this developer\">\n                            <i class=\"icon-remove\" />\n                        </div>\n                        <span name=\"developer\" class=\"developer left\">\n                            <input type=\"text\" value=\""
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "legacy", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "legacy", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "/>\n                        </span>\n                        <span>\n                            <select class=\"available_types left\" tabindex=\"-1\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "legacy", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "legacy", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.type), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "duck.co", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "duck.co", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "github", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "github", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "ddg", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.type), "ddg", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            </select>\n                        </span>\n                        <span class=\"developer_username left type-"
    + escapeExpression(((stack1 = (depth0 && depth0.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                            <input type=\"text\" ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(15, program15, data),fn:self.program(13, program13, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "legacy", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "legacy", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "/>\n                        </span>\n                    </li>\n                    <span class=\"clearfix\"></span>\n                ";
  return buffer;
  }
function program3(depth0,data) {
  
  
  return "disabled=\"disabled\"";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<option value=\"0\">"
    + escapeExpression(((stack1 = (depth0 && depth0.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</option>";
  return buffer;
  }

function program7(depth0,data) {
  
  
  return "<option value=\"1\">duck.co</option>";
  }

function program9(depth0,data) {
  
  
  return "<option value=\"2\">github</option>";
  }

function program11(depth0,data) {
  
  
  return "<option value=\"3\">ddg</option>";
  }

function program13(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "value=\""
    + escapeExpression(((stack1 = (depth0 && depth0.url)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" disabled=\"disabled\"";
  return buffer;
  }

function program15(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "value=\""
    + escapeExpression((helper = helpers.final_path || (depth0 && depth0.final_path),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.url), options) : helperMissing.call(depth0, "final_path", (depth0 && depth0.url), options)))
    + "\"";
  return buffer;
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-developer\">\n    <div class=\"column-right-edits__child js-editable\" id=\"developer\" name=\"developer\">\n        <ul>\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            <li class=\"editpage hide left new_input\">\n                <div class=\"button delete listbutton left\" name=\"developer\" title=\"Remove this developer\">\n                    <i class=\"icon-remove\" />\n                </div>\n                <span name=\"developer\" class=\"editable developer left\" id=\"input_developer\">\n                    <input type=\"text\" value=\"\" />\n                </span>\n                <select class=\"available_types left\" tabindex=\"-1\">\n                    <option value=\"0\">duck.co</option>\n                    <option value=\"1\">github</option>\n                    <option value=\"2\">ddg</option>\n                </select>\n                <span class=\"developer_username left\">\n                    <input type=\"text\"/>\n                </span>\n            </li>\n            <li class=\"editpage left add_input\" id=\"add_developer\">\n                <div class=\"button listbutton left\" id=\"add_developer_button\" title=\"Add example\">\n                    <i class=\"icon-plus\" />\n                </div>\n            </li>\n        </ul>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_example_query"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-example_query\">\n    <div class=\"column-right-edits__child js-section-editable\" id=\"examples\" name=\"examples\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"example_query\" />\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_id"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-id\">\n    <div class=\"column-right-edits__child js-editable\" id=\"id\" name=\"id\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"id\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_is_stackexchange"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "-empty";
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-is_stackexchange\">\n    <div class=\"column-right-edits__child js-editable\" id=\"is_stackexchange\" name=\"is_stackexchange\">\n        <i class=\"js-editable icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.is_stackexchange), options) : helperMissing.call(depth0, "is_false", (depth0 && depth0.is_stackexchange), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_stackexchange-check\"/>\n        Is Stack Exchange\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_name"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-name\">\n    <div class=\"column-right-edits__child js-editable\" id=\"name\" name=\"name\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"name\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_other_queries"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                    <li class=\"editpage left\">\n                        <div class=\"button delete listbutton left\" name=\"other_queries\" title=\"Remove this example\">\n                            <i class=\"icon-remove\" />\n                        </div>\n                        <span title=\"try this example on DuckDuckGo\" name=\"other_queries\" class=\"editable other_queries left\">\n                            <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" />\n                        </span>\n                    </li>\n                    <span class=\"clearfix\"></span>\n                ";
  return buffer;
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-other_queries\">\n    <div class=\"column-right-edits__child js-section-editable\" id=\"other_queries\" name=\"other_queries\">\n        <ul>\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            <li class=\"editpage hide left new_input\" id=\"input_example\">\n                <div class=\"button delete listbutton left\" name=\"example_query\" title=\"Remove this example\">\n                    <i class=\"icon-remove\" />\n                </div>\n                <span name=\"other_queries\" class=\"editable other_queries left\" id=\"input_example\">\n                    <input type=\"text\" value=\"\" />\n                </span>\n            </li>\n            <li class=\"editpage left add_input\" id=\"add_example\">\n                <div class=\"button listbutton left\" id=\"add_example_button\" title=\"Add example\">\n                    <i class=\"icon-plus\" />\n                </div>\n            </li>\n        </ul>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_perl_dependencies"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                    <li class=\"editpage left\">\n                        <div class=\"button delete listbutton left\" name=\"perl_dependencies\" title=\"Remove perl_dependencies\">\n                            <i class=\"icon-remove\" />\n                        </div>\n                        <span name=\"perl_dependencies\" class=\"editable perl_dependencies left\">\n                            <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" />\n                        </span>\n                    </li>\n                    <span class=\"clearfix\"></span>\n                ";
  return buffer;
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-perl_dependencies\">\n    <div class=\"column-right-edits__child js-section-editable\" id=\"perl_dependencies\" name=\"perl_dependencies\">\n        <ul>\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            <li class=\"editpage hide left new_input\" id=\"input_perl_dependencies\">\n                <div class=\"button delete listbutton left\" title=\"Remove perl_dependencies\">\n                    <i class=\"icon-remove\" />\n                </div>\n                <span name=\"perl_dependencies\" class=\"editable perl_dependencies left\" id=\"input_perl_dependencies\">\n                    <input type=\"text\" value=\"\" />\n                </span>\n            </li>\n            <li class=\"editpage left add_input\" id=\"add_perl_dependencies\">\n                <div class=\"button listbutton left\" id=\"add_perl_dependencies_button\" title=\"Add perl_dependencies\">\n                    <i class=\"icon-plus\" />\n                </div>\n            </li>\n        </ul>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_perl_module"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-perl_module\">\n    <div class=\"column-right-edits__child js-editable\" id=\"perl_module\" name=\"perl_module\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.perl_module) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.perl_module); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"perl_module\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_producer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-producer\">\n    <div class=\"column-right-edits__child js-editable\" id=\"producer\" name=\"producer\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.producer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.producer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"producer\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_repo"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "<option value=\"1\">spice</option>";
  }

function program3(depth0,data) {
  
  
  return "<option value=\"2\">goodies</option>";
  }

function program5(depth0,data) {
  
  
  return "<option value=\"3\">fathead</option>";
  }

function program7(depth0,data) {
  
  
  return "<option value=\"4\">longtail</option>";
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-repo\">\n    <div class=\"column-right-edits__child js-editable\" id=\"repo\" repo=\"repo\">\n        <div class=\"ia_repo left\">\n            <span class=\"editable left\" name=\"repo\">\n                <select class=\"available_repos\" tabindex=\"-1\">\n                    <option value=\"0\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                    ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "goodies", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "goodies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "longtail", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </select>\n            </span>\n        </div>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_src_api_documentation"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-src_api_documentation\">\n    <div class=\"column-right-edits__child js-editable\" id=\"src_api_documentation\" name=\"src_api_documentation\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.src_api_documentation) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_api_documentation); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"src_api_documentation\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_src_domain"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-src_domain\">\n    <div class=\"column-right-edits__child js-editable\" id=\"src_domain\" name=\"src_domain\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.src_domain) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_domain); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"src_domain\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_src_id"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-src_id\">\n    <div class=\"column-right-edits__child js-editable\" id=\"src_id\" name=\"src_id\">\n        <input type=\"number\" value=\"";
  if (helper = helpers.src_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"src_id\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_src_name"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-src_name\">\n    <div class=\"column-right-edits__child js-editable\" id=\"src_name\" name=\"src_name\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.src_name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.src_name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"src_name\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_src_options"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "-empty";
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-src_options\">\n    <div class=\"column-right-edits__child js-editable \" id=\"src_options\" name=\"src_options\">\n        <ul class=\"section-group\" id=\"src_options-group\">\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract-check\"/>\n                <span class=\"check-txt\">\n                    Skip abstract\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract_paren-check\"/>\n                <span class=\"check-txt\">\n                    Skip abstract parent\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_icon-check\"/>\n                <span class=\"check-txt\">\n                    Skip icon\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_image_name-check\"/>\n                <span class=\"check-txt\">\n                    Skip image name\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_wikipedia-check\"/>\n                <span class=\"check-txt\">\n                    Is Wikipedia\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_mediawiki-check\"/>\n                <span class=\"check-txt\">\n                    Is MediaWiki\n                </span>\n            </li>\n            <li>\n                <i class=\"section-group__item js-editable icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_fanon-check\"/>\n                <span class=\"check-txt\">\n                    Is Fanon\n                </span>\n            </li>\n            <li>\n                <label class=\"left\">Source skip: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"source_skip-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.source_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n            <li>\n                <label class=\"left\">Skip query: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"skip_qr-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n            <li>\n                <label class=\"left\">Directory: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"directory-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n            <li>\n                <label class=\"left\">Minimum abstract length: </label>\n                <input type=\"number\" step=\"1\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"min_abstract_length-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" /> \n            </li>\n            <li>\n                <label class=\"left\">Source info: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"src_info-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n            <li>\n                <label class=\"left\">Skip end: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"skip_end-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_end)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n            <li>\n                <label class=\"left\">Language: </label>\n                <input type=\"text\" class=\"clearfix section-group__item js-editable selection-group__item-input\" id=\"language-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n            </li>\n        </ul>   \n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_status"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-status\">\n    <div class=\"column-right-edits__child js-editable\" id=\"status\" name=\"status\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.status) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.status); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"status\"/>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_tab"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-tab\">\n    <div class=\"column-right-edits__child js-editable\" id=\"tab\" name=\"tab\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.tab) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.tab); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"tab\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_template"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-template\">\n    <div class=\"column-right-edits__child js-editable\" id=\"template\" name=\"template\">\n        <input type=\"text\" value=\"";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"column-right-edits__child__input js-input\" name=\"template\"/>\n    </div>\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_topic"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", helper, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-topic\">\n    <div class=\"column-right-edits__child js-section-editable\" id=\"topic\" name=\"topic\">\n        <div class=\"separator ia_topic\">\n            <div class=\"button delete listbutton left\" name=\"topic\" title=\"Remove this topic\">\n                <i class=\"icon-remove\" />\n            </div>\n            <select class=\"available_topics left\" id=\"first-topic-select\">\n                <option value=\"0\">"
    + escapeExpression((helper = helpers.index || (depth0 && depth0.index),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), 0, options) : helperMissing.call(depth0, "index", (depth0 && depth0.topic), 0, options)))
    + "</option>\n            </select>\n            <span class=\"clearfix\"></span>\n        </div>\n        <div class=\"separator ia_topic\">\n            <div class=\"button delete listbutton left\" name=\"topic\" title=\"Remove this topic\">\n                <i class=\"icon-remove\" />\n            </div>\n            <select class=\"available_topics left\" id=\"second-topic-select\">\n                <option value=\"1\">"
    + escapeExpression((helper = helpers.index || (depth0 && depth0.index),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), 1, options) : helperMissing.call(depth0, "index", (depth0 && depth0.topic), 1, options)))
    + "</option>\n            </select>\n            <span class=\"clearfix\"></span>\n        </div>\n        <div class=\"separator ia_topic\">\n            <div class=\"button delete listbutton left\" name=\"topic\" title=\"Remove this topic\">\n                <i class=\"icon-remove\" />\n            </div>\n            <select class=\"available_topics\" id=\"third-topic-select\">\n                <option value=\"2\">"
    + escapeExpression((helper = helpers.index || (depth0 && depth0.index),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), 2, options) : helperMissing.call(depth0, "index", (depth0 && depth0.topic), 2, options)))
    + "</option>\n            </select>\n            <span class=\"clearfix\"></span>\n        </div>\n        <span class=\"clearfix\"></span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_triggers"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                    <li class=\"editpage left\">\n                        <div class=\"button delete listbutton left\" name=\"triggers\" title=\"Remove trigger\">\n                            <i class=\"icon-remove\" />\n                        </div>\n                        <span name=\"triggers\" class=\"editable triggers left\">\n                            <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" />\n                        </span>\n                    </li>\n                    <span class=\"clearfix\"></span>\n                ";
  return buffer;
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-triggers\">\n    <div class=\"column-right-edits__child js-section-editable\" id=\"triggers\" name=\"triggers\">\n        <ul>\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            <li class=\"editpage hide left new_input\" id=\"input_triggers\">\n                <div class=\"button delete listbutton left\" title=\"Remove trigger\">\n                    <i class=\"icon-remove\" />\n                </div>\n                <span name=\"triggers\" class=\"editable triggers left\" id=\"input_triggers\">\n                    <input type=\"text\" value=\"\" />\n                </span>\n            </li>\n            <li class=\"editpage left add_input\" id=\"add_trigger\">\n                <div class=\"button listbutton left\" id=\"add_trigger_button\" title=\"Add trigger\">\n                    <i class=\"icon-plus\" />\n                </div>\n            </li>\n        </ul>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["edit_unsafe"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "-empty";
  }

  buffer += "<div class=\"column-right-edits left\" id=\"column-edits-unsafe\">\n    <div class=\"column-right-edits__child js-check js-editable\" id=\"unsafe\" name=\"unsafe\">\n        <i class=\"js-editable icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.unsafe), options) : helperMissing.call(depth0, "is_false", (depth0 && depth0.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"unsafe-check\"/>\n        Unsafe\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["examples"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program2(depth0,data) {
  
  
  return "hide";
  }

function program4(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program5(depth0,data) {
  
  
  return "class=\"asterisk\"";
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <a href=\"#\" class=\"devpage-edit ";
  stack1 = (helper = helpers.or || (depth0 && depth0.or),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options) : helperMissing.call(depth0, "or", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-edit-example_query\">Edit</a>\n            <a href=\"#\" class=\"devpage-commit sep--after ";
  stack1 = (helper = helpers.unless_and || (depth0 && depth0.unless_and),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options) : helperMissing.call(depth0, "unless_and", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-commit-example_query\">Commit</a>\n            <a href=\"#\" class=\"devpage-cancel ";
  stack1 = (helper = helpers.unless_and || (depth0 && depth0.unless_and),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options) : helperMissing.call(depth0, "unless_and", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-cancel-example_query\">Cancel</a>\n        ";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <ul class=\"hidden-toshow ";
  stack1 = (helper = helpers.unless_and || (depth0 && depth0.unless_and),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options) : helperMissing.call(depth0, "unless_and", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " parent-group\" id=\"other_queries-group\">\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n             ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.programWithDepth(28, program28, data, depth0),fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n            <li class=\"editpage hide new_input\">\n                <span class=\"other_queries\">\n                    <input type=\"text\" value=\"\" class=\"js-autocommit group-vals\" />\n                    <span class=\"delete-tag delete\"><i class=\"ddgsi-close\"></i></span>\n                </span>\n            </li>\n            <li class=\"editpage add_input\" id=\"add_example\">\n                <div class=\"btn btn--secondary listbutton\" id=\"add_example_button\" title=\"Add example\">\n                    <i class=\"ddgsi-plus\" />\n                </div>\n            </li>\n        </ul>\n    ";
  return buffer;
  }
function program10(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <li ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), "n---d", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), "n---d", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                        <span class=\"example_query\">\n                            <input type=\"text\" id=\"example_query-input\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"example_query js-autocommit\" />\n                            <span class=\"delete-tag delete\"><i class=\"ddgsi-close\"></i></span>\n                        </span>\n                    </li>\n             ";
  return buffer;
  }
function program11(depth0,data) {
  
  
  return "class=\"hide\"";
  }

function program13(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.noop,fn:self.programWithDepth(14, program14, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program14(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <li ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), "[]", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), "[]", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                        <span class=\"";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.program(16, program16, data),fn:self.programWithDepth(15, program15, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                            <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" ";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.noop,fn:self.programWithDepth(20, program20, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            class=\"js-autocommit ";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.program(16, program16, data),fn:self.programWithDepth(23, program23, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" />\n                            <span class=\"delete delete-tag\" title=\"Remove example\">\n                                <i class=\"ddgsi-close\"></i>\n                            </span>\n                       </span>\n                    </li>\n                    ";
  stack1 = (helper = helpers.module_zero || (depth0 && depth0.module_zero),options={hash:{},inverse:self.noop,fn:self.program(26, program26, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.index), 3, options) : helperMissing.call(depth0, "module_zero", (data == null || data === false ? data : data.index), 3, options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program15(depth0,data,depth2) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth2 && depth2.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.program(18, program18, data),fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program16(depth0,data) {
  
  
  return "example_query";
  }

function program18(depth0,data) {
  
  
  return "other_queries";
  }

function program20(depth0,data,depth2) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth2 && depth2.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program21(depth0,data) {
  
  
  return "id=\"example_query-input\"";
  }

function program23(depth0,data,depth2) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth2 && depth2.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.program(24, program24, data),fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program24(depth0,data) {
  
  
  return "group-vals";
  }

function program26(depth0,data) {
  
  
  return "\n                        <span class=\"clearfix\"></span>\n                    ";
  }

function program28(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(29, program29, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.noop,fn:self.programWithDepth(31, program31, data, depth0, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program29(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    <li ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                        <span class=\"example_query\">\n                            <input type=\"text\" id=\"example_query-input\" value=\"";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"example_query js-autocommit\" />\n                            <span class=\"delete-tag delete\"><i class=\"ddgsi-close\"></i></span>\n                        </span>\n                    </li>\n                ";
  return buffer;
  }

function program31(depth0,data,depth1,depth2) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <li ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                        <span class=\"";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.program(18, program18, data),fn:self.programWithDepth(32, program32, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                            <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" class=\"js-autocommit ";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.program(24, program24, data),fn:self.programWithDepth(34, program34, data, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" ";
  stack1 = helpers.unless.call(depth0, (depth2 && depth2.example_query), {hash:{},inverse:self.noop,fn:self.program(36, program36, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "/>\n                            <span class=\"delete-tag delete\"><i class=\"ddgsi-close\"></i></span>\n                        </span>\n                    </li>\n                    ";
  stack1 = (helper = helpers.module_zero || (depth2 && depth2.module_zero),options={hash:{},inverse:self.noop,fn:self.program(26, program26, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.index), 3, options) : helperMissing.call(depth0, "module_zero", (data == null || data === false ? data : data.index), 3, options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program32(depth0,data,depth2) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, (depth2 && depth2.example_query), {hash:{},inverse:self.program(16, program16, data),fn:self.program(18, program18, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program34(depth0,data,depth2) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, (depth2 && depth2.example_query), {hash:{},inverse:self.program(16, program16, data),fn:self.program(24, program24, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program36(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program38(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.program(44, program44, data),fn:self.program(39, program39, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program39(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.test_machine), {hash:{},inverse:self.program(42, program42, data),fn:self.program(40, program40, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program40(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <a class=\"one-line\" href=\"https://";
  if (helper = helpers.test_machine) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.test_machine); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ".duckduckgo.com/?q="
    + escapeExpression((helper = helpers.encodeURIComponent || (depth0 && depth0.encodeURIComponent),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.example_query), options) : helperMissing.call(depth0, "encodeURIComponent", (depth0 && depth0.example_query), options)))
    + escapeExpression((helper = helpers.tab_url || (depth0 && depth0.tab_url),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.tab), options) : helperMissing.call(depth0, "tab_url", (depth0 && depth0.tab), options)))
    + "\" title=\"try this example on DuckDuckGo\">";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                ";
  return buffer;
  }

function program42(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    <span>";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n                ";
  return buffer;
  }

function program44(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                <a class=\"one-line\" href=\"https://duckduckgo.com/?q="
    + escapeExpression((helper = helpers.encodeURIComponent || (depth0 && depth0.encodeURIComponent),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.example_query), options) : helperMissing.call(depth0, "encodeURIComponent", (depth0 && depth0.example_query), options)))
    + escapeExpression((helper = helpers.tab_url || (depth0 && depth0.tab_url),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.tab), options) : helperMissing.call(depth0, "tab_url", (depth0 && depth0.tab), options)))
    + "\" title=\"try this example on DuckDuckGo\">";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n            ";
  return buffer;
  }

function program46(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n            ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.noop,fn:self.programWithDepth(47, program47, data, depth0, depth1),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program47(depth0,data,depth1,depth2) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                ";
  stack1 = (helper = helpers.ne_and || (depth2 && depth2.ne_and),options={hash:{},inverse:self.programWithDepth(53, program53, data, depth1),fn:self.programWithDepth(48, program48, data, depth1),data:data},helper ? helper.call(depth0, (depth2 && depth2.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth2 && depth2.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program48(depth0,data,depth2) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers['if'].call(depth0, (depth2 && depth2.test_machine), {hash:{},inverse:self.program(51, program51, data),fn:self.programWithDepth(49, program49, data, depth2),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program49(depth0,data,depth3) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        <a class=\"one-line\" href=\"https://"
    + escapeExpression(((stack1 = (depth3 && depth3.test_machine)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + ".duckduckgo.com/?q="
    + escapeExpression((helper = helpers.encodeURIComponent || (depth0 && depth0.encodeURIComponent),options={hash:{},data:data},helper ? helper.call(depth0, depth0, options) : helperMissing.call(depth0, "encodeURIComponent", depth0, options)))
    + escapeExpression((helper = helpers.tab_url || (depth3 && depth3.tab_url),options={hash:{},data:data},helper ? helper.call(depth0, (depth3 && depth3.tab), options) : helperMissing.call(depth0, "tab_url", (depth3 && depth3.tab), options)))
    + "\" title=\"try this example on DuckDuckGo\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</a>\n                    ";
  return buffer;
  }

function program51(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <span>"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</span>\n                    ";
  return buffer;
  }

function program53(depth0,data,depth2) {
  
  var buffer = "", helper, options;
  buffer += "\n                    <a class=\"one-line\" href=\"https://duckduckgo.com/?q="
    + escapeExpression((helper = helpers.encodeURIComponent || (depth0 && depth0.encodeURIComponent),options={hash:{},data:data},helper ? helper.call(depth0, depth0, options) : helperMissing.call(depth0, "encodeURIComponent", depth0, options)))
    + escapeExpression((helper = helpers.tab_url || (depth2 && depth2.tab_url),options={hash:{},data:data},helper ? helper.call(depth0, (depth2 && depth2.tab), options) : helperMissing.call(depth0, "tab_url", (depth2 && depth2.tab), options)))
    + "\" title=\"try this example on DuckDuckGo\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</a>\n                ";
  return buffer;
  }

function program55(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <div class=\"no-available ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">No example queries.</div>\n        ";
  return buffer;
  }

function program57(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <div class=\"example-container\">\n      ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", "development", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "planning", "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(60, program60, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", "development", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "planning", "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      <span class=\"clearfix\"></span>\n    </div>\n";
  return buffer;
  }
function program58(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <div class=\"search-example pull-left\">\n            <span class=\"ddgsi-loupe\"></span> <span>";
  if (helper = helpers.example_query) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.example_query); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n        </div>\n      ";
  return buffer;
  }

function program60(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n          <div class=\"pull-right screenshot-switcher\">\n            <span class=\"btn switcher-icon\">\n              <span class=\"platform-desktop\"><span class=\"path1\"></span><span class=\"path2\"></span></span>\n            </span>\n\n            <span class=\"btn switcher-icon remove-border\">\n              <span class=\"platform-mobile add-opacity\"><span class=\"path1\"></span><span class=\"path2\"></span></span>\n            </span>\n          </div>\n\n          ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(61, program61, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n          ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.programWithDepth(64, program64, data, depth0),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  return buffer;
  }
function program61(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.can_show), {hash:{},inverse:self.noop,fn:self.program(62, program62, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n          ";
  return buffer;
  }
function program62(depth0,data) {
  
  
  return "\n                <div class=\"pull-right screenshot-switcher--generate hide\">\n                  <span class=\"btn btn--primary\">Generate Screenshot</span>\n                </div>\n            ";
  }

function program64(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n              ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth1 && depth1.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(65, program65, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n          ";
  return buffer;
  }
function program65(depth0,data) {
  
  
  return "\n                  <div class=\"pull-right screenshot-switcher--generate hide\">\n                    <span class=\"btn btn--primary\">Generate Screenshot</span>\n                  </div>\n              ";
  }

  buffer += "<div class=\"ia-examples ia-single--info ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n    <h3 class=\"ia-single--header\">\n        <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Example Queries</span>\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </h3>\n\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    <div class=\"readonly--info ";
  stack1 = (helper = helpers.or || (depth0 && depth0.or),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options) : helperMissing.call(depth0, "or", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"example_query--readonly\">\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(38, program38, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.other_queries), {hash:{},inverse:self.program(55, program55, data),fn:self.programWithDepth(46, program46, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </div>\n</div>\n\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.program(57, program57, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["github"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n<div class=\"ia-issues ia-single--info\">\n  <h3 class=\"ia-single--header left\">\n      ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.issues)),stack1 == null || stack1 === false ? stack1 : stack1.length), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </h3>\n  <a id=\"create-issue--link\" class=\"btn btn--primary right\" \n  href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/new?&title=";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "%3A%20&body=";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.developer), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "%0A%0A------%0AIA%20Page%3A%20%20http%3A%2F%2Fduck.co%2Fia%2Fview%2F";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">Create Issue</a>\n  ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.issues)),stack1 == null || stack1 === false ? stack1 : stack1.length), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.issues)),stack1 == null || stack1 === false ? stack1 : stack1.length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " "
    + escapeExpression((helper = helpers.plural || (depth0 && depth0.plural),options={hash:{
    'plural': ("Issues"),
    'singular': ("Issue")
  },data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.issues)),stack1 == null || stack1 === false ? stack1 : stack1.length), options) : helperMissing.call(depth0, "plural", ((stack1 = (depth0 && depth0.issues)),stack1 == null || stack1 === false ? stack1 : stack1.length), options)))
    + " on Github\n      ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n        No Issues on Github\n      ";
  }

function program6(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "github", options) : helperMissing.call(depth0, "eq", (depth0 && depth0.type), "github", options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program7(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "@"
    + escapeExpression((helper = helpers.final_path || (depth0 && depth0.final_path),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.url), options) : helperMissing.call(depth0, "final_path", (depth0 && depth0.url), options)))
    + " ";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <ul class=\"clear\">\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.issues), {hash:{},inverse:self.noop,fn:self.programWithDepth(10, program10, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    ";
  stack1 = (helper = helpers.gt || (depth0 && depth0.gt),options={hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.issues), 5, options) : helperMissing.call(depth0, "gt", (depth0 && depth0.issues), 5, options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program10(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <li ";
  stack1 = (helper = helpers.gt || (depth0 && depth0.gt),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.index), 4, options) : helperMissing.call(depth0, "gt", (data == null || data === false ? data : data.index), 4, options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n          <div>\n            <a class=\"one-line\" href=\"https://github.com/duckduckgo/zeroclickinfo-"
    + escapeExpression(((stack1 = (depth1 && depth1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/issues/";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " #";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n            <span class=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                ";
  stack1 = (helper = helpers.loop_n || (depth0 && depth0.loop_n),options={hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, 3, (depth0 && depth0.tags), options) : helperMissing.call(depth0, "loop_n", 3, (depth0 && depth0.tags), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </span>\n            <span>\n                <span class=\"date\">Created "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.date), options)))
    + " by <a class=\"author\" href=\"https://github.com/";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></span>\n            </span>\n          </div>\n          <span class=\"clearfix\"></span>\n        </li>\n      ";
  return buffer;
  }
function program11(depth0,data) {
  
  
  return "class=\"hide\"";
  }

function program13(depth0,data) {
  
  
  return "sep--after";
  }

function program15(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                  <span class=\"tag-grp\">\n                    <i class=\"icon-circle\" style=\"color: #";
  if (helper = helpers.color) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.color); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ";\" /> <span class=\"tag-name\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n                  </span>\n                ";
  return buffer;
  }

function program17(depth0,data) {
  
  
  return "\n      <a href=\"#\" id=\"show-all-issues\">\n        Show All Issues\n      </a>\n    ";
  }

  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["index"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <li class=\"ia-item\">\n      <div class=\"ia_dev_milestone-";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ia_repo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ia_template-";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.instant_answer_topics), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n        \n        <div class=\"ia-item--stamp circle stamp--";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></div>\n        \n        <div class=\"ia-item--details\">\n          <div class=\"ia-item--details--top\">\n            <h3 class=\"left ia-item--header\"><a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></h3>\n            ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.instant_answer_topics), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n          </div>\n          <div class=\"ia-item--details--bottom one-line\">";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>\n          <div class=\"ia-item--details--img hide\">\n            <img class=\"ia-item--img\" src=\"/static/img/duckduckhack/default.png\" data-img=\"https://images.duckduckgo.com/iu/?u="
    + escapeExpression((helper = helpers.encodeURIComponent || (depth0 && depth0.encodeURIComponent),options={hash:{},data:data},helper ? helper.call(depth0, "https://ia-screenshots.s3.amazonaws.com/", options) : helperMissing.call(depth0, "encodeURIComponent", "https://ia-screenshots.s3.amazonaws.com/", options)));
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "_desktop.png&f=1\">\n          </div>\n        </div>\n        \n      </div>\n    </li>\n  ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += " ia_topic-"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.topic)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " ";
  return buffer;
  }

function program4(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n              <span class=\"topic right btn--wire\" data-topic=\"ia_topic-"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.topic)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.topic)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n              </span>\n            ";
  return buffer;
  }

  buffer += "<ul id=\"ia-list\">\n  ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.ia), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["issues"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this, functionType="function";

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <li id=\"pipeline-live__list__";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"pipeline-live__list__item by_ia_item ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.issues), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.producer), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.designer), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.developer)),stack1 == null || stack1 === false ? stack1 : stack1.name), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                <div class=\"list-container--left left by_ia_item--left\">\n                    <div class=\"left ia-item--stamp circle stamp--";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></div>\n                    <h3 class=\"left\"><a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></h3>\n                </div>\n                <div class=\"list-container--right left\">\n                    <ul class=\"list-container--right__issues issues_col\">\n                        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.issues), {hash:{},inverse:self.noop,fn:self.programWithDepth(11, program11, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </ul>\n                </div>\n                <span class=\"clearfix\"></span>\n            </li>\n        ";
  return buffer;
  }
function program2(depth0,data) {
  
  var stack1;
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program3(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += " issue-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + " ";
  return buffer;
  }

function program5(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "producer-";
  if (helper = helpers.producer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.producer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1);
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "designer-";
  if (helper = helpers.designer) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.designer); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1);
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "developer-"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.developer)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1));
  return buffer;
  }

function program11(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            <li class=\"";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                                <div class=\"one-line clearfix\">\n                                    <a href=\"https://github.com/duckduckgo/zeroclickinfo-"
    + escapeExpression(((stack1 = (depth1 && depth1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "/issues/";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                                </div>\n                                <div class=\"issue_date left\">\n                                    #";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " created by ";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " on "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.date), options)))
    + "\n                                </div>\n                                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(12, program12, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            </li>\n                        ";
  return buffer;
  }
function program12(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                                    <div title=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"list-container--right__issues__tags issues_col__tags left issue-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + "\" style=\"background-color: #";
  if (helper = helpers.color) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.color); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ";\">\n                                    </div>\n                                ";
  return buffer;
  }

function program14(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n             <li id=\"pipeline-issue__list__";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"hide pipeline-live__list__item by_date_item ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                <div class=\"list-container--left left by_date_item--left\">\n                    <div class=\"left ia-item--stamp circle stamp--";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></div>\n                    <div class=\"left\">\n                        <div class=\"one-line\">\n                            <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                        </div>\n                        <span class=\"clearfix\"></span>\n                        <div class=\"issue_date left\">\n                            #";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " created by ";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " on "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.date), options)))
    + "\n                        </div>\n                        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </div>\n                    <span class=\"clearfix\"></span>\n                </div>\n                <div class=\"list-container--right left ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n                    <h3 class=\"left\"><a href=\"/ia/view/";
  if (helper = helpers.ia_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.ia_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.ia_name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.ia_name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></h3>\n                </div>\n                <span class=\"clearfix\"></span>\n             </li>\n        ";
  return buffer;
  }
function program15(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            <div title=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"list-container--right__issues__tags issues_col__tags left issue-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + "\" style=\"background-color: #";
  if (helper = helpers.color) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.color); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ";\">\n                            </div>\n                        ";
  return buffer;
  }

function program17(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <div class=\"filter-issues__item\">\n            <i class=\"filter-issues__item__checkbox icon-check-empty left\" id=\"issue-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + "\"></i>\n            <div class=\"filter-issues__item__tag left\" style=\"background-color: #";
  if (helper = helpers.color) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.color); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ";\">\n                ";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n            </div>\n        </div>\n        <span class=\"clearfix\"></span>\n    ";
  return buffer;
  }

  buffer += "<div id=\"issues_sort_by\">\n    Sort by \n    <input type=\"radio\" name=\"sort_group\" id=\"sort_ia\" checked=\"checked\" /> IA name\n    <input type=\"radio\" name=\"sort_group\" id=\"sort_date\" /> Creation date\n</div>\n\n<div id=\"pipeline-live-container\" class=\"pipeline-container left\">\n    <ul class=\"dev_pipeline-container__list\" id=\"pipeline-live__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.ia), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        \n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.by_date), {hash:{},inverse:self.noop,fn:self.program(14, program14, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n\n<div class=\"filter-issues left\">\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.tags), {hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n\n";
  return buffer;
  });

this["Handlebars"]["templates"]["name"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program2(depth0,data) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program3(depth0,data) {
  
  
  return "fix-height";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.program(8, program8, data),fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program6(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <h2>";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h2>\n        ";
  return buffer;
  }

function program8(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n            <input type=\"text\" class=\"frm__input name top-details js-autocommit\" id=\"name-input\" value=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" />\n        ";
  return buffer;
  }

function program10(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n        <h2>";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h2>\n    ";
  return buffer;
  }

  buffer += "<div class=\"ia-single--name ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.program(10, program10, data),fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["overview"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this, functionType="function";

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <div class=\"half-w ";
  stack1 = helpers['if'].call(depth0, (data == null || data === false ? data : data.first), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n    <h2 class=\"left\">\n        <span class=\"heavy\">";
  if (helper = helpers.count) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.count); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span> "
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " Instant Answers\n    </h2>\n        <div class=\"button btn--primary right\"><a href=\"/ia";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.key), "new", options) : helperMissing.call(depth0, "eq", (data == null || data === false ? data : data.key), "new", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">See All</a></div>\n        <span class=\"clearfix\"></span>\n        \n        <ul class=\"iap-list\">\n            ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.list), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </ul>\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  
  return "left";
  }

function program4(depth0,data) {
  
  
  return "right";
  }

function program6(depth0,data) {
  
  
  return "/dev/pipeline";
  }

function program8(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                <li class=\"ia-item\">\n                  <div class=\"ia_dev_milestone-";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ia_repo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " ia-item__container\">\n                        \n                    <div class=\"left ia-item--stamp circle stamp--";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></div>\n                    <h3 class=\"left ia-item--header\"><a href=\"/ia/view/";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a></h3>\n\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.most_recent), {hash:{},inverse:self.program(16, program16, data),fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                    \n                    <span class=\"clearfix\"></span>\n                  </div>\n                </li>\n            ";
  return buffer;
  }
function program9(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.program(13, program13, data),fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.key), "live", options) : helperMissing.call(depth0, "eq", (data == null || data === false ? data : data.key), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  return buffer;
  }
function program10(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.live_date), {hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        ";
  return buffer;
  }
function program11(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "\n                                <span class=\"ia_date right\">launched on "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.live_date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.live_date), options)))
    + "</span>\n                            ";
  return buffer;
  }

function program13(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.created_date), {hash:{},inverse:self.noop,fn:self.program(14, program14, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        ";
  return buffer;
  }
function program14(depth0,data) {
  
  var buffer = "", helper, options;
  buffer += "\n                                <span class=\"ia_date right\">created on "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.created_date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.created_date), options)))
    + "</span>\n                            ";
  return buffer;
  }

function program16(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "                    \n                        ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.issues), {hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.key), "live", options) : helperMissing.call(depth0, "eq", (data == null || data === false ? data : data.key), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  return buffer;
  }
function program17(depth0,data) {
  
  
  return "\n                            <i class=\"icon-bug right\"></i>\n                        ";
  }

function program19(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.edits), {hash:{},inverse:self.noop,fn:self.program(20, program20, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        ";
  return buffer;
  }
function program20(depth0,data) {
  
  
  return "\n                                <i class=\"icon-edit right\"></i>\n                            ";
  }

function program22(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <li class=\"top-issues__list__item main-tag\">\n                <div class=\"list-container--left left main-tag__left\">\n                    <ul class=\"list-container--left__issues issues_col main-tag__left__list\">\n                        ";
  stack1 = (helper = helpers.loop_n || (depth0 && depth0.loop_n),options={hash:{},inverse:self.noop,fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, 5, (depth0 && depth0.list), options) : helperMissing.call(depth0, "loop_n", 5, (depth0 && depth0.list), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    </ul>\n                </div>\n                <div class=\"list-container--right right main-tag__right\">\n                    <div class=\"tag-"
    + escapeExpression((helper = helpers.slug || (depth0 && depth0.slug),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.name), options) : helperMissing.call(depth0, "slug", (depth0 && depth0.name), options)))
    + " tag-container right\">\n                        <h3 class=\"heavy\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h3>\n                    </div>\n                </div>\n                <span class=\"clearfix\"></span>\n            <li>\n        ";
  return buffer;
  }
function program23(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            <li>\n                                <div class=\"left ia-item--stamp circle stamp--";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></div>\n                                <div class=\"one-line left\">\n                                    <h5 class=\"issue-title\">\n                                        <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                                            ";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                                        </a>\n                                    </h5>\n                                    <span class=\"issue-details\">\n                                        #";
  if (helper = helpers.issue_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.issue_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + " opened on "
    + escapeExpression((helper = helpers.parse_date || (depth0 && depth0.parse_date),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.date), options) : helperMissing.call(depth0, "parse_date", (depth0 && depth0.date), options)))
    + " by <a href=\"https://github.com/";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.author) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.author); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a> \n                                        &middot; IA Page: <a href=\"/ia/view/";
  if (helper = helpers.ia_id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.ia_id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.ia_name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.ia_name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                                    </span>\n                                </div>\n                                <span class=\"clearfix\"></span>\n                            </li>\n                        ";
  return buffer;
  }

  stack1 = helpers.each.call(depth0, (depth0 && depth0.ias), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n<span class=\"clearfix\"></span>\n\n<div id=\"top-issues\">\n    <div class=\"top-issues__title\">\n        <h2 class=\"left\">Top Issues on GitHub</h2>\n        <div class=\"button btn--primary right\"><a href=\"/ia/dev/issues\">See All</a></div>\n        <span class=\"clearfix\"></span>\n    </div>\n    <ul class=\"top-issues__list\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.issues), {hash:{},inverse:self.noop,fn:self.program(22, program22, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_answerbar"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-answerbar\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Fallback Timeout (ms)\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-answerbar\">\n        <div class=\"column-right-edits__child\" id=\"answerbar\" name=\"answerbar\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.answerbar)),stack1 == null || stack1 === false ? stack1 : stack1.fallback_timeout)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"answerbar\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"answerbar\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_api_status_page"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"row-diff\" id=\"row-diff-api_status_page\">\n        <div class=\"column-left-labels left\">\n            <div class=\"column-left-labels__child\">\n                <p class=\"column-left-labels__child__p\">\n                    API Status Page\n                </p>\n            </div>\n        </div>\n        <div class=\"column-center-live left\">\n            <div class=\"column-center-live__child\">\n                <p class=\"column-center-live__child__p\">\n                    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.api_status_page), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </p>\n            </div>\n        </div>\n        <div class=\"column-right-edits left\" id=\"column-edits-api_status_page\">\n            <div class=\"column-right-edits__child\" id=\"api_status_page\" name=\"api_status_page\">\n                <p class=\"column-right-edits__child__p\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.api_status_page)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </p>\n            </div>\n        </div>\n\n        <div class=\"button js-pre-editable\" name=\"api_status_page\">\n            <i class=\"js-pre-editable__icon icon-edit\"></i>\n            <span class=\"js-pre-editable__text\">Edit</span>\n        </div>\n\n        <div class=\"button hide js-editable\" name=\"api_status_page\">\n            <i class=\"js-editable__icon icon-check\"></i>\n            <span class=\"js-editable__text\">Done</span>\n        </div>\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.api_status_page)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                        —\n                    ";
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "spice", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_blockgroup"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.blockgroup)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-blockgroup\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Blockgroup\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.blockgroup), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-blockgroup\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.blockgroup)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"blockgroup\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"blockgroup\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_deployment_state"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.deployment_state)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-deployment_state\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Deployment State\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.deployment_state), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-deployment_state\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.deployment_state)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"deployment_state\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"deployment_state\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_description"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-description\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Description\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.description), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-description\">\n        <div class=\"column-right-edits__child\" id=\"description\" name=\"description\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"description\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"description\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_designer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.designer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-designer\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Designer\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.designer), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-designer\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.designer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"designer\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"designer\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_dev_milestone"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.dev_milestone)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-dev_milestone\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Dev Milestone\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.dev_milestone), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-dev_milestone\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.dev_milestone)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"dev_milestone\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"dev_milestone\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_developer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.developer), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                        <li class=\"editpage\">\n                            <span name=\"developer\" class=\"pre_edit other-examples\">\n                                <a href=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n                                    ";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                                </a>\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.developer), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-developer\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Developer\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.developer), {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-developer\">\n        <div class=\"column-right-edits__child\" id=\"examples\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.developer), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"developer\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"developer\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_error"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"hide\" id=\"error\"><strong>Error: unable to save the data.</strong></div>\n";
  });

this["Handlebars"]["templates"]["pre_edit_example_query"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.example_query)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-example_query\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Example Query\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p name=\"example_query\" class=\"column-center-live__child__p\" id=\"primary\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.example_query), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-example_query\">\n        <div class=\"column-right-edits__child\" id=\"example_query\">\n            <p name=\"example_query\" class=\"column-right-edits__child__p\" id=\"primary\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.example_query)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"example_query\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"example_query\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_id"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-id\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                ID\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.id), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-id\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"id\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"id\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_is_stackexchange"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n<div class=\"row-diff\" id=\"row-diff-is_stackexchange\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Stack Exchange\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                <i class=\"icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"/>\n                Is Stack Exchange\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-is_stackexchange\">\n        <div class=\"column-right-edits__child\" id=\"is_stackexchange\" name=\"is_stackexchange\">\n            <p class=\"column-right-edits__child__p\">\n                ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options) : helperMissing.call(depth0, "not_null", ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"is_stackexchange\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable js-check\" name=\"is_stackexchange\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  
  return "-empty";
  }

function program4(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <i class=\"icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.is_stackexchange), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"/>\n                    Is Stack Exchange\n                ";
  return buffer;
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "longtail", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_issues"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<hr>\n\n<p class=\"left\"><strong>Issues</strong></p>\n\n<div class=\"right button new-issue\">\n    <a href=\"https://github.com/duckduckgo/zeroclickinfo-";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "/issues/new?&title=issue+title&body=http%3A%2F%2Fduck.co%2Fia%2Fview%2F";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n        + Add an Issue\n    </a>\n</div>\n<span class=\"clearfix\"></span>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_name"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-name\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Name\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.name), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-name\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"name\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"name\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_other_queries"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li class=\"editpage\">\n                            <span title=\"try this example on DuckDuckGo\" name=\"other_queries\" class=\"pre_edit other_queries\">\n                                "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-other_queries\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Other Queries\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-other_queries\">\n        <div class=\"column-right-edits__child\" id=\"examples\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.other_queries), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"other_queries\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"other_queries\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_perl_dependencies"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li class=\"editpage\">\n                            <span name=\"perl_dependencies\" class=\"pre_edit perl_dependencies\">\n                                "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li class=\"editpage\">\n                            <span title=\"try this example on DuckDuckGo\" name=\"perl_dependencies\" class=\"pre_edit perl_dependencies\">\n                                "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-perl_dependencies\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Perl Dependencies\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies), {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-perl_dependencies\">\n        <div class=\"column-right-edits__child\" id=\"examples\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.perl_dependencies), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"perl_dependencies\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"perl_dependencies\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_perl_module"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.perl_module)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-perl_module\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Perl Module\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.perl_module), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-perl_module\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.perl_module)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"perl_module\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"perl_module\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_producer"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.producer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-producer\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Producer\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.producer), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-producer\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.producer)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"producer\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"producer\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_repo"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-repo\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Type\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-repo\">\n        <div class=\"column-right-edits__child\" id=\"repo\" name=\"repo\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.repo)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"repo\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"repo\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_src_api_documentation"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"row-diff\" id=\"row-diff-src_api_documentation\">\n        <div class=\"column-left-labels left\">\n            <div class=\"column-left-labels__child\">\n                <p class=\"column-left-labels__child__p\">\n                    API Documentation\n                </p>\n            </div>\n        </div>\n        <div class=\"column-center-live left\">\n            <div class=\"column-center-live__child\">\n                <p class=\"column-center-live__child__p\">\n                    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_api_documentation), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </p>\n            </div>\n        </div>\n        <div class=\"column-right-edits left\" id=\"column-edits-src_api_documentation\">\n            <div class=\"column-right-edits__child\" id=\"src_api_documentation\" name=\"src_api_documentation\">\n                <p class=\"column-right-edits__child__p\">\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_api_documentation)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                </p>\n            </div>\n        </div>\n\n        <div class=\"button js-pre-editable\" name=\"src_api_documentation\">\n            <i class=\"js-pre-editable__icon icon-edit\"></i>\n            <span class=\"js-pre-editable__text\">Edit</span>\n        </div>\n\n        <div class=\"button hide js-editable\" name=\"src_api_documentation\">\n            <i class=\"js-editable__icon icon-check\"></i>\n            <span class=\"js-editable__text\">Done</span>\n        </div>\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_api_documentation)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                        —\n                    ";
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "spice", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_src_domain"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n<div class=\"row-diff\" id=\"row-diff-src_domain\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Source Domain\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_domain), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-src_domain\">\n        <div class=\"column-right-edits__child\" id=\"src_domain\" name=\"src_domain\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_domain)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"src_domain\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"src_domain\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_domain)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", "longtail", options) : helperMissing.call(depth0, "eq_or", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_src_id"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n<div class=\"row-diff\" id=\"row-diff-src_id\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Source ID\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_id), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-src_id\">\n        <div class=\"column-right-edits__child\" id=\"src_id\" name=\"src_id\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"src_id\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"src_id\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_src_name"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n<div class=\"row-diff\" id=\"row-diff-src_name\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Source Name\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_name), {hash:{},inverse:self.program(4, program4, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-src_name\">\n        <div class=\"column-right-edits__child\" id=\"src_name\" name=\"src_name\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"src_name\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"src_name\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_src_options"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"row-diff\" id=\"row-diff-src_options\">\n        <div class=\"column-left-labels left\">\n            <div class=\"column-left-labels__child\">\n                <p class=\"column-left-labels__child__p\">\n                    Source Options\n                </p>\n            </div>\n        </div>\n        <div class=\"column-center-live left\">\n            <div class=\"column-center-live__child\">\n                <p class=\"column-center-live__child__p\">\n                    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options), {hash:{},inverse:self.program(5, program5, data),fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </p>\n            </div>\n        </div>\n        <div class=\"column-right-edits left\" id=\"column-edits-src_options\">\n            <div class=\"column-right-edits__child\" id=\"src_options\" name=\"src_options\">\n                <p class=\"column-right-edits__child__p\">\n                    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </p>\n            </div>\n        </div>\n\n        <div class=\"button js-pre-editable\" name=\"src_options\">\n            <i class=\"js-pre-editable__icon icon-edit\"></i>\n            <span class=\"js-pre-editable__text\">Edit</span>\n        </div>\n\n        <div class=\"button hide js-editable\" name=\"src_options\">\n            <i class=\"js-editable__icon icon-check\"></i>\n            <span class=\"js-editable__text\">Done</span>\n        </div>\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    <ul class=\"section-group\" id=\"src_options-group\">\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract-check\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract_paren-check\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract parent\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_icon-check\"/>\n                            <span class=\"check-txt\">\n                                Skip icon\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_image_name-check\"/>\n                            <span class=\"check-txt\">\n                                Skip image name\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_wikipedia-check\"/>\n                            <span class=\"check-txt\">\n                                Is Wikipedia\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_mediawiki-check\"/>\n                            <span class=\"check-txt\">\n                                Is MediaWiki\n                            </span>\n                        </li>\n                        <li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_fanon-check\"/>\n                            <span class=\"check-txt\">\n                                Is Fanon\n                            </span>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source skip: </label>\n                            <div class=\"clearfix \" id=\"source_skip-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.source_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                            <label class=\"left\">Skip query: </label>\n                            <div class=\"clearfix \" id=\"skip_qr-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Directory: </label>\n                            <div class=\"clearfix \" id=\"directory-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Minimum abstract length: </label>\n                            <div class=\"clearfix \" id=\"min_abstract_length-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source info: </label>\n                            <div class=\"clearfix \" id=\"src_info-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip end: </label>\n                            <div class=\"clearfix \" id=\"skip_end-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_end)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Language: </label>\n                            <div class=\"clearfix \" id=\"Language-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                    </ul>\n                    ";
  return buffer;
  }
function program3(depth0,data) {
  
  
  return "-empty";
  }

function program5(depth0,data) {
  
  
  return "\n                        —\n                    ";
  }

function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    <ul class=\"section-group\" id=\"src_options-group\">\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract-check\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_abstract_paren), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_abstract_paren-check\"/>\n                            <span class=\"check-txt\">\n                                Skip abstract parent\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_icon), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_icon-check\"/>\n                            <span class=\"check-txt\">\n                                Skip icon\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_image_name), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"skip_image_name-check\"/>\n                            <span class=\"check-txt\">\n                                Skip image name\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_wikipedia), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_wikipedia-check\"/>\n                            <span class=\"check-txt\">\n                                Is Wikipedia\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_mediawiki), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_mediawiki-check\"/>\n                            <span class=\"check-txt\">\n                                Is MediaWiki\n                            </span>\n                        </li>\n                        <li>\n                            <i class=\"section-group__item icon-check";
  stack1 = helpers.unless.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.is_fanon), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"is_fanon-check\"/>\n                            <span class=\"check-txt\">\n                                Is Fanon\n                            </span>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source skip: </label>\n                            <div class=\"clearfix \" id=\"source_skip-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.source_skip)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip query: </label>\n                            <div class=\"clearfix \" id=\"skip_qr-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_qr)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Directory: </label>\n                            <div class=\"clearfix \" id=\"directory-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.directory)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Minimum abstract length: </label>\n                            <div class=\"clearfix \" id=\"min_abstract_length-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.min_abstract_length)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Source info: </label>\n                            <div class=\"clearfix \" id=\"src_info-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.src_info)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Skip end: </label>\n                            <div class=\"clearfix \" id=\"skip_end-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.skip_end)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                        <li>\n                            <label class=\"left\">Language: </label>\n                            <div class=\"clearfix \" id=\"language-txt\">\n                                "
    + escapeExpression(((stack1 = ((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.src_options)),stack1 == null || stack1 === false ? stack1 : stack1.language)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                            </div>\n                        </li>\n                    </ul>\n                    ";
  return buffer;
  }

  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_status"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.status)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-status\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Status\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.status), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-status\">\n        <div class=\"column-right-edits__child\" id=\"status\" name=\"status\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.status)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"status\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"status\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_tab"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.tab)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-tab\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Tab\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.tab), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-tab\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.tab)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"tab\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"tab\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_template"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.template)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n                ";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-template\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Template\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.template), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-template\">\n        <div class=\"column-right-edits__child\">\n            <p class=\"column-right-edits__child__p\">\n                "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.template)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"template\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"template\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_topic"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <ul class=\"column-center-live__child__ul\">\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.topic), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </ul>\n            ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li>\n                            "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                        </li>\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                —\n            ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <ul>\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.topic), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                </ul>\n            ";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li>\n                            "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                        </li> \n                    ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-topic\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Topic\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.topic), {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-topic\">\n        <div class=\"column-right-edits__child\" id=\"topic\" name=\"topic\">\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.topic), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"topic\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"topic\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_triggers"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li class=\"editpage\">\n                            <span name=\"triggers\" class=\"pre_edit triggers\">\n                                "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n                    —\n                ";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "";
  buffer += "\n                        <li class=\"editpage\">\n                            <span title=\"try this example on DuckDuckGo\" name=\"triggers\" class=\"pre_edit triggers\">\n                                "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\n                            </span>\n                        </li>\n                    ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-triggers\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Trigger Words\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-triggers\">\n        <div class=\"column-right-edits__child\" id=\"examples\">\n            <ul class=\"column-center-live__child__ul\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </ul>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"triggers\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable\" name=\"triggers\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["pre_edit_unsafe"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "-empty";
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <i class=\"icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"/>\n                    Unsafe\n                ";
  return buffer;
  }

  buffer += "<div class=\"row-diff\" id=\"row-diff-unsafe\">\n    <div class=\"column-left-labels left\">\n        <div class=\"column-left-labels__child\">\n            <p class=\"column-left-labels__child__p\">\n                Safe Search\n            </p>\n        </div>\n    </div>\n    <div class=\"column-center-live left\">\n        <div class=\"column-center-live__child\">\n            <p class=\"column-center-live__child__p\">\n                <i class=\"icon-check";
  stack1 = (helper = helpers.is_false || (depth0 && depth0.is_false),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options) : helperMissing.call(depth0, "is_false", ((stack1 = (depth0 && depth0.live)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"/>\n                Unsafe\n            </p>\n        </div>\n    </div>\n    <div class=\"column-right-edits left\" id=\"column-edits-unsafe\">\n        <div class=\"column-right-edits__child\" id=\"unsafe\" name=\"unsafe\">\n            <p class=\"column-right-edits__child__p\">\n                ";
  stack1 = (helper = helpers.not_null || (depth0 && depth0.not_null),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options) : helperMissing.call(depth0, "not_null", ((stack1 = (depth0 && depth0.edited)),stack1 == null || stack1 === false ? stack1 : stack1.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </p>\n        </div>\n    </div>\n\n    <div class=\"button js-pre-editable\" name=\"unsafe\">\n        <i class=\"js-pre-editable__icon icon-edit\"></i>\n        <span class=\"js-pre-editable__text\">Edit</span>\n    </div>\n\n    <div class=\"button hide js-editable js-check\" name=\"unsafe\">\n        <i class=\"js-editable__icon icon-check\"></i>\n        <span class=\"js-editable__text\">Done</span>\n    </div>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["screens"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.programWithDepth(2, program2, data, depth1),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", "development", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "planning", "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program2(depth0,data,depth2) {
  
  var buffer = "", stack1;
  buffer += "\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.example_query), {hash:{},inverse:self.noop,fn:self.programWithDepth(3, program3, data, depth0, depth2),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program3(depth0,data,depth1,depth3) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n<div class=\"screens--wide\">\n  <div class=\"ia-single--screenshots\">\n    <div class=\"screenshot--status hide\">\n        <div class=\"default-message hide\"></div>\n        <div class=\"revert hide\"><a href=\"#\">Restore previous screenshot</a></div>\n        <img class=\"loader\" style=\"display: none;\" src=\"/static/img/ia/loader_f2f2f2.gif\">\n    </div>\n\n    <!-- Mobile image -->\n    <div class=\"mobile-faux__container hide\">\n        <div class=\"mobile-faux__edge\">\n            <div class=\"mobile-faux__padding\">\n                <img class=\"screenshot-mobile\" src=\"\" style=\"display: inline-block;\">\n            </div>\n        </div>\n    </div>\n\n    <!-- Desktop image -->\n    <img class=\"screenshot-desktop hide\" src=\"\" style=\"display: block;\">\n  </div>\n\n  ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.programWithDepth(7, program7, data, depth3),fn:self.programWithDepth(4, program4, data, depth1),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  }
function program4(depth0,data,depth2) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  stack1 = helpers['if'].call(depth0, (depth2 && depth2.can_show), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program5(depth0,data) {
  
  
  return "\n        <span class=\"generate-screenshot pull-right btn btn--primary\">\n          <i class=\"icon-refresh\"></i>\n        </span>\n    ";
  }

function program7(depth0,data,depth4) {
  
  var buffer = "", stack1;
  buffer += "\n      ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth4 && depth4.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program8(depth0,data) {
  
  
  return "\n        <span class=\"generate-screenshot pull-right btn btn--primary\">\n          <i class=\"icon-refresh\"></i>\n        </span>\n      ";
  }

  stack1 = helpers['with'].call(depth0, (depth0 && depth0.live), {hash:{},inverse:self.noop,fn:self.programWithDepth(1, program1, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["test"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "ghosted", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "ghosted", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", "development", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "planning", "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program3(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        <div class=\"ia-single--testing ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n            <h3 class=\"ia-single--header\">Testing</h3>\n            <div class=\"gw\">\n                <div class=\"g third testing-section\">\n                    <div class=\"frm\">\n                        <label class=\"details__label\">\n                            Browser Testing\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"browsers_ie-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"browsers_ie frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.browsers_ie), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.browsers_ie), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">IE</span>\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"browsers_chrome-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"browsers_chrome frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.browsers_chrome), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.browsers_chrome), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Chrome</span>\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"browsers_firefox-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"browsers_firefox frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.browsers_firefox), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.browsers_firefox), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Firefox</span>\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"browsers_safari-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"browsers_safari frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.browsers_safari), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.browsers_safari), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Safari</span>\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"browsers_opera-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"browsers_opera frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.browsers_opera), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.browsers_opera), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Opera</span>\n                        </label>\n                    </div>\n                </div>\n\n                <div class=\"g third testing-section\">\n                    <div class=\"frm\">\n                        <label class=\"details__label\">\n                            Mobile Testing\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"mobile_ios-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"mobile_ios frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.mobile_ios), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.mobile_ios), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">iOS</span>\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"mobile_android-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"mobile_android frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.mobile_android), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.mobile_android), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Android</span>\n                        </label>\n                    </div>\n                </div>\n\n                <div class=\"g third testing-section\">\n                    <div class=\"frm\">\n                        <label class=\"details__label\">\n                            Miscellaneous\n                        </label>\n                        <label class=\"frm__label\">\n                            <input  id=\"unsafe-check\" ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " class=\"unsafe frm__label__chk ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options) : helperMissing.call(depth0, "is_true", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" type=\"checkbox\" ";
  stack1 = (helper = helpers.is_true || (depth0 && depth0.is_true),options={hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.unsafe), options) : helperMissing.call(depth0, "is_true", (depth0 && depth0.unsafe), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n                            <span class=\"frm__label__txt\">Requires Safe Search</span>\n                        </label>\n                    </div>\n                </div>\n            </div>\n        </div>\n    ";
  return buffer;
  }
function program4(depth0,data) {
  
  
  return "wicked-border";
  }

function program6(depth0,data) {
  
  
  return "disabled=\"disabled\"";
  }

function program8(depth0,data) {
  
  
  return "js-autocommit";
  }

function program10(depth0,data) {
  
  
  return "checked=\"checked\"";
  }

  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["top_details"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n        ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program2(depth0,data) {
  
  
  return "\n            <div class=\"special-permissions__edit js-edit-enable btn btn--wire--hero btn--inline\" id=\"edit_activate\">Edit</div>\n        ";
  }

function program4(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program5(depth0,data) {
  
  
  return "ninety";
  }

function program7(depth0,data) {
  
  var stack1;
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.topic), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program8(depth0,data) {
  
  
  return "hide";
  }

function program10(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program11(depth0,data) {
  
  
  return "sep--after";
  }

function program13(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.program(27, program27, data),fn:self.program(14, program14, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program14(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    <div class=\"topic-container parent-group\" id=\"topic-group\">\n                      ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(20, program20, data),fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "top_fields", "topic", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "top_fields", "topic", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n                      <div class=\"btn ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(25, program25, data),fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "top_fields", "topic", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "top_fields", "topic", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"add_topic\">\n                        <i class=\"ddgsi-plus\" />\n                      </div>\n\n                      <span class=\"hide\" id=\"topic-cancel\">\n                        <a href=\"#\">Cancel</a>\n                      </span>\n\n                      <div class=\"hide separator topic-separator new_empty_topic\">\n                        <div class=\"topic-remove hide\" name=\"topic\" title=\"Remove this topic\">\n                          <i class=\"ddgsi ddgsi-close-bold\">X</i>\n                        </div>\n                        <span class=\"frm__select\">\n                         <select class=\"group-vals topic top-details js-autocommit topic-group\">\n                          <option value=\"\" disabled selected>Select a Topic</option>\n                         </select>\n                        </span>\n                        <span class=\"delete-tag\"><i class=\"delete ddgsi ddgsi-close\"></i></span>\n                      </div>\n                    </div>\n                ";
  return buffer;
  }
function program15(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        ";
  stack1 = helpers['with'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields), {hash:{},inverse:self.noop,fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                      ";
  return buffer;
  }
function program16(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), "n---d", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.topic), "n---d", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        ";
  return buffer;
  }
function program17(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                              ";
  stack1 = (helper = helpers.loop_n || (depth0 && depth0.loop_n),options={hash:{},inverse:self.noop,fn:self.program(18, program18, data),data:data},helper ? helper.call(depth0, 2, (depth0 && depth0.topic), options) : helperMissing.call(depth0, "loop_n", 2, (depth0 && depth0.topic), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            ";
  return buffer;
  }
function program18(depth0,data) {
  
  var buffer = "";
  buffer += "\n                                <div class=\"separator topic-separator btn-grp\">\n                                  <span class=\"frm__select\">\n                                    <select class=\"group-vals top-details topic js-autocommit topic-group\">\n                                      <option value=\"0\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</option>\n                                    </select>\n                                  </span>\n                                  <span class=\"delete-tag\"><i class=\"delete ddgsi ddgsi-close\"></i></span>\n                                </div>\n                              ";
  return buffer;
  }

function program20(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                          ";
  stack1 = (helper = helpers.loop_n || (depth0 && depth0.loop_n),options={hash:{},inverse:self.noop,fn:self.program(21, program21, data),data:data},helper ? helper.call(depth0, 2, (depth0 && depth0.topic), options) : helperMissing.call(depth0, "loop_n", 2, (depth0 && depth0.topic), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                      ";
  return buffer;
  }
function program21(depth0,data) {
  
  var buffer = "";
  buffer += "\n                            <div class=\"separator topic-separator btn-grp\">\n                              <span class=\"frm__select\">\n                                <select class=\"group-vals top-details topic js-autocommit topic-group\">\n                                  <option value=\"0\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</option>\n                                </select>\n                              </span>\n                              <span class=\"delete-tag\"><i class=\"delete ddgsi ddgsi-close\"></i></span>\n                            </div>\n                          ";
  return buffer;
  }

function program23(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.gt || (depth0 && depth0.gt),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields)),stack1 == null || stack1 === false ? stack1 : stack1.topic), 1, options) : helperMissing.call(depth0, "gt", ((stack1 = ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields)),stack1 == null || stack1 === false ? stack1 : stack1.topic), 1, options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program25(depth0,data) {
  
  var stack1, helper, options;
  stack1 = (helper = helpers.gt || (depth0 && depth0.gt),options={hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.topic), 1, options) : helperMissing.call(depth0, "gt", (depth0 && depth0.topic), 1, options));
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }

function program27(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.topic), {hash:{},inverse:self.noop,fn:self.program(28, program28, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program28(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        <a href=\"/ia?&topic="
    + escapeExpression((helper = helpers.urify || (depth0 && depth0.urify),options={hash:{},data:data},helper ? helper.call(depth0, depth0, options) : helperMissing.call(depth0, "urify", depth0, options)))
    + "\">\n                            "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0));
  stack1 = helpers.unless.call(depth0, (data == null || data === false ? data : data.last), {hash:{},inverse:self.noop,fn:self.program(29, program29, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                        </a>\n                    ";
  return buffer;
  }
function program29(depth0,data) {
  
  
  return ", ";
  }

function program31(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.topic), {hash:{},inverse:self.program(32, program32, data),fn:self.program(27, program27, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program32(depth0,data) {
  
  
  return "\n                    No topic\n                ";
  }

function program34(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(35, program35, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program35(depth0,data) {
  
  
  return "add-width";
  }

function program37(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.program(51, program51, data),fn:self.program(38, program38, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program38(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(49, program49, data),fn:self.program(39, program39, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "top_fields", "repo", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "top_fields", "repo", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                 ";
  return buffer;
  }
function program39(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        ";
  stack1 = helpers['with'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields), {hash:{},inverse:self.noop,fn:self.program(40, program40, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  return buffer;
  }
function program40(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            <span class=\"frm__select\">\n                              <select class=\"top-details js-autocommit repo\" tabindex=\"-1\" id=\"repo-select\">\n                                <option value=\"0\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(41, program41, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(43, program43, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "goodies", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "goodies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(45, program45, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "longtail", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(47, program47, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                              </select>\n                            </span>\n                        ";
  return buffer;
  }
function program41(depth0,data) {
  
  
  return "<option value=\"1\">fathead</option>";
  }

function program43(depth0,data) {
  
  
  return "<option value=\"2\">goodies</option>";
  }

function program45(depth0,data) {
  
  
  return "<option value=\"3\">longtail</option>";
  }

function program47(depth0,data) {
  
  
  return "<option value=\"4\">spice</option>";
  }

function program49(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        <span class=\"frm__select\">\n                          <select class=\"top-details js-autocommit repo\" tabindex=\"-1\" id=\"repo-select\">\n                            <option value=\"0\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                            ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(41, program41, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "fathead", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "fathead", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(43, program43, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "goodies", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "goodies", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(45, program45, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "longtail", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "longtail", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(47, program47, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.repo), "spice", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.repo), "spice", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                          </select>\n                        </span>\n                    ";
  return buffer;
  }

function program51(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.repo), {hash:{},inverse:self.noop,fn:self.program(52, program52, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                 ";
  return buffer;
  }
function program52(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                        <a href=\"/ia?&repo=";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                    ";
  return buffer;
  }

function program54(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.repo), {hash:{},inverse:self.noop,fn:self.program(55, program55, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program55(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    <a href=\"/ia?&repo=";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.repo) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.repo); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</a>\n                ";
  return buffer;
  }

function program57(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.program(75, program75, data),fn:self.program(58, program58, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program58(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                    ";
  stack1 = (helper = helpers.exists_subkey || (depth0 && depth0.exists_subkey),options={hash:{},inverse:self.program(73, program73, data),fn:self.program(59, program59, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.staged), "top_fields", "dev_milestone", options) : helperMissing.call(depth0, "exists_subkey", (depth0 && depth0.staged), "top_fields", "dev_milestone", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program59(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                        ";
  stack1 = helpers['with'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.top_fields), {hash:{},inverse:self.noop,fn:self.program(60, program60, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  return buffer;
  }
function program60(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                            <span class=\"frm__select\">\n                              <select class=\"top-details js-autocommit dev_milestone\" tabindex=\"-1\" id=\"dev_milestone-select\">\n                                <option value=\"0\">";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(61, program61, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "planning", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(63, program63, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "development", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(65, program65, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "testing", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "testing", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(67, program67, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "complete", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "complete", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(69, program69, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(71, program71, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "ghosted", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "ghosted", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                              </select>\n                            </span>\n                        ";
  return buffer;
  }
function program61(depth0,data) {
  
  
  return "<option value=\"1\">planning</option>";
  }

function program63(depth0,data) {
  
  
  return "<option value=\"2\">development</option>";
  }

function program65(depth0,data) {
  
  
  return "<option value=\"3\">testing</option>";
  }

function program67(depth0,data) {
  
  
  return "<option value=\"4\">complete</option>";
  }

function program69(depth0,data) {
  
  
  return "<option value=\"5\">live</option>";
  }

function program71(depth0,data) {
  
  
  return "<option value=\"6\">ghosted</option>";
  }

function program73(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        <span class=\"frm__select\">\n                            <select class=\"top-details js-autocommit dev_milestone\" tabindex=\"-1\" id=\"dev_milestone-select\">\n                                <option value=\"0\">";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</option>\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(61, program61, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "planning", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "planning", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(63, program63, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "development", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "development", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(65, program65, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "testing", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "testing", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(67, program67, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "complete", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "complete", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(69, program69, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "live", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                                ";
  stack1 = (helper = helpers.not_eq || (depth0 && depth0.not_eq),options={hash:{},inverse:self.noop,fn:self.program(71, program71, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "ghosted", options) : helperMissing.call(depth0, "not_eq", (depth0 && depth0.dev_milestone), "ghosted", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                            </select>\n                        </span>\n                    ";
  return buffer;
  }

function program75(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                        ";
  if (helper = helpers.edited_dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.edited_dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n                ";
  return buffer;
  }

function program77(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n                    ";
  if (helper = helpers.dev_milestone) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.dev_milestone); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\n            ";
  return buffer;
  }

  buffer += "<div class=\"pull-right\">\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n\n<div class=\"";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n    <span class=\"top__categories left ";
  stack1 = (helper = helpers.eq_or || (depth0 && depth0.eq_or),options={hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "eq_or", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n        <!-- Don't add any separators when we're editing. -->\n        <span class=\"";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.program(11, program11, data),fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n            <span class=\"detail-title\">Topics:</span>\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.program(31, program31, data),fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </span>\n    </span>\n\n    <span class=\"top__repo left ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(34, program34, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n        <!-- Don't add any separators when we're editing. -->\n        <span class=\"";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.program(11, program11, data),fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n            <span class=\"detail-title\">Type:</span>\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.program(54, program54, data),fn:self.program(37, program37, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </span>\n    </span>\n\n    <span class=\"top__milestone left\">\n        <span>\n            <span class=\"detail-title\">Status:</span>\n            ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), {hash:{},inverse:self.program(77, program77, data),fn:self.program(57, program57, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </span>\n    </span>\n</div>\n";
  return buffer;
  });

this["Handlebars"]["templates"]["traffic"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "\n    <h3 class=\"ia-single--header\">\n        <span>Traffic Data</span>\n    </h3>\n    <canvas class=\"charts\" id=\"ia_traffic\"></canvas>\n";
  }

  stack1 = (helper = helpers.or || (depth0 && depth0.or),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options) : helperMissing.call(depth0, "or", ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.admin), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });

this["Handlebars"]["templates"]["triggers"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <div class=\"ia-triggers ia-single--info\">\n        <h3 class=\"ia-single--header\">\n            <span ";
  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">Triggers</span>\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </h3>\n\n        ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        <span class=\"readonly--info ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"triggers--readonly\">\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.program(19, program19, data),fn:self.program(15, program15, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </span>\n    </div>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var stack1;
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.permissions)),stack1 == null || stack1 === false ? stack1 : stack1.can_edit), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }
  }
function program3(depth0,data) {
  
  
  return "class=\"asterisk\"";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <a href=\"#\" class=\"devpage-edit ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-edit-triggers\">Edit</a>\n            <a href=\"#\" class=\"devpage-commit sep--after ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-commit-triggers\">Commit</a>\n            <a href=\"#\" class=\"devpage-cancel ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" id=\"dev-cancel-triggers\">Cancel</a>\n        ";
  return buffer;
  }
function program6(depth0,data) {
  
  
  return "hide";
  }

function program8(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n            <ul class=\"hidden-toshow ";
  stack1 = helpers.unless.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = (helper = helpers.eq || (depth0 && depth0.eq),options={hash:{},inverse:self.noop,fn:self.program(6, program6, data),data:data},helper ? helper.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), "n---d", options) : helperMissing.call(depth0, "eq", ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), "n---d", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " parent-group\" id=\"triggers-group\">\n                ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.program(13, program13, data),fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                <li class=\"editpage hide new_input\">\n                    <span name=\"triggers\" class=\"triggers\">\n                        <input type=\"text\" value=\"\" class=\"js-autocommit group-vals\" />\n                        <span class=\"delete-tag delete triggers\"><i class=\"ddgsi-close\"></i></span>\n                    </span>\n                </li>\n                <li class=\"editpage add_input\" id=\"add_trigger\">\n                    <div class=\"btn btn--secondary listbutton\" id=\"add_trigger_button\" title=\"Add trigger\">\n                        <i class=\"ddgsi-plus\" />\n                    </div>\n                </li>\n            </ul>\n        ";
  return buffer;
  }
function program9(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.staged)),stack1 == null || stack1 === false ? stack1 : stack1.triggers), {hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program10(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n                        <li>\n                            <span class=\"triggers\">\n                                <input type=\"text\" value=\""
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "\" class=\"js-autocommit group-vals\" />\n                                <span class=\"delete-tag delete triggers\"><i class=\"ddgsi-close\"></i></span>\n                            </span>\n                        </li>\n                        ";
  stack1 = (helper = helpers.module_zero || (depth0 && depth0.module_zero),options={hash:{},inverse:self.noop,fn:self.program(11, program11, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.index), 3, options) : helperMissing.call(depth0, "module_zero", (data == null || data === false ? data : data.index), 3, options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                    ";
  return buffer;
  }
function program11(depth0,data) {
  
  
  return "\n                            <span class=\"clearfix\"></span>\n                        ";
  }

function program13(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }

function program15(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.triggers), {hash:{},inverse:self.noop,fn:self.program(16, program16, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  return buffer;
  }
function program16(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                    "
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0));
  stack1 = helpers.unless.call(depth0, (data == null || data === false ? data : data.last), {hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n                ";
  return buffer;
  }
function program17(depth0,data) {
  
  
  return ", ";
  }

function program19(depth0,data) {
  
  
  return "\n                <span class=\"no-available\">No triggers applied.</span>\n            ";
  }

  stack1 = (helper = helpers.ne_and || (depth0 && depth0.ne_and),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.dev_milestone), "live", "deprecated", options) : helperMissing.call(depth0, "ne_and", (depth0 && depth0.dev_milestone), "live", "deprecated", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
(function(env) {

    //


    env.DDH = {

    };


})(window);

(function(env) {
    // Handlebars helpers for IA Pages

    // Return the string correctly formatted with newlines
    Handlebars.registerHelper("newlines", function(string) {
        string = string.replace(/\n/g, "<br />");

        return new Handlebars.SafeString(string);
    });

    // Return elapsed time expressed as days from now (e.g. 5 days, 1 day, today)
    Handlebars.registerHelper("timeago", function(date, full) {
        var timestring = full? " days ago" : "d";
        if (date) {
            // expected date format: YYYY-MM-DDTHH:mm:ssZ e.g. 2011-04-22T13:33:48Z
            date = date.replace("/T.*Z/", " ");
            date = moment.utc(date, "YYYY-MM-DD");
            
            var elapsed = parseInt(moment().diff(date, "days", true));
            date = elapsed + timestring;

            return date;
        }
    });

    // Format the full date and convert time to local timezone time
    Handlebars.registerHelper("format_time", function(date) {
        if (date) {
            var offset = moment().local().utcOffset();

            // expected date format: YYYY-MM-DDTHH:mm:ssZ e.g. 2011-04-22T13:33:48Z
            date = date.replace("T", " ").replace("Z", " ");
            date = moment.utc(date, "YYYY-MM-DD HH:mm:ss");
            date = date.add(offset, "m");
            date = date.format('D MMM YYYY HH:mm');
            return date;
        }
     });

     // Return true if date1 is before date2
     Handlebars.registerHelper("is_before", function(date1, date2, options) {
        if (moment.utc(date1).isBefore(date2)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
     });

    /**
     * @function plural
     *
     * Returns the value of `context` (assuming `context` is a **number**)
     * and appends the singular or plural form of the specified word,
     * depending on the value of `context`
     *
     * @param {string} singular Indicates the singular form to use
     * @param {string} plural   Indicates the plural form to use
     * @param {string} delimiter **[optional]** Format the number with the `numFormat` helper
     *
     * Example:
     *
     * `{plural star_rating singular="star" plural="stars"}}`
     *
     * Will produce:
     * - `{{star_rating}} star`  if the value of `star_rating` is `1`, or
     * - `{{star_rating}} stars` if `star_rating` > `1`
     *
     */
    Handlebars.registerHelper("plural", function(num, options) {
        var singular = options.hash.singular || '',
            plural   = options.hash.plural || '',
            word = (num === 1) ? singular : plural;

        if (options.hash.delimiter){
            num = Handlebars.helpers.numFormat(num, options);
        }

        return word;
    });

    Handlebars.registerHelper("exists", function(obj, key, options) {
       if (obj && obj.hasOwnProperty(key)) {
           return options.fn(this);
       } else {
           return options.inverse(this);
       }
    });

    Handlebars.registerHelper("exists_subkey", function(obj, key, subkey, options) {
        if (obj && obj[key] && obj[key].hasOwnProperty(subkey)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    Handlebars.registerHelper("n_exists", function(obj, key, options) {
        if (!obj || !obj.hasOwnProperty(key)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    Handlebars.registerHelper("n_exists_subkey", function(obj, key, subkey, options) {
        if (!obj || !obj[key] || !obj[key].hasOwnProperty(subkey)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if v1 or v2 (or both) are true
    Handlebars.registerHelper('or', function(v1, v2, options) {
        if (v1 || v2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });


    // True if the two vals are false
    Handlebars.registerHelper('unless_and', function(v1, v2, options) {
        if ((!v1) && (!v2)) {
            return options.fn(this);
        } else {
             return options.inverse(this);
        }
    });

    // Check if two values are equal
    Handlebars.registerHelper('eq', function(value1, value2, options) {
        if (value1 === value2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // Check if two values are different
    Handlebars.registerHelper('not_eq', function(value1, value2, options) {
        if (value1 !== value2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if first value is different both from the second and from the third
    Handlebars.registerHelper('ne_and', function(value1, value2, value3, options) {
        if (value1 !== value2 && value1 !== value3) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if the first value is equal to the second
    // or to the third
    Handlebars.registerHelper('eq_or', function(value1, value2, value3, options) {
        if (value1 === value2 || value1 === value3) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if the first value is greater than the second
    Handlebars.registerHelper('gt', function(value1, value2, options) {
        if (value1) {
            value1 = (typeof value1 == 'number')? value1 : value1.length;
            if (value1 > value2) {
                return options.fn(this);
            } else {
                return options.inverse(this);
            }
        } else {
            return options.inverse(this);
        }
    });

    // Return the array value at the specified index
    Handlebars.registerHelper('index', function(array, idx) {
        if (array[idx]) {
            return array[idx];
        }
    });

    Handlebars.registerHelper('tab_url', function(tab) {
        if (tab && tab.length) {
            return '&ia=' + tab.toLowerCase().replace(/\s/g, "");
        }
    });

    // Strip non-alphanumeric chars from a string and transform it to lowercase
    Handlebars.registerHelper('slug', function(txt) {
        txt = txt? txt.toLowerCase().replace(/[^a-z0-9]/g, '') : '';
        return txt;
    });

    // Urify string
    Handlebars.registerHelper('urify', function(txt) {
        txt = txt.toLowerCase().replace(/[^a-z]+/g, '-');
        return txt;
    });

    // Remove specified chars from a given string
    // and replace it with specified char/string (optional)
    Handlebars.registerHelper('replace', function(txt, to_remove, replacement) {
        replacement = replacement? replacement : '';
        to_remove = new RegExp(to_remove, 'g');

        txt = txt.replace(to_remove, replacement);
        return txt;
    });

    // Returns true for values equal to zero, evaluating to false
    Handlebars.registerHelper('is_false', function(value, options) {
        value = parseInt(value);
        if (!value) {
            return options.fn(this);
        }
    });

    // Returns true if any value in the array is false
    Handlebars.registerHelper('is_false_array', function(val1, val2, val3, val4, val5, val6, options) {
        if ((!val1) || (!val2) || (!val3) || (!val4) || (!val5) || (!(val6 && val6.length))) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // Returns true for values equal to 1, evaluating to true
    Handlebars.registerHelper('is_true', function(value, options) {
        value = parseInt(value);
        if (value) {
            return options.fn(this);
        }
    });

    // Check if object has key
    Handlebars.registerHelper('not_null', function(key, options) {
        if (key || key === '') {
            return options.fn(this);
        }
    });

    //Return final path of URL
    Handlebars.registerHelper('final_path', function(url) {
        if(url) {
            url = url.replace(/.*\/([^\/]*)$/,'$1');
        }
        return url;
    });

    // Loop n times
    Handlebars.registerHelper('loop_n', function(n, context, options) {
        var result = '';
        for(var i = 0; i < n; i++) {
            if (context[i]) {
                result += options.fn(context[i]);
            }
        }

        return result;
    });

    // Parse date
    Handlebars.registerHelper('parse_date', function(date) {
        date = date.replace(/T.*/, '').split('-');
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
        var year = date[0] || '';
        var month = date[1]? months[parseInt(date[1].replace('0', '')) - 1] : '';
        var day = date[2] || '';

        return month + ", " + day + " " + year;
    });

    // Returns true if value1 % value2 equals zero
    Handlebars.registerHelper('module_zero', function(value1, value2, options) {
        if ((value1 % value2 === 0) && (value1 > 1)) {
             return options.fn(this);
        }
    });

    // return the length of an array
    Handlebars.registerHelper('length', function(obj) {
        if(Array.isArray(obj)){
            return obj.length;
        }
    });

    // return sum of up to 4 values
    Handlebars.registerHelper('sum', function(v1, v2, v3, v4) {
        var values = [v1, v2, v3, v4];
        var total = 0;
        for(var i = 0; i < values.length; i++){
            if( typeof values[i] == 'number' ){
                total += values[i];
            }
        }
        return total;
    });

    // return total number of IAs since a given number of days
    // obj: array of IA objects
    // days: int
    // operator: 'less-than' 'greater-than'
    Handlebars.registerHelper('stats_from_day', function(obj, days, operator) {
        var calc = function(date, operator) {
            var days_from = function(tmpdate){
                var dateObj = moment.utc(tmpdate, "YYYY-MM-DD");
                var elapsed = parseInt(moment().diff(dateObj, "days", true));
                return elapsed;
            };

            if(operator == 'less-than'){
                if(days_from(date) < days){
                    return 1;
                }
            }
            if(operator == 'greater-than'){
                if(days_from(date) > days){
                    return 1;
                }
            }
            
        };

        var total = 0;
        if(obj){
            for(var i = 0; i < obj.length; i++){
                if( calc(obj[i].created_date, operator) ){
                        total++;
                }
            }
        }
        return total;
    });

})(DDH);

(function(env) {

    DDH.IADeprecated = function() {
        this.init();
    };

    DDH.IADeprecated.prototype = {

        init: function() {
            // 
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

            $.getJSON(url, function(data) { 
                // 
                var ia_deprecated = Handlebars.templates.dev_pipeline_deprecated(data.deprecated);
                $("#deprecated").html(ia_deprecated);

                if (data.ghosted) {
                    var ia_ghosted = Handlebars.templates.dev_pipeline_deprecated(data.ghosted);
                    $("#ghosted").html(ia_ghosted);
                }
            });

            $(".toggle-ghosted").click(function() {
                $(this).children("i").toggleClass("icon-check-empty");
                $(this).children("i").toggleClass("icon-check");
                $("#ghosted").toggleClass("hide");
            });
        }
    };
})(DDH);
 

(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {
        filters: [
            'missing',
            'important',
            'mentioned',
            'attention'
        ],

        current_filter: '',

        by_priority: false,

        query: '',

        data: {},

        init: function() {
	    $('#wrapper').css('min-width', '1200px');

            // 
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            $.getJSON(url, function(data) { 
                // 
                // Check user permissions and add to the data
                if ($("#create-new-ia").length) {
                    data.permissions = {};
                    data.permissions.admin = 1;
                    $("#sort_pipeline select option:selected").val(0);
                    dev_p.by_priority = true;
                }

                // Get username for the at mentions filter
                var username = $.trim($(".header-account-info .user-name").text());
                data.username = username;

                dev_p.data = data;
                
                var stats = Handlebars.templates.dev_pipeline_stats(data.dev_milestones);

                sort_pipeline();

                $("#pipeline-stats").html(stats);

                if ($.trim($("#select-action option:selected").text()) === "type") {
                    $("#select-milestone").addClass("hide");
                    $("#select-type").removeClass("hide");
                }

                // 100% width
                $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
		        $(".breadcrumb-nav").remove();

                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    var param_count = 0;

                    for (var idx = 0; idx < parameters.length; idx++) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];

                        if (field && value && ((dev_p.filters.indexOf(value) !== -1) || field === "q")) {
                            if ((field === "q") && value) {
                                $(".search-thing").val(decodeURIComponent(value.replace(/\+/g, " ")));

                                //create return keypress event
                                var evt = $.Event("keypress");
                                evt.which = 13;
                                $(".search-thing").trigger(evt);
                                param_count++;
                            } else if (field === "filter") {
                                $("#filter-" + value).trigger("click");
                                param_count++;
                            }
                        }
                    }

                    if (param_count === 0) {
                        filter('', true);
                    }
                } else {
                    filter('', true);
                }
            });

            $("body").on("click", "#asana-create", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    create_task($.trim($("#edit-sidebar-id").val()));
                    $(this).addClass("disabled");
                }
            });

            $("body").on("click", "#pipeline_toggle-dev", function(evt) {
                dev_p.query = "";

                $(".search-thing").val("");
                $(".active-filter").removeClass("active-filter");
                filter('', true);
            });

            $("body").on("change", "#sort_pipeline select", function(evt) {
                var option = parseInt($(this).find("option:selected").val());
                
                dev_p.by_priority = option? false : true;
                
                sort_pipeline();
            });

            $("body").on("focusin", "#id-input.not_saved", function(evt) {
                $(this).removeClass("not_saved");
            });

            $("body").on("keypress", ".search-thing", function(evt) {
                if(evt.type === "keypress" && evt.which === 13) {
                    dev_p.query = $(this).val();
                    $("#pipeline-clear-filters").removeClass("hide");
                    filter();
                }
            });

            $("body").on("click", "#beta_install", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    $(this).addClass("disabled");
                    var prs = [];
                    $(".dev_pipeline-column__list .selected").each(function(idx) {
                        var temp_pr = $.trim($(this).find(".item-activity a").attr("href"));
                        var temp_hash = pr_hash(temp_pr);

                        if (temp_hash) {
                            prs.push(temp_hash);
                        }
                    });

                    if (prs.length) {
                        send_to_beta(JSON.stringify(prs));
                    }
                }
            });

            $("body").on("click", "#beta-single", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    $(this).addClass("disabled");
                    var prs = [];
                    var pr = $.trim($("#pr").attr("href"));
                    var tmp_hash = pr_hash(pr);

                    if (pr_hash) {
                        prs.push(tmp_hash);
                        send_to_beta(JSON.stringify(prs));
                    }
                }
            });

            $("body").on("click", ".dev_pipeline-column__list li", function(evt) {
                var $items = $(".dev_pipeline-column__list .selected");
                var was_selected = $(this).hasClass("selected");
                var multiselect = false;
                
                if (evt.shiftKey || was_selected || (!dev_p.data.hasOwnProperty("permissions"))) {
                    if ((!dev_p.data.hasOwnProperty("permissions"))) {
                        $(".selected").removeClass("selected");
                    }
                    
                    $(this).toggleClass("selected");
                    if (evt.shiftKey) {
                        evt.preventDefault();
                        multiselect = true;
                    }
                } else {
                    $items.toggleClass("selected"); 
                
                    if (!was_selected) {
                        $(this).toggleClass("selected");
                    }
                }
                
                // can't use caching here since the set of selected IAs changed
                // in the meantime
                var selected = $(".dev_pipeline-column__list .selected").length;
                
                if (selected > 1) {
                    $(".pipeline-actions").removeClass("hide");
                } else {
                    $(".pipeline-actions").addClass("hide");
                }

                appendSidebar(selected, multiselect);
            });

            $('body').on('focus', '.edit-sidebar', function(evt) {
            var focus_class = $(this).data('focus-class');
            if(focus_class) {
                $(this).addClass(focus_class);
            }
            });

            $('body').on('blur', '.edit-sidebar', function(evt) {
            $(this).removeClass('frm__input').removeClass('frm__text');
            });

            $("body").on("keypress change", ".edit-sidebar", function(evt) {
                if ((evt.type === "keypress" && evt.which === 13) || (evt.type === "change" && $(this).children("select").length)) {
                   var field = $(this).attr("id").replace("edit-sidebar-", "");
                   if ((field !== "description") || (field === "description" && evt.ctrlKey)) {
                       var value = (evt.type === "change")? $.trim($(this).find("option:selected").text()) : $.trim($(this).val());
                       var id = $("#page_sidebar").attr("ia_id");

                       autocommit(field, value, id);
                   }
                }
            });

            $("body").on("click", "#sidebar-close, .deselect-all", function(evt) {
                var $selected = $(".dev_pipeline-column__list .selected");
                $selected.removeClass("selected");

                // remove sidebar
                appendSidebar(0);
               
                
                if (dev_p.saved) {
                    var jqxhr = $.getJSON(url, function (data) {
                        dev_p.saved = false;
                        dev_p.data.dev_milestones = data.dev_milestones;

                        //var iadp = Handlebars.templates.dev_pipeline(data);
                        //$("#dev_pipeline").html(iadp);
                        sort_pipeline();
                        filter();
                    });
                }
            });

             $("body").on("click", ".pipeline-filter", function(evt) {
                if (!$(this).hasClass("active-filter")) {
                    $(".active-filter").removeClass("active-filter");
                    $(this).addClass("active-filter");
                    var which_filter = $(this).attr("id").replace("filter-", "");
                    
                    filter(which_filter);
                    
                } else {
                    $(this).removeClass("active-filter");
                    filter('', true);
                }
            });

            $("body").on("keypress change", ".pipeline-actions__select, .pipeline-actions__input", function(evt)  {
                if ((evt.type === "keypress" && evt.which === 13 && $(this).hasClass("pipeline-actions__input")) 
                   || (evt.type === "change" && $(this).hasClass("pipeline-actions__select"))) {
                    var ias = [];
                    var field, value;
                    if (evt.type === "change") {
                        field = $.trim($(this).attr("id").replace("select-", ""));
                        value = $.trim($(this).find("option:selected").text().replace(/\s/g, "_"));
                    } else {
                        field = $.trim($(this).attr("id").replace("input-", ""));
                        value = $.trim($(this).val());
                    }

                    $(".dev_pipeline-column__list .selected").each(function(idx) {
                        var temp_id = $.trim($(this).attr("id").replace("pipeline-list__", ""));
                        
                        ias.push(temp_id);
                    });

                    ias = JSON.stringify(ias);
                    save_multiple(ias, field, value);
                }
            });

            $("body").on("click", ".toggle-details i", function(evt) {
                toggleCheck($(this));

                $(".activity-details").toggleClass("hide");
            });

            $("#select-teamrole").change(function(evt) {
                if ($("#filter-team_checkbox").hasClass("icon-check")) {
                    $(".dev_pipeline-column__list li").hide();

                    var teamrole = $(this).find("option:selected").text();
                    $(".dev_pipeline-column__list li." + teamrole + "-" + username).show();
                }
            });

            function pr_hash(href) {
                var temp_pr_id = href.replace(/.*\//, "");
                var temp_repo = href.replace(/^.*\/duckduckgo\//, "").replace(/\/[a-zA-Z0-9]*\/[a-zA-Z0-9]*\/?/, "");

                if (temp_pr_id && temp_repo) {
                    var temp_hash = 
                        {
                            "action" : "duckco",
                            "number" : temp_pr_id,
                            "repo" : temp_repo
                        };
                    return temp_hash;
                }

                return false;
            }

            function send_to_beta(prs) {
                var jqxhr = $.post("/ia/send_to_beta", {
                    data : prs
                })
                .done(function(data) {
                    dev_p.saved = true;
                });
            }

            function autocommit(field, value, id) {
               var jqxhr = $.post("/ia/save", {
                   field : field,
                   value : value,
                   id : id,
                   autocommit : 1
               })
               .done(function(data) {
                   if (data.result.saved) {
                       dev_p.saved = true;
                   }
               });
            }

            function toggleCheck($obj) {
                $obj.toggleClass("icon-check");
                $obj.toggleClass("icon-check-empty");
            }

            function appendSidebar(selected, multi) {
                $("#page_sidebar, #actions_sidebar").addClass("hide").empty();
                $("#page_sidebar").attr("ia_id", "");
                
                if ((!multi) && selected === 1) {
                    var $item = $(".dev_pipeline-column__list .selected");
                    var meta_id = $item.attr("id").replace("pipeline-list__", "");
                    var milestone = $item.parents(".dev_pipeline-column").attr("id").replace("pipeline-", "");
                    var page_data = getPageData(meta_id, milestone);
                    page_data.permissions = dev_p.data.permissions;
                    if (page_data) {
                        var sidebar = Handlebars.templates.dev_pipeline_detail(page_data);            
                    
                        $("#page_sidebar").html(sidebar).removeClass("hide");
                        $("#page_sidebar").attr("ia_id", page_data.id);
                    }
                } else if (multi && selected > 1) {
                   var actions_data = {};
                   actions_data.permissions = dev_p.data.permissions;
                   actions_data.selected = selected;
                   actions_data.beta = 1;
                   actions_data.got_prs = 0;
                   var same_type = true;
                   var temp_type = '';

                   $(".dev_pipeline-column__list .selected").each(function(idx) {
                       var meta_id = $(this).attr("id").replace("pipeline-list__", "");
                       var milestone = $(this).parents(".dev_pipeline-column").attr("id").replace("pipeline-", "");
                       var page_data = getPageData(meta_id, milestone);
                        
                       // If at least one of the selected IAs isn't on beta we show the "install on beta" button
                       if (page_data.beta_install !== "success") {
                           actions_data.beta = 0;
                       }

                       if (page_data.pr && page_data.pr.issue_id) {
                           actions_data.got_prs = 1;
                       }

                       if ((page_data.repo !== temp_type) && (temp_type !== '')) {
                           same_type = false;
                       } else if (temp_type === '') {
                           temp_type = page_data.repo;
                       }
                   });

                   if (!same_type) {
                       actions_data.got_prs = 0;
                   }

                   var actions_sidebar = Handlebars.templates.dev_pipeline_actions(actions_data);
                   $("#actions_sidebar").html(actions_sidebar).removeClass("hide");
                }
            }

            function getPageData(meta_id, milestone) {
                
                
                for (var idx = 0; idx < dev_p.data.dev_milestones[milestone].length; idx++) {
                    var temp_ia = dev_p.data.dev_milestones[milestone][idx];

                    if (temp_ia.id === meta_id) {
                        return temp_ia;
                    }
                }
            }
            
            function elapsed_time(date) {
                date = moment.utc(date.replace("/T.*Z/", " "), "YYYY-MM-DD");
                return parseInt(moment().diff(date, "days", true));
            }

            // Sort each milestone array by priority
            function sort_pipeline() {
                $.each(dev_p.data.dev_milestones, function (key, val) {
                    $.each(dev_p.data.dev_milestones[key], function (temp_ia) {
                        var priority_val = 0;
                        var priority_msg = '';

                        var ia = dev_p.data.dev_milestones[key][temp_ia];

                        if (dev_p.by_priority) {
                            // Priority is higher when:
                            // - last activity (especially comment) is by a contributor (non-admin)
                            // - last activity happened long ago (the older the activity, the higher the priority)
                            if (ia.pr && ia.pr.issue_id) {
                                if (ia.last_comment) {
                                    priority_val += ia.last_comment.admin? -20 : 20;
                                    var idle_comment = elapsed_time(ia.last_comment.date);
                                    if (ia.last_comment.admin) {
                                        priority_val -= 20;
                                        priority_val += idle_comment;
                                        priority_msg += "- 20 (last comment by admin) \n+ elapsed time since last comment \n";
                                    } else {
                                        priority_val += 20;
                                        priority_val += (2 * idle_comment);
                                        priority_msg += "+ 20 (last comment by contributor) \n+ twice the elapsed time since last comment \n";
                                    }
                                } if (ia.last_commit) {
                                    var idle_commit = elapsed_time(ia.last_commit.date);
                                    if (ia.last_comment &&  moment.utc(ia.last_comment.date).isBefore(ia.last_commit.date)) {
                                        priority_val += (1.5 * idle_commit);
                                        priority_msg += "+ 1.5 times the elapsed time since last commit (made after last comment) \n";
                                    } else if ((!ia.last_comment) && (!ia.last_commit.admin)) {
                                        priority_val += (2 * idle_commit);
                                        priority_msg += "+ twice the elapsed time since last commit (there are no comments in the PR) \n";
                                    }
                                }

                                // Priority drops if the PR is on hold
                                if (ia.pr && ia.pr.issue_id) {
                                    var tags = ia.pr.tags;

                                    $.each(tags, function(idx) {
                                        var tag = tags[idx];
                                        if (tag.name.toLowerCase() === "on hold") {
                                            priority_val -= 100;
                                             priority_msg += "- 100: the PR is on hold \n";
                                        } else if (tag.name.toLowerCase() === "priority: high") {
                                            priority_val += 20;
                                             priority_msg += "+ 20: the PR is high priority \n";
                                        }
                                    });
                                }

                                // Priority is higher if the user has been mentioned in the last comment
                                if (ia.at_mentions && ia.at_mentions.indexOf(dev_p.data.username) !== -1) {
                                    priority_val += 50;
                                     priority_msg += "+ 50: you have been @ mentioned in the last comment \n";
                                }

                                // Has a PR, so it still has more priority than IAs which don't have one
                                if (priority_val <= 0) {
                                    priority_val = 1;
                                    priority_msg += "final value is 1: there's a PR, so it's higher priority than IAs without a PR \n";
                                }
                            }

                            dev_p.data.dev_milestones[key][temp_ia].priority = priority_val;
                            dev_p.data.dev_milestones[key][temp_ia].priority_msg = priority_msg;
                        }
                    });
                        
                    dev_p.data.dev_milestones[key].sort(function (l, r) {
                        var a, b;
                        if (dev_p.by_priority) {
                            a = l.priority;
                            b = r.priority;
                        } else {
                            a = l.last_update? - elapsed_time(l.last_update) : -100;
                            b = r.last_update? - elapsed_time(r.last_update) : -100;
                        }

                        if (a > b) {
                            return -1;
                        } else if (b > a) {
                            return 1;
                        }
                            
                        return 0;
                    });
                });

                dev_p.data.by_priority = dev_p.by_priority;
                var iadp = Handlebars.templates.dev_pipeline(dev_p.data);
                $("#dev_pipeline").html(iadp);
                filterCounts();
                if (dev_p.data.permissions && dev_p.data.permissions.admin) {
                    $(".mentioned, .attention").addClass("dog-ear");
                }
            }

            // Add counts to filters
            function filterCounts() {
                $(".pipeline-filter").each(function(idx) {
                    var temp_filter = $(this).attr("id").replace("filter-", "");
                    var temp_count = $(".dev_pipeline-column__list li." + temp_filter).length;
                    $("#count-" + temp_filter).text(temp_count);
                });
            }

            function create_task(id) {
                var jhxqr = $.post("/ia/asana", {
                    id : id
                })
                .done(function(data) {
                    
                    dev_p.saved = true;
                });
                    
            }

            function filter(which_filter, reset) {
                var query = dev_p.query? dev_p.query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&") : '';
                var url = "";
                var $obj = $(".dev_pipeline-column__list li");

                $obj.hide();
                if (which_filter) {
                    url += "&filter=" + which_filter;
                    which_filter = "." + which_filter;
                } else {
                    which_filter = reset? "" : dev_p.current_filter;
                }

                dev_p.current_filter = which_filter;
                $obj = $(".dev_pipeline-column__list li" + which_filter);
                var $children = $obj.children(".item-name");

                if (query) {
                    var regex = new RegExp(query, "gi");
                    url = "&q=" + encodeURIComponent(query.replace(/\x5c/g, "")).replace(/%20/g, "+") + url;
                    
                    $children.each(function(idx) {
                        if (regex.test($(this).text())) {
                            $(this).parent().show();
                        }
                    });
                } else {
                    $obj.show();
                }

                url = url.length? "?" + url.replace("#", "").replace("&", ""): "/ia/dev/pipeline";

                // Allows changing URL without reloading, since it doesn't add the new URL to history;
                // Not supported on IE8 and IE9.
                history.pushState({}, "Index: Instant Answers", url);
                updateCount();
            }

            function updateCount() {
                var all_visible = $("#dev_pipeline .item-name:visible").length;
                var planning_visible = $("#dev_pipeline #pipeline-planning__list .item-name:visible").length;
                var development_visible =  $("#dev_pipeline #pipeline-development__list .item-name:visible").length;
                var testing_visible = $("#dev_pipeline #pipeline-testing__list .item-name:visible").length;
                var complete_visible = $("#dev_pipeline #pipeline-complete__list .item-name:visible").length;
                
                //$("#pipeline-stats h1").text(all_visible + " Instant Answers in progress");
                $("#pipeline-planning .milestone-count").text(planning_visible);
                $("#pipeline-development .milestone-count").text(development_visible);
                $("#pipeline-testing .milestone-count").text(testing_visible);
                $("#pipeline-complete .milestone-count").text(complete_visible);
            }

            function save_multiple(ias, field, value) {
                var jqxhr = $.post("/ia/save_multiple", {
                    field : field,
                    value : value,
                    ias : ias
                })
                .done(function(data) {
                    dev_p.saved = true;
                });
            }
        }
    };
})(DDH);
 

(function(env) {

    DDH.IAIndex = function() {
        this.init();
    };

    DDH.IAIndex.prototype = {

        sort_field: '',
        sort_asc: 1,    // sort ascending
        selected_filter: {
            dev_milestone: '',
            repo: '',
            topic: '',
            template: ''
        },

        init: function() {
            //
            var ind = this;
            var url = "/ia/json";
            var $list_item;
            var $clear_filters;
            //var right_pane_top;
            //var right_pane_left;
            var $right_pane;
            var window_top;
            var $dropdown_header;
            var $input_query;
            var query = ""; 
            ind.ia_list = ia_init();

            ind.refresh();
            $list_item = $("#ia-list .ia-item");
            $clear_filters = $("#clear_filters");
            $right_pane = $("#filters");
            //right_pane_top = $right_pane.offset().top;
            //right_pane_left = $right_pane.offset().left;
            $dropdown_header = $right_pane.children(".dropdown").children(".dropdown_header");
            $input_query = $('#filters input[name="query"]');

            var parameters = window.location.search.replace("?", "");
            parameters = $.trim(parameters.replace(/\/$/, ''));
            if (parameters) {
                parameters = parameters.split("&");

                var param_count = 0;

                $.each(parameters, function(idx) {
                    var temp = parameters[idx].split("=");
                    var field = temp[0];
                    var value = temp[1];
                    if (field && value && (ind.selected_filter.hasOwnProperty(field) || field === "q")) {
                        if (ind.selected_filter.hasOwnProperty(field)) {
                            var selector = "ia_" + field + "-" + value;
                            selector = (field === 'topic')? "." + selector : "#" + selector;
                            $(selector).parent().trigger("click");
                            param_count++;
                        } else if ((field === "q") && value) {
                            $input_query.val(decodeURIComponent(value.replace(/\+/g, " ")));
                            $(".filters--search-button").trigger("click");
                            param_count++;
                        }
                    }
                });

                if (param_count === 0) {
                    ind.filter($list_item, query);
                }
            } else {
                ind.filter($list_item, query);
            }

            $(document).click(function(evt) {
                if (!$(evt.target).closest(".dropdown").length) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                }
            });

            /*$(window).resize(function(evt) {
                if ($right_pane.hasClass("is-fixed")) {
                    $right_pane.removeClass("is-fixed");
                    right_pane_left = $right_pane.offset().left;
                    $right_pane.addClass("is-fixed");
                    $right_pane.css('left', right_pane_left + "px");
                } else {
                    right_pane_left = $right_pane.offset().left;
                    right_pane_top = $right_pane.offset().top;
                }
            });*/

            $(".filters--search-button").hover(function() {
                $(this).addClass("search-button--hover");
            }, function() {
                $(this).removeClass("search-button--hover");
            });
            
            $("body").on("click keypress", "#search-ias, #filters .one-field input.text, .filters--search-button", function(evt) {
                
                //

                if (((evt.type === "keypress" && evt.which === 13) && $(this).hasClass("text"))
                    || (evt.type === "click" && $(this).hasClass("filters--search-button"))) {
                    var temp_query = $.trim($input_query.val());
                    if (temp_query !== query) {
                        query = temp_query;
                        ind.filter($list_item, query);
                        if ($clear_filters.hasClass("hide")) {
                            $clear_filters.removeClass("hide");
                        }
                    }
                }
            });

            $("body").on("click", "#ia-list .ia-item", function(evt) {
                if (!$(evt.target).closest(".ia-item--header").length
                    && !$(evt.target).closest(".topic").length) {
                    var $img = $(this).find(".ia-item--details--img");
                    if ($img.hasClass("hide")) {
                        $img.removeClass("hide");
                        var data_img = $img.children(".ia-item--img").attr("data-img");
                        $img.children(".ia-item--img").attr("src", data_img);
                    } else {
                        $img.addClass("hide");
                    }
                } 
            });

            $("body").on("click", "#filters .dropdown .dropdown_header", function(evt) {
                var $list = $(this).parent().children("ul");
                if ($list.hasClass("hide") && !$(this).parent().hasClass("disabled")) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                    $list.removeClass("hide");
                } else {
                    $list.addClass("hide");
                }
            });

            /*$(window).scroll(function(evt) {
                var window_top = $(window).scrollTop();

                if (right_pane_top < window_top) {
                    if (!$right_pane.hasClass("is-fixed")) {
                        $right_pane.addClass("is-fixed");
                        $right_pane.css('left', right_pane_left + "px");
                    }
               } else {
                    if ($right_pane.hasClass("is-fixed")) {
                        $right_pane.removeClass("is-fixed");
                    }
                }
            });*/

            $("#filters .ddgsi-close-grid").click(function() {
                $("#filters").addClass("hide-small");
            });

            $("#ia_index_header .ddgsi-menu").click(function() {
                $("#filters").removeClass("hide-small");
            });

            $(".breadcrumb-nav").hide();

            $("body").on("click", "#clear_filters", function(evt) {
                $(this).addClass("hide");
                query = "";
                ind.selected_filter.dev_milestone = "";
                ind.selected_filter.repo = "";
                ind.selected_filter.topic = "";
                ind.selected_filter.template = "";

                $input_query.val("");

                $dropdown_header.each(function(idx) {
                    var text = $(this).parent().children("ul").children("li:first-child").text();
                    $(this).children("span").text($.trim(text.replace(/\([0-9]+\)/g, "")));
                });

                $(".is-selected").removeClass("is-selected");
                $("#ia_dev_milestone-all").addClass("is-selected");
                $("#ia_repo-all, #ia_topic-all, #ia_template-all").parent().addClass("is-selected");

                $(".button-group-vertical").find(".ia-repo").removeClass("fill");
                ind.filter($list_item);
            });

            $("body").on("click", ".button-group .button, .button-group-vertical .row, .topic", function(evt) {

                //

                if (!$(this).hasClass("disabled") && !$(this).parent().parent().parent().hasClass("disabled")) { 
                    if($(this).hasClass("row")) {
                        $(this).parent().find(".ia-repo").removeClass("fill");
                        $(this).find(".ia-repo").addClass("fill");
                    }

                    if (!$(this).hasClass("is-selected")) {
                        var $parent = $(this).parent();

                        $parent.find(".is-selected").removeClass("is-selected");
                        $(this).addClass("is-selected");

                        if ($clear_filters.hasClass("hide")) {
                            $clear_filters.removeClass("hide");
                        }


                        if ($parent.parent().hasClass("dropdown")) {
                            $parent.parent().children(".dropdown_header").children("span").text($.trim($(this).text().replace(/\([0-9]+\)/g, "")));
                            $parent.parent().children("ul").addClass("hide");
                        }
                    }

                    ind.selected_filter.dev_milestone = "." + $("#filter_dev_milestone .is-selected").attr("id");
                    ind.selected_filter.repo = "." + $("#filter_repo .is-selected a").attr("id");

                    if($(this).hasClass("topic")) {
                        ind.selected_filter.topic = "." + $(this).data("topic");
                    } else {                        
                        ind.selected_filter.topic = "." + $("#filter_topic .is-selected a").attr("id");
                    }

                    ind.selected_filter.template = "." + $("#filter_template .is-selected a").attr("id");

                    if (ind.selected_filter.dev_milestone === ".ia_dev_milestone-all") {
                        ind.selected_filter.dev_milestone = "";
                    }

                    if (ind.selected_filter.repo === ".ia_repo-all") {
                        ind.selected_filter.repo = "";
                    }

                    if (ind.selected_filter.topic === ".ia_topic-all") {
                        ind.selected_filter.topic = "";
                    }

                    if (ind.selected_filter.template === ".ia_template-all") {
                        ind.selected_filter.template = "";
                    }

                    if($(this).hasClass("topic")) {
                        $("#filter_topic").find("li").removeClass("is-selected");
                        $("#" + $(this).data("topic")).parent().addClass("is-selected");
                        $("#filter_topic").find(".dropdown_header span").text($(this).text());
                    }

                    query = $.trim($input_query.val());

                    ind.filter($list_item, query);
                }
            });
        },

        filter: function($obj, query) {
            var repo = this.selected_filter.repo;
            var dev_milestone = this.selected_filter.dev_milestone;
            var topic = this.selected_filter.topic;
            var template = this.selected_filter.template;
            var regex;
            var url = "";

            if (query) {
                
                query = query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
                regex = new RegExp(query, "gi");
                url += "&q=" + encodeURIComponent(query.replace(/\x5c/g, "")).replace(/%20/g, "+");
            }

            if (!query && !repo.length && !topic.length && !dev_milestone.length && !template.length) {
                $obj.show();
            } else {
                $obj.hide();
                $.each(this.selected_filter, function(key, val) {
                    if (val) {
                        if (key === "topic") {
                            val = val.replace(".", "#");
                            val = $(val).attr("class").replace("ia_topic-", "");
                        } else {
                            val = val.replace(".ia_" + key + "-", "");
                        }
                        
                        url += "&" + key + "=" + val;
                    }
                });

                var $children = $obj.children(dev_milestone + repo + topic + template);
               
                var temp_name;
                var temp_desc;
                if (regex) {
                    $children.each(function(idx) {
                        temp_name = $.trim($(this).find(".ia-item--header").text());
                        temp_desc = $.trim($(this).find(".ia-item--details--bottom").text());

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            $(this).parent().show();
                        }
                    });
                } else {
                    $children.parent().show();
                }
            }

            url = url.length? "?" + url.replace("#", "").replace("&", ""): "/ia";
            
            // Allows changing URL without reloading, since it doesn't add the new URL to history;
            // Not supported on IE8 and IE9.
            history.pushState({}, "Index: Instant Answers", url);

            this.count($obj, $("#filter_repo ul li a"), regex, dev_milestone + topic + template);
            this.count($obj, $("#filter_topic ul li a"), regex, dev_milestone + repo + template);
            this.count($obj, $("#filter_template ul li a"), regex, dev_milestone + repo + topic);
        },

        count: function($list, $obj, regex, classes) {
            var temp_text;
            var id;
            var selector_all = "";
            var text_all;
            var tot_count = 0;

            $("#ia_index_header h2").text("Showing " + $(".ia-item:visible").length + " Instant Answers");
            
            $obj.each(function(idx) {
                temp_text = $.trim($(this).text().replace(/\([0-9]+\)/g, ""));
                id = "." + $(this).attr("id");
                
                // First row of each section will have the count equal to the sum of the other rows counts
                // in that section, except for topics, because an IA can have more than one topic
                if (id === ".ia_repo-all" || id === ".ia_template-all" || id === ".ia_dev_milestone-all") {
                    selector_all = id.replace(".", "#");
                    text_all = temp_text;
                    return;
                } else if (id === ".ia_topic-all") {
                    id = "";
                }
                
                var $children = $list.children(classes + id);  
                if (regex) {
                    var temp_name;
                    var temp_desc;
                    var children_count = 0;

                    $children.each(function(idx) {
                        temp_name = $.trim($(this).find(".ia-item--header").text());
                        temp_desc = $.trim($(this).find(".ia-item--details--bottom").text());

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            children_count++;
                        }
                    });

                    temp_text += " (" + children_count + ")";
                    tot_count += children_count;
                } else {
                    temp_text += " (" + $children.length + ")";
                    tot_count += $children.length;
                }
                    
                $(this).text(temp_text);
            });
            
            if (selector_all !== "") {
                text_all += " (" + tot_count + ")";
                $(selector_all).text(text_all);

                if (selector_all !== "#ia_repo-all") {
                    if (tot_count === 0) {
                        $(selector_all).parent().parent().parent().addClass("disabled");
                    } else {
                        $(selector_all).parent().parent().parent().removeClass("disabled");
                    }
                }
            }
        },

        sort: function(what) {
            //

            // reverse
            if (this.sort_field == what) {
                this.sort_asc = 1 - this.sort_asc;
            }
            else {
                this.sort_asc = 1; // reset
            }

            this.sort_field = what;
            var ascending = this.sort_asc;

            this.ia_list.sort(function(l,r) {

                // sort direction
                if (ascending) {
                    var a=l, b=r;
                }
                else {
                    var a=r; b=l;
                }

                
                if (a[what] > b[what]) {
                    return 1;
                }

                if (a[what] < b[what]) {
                    return -1;
                }

                return 0;
            });
            
            this.refresh();
        },

        refresh: function() {
            var iap = Handlebars.templates.index({ia: this.ia_list});
            $("#ia_index").html(iap);
        }

    };

})(DDH);

(function(env) {

    DDH.IAIssues = function() {
        this.init();
    };

    DDH.IAIssues.prototype = {

        sort_by_date: false,
        selected_tag: '',

        init: function() {
            // 
            var issues_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

            $.getJSON(url, function(data) { 
                // 
                var ia_issues;
                ia_issues = Handlebars.templates.issues(data);
                $("#issues").html(ia_issues);

                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    $.each(parameters, function(idx) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];
                        if ((field === "tag") && value) {
                            $("#issue-" + value).trigger("click");
                        } else if ((field === "sort") && (value === "date")) {
                            $("#sort_date").trigger("click");
                        }
                    });
                }
            });

            $("body").on('click', "#sort_date", function(evt) {
                issues_p.sort_by_date = true;
                $("#pipeline-live__list .by_ia_item").addClass("hide");
                issues_p.filter();
            });

            $("body").on('click', "#sort_ia", function(evt) {
                issues_p.sort_by_date = false;
                $("#pipeline-live__list .by_date_item").addClass("hide");
                issues_p.filter();
            });

            $("body").on('click', ".filter-issues__item__checkbox", function(evt) {
                var url = "";

                if ($(this).hasClass("icon-check-empty")) {
                    $(".filter-issues__item__checkbox.icon-check").removeClass("icon-check").addClass("icon-check-empty");

                    $(this).removeClass("icon-check-empty");
                    $(this).addClass("icon-check");

                    issues_p.selected_tag = "." + $(this).attr("id");
                } else {
                    $(this).removeClass("icon-check");
                    $(this).addClass("icon-check-empty");
                    issues_p.selected_tag = '';
                }

                issues_p.filter();
            });
        },

        filter: function() {
            var selector = this.sort_by_date? "#pipeline-live__list .by_date_item" : "#pipeline-live__list .by_ia_item";
            var url = this.sort_by_date? "&sort=date" : "";

            if (this.selected_tag.length) {
                var value = this.selected_tag.replace(".issue-", "");
                url += "&tag=" + value;
                
                $(selector).addClass("hide");
                $(selector + " .list-container--right__issues li").addClass("hide");
                $(selector + this.selected_tag).removeClass("hide");
                $(selector + " .list-container--right__issues li" + this.selected_tag).removeClass("hide");
            } else {
                $(selector).removeClass("hide");
                $(selector + " .list-container--right__issues li").removeClass("hide");
            }

            url = url.length? "?" + url.replace("#", "").replace("&", "") : "issues";
            
            // Allows changing URL without reloading, since it doesn't add the new URL to history;
            // Not supported on IE8 and IE9.
            history.pushState({}, "IA Pages Issues", url);
        }
    };
})(DDH);
 

(function(env) {

    DDH.IAOverview = function() {
        this.init();
    };

    DDH.IAOverview.prototype = {

        init: function() {
            // 
            var overview = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            $.getJSON(url, function(data) { 
                var template = Handlebars.templates.overview(data);

                $("#ia-overview").html(template);
            });

             $("body").on("click", "#create-new-ia", function(evt) {
                $(this).hide();
                $("#create-new-ia-form").removeClass("hide");
            });

            $("body").on('click', "#new-ia-form-cancel", function(evt) {
                $("#create-new-ia-form").addClass("hide");
                $("#create-new-ia").show();
            });

            $("body").on('click', "#new-ia-form-save", function(evt) {
                var $id_input = $("#id-input");
                var name = $.trim($("#name-input").val());
                var id = $.trim($id_input.val());
                var description = $.trim($("#description-input").val());
                var dev_milestone = $.trim($("#dev_milestone-select .available_dev_milestones option:selected").text());
                
                if (name.length && id.length && dev_milestone.length && description.length) {
                    id = id.replace(/\s/g, '');

                    var jqxhr = $.post("/ia/create", {
                        name : name,
                        id : id,
                        description : description,
                        dev_milestone : dev_milestone
                    })
                    .done(function(data) {
                        if (data.result && data.id) {
                            window.location = '/ia/view/' + data.id;
                        } else {
                            $id_input.addClass("not_saved");
                        }
                    });
                }
            });
        }
    };
})(DDH); 

(function(env) {
    function dropdownLength(value, add) {
        if(value.length <= 5 && value.length > 0) {
            return (value.length + (add || 0)) * 8;
        }

        return (value.length + (add || 0)) * 8 || 150;
    }

    // Handlebars helpers
    Handlebars.registerHelper('encodeURIComponent', encodeURIComponent);

    DDH.IAPage = function(ops) {
        this.init(ops);
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPage.prototype = {
        init: function(ops) {
            //

            var page = this;
            var json_url = "/ia/view/" + DDH_iaid + "/json";

            if (DDH_iaid) {
                //

                $.getJSON(json_url, function(ia_data) {
                    //Get user permissions
                    ia_data.permissions = {};
                    if ($(".special-permissions").length) {
                        ia_data.permissions = {can_edit: 1};

                        // Preview switch must be on "edited" by default
                        ia_data.preview = 1;

                        ia_data.edit_count = ia_data.edited ? Object.keys(ia_data.edited).length : 0;

                        if ($("#view_commits").length) {
                            ia_data.permissions.admin = 1;
                        }

                        if(ia_data.live.test_machine && ia_data.live.example_query) {
                            ia_data.live.can_show = true;
                        }
                    
                        ia_data.edited_dev_milestone = ia_data.edited.dev_milestone;
                    }

                    // Allow blue band to get 100% page width
                    $(".site-main > .content-wrap").first().removeClass("content-wrap");
                    $(".breadcrumb-nav").remove();

                    // Separate back-end files from front-end ones
                    ia_data.live.back_end = [];
                    ia_data.live.front_end = [];
                    if (ia_data.live.code) {
                        front_end = ["handlebars", "js", "css", "json"];
                        back_end = ["pm", "t"];
                        $.each(ia_data.live.code, function(idx) {
                            var file = ia_data.live.code[idx];
                            var type = file.replace(/.*\.([^\.]*)$/,'$1');

                            if ($.inArray(type, front_end) !== -1) {
                                ia_data.live.front_end.push(file);
                            } else if ($.inArray(type, back_end) !== -1) {
                                ia_data.live.back_end.push(file);
                            }
                        });
                    }

                    // Show latest edits for admins and users with edit permissions
                    var latest_edits_data = {};
                    if (ia_data.edited || (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")) {
                        latest_edits_data = page.updateData(ia_data, latest_edits_data, true);
                    } else {
                        latest_edits_data = ia_data.live;
                    }

                    

                    // Readonly mode templates
                    var readonly_templates = {
                        live: {
                            name : Handlebars.templates.name(latest_edits_data),
                            top_details : Handlebars.templates.top_details(latest_edits_data),
                            description : Handlebars.templates.description(latest_edits_data),
                            examples : Handlebars.templates.examples(latest_edits_data),
                            devinfo : Handlebars.templates.devinfo(latest_edits_data),
                            github: Handlebars.templates.github(latest_edits_data),
                            edit_buttons: Handlebars.templates.edit_buttons(latest_edits_data),
                            breadcrumbs: Handlebars.templates.breadcrumbs(latest_edits_data),
                            triggers: Handlebars.templates.triggers(latest_edits_data),
                            test: Handlebars.templates.test(latest_edits_data),
                            advanced:  Handlebars.templates.advanced(latest_edits_data),
                            traffic: Handlebars.templates.traffic(latest_edits_data)
                        },
                        screens : Handlebars.templates.screens(ia_data),
                    };

                    // Pre-Edit mode templates
                    var pre_templates = {
                        name : Handlebars.templates.pre_edit_name(ia_data),
                        status : Handlebars.templates.pre_edit_status(ia_data),
                        description : Handlebars.templates.pre_edit_description(ia_data),
                        topic : Handlebars.templates.pre_edit_topic(ia_data),
                        example_query : Handlebars.templates.pre_edit_example_query(ia_data),
                        other_queries : Handlebars.templates.pre_edit_other_queries(ia_data),
                        dev_milestone : Handlebars.templates.pre_edit_dev_milestone(ia_data),
                        template : Handlebars.templates.pre_edit_template(ia_data),
                        perl_module : Handlebars.templates.pre_edit_perl_module(ia_data),
                        producer : Handlebars.templates.pre_edit_producer(ia_data),
                        designer : Handlebars.templates.pre_edit_designer(ia_data),
                        developer : Handlebars.templates.pre_edit_developer(ia_data),
                        tab : Handlebars.templates.pre_edit_tab(ia_data),
                        repo : Handlebars.templates.pre_edit_repo(ia_data),
                        src_api_documentation : Handlebars.templates.pre_edit_src_api_documentation(ia_data),
                        api_status_page : Handlebars.templates.pre_edit_api_status_page(ia_data),
                        unsafe : Handlebars.templates.pre_edit_unsafe(ia_data),
                        answerbar : Handlebars.templates.pre_edit_answerbar(ia_data),
                        triggers :  Handlebars.templates.pre_edit_triggers(ia_data),
                        perl_dependencies :  Handlebars.templates.pre_edit_perl_dependencies(ia_data),
                        src_options : Handlebars.templates.pre_edit_src_options(ia_data),
                        src_id : Handlebars.templates.pre_edit_src_id(ia_data),
                        src_name : Handlebars.templates.pre_edit_src_name(ia_data),
                        src_domain : Handlebars.templates.pre_edit_src_domain(ia_data),
                        is_stackexchange : Handlebars.templates.pre_edit_is_stackexchange(ia_data),
                        id : Handlebars.templates.pre_edit_id(ia_data),
                        blockgroup: Handlebars.templates.pre_edit_blockgroup(ia_data),
                        deployment_state: Handlebars.templates.pre_edit_deployment_state(ia_data)
                    };

                    page.updateAll(readonly_templates, ia_data, false);

                    $('body').on("click", "#show-all-issues", function(evt) {
                        $(this).hide();
                        $(".ia-issues ul li").show();
                    });

                    $("#view_json").click(function(evt) {
                        location.href = json_url;
                    });

                    function tagLength(value) {
                        if(value.length <= 10 && value.length > 0) {
                            return (value.length + 5) * 8;
                        }
                        return value.length * 8 || 100;
                    }

                    $("body").on("click", "#beta-install", function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            $(this).addClass("disabled");
                            var temp_hash = {
                                "action" : "duckco",
                                "number" : ia_data.live.pr.id,
                                "repo" : "zeroclickinfo-" + ia_data.live.repo
                            };
                            beta_install(temp_hash);
                        }
                    });

                    $("body").on("change", "select.top-details.js-autocommit", function(evt) {
                        if($(this).hasClass("topic")) {
                            $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                        } else {
                            $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                        }
                    });

                    $("body").on("keydown", ".ia-examples input[type='text'], .ia-triggers input[type='text']", function(evt) {
                        if(tagLength(this.value) > 100) {
                            $(this).css("width", tagLength(this.value) + "px");
                        }
                    });

                    $("body").on("click", ".devpage-edit", function(evt) {
                        evt.preventDefault();

                        $(".ia-examples input[type='text'], .ia-triggers input[type='text']").each(function() {
                            $(this).css("width", tagLength(this.value) + "px");
                        });

                        var $parent = $(this).parent().parent();

                        $(this).addClass("hide");
                        $(this).siblings(".devpage-commit, .devpage-cancel").removeClass("hide");

                        // Show editable field and hide readonly field
                        $parent.children(".hidden-toshow").removeClass("hide");
                        $parent.children(".readonly--info").addClass("hide");
                    });

                    // This shows the contributor's popup.
                    $("body").on("click", ".devpage-edit-popup", function(evt) {
                        evt.preventDefault();

                        var field = $(this).attr("id").replace("dev-edit-", "");
                        var $popup = $("#" + field + "-popup");

                        $popup.removeClass("hide");

                        // It should also show a blue background.
                        $("#edit-modal").removeClass("hide");
                        $popup.find(".save-button-popup").removeClass("is-disabled");
                    });

                    $("body").on("click", "#edit-modal", function(evt) {
                        $(this).addClass("hide");
                        $("#contributors-popup").addClass("hide");
                    });

                    $("body").on("click", "#asana_button", function(evt) {
                        if(!$(this).hasClass("is-disabled")) {
                            create_task(DDH_iaid);
                            $(this).addClass("is-disabled");
                        }
                    });

                    $("body").on("click", ".devpage-cancel", function(evt) {
                        evt.preventDefault();

                        var field = $(this).attr("id").replace(/dev\-cancel\-/, "");

                        if (ia_data.staged && ia_data.staged[field]) {
                            // Remove any unsaved edits and then refresh Handlebars
                            if (field === "example_query" || field === "other_queries") {
                                delete ia_data.staged.example_query;
                                delete ia_data.staged.other_queries;
                            } else {
                                delete ia_data.staged[field];
                            }
                        }

                        keepUnsavedEdits(field);
                    });

                    $("body").on("click", "#js-top-details-cancel", function(evt) {
                        if (!$(this).hasClass("is-disabled")) {
                            // Remove any unsaved edits
                            if (ia_data.staged && ia_data.staged.top_details) {
                                delete ia_data.staged.top_details;
                            }

                            keepUnsavedEdits("top_details");

                            // Make sure to update the widths of the topics.
                            $("select.top-details.js-autocommit").each(function() {
                                if($(this).hasClass("topic")) {
                                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                                } else {
                                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                                }
                            });
                        }
                    });

                    $('body').on("change keypress focusout", ".available_types, .developer_username input", function(evt) {
                        if ((evt.type === "change" && $(this).hasClass("available_types")) || (evt.type === "keypress" && evt.which === 13)
                             || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var $available_types;
                            var $dev_username;
                            var $parent;

                            if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                                $parent = $(this).parent().parent().parent();
                            } else {
                                $parent =  $(this).parent();
                            }

                            $dev_username = $parent.find(".developer_username input");
                            $available_types = $parent.find(".available_types");

                            if ($(this).hasClass("focused")) {
                                $(this).removeClass("focused");
                            }

                            var type = $.trim($available_types.find("option:selected").text());
                            var username = $.trim($dev_username.val());

                            if (username && type && (type !== "ddg")) {
                                usercheck(type, username, $available_types, $dev_username);
                            } else if (type && (type === "ddg")) {
                                $dev_username.val("http://www.duckduckhack.com");
                                $parent.find(".developer input").val("DDG Team");
                                $dev_username.parent().removeClass("invalid");
                                $available_types.parent().removeClass("invalid");
                            }
                        }
                    });

                    $("body").on("focusout keypress", "#producer-input", function(evt) {
                        if ((evt.type === "keypress" && evt.which === 13) || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var username = $(this).val();

                            if (username) {
                                usercheck("duck.co", username, null, $(this));
                            }
                        }
                    });

                    $('body').on("focusin", ".developer_username input, #producer-input", function(evt) {
                        if (!$(this).hasClass("focused")) {
                            $(this).addClass("focused");
                            var $parent = $(this).hasClass("group-vals")? $(this).parent().parent() : $(this).parent();
                            var $error = $parent.find(".ddgsi-warning").parent();
                            var $valid = $parent.find(".ddgsi-check-sign").parent();

                            $error.addClass("hide");
                            $valid.addClass("hide");

                            $("#contributors-popup .save-button-popup").removeClass("is-disabled");
                        }
                    });

                    $("body").on('click', "#edit_activate", function(evt) {
                        page.updateAll(pre_templates, ia_data, true);
                        $("#edit_disable").removeClass("hide");
                        $(this).hide();

                        if (ia_data.permissions.admin && ia_data.edit_count) {
                            $("#view_commits").removeClass("hide");
                        }
                    });

                    $('body').on('click', '.switch.js-switch', function(evt) {
                        var $preview =  $(this).parent();
                        if (!$preview.hasClass("is-on")) {
                            $preview.addClass("is-on");
                            ia_data.preview = 0;
                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                        } else {
                            $preview.removeClass("is-on");
                            ia_data.preview = 1;
                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, true);
                        }

                        page.updateAll(readonly_templates, ia_data, false);
                        Screens.render();
                    });

                    // Generate a screenshot
                    //
                    // UI States:
                    // - If we're logged in
                    //     - There is no screenshot at all
                    //         - Show top generate button part
                    //         - Hide the desktop/mobile switcher buttons
                    //         - Show there-is-no-screenshot message
                    //         - When the generate button is clicked:
                    //             - The screenshot loads.
                    //                 - While the screenshot loads, disable the "Generate Screenshot" button.
                    //                 - The screenshot succeeds
                    //                     - Show desktop view as a default
                    //                 - The screenshot fails
                    //                     - When the screenshot fails, show an error message
                    //     - There is a screenshot and we want to take another
                    //         - Show refresh screenshot button over the image.
                    //         - Show the desktop/mobile switcher buttons
                    //         - When the refresh button is clicked:
                    //             - The screenshot loads
                    //                 - While the screenshot loads, disable the refresh button and the switcher buttons
                    //                 - The screenshot succeeds
                    //                     - When the new screenshot loads, make sure we stay on the current view, i.e., stay on desktop
                    //                       if we're on desktop view and stay on mobile if we're on the mobile view
                    //                 - The screenshot fails
                    //                     - When the screenshot fails, show an error message
                    //                     - Show a message that the user can click on to revert back to the old screenshot
                    //                         - When the user clicks on the revert button, make sure to return to the old view (desktop/mobile)
                    // - If we're not logged in
                    //     - If there is a screenshot
                    //         - Show the screenshots
                    //         - Show the switcher buttons
                    //         - Don't show the refresh button
                    //         - Don't show the generate screenshot button
                    //     - If there is no screenshot
                    //         - Show the screenshot
                    //         - Don't show the switcher buttons
                    //         - Don't show the generate screenshot button
                    //         - Don't show the refresh button

                    var capitalize = function(str) {
                        if(str) {
                            return str.charAt(0).toUpperCase() + str.slice(1);
                        }
                        return "";
                    };

                    window.Screens = {
                        render: function() {
                            Screens.resetState();
                            Screens.hasScreenshot(function() {
                                Screens.setScreenshotImage();
                                Screens.setRefreshButton();
                                Screens.setSwitcherButtons();
                            }, function() {
                                Screens.setMessage("There are no screenshots for the query '" + capitalize(ia_data.live.example_query) + "'.");
                                Screens.setTakeScreenshotButton();
                            });
                        },
                        resetState: function() {
                            Screens.state.refreshClicked = false;
                            Screens.state.generateClicked = false;
                            Screens.state.isError = false;
                            Screens.state.isLoading = false;
                            Screens.state.isMobile = false;
                            Screens.disableLoadingAnimation();
                            Screens.enableRefreshButton();
                            Screens.enableTakeScreenshotButton();
                            Screens.disableScreenshotImage();
                        },
                        data: {
                            url: function() {
                                var image = Screens.state.isMobile ? 'mobile' : 'index';
                                return 'https://images.duckduckgo.com/iu/?u=' +
                                       encodeURIComponent('https://ia-screenshots.s3.amazonaws.com/' + DDH_iaid + '_' + image + '.png?nocache=' + Math.floor(Math.random() * 10000)) +
                                       '&f=1';
                            },
                            createImageEndpoint: 'https://jag.duckduckgo.com/screenshot/create/' + DDH_iaid,
                            saveImageEndpoint: 'https://jag.duckduckgo.com/screenshot/save/' + DDH_iaid
                        },
                        events: {
                            refreshClick: {
                                evt: 'click',
                                selector: '.generate-screenshot',
                                fn: function() {
                                    if(!Screens.state.refreshClicked) {
                                        Screens.toggleState("refreshClicked");

                                        Screens.disableRefreshButton();
                                        Screens.disableScreenshotImage();
                                        Screens.setLoadingAnimation();
                                        Screens.state.isLoading = true;
                                        Screens.generateImage(function() {
                                            Screens.toggleState("refreshClicked");
                                            Screens.render();
                                            Screens.state.isLoading = false;
                                        });
                                    }
                                }
                            },
                            generateClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher--generate .btn',
                                fn: function() {
                                    if(!Screens.state.generateClicked) {
                                        Screens.toggleState("generateClicked");

                                        Screens.disableTakeScreenshotButton();
                                        Screens.disableMessage();
                                        Screens.setLoadingAnimation();
                                        Screens.state.isLoading = true;
                                        Screens.generateImage(function() {
                                            Screens.toggleState("generateClicked");
                                            Screens.render();
                                            Screens.state.isLoading = false;
                                        }, true);
                                    }
                                }
                            },
                            revertClick: {
                                evt: 'click',
                                selector: '.revert',
                                fn: function(event) {
                                    event.preventDefault();
                                    $('.revert').hide();
                                    $('.default-message').hide();
                                    Screens.render();
                                }
                            },
                            mobileClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher .platform-mobile',
                                fn: function(event) {
                                    if(!Screens.state.isError && !Screens.state.isLoading) {
                                        Screens.state.isMobile = true;
                                        $('.mobile-faux__container').show();
                                        $('.screenshot-desktop').hide();
                                        Screens.setScreenshotImage();
                                        Screens.setOpacity();
                                    }
                                }
                            },
                            desktopClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher .platform-desktop',
                                fn: function(event) {
                                    if(!Screens.state.isError && !Screens.state.isLoading) {
                                        Screens.state.isMobile = false;
                                        $('.mobile-faux__container').hide();
                                        $('.screenshot-desktop').show();
                                        Screens.setScreenshotImage();
                                        Screens.setOpacity();
                                    }
                                }
                            }
                        },
                        state: {
                            refreshClicked: false,
                            generateClicked: false,
                            isMobile: false,
                            isError: false,
                            isLoading: false
                        },
                        toggleState: function(state) {
                            Screens.state[state] = !Screens.state[state];
                        },
                        setOpacity: function() {
                            if(Screens.state.isMobile) {
                                $('.screenshot-switcher .platform-desktop').parent().addClass('remove-border');
                                $('.screenshot-switcher .platform-mobile').parent().removeClass('remove-border');

                                $('.screenshot-switcher .platform-mobile').removeClass('add-opacity');
                                $('.screenshot-switcher .platform-desktop').addClass('add-opacity');
                            } else {
                                $('.screenshot-switcher .platform-desktop').parent().removeClass('remove-border');
                                $('.screenshot-switcher .platform-mobile').parent().addClass('remove-border');

                                $('.screenshot-switcher .platform-mobile').addClass('add-opacity');
                                $('.screenshot-switcher .platform-desktop').removeClass('add-opacity');
                            }
                        },
                        generateImage: function(callback, isFirst) {
                            function failedMessage() {
                                Screens.disableScreenshotImage();
                                Screens.disableLoadingAnimation();
                                Screens.setMessage("Screenshot Failed", true, isFirst);

                                Screens.state.isError = true;
                            }

                            var nocache = Math.floor(Math.random() * 10000);
                            $.post(Screens.data.createImageEndpoint + "?nocache=" + nocache, function(data) {
                                if(data && data.status === "ok" && data.screenshots && data.screenshots.index) {
                                    $.post(Screens.data.saveImageEndpoint + "?nocache=" + nocache, function() {
                                        Screens.state.isError = false;
                                        callback();
                                    });
                                } else {
                                    failedMessage();
                                }
                            }).fail(failedMessage);
                        },
                        enableRefreshButton: function() {
                            $('.generate-screenshot')
                                .removeClass('btn--alternative')
                                .addClass('btn--primary');
                        },
                        enableTakeScreenshotButton: function() {
                            $('.screenshot-switcher--generate .btn')
                                .removeClass('btn--wire')
                                .addClass('btn--primary');
                        },
                        setMessage: function(message, enableRevert, isFirst) {
                            $('.screenshot--status').show();
                            $('.screenshot--status .default-message').show().text(message);

                            if(enableRevert) {
                                this.setEvent(this.events.revertClick);
                                if(isFirst) {
                                    Screens.toggleState("generateClicked");
                                    Screens.enableTakeScreenshotButton();
                                } else {
                                    $('.revert').show();
                                }
                            }
                        },
                        setLoadingAnimation: function() {
                            $('.screenshot--status').show();
                            $('.screenshot--status .loader').show();
                        },
                        setRefreshButton: function() {
                            $('.generate-screenshot').removeClass("hide");
                            this.setEvent(this.events.refreshClick);

                            $('.screenshot-switcher--generate').addClass("hide");
                        },
                        setTakeScreenshotButton: function() {
                            $('.screenshot-switcher').hide();
                            $('.screenshot-switcher--generate').removeClass("hide");

                            this.setEvent(this.events.generateClick);
                        },
                        setSwitcherButtons: function() {
                            $('.screenshot-switcher').show();
                            Screens.setEvent(Screens.events.mobileClick);
                            Screens.setEvent(Screens.events.desktopClick);
                        },
                        setScreenshotImage: function() {
                            var image = Screens.state.isMobile ? 'mobile' : 'desktop';

                            var screenshotImage = $('.ia-single--screenshots img.screenshot-' + image);
                            screenshotImage.attr('src', this.data.url());
                            screenshotImage.show();
                        },
                        disableScreenshotImage: function() {
                            $('.ia-single--screenshots img.screenshot-desktop').hide();
                            $('.mobile-faux__container').hide();
                        },
                        setEvent: function(eventData) {
                            $(eventData.selector).on(eventData.evt, eventData.fn);
                        },
                        disableLoadingAnimation: function() {
                            $('.screenshot--status').hide();
                            $('.screenshot--status .loader').hide();
                        },
                        disableRefreshButton: function() {
                            $('.generate-screenshot')
                                .removeClass('btn--primary')
                                .addClass('btn--alternative');
                        },
                        disableTakeScreenshotButton: function() {
                            $('.screenshot-switcher--generate .btn')
                                .removeClass('btn--primary')
                                .addClass('btn--wire');
                        },
                        disableMessage: function() {
                            $('.screenshot--status').hide();
                            $('.screenshot--status .default-message').hide();
                        },
                        hasScreenshot: function(succeed, failed) {
                            $("<img src='" + this.data.url() + "'>")
                                .on("load", function() {
                                    succeed();
                                })
                                .error(function() {
                                    failed();
                                });
                        }
                    };

                    Screens.render();

                    $("body").on('click', ".js-expand.button", function(evt) {
                        var milestone = $(this).parent().parent().attr("id");
                        $(".container-" + milestone + "__body").toggleClass("hide");
                        $(this).children("i").toggleClass("icon-caret-up");
                        $(this).children("i").toggleClass("icon-caret-down");
                    });

                    $("body").on("change", '.ia-single--details input[type="number"].js-autocommit', function(evt) {
                        resetSaved($(this));

                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                    });

                    $("body").on("focusin", "textarea.js-autocommit, input.js-autocommit", function(evt) {
                        resetSaved($(this));
                    });

                    $("body").on("keydown", ".ia-single--details .js-autocommit", function(evt) {
                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                    });

                    $("body").on("click", "select.js-autocommit", function(evt) {
                        var $obj;

                        if ($(this).hasClass("topic-group")) {
                            $obj = $(".js-autocommit.topic");
                        } else {
                            $obj = $(this);
                        }

                        resetSaved($obj);
                    });

                    // Dev Page: commit test machine on change
                    $("body").on("change", ".test_machine.js-autocommit", function(evt) {
                        commitEdit($(this));
                    });

                    $("body").on("focusin", ".topic-group.js-autocommit", function(evt) {
                        $(".top__repo, .top__milestone").hide();
                        $("#topic-cancel").removeClass("hide");
                    });

                    $("body").on("blur", ".topic-group.js-autocommit", function(evt) {
                        $(".top__repo, .top__milestone").show();
                        $("#topic-cancel").addClass("hide");
                        if ($(".topic-group.js-autocommit").length < 2) {
                            $("#add_topic").removeClass("hide");
                        }
                    });

                    $("body").on("change", "select.top-details.js-autocommit", function(evt) {
                        $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");

                        // Display topics as tags
                        if ($(this).hasClass("topic-group")) {
                            $(".topic-group.js-autocommit").trigger("blur");
                        }
                    });

                    $("body").on("keydown", "#name-input", function(evt) {
                        $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");
                    });

                    // Cancel an editing attempt on topics and remove any new empty topics
                    $("body").on("click", "#topic-cancel", function(evt) {
                        $(".topic-group.js-autocommit").each(function(idx) {
                            if ((!$(this).val()) && (!$(this).hasClass("new_empty_topic"))) {
                                $(this).parent().parent().addClass("hide").removeClass("js-autocommit");
                            }
                        });

                        $(".topic-group.js-autocommit").trigger("blur");
                    });

                    $("body").on('click', "#contributors-popup .cancel-button-popup", function(evt) {
                        $("#contributors-popup").addClass("hide");
                        $("#edit-modal").hide();
                    });

                    $("body").on("keypress", ".other_queries.js-autocommit, #example_query-input", function(evt) {
                        if (evt.keyCode === 13) {
                            $(".other_queries.js-autocommit, #example_query-input").trigger("blur");
                        }
                    });

                    //Dev Page: commit fields in the details section
                    $("body").on("click", "#devpage-commit-details", function(evt) {
                        evt.preventDefault();

                        var $details = $("#ia-single--details .js-autocommit");
                        
                        // There's only one section group for fatheads and one for spices,
                        // so we check if it's been saved already in order to avoid useless 
                        // multiple POST requests
                        var section_done = false;
                        var to_commit = [];

                        $details.each(function(idx) {
                            if ((!section_done) || (!$(this).hasClass("section-group__item"))) {
                                if ($(this).hasClass("section-group__item")) {
                                    section_done = true;
                                }
                                
                                to_commit.push(getUnsavedValue($(this)));
                            }
                        });

                        commitMultiple(to_commit);

                        $("#devpage-commit-details, #devpage-cancel-details").addClass("hide");
                    });

                    // Dev Page: cancel edits in the details section
                    $("body").on("click", "#devpage-cancel-details", function(evt) {
                        evt.preventDefault();

                        if (ia_data.staged && ia_data.staged.details) {
                            delete ia_data.staged.details;
                        }
                        
                        keepUnsavedEdits("details");
                    });

                    $("body").on("click", "#ia-single--details .frm__label__chk.js-autocommit", function(evt) {
                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                        if (!$(this).attr("checked")) {
                            $(this).attr("checked", ":checked");
                        } else {
                            $(this).removeAttr("checked");
                        }
                    });

                    // Dev Page: commit checkboxes in the testing section
                    $("body").on("click", ".testing-section .js-autocommit", function(evt) {
                        evt.preventDefault();
                        commitEdit($(this));
                    });

                    // Dev Page: commit fields in the blue band
                    $("body").on('click', "#js-top-details-submit", function(evt) {
                        if (!$(this).hasClass("is-disabled")) {
                            var $editable = $(".top-details.js-autocommit");
                            var field;
                            var is_json = false;
                            var topic_done = false;

                            
                            $editable.each(function(idx) {
                                field = $(this).hasClass("topic-group")? "topic" : "";
                                is_json = field === "topic"? true : false;

                                // Make sure we try to commit topics just once
                                if ((field !== "topic") || (!topic_done)) {
                                    commitEdit($(this), field, is_json);
                                    topic_done = field === "topic"? true : topic_done;
                                }
                            });

                            $("#js-top-details-submit, #js-top-details-cancel").addClass("is-disabled");
                        }
                    });

                    // Dev Page: commit fields inside a popup
                    $("body").on('click', "#contributors-popup .save-button-popup", function(evt) {
                        // We only have a popup for the contributors fields, so far:
                        // try committing developer and then commitEdit() and autocommit() will take care of whether
                        // to commit producer as well (if user has permissions etc).
                        if (!$(this).hasClass("is-disabled")) {
                            var $editable = $(".developer_username input");
                            $(this).addClass("is-disabled");
                            commitEdit($editable, "developer", true);
                        }
                    });

                    // Dev Page: commit any field inside .ia-single--left and .ia-single--right (except popup fields)
                    $("body").on('click', ".devpage-commit", function(evt) {
                        evt.preventDefault();

                        var $parent = $(this).parent().parent();
                        var $editable = $parent.find(".js-autocommit").first();
                        var to_commit = [];

                        if ($parent.hasClass("ia-examples")) {
                            // We pass the fields names as well in case all of them are removed
                            // so we'll be able to commit the empty value for these fields anyway
                            to_commit.push(getUnsavedValue($(".other_queries input"), "other_queries", true));
                            to_commit.push(getUnsavedValue($("#example_query-input"), "example_query"));

                            commitMultiple(to_commit, true);
                        } else {
                            
                            commitEdit($editable);
                        }
                    });

                    $("body").on('click', ".assign-button.js-autocommit", function(evt) {
                        var $input = $(".team-input");
                        var username = $.trim($(".header-account-info .user-name").text());
                        $input.val(username);
                        $("#producer-input").removeClass("focused");
                         $("#contributors-popup .save-button-popup").removeClass("is-disabled");
                        usercheck("duck.co", username, null, $("#producer-input"));
                    });

                    $("body").on('click', '.js-pre-editable.button', function(evt) {
                        var field = $(this).attr('name');
                        var $row = $(this).parent();
                        var $obj = $("#column-edits-" + field);
                        var value = {};

                        value[field] = ia_data.edited[field]? ia_data.edited[field] : ia_data.live[field];

                        $obj.replaceWith(Handlebars.templates['edit_' + field](value));
                        $row.addClass("row-diff-edit");
                        $(this).hide();
                        $row.children(".js-editable").removeClass("hide");

                        if (field === "topic") {
                            page.appendTopics($(".available_topics"));
                        } else if (field === "blockgroup") {
                            page.appendBlockgroup($(".available_blockgroups"));
                        }
                    });

                    $("#edit_disable").on('click', function(evt) {
                        location.reload();
                    });

                    $("body").on('click', '.add_input', function(evt) {
                        evt.preventDefault();

                        var $ul = $(this).closest('ul');
                        var $new_input = $ul.find('.new_input').first().clone();
                        var $last_li = $ul.children('li').last();
                        $last_li.before($new_input.removeClass("hide"));
                        $new_input.removeClass("new_input");

                        if (($(this).attr("id") === "add_example") && ($("#example_query-input").length === 0)
                            && (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")) {
                            var $input = $new_input.find("input");
                            $input.attr("id", "example_query-input");
                            $input.removeClass("group-vals").removeClass("other_queries").addClass("example_query");
                            $new_input.find(".other_queries").removeClass("other_queries").addClass("example_query");
                        }
                    });

                    $("body").on('click', '#add_topic', function(evt) {
                        var topics;
                        topics = $(".topic-separator").length;
                        var $empty_topic = $(".new_empty_topic").clone();
                        $(this).before($empty_topic.removeClass("hide").removeClass("new_empty_topic"));

                        if (topics > 1) {
                            $(this).addClass("hide");
                        }
                    });

                    $("body").on('click', '#view_commits', function(evt) {
                        window.location = "/ia/commit/" + DDH_iaid;
                    });

                    $("body").on("click", ".delete", function(evt) {
                        var field = $(this).attr('name');

                        // If dev milestone is not 'live' it means we are in the dev page
                        if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                            if ($(this).parent().parent().hasClass("topic-separator")) {
                                $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");
                                $("#add_topic").removeClass("hide");
                            } else if ($(this).parent().hasClass("example_query")) {
                                
                                var $first_query = $(".other_queries input.js-autocommit.group-vals").first();
                                
                                if ($first_query.length && (!$first_query.parent().parent().hasClass("new_input"))) {
                                    $first_query.removeClass("group-vals").addClass("example_query");
                                    $first_query.parent().removeClass("other_queries").addClass("example_query");
                                    $first_query.attr("id", "example_query-input");
                                }
                            }

                            $(this).parent().parent().remove();
                        } else {
                            if (field !== "topic") {
                                $(this).parent().remove();
                            } else {
                                var $select = $(this).parent().find('.available_topics');
                                $select.find('option[value="0"]').empty();
                                $select.val('0');
                            }
                        }
                   });

                    $("body").on("click", ".column-right-edits i.icon-check.js-editable", function(evt) {
                        $(this).removeClass("icon-check").addClass("icon-check-empty");
                    });

                    $("body").on("click", ".column-right-edits i.icon-check-empty.js-editable", function(evt) {
                        $(this).removeClass("icon-check-empty").addClass("icon-check");
                    });

                    $("body").on('keypress click', '.js-input, .button.js-editable', function(evt) {
                        if ((evt.type === 'keypress' && (evt.which === 13 && $(this).hasClass("js-input")))
                            || (evt.type === 'click' && $(this).hasClass("js-editable"))) {
                            var field = $(this).attr('name');
                            var value;
                            var is_json = false;
                            var edited_value = ia_data.edited[field];
                            var live_value = ia_data.live[field];
                            var $obj = $("#row-diff-" + field);

                            if ($(this).hasClass("js-input")) {
                                value = $.trim($(this).val());
                            } else if ($(this).hasClass("js-check")) {
                                value = $("#" + field + "-check").hasClass("icon-check")? 1 : 0;
                                
                                
                            } else {
                                var input;
                                if (field === "dev_milestone" || field === "repo" || field === "blockgroup" || field === "deployment_state") {
                                     $input = $obj.find(".available_" + field + "s option:selected");
                                     value = $.trim($input.text());
                                     value = (value === "---")? null : value;
                                     
                                } else {
                                    $input = $obj.find("input.js-input,#description textarea");
                                    value = $.trim($input.val());
                                }
                            }

                            if ((evt.type === "click"
                                && (field === "topic" || field === "other_queries" || field === "triggers" || field === "perl_dependencies" || field === "src_options"))
                                || (field === "answerbar") || (field === "developer")) {
                                if (field !== "answerbar" && field !== "src_options") {
                                    value = getGroupVals(field);
                                } else if (field === "src_options") {
                                    value = {};
                                    value = getSectionVals(null, "src_options-group");
                                } else if (field === "answerbar") {
                                    value = {};
                                    value.fallback_timeout = $("#answerbar input").val();
                                }

                                value = JSON.stringify(value);
                                edited_value = JSON.stringify(ia_data.edited[field]);
                                live_value = JSON.stringify(ia_data.live[field]);
                                is_json = true;
                            }

                            if (value !== edited_value && value !== live_value) {
                                save(field, value, DDH_iaid, $obj, is_json);
                            } else {
                                $obj.replaceWith(pre_templates[field]);
                            }

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    // Check if username exists for the given account type (either github or duck.co)
                    function usercheck(type, username, $type, $username) {
                        var jqxhr = $.post("/ia/usercheck", {
                            type: type,
                            username: username
                        })
                        .done(function(data) {
                            var $parent =  $username.hasClass("group-vals")? $username.parent().parent() : $username.parent();
                            var $error = $parent.find(".ddgsi-warning").parent();
                            var $valid = $parent.find(".ddgsi-check-sign").parent();

                            if (data.result) {
                                $error.addClass("hide");
                                $valid.removeClass("hide");
                            } else {
                                $error.removeClass("hide");
                                $valid.addClass("hide");
                            }
                        });
                    }

                    // Autocommit multiple fields
                    // to_commit is an array of hashes,
                    // each containing field, value, is_json and parent_field (for section group fields)
                    function commitMultiple(to_commit, refresh) {
                        var field;
                        var parent_field;
                        var value;
                        var is_json;
                        refresh = refresh? true : false;

                        $.each(to_commit, function(idx, val) {
                            field = val.field;
                            value = val.value;
                            is_json = val.is_json;
                            parent_field = val.parent_field;
                            var temp_refresh = (idx === (to_commit.length - 1))? refresh : false;
                           
                            var live_data = (ia_data.live[field] && is_json)? JSON.stringify(ia_data.live[field]) : ia_data.live[field];
     
                            
                            
                                                       
                            if (field && (live_data != value)) {
                                if (parent_field) {
                                    autocommit(parent_field, value, DDH_iaid, is_json, field);
                                } else {
                                    // Ensure name has always a value
                                    if (value || (field !== "name")) {
                                        autocommit(field, value, DDH_iaid, is_json);
                                    }
                                }
                            } else if (temp_refresh && ia_data.examples_saved) {
                                // For now we're using this only for example queries
                                // so it's ok to avoid checking for the field here
                                keepUnsavedEdits("example_query");
                            } else if (!ia_data.examples_saved && (field === "example_query" || field === "other_queries")) {
                                ia_data.examples_saved = 1;
                            }
                        });
                    }

                    // Gather data needed for committing an edit and call autocommit
                    function commitEdit($editable, field, is_json) {
                        var field = field? field : "";
                        var parent_field;
                        var value;
                        var is_json = is_json? is_json : false;

                        var result = getUnsavedValue($editable, field, is_json);

                        field = result.field;
                        value = result.value;
                        is_json = result.is_json;
                        parent_field = result.parent_field;

                        var live_data = (ia_data.live[field] && is_json)? JSON.stringify(ia_data.live[field]) : ia_data.live[field];

                        
                        
                        
                        if (field && (live_data != value)) {
                            if (parent_field) {
                                autocommit(parent_field, value, DDH_iaid, is_json, field);
                            } else {
                                // Ensure name has always a value
                                if (value || (field !== "name")) {
                                    autocommit(field, value, DDH_iaid, is_json);
                                }
                            }
                        } else {
                            if (field === "developer" && ia_data.permissions && ia_data.permissions.admin) {
                                commitEdit($("#producer-input"));
                            } else if (!$("#ia-single--details ." + field).length) {
                                keepUnsavedEdits(field);
                            }
                        }
                    }

                    // Get a value for an editable field in the dev page
                    // This is used both for getting a value to commit
                    // and also inside keepUnsavedEdits(), for collecting each unsaved value after commit
                    // before refreshing the Handlebars templates.
                    function getUnsavedValue($editable, field, is_json) {
                        field = field? field : "";
                        var parent_field;
                        var result = {};
                        var value = is_json? JSON.stringify([]) : "";
                        is_json = is_json? is_json : false;

                        if ($editable.length) {
                            if ($editable.hasClass("group-vals")) {
                                is_json = true;
                                field = $editable.parents(".parent-group").attr("id").replace(/\-.+/, "");
                                var $obj = field === "topic"? $(".topic-group.js-autocommit option:selected") : "";
                                value = getGroupVals(field, $obj);
                                value = JSON.stringify(value);
                            } else {
                                field = $editable.attr("id").replace(/\-.+/, "");
                                var editable_type = $editable.attr("id").replace(/.+\-/, "");
                                if (editable_type === "check") {
                                    value = $editable.is(":checked")? 1 : 0;
                                } else if (editable_type === "select") {
                                    var $selected = $editable.find("option:selected");
                                    value = $selected.attr("value").length? $.trim($selected.text()) : '';
                                } else if (editable_type === "input" || editable_type === "textarea") {
                                    value = ($editable.attr("type") === "number")? parseInt($editable.val()) : $.trim($editable.val());

                                    if ($editable.hasClass("comma-separated")) {
                                        value = value.length? JSON.stringify(value.split(/\s*,\s*/)) : "[]";
                                        is_json = true;
                                    }
                                }
                            }

                            if ($editable.hasClass("section-group__item")) {
                                value = "";
                                parent_field = $.trim($editable.parents(".section-group").attr("id"));
                                var section_vals = getSectionVals($editable, parent_field);
                                

                                parent_field = parent_field.replace("-group", "");
                                value = section_vals? JSON.stringify(section_vals) : value;
                                is_json = true;
                            }
                        }

                        result.value = value;
                        result.is_json = is_json;
                        result.field = field;
                        result.parent_field = parent_field;

                        return result;
                    }

                    // Gets values for fields such as topic, developer, other queries
                    // which have an array of values instead of just a single value
                    function getGroupVals(field, $obj) {
                        var $selector;
                        var temp_val;
                        var value = [];

                        if ($obj && $obj.length) {
                            $selector = $obj;
                        } else {
                            if (field === "topic") {
                                $selector = $(".ia_topic .available_topics option:selected");
                            } else if ((ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") && (field === "developer")) {
                                $selector = $(".developer_username input[type='text']");
                            } else {
                                $selector = $("." + field).children("input");
                            }
                        }

                        $selector.each(function(index) {
                            if (field === "developer") {
                                var $li_item = (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")? $(this).parent().parent().parent() : $(this).parent().parent();

                                temp_val = {};
                                temp_val.name = $.trim($(this).val());
                                temp_val.type = $.trim($li_item.find(".available_types").find("option:selected").text()) || "legacy";
                                temp_val.username = $.trim($li_item.find(".developer_username input[type='text']").val());
                                
                                if (!temp_val.username) {
                                    return;
                                }
                            } else {
                                if (field === "topic") {
                                    temp_val = $(this).attr("value").length? $.trim($(this).text()) : "";
                                } else {
                                    temp_val = $.trim($(this).val());
                                }
                            }

                            if (temp_val && $.inArray(temp_val, value) === -1) {
                                value.push(temp_val);
                            }
                        });

                        return value;
                    }

                    // Gets values for section fields, which can contain mixed types of values,
                    // such as src_options, which has both input fields and checkboxes
                    function getSectionVals($obj, parent_field) {
                        var section_vals = {};
                        var temp_field;
                        var temp_value;

                        $("#" + parent_field + " .section-group__item").each(function(idx) {
                            if ($(this) !== $obj) {
                                if ($(this).hasClass("frm__input")
                                    || $(this).hasClass("selection-group__item-input")) {
                                    temp_field = $.trim($(this).attr("id").replace("-input", ""));
                                    temp_value = ($(this).attr("type") === "number")? parseInt($(this).val()) : $.trim($(this).val());
                                } else {
                                    temp_field = $.trim($(this).attr("id").replace("-check", ""));
                                    if ($(this).attr("checked") || $(this).hasClass("icon-check")) {
                                        temp_value = 1;
                                    } else {
                                        temp_value = 0;
                                    }
                                }

                                section_vals[temp_field] = temp_value;
                            }
                        });

                        return section_vals;
                    }

                    function resetSaved($obj) {
                        if ($obj.hasClass("not_saved")) {
                            $obj.removeClass("not_saved");
                            $obj.siblings(".error-notification").addClass("hide");
                        }
                    }

                    // After saving a field inside .ia-single--left or .ia-single--right,
                    // we need to refresh the Handlebars templates: this means that we'd lose any unsaved
                    // edits if other fields were open for editing at the same time.
                    // So before refreshing we collect all the unsaved data and we pass it to the Handlebars
                    // templates, so they will retain the unsaved data and will display those fields as editable
                    // like we left them.
                    function keepUnsavedEdits(field) {
                        var $commit_open = $(".devpage-edit.hide").parent().parent();
                        var secondary_field = "";
                        ia_data.staged = {};
                        var error_save = [];
                        var examples_done = false;
                        field = field? field : "";

                        if ((field === "example_query") || (field === "other_queries")) {
                            secondary_field = (field === "example_query")? "other_queries" : "example_query";
                        }

                        if (ia_data.examples_saved) {
                            delete ia_data.examples_saved;
                        }

                        if ($("#beta-install").hasClass("disabled")) {
                            ia_data.staged.beta = 1;
                        }

                        $commit_open.each(function(idx) {
                            var $unsaved_edits = $(this).find(".js-autocommit").first();
                            
                            var temp_result = getUnsavedValue($unsaved_edits);
                            var temp_field = temp_result.field;

                            if ((temp_field !== field) && (temp_field !== secondary_field)) {
                                var temp_value = temp_result.value;

                                if (temp_result.is_json && temp_value) {
                                    temp_value = $.parseJSON(temp_value);
                                } else if (!temp_value && (temp_field === "example_query") || (temp_field === "triggers")) {
                                    temp_value = "n---d";
                                }
                                
                                if (!examples_done || (temp_field !== "example_query" && temp_field !== "other_examples")) {
                                    ia_data.staged[temp_field] = temp_value;

                                    if (temp_field === "example_query") {
                                        temp_result = getUnsavedValue($(".other_queries input"), "other_queries", true);
                                        temp_value = temp_result.value? $.parseJSON(temp_result.value) : temp_result.value;

                                        ia_data.staged.other_queries = temp_value;
                                        examples_done = true;
                                    } else if (temp_field === "other_queries") {
                                        temp_result = getUnsavedValue($("#example_query-input"), "example_query");
                                        ia_data.staged.example_query = temp_result.value;

                                        examples_done = true;
                                    }
                                }

                                if ($unsaved_edits.hasClass("not_saved") && ($.inArray(temp_field, error_save) === -1)) {
                                    var temp_error = {};
                                    temp_error.field = temp_field;
                                    var $notif = $("." + temp_field).siblings(".error-notification");
                                    temp_error.msg = $notif.text()? $notif.text() : "";
                                    error_save.push(temp_error);
                                }
                            }
                        });

                        // If the submit button is visible it means at least one field
                        // in the top blue band was edited.
                        // Those fields are saved all at once when clicking on submit,
                        // and are always editable for people with permissions,
                        // so we don't know which fields have been modified and which haven't:
                        // let's just take all the current values as unsaved
                        if (!$("#js-top-details-submit").hasClass("is-disabled") && (field !== "top_details")) {
                            ia_data.staged.top_fields = {};
                            $(".top-details.js-autocommit").each(function(idx) {
                                var temp_field;
                                var temp_editable;
                                if (!$(this).hasClass("topic")) {
                                    temp_field = $(this).attr("id").replace(/\-.+/, "");
                                    temp_editable = $(this).attr("id").replace(/.+\-/, "");
                                } else {
                                    temp_field = "topic";
                                    temp_editable = "select";
                                }

                                if (!ia_data.staged.top_fields[temp_field] && (temp_field !== field)) {
                                    temp_result = getUnsavedValue($(this), field, temp_editable);
                                    temp_value = temp_field === "topic"? $.parseJSON(temp_result.value) : temp_result.value;

                                    ia_data.staged.top_fields[temp_field] = temp_value;
                                }
                            });
                        }

                        // If the details commit button is visible it means at least one field
                        // in the details section was edited.
                        // These fields have the same behaviour as the blue band fields, too,
                        // so we perform the same actions for them as well
                        if (!$("#devpage-commit-details").hasClass("hide") && (field !== "details")) {
                            ia_data.staged.details = {};
                            var section_done = false;
                            var $details = $("#ia-single--details .js-autocommit");

                            $details.each(function(idx) {
                                if ((!section_done) || (!$(this).hasClass("section-group__item"))) {
                                    if ($(this).hasClass("section-group__item")) {
                                        section_done = true;
                                    }
                                    
                                    var temp_result = getUnsavedValue($(this));
                                    var temp_field = temp_result.field;
                                    var temp_parent = temp_result.parent_field;

                                    if ((temp_field !== field) && (temp_field !== secondary_field)) {
                                        var temp_value = temp_result.value;

                                        if (temp_result.is_json && temp_value) {
                                            temp_value = $.parseJSON(temp_value);
                                        }

                                        ia_data.staged.details[temp_field] = temp_parent? temp_value[temp_field] : temp_value;
                                    }

                                }
                            });

                        }

                        if (ia_data.live.test_machine && ia_data.live.example_query && ia_data.permissions.can_edit) {
                            ia_data.can_show = 1;
                        } else {
                             ia_data.can_show = 0;
                        }

                        page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                        page.updateAll(readonly_templates, ia_data, false);

                        Screens.render();

                        $commit_open.find(".devpage-edit").trigger("click");

                        $.each(error_save, function(idx, val) {
                            $("." + val.field).addClass("not_saved");
                            var $error_msg = $("." + val.field).siblings(".error-notification");
                            $error_msg.removeClass("hide").text(val.msg);
                        });
                    }

                    //Install pr on beta
                    function beta_install(pr) {
                        var prs = [pr];
                        var jqxhr = $.post("/ia/send_to_beta", {
                            data : JSON.stringify(prs)
                        })
                        .done(function (data) {
                            if (!ia_data.staged) {
                                ia_data.staged = {};
                            }
                                
                            ia_data.staged.beta = 1;
                        });
                    }
                    function create_task(id) {
                        var jqxhr = $.post("/ia/asana", {
                            id : id
                        })
                        .done(function(data) {
                        });
                    }

                    // Saves values for editable fields on the dev page
                    function autocommit(field, value, id, is_json, subfield) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 1
                        })
                        .done(function(data) {
                            subfield = subfield? subfield : "";
                            if (data.result) {
                                if (data.result.saved) {
                                    if (field === "dev_milestone" && data.result[field] === "live") {
                                        location.reload();
                                    } else if (field === "id" || data.result.id) {
                                        location.href = "/ia/view/" + data.result.id;
                                    } else {
                                        ia_data.live[field] = (is_json && data.result[field])? $.parseJSON(data.result[field]) : data.result[field];
                                        if ((field === "developer" && ia_data.permissions && ia_data.permissions.admin)
                                            || ($("#ia-single--details ." + field).length || (subfield && $("#ia-single--details ." + subfield).length))
                                            || ((field === "example_query" || field === "other_queries") && (!ia_data.examples_saved))) {
                                             if (field === "example_query" || field === "other_queries") {
                                                 ia_data.examples_saved = 1;
                                             }
                                             
                                             page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                                        } else {
                                            
                                            keepUnsavedEdits(field);
                                        }
                                    }
                                } else {
                                    $("." + field).addClass("not_saved");
                                    var $error_msg = $("." + field).siblings(".error-notification");
                                    $error_msg.removeClass("hide");
                                    $error_msg.text(data.result.msg);
                                }

                                if (field === "developer" && ia_data.permissions && ia_data.permissions.admin) {
                                    commitEdit($("#producer-input"));
                                }
                            }
                        });
                    }

                    function save(field, value, id, $obj, is_json) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 0
                        })
                        .done(function(data) {
                            
                            if (data.result && data.result.staged) {
                                
                                if (data.result.is_admin) {
                                    if ($("#view_commits").hasClass("hide")) {
                                        $("#view_commits").removeClass("hide");
                                    }
                                }

                                if (is_json) {
                                    ia_data.edited[field] = $.parseJSON(data.result[field]);
                                } else {
                                    ia_data.edited[field] = data.result[field];
                                }

                                pre_templates[field] = Handlebars.templates['pre_edit_' + field](ia_data);

                                $obj.replaceWith(pre_templates[field]);
                            } else {
                                if ($("#error").hasClass("hide")) {
                                    $("#error").removeClass("hide");
                                }
                            }
                        });
                    }
                });
            }
        },

        imgHide: false,

        field_order: [
            'description',
            'examples',
            'screens',
            'github',
            'triggers',
            'advanced',
            'test',
            'traffic'
        ],

        edit_field_order: [
            'name',
            'status',
            'description',
            'repo',
            'topic',
            'example_query',
            'other_queries',
            'perl_module',
            'template',
            'src_api_documentation',
            'api_status_page',
            'src_id',
            'src_name',
            'src_domain',
            'is_stackexchange',
            'src_options',
            'unsafe',
            'answerbar',
            'triggers',
            'perl_dependencies'
        ],

        updateHandlebars: function(templates, ia_data, dev_milestone, staged) {
            var latest_edits_data = {};
            latest_edits_data = this.updateData(ia_data, latest_edits_data, staged);

            $.each(templates.live, function(key, val) {
                templates.live[key] = Handlebars.templates[key](latest_edits_data);
            });

            templates.screens = Handlebars.templates.screens(ia_data);
        },

        updateData: function(ia_data, x, edited) {
            var edited_fields = 0;
            $.each(ia_data.live, function(key, value) {
                if (edited && ia_data.edited && ia_data.edited[key] && (key !== "id") && (key !== "dev_milestone")) {
                    x[key] = ia_data.edited[key];
                    edited_fields++;
                } else {
                    x[key] = value;
                }
            });

            $.each(ia_data, function(key, value) {
                if (key !== "live" && key !== "edited") {
                    x[key] = value;
                }
            });

            if (edited && edited_fields === 0 &&
                (ia_data.live.dev_milestone === "live" || ia_data.live.dev_milestone === "deprecated")) {
                $(".special-permissions__toggle-view").hide();
            }

            

            return x;
        },

        appendTopics: function($obj) {
            if ($obj.length) {
                $obj.append($("#allowed_topics").html());

                this.hideDupes($obj);
            }
        },

        appendBlockgroup: function($obj) {
            if ($obj.length) {
                $obj.append($("#allowed_blockgroups").html());

                this.hideDupes($obj);
            }
        },

        // Hide duplicated dropdown values
        hideDupes: function($obj) {
                $obj.each(function(idx) {
                    $first_opt = $(this).find('option[value="0"]');
                    var opt_0 = $.trim($first_opt.text()) || '';
                    $(this).find("option").each(function(id) {
                        if ($(this) !== $first_opt && $.trim($(this).text()) === opt_0) {
                            $(this).hide();
                        }
                    });

                    if (!opt_0)  {
                        $first_opt.hide();
                    } else {
                        $first_opt.show();
                    }
                });
        },

        hideAssignToMe: function() {
            // If one or more team fields has the current user's name as value,
            // hide the 'assign to me' button accordingly
            var current_user = $.trim($(".header-account-info .user-name").text());
            $(".team-input").each(function(idx) {
                if ($(this).val() === current_user) {
                    $("#" + $.trim($(this).attr("id").replace("-input", "")) + "-button").hide();
                    $(this).css({width: "100%"});
                }
            });
        },

        updateAll: function(templates, ia_data, edit) {
            var dev_milestone = ia_data.live.dev_milestone;

            if (!edit) {
                $(".ia-single--name").remove();

                $("#ia-single-top-name").html(templates.live.name);
                $('#ia-breadcrumbs').html(templates.live.breadcrumbs);
                $("#ia-single-top-details").html(templates.live.top_details);
                $('.edit-container').html(templates.live.edit_buttons);
                $(".ia-single--left, .ia-single--right").show().empty();

                for (var i = 0; i < this.field_order.length; i++) {
                    $(".ia-single--left").append(templates.live[this.field_order[i]]);

                    if (this.field_order[i] === "examples") {
                        $(".ia-single--left").append(templates.screens);
                    }
                }

                if (ia_data.live.hasOwnProperty("traffic") && ia_data.live.traffic) {
                    var traffic = $("#ia_traffic").get(0).getContext("2d");
                    var chart_data = {
                        labels: ia_data.live.traffic.dates,
                        datasets: [
                            {
                                label: "Last 30 days traffic",
                                fillColor: "#60a5da",
                                strokeColor: "#4495d4",
                                pointColor: "#4495d4",
                                pointStrokeColor: "#fff",
                                pointHighlightFill: "#fff",
                                pointHighlightStroke: "#4495d4",
                                data: ia_data.live.traffic.counts
                            }
                        ]
                    };
                    var chart = new Chart(traffic).Line(chart_data);
                }

                $(".ia-single--right").append(templates.live.devinfo);

                $(".show-more").click(function(e) {
                    e.preventDefault();

                    if($(".ia-single--info li").hasClass("hide")) {
                        $(".ia-single--info li").removeClass("hide");
                        $("#show-more--link").text("Show Less");
                        $(".ia-single--info").find(".ddgsi").removeClass("ddgsi-chev-down").addClass("ddgsi-chev-up");
                    } else {
                        $(".ia-single--info li.extra-item").addClass("hide");
                        $("#show-more--link").text("Show More");
                        $(".ia-single--info").find(".ddgsi").removeClass("ddgsi-chev-up").addClass("ddgsi-chev-down");
                    }
                });

                if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                    this.appendTopics($(".topic-group.js-autocommit"));
                }
            } else {
                $("#ia-single-top").attr("id", "ia-single-top--edit");
                $("#ia-single-top-name, #ia-single-top-details, .ia-single--left, .ia-single--right, .edit-container, #ia-breadcrumbs").hide();
                $(".special-permissions .btn--wire--hero").removeClass("btn--wire--hero").addClass("button");
                $(".ia-single--edits").removeClass("hide");
                for (var i = 0; i < this.edit_field_order.length; i++) {
                    $(".ia-single--edits").append(templates[this.edit_field_order[i]]);
                }

                // Only admins can edit these fields
                if ($("#view_commits").length) {
                    $(".ia-single--edits").append(templates.dev_milestone);
                    $(".ia-single--edits").append(templates.producer);
                    $(".ia-single--edits").append(templates.designer);
                    $(".ia-single--edits").append(templates.developer);
                    $(".ia-single--edits").append(templates.tab);
                    $(".ia-single--edits").append(templates.id);
                    $(".ia-single--edits").append(templates.blockgroup);
                    $(".ia-single--edits").append(templates.deployment_state);
                }
            }

            // Make sure to update the widths of the topics.
            $("select.top-details.js-autocommit").each(function() {
                if($(this).hasClass("topic")) {
                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                } else {
                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                }
            });
        }
    };

})(DDH);

(function(env) {


    // placeholder

    DDH.IAPageCommit = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPageCommit.prototype = {
        init: function(ops) {
            // 

            if (DDH_iaid) {
                //

                $.getJSON("/ia/commit/" + DDH_iaid + "/json", function(x) {
                    if (x.redirect) {
                        window.location = "/ia/view/" + DDH_iaid;
                    } else {
                        var iapc = Handlebars.templates.commit_page(x);
                        $("#ia_commit").html(iapc);
                    }

                    $("body").on('click', '.updates_list td', function(evt) {
                        $(this).parent().find('td').removeClass("item_selected");
                        $(this).removeClass("item_focused");
                        $(this).addClass("item_selected");

                        // Enable commit button only if a version (either live or edited)
                        // has been selected for each field 
                        if ($("#commit").hasClass("disabled")) {
                            if ($("tr.updates_list").length === $("td.item_selected").length) {
                                $("#commit").removeClass("disabled");
                            }
                        }
                    });

                    $("body").on('click', '#commit', function(evt) {
                        if (!$(this).hasClass('disabled')) {
                            var values = [];
                            var is_json = false;
                            $('.updates_list .item_selected').each(function(idx) {
                                var temp_field = $(this).attr('name');
                                var temp_value;

                                if (temp_field === "topic" || temp_field === "other_queries" || temp_field === "developer"
                                    || temp_field === "triggers" || temp_field === "perl_dependencies") {
                                    temp_value = [];
                                    is_json = true;
                                    $('.updates_list .item_selected li').each(function(id) {
                                        if ($(this).parent().attr('name') === temp_field) {
                                            if (temp_field === "developer") {
                                                var temp_dev = {};
                                                temp_dev.name = $.trim($(this).text());
                                                temp_dev.type = $.trim($(this).attr("data-type"));
                                                temp_dev.url = $.trim($(this).find("a").attr("href"));

                                                temp_value.push(temp_dev);
                                            } else {
                                                temp_value.push($.trim($(this).text()));
                                            }
                                        }
                                    });
                                } else if (temp_field === "src_options") {
                                    temp_value = {};
                                    is_json = true;
                                    $('.item_selected .src_options-group li .section-group__item').each(function(id) {
                                        var subfield = $(this).attr("data-field");

                                        if ($(this).hasClass("icon-check")) {
                                            temp_value[subfield] = 1;
                                        } else if ($(this).hasClass("icon-check-empty")) {
                                            temp_value[subfield] = 0;
                                        } else {
                                            temp_value[subfield] = $.trim($(this).text().replace(/\"/g, ""));
                                        } 
                                    });
                                } else if (temp_field === "answerbar") {
                                    is_json = true;
                                    temp_value = {};
                                    temp_value.fallback_timeout = $.trim($(this).text().replace(/\"/g, ""));
                                } else {
                                    temp_value = $.trim($(this).text().replace(/\"/g, ""));

                                    if (temp_field === "src_id") {
                                        temp_value = parseInt(temp_value);
                                    } else if ((temp_field === "blockgroup" || temp_field === "deployment_state") && temp_value === "") {
                                        temp_value = null;
                                    }
                                }
                                
                                if (is_json && (temp_field !== "topic")) {
                                    temp_value = JSON.stringify(temp_value);
                                    is_json = false;
                                }

                                values.push({'field':temp_field, 'value':temp_value});
                            });

                            DDH.IAPageCommit.prototype.save(values);
                        }
                    });

                    $("body").on('mouseenter mouseleave', '.updates_list td', function(evt) {
                        if (!$(this).hasClass("item_selected")) {
                            $(this).toggleClass("item_focused");
                        }
                    });
                });
            }
        },

        save: function(values) { 
            var jqxhr = $.post("/ia/commit/" + DDH_iaid + "/save", {
                values: JSON.stringify(values),
                id: DDH_iaid,
            })
            .done(function(data) {
                if (data.result && data.result.saved) {
                    window.location = '/ia/view/' + data.result.id;
                }
            });
        }
    };

})(DDH);
 

//

$(document).ready(function() {

    if (DDH_iapage) {

        //

        if (DDH[DDH_iapage]) {
            DDH.page = new DDH[DDH_iapage]();
        }
        // else .. error
    }

});






//! moment.js
//! version : 2.10.6
//! authors : Tim Wood, Iskren Chernev, Moment.js contributors
//! license : MIT
//! momentjs.com
!function(a,b){"object"==typeof exports&&"undefined"!=typeof module?module.exports=b():"function"==typeof define&&define.amd?define(b):a.moment=b()}(this,function(){"use strict";function a(){return Hc.apply(null,arguments)}function b(a){Hc=a}function c(a){return"[object Array]"===Object.prototype.toString.call(a)}function d(a){return a instanceof Date||"[object Date]"===Object.prototype.toString.call(a)}function e(a,b){var c,d=[];for(c=0;c<a.length;++c)d.push(b(a[c],c));return d}function f(a,b){return Object.prototype.hasOwnProperty.call(a,b)}function g(a,b){for(var c in b)f(b,c)&&(a[c]=b[c]);return f(b,"toString")&&(a.toString=b.toString),f(b,"valueOf")&&(a.valueOf=b.valueOf),a}function h(a,b,c,d){return Ca(a,b,c,d,!0).utc()}function i(){return{empty:!1,unusedTokens:[],unusedInput:[],overflow:-2,charsLeftOver:0,nullInput:!1,invalidMonth:null,invalidFormat:!1,userInvalidated:!1,iso:!1}}function j(a){return null==a._pf&&(a._pf=i()),a._pf}function k(a){if(null==a._isValid){var b=j(a);a._isValid=!(isNaN(a._d.getTime())||!(b.overflow<0)||b.empty||b.invalidMonth||b.invalidWeekday||b.nullInput||b.invalidFormat||b.userInvalidated),a._strict&&(a._isValid=a._isValid&&0===b.charsLeftOver&&0===b.unusedTokens.length&&void 0===b.bigHour)}return a._isValid}function l(a){var b=h(NaN);return null!=a?g(j(b),a):j(b).userInvalidated=!0,b}function m(a,b){var c,d,e;if("undefined"!=typeof b._isAMomentObject&&(a._isAMomentObject=b._isAMomentObject),"undefined"!=typeof b._i&&(a._i=b._i),"undefined"!=typeof b._f&&(a._f=b._f),"undefined"!=typeof b._l&&(a._l=b._l),"undefined"!=typeof b._strict&&(a._strict=b._strict),"undefined"!=typeof b._tzm&&(a._tzm=b._tzm),"undefined"!=typeof b._isUTC&&(a._isUTC=b._isUTC),"undefined"!=typeof b._offset&&(a._offset=b._offset),"undefined"!=typeof b._pf&&(a._pf=j(b)),"undefined"!=typeof b._locale&&(a._locale=b._locale),Jc.length>0)for(c in Jc)d=Jc[c],e=b[d],"undefined"!=typeof e&&(a[d]=e);return a}function n(b){m(this,b),this._d=new Date(null!=b._d?b._d.getTime():NaN),Kc===!1&&(Kc=!0,a.updateOffset(this),Kc=!1)}function o(a){return a instanceof n||null!=a&&null!=a._isAMomentObject}function p(a){return 0>a?Math.ceil(a):Math.floor(a)}function q(a){var b=+a,c=0;return 0!==b&&isFinite(b)&&(c=p(b)),c}function r(a,b,c){var d,e=Math.min(a.length,b.length),f=Math.abs(a.length-b.length),g=0;for(d=0;e>d;d++)(c&&a[d]!==b[d]||!c&&q(a[d])!==q(b[d]))&&g++;return g+f}function s(){}function t(a){return a?a.toLowerCase().replace("_","-"):a}function u(a){for(var b,c,d,e,f=0;f<a.length;){for(e=t(a[f]).split("-"),b=e.length,c=t(a[f+1]),c=c?c.split("-"):null;b>0;){if(d=v(e.slice(0,b).join("-")))return d;if(c&&c.length>=b&&r(e,c,!0)>=b-1)break;b--}f++}return null}function v(a){var b=null;if(!Lc[a]&&"undefined"!=typeof module&&module&&module.exports)try{b=Ic._abbr,require("./locale/"+a),w(b)}catch(c){}return Lc[a]}function w(a,b){var c;return a&&(c="undefined"==typeof b?y(a):x(a,b),c&&(Ic=c)),Ic._abbr}function x(a,b){return null!==b?(b.abbr=a,Lc[a]=Lc[a]||new s,Lc[a].set(b),w(a),Lc[a]):(delete Lc[a],null)}function y(a){var b;if(a&&a._locale&&a._locale._abbr&&(a=a._locale._abbr),!a)return Ic;if(!c(a)){if(b=v(a))return b;a=[a]}return u(a)}function z(a,b){var c=a.toLowerCase();Mc[c]=Mc[c+"s"]=Mc[b]=a}function A(a){return"string"==typeof a?Mc[a]||Mc[a.toLowerCase()]:void 0}function B(a){var b,c,d={};for(c in a)f(a,c)&&(b=A(c),b&&(d[b]=a[c]));return d}function C(b,c){return function(d){return null!=d?(E(this,b,d),a.updateOffset(this,c),this):D(this,b)}}function D(a,b){return a._d["get"+(a._isUTC?"UTC":"")+b]()}function E(a,b,c){return a._d["set"+(a._isUTC?"UTC":"")+b](c)}function F(a,b){var c;if("object"==typeof a)for(c in a)this.set(c,a[c]);else if(a=A(a),"function"==typeof this[a])return this[a](b);return this}function G(a,b,c){var d=""+Math.abs(a),e=b-d.length,f=a>=0;return(f?c?"+":"":"-")+Math.pow(10,Math.max(0,e)).toString().substr(1)+d}function H(a,b,c,d){var e=d;"string"==typeof d&&(e=function(){return this[d]()}),a&&(Qc[a]=e),b&&(Qc[b[0]]=function(){return G(e.apply(this,arguments),b[1],b[2])}),c&&(Qc[c]=function(){return this.localeData().ordinal(e.apply(this,arguments),a)})}function I(a){return a.match(/\[[\s\S]/)?a.replace(/^\[|\]$/g,""):a.replace(/\\/g,"")}function J(a){var b,c,d=a.match(Nc);for(b=0,c=d.length;c>b;b++)Qc[d[b]]?d[b]=Qc[d[b]]:d[b]=I(d[b]);return function(e){var f="";for(b=0;c>b;b++)f+=d[b]instanceof Function?d[b].call(e,a):d[b];return f}}function K(a,b){return a.isValid()?(b=L(b,a.localeData()),Pc[b]=Pc[b]||J(b),Pc[b](a)):a.localeData().invalidDate()}function L(a,b){function c(a){return b.longDateFormat(a)||a}var d=5;for(Oc.lastIndex=0;d>=0&&Oc.test(a);)a=a.replace(Oc,c),Oc.lastIndex=0,d-=1;return a}function M(a){return"function"==typeof a&&"[object Function]"===Object.prototype.toString.call(a)}function N(a,b,c){dd[a]=M(b)?b:function(a){return a&&c?c:b}}function O(a,b){return f(dd,a)?dd[a](b._strict,b._locale):new RegExp(P(a))}function P(a){return a.replace("\\","").replace(/\\(\[)|\\(\])|\[([^\]\[]*)\]|\\(.)/g,function(a,b,c,d,e){return b||c||d||e}).replace(/[-\/\\^$*+?.()|[\]{}]/g,"\\$&")}function Q(a,b){var c,d=b;for("string"==typeof a&&(a=[a]),"number"==typeof b&&(d=function(a,c){c[b]=q(a)}),c=0;c<a.length;c++)ed[a[c]]=d}function R(a,b){Q(a,function(a,c,d,e){d._w=d._w||{},b(a,d._w,d,e)})}function S(a,b,c){null!=b&&f(ed,a)&&ed[a](b,c._a,c,a)}function T(a,b){return new Date(Date.UTC(a,b+1,0)).getUTCDate()}function U(a){return this._months[a.month()]}function V(a){return this._monthsShort[a.month()]}function W(a,b,c){var d,e,f;for(this._monthsParse||(this._monthsParse=[],this._longMonthsParse=[],this._shortMonthsParse=[]),d=0;12>d;d++){if(e=h([2e3,d]),c&&!this._longMonthsParse[d]&&(this._longMonthsParse[d]=new RegExp("^"+this.months(e,"").replace(".","")+"$","i"),this._shortMonthsParse[d]=new RegExp("^"+this.monthsShort(e,"").replace(".","")+"$","i")),c||this._monthsParse[d]||(f="^"+this.months(e,"")+"|^"+this.monthsShort(e,""),this._monthsParse[d]=new RegExp(f.replace(".",""),"i")),c&&"MMMM"===b&&this._longMonthsParse[d].test(a))return d;if(c&&"MMM"===b&&this._shortMonthsParse[d].test(a))return d;if(!c&&this._monthsParse[d].test(a))return d}}function X(a,b){var c;return"string"==typeof b&&(b=a.localeData().monthsParse(b),"number"!=typeof b)?a:(c=Math.min(a.date(),T(a.year(),b)),a._d["set"+(a._isUTC?"UTC":"")+"Month"](b,c),a)}function Y(b){return null!=b?(X(this,b),a.updateOffset(this,!0),this):D(this,"Month")}function Z(){return T(this.year(),this.month())}function $(a){var b,c=a._a;return c&&-2===j(a).overflow&&(b=c[gd]<0||c[gd]>11?gd:c[hd]<1||c[hd]>T(c[fd],c[gd])?hd:c[id]<0||c[id]>24||24===c[id]&&(0!==c[jd]||0!==c[kd]||0!==c[ld])?id:c[jd]<0||c[jd]>59?jd:c[kd]<0||c[kd]>59?kd:c[ld]<0||c[ld]>999?ld:-1,j(a)._overflowDayOfYear&&(fd>b||b>hd)&&(b=hd),j(a).overflow=b),a}function _(b){a.suppressDeprecationWarnings===!1&&"undefined"!=typeof console&&console.warn&&console.warn("Deprecation warning: "+b)}function aa(a,b){var c=!0;return g(function(){return c&&(_(a+"\n"+(new Error).stack),c=!1),b.apply(this,arguments)},b)}function ba(a,b){od[a]||(_(b),od[a]=!0)}function ca(a){var b,c,d=a._i,e=pd.exec(d);if(e){for(j(a).iso=!0,b=0,c=qd.length;c>b;b++)if(qd[b][1].exec(d)){a._f=qd[b][0];break}for(b=0,c=rd.length;c>b;b++)if(rd[b][1].exec(d)){a._f+=(e[6]||" ")+rd[b][0];break}d.match(ad)&&(a._f+="Z"),va(a)}else a._isValid=!1}function da(b){var c=sd.exec(b._i);return null!==c?void(b._d=new Date(+c[1])):(ca(b),void(b._isValid===!1&&(delete b._isValid,a.createFromInputFallback(b))))}function ea(a,b,c,d,e,f,g){var h=new Date(a,b,c,d,e,f,g);return 1970>a&&h.setFullYear(a),h}function fa(a){var b=new Date(Date.UTC.apply(null,arguments));return 1970>a&&b.setUTCFullYear(a),b}function ga(a){return ha(a)?366:365}function ha(a){return a%4===0&&a%100!==0||a%400===0}function ia(){return ha(this.year())}function ja(a,b,c){var d,e=c-b,f=c-a.day();return f>e&&(f-=7),e-7>f&&(f+=7),d=Da(a).add(f,"d"),{week:Math.ceil(d.dayOfYear()/7),year:d.year()}}function ka(a){return ja(a,this._week.dow,this._week.doy).week}function la(){return this._week.dow}function ma(){return this._week.doy}function na(a){var b=this.localeData().week(this);return null==a?b:this.add(7*(a-b),"d")}function oa(a){var b=ja(this,1,4).week;return null==a?b:this.add(7*(a-b),"d")}function pa(a,b,c,d,e){var f,g=6+e-d,h=fa(a,0,1+g),i=h.getUTCDay();return e>i&&(i+=7),c=null!=c?1*c:e,f=1+g+7*(b-1)-i+c,{year:f>0?a:a-1,dayOfYear:f>0?f:ga(a-1)+f}}function qa(a){var b=Math.round((this.clone().startOf("day")-this.clone().startOf("year"))/864e5)+1;return null==a?b:this.add(a-b,"d")}function ra(a,b,c){return null!=a?a:null!=b?b:c}function sa(a){var b=new Date;return a._useUTC?[b.getUTCFullYear(),b.getUTCMonth(),b.getUTCDate()]:[b.getFullYear(),b.getMonth(),b.getDate()]}function ta(a){var b,c,d,e,f=[];if(!a._d){for(d=sa(a),a._w&&null==a._a[hd]&&null==a._a[gd]&&ua(a),a._dayOfYear&&(e=ra(a._a[fd],d[fd]),a._dayOfYear>ga(e)&&(j(a)._overflowDayOfYear=!0),c=fa(e,0,a._dayOfYear),a._a[gd]=c.getUTCMonth(),a._a[hd]=c.getUTCDate()),b=0;3>b&&null==a._a[b];++b)a._a[b]=f[b]=d[b];for(;7>b;b++)a._a[b]=f[b]=null==a._a[b]?2===b?1:0:a._a[b];24===a._a[id]&&0===a._a[jd]&&0===a._a[kd]&&0===a._a[ld]&&(a._nextDay=!0,a._a[id]=0),a._d=(a._useUTC?fa:ea).apply(null,f),null!=a._tzm&&a._d.setUTCMinutes(a._d.getUTCMinutes()-a._tzm),a._nextDay&&(a._a[id]=24)}}function ua(a){var b,c,d,e,f,g,h;b=a._w,null!=b.GG||null!=b.W||null!=b.E?(f=1,g=4,c=ra(b.GG,a._a[fd],ja(Da(),1,4).year),d=ra(b.W,1),e=ra(b.E,1)):(f=a._locale._week.dow,g=a._locale._week.doy,c=ra(b.gg,a._a[fd],ja(Da(),f,g).year),d=ra(b.w,1),null!=b.d?(e=b.d,f>e&&++d):e=null!=b.e?b.e+f:f),h=pa(c,d,e,g,f),a._a[fd]=h.year,a._dayOfYear=h.dayOfYear}function va(b){if(b._f===a.ISO_8601)return void ca(b);b._a=[],j(b).empty=!0;var c,d,e,f,g,h=""+b._i,i=h.length,k=0;for(e=L(b._f,b._locale).match(Nc)||[],c=0;c<e.length;c++)f=e[c],d=(h.match(O(f,b))||[])[0],d&&(g=h.substr(0,h.indexOf(d)),g.length>0&&j(b).unusedInput.push(g),h=h.slice(h.indexOf(d)+d.length),k+=d.length),Qc[f]?(d?j(b).empty=!1:j(b).unusedTokens.push(f),S(f,d,b)):b._strict&&!d&&j(b).unusedTokens.push(f);j(b).charsLeftOver=i-k,h.length>0&&j(b).unusedInput.push(h),j(b).bigHour===!0&&b._a[id]<=12&&b._a[id]>0&&(j(b).bigHour=void 0),b._a[id]=wa(b._locale,b._a[id],b._meridiem),ta(b),$(b)}function wa(a,b,c){var d;return null==c?b:null!=a.meridiemHour?a.meridiemHour(b,c):null!=a.isPM?(d=a.isPM(c),d&&12>b&&(b+=12),d||12!==b||(b=0),b):b}function xa(a){var b,c,d,e,f;if(0===a._f.length)return j(a).invalidFormat=!0,void(a._d=new Date(NaN));for(e=0;e<a._f.length;e++)f=0,b=m({},a),null!=a._useUTC&&(b._useUTC=a._useUTC),b._f=a._f[e],va(b),k(b)&&(f+=j(b).charsLeftOver,f+=10*j(b).unusedTokens.length,j(b).score=f,(null==d||d>f)&&(d=f,c=b));g(a,c||b)}function ya(a){if(!a._d){var b=B(a._i);a._a=[b.year,b.month,b.day||b.date,b.hour,b.minute,b.second,b.millisecond],ta(a)}}function za(a){var b=new n($(Aa(a)));return b._nextDay&&(b.add(1,"d"),b._nextDay=void 0),b}function Aa(a){var b=a._i,e=a._f;return a._locale=a._locale||y(a._l),null===b||void 0===e&&""===b?l({nullInput:!0}):("string"==typeof b&&(a._i=b=a._locale.preparse(b)),o(b)?new n($(b)):(c(e)?xa(a):e?va(a):d(b)?a._d=b:Ba(a),a))}function Ba(b){var f=b._i;void 0===f?b._d=new Date:d(f)?b._d=new Date(+f):"string"==typeof f?da(b):c(f)?(b._a=e(f.slice(0),function(a){return parseInt(a,10)}),ta(b)):"object"==typeof f?ya(b):"number"==typeof f?b._d=new Date(f):a.createFromInputFallback(b)}function Ca(a,b,c,d,e){var f={};return"boolean"==typeof c&&(d=c,c=void 0),f._isAMomentObject=!0,f._useUTC=f._isUTC=e,f._l=c,f._i=a,f._f=b,f._strict=d,za(f)}function Da(a,b,c,d){return Ca(a,b,c,d,!1)}function Ea(a,b){var d,e;if(1===b.length&&c(b[0])&&(b=b[0]),!b.length)return Da();for(d=b[0],e=1;e<b.length;++e)(!b[e].isValid()||b[e][a](d))&&(d=b[e]);return d}function Fa(){var a=[].slice.call(arguments,0);return Ea("isBefore",a)}function Ga(){var a=[].slice.call(arguments,0);return Ea("isAfter",a)}function Ha(a){var b=B(a),c=b.year||0,d=b.quarter||0,e=b.month||0,f=b.week||0,g=b.day||0,h=b.hour||0,i=b.minute||0,j=b.second||0,k=b.millisecond||0;this._milliseconds=+k+1e3*j+6e4*i+36e5*h,this._days=+g+7*f,this._months=+e+3*d+12*c,this._data={},this._locale=y(),this._bubble()}function Ia(a){return a instanceof Ha}function Ja(a,b){H(a,0,0,function(){var a=this.utcOffset(),c="+";return 0>a&&(a=-a,c="-"),c+G(~~(a/60),2)+b+G(~~a%60,2)})}function Ka(a){var b=(a||"").match(ad)||[],c=b[b.length-1]||[],d=(c+"").match(xd)||["-",0,0],e=+(60*d[1])+q(d[2]);return"+"===d[0]?e:-e}function La(b,c){var e,f;return c._isUTC?(e=c.clone(),f=(o(b)||d(b)?+b:+Da(b))-+e,e._d.setTime(+e._d+f),a.updateOffset(e,!1),e):Da(b).local()}function Ma(a){return 15*-Math.round(a._d.getTimezoneOffset()/15)}function Na(b,c){var d,e=this._offset||0;return null!=b?("string"==typeof b&&(b=Ka(b)),Math.abs(b)<16&&(b=60*b),!this._isUTC&&c&&(d=Ma(this)),this._offset=b,this._isUTC=!0,null!=d&&this.add(d,"m"),e!==b&&(!c||this._changeInProgress?bb(this,Ya(b-e,"m"),1,!1):this._changeInProgress||(this._changeInProgress=!0,a.updateOffset(this,!0),this._changeInProgress=null)),this):this._isUTC?e:Ma(this)}function Oa(a,b){return null!=a?("string"!=typeof a&&(a=-a),this.utcOffset(a,b),this):-this.utcOffset()}function Pa(a){return this.utcOffset(0,a)}function Qa(a){return this._isUTC&&(this.utcOffset(0,a),this._isUTC=!1,a&&this.subtract(Ma(this),"m")),this}function Ra(){return this._tzm?this.utcOffset(this._tzm):"string"==typeof this._i&&this.utcOffset(Ka(this._i)),this}function Sa(a){return a=a?Da(a).utcOffset():0,(this.utcOffset()-a)%60===0}function Ta(){return this.utcOffset()>this.clone().month(0).utcOffset()||this.utcOffset()>this.clone().month(5).utcOffset()}function Ua(){if("undefined"!=typeof this._isDSTShifted)return this._isDSTShifted;var a={};if(m(a,this),a=Aa(a),a._a){var b=a._isUTC?h(a._a):Da(a._a);this._isDSTShifted=this.isValid()&&r(a._a,b.toArray())>0}else this._isDSTShifted=!1;return this._isDSTShifted}function Va(){return!this._isUTC}function Wa(){return this._isUTC}function Xa(){return this._isUTC&&0===this._offset}function Ya(a,b){var c,d,e,g=a,h=null;return Ia(a)?g={ms:a._milliseconds,d:a._days,M:a._months}:"number"==typeof a?(g={},b?g[b]=a:g.milliseconds=a):(h=yd.exec(a))?(c="-"===h[1]?-1:1,g={y:0,d:q(h[hd])*c,h:q(h[id])*c,m:q(h[jd])*c,s:q(h[kd])*c,ms:q(h[ld])*c}):(h=zd.exec(a))?(c="-"===h[1]?-1:1,g={y:Za(h[2],c),M:Za(h[3],c),d:Za(h[4],c),h:Za(h[5],c),m:Za(h[6],c),s:Za(h[7],c),w:Za(h[8],c)}):null==g?g={}:"object"==typeof g&&("from"in g||"to"in g)&&(e=_a(Da(g.from),Da(g.to)),g={},g.ms=e.milliseconds,g.M=e.months),d=new Ha(g),Ia(a)&&f(a,"_locale")&&(d._locale=a._locale),d}function Za(a,b){var c=a&&parseFloat(a.replace(",","."));return(isNaN(c)?0:c)*b}function $a(a,b){var c={milliseconds:0,months:0};return c.months=b.month()-a.month()+12*(b.year()-a.year()),a.clone().add(c.months,"M").isAfter(b)&&--c.months,c.milliseconds=+b-+a.clone().add(c.months,"M"),c}function _a(a,b){var c;return b=La(b,a),a.isBefore(b)?c=$a(a,b):(c=$a(b,a),c.milliseconds=-c.milliseconds,c.months=-c.months),c}function ab(a,b){return function(c,d){var e,f;return null===d||isNaN(+d)||(ba(b,"moment()."+b+"(period, number) is deprecated. Please use moment()."+b+"(number, period)."),f=c,c=d,d=f),c="string"==typeof c?+c:c,e=Ya(c,d),bb(this,e,a),this}}function bb(b,c,d,e){var f=c._milliseconds,g=c._days,h=c._months;e=null==e?!0:e,f&&b._d.setTime(+b._d+f*d),g&&E(b,"Date",D(b,"Date")+g*d),h&&X(b,D(b,"Month")+h*d),e&&a.updateOffset(b,g||h)}function cb(a,b){var c=a||Da(),d=La(c,this).startOf("day"),e=this.diff(d,"days",!0),f=-6>e?"sameElse":-1>e?"lastWeek":0>e?"lastDay":1>e?"sameDay":2>e?"nextDay":7>e?"nextWeek":"sameElse";return this.format(b&&b[f]||this.localeData().calendar(f,this,Da(c)))}function db(){return new n(this)}function eb(a,b){var c;return b=A("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=o(a)?a:Da(a),+this>+a):(c=o(a)?+a:+Da(a),c<+this.clone().startOf(b))}function fb(a,b){var c;return b=A("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=o(a)?a:Da(a),+a>+this):(c=o(a)?+a:+Da(a),+this.clone().endOf(b)<c)}function gb(a,b,c){return this.isAfter(a,c)&&this.isBefore(b,c)}function hb(a,b){var c;return b=A(b||"millisecond"),"millisecond"===b?(a=o(a)?a:Da(a),+this===+a):(c=+Da(a),+this.clone().startOf(b)<=c&&c<=+this.clone().endOf(b))}function ib(a,b,c){var d,e,f=La(a,this),g=6e4*(f.utcOffset()-this.utcOffset());return b=A(b),"year"===b||"month"===b||"quarter"===b?(e=jb(this,f),"quarter"===b?e/=3:"year"===b&&(e/=12)):(d=this-f,e="second"===b?d/1e3:"minute"===b?d/6e4:"hour"===b?d/36e5:"day"===b?(d-g)/864e5:"week"===b?(d-g)/6048e5:d),c?e:p(e)}function jb(a,b){var c,d,e=12*(b.year()-a.year())+(b.month()-a.month()),f=a.clone().add(e,"months");return 0>b-f?(c=a.clone().add(e-1,"months"),d=(b-f)/(f-c)):(c=a.clone().add(e+1,"months"),d=(b-f)/(c-f)),-(e+d)}function kb(){return this.clone().locale("en").format("ddd MMM DD YYYY HH:mm:ss [GMT]ZZ")}function lb(){var a=this.clone().utc();return 0<a.year()&&a.year()<=9999?"function"==typeof Date.prototype.toISOString?this.toDate().toISOString():K(a,"YYYY-MM-DD[T]HH:mm:ss.SSS[Z]"):K(a,"YYYYYY-MM-DD[T]HH:mm:ss.SSS[Z]")}function mb(b){var c=K(this,b||a.defaultFormat);return this.localeData().postformat(c)}function nb(a,b){return this.isValid()?Ya({to:this,from:a}).locale(this.locale()).humanize(!b):this.localeData().invalidDate()}function ob(a){return this.from(Da(),a)}function pb(a,b){return this.isValid()?Ya({from:this,to:a}).locale(this.locale()).humanize(!b):this.localeData().invalidDate()}function qb(a){return this.to(Da(),a)}function rb(a){var b;return void 0===a?this._locale._abbr:(b=y(a),null!=b&&(this._locale=b),this)}function sb(){return this._locale}function tb(a){switch(a=A(a)){case"year":this.month(0);case"quarter":case"month":this.date(1);case"week":case"isoWeek":case"day":this.hours(0);case"hour":this.minutes(0);case"minute":this.seconds(0);case"second":this.milliseconds(0)}return"week"===a&&this.weekday(0),"isoWeek"===a&&this.isoWeekday(1),"quarter"===a&&this.month(3*Math.floor(this.month()/3)),this}function ub(a){return a=A(a),void 0===a||"millisecond"===a?this:this.startOf(a).add(1,"isoWeek"===a?"week":a).subtract(1,"ms")}function vb(){return+this._d-6e4*(this._offset||0)}function wb(){return Math.floor(+this/1e3)}function xb(){return this._offset?new Date(+this):this._d}function yb(){var a=this;return[a.year(),a.month(),a.date(),a.hour(),a.minute(),a.second(),a.millisecond()]}function zb(){var a=this;return{years:a.year(),months:a.month(),date:a.date(),hours:a.hours(),minutes:a.minutes(),seconds:a.seconds(),milliseconds:a.milliseconds()}}function Ab(){return k(this)}function Bb(){return g({},j(this))}function Cb(){return j(this).overflow}function Db(a,b){H(0,[a,a.length],0,b)}function Eb(a,b,c){return ja(Da([a,11,31+b-c]),b,c).week}function Fb(a){var b=ja(this,this.localeData()._week.dow,this.localeData()._week.doy).year;return null==a?b:this.add(a-b,"y")}function Gb(a){var b=ja(this,1,4).year;return null==a?b:this.add(a-b,"y")}function Hb(){return Eb(this.year(),1,4)}function Ib(){var a=this.localeData()._week;return Eb(this.year(),a.dow,a.doy)}function Jb(a){return null==a?Math.ceil((this.month()+1)/3):this.month(3*(a-1)+this.month()%3)}function Kb(a,b){return"string"!=typeof a?a:isNaN(a)?(a=b.weekdaysParse(a),"number"==typeof a?a:null):parseInt(a,10)}function Lb(a){return this._weekdays[a.day()]}function Mb(a){return this._weekdaysShort[a.day()]}function Nb(a){return this._weekdaysMin[a.day()]}function Ob(a){var b,c,d;for(this._weekdaysParse=this._weekdaysParse||[],b=0;7>b;b++)if(this._weekdaysParse[b]||(c=Da([2e3,1]).day(b),d="^"+this.weekdays(c,"")+"|^"+this.weekdaysShort(c,"")+"|^"+this.weekdaysMin(c,""),this._weekdaysParse[b]=new RegExp(d.replace(".",""),"i")),this._weekdaysParse[b].test(a))return b}function Pb(a){var b=this._isUTC?this._d.getUTCDay():this._d.getDay();return null!=a?(a=Kb(a,this.localeData()),this.add(a-b,"d")):b}function Qb(a){var b=(this.day()+7-this.localeData()._week.dow)%7;return null==a?b:this.add(a-b,"d")}function Rb(a){return null==a?this.day()||7:this.day(this.day()%7?a:a-7)}function Sb(a,b){H(a,0,0,function(){return this.localeData().meridiem(this.hours(),this.minutes(),b)})}function Tb(a,b){return b._meridiemParse}function Ub(a){return"p"===(a+"").toLowerCase().charAt(0)}function Vb(a,b,c){return a>11?c?"pm":"PM":c?"am":"AM"}function Wb(a,b){b[ld]=q(1e3*("0."+a))}function Xb(){return this._isUTC?"UTC":""}function Yb(){return this._isUTC?"Coordinated Universal Time":""}function Zb(a){return Da(1e3*a)}function $b(){return Da.apply(null,arguments).parseZone()}function _b(a,b,c){var d=this._calendar[a];return"function"==typeof d?d.call(b,c):d}function ac(a){var b=this._longDateFormat[a],c=this._longDateFormat[a.toUpperCase()];return b||!c?b:(this._longDateFormat[a]=c.replace(/MMMM|MM|DD|dddd/g,function(a){return a.slice(1)}),this._longDateFormat[a])}function bc(){return this._invalidDate}function cc(a){return this._ordinal.replace("%d",a)}function dc(a){return a}function ec(a,b,c,d){var e=this._relativeTime[c];return"function"==typeof e?e(a,b,c,d):e.replace(/%d/i,a)}function fc(a,b){var c=this._relativeTime[a>0?"future":"past"];return"function"==typeof c?c(b):c.replace(/%s/i,b)}function gc(a){var b,c;for(c in a)b=a[c],"function"==typeof b?this[c]=b:this["_"+c]=b;this._ordinalParseLenient=new RegExp(this._ordinalParse.source+"|"+/\d{1,2}/.source)}function hc(a,b,c,d){var e=y(),f=h().set(d,b);return e[c](f,a)}function ic(a,b,c,d,e){if("number"==typeof a&&(b=a,a=void 0),a=a||"",null!=b)return hc(a,b,c,e);var f,g=[];for(f=0;d>f;f++)g[f]=hc(a,f,c,e);return g}function jc(a,b){return ic(a,b,"months",12,"month")}function kc(a,b){return ic(a,b,"monthsShort",12,"month")}function lc(a,b){return ic(a,b,"weekdays",7,"day")}function mc(a,b){return ic(a,b,"weekdaysShort",7,"day")}function nc(a,b){return ic(a,b,"weekdaysMin",7,"day")}function oc(){var a=this._data;return this._milliseconds=Wd(this._milliseconds),this._days=Wd(this._days),this._months=Wd(this._months),a.milliseconds=Wd(a.milliseconds),a.seconds=Wd(a.seconds),a.minutes=Wd(a.minutes),a.hours=Wd(a.hours),a.months=Wd(a.months),a.years=Wd(a.years),this}function pc(a,b,c,d){var e=Ya(b,c);return a._milliseconds+=d*e._milliseconds,a._days+=d*e._days,a._months+=d*e._months,a._bubble()}function qc(a,b){return pc(this,a,b,1)}function rc(a,b){return pc(this,a,b,-1)}function sc(a){return 0>a?Math.floor(a):Math.ceil(a)}function tc(){var a,b,c,d,e,f=this._milliseconds,g=this._days,h=this._months,i=this._data;return f>=0&&g>=0&&h>=0||0>=f&&0>=g&&0>=h||(f+=864e5*sc(vc(h)+g),g=0,h=0),i.milliseconds=f%1e3,a=p(f/1e3),i.seconds=a%60,b=p(a/60),i.minutes=b%60,c=p(b/60),i.hours=c%24,g+=p(c/24),e=p(uc(g)),h+=e,g-=sc(vc(e)),d=p(h/12),h%=12,i.days=g,i.months=h,i.years=d,this}function uc(a){return 4800*a/146097}function vc(a){return 146097*a/4800}function wc(a){var b,c,d=this._milliseconds;if(a=A(a),"month"===a||"year"===a)return b=this._days+d/864e5,c=this._months+uc(b),"month"===a?c:c/12;switch(b=this._days+Math.round(vc(this._months)),a){case"week":return b/7+d/6048e5;case"day":return b+d/864e5;case"hour":return 24*b+d/36e5;case"minute":return 1440*b+d/6e4;case"second":return 86400*b+d/1e3;case"millisecond":return Math.floor(864e5*b)+d;default:throw new Error("Unknown unit "+a)}}function xc(){return this._milliseconds+864e5*this._days+this._months%12*2592e6+31536e6*q(this._months/12)}function yc(a){return function(){return this.as(a)}}function zc(a){return a=A(a),this[a+"s"]()}function Ac(a){return function(){return this._data[a]}}function Bc(){return p(this.days()/7)}function Cc(a,b,c,d,e){return e.relativeTime(b||1,!!c,a,d)}function Dc(a,b,c){var d=Ya(a).abs(),e=ke(d.as("s")),f=ke(d.as("m")),g=ke(d.as("h")),h=ke(d.as("d")),i=ke(d.as("M")),j=ke(d.as("y")),k=e<le.s&&["s",e]||1===f&&["m"]||f<le.m&&["mm",f]||1===g&&["h"]||g<le.h&&["hh",g]||1===h&&["d"]||h<le.d&&["dd",h]||1===i&&["M"]||i<le.M&&["MM",i]||1===j&&["y"]||["yy",j];return k[2]=b,k[3]=+a>0,k[4]=c,Cc.apply(null,k)}function Ec(a,b){return void 0===le[a]?!1:void 0===b?le[a]:(le[a]=b,!0)}function Fc(a){var b=this.localeData(),c=Dc(this,!a,b);return a&&(c=b.pastFuture(+this,c)),b.postformat(c)}function Gc(){var a,b,c,d=me(this._milliseconds)/1e3,e=me(this._days),f=me(this._months);a=p(d/60),b=p(a/60),d%=60,a%=60,c=p(f/12),f%=12;var g=c,h=f,i=e,j=b,k=a,l=d,m=this.asSeconds();return m?(0>m?"-":"")+"P"+(g?g+"Y":"")+(h?h+"M":"")+(i?i+"D":"")+(j||k||l?"T":"")+(j?j+"H":"")+(k?k+"M":"")+(l?l+"S":""):"P0D"}var Hc,Ic,Jc=a.momentProperties=[],Kc=!1,Lc={},Mc={},Nc=/(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|W[o|W]?|Q|YYYYYY|YYYYY|YYYY|YY|gg(ggg?)?|GG(GGG?)?|e|E|a|A|hh?|HH?|mm?|ss?|S{1,9}|x|X|zz?|ZZ?|.)/g,Oc=/(\[[^\[]*\])|(\\)?(LTS|LT|LL?L?L?|l{1,4})/g,Pc={},Qc={},Rc=/\d/,Sc=/\d\d/,Tc=/\d{3}/,Uc=/\d{4}/,Vc=/[+-]?\d{6}/,Wc=/\d\d?/,Xc=/\d{1,3}/,Yc=/\d{1,4}/,Zc=/[+-]?\d{1,6}/,$c=/\d+/,_c=/[+-]?\d+/,ad=/Z|[+-]\d\d:?\d\d/gi,bd=/[+-]?\d+(\.\d{1,3})?/,cd=/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i,dd={},ed={},fd=0,gd=1,hd=2,id=3,jd=4,kd=5,ld=6;H("M",["MM",2],"Mo",function(){return this.month()+1}),H("MMM",0,0,function(a){return this.localeData().monthsShort(this,a)}),H("MMMM",0,0,function(a){return this.localeData().months(this,a)}),z("month","M"),N("M",Wc),N("MM",Wc,Sc),N("MMM",cd),N("MMMM",cd),Q(["M","MM"],function(a,b){b[gd]=q(a)-1}),Q(["MMM","MMMM"],function(a,b,c,d){var e=c._locale.monthsParse(a,d,c._strict);null!=e?b[gd]=e:j(c).invalidMonth=a});var md="January_February_March_April_May_June_July_August_September_October_November_December".split("_"),nd="Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),od={};a.suppressDeprecationWarnings=!1;var pd=/^\s*(?:[+-]\d{6}|\d{4})-(?:(\d\d-\d\d)|(W\d\d$)|(W\d\d-\d)|(\d\d\d))((T| )(\d\d(:\d\d(:\d\d(\.\d+)?)?)?)?([\+\-]\d\d(?::?\d\d)?|\s*Z)?)?$/,qd=[["YYYYYY-MM-DD",/[+-]\d{6}-\d{2}-\d{2}/],["YYYY-MM-DD",/\d{4}-\d{2}-\d{2}/],["GGGG-[W]WW-E",/\d{4}-W\d{2}-\d/],["GGGG-[W]WW",/\d{4}-W\d{2}/],["YYYY-DDD",/\d{4}-\d{3}/]],rd=[["HH:mm:ss.SSSS",/(T| )\d\d:\d\d:\d\d\.\d+/],["HH:mm:ss",/(T| )\d\d:\d\d:\d\d/],["HH:mm",/(T| )\d\d:\d\d/],["HH",/(T| )\d\d/]],sd=/^\/?Date\((\-?\d+)/i;a.createFromInputFallback=aa("moment construction falls back to js Date. This is discouraged and will be removed in upcoming major release. Please refer to https://github.com/moment/moment/issues/1407 for more info.",function(a){a._d=new Date(a._i+(a._useUTC?" UTC":""))}),H(0,["YY",2],0,function(){return this.year()%100}),H(0,["YYYY",4],0,"year"),H(0,["YYYYY",5],0,"year"),H(0,["YYYYYY",6,!0],0,"year"),z("year","y"),N("Y",_c),N("YY",Wc,Sc),N("YYYY",Yc,Uc),N("YYYYY",Zc,Vc),N("YYYYYY",Zc,Vc),Q(["YYYYY","YYYYYY"],fd),Q("YYYY",function(b,c){c[fd]=2===b.length?a.parseTwoDigitYear(b):q(b)}),Q("YY",function(b,c){c[fd]=a.parseTwoDigitYear(b)}),a.parseTwoDigitYear=function(a){return q(a)+(q(a)>68?1900:2e3)};var td=C("FullYear",!1);H("w",["ww",2],"wo","week"),H("W",["WW",2],"Wo","isoWeek"),z("week","w"),z("isoWeek","W"),N("w",Wc),N("ww",Wc,Sc),N("W",Wc),N("WW",Wc,Sc),R(["w","ww","W","WW"],function(a,b,c,d){b[d.substr(0,1)]=q(a)});var ud={dow:0,doy:6};H("DDD",["DDDD",3],"DDDo","dayOfYear"),z("dayOfYear","DDD"),N("DDD",Xc),N("DDDD",Tc),Q(["DDD","DDDD"],function(a,b,c){c._dayOfYear=q(a)}),a.ISO_8601=function(){};var vd=aa("moment().min is deprecated, use moment.min instead. https://github.com/moment/moment/issues/1548",function(){var a=Da.apply(null,arguments);return this>a?this:a}),wd=aa("moment().max is deprecated, use moment.max instead. https://github.com/moment/moment/issues/1548",function(){var a=Da.apply(null,arguments);return a>this?this:a});Ja("Z",":"),Ja("ZZ",""),N("Z",ad),N("ZZ",ad),Q(["Z","ZZ"],function(a,b,c){c._useUTC=!0,c._tzm=Ka(a)});var xd=/([\+\-]|\d\d)/gi;a.updateOffset=function(){};var yd=/(\-)?(?:(\d*)\.)?(\d+)\:(\d+)(?:\:(\d+)\.?(\d{3})?)?/,zd=/^(-)?P(?:(?:([0-9,.]*)Y)?(?:([0-9,.]*)M)?(?:([0-9,.]*)D)?(?:T(?:([0-9,.]*)H)?(?:([0-9,.]*)M)?(?:([0-9,.]*)S)?)?|([0-9,.]*)W)$/;Ya.fn=Ha.prototype;var Ad=ab(1,"add"),Bd=ab(-1,"subtract");a.defaultFormat="YYYY-MM-DDTHH:mm:ssZ";var Cd=aa("moment().lang() is deprecated. Instead, use moment().localeData() to get the language configuration. Use moment().locale() to change languages.",function(a){return void 0===a?this.localeData():this.locale(a)});H(0,["gg",2],0,function(){return this.weekYear()%100}),H(0,["GG",2],0,function(){return this.isoWeekYear()%100}),Db("gggg","weekYear"),Db("ggggg","weekYear"),Db("GGGG","isoWeekYear"),Db("GGGGG","isoWeekYear"),z("weekYear","gg"),z("isoWeekYear","GG"),N("G",_c),N("g",_c),N("GG",Wc,Sc),N("gg",Wc,Sc),N("GGGG",Yc,Uc),N("gggg",Yc,Uc),N("GGGGG",Zc,Vc),N("ggggg",Zc,Vc),R(["gggg","ggggg","GGGG","GGGGG"],function(a,b,c,d){b[d.substr(0,2)]=q(a)}),R(["gg","GG"],function(b,c,d,e){c[e]=a.parseTwoDigitYear(b)}),H("Q",0,0,"quarter"),z("quarter","Q"),N("Q",Rc),Q("Q",function(a,b){b[gd]=3*(q(a)-1)}),H("D",["DD",2],"Do","date"),z("date","D"),N("D",Wc),N("DD",Wc,Sc),N("Do",function(a,b){return a?b._ordinalParse:b._ordinalParseLenient}),Q(["D","DD"],hd),Q("Do",function(a,b){b[hd]=q(a.match(Wc)[0],10)});var Dd=C("Date",!0);H("d",0,"do","day"),H("dd",0,0,function(a){return this.localeData().weekdaysMin(this,a)}),H("ddd",0,0,function(a){return this.localeData().weekdaysShort(this,a)}),H("dddd",0,0,function(a){return this.localeData().weekdays(this,a)}),H("e",0,0,"weekday"),H("E",0,0,"isoWeekday"),z("day","d"),z("weekday","e"),z("isoWeekday","E"),N("d",Wc),N("e",Wc),N("E",Wc),N("dd",cd),N("ddd",cd),N("dddd",cd),R(["dd","ddd","dddd"],function(a,b,c){var d=c._locale.weekdaysParse(a);null!=d?b.d=d:j(c).invalidWeekday=a}),R(["d","e","E"],function(a,b,c,d){b[d]=q(a)});var Ed="Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),Fd="Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),Gd="Su_Mo_Tu_We_Th_Fr_Sa".split("_");H("H",["HH",2],0,"hour"),H("h",["hh",2],0,function(){return this.hours()%12||12}),Sb("a",!0),Sb("A",!1),z("hour","h"),N("a",Tb),N("A",Tb),N("H",Wc),N("h",Wc),N("HH",Wc,Sc),N("hh",Wc,Sc),Q(["H","HH"],id),Q(["a","A"],function(a,b,c){c._isPm=c._locale.isPM(a),c._meridiem=a}),Q(["h","hh"],function(a,b,c){b[id]=q(a),j(c).bigHour=!0});var Hd=/[ap]\.?m?\.?/i,Id=C("Hours",!0);H("m",["mm",2],0,"minute"),z("minute","m"),N("m",Wc),N("mm",Wc,Sc),Q(["m","mm"],jd);var Jd=C("Minutes",!1);H("s",["ss",2],0,"second"),z("second","s"),N("s",Wc),N("ss",Wc,Sc),Q(["s","ss"],kd);var Kd=C("Seconds",!1);H("S",0,0,function(){return~~(this.millisecond()/100)}),H(0,["SS",2],0,function(){return~~(this.millisecond()/10)}),H(0,["SSS",3],0,"millisecond"),H(0,["SSSS",4],0,function(){return 10*this.millisecond()}),H(0,["SSSSS",5],0,function(){return 100*this.millisecond()}),H(0,["SSSSSS",6],0,function(){return 1e3*this.millisecond()}),H(0,["SSSSSSS",7],0,function(){return 1e4*this.millisecond()}),H(0,["SSSSSSSS",8],0,function(){return 1e5*this.millisecond()}),H(0,["SSSSSSSSS",9],0,function(){return 1e6*this.millisecond()}),z("millisecond","ms"),N("S",Xc,Rc),N("SS",Xc,Sc),N("SSS",Xc,Tc);var Ld;for(Ld="SSSS";Ld.length<=9;Ld+="S")N(Ld,$c);for(Ld="S";Ld.length<=9;Ld+="S")Q(Ld,Wb);var Md=C("Milliseconds",!1);H("z",0,0,"zoneAbbr"),H("zz",0,0,"zoneName");var Nd=n.prototype;Nd.add=Ad,Nd.calendar=cb,Nd.clone=db,Nd.diff=ib,Nd.endOf=ub,Nd.format=mb,Nd.from=nb,Nd.fromNow=ob,Nd.to=pb,Nd.toNow=qb,Nd.get=F,Nd.invalidAt=Cb,Nd.isAfter=eb,Nd.isBefore=fb,Nd.isBetween=gb,Nd.isSame=hb,Nd.isValid=Ab,Nd.lang=Cd,Nd.locale=rb,Nd.localeData=sb,Nd.max=wd,Nd.min=vd,Nd.parsingFlags=Bb,Nd.set=F,Nd.startOf=tb,Nd.subtract=Bd,Nd.toArray=yb,Nd.toObject=zb,Nd.toDate=xb,Nd.toISOString=lb,Nd.toJSON=lb,Nd.toString=kb,Nd.unix=wb,Nd.valueOf=vb,Nd.year=td,Nd.isLeapYear=ia,Nd.weekYear=Fb,Nd.isoWeekYear=Gb,Nd.quarter=Nd.quarters=Jb,Nd.month=Y,Nd.daysInMonth=Z,Nd.week=Nd.weeks=na,Nd.isoWeek=Nd.isoWeeks=oa,Nd.weeksInYear=Ib,Nd.isoWeeksInYear=Hb,Nd.date=Dd,Nd.day=Nd.days=Pb,Nd.weekday=Qb,Nd.isoWeekday=Rb,Nd.dayOfYear=qa,Nd.hour=Nd.hours=Id,Nd.minute=Nd.minutes=Jd,Nd.second=Nd.seconds=Kd,
Nd.millisecond=Nd.milliseconds=Md,Nd.utcOffset=Na,Nd.utc=Pa,Nd.local=Qa,Nd.parseZone=Ra,Nd.hasAlignedHourOffset=Sa,Nd.isDST=Ta,Nd.isDSTShifted=Ua,Nd.isLocal=Va,Nd.isUtcOffset=Wa,Nd.isUtc=Xa,Nd.isUTC=Xa,Nd.zoneAbbr=Xb,Nd.zoneName=Yb,Nd.dates=aa("dates accessor is deprecated. Use date instead.",Dd),Nd.months=aa("months accessor is deprecated. Use month instead",Y),Nd.years=aa("years accessor is deprecated. Use year instead",td),Nd.zone=aa("moment().zone is deprecated, use moment().utcOffset instead. https://github.com/moment/moment/issues/1779",Oa);var Od=Nd,Pd={sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",nextWeek:"dddd [at] LT",lastDay:"[Yesterday at] LT",lastWeek:"[Last] dddd [at] LT",sameElse:"L"},Qd={LTS:"h:mm:ss A",LT:"h:mm A",L:"MM/DD/YYYY",LL:"MMMM D, YYYY",LLL:"MMMM D, YYYY h:mm A",LLLL:"dddd, MMMM D, YYYY h:mm A"},Rd="Invalid date",Sd="%d",Td=/\d{1,2}/,Ud={future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"},Vd=s.prototype;Vd._calendar=Pd,Vd.calendar=_b,Vd._longDateFormat=Qd,Vd.longDateFormat=ac,Vd._invalidDate=Rd,Vd.invalidDate=bc,Vd._ordinal=Sd,Vd.ordinal=cc,Vd._ordinalParse=Td,Vd.preparse=dc,Vd.postformat=dc,Vd._relativeTime=Ud,Vd.relativeTime=ec,Vd.pastFuture=fc,Vd.set=gc,Vd.months=U,Vd._months=md,Vd.monthsShort=V,Vd._monthsShort=nd,Vd.monthsParse=W,Vd.week=ka,Vd._week=ud,Vd.firstDayOfYear=ma,Vd.firstDayOfWeek=la,Vd.weekdays=Lb,Vd._weekdays=Ed,Vd.weekdaysMin=Nb,Vd._weekdaysMin=Gd,Vd.weekdaysShort=Mb,Vd._weekdaysShort=Fd,Vd.weekdaysParse=Ob,Vd.isPM=Ub,Vd._meridiemParse=Hd,Vd.meridiem=Vb,w("en",{ordinalParse:/\d{1,2}(th|st|nd|rd)/,ordinal:function(a){var b=a%10,c=1===q(a%100/10)?"th":1===b?"st":2===b?"nd":3===b?"rd":"th";return a+c}}),a.lang=aa("moment.lang is deprecated. Use moment.locale instead.",w),a.langData=aa("moment.langData is deprecated. Use moment.localeData instead.",y);var Wd=Math.abs,Xd=yc("ms"),Yd=yc("s"),Zd=yc("m"),$d=yc("h"),_d=yc("d"),ae=yc("w"),be=yc("M"),ce=yc("y"),de=Ac("milliseconds"),ee=Ac("seconds"),fe=Ac("minutes"),ge=Ac("hours"),he=Ac("days"),ie=Ac("months"),je=Ac("years"),ke=Math.round,le={s:45,m:45,h:22,d:26,M:11},me=Math.abs,ne=Ha.prototype;ne.abs=oc,ne.add=qc,ne.subtract=rc,ne.as=wc,ne.asMilliseconds=Xd,ne.asSeconds=Yd,ne.asMinutes=Zd,ne.asHours=$d,ne.asDays=_d,ne.asWeeks=ae,ne.asMonths=be,ne.asYears=ce,ne.valueOf=xc,ne._bubble=tc,ne.get=zc,ne.milliseconds=de,ne.seconds=ee,ne.minutes=fe,ne.hours=ge,ne.days=he,ne.weeks=Bc,ne.months=ie,ne.years=je,ne.humanize=Fc,ne.toISOString=Gc,ne.toString=Gc,ne.toJSON=Gc,ne.locale=rb,ne.localeData=sb,ne.toIsoString=aa("toIsoString() is deprecated. Please use toISOString() instead (notice the capitals)",Gc),ne.lang=Cd,H("X",0,0,"unix"),H("x",0,0,"valueOf"),N("x",_c),N("X",bd),Q("X",function(a,b,c){c._d=new Date(1e3*parseFloat(a,10))}),Q("x",function(a,b,c){c._d=new Date(q(a))}),a.version="2.10.6",b(Da),a.fn=Od,a.min=Fa,a.max=Ga,a.utc=h,a.unix=Zb,a.months=jc,a.isDate=d,a.locale=w,a.invalid=l,a.duration=Ya,a.isMoment=o,a.weekdays=lc,a.parseZone=$b,a.localeData=y,a.isDuration=Ia,a.monthsShort=kc,a.weekdaysMin=nc,a.defineLocale=x,a.weekdaysShort=mc,a.normalizeUnits=A,a.relativeTimeThreshold=Ec;var oe=a;return oe});
/*!
 * Chart.js
 * http://chartjs.org/
 * Version: 1.0.2
 *
 * Copyright 2015 Nick Downie
 * Released under the MIT license
 * https://github.com/nnnick/Chart.js/blob/master/LICENSE.md
 */
(function(){"use strict";var t=this,i=t.Chart,e=function(t){this.canvas=t.canvas,this.ctx=t;var i=function(t,i){return t["offset"+i]?t["offset"+i]:document.defaultView.getComputedStyle(t).getPropertyValue(i)},e=this.width=i(t.canvas,"Width"),n=this.height=i(t.canvas,"Height");t.canvas.width=e,t.canvas.height=n;var e=this.width=t.canvas.width,n=this.height=t.canvas.height;return this.aspectRatio=this.width/this.height,s.retinaScale(this),this};e.defaults={global:{animation:!0,animationSteps:60,animationEasing:"easeOutQuart",showScale:!0,scaleOverride:!1,scaleSteps:null,scaleStepWidth:null,scaleStartValue:null,scaleLineColor:"rgba(0,0,0,.1)",scaleLineWidth:1,scaleShowLabels:!0,scaleLabel:"<%=value%>",scaleIntegersOnly:!0,scaleBeginAtZero:!1,scaleFontFamily:"'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",scaleFontSize:12,scaleFontStyle:"normal",scaleFontColor:"#666",responsive:!1,maintainAspectRatio:!0,showTooltips:!0,customTooltips:!1,tooltipEvents:["mousemove","touchstart","touchmove","mouseout"],tooltipFillColor:"rgba(0,0,0,0.8)",tooltipFontFamily:"'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",tooltipFontSize:14,tooltipFontStyle:"normal",tooltipFontColor:"#fff",tooltipTitleFontFamily:"'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",tooltipTitleFontSize:14,tooltipTitleFontStyle:"bold",tooltipTitleFontColor:"#fff",tooltipYPadding:6,tooltipXPadding:6,tooltipCaretSize:8,tooltipCornerRadius:6,tooltipXOffset:10,tooltipTemplate:"<%if (label){%><%=label%>: <%}%><%= value %>",multiTooltipTemplate:"<%= value %>",multiTooltipKeyBackground:"#fff",onAnimationProgress:function(){},onAnimationComplete:function(){}}},e.types={};var s=e.helpers={},n=s.each=function(t,i,e){var s=Array.prototype.slice.call(arguments,3);if(t)if(t.length===+t.length){var n;for(n=0;n<t.length;n++)i.apply(e,[t[n],n].concat(s))}else for(var o in t)i.apply(e,[t[o],o].concat(s))},o=s.clone=function(t){var i={};return n(t,function(e,s){t.hasOwnProperty(s)&&(i[s]=e)}),i},a=s.extend=function(t){return n(Array.prototype.slice.call(arguments,1),function(i){n(i,function(e,s){i.hasOwnProperty(s)&&(t[s]=e)})}),t},h=s.merge=function(){var t=Array.prototype.slice.call(arguments,0);return t.unshift({}),a.apply(null,t)},l=s.indexOf=function(t,i){if(Array.prototype.indexOf)return t.indexOf(i);for(var e=0;e<t.length;e++)if(t[e]===i)return e;return-1},r=(s.where=function(t,i){var e=[];return s.each(t,function(t){i(t)&&e.push(t)}),e},s.findNextWhere=function(t,i,e){e||(e=-1);for(var s=e+1;s<t.length;s++){var n=t[s];if(i(n))return n}},s.findPreviousWhere=function(t,i,e){e||(e=t.length);for(var s=e-1;s>=0;s--){var n=t[s];if(i(n))return n}},s.inherits=function(t){var i=this,e=t&&t.hasOwnProperty("constructor")?t.constructor:function(){return i.apply(this,arguments)},s=function(){this.constructor=e};return s.prototype=i.prototype,e.prototype=new s,e.extend=r,t&&a(e.prototype,t),e.__super__=i.prototype,e}),c=s.noop=function(){},u=s.uid=function(){var t=0;return function(){return"chart-"+t++}}(),d=s.warn=function(t){window.console&&"function"==typeof window.console.warn&&console.warn(t)},p=s.amd="function"==typeof define&&define.amd,f=s.isNumber=function(t){return!isNaN(parseFloat(t))&&isFinite(t)},g=s.max=function(t){return Math.max.apply(Math,t)},m=s.min=function(t){return Math.min.apply(Math,t)},v=(s.cap=function(t,i,e){if(f(i)){if(t>i)return i}else if(f(e)&&e>t)return e;return t},s.getDecimalPlaces=function(t){return t%1!==0&&f(t)?t.toString().split(".")[1].length:0}),S=s.radians=function(t){return t*(Math.PI/180)},x=(s.getAngleFromPoint=function(t,i){var e=i.x-t.x,s=i.y-t.y,n=Math.sqrt(e*e+s*s),o=2*Math.PI+Math.atan2(s,e);return 0>e&&0>s&&(o+=2*Math.PI),{angle:o,distance:n}},s.aliasPixel=function(t){return t%2===0?0:.5}),y=(s.splineCurve=function(t,i,e,s){var n=Math.sqrt(Math.pow(i.x-t.x,2)+Math.pow(i.y-t.y,2)),o=Math.sqrt(Math.pow(e.x-i.x,2)+Math.pow(e.y-i.y,2)),a=s*n/(n+o),h=s*o/(n+o);return{inner:{x:i.x-a*(e.x-t.x),y:i.y-a*(e.y-t.y)},outer:{x:i.x+h*(e.x-t.x),y:i.y+h*(e.y-t.y)}}},s.calculateOrderOfMagnitude=function(t){return Math.floor(Math.log(t)/Math.LN10)}),C=(s.calculateScaleRange=function(t,i,e,s,n){var o=2,a=Math.floor(i/(1.5*e)),h=o>=a,l=g(t),r=m(t);l===r&&(l+=.5,r>=.5&&!s?r-=.5:l+=.5);for(var c=Math.abs(l-r),u=y(c),d=Math.ceil(l/(1*Math.pow(10,u)))*Math.pow(10,u),p=s?0:Math.floor(r/(1*Math.pow(10,u)))*Math.pow(10,u),f=d-p,v=Math.pow(10,u),S=Math.round(f/v);(S>a||a>2*S)&&!h;)if(S>a)v*=2,S=Math.round(f/v),S%1!==0&&(h=!0);else if(n&&u>=0){if(v/2%1!==0)break;v/=2,S=Math.round(f/v)}else v/=2,S=Math.round(f/v);return h&&(S=o,v=f/S),{steps:S,stepValue:v,min:p,max:p+S*v}},s.template=function(t,i){function e(t,i){var e=/\W/.test(t)?new Function("obj","var p=[],print=function(){p.push.apply(p,arguments);};with(obj){p.push('"+t.replace(/[\r\t\n]/g," ").split("<%").join("	").replace(/((^|%>)[^\t]*)'/g,"$1\r").replace(/\t=(.*?)%>/g,"',$1,'").split("	").join("');").split("%>").join("p.push('").split("\r").join("\\'")+"');}return p.join('');"):s[t]=s[t];return i?e(i):e}if(t instanceof Function)return t(i);var s={};return e(t,i)}),w=(s.generateLabels=function(t,i,e,s){var o=new Array(i);return labelTemplateString&&n(o,function(i,n){o[n]=C(t,{value:e+s*(n+1)})}),o},s.easingEffects={linear:function(t){return t},easeInQuad:function(t){return t*t},easeOutQuad:function(t){return-1*t*(t-2)},easeInOutQuad:function(t){return(t/=.5)<1?.5*t*t:-0.5*(--t*(t-2)-1)},easeInCubic:function(t){return t*t*t},easeOutCubic:function(t){return 1*((t=t/1-1)*t*t+1)},easeInOutCubic:function(t){return(t/=.5)<1?.5*t*t*t:.5*((t-=2)*t*t+2)},easeInQuart:function(t){return t*t*t*t},easeOutQuart:function(t){return-1*((t=t/1-1)*t*t*t-1)},easeInOutQuart:function(t){return(t/=.5)<1?.5*t*t*t*t:-0.5*((t-=2)*t*t*t-2)},easeInQuint:function(t){return 1*(t/=1)*t*t*t*t},easeOutQuint:function(t){return 1*((t=t/1-1)*t*t*t*t+1)},easeInOutQuint:function(t){return(t/=.5)<1?.5*t*t*t*t*t:.5*((t-=2)*t*t*t*t+2)},easeInSine:function(t){return-1*Math.cos(t/1*(Math.PI/2))+1},easeOutSine:function(t){return 1*Math.sin(t/1*(Math.PI/2))},easeInOutSine:function(t){return-0.5*(Math.cos(Math.PI*t/1)-1)},easeInExpo:function(t){return 0===t?1:1*Math.pow(2,10*(t/1-1))},easeOutExpo:function(t){return 1===t?1:1*(-Math.pow(2,-10*t/1)+1)},easeInOutExpo:function(t){return 0===t?0:1===t?1:(t/=.5)<1?.5*Math.pow(2,10*(t-1)):.5*(-Math.pow(2,-10*--t)+2)},easeInCirc:function(t){return t>=1?t:-1*(Math.sqrt(1-(t/=1)*t)-1)},easeOutCirc:function(t){return 1*Math.sqrt(1-(t=t/1-1)*t)},easeInOutCirc:function(t){return(t/=.5)<1?-0.5*(Math.sqrt(1-t*t)-1):.5*(Math.sqrt(1-(t-=2)*t)+1)},easeInElastic:function(t){var i=1.70158,e=0,s=1;return 0===t?0:1==(t/=1)?1:(e||(e=.3),s<Math.abs(1)?(s=1,i=e/4):i=e/(2*Math.PI)*Math.asin(1/s),-(s*Math.pow(2,10*(t-=1))*Math.sin(2*(1*t-i)*Math.PI/e)))},easeOutElastic:function(t){var i=1.70158,e=0,s=1;return 0===t?0:1==(t/=1)?1:(e||(e=.3),s<Math.abs(1)?(s=1,i=e/4):i=e/(2*Math.PI)*Math.asin(1/s),s*Math.pow(2,-10*t)*Math.sin(2*(1*t-i)*Math.PI/e)+1)},easeInOutElastic:function(t){var i=1.70158,e=0,s=1;return 0===t?0:2==(t/=.5)?1:(e||(e=.3*1.5),s<Math.abs(1)?(s=1,i=e/4):i=e/(2*Math.PI)*Math.asin(1/s),1>t?-.5*s*Math.pow(2,10*(t-=1))*Math.sin(2*(1*t-i)*Math.PI/e):s*Math.pow(2,-10*(t-=1))*Math.sin(2*(1*t-i)*Math.PI/e)*.5+1)},easeInBack:function(t){var i=1.70158;return 1*(t/=1)*t*((i+1)*t-i)},easeOutBack:function(t){var i=1.70158;return 1*((t=t/1-1)*t*((i+1)*t+i)+1)},easeInOutBack:function(t){var i=1.70158;return(t/=.5)<1?.5*t*t*(((i*=1.525)+1)*t-i):.5*((t-=2)*t*(((i*=1.525)+1)*t+i)+2)},easeInBounce:function(t){return 1-w.easeOutBounce(1-t)},easeOutBounce:function(t){return(t/=1)<1/2.75?7.5625*t*t:2/2.75>t?1*(7.5625*(t-=1.5/2.75)*t+.75):2.5/2.75>t?1*(7.5625*(t-=2.25/2.75)*t+.9375):1*(7.5625*(t-=2.625/2.75)*t+.984375)},easeInOutBounce:function(t){return.5>t?.5*w.easeInBounce(2*t):.5*w.easeOutBounce(2*t-1)+.5}}),b=s.requestAnimFrame=function(){return window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame||function(t){return window.setTimeout(t,1e3/60)}}(),P=s.cancelAnimFrame=function(){return window.cancelAnimationFrame||window.webkitCancelAnimationFrame||window.mozCancelAnimationFrame||window.oCancelAnimationFrame||window.msCancelAnimationFrame||function(t){return window.clearTimeout(t,1e3/60)}}(),L=(s.animationLoop=function(t,i,e,s,n,o){var a=0,h=w[e]||w.linear,l=function(){a++;var e=a/i,r=h(e);t.call(o,r,e,a),s.call(o,r,e),i>a?o.animationFrame=b(l):n.apply(o)};b(l)},s.getRelativePosition=function(t){var i,e,s=t.originalEvent||t,n=t.currentTarget||t.srcElement,o=n.getBoundingClientRect();return s.touches?(i=s.touches[0].clientX-o.left,e=s.touches[0].clientY-o.top):(i=s.clientX-o.left,e=s.clientY-o.top),{x:i,y:e}},s.addEvent=function(t,i,e){t.addEventListener?t.addEventListener(i,e):t.attachEvent?t.attachEvent("on"+i,e):t["on"+i]=e}),k=s.removeEvent=function(t,i,e){t.removeEventListener?t.removeEventListener(i,e,!1):t.detachEvent?t.detachEvent("on"+i,e):t["on"+i]=c},F=(s.bindEvents=function(t,i,e){t.events||(t.events={}),n(i,function(i){t.events[i]=function(){e.apply(t,arguments)},L(t.chart.canvas,i,t.events[i])})},s.unbindEvents=function(t,i){n(i,function(i,e){k(t.chart.canvas,e,i)})}),R=s.getMaximumWidth=function(t){var i=t.parentNode;return i.clientWidth},T=s.getMaximumHeight=function(t){var i=t.parentNode;return i.clientHeight},A=(s.getMaximumSize=s.getMaximumWidth,s.retinaScale=function(t){var i=t.ctx,e=t.canvas.width,s=t.canvas.height;window.devicePixelRatio&&(i.canvas.style.width=e+"px",i.canvas.style.height=s+"px",i.canvas.height=s*window.devicePixelRatio,i.canvas.width=e*window.devicePixelRatio,i.scale(window.devicePixelRatio,window.devicePixelRatio))}),M=s.clear=function(t){t.ctx.clearRect(0,0,t.width,t.height)},W=s.fontString=function(t,i,e){return i+" "+t+"px "+e},z=s.longestText=function(t,i,e){t.font=i;var s=0;return n(e,function(i){var e=t.measureText(i).width;s=e>s?e:s}),s},B=s.drawRoundedRectangle=function(t,i,e,s,n,o){t.beginPath(),t.moveTo(i+o,e),t.lineTo(i+s-o,e),t.quadraticCurveTo(i+s,e,i+s,e+o),t.lineTo(i+s,e+n-o),t.quadraticCurveTo(i+s,e+n,i+s-o,e+n),t.lineTo(i+o,e+n),t.quadraticCurveTo(i,e+n,i,e+n-o),t.lineTo(i,e+o),t.quadraticCurveTo(i,e,i+o,e),t.closePath()};e.instances={},e.Type=function(t,i,s){this.options=i,this.chart=s,this.id=u(),e.instances[this.id]=this,i.responsive&&this.resize(),this.initialize.call(this,t)},a(e.Type.prototype,{initialize:function(){return this},clear:function(){return M(this.chart),this},stop:function(){return P(this.animationFrame),this},resize:function(t){this.stop();var i=this.chart.canvas,e=R(this.chart.canvas),s=this.options.maintainAspectRatio?e/this.chart.aspectRatio:T(this.chart.canvas);return i.width=this.chart.width=e,i.height=this.chart.height=s,A(this.chart),"function"==typeof t&&t.apply(this,Array.prototype.slice.call(arguments,1)),this},reflow:c,render:function(t){return t&&this.reflow(),this.options.animation&&!t?s.animationLoop(this.draw,this.options.animationSteps,this.options.animationEasing,this.options.onAnimationProgress,this.options.onAnimationComplete,this):(this.draw(),this.options.onAnimationComplete.call(this)),this},generateLegend:function(){return C(this.options.legendTemplate,this)},destroy:function(){this.clear(),F(this,this.events);var t=this.chart.canvas;t.width=this.chart.width,t.height=this.chart.height,t.style.removeProperty?(t.style.removeProperty("width"),t.style.removeProperty("height")):(t.style.removeAttribute("width"),t.style.removeAttribute("height")),delete e.instances[this.id]},showTooltip:function(t,i){"undefined"==typeof this.activeElements&&(this.activeElements=[]);var o=function(t){var i=!1;return t.length!==this.activeElements.length?i=!0:(n(t,function(t,e){t!==this.activeElements[e]&&(i=!0)},this),i)}.call(this,t);if(o||i){if(this.activeElements=t,this.draw(),this.options.customTooltips&&this.options.customTooltips(!1),t.length>0)if(this.datasets&&this.datasets.length>1){for(var a,h,r=this.datasets.length-1;r>=0&&(a=this.datasets[r].points||this.datasets[r].bars||this.datasets[r].segments,h=l(a,t[0]),-1===h);r--);var c=[],u=[],d=function(){var t,i,e,n,o,a=[],l=[],r=[];return s.each(this.datasets,function(i){t=i.points||i.bars||i.segments,t[h]&&t[h].hasValue()&&a.push(t[h])}),s.each(a,function(t){l.push(t.x),r.push(t.y),c.push(s.template(this.options.multiTooltipTemplate,t)),u.push({fill:t._saved.fillColor||t.fillColor,stroke:t._saved.strokeColor||t.strokeColor})},this),o=m(r),e=g(r),n=m(l),i=g(l),{x:n>this.chart.width/2?n:i,y:(o+e)/2}}.call(this,h);new e.MultiTooltip({x:d.x,y:d.y,xPadding:this.options.tooltipXPadding,yPadding:this.options.tooltipYPadding,xOffset:this.options.tooltipXOffset,fillColor:this.options.tooltipFillColor,textColor:this.options.tooltipFontColor,fontFamily:this.options.tooltipFontFamily,fontStyle:this.options.tooltipFontStyle,fontSize:this.options.tooltipFontSize,titleTextColor:this.options.tooltipTitleFontColor,titleFontFamily:this.options.tooltipTitleFontFamily,titleFontStyle:this.options.tooltipTitleFontStyle,titleFontSize:this.options.tooltipTitleFontSize,cornerRadius:this.options.tooltipCornerRadius,labels:c,legendColors:u,legendColorBackground:this.options.multiTooltipKeyBackground,title:t[0].label,chart:this.chart,ctx:this.chart.ctx,custom:this.options.customTooltips}).draw()}else n(t,function(t){var i=t.tooltipPosition();new e.Tooltip({x:Math.round(i.x),y:Math.round(i.y),xPadding:this.options.tooltipXPadding,yPadding:this.options.tooltipYPadding,fillColor:this.options.tooltipFillColor,textColor:this.options.tooltipFontColor,fontFamily:this.options.tooltipFontFamily,fontStyle:this.options.tooltipFontStyle,fontSize:this.options.tooltipFontSize,caretHeight:this.options.tooltipCaretSize,cornerRadius:this.options.tooltipCornerRadius,text:C(this.options.tooltipTemplate,t),chart:this.chart,custom:this.options.customTooltips}).draw()},this);return this}},toBase64Image:function(){return this.chart.canvas.toDataURL.apply(this.chart.canvas,arguments)}}),e.Type.extend=function(t){var i=this,s=function(){return i.apply(this,arguments)};if(s.prototype=o(i.prototype),a(s.prototype,t),s.extend=e.Type.extend,t.name||i.prototype.name){var n=t.name||i.prototype.name,l=e.defaults[i.prototype.name]?o(e.defaults[i.prototype.name]):{};e.defaults[n]=a(l,t.defaults),e.types[n]=s,e.prototype[n]=function(t,i){var o=h(e.defaults.global,e.defaults[n],i||{});return new s(t,o,this)}}else d("Name not provided for this chart, so it hasn't been registered");return i},e.Element=function(t){a(this,t),this.initialize.apply(this,arguments),this.save()},a(e.Element.prototype,{initialize:function(){},restore:function(t){return t?n(t,function(t){this[t]=this._saved[t]},this):a(this,this._saved),this},save:function(){return this._saved=o(this),delete this._saved._saved,this},update:function(t){return n(t,function(t,i){this._saved[i]=this[i],this[i]=t},this),this},transition:function(t,i){return n(t,function(t,e){this[e]=(t-this._saved[e])*i+this._saved[e]},this),this},tooltipPosition:function(){return{x:this.x,y:this.y}},hasValue:function(){return f(this.value)}}),e.Element.extend=r,e.Point=e.Element.extend({display:!0,inRange:function(t,i){var e=this.hitDetectionRadius+this.radius;return Math.pow(t-this.x,2)+Math.pow(i-this.y,2)<Math.pow(e,2)},draw:function(){if(this.display){var t=this.ctx;t.beginPath(),t.arc(this.x,this.y,this.radius,0,2*Math.PI),t.closePath(),t.strokeStyle=this.strokeColor,t.lineWidth=this.strokeWidth,t.fillStyle=this.fillColor,t.fill(),t.stroke()}}}),e.Arc=e.Element.extend({inRange:function(t,i){var e=s.getAngleFromPoint(this,{x:t,y:i}),n=e.angle>=this.startAngle&&e.angle<=this.endAngle,o=e.distance>=this.innerRadius&&e.distance<=this.outerRadius;return n&&o},tooltipPosition:function(){var t=this.startAngle+(this.endAngle-this.startAngle)/2,i=(this.outerRadius-this.innerRadius)/2+this.innerRadius;return{x:this.x+Math.cos(t)*i,y:this.y+Math.sin(t)*i}},draw:function(t){var i=this.ctx;i.beginPath(),i.arc(this.x,this.y,this.outerRadius,this.startAngle,this.endAngle),i.arc(this.x,this.y,this.innerRadius,this.endAngle,this.startAngle,!0),i.closePath(),i.strokeStyle=this.strokeColor,i.lineWidth=this.strokeWidth,i.fillStyle=this.fillColor,i.fill(),i.lineJoin="bevel",this.showStroke&&i.stroke()}}),e.Rectangle=e.Element.extend({draw:function(){var t=this.ctx,i=this.width/2,e=this.x-i,s=this.x+i,n=this.base-(this.base-this.y),o=this.strokeWidth/2;this.showStroke&&(e+=o,s-=o,n+=o),t.beginPath(),t.fillStyle=this.fillColor,t.strokeStyle=this.strokeColor,t.lineWidth=this.strokeWidth,t.moveTo(e,this.base),t.lineTo(e,n),t.lineTo(s,n),t.lineTo(s,this.base),t.fill(),this.showStroke&&t.stroke()},height:function(){return this.base-this.y},inRange:function(t,i){return t>=this.x-this.width/2&&t<=this.x+this.width/2&&i>=this.y&&i<=this.base}}),e.Tooltip=e.Element.extend({draw:function(){var t=this.chart.ctx;t.font=W(this.fontSize,this.fontStyle,this.fontFamily),this.xAlign="center",this.yAlign="above";var i=this.caretPadding=2,e=t.measureText(this.text).width+2*this.xPadding,s=this.fontSize+2*this.yPadding,n=s+this.caretHeight+i;this.x+e/2>this.chart.width?this.xAlign="left":this.x-e/2<0&&(this.xAlign="right"),this.y-n<0&&(this.yAlign="below");var o=this.x-e/2,a=this.y-n;if(t.fillStyle=this.fillColor,this.custom)this.custom(this);else{switch(this.yAlign){case"above":t.beginPath(),t.moveTo(this.x,this.y-i),t.lineTo(this.x+this.caretHeight,this.y-(i+this.caretHeight)),t.lineTo(this.x-this.caretHeight,this.y-(i+this.caretHeight)),t.closePath(),t.fill();break;case"below":a=this.y+i+this.caretHeight,t.beginPath(),t.moveTo(this.x,this.y+i),t.lineTo(this.x+this.caretHeight,this.y+i+this.caretHeight),t.lineTo(this.x-this.caretHeight,this.y+i+this.caretHeight),t.closePath(),t.fill()}switch(this.xAlign){case"left":o=this.x-e+(this.cornerRadius+this.caretHeight);break;case"right":o=this.x-(this.cornerRadius+this.caretHeight)}B(t,o,a,e,s,this.cornerRadius),t.fill(),t.fillStyle=this.textColor,t.textAlign="center",t.textBaseline="middle",t.fillText(this.text,o+e/2,a+s/2)}}}),e.MultiTooltip=e.Element.extend({initialize:function(){this.font=W(this.fontSize,this.fontStyle,this.fontFamily),this.titleFont=W(this.titleFontSize,this.titleFontStyle,this.titleFontFamily),this.height=this.labels.length*this.fontSize+(this.labels.length-1)*(this.fontSize/2)+2*this.yPadding+1.5*this.titleFontSize,this.ctx.font=this.titleFont;var t=this.ctx.measureText(this.title).width,i=z(this.ctx,this.font,this.labels)+this.fontSize+3,e=g([i,t]);this.width=e+2*this.xPadding;var s=this.height/2;this.y-s<0?this.y=s:this.y+s>this.chart.height&&(this.y=this.chart.height-s),this.x>this.chart.width/2?this.x-=this.xOffset+this.width:this.x+=this.xOffset},getLineHeight:function(t){var i=this.y-this.height/2+this.yPadding,e=t-1;return 0===t?i+this.titleFontSize/2:i+(1.5*this.fontSize*e+this.fontSize/2)+1.5*this.titleFontSize},draw:function(){if(this.custom)this.custom(this);else{B(this.ctx,this.x,this.y-this.height/2,this.width,this.height,this.cornerRadius);var t=this.ctx;t.fillStyle=this.fillColor,t.fill(),t.closePath(),t.textAlign="left",t.textBaseline="middle",t.fillStyle=this.titleTextColor,t.font=this.titleFont,t.fillText(this.title,this.x+this.xPadding,this.getLineHeight(0)),t.font=this.font,s.each(this.labels,function(i,e){t.fillStyle=this.textColor,t.fillText(i,this.x+this.xPadding+this.fontSize+3,this.getLineHeight(e+1)),t.fillStyle=this.legendColorBackground,t.fillRect(this.x+this.xPadding,this.getLineHeight(e+1)-this.fontSize/2,this.fontSize,this.fontSize),t.fillStyle=this.legendColors[e].fill,t.fillRect(this.x+this.xPadding,this.getLineHeight(e+1)-this.fontSize/2,this.fontSize,this.fontSize)},this)}}}),e.Scale=e.Element.extend({initialize:function(){this.fit()},buildYLabels:function(){this.yLabels=[];for(var t=v(this.stepValue),i=0;i<=this.steps;i++)this.yLabels.push(C(this.templateString,{value:(this.min+i*this.stepValue).toFixed(t)}));this.yLabelWidth=this.display&&this.showLabels?z(this.ctx,this.font,this.yLabels):0},addXLabel:function(t){this.xLabels.push(t),this.valuesCount++,this.fit()},removeXLabel:function(){this.xLabels.shift(),this.valuesCount--,this.fit()},fit:function(){this.startPoint=this.display?this.fontSize:0,this.endPoint=this.display?this.height-1.5*this.fontSize-5:this.height,this.startPoint+=this.padding,this.endPoint-=this.padding;var t,i=this.endPoint-this.startPoint;for(this.calculateYRange(i),this.buildYLabels(),this.calculateXLabelRotation();i>this.endPoint-this.startPoint;)i=this.endPoint-this.startPoint,t=this.yLabelWidth,this.calculateYRange(i),this.buildYLabels(),t<this.yLabelWidth&&this.calculateXLabelRotation()},calculateXLabelRotation:function(){this.ctx.font=this.font;var t,i,e=this.ctx.measureText(this.xLabels[0]).width,s=this.ctx.measureText(this.xLabels[this.xLabels.length-1]).width;if(this.xScalePaddingRight=s/2+3,this.xScalePaddingLeft=e/2>this.yLabelWidth+10?e/2:this.yLabelWidth+10,this.xLabelRotation=0,this.display){var n,o=z(this.ctx,this.font,this.xLabels);this.xLabelWidth=o;for(var a=Math.floor(this.calculateX(1)-this.calculateX(0))-6;this.xLabelWidth>a&&0===this.xLabelRotation||this.xLabelWidth>a&&this.xLabelRotation<=90&&this.xLabelRotation>0;)n=Math.cos(S(this.xLabelRotation)),t=n*e,i=n*s,t+this.fontSize/2>this.yLabelWidth+8&&(this.xScalePaddingLeft=t+this.fontSize/2),this.xScalePaddingRight=this.fontSize/2,this.xLabelRotation++,this.xLabelWidth=n*o;this.xLabelRotation>0&&(this.endPoint-=Math.sin(S(this.xLabelRotation))*o+3)}else this.xLabelWidth=0,this.xScalePaddingRight=this.padding,this.xScalePaddingLeft=this.padding},calculateYRange:c,drawingArea:function(){return this.startPoint-this.endPoint},calculateY:function(t){var i=this.drawingArea()/(this.min-this.max);return this.endPoint-i*(t-this.min)},calculateX:function(t){var i=(this.xLabelRotation>0,this.width-(this.xScalePaddingLeft+this.xScalePaddingRight)),e=i/Math.max(this.valuesCount-(this.offsetGridLines?0:1),1),s=e*t+this.xScalePaddingLeft;return this.offsetGridLines&&(s+=e/2),Math.round(s)},update:function(t){s.extend(this,t),this.fit()},draw:function(){var t=this.ctx,i=(this.endPoint-this.startPoint)/this.steps,e=Math.round(this.xScalePaddingLeft);this.display&&(t.fillStyle=this.textColor,t.font=this.font,n(this.yLabels,function(n,o){var a=this.endPoint-i*o,h=Math.round(a),l=this.showHorizontalLines;t.textAlign="right",t.textBaseline="middle",this.showLabels&&t.fillText(n,e-10,a),0!==o||l||(l=!0),l&&t.beginPath(),o>0?(t.lineWidth=this.gridLineWidth,t.strokeStyle=this.gridLineColor):(t.lineWidth=this.lineWidth,t.strokeStyle=this.lineColor),h+=s.aliasPixel(t.lineWidth),l&&(t.moveTo(e,h),t.lineTo(this.width,h),t.stroke(),t.closePath()),t.lineWidth=this.lineWidth,t.strokeStyle=this.lineColor,t.beginPath(),t.moveTo(e-5,h),t.lineTo(e,h),t.stroke(),t.closePath()},this),n(this.xLabels,function(i,e){var s=this.calculateX(e)+x(this.lineWidth),n=this.calculateX(e-(this.offsetGridLines?.5:0))+x(this.lineWidth),o=this.xLabelRotation>0,a=this.showVerticalLines;0!==e||a||(a=!0),a&&t.beginPath(),e>0?(t.lineWidth=this.gridLineWidth,t.strokeStyle=this.gridLineColor):(t.lineWidth=this.lineWidth,t.strokeStyle=this.lineColor),a&&(t.moveTo(n,this.endPoint),t.lineTo(n,this.startPoint-3),t.stroke(),t.closePath()),t.lineWidth=this.lineWidth,t.strokeStyle=this.lineColor,t.beginPath(),t.moveTo(n,this.endPoint),t.lineTo(n,this.endPoint+5),t.stroke(),t.closePath(),t.save(),t.translate(s,o?this.endPoint+12:this.endPoint+8),t.rotate(-1*S(this.xLabelRotation)),t.font=this.font,t.textAlign=o?"right":"center",t.textBaseline=o?"middle":"top",t.fillText(i,0,0),t.restore()},this))}}),e.RadialScale=e.Element.extend({initialize:function(){this.size=m([this.height,this.width]),this.drawingArea=this.display?this.size/2-(this.fontSize/2+this.backdropPaddingY):this.size/2},calculateCenterOffset:function(t){var i=this.drawingArea/(this.max-this.min);return(t-this.min)*i},update:function(){this.lineArc?this.drawingArea=this.display?this.size/2-(this.fontSize/2+this.backdropPaddingY):this.size/2:this.setScaleSize(),this.buildYLabels()},buildYLabels:function(){this.yLabels=[];for(var t=v(this.stepValue),i=0;i<=this.steps;i++)this.yLabels.push(C(this.templateString,{value:(this.min+i*this.stepValue).toFixed(t)}))},getCircumference:function(){return 2*Math.PI/this.valuesCount},setScaleSize:function(){var t,i,e,s,n,o,a,h,l,r,c,u,d=m([this.height/2-this.pointLabelFontSize-5,this.width/2]),p=this.width,g=0;for(this.ctx.font=W(this.pointLabelFontSize,this.pointLabelFontStyle,this.pointLabelFontFamily),i=0;i<this.valuesCount;i++)t=this.getPointPosition(i,d),e=this.ctx.measureText(C(this.templateString,{value:this.labels[i]})).width+5,0===i||i===this.valuesCount/2?(s=e/2,t.x+s>p&&(p=t.x+s,n=i),t.x-s<g&&(g=t.x-s,a=i)):i<this.valuesCount/2?t.x+e>p&&(p=t.x+e,n=i):i>this.valuesCount/2&&t.x-e<g&&(g=t.x-e,a=i);l=g,r=Math.ceil(p-this.width),o=this.getIndexAngle(n),h=this.getIndexAngle(a),c=r/Math.sin(o+Math.PI/2),u=l/Math.sin(h+Math.PI/2),c=f(c)?c:0,u=f(u)?u:0,this.drawingArea=d-(u+c)/2,this.setCenterPoint(u,c)},setCenterPoint:function(t,i){var e=this.width-i-this.drawingArea,s=t+this.drawingArea;this.xCenter=(s+e)/2,this.yCenter=this.height/2},getIndexAngle:function(t){var i=2*Math.PI/this.valuesCount;return t*i-Math.PI/2},getPointPosition:function(t,i){var e=this.getIndexAngle(t);return{x:Math.cos(e)*i+this.xCenter,y:Math.sin(e)*i+this.yCenter}},draw:function(){if(this.display){var t=this.ctx;if(n(this.yLabels,function(i,e){if(e>0){var s,n=e*(this.drawingArea/this.steps),o=this.yCenter-n;if(this.lineWidth>0)if(t.strokeStyle=this.lineColor,t.lineWidth=this.lineWidth,this.lineArc)t.beginPath(),t.arc(this.xCenter,this.yCenter,n,0,2*Math.PI),t.closePath(),t.stroke();else{t.beginPath();for(var a=0;a<this.valuesCount;a++)s=this.getPointPosition(a,this.calculateCenterOffset(this.min+e*this.stepValue)),0===a?t.moveTo(s.x,s.y):t.lineTo(s.x,s.y);t.closePath(),t.stroke()}if(this.showLabels){if(t.font=W(this.fontSize,this.fontStyle,this.fontFamily),this.showLabelBackdrop){var h=t.measureText(i).width;t.fillStyle=this.backdropColor,t.fillRect(this.xCenter-h/2-this.backdropPaddingX,o-this.fontSize/2-this.backdropPaddingY,h+2*this.backdropPaddingX,this.fontSize+2*this.backdropPaddingY)}t.textAlign="center",t.textBaseline="middle",t.fillStyle=this.fontColor,t.fillText(i,this.xCenter,o)}}},this),!this.lineArc){t.lineWidth=this.angleLineWidth,t.strokeStyle=this.angleLineColor;for(var i=this.valuesCount-1;i>=0;i--){if(this.angleLineWidth>0){var e=this.getPointPosition(i,this.calculateCenterOffset(this.max));t.beginPath(),t.moveTo(this.xCenter,this.yCenter),t.lineTo(e.x,e.y),t.stroke(),t.closePath()}var s=this.getPointPosition(i,this.calculateCenterOffset(this.max)+5);t.font=W(this.pointLabelFontSize,this.pointLabelFontStyle,this.pointLabelFontFamily),t.fillStyle=this.pointLabelFontColor;var o=this.labels.length,a=this.labels.length/2,h=a/2,l=h>i||i>o-h,r=i===h||i===o-h;t.textAlign=0===i?"center":i===a?"center":a>i?"left":"right",t.textBaseline=r?"middle":l?"bottom":"top",t.fillText(this.labels[i],s.x,s.y)}}}}}),s.addEvent(window,"resize",function(){var t;return function(){clearTimeout(t),t=setTimeout(function(){n(e.instances,function(t){t.options.responsive&&t.resize(t.render,!0)})},50)}}()),p?define(function(){return e}):"object"==typeof module&&module.exports&&(module.exports=e),t.Chart=e,e.noConflict=function(){return t.Chart=i,e}}).call(this),function(){"use strict";var t=this,i=t.Chart,e=i.helpers,s={scaleBeginAtZero:!0,scaleShowGridLines:!0,scaleGridLineColor:"rgba(0,0,0,.05)",scaleGridLineWidth:1,scaleShowHorizontalLines:!0,scaleShowVerticalLines:!0,barShowStroke:!0,barStrokeWidth:2,barValueSpacing:5,barDatasetSpacing:1,legendTemplate:'<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].fillColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'};i.Type.extend({name:"Bar",defaults:s,initialize:function(t){var s=this.options;this.ScaleClass=i.Scale.extend({offsetGridLines:!0,calculateBarX:function(t,i,e){var n=this.calculateBaseWidth(),o=this.calculateX(e)-n/2,a=this.calculateBarWidth(t);return o+a*i+i*s.barDatasetSpacing+a/2},calculateBaseWidth:function(){return this.calculateX(1)-this.calculateX(0)-2*s.barValueSpacing},calculateBarWidth:function(t){var i=this.calculateBaseWidth()-(t-1)*s.barDatasetSpacing;return i/t}}),this.datasets=[],this.options.showTooltips&&e.bindEvents(this,this.options.tooltipEvents,function(t){var i="mouseout"!==t.type?this.getBarsAtEvent(t):[];this.eachBars(function(t){t.restore(["fillColor","strokeColor"])}),e.each(i,function(t){t.fillColor=t.highlightFill,t.strokeColor=t.highlightStroke}),this.showTooltip(i)}),this.BarClass=i.Rectangle.extend({strokeWidth:this.options.barStrokeWidth,showStroke:this.options.barShowStroke,ctx:this.chart.ctx}),e.each(t.datasets,function(i){var s={label:i.label||null,fillColor:i.fillColor,strokeColor:i.strokeColor,bars:[]};this.datasets.push(s),e.each(i.data,function(e,n){s.bars.push(new this.BarClass({value:e,label:t.labels[n],datasetLabel:i.label,strokeColor:i.strokeColor,fillColor:i.fillColor,highlightFill:i.highlightFill||i.fillColor,highlightStroke:i.highlightStroke||i.strokeColor}))},this)},this),this.buildScale(t.labels),this.BarClass.prototype.base=this.scale.endPoint,this.eachBars(function(t,i,s){e.extend(t,{width:this.scale.calculateBarWidth(this.datasets.length),x:this.scale.calculateBarX(this.datasets.length,s,i),y:this.scale.endPoint}),t.save()},this),this.render()},update:function(){this.scale.update(),e.each(this.activeElements,function(t){t.restore(["fillColor","strokeColor"])}),this.eachBars(function(t){t.save()}),this.render()},eachBars:function(t){e.each(this.datasets,function(i,s){e.each(i.bars,t,this,s)},this)},getBarsAtEvent:function(t){for(var i,s=[],n=e.getRelativePosition(t),o=function(t){s.push(t.bars[i])},a=0;a<this.datasets.length;a++)for(i=0;i<this.datasets[a].bars.length;i++)if(this.datasets[a].bars[i].inRange(n.x,n.y))return e.each(this.datasets,o),s;return s},buildScale:function(t){var i=this,s=function(){var t=[];return i.eachBars(function(i){t.push(i.value)}),t},n={templateString:this.options.scaleLabel,height:this.chart.height,width:this.chart.width,ctx:this.chart.ctx,textColor:this.options.scaleFontColor,fontSize:this.options.scaleFontSize,fontStyle:this.options.scaleFontStyle,fontFamily:this.options.scaleFontFamily,valuesCount:t.length,beginAtZero:this.options.scaleBeginAtZero,integersOnly:this.options.scaleIntegersOnly,calculateYRange:function(t){var i=e.calculateScaleRange(s(),t,this.fontSize,this.beginAtZero,this.integersOnly);e.extend(this,i)},xLabels:t,font:e.fontString(this.options.scaleFontSize,this.options.scaleFontStyle,this.options.scaleFontFamily),lineWidth:this.options.scaleLineWidth,lineColor:this.options.scaleLineColor,showHorizontalLines:this.options.scaleShowHorizontalLines,showVerticalLines:this.options.scaleShowVerticalLines,gridLineWidth:this.options.scaleShowGridLines?this.options.scaleGridLineWidth:0,gridLineColor:this.options.scaleShowGridLines?this.options.scaleGridLineColor:"rgba(0,0,0,0)",padding:this.options.showScale?0:this.options.barShowStroke?this.options.barStrokeWidth:0,showLabels:this.options.scaleShowLabels,display:this.options.showScale};this.options.scaleOverride&&e.extend(n,{calculateYRange:e.noop,steps:this.options.scaleSteps,stepValue:this.options.scaleStepWidth,min:this.options.scaleStartValue,max:this.options.scaleStartValue+this.options.scaleSteps*this.options.scaleStepWidth}),this.scale=new this.ScaleClass(n)},addData:function(t,i){e.each(t,function(t,e){this.datasets[e].bars.push(new this.BarClass({value:t,label:i,x:this.scale.calculateBarX(this.datasets.length,e,this.scale.valuesCount+1),y:this.scale.endPoint,width:this.scale.calculateBarWidth(this.datasets.length),base:this.scale.endPoint,strokeColor:this.datasets[e].strokeColor,fillColor:this.datasets[e].fillColor}))
},this),this.scale.addXLabel(i),this.update()},removeData:function(){this.scale.removeXLabel(),e.each(this.datasets,function(t){t.bars.shift()},this),this.update()},reflow:function(){e.extend(this.BarClass.prototype,{y:this.scale.endPoint,base:this.scale.endPoint});var t=e.extend({height:this.chart.height,width:this.chart.width});this.scale.update(t)},draw:function(t){var i=t||1;this.clear();this.chart.ctx;this.scale.draw(i),e.each(this.datasets,function(t,s){e.each(t.bars,function(t,e){t.hasValue()&&(t.base=this.scale.endPoint,t.transition({x:this.scale.calculateBarX(this.datasets.length,s,e),y:this.scale.calculateY(t.value),width:this.scale.calculateBarWidth(this.datasets.length)},i).draw())},this)},this)}})}.call(this),function(){"use strict";var t=this,i=t.Chart,e=i.helpers,s={segmentShowStroke:!0,segmentStrokeColor:"#fff",segmentStrokeWidth:2,percentageInnerCutout:50,animationSteps:100,animationEasing:"easeOutBounce",animateRotate:!0,animateScale:!1,legendTemplate:'<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<segments.length; i++){%><li><span style="background-color:<%=segments[i].fillColor%>"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>'};i.Type.extend({name:"Doughnut",defaults:s,initialize:function(t){this.segments=[],this.outerRadius=(e.min([this.chart.width,this.chart.height])-this.options.segmentStrokeWidth/2)/2,this.SegmentArc=i.Arc.extend({ctx:this.chart.ctx,x:this.chart.width/2,y:this.chart.height/2}),this.options.showTooltips&&e.bindEvents(this,this.options.tooltipEvents,function(t){var i="mouseout"!==t.type?this.getSegmentsAtEvent(t):[];e.each(this.segments,function(t){t.restore(["fillColor"])}),e.each(i,function(t){t.fillColor=t.highlightColor}),this.showTooltip(i)}),this.calculateTotal(t),e.each(t,function(t,i){this.addData(t,i,!0)},this),this.render()},getSegmentsAtEvent:function(t){var i=[],s=e.getRelativePosition(t);return e.each(this.segments,function(t){t.inRange(s.x,s.y)&&i.push(t)},this),i},addData:function(t,i,e){var s=i||this.segments.length;this.segments.splice(s,0,new this.SegmentArc({value:t.value,outerRadius:this.options.animateScale?0:this.outerRadius,innerRadius:this.options.animateScale?0:this.outerRadius/100*this.options.percentageInnerCutout,fillColor:t.color,highlightColor:t.highlight||t.color,showStroke:this.options.segmentShowStroke,strokeWidth:this.options.segmentStrokeWidth,strokeColor:this.options.segmentStrokeColor,startAngle:1.5*Math.PI,circumference:this.options.animateRotate?0:this.calculateCircumference(t.value),label:t.label})),e||(this.reflow(),this.update())},calculateCircumference:function(t){return 2*Math.PI*(Math.abs(t)/this.total)},calculateTotal:function(t){this.total=0,e.each(t,function(t){this.total+=Math.abs(t.value)},this)},update:function(){this.calculateTotal(this.segments),e.each(this.activeElements,function(t){t.restore(["fillColor"])}),e.each(this.segments,function(t){t.save()}),this.render()},removeData:function(t){var i=e.isNumber(t)?t:this.segments.length-1;this.segments.splice(i,1),this.reflow(),this.update()},reflow:function(){e.extend(this.SegmentArc.prototype,{x:this.chart.width/2,y:this.chart.height/2}),this.outerRadius=(e.min([this.chart.width,this.chart.height])-this.options.segmentStrokeWidth/2)/2,e.each(this.segments,function(t){t.update({outerRadius:this.outerRadius,innerRadius:this.outerRadius/100*this.options.percentageInnerCutout})},this)},draw:function(t){var i=t?t:1;this.clear(),e.each(this.segments,function(t,e){t.transition({circumference:this.calculateCircumference(t.value),outerRadius:this.outerRadius,innerRadius:this.outerRadius/100*this.options.percentageInnerCutout},i),t.endAngle=t.startAngle+t.circumference,t.draw(),0===e&&(t.startAngle=1.5*Math.PI),e<this.segments.length-1&&(this.segments[e+1].startAngle=t.endAngle)},this)}}),i.types.Doughnut.extend({name:"Pie",defaults:e.merge(s,{percentageInnerCutout:0})})}.call(this),function(){"use strict";var t=this,i=t.Chart,e=i.helpers,s={scaleShowGridLines:!0,scaleGridLineColor:"rgba(0,0,0,.05)",scaleGridLineWidth:1,scaleShowHorizontalLines:!0,scaleShowVerticalLines:!0,bezierCurve:!0,bezierCurveTension:.4,pointDot:!0,pointDotRadius:4,pointDotStrokeWidth:1,pointHitDetectionRadius:20,datasetStroke:!0,datasetStrokeWidth:2,datasetFill:!0,legendTemplate:'<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].strokeColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'};i.Type.extend({name:"Line",defaults:s,initialize:function(t){this.PointClass=i.Point.extend({strokeWidth:this.options.pointDotStrokeWidth,radius:this.options.pointDotRadius,display:this.options.pointDot,hitDetectionRadius:this.options.pointHitDetectionRadius,ctx:this.chart.ctx,inRange:function(t){return Math.pow(t-this.x,2)<Math.pow(this.radius+this.hitDetectionRadius,2)}}),this.datasets=[],this.options.showTooltips&&e.bindEvents(this,this.options.tooltipEvents,function(t){var i="mouseout"!==t.type?this.getPointsAtEvent(t):[];this.eachPoints(function(t){t.restore(["fillColor","strokeColor"])}),e.each(i,function(t){t.fillColor=t.highlightFill,t.strokeColor=t.highlightStroke}),this.showTooltip(i)}),e.each(t.datasets,function(i){var s={label:i.label||null,fillColor:i.fillColor,strokeColor:i.strokeColor,pointColor:i.pointColor,pointStrokeColor:i.pointStrokeColor,points:[]};this.datasets.push(s),e.each(i.data,function(e,n){s.points.push(new this.PointClass({value:e,label:t.labels[n],datasetLabel:i.label,strokeColor:i.pointStrokeColor,fillColor:i.pointColor,highlightFill:i.pointHighlightFill||i.pointColor,highlightStroke:i.pointHighlightStroke||i.pointStrokeColor}))},this),this.buildScale(t.labels),this.eachPoints(function(t,i){e.extend(t,{x:this.scale.calculateX(i),y:this.scale.endPoint}),t.save()},this)},this),this.render()},update:function(){this.scale.update(),e.each(this.activeElements,function(t){t.restore(["fillColor","strokeColor"])}),this.eachPoints(function(t){t.save()}),this.render()},eachPoints:function(t){e.each(this.datasets,function(i){e.each(i.points,t,this)},this)},getPointsAtEvent:function(t){var i=[],s=e.getRelativePosition(t);return e.each(this.datasets,function(t){e.each(t.points,function(t){t.inRange(s.x,s.y)&&i.push(t)})},this),i},buildScale:function(t){var s=this,n=function(){var t=[];return s.eachPoints(function(i){t.push(i.value)}),t},o={templateString:this.options.scaleLabel,height:this.chart.height,width:this.chart.width,ctx:this.chart.ctx,textColor:this.options.scaleFontColor,fontSize:this.options.scaleFontSize,fontStyle:this.options.scaleFontStyle,fontFamily:this.options.scaleFontFamily,valuesCount:t.length,beginAtZero:this.options.scaleBeginAtZero,integersOnly:this.options.scaleIntegersOnly,calculateYRange:function(t){var i=e.calculateScaleRange(n(),t,this.fontSize,this.beginAtZero,this.integersOnly);e.extend(this,i)},xLabels:t,font:e.fontString(this.options.scaleFontSize,this.options.scaleFontStyle,this.options.scaleFontFamily),lineWidth:this.options.scaleLineWidth,lineColor:this.options.scaleLineColor,showHorizontalLines:this.options.scaleShowHorizontalLines,showVerticalLines:this.options.scaleShowVerticalLines,gridLineWidth:this.options.scaleShowGridLines?this.options.scaleGridLineWidth:0,gridLineColor:this.options.scaleShowGridLines?this.options.scaleGridLineColor:"rgba(0,0,0,0)",padding:this.options.showScale?0:this.options.pointDotRadius+this.options.pointDotStrokeWidth,showLabels:this.options.scaleShowLabels,display:this.options.showScale};this.options.scaleOverride&&e.extend(o,{calculateYRange:e.noop,steps:this.options.scaleSteps,stepValue:this.options.scaleStepWidth,min:this.options.scaleStartValue,max:this.options.scaleStartValue+this.options.scaleSteps*this.options.scaleStepWidth}),this.scale=new i.Scale(o)},addData:function(t,i){e.each(t,function(t,e){this.datasets[e].points.push(new this.PointClass({value:t,label:i,x:this.scale.calculateX(this.scale.valuesCount+1),y:this.scale.endPoint,strokeColor:this.datasets[e].pointStrokeColor,fillColor:this.datasets[e].pointColor}))},this),this.scale.addXLabel(i),this.update()},removeData:function(){this.scale.removeXLabel(),e.each(this.datasets,function(t){t.points.shift()},this),this.update()},reflow:function(){var t=e.extend({height:this.chart.height,width:this.chart.width});this.scale.update(t)},draw:function(t){var i=t||1;this.clear();var s=this.chart.ctx,n=function(t){return null!==t.value},o=function(t,i,s){return e.findNextWhere(i,n,s)||t},a=function(t,i,s){return e.findPreviousWhere(i,n,s)||t};this.scale.draw(i),e.each(this.datasets,function(t){var h=e.where(t.points,n);e.each(t.points,function(t,e){t.hasValue()&&t.transition({y:this.scale.calculateY(t.value),x:this.scale.calculateX(e)},i)},this),this.options.bezierCurve&&e.each(h,function(t,i){var s=i>0&&i<h.length-1?this.options.bezierCurveTension:0;t.controlPoints=e.splineCurve(a(t,h,i),t,o(t,h,i),s),t.controlPoints.outer.y>this.scale.endPoint?t.controlPoints.outer.y=this.scale.endPoint:t.controlPoints.outer.y<this.scale.startPoint&&(t.controlPoints.outer.y=this.scale.startPoint),t.controlPoints.inner.y>this.scale.endPoint?t.controlPoints.inner.y=this.scale.endPoint:t.controlPoints.inner.y<this.scale.startPoint&&(t.controlPoints.inner.y=this.scale.startPoint)},this),s.lineWidth=this.options.datasetStrokeWidth,s.strokeStyle=t.strokeColor,s.beginPath(),e.each(h,function(t,i){if(0===i)s.moveTo(t.x,t.y);else if(this.options.bezierCurve){var e=a(t,h,i);s.bezierCurveTo(e.controlPoints.outer.x,e.controlPoints.outer.y,t.controlPoints.inner.x,t.controlPoints.inner.y,t.x,t.y)}else s.lineTo(t.x,t.y)},this),s.stroke(),this.options.datasetFill&&h.length>0&&(s.lineTo(h[h.length-1].x,this.scale.endPoint),s.lineTo(h[0].x,this.scale.endPoint),s.fillStyle=t.fillColor,s.closePath(),s.fill()),e.each(h,function(t){t.draw()})},this)}})}.call(this),function(){"use strict";var t=this,i=t.Chart,e=i.helpers,s={scaleShowLabelBackdrop:!0,scaleBackdropColor:"rgba(255,255,255,0.75)",scaleBeginAtZero:!0,scaleBackdropPaddingY:2,scaleBackdropPaddingX:2,scaleShowLine:!0,segmentShowStroke:!0,segmentStrokeColor:"#fff",segmentStrokeWidth:2,animationSteps:100,animationEasing:"easeOutBounce",animateRotate:!0,animateScale:!1,legendTemplate:'<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<segments.length; i++){%><li><span style="background-color:<%=segments[i].fillColor%>"></span><%if(segments[i].label){%><%=segments[i].label%><%}%></li><%}%></ul>'};i.Type.extend({name:"PolarArea",defaults:s,initialize:function(t){this.segments=[],this.SegmentArc=i.Arc.extend({showStroke:this.options.segmentShowStroke,strokeWidth:this.options.segmentStrokeWidth,strokeColor:this.options.segmentStrokeColor,ctx:this.chart.ctx,innerRadius:0,x:this.chart.width/2,y:this.chart.height/2}),this.scale=new i.RadialScale({display:this.options.showScale,fontStyle:this.options.scaleFontStyle,fontSize:this.options.scaleFontSize,fontFamily:this.options.scaleFontFamily,fontColor:this.options.scaleFontColor,showLabels:this.options.scaleShowLabels,showLabelBackdrop:this.options.scaleShowLabelBackdrop,backdropColor:this.options.scaleBackdropColor,backdropPaddingY:this.options.scaleBackdropPaddingY,backdropPaddingX:this.options.scaleBackdropPaddingX,lineWidth:this.options.scaleShowLine?this.options.scaleLineWidth:0,lineColor:this.options.scaleLineColor,lineArc:!0,width:this.chart.width,height:this.chart.height,xCenter:this.chart.width/2,yCenter:this.chart.height/2,ctx:this.chart.ctx,templateString:this.options.scaleLabel,valuesCount:t.length}),this.updateScaleRange(t),this.scale.update(),e.each(t,function(t,i){this.addData(t,i,!0)},this),this.options.showTooltips&&e.bindEvents(this,this.options.tooltipEvents,function(t){var i="mouseout"!==t.type?this.getSegmentsAtEvent(t):[];e.each(this.segments,function(t){t.restore(["fillColor"])}),e.each(i,function(t){t.fillColor=t.highlightColor}),this.showTooltip(i)}),this.render()},getSegmentsAtEvent:function(t){var i=[],s=e.getRelativePosition(t);return e.each(this.segments,function(t){t.inRange(s.x,s.y)&&i.push(t)},this),i},addData:function(t,i,e){var s=i||this.segments.length;this.segments.splice(s,0,new this.SegmentArc({fillColor:t.color,highlightColor:t.highlight||t.color,label:t.label,value:t.value,outerRadius:this.options.animateScale?0:this.scale.calculateCenterOffset(t.value),circumference:this.options.animateRotate?0:this.scale.getCircumference(),startAngle:1.5*Math.PI})),e||(this.reflow(),this.update())},removeData:function(t){var i=e.isNumber(t)?t:this.segments.length-1;this.segments.splice(i,1),this.reflow(),this.update()},calculateTotal:function(t){this.total=0,e.each(t,function(t){this.total+=t.value},this),this.scale.valuesCount=this.segments.length},updateScaleRange:function(t){var i=[];e.each(t,function(t){i.push(t.value)});var s=this.options.scaleOverride?{steps:this.options.scaleSteps,stepValue:this.options.scaleStepWidth,min:this.options.scaleStartValue,max:this.options.scaleStartValue+this.options.scaleSteps*this.options.scaleStepWidth}:e.calculateScaleRange(i,e.min([this.chart.width,this.chart.height])/2,this.options.scaleFontSize,this.options.scaleBeginAtZero,this.options.scaleIntegersOnly);e.extend(this.scale,s,{size:e.min([this.chart.width,this.chart.height]),xCenter:this.chart.width/2,yCenter:this.chart.height/2})},update:function(){this.calculateTotal(this.segments),e.each(this.segments,function(t){t.save()}),this.reflow(),this.render()},reflow:function(){e.extend(this.SegmentArc.prototype,{x:this.chart.width/2,y:this.chart.height/2}),this.updateScaleRange(this.segments),this.scale.update(),e.extend(this.scale,{xCenter:this.chart.width/2,yCenter:this.chart.height/2}),e.each(this.segments,function(t){t.update({outerRadius:this.scale.calculateCenterOffset(t.value)})},this)},draw:function(t){var i=t||1;this.clear(),e.each(this.segments,function(t,e){t.transition({circumference:this.scale.getCircumference(),outerRadius:this.scale.calculateCenterOffset(t.value)},i),t.endAngle=t.startAngle+t.circumference,0===e&&(t.startAngle=1.5*Math.PI),e<this.segments.length-1&&(this.segments[e+1].startAngle=t.endAngle),t.draw()},this),this.scale.draw()}})}.call(this),function(){"use strict";var t=this,i=t.Chart,e=i.helpers;i.Type.extend({name:"Radar",defaults:{scaleShowLine:!0,angleShowLineOut:!0,scaleShowLabels:!1,scaleBeginAtZero:!0,angleLineColor:"rgba(0,0,0,.1)",angleLineWidth:1,pointLabelFontFamily:"'Arial'",pointLabelFontStyle:"normal",pointLabelFontSize:10,pointLabelFontColor:"#666",pointDot:!0,pointDotRadius:3,pointDotStrokeWidth:1,pointHitDetectionRadius:20,datasetStroke:!0,datasetStrokeWidth:2,datasetFill:!0,legendTemplate:'<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].strokeColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>'},initialize:function(t){this.PointClass=i.Point.extend({strokeWidth:this.options.pointDotStrokeWidth,radius:this.options.pointDotRadius,display:this.options.pointDot,hitDetectionRadius:this.options.pointHitDetectionRadius,ctx:this.chart.ctx}),this.datasets=[],this.buildScale(t),this.options.showTooltips&&e.bindEvents(this,this.options.tooltipEvents,function(t){var i="mouseout"!==t.type?this.getPointsAtEvent(t):[];this.eachPoints(function(t){t.restore(["fillColor","strokeColor"])}),e.each(i,function(t){t.fillColor=t.highlightFill,t.strokeColor=t.highlightStroke}),this.showTooltip(i)}),e.each(t.datasets,function(i){var s={label:i.label||null,fillColor:i.fillColor,strokeColor:i.strokeColor,pointColor:i.pointColor,pointStrokeColor:i.pointStrokeColor,points:[]};this.datasets.push(s),e.each(i.data,function(e,n){var o;this.scale.animation||(o=this.scale.getPointPosition(n,this.scale.calculateCenterOffset(e))),s.points.push(new this.PointClass({value:e,label:t.labels[n],datasetLabel:i.label,x:this.options.animation?this.scale.xCenter:o.x,y:this.options.animation?this.scale.yCenter:o.y,strokeColor:i.pointStrokeColor,fillColor:i.pointColor,highlightFill:i.pointHighlightFill||i.pointColor,highlightStroke:i.pointHighlightStroke||i.pointStrokeColor}))},this)},this),this.render()},eachPoints:function(t){e.each(this.datasets,function(i){e.each(i.points,t,this)},this)},getPointsAtEvent:function(t){var i=e.getRelativePosition(t),s=e.getAngleFromPoint({x:this.scale.xCenter,y:this.scale.yCenter},i),n=2*Math.PI/this.scale.valuesCount,o=Math.round((s.angle-1.5*Math.PI)/n),a=[];return(o>=this.scale.valuesCount||0>o)&&(o=0),s.distance<=this.scale.drawingArea&&e.each(this.datasets,function(t){a.push(t.points[o])}),a},buildScale:function(t){this.scale=new i.RadialScale({display:this.options.showScale,fontStyle:this.options.scaleFontStyle,fontSize:this.options.scaleFontSize,fontFamily:this.options.scaleFontFamily,fontColor:this.options.scaleFontColor,showLabels:this.options.scaleShowLabels,showLabelBackdrop:this.options.scaleShowLabelBackdrop,backdropColor:this.options.scaleBackdropColor,backdropPaddingY:this.options.scaleBackdropPaddingY,backdropPaddingX:this.options.scaleBackdropPaddingX,lineWidth:this.options.scaleShowLine?this.options.scaleLineWidth:0,lineColor:this.options.scaleLineColor,angleLineColor:this.options.angleLineColor,angleLineWidth:this.options.angleShowLineOut?this.options.angleLineWidth:0,pointLabelFontColor:this.options.pointLabelFontColor,pointLabelFontSize:this.options.pointLabelFontSize,pointLabelFontFamily:this.options.pointLabelFontFamily,pointLabelFontStyle:this.options.pointLabelFontStyle,height:this.chart.height,width:this.chart.width,xCenter:this.chart.width/2,yCenter:this.chart.height/2,ctx:this.chart.ctx,templateString:this.options.scaleLabel,labels:t.labels,valuesCount:t.datasets[0].data.length}),this.scale.setScaleSize(),this.updateScaleRange(t.datasets),this.scale.buildYLabels()},updateScaleRange:function(t){var i=function(){var i=[];return e.each(t,function(t){t.data?i=i.concat(t.data):e.each(t.points,function(t){i.push(t.value)})}),i}(),s=this.options.scaleOverride?{steps:this.options.scaleSteps,stepValue:this.options.scaleStepWidth,min:this.options.scaleStartValue,max:this.options.scaleStartValue+this.options.scaleSteps*this.options.scaleStepWidth}:e.calculateScaleRange(i,e.min([this.chart.width,this.chart.height])/2,this.options.scaleFontSize,this.options.scaleBeginAtZero,this.options.scaleIntegersOnly);e.extend(this.scale,s)},addData:function(t,i){this.scale.valuesCount++,e.each(t,function(t,e){var s=this.scale.getPointPosition(this.scale.valuesCount,this.scale.calculateCenterOffset(t));this.datasets[e].points.push(new this.PointClass({value:t,label:i,x:s.x,y:s.y,strokeColor:this.datasets[e].pointStrokeColor,fillColor:this.datasets[e].pointColor}))},this),this.scale.labels.push(i),this.reflow(),this.update()},removeData:function(){this.scale.valuesCount--,this.scale.labels.shift(),e.each(this.datasets,function(t){t.points.shift()},this),this.reflow(),this.update()},update:function(){this.eachPoints(function(t){t.save()}),this.reflow(),this.render()},reflow:function(){e.extend(this.scale,{width:this.chart.width,height:this.chart.height,size:e.min([this.chart.width,this.chart.height]),xCenter:this.chart.width/2,yCenter:this.chart.height/2}),this.updateScaleRange(this.datasets),this.scale.setScaleSize(),this.scale.buildYLabels()},draw:function(t){var i=t||1,s=this.chart.ctx;this.clear(),this.scale.draw(),e.each(this.datasets,function(t){e.each(t.points,function(t,e){t.hasValue()&&t.transition(this.scale.getPointPosition(e,this.scale.calculateCenterOffset(t.value)),i)},this),s.lineWidth=this.options.datasetStrokeWidth,s.strokeStyle=t.strokeColor,s.beginPath(),e.each(t.points,function(t,i){0===i?s.moveTo(t.x,t.y):s.lineTo(t.x,t.y)},this),s.closePath(),s.stroke(),s.fillStyle=t.fillColor,s.fill(),e.each(t.points,function(t){t.hasValue()&&t.draw()})},this)}})}.call(this);