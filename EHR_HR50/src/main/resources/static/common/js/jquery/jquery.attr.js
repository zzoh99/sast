jQuery.fn.extend({
	attr: function( name, value ) {
		if( typeof value != "undefined" &&  name == "src" && value.indexOf("common/hidden.jsp")== -1 &&(this.selector).indexOf("iframe") > -1 && value.indexOf("token=") == -1 ){
			return catchTabSubmitCall(this.selector, value);
		}
		return access( this, jQuery.attr, name, value, arguments.length > 1 );
	}
});

