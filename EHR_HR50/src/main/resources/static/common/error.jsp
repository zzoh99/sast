<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" 		prefix="spring" %>
<%-- <%@ taglib uri="http://www.springframework.org/tags/form" 	prefix="form" %> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" 			prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" 	prefix="fn" %>
<%//@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>ERROR</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<link rel="stylesheet" href="/common/blue/css/style.css" />
<script type="text/javascript">

	$(function(){
		
		$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_${ssnEnterCd}.ico' />");
		$(document).attr("title","${ssnEnterNm} ${ssnAlias}");
		
		//alert(location.href);
		if( window.dialogArguments != undefined ) {
			
			//self.close();
	        //dialogArguments.parent.location.href
	        //return;
	    }
	     else {
	        
	        //dialogArguments.parent.location.href
	    }		
		
		$("#title").html("${requestScope['javax.servlet.error.status_code']}:"+" 잘못된 주소 입니다. <br/>확인후 다시 시도 하십시오.");
		
		var contents = "";
		contents +="<br/>Message : ${requestScope['javax.servlet.error.message']}";
		contents +="<br/>Request_uri : ${requestScope['javax.servlet.error.request_uri']}";
		contents +="<br/>관리자에게 문의바랍니다.";
		$("#contents").html(contents);
		$("#error_main").show();
		
		/*
		var chargeNmInfo = ajaxCall("${ctx}/getErrorChargeInfo.do", "gubun=1", false);

		if (chargeNmInfo != null && chargeNmInfo["Map"] != null) {
			chargeNmInfo["Map"].
		} 
		*/
		$.ajax({
			url 		: "${ctx}/getErrorChargeInfo.do",
			type 		: "post",
			dataType 	: "json",
			async 		: false,
			data 		: "",
			success : function(rv) {
				var list = rv.DATA;
				var tmp = "<p><b>문의처&nbsp; : &nbsp;</b>#DATA1#</p><br><p><b>사내전화&nbsp; : &nbsp;</b>#DATA2#</p>";
				var str = "";
				for(var i=0; i<list.length; i++){
					str = tmp.replace(/#DATA1#/g,list[i].name)
					         .replace(/#DATA2#/g,list[i].officeTel);
				}
				if(str=="") str= "<p></p><p></p>";
				
				$("#chargeInfo").html(str);
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

		$(window).resize(function() {setErrorSize();});
		setErrorSize();
	});
	
	function setErrorSize() {
		if( $(window).width() > 980 ) $("#error_main").addClass("min");
		else $("#error_main").removeClass("min");
	}
</script>
<body>
<div id="error_main" class="error_main" style="display:none">
	<div class="body">
		<div class="bg"></div>
		<div class="content">
			<div id="header" class="header">Information<span></span></div>
			<div id="title"  class="title"></div>
			
			<br /><br /><br />
			<div class="bottom">
				<!--  
				<b>문의처&nbsp;&nbsp;<span id="chargeNm"></span></b><br /><br /><br />
				<span id="tel"></span>
				-->
				<span id="chargeInfo"></span>
			</div>
		</div>
	</div>
</div>
</body>
</html>

  