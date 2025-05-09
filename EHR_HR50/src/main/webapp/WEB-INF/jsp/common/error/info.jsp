<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="com.hr.common.language.Language"%>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags" 		prefix="spring" %>
<%-- <%@ taglib uri="http://www.springframework.org/tags/form" 	prefix="form" %> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" 			prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" 	prefix="fn" %>
<%-- <c:set var="msgCode" value="security.error.code.${code}"/> --%>

<%

String enterCd = (String) session.getAttribute("ssnEnterCd");
String localeCd = (String) session.getAttribute("ssnLocaleCd");

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

String code = request.getParameter("code");
String defaultMsg = "";
if("905".equals(code)) {
	defaultMsg = "세션이 만료 되었습니다.";
}else if("991".equals(code)) {
	defaultMsg = "세션이 만료 되었습니다.(세션 변조)";
}else if("992".equals(code)) {
	defaultMsg = "중복 로그인으로 세션이 만료 되었습니다.";
}else if("993".equals(code)) {
	defaultMsg = "세션이 만료 되었습니다.(파라미터 변조)";
}else if("994".equals(code)) {
	defaultMsg = "세션이 만료 되었습니다.(권한 없는 화면 접근)";
}else if("995".equals(code)) {
	defaultMsg = "세션이 만료 되었습니다.(강제URL 접근)";
}else if("998".equals(code)) {
	defaultMsg = "알수없는 에러가 발생하였습니다.";
}else if("999".equals(code)) {
	defaultMsg = "잘못된 접근입니다.";
} else {
	defaultMsg = "잘못된 접근입니다.";
}

WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
Language language = (Language) webAppCtxt.getBean("Language");

request.setAttribute("message", language.getMessage("security.error.code." + code, null, defaultMsg, null, localeCd, enterCd));
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>오류안내</title>
<!-- FONT PRELOAD -->
<link rel="preload" href="/assets/fonts/google_icons/MaterialIcons-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
<link rel="preload" href="/assets/fonts/google_icons/MaterialIconsOutlined-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
<link rel="preload" href="/assets/fonts/font.css" as="style">
<!--   STYLE START	 -->
<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js"></script>
<link rel="stylesheet" href="/common/css/contents.css" />
<!-- <link rel="stylesheet" href="/common/plugin/Login/css/site.css" /> -->

<script type="text/javascript">
var limit = 10;

$(function(){
	var code = "${code}";
	var message = "${message}";

	var icode = parseInt(code);
	if(code != "" && ( icode == 905 || icode >= 991 )  ){ //세션 만료

		if( top.opener != null && top.opener != undefined ){ //팝업 여부
			top.opener.moveInfoPage("${code}");
			top.close();
		}

		if( window.dialogArguments != undefined  ){ //모달 팝업이면
			window.returnValue = "{\"securityKey\":\"Security\", \"code\":"+code+"}";
			window.close();
		}

		//if(parent.frames.length > 0 ){ //현재페이지가 top이 아니라는 의미임.

		if(window.parent.frames.length > 0 ){ //현재페이지가 top이 아니라는 의미임.
			top.location.replace("/Info.do?code=${code}");
		}

		$("#title").html(code);
		var contents = "";
		contents +="<br/>Code      : ${code}";
		contents +="<br/>Message : "+message;
		contents +="<br/><br/><br/><span id='limit_sec'>"+limit+"</span>초 후 로그인화면으로 이동합니다.";
		contents +="<br/><br/><b><a href=\"#\" id=\"goLogin\"><tit:txt mid='103879' mdef='[ 바로 이동 ]'/></a></b>";
		$("#contents").html(contents);
		$("#error_main").show();

		chechRefreshTime();

	}else{
		$("#title").html(code);
		var contents = "";



		contents +="<br/>Code      : ${requestScope['javax.servlet.error.status_code']}";
		<%--contents +="<br/>Exception_type : ${requestScope['javax.servlet.error.exception_type']}";--%>
		<%--contents +="<br/>Message : ${requestScope['javax.servlet.error.message']}";--%>
		<%--contents +="<br/>Exception : ${requestScope['javax.servlet.error.exception']}";--%>
		contents +="<br/>Request_uri : ${requestScope['javax.servlet.error.request_uri']}";

		contents +="<br/><br/>관리자에게 문의바랍니다.";
		$("#contents").html(contents);
		$("#error_main").show();
	}


	// 로그아웃 클릭 이벤트
	$("#goLogin").click(function(){
		var url = "/Login.do";
		$(location).attr('href',url);
	});

	var result = "";
	$.each(jQuery.browser, function(i, val) {
			result += i + ":" + val + "\n";
	});
	$("#userInfo").html(result);

});
function chechRefreshTime(){
	if( limit > 0 ){
		$("#limit_sec").html(limit);
		setTimeout("chechRefreshTime()",1100);
	}else{
		var url = "/Login.do";
		$(location).attr('href',url);
	}
	limit -= 1;
}

function goLogin() {
	var url = "/Login.do";
	$(location).attr('href',url);
}

</script>
<body>
<div id="error_main" class="error-page" style="display:none;">
	<div class="error-page clearfix">
        <div class="img-wrap float-left">
        	<img src="/assets/images/error.png" alt="error 안내">
        </div>
        <div class="text-wrap float-right">
            <p class="title"><strong>Sorry!</strong>서비스 접속이 원활하지 않습니다.</p>
            <div id="title"  class="title"></div>
			<div id="contents"  class="contents"></div>
			<div id="userInfo"  class="userInfo"></div>
            <div class="btn-wrap">
                <a href="/Login.do" id="goLoginBtn" class="btn outline"><i class="mdi-ico">exit_to_app</i><c:out value="로그인페이지로 이동"/></a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
