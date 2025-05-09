																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																								<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>
<%
	String code = request.getParameter("code");
	String message = request.getParameter("message");
	
	//String attr_code =    request.getAttribute("code");
	//String attr_message = request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ISU System</title>
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js"></script>
<link rel="stylesheet" href="/common/css/contents.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script type="text/javascript">
$(function(){
	var code = "${code}";
	if(parent.opener){
		if(code == "905"){
			alert("<msg:txt mid='109335' mdef='세션이 만료 되었습니다.'/>");
			self.close();
			redirect("/Login.do");
		}else if(code == "992"){

			$("#title").html(code);
			var contents = "";
			contents +="<br/>Code      : ${code}";
			contents +="<br/>Message : ${message}";
			$("#contents").html(contents);
			$("#error_main").show();
			
		}else{
			$("#title").html(code);
			var contents = "";
			contents +="<br/>Code      : ${requestScope['javax.servlet.error.status_code']}";
			contents +="<br/>Exception_type : ${requestScope['javax.servlet.error.exception_type']}";
			contents +="<br/>Message : ${requestScope['javax.servlet.error.message']}";
			contents +="<br/>Exception : ${requestScope['javax.servlet.error.exception']}";
			contents +="<br/>Request_uri : ${requestScope['javax.servlet.error.request_uri']}";

			contents +="관리자에게 문의바랍니다.";
			$("#contents").html(contents);
			$("#error_main").show();
			//redirect("/Main.do");
		}
	}else{
		if(code == "905"){
			alert("<msg:txt mid='109335' mdef='세션이 만료 되었습니다.'/>");
			redirect("/Login.do");
		}else if(code == "906"){
			redirect("/Main.do");
			
		}else if(code == "992"){
			$("#title").html(code);
			var contents = "";
			contents +="<br/>Code      : ${code}";
			contents +="<br/>Message : ${message}";
			$("#contents").html(contents);
			$("#error_main").show();
			
		}else{
			$("#title").html(code);
			var contents = "";
			//contents +="<br/>Message : ${message}";
			//contents +="<br/>Request_uri : ${requestScope['javax.servlet.error.request_uri']}";
			contents +="<br/>Code      : ${requestScope['javax.servlet.error.status_code']}";
			contents +="<br/>Exception_type : ${requestScope['javax.servlet.error.exception_type']}";
			contents +="<br/>Message : ${requestScope['javax.servlet.error.message']}";
			contents +="<br/>Exception : ${requestScope['javax.servlet.error.exception']}";
			contents +="<br/>Request_uri : ${requestScope['javax.servlet.error.request_uri']}";

			contents +="관리자에게 문의바랍니다.";
			$("#contents").html(contents);
			$("#error_main").show();
		}
	}

		var result = "";

		$.each(jQuery.browser, function(i, val) {
				result += i + ":" + val + "\n";
		});

		//result = result +"<br/>"+ document.referrer;



	// 로그아웃 클릭 이벤트
	$("#logout").click(function(){
		var url = "/logoutUser.do";
		$(location).attr('href',url);
	});

	$("#userInfo").html(result);

});

/*IE에선 location.href로 이동시 이동한 페이지에서 Referer 정보를 확인하면 이동 전 페이지의 URL이 노출되지 않는다*/
function redirect(url) {
	if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
		var referLink = document.createElement('a');
		referLink.href = url;
		document.body.appendChild(referLink);
		referLink.click();
	} else {
		$(location).attr('href',url);
	}
}

/*
msie = parseInt((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1]);
if (isNaN(msie)) {
	msie = parseInt((/trident\/.*; rv:(\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1]);
}
*/

</script>
<body>
<div id="error_main" class="error_main" style="display:none">
	<div class="body">
		<div id="header" class="header">Information <span></span></div>
		<div id="title"  class="title"></div>
		<div id="contents"  class="contents"></div>
		<div id="userInfo"  class="userInfo"></div>

		<!--
		<div>
			IE7 에서는 정상적으로 작동하지 않을 수 있으니 IE 8 이상을 권장합니다.<br />
			반복적으로 에러화면이 보일경우  "<a id="logout"><tit:txt mid='114568' mdef='로그아웃'/></a>" 을 클릭하여 제접속 하시기 바랍니다.<br />
			사용자 컴퓨터 정보 <div id="contents"  class="contents"></div>
		</div>
		-->
		<div class="bottom">
			<b><!--  문의처 도수진과장--></b><br />
<!--  			02 - 2030 -  0387	-->
		</div>
	</div>
</div>
</body>
</html>
