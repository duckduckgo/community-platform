/*!
 * 'addPlaceholder' Plugin for jQuery
 *
 * @author Ilia Draznin
 * @link http://iliadraznin.com/2011/02/jquery-placeholder-plugin/
 * @created 19-02-2011
 * @updated 06-04-2011
 * @version 1.0.3
 *
 * Description:
 * jQuery plugin that adds "placeholder" functionality (like in Chrome) to browsers that 
 * don't support it natively (like Firefox 3.6 or lower, or IE naturally)
 * 
 * Usage:
 * $(selector).addPlaceholder(options);
 */
(function($){
	$.extend($.support, { placeholder: !!('placeholder' in document.createElement('input')) });

	$.fn.addPlaceholder = function(options){
		var settings = {
			'class': 'placeholder',
			'allowspaces': false,
			'dopass': true,
			'dotextarea': true,
			'checkafill': false
		};
		
		return this.each(function(){
			if ($.support.placeholder) return false;
			
			$.extend( settings, options );
			
			if ( !( this.tagName.toLowerCase()=='input' || (settings['dotextarea'] && this.tagName.toLowerCase()=='textarea') ) ) return true;
			
			var $this = $(this),
				ph = this.getAttribute('placeholder'),
				ispass = $this.is('input[type=password]');
			
			if (!ph) return true;
			
			if (settings['dopass'] && ispass) {
				passPlacehold($this, ph);
			}
			else if (!ispass) {
				inputPlacehold($this, ph)
			}
		});
		
		function inputPlacehold(el, ph) {
			if ( valueEmpty(el.val()) || el.val()==ph ) {
				el.val(ph);
				el.addClass(settings['class']);
			}
			
			el.focusin(function(){
				if (el.hasClass(settings['class'])) {
					el.removeClass(settings['class']);
					el.val('');
				}
			});
			el.focusout(function(){
				if ( valueEmpty(el.val()) ) {
					el.val(ph);
					el.addClass(settings['class']);
				}
			});
		}
		
		function passPlacehold(el, ph) {
			el.addClass(settings['class']);
			var span = $('<span/>',{
				'class': el.attr('class')+' '+settings['class'],
				text: ph,
				css: {
					border:		'none',
					cursor:		'text',
					background:	'transparent',
					position:	'absolute',
					top:		el.position().top,
					left:		el.position().left,
					lineHeight: el.height()+3+'px',
					paddingLeft:parseFloat(el.css('paddingLeft'))+2+'px'
				}
			}).insertAfter(el);
			
			el.focusin(function(){
				if (el.hasClass(settings['class'])) {
					span.hide();
					el.removeClass(settings['class']);
				}
			});
			el.focusout(function(){
				if ( valueEmpty(el.val()) ) {
					span.show();
					el.addClass(settings['class']);
				}
			});
			
			if (settings['checkafill']) {
				(function checkPass(){
					if (!valueEmpty(el.val()) && el.hasClass(settings['class'])) {
						el.focusin();
					}
					setTimeout(checkPass, 250);
				})();
			}
		}
		
		function valueEmpty( value ) {
			return settings['allowspaces'] ? value==='' : $.trim(value)==='';
		}
	};
})(jQuery);