<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.hr.common.language.Language"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%
String enterCd = (String) session.getAttribute("ssnEnterCd");
String localeCd = (String) session.getAttribute("ssnLocaleCd");
String ssnLangUseYn = (String) session.getAttribute("ssnLangUseYn");

String jRSAModulus  = (String) session.getAttribute("RSAModulus");
String jRSAExponent = (String) session.getAttribute("RSAExponent");


//if(enterCd == null || "".equals(enterCd) || "".equals(localeCd) || "".equals(localeCd)) {
//	Cookie[] cookies = request.getCookies();
//
//	if(cookies != null) {
//		for(Cookie cookie : cookies) {
//			String name = cookie.getName();
//
//			if("enterCd".equals(name)) {
//				enterCd = cookie.getValue();
//			} else if("localeCd".equals(name)) {
//				localeCd = cookie.getValue();
//			}
//		}
//	}
//}

//다국어 사용여부에 따라..  2019.12.27 jylee
if( localeCd != null && !"".equals(localeCd) && ssnLangUseYn != null && ssnLangUseYn.equals("1")){

	WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
	Language language = (Language) webAppCtxt.getBean("Language");
	
	request.setAttribute("ajax_status_0", language.getMessage("ajax.exception.status.0", null, "오랫동안 사용되지 않아 초기화면으로 이동합니다.", null, localeCd, enterCd));
	request.setAttribute("ajax_status_404", language.getMessage("ajax.exception.status.404", null, "페이지를 찾을수없습니다.", null, localeCd, enterCd));
	request.setAttribute("ajax_status_500", language.getMessage("ajax.exception.status.500", null, "서버에러가 발생하였습니다.", null, localeCd, enterCd));
	request.setAttribute("ajax_thrownError_parsererror", language.getMessage("ajax.exception.thrownError.parsererror", null, "json 응답 메시지를 분석할수 없습니다.", null, localeCd, enterCd));
	request.setAttribute("ajax_thrownError_timeout", language.getMessage("ajax.exception.thrownError.timeout", null, "시간을 초과하였습니다.", null, localeCd, enterCd));
	request.setAttribute("ajax_else", language.getMessage("ajax.exception.else", null, "알수없는 에러가 발생하였습니다.", null, localeCd, enterCd));
}else{
	request.setAttribute("ajax_status_0", "오랫동안 사용되지 않아 초기화면으로 이동합니다.");
	request.setAttribute("ajax_status_404", "페이지를 찾을수없습니다.");
	request.setAttribute("ajax_status_500", "서버에러가 발생하였습니다.");
	request.setAttribute("ajax_thrownError_parsererror", "json 응답 메시지를 분석할수 없습니다.");
	request.setAttribute("ajax_thrownError_timeout", "시간을 초과하였습니다.");
	request.setAttribute("ajax_else", "알수없는 에러가 발생하였습니다.");
}


%>
<script type="text/javascript">
$(function()  {
  	//$(document).keypress(function(e) {if (e.keyCode == 13) return false; });

	// textarea tag에서 enter key 허용하도록 처리.
	$(document).keypress(function(e) {
		e = e || event;
		let tag = e.srcElement ? e.srcElement.tagName : e.target.nodeName;

		if (e.keyCode == 13) {
			// TEXTARAE 인 경우 enter key 허용
			if (tag.toUpperCase() == "TEXTAREA") {
				return true;
			} else {
				return false;
			}
		}
	});
  <%--
  $.extend($.validator.messages, {
      required: function(element,input) {
        var vtxt =  $(input).attr("vtxt");
        if(vtxt != "undefined" && vtxt != ""){
          return vtxt+"<fmt:message key='jquery.valdate.required.existid'/>" ;
        }else{
          return "<fmt:message key='jquery.valdate.required.noneid'/>";
        }
      },
      remote:     "<fmt:message key='jquery.valdate.remote'/>",
      email:       "<fmt:message key='jquery.valdate.email'/>",
      url:       "<fmt:message key='jquery.valdate.url'/>",
      date:       "<fmt:message key='jquery.valdate.date'/>",
      dateISO:     "<fmt:message key='jquery.valdate.dateISO'/>",
      number:     "<fmt:message key='jquery.valdate.number'/>",
      digits:     "<fmt:message key='jquery.valdate.digits'/>",
      creditcard:   "<fmt:message key='jquery.valdate.creditcard'/>",
      equalTo:     "<fmt:message key='jquery.valdate.equalTo'/>",
      accept:     "<fmt:message key='jquery.valdate.accept'/>",
      maxlength: $.validator.format("<fmt:message key='jquery.valdate.maxlength'/>"),
      minlength: $.validator.format("<fmt:message key='jquery.valdate.minlength'/>"),
      rangelength: $.validator.format("<fmt:message key='jquery.valdate.rangelength'/>"),
      range: $.validator.format("<fmt:message key='jquery.valdate.range'/>"),
      max: $.validator.format("<fmt:message key='jquery.valdate.max'/>"),
      min: $.validator.format("<fmt:message key='jquery.valdate.min'/>")
  });
  --%>
  $("body").append("<input type='hidden' id='_theme' value='${theme}'>");
});

function ajaxJsonErrorAlert(jqXHR, textStatus, thrownError){
	if(jqXHR.status == "905"){
		if(opener != null){
			self.close();
			opener.window.top.location.replace("/Info.do?code=905");
		}else{
			window.top.location.replace("/Info.do?code=905");
		}
	}else if(jqXHR.status	==0){
		alert("${ajax_status_0}");
		top.location.href="/";
	}else if(jqXHR.status	==404){ 			alert("${ajax_status_404}");
	}else if(jqXHR.status	==500){ 			alert("${ajax_status_500}");
	}else if(thrownError	=='parsererror'){ 	alert("${ajax_thrownError_parsererror}");
	}else if(thrownError	=='timeout'){ 		alert("${ajax_thrownError_timeout}");
	}else {
        if(jqXHR.status!=200){
        	alert(jqXHR.status +":  ${ajax_else}");
        }
        else{
        	top.location.replace("/Info.do?code=905");
        }

	}

	//network Error 12029 error UnKnown
}
</script>

<script>
var comBtnAuthPg = ("${authPg}"=="") ? "R" : "${authPg}";
$(function() {
  (comBtnAuthPg =="A") ? $(".authA,.authR").removeClass("authA").removeClass("authR"):$(".authR").removeClass("authR");
});




var testSubUrl = "";
var testRsaUrl = "";
var trsaUrl = "";
var tsubUrl = "";
$(function() {
	if(parent.$("#surl").length > 0) {
		var rsa = new RSAKey();
		rsa.setPublic("<%=jRSAModulus%>", "<%=jRSAExponent%>");

		trsaUrl = rsa.encrypt('${tUrl}')
		tsubUrl = parent.$("#surl").val();

	}

	//if(location.href.indexOf("?") >0){

		if(typeof tsubUrl != "undefined") {
			testSubUrl = tsubUrl ;
		} else {

			if(opener != null && typeof opener.testSubUrl != "undefined") {
				testSubUrl = opener.testSubUrl;
			}
			else {
				if(parent != null && typeof parent.testSubUrl != "undefined") {
					testSubUrl = parent.testSubUrl;
				}
			}
		}

		if(typeof trsaUrl != "undefined") {

			testRsaUrl = trsaUrl;
		} else {

			if(opener != null && typeof opener.testRsaUrl != "undefined") {
				testRsaUrl = opener.testRsaUrl;
			}
			 else {
				if(parent != null && typeof parent.testRsaUrl != "undefined") {
					testRsaUrl = parent.testRsaUrl;
				}
			}
		}

		$("#s_RSAURL").remove();
		$("#s_SUBURL").remove();
		$('<input/>').attr({type:'hidden',id:'s_RSAURL',name:'s_THISPG',value:testRsaUrl}).appendTo('form:eq(0)');
		$('<input/>').attr({type:'hidden',id:'s_SUBURL',name:'s_SUBURL',value:testSubUrl}).appendTo('form:eq(0)');
	//}
});



</script>
