<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>로그인메뉴관리팝업</title>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<head>
	<title>메인아이콘</title>
	<link rel="stylesheet" type="text/css" href="/common/css/main.css">
	<style>
		.main_icon_box { overflow: hidden; width: 720px; margin: 30px auto; padding-top: 1px; }
		.main_icon_box li { float: left; margin: -1px 0 0 -1px; width: 180px; height: 180px; background-color: #FFF; border: 1px solid #c7cacd; text-align: center; }
		.main_icon_box li:nth-child(4n + 1) { margin-left: 0; }
		.main_icon_box li p.icon { height: 150px; padding-top: 40px; }
		.main_icon_box li p.icon_input { border-top: 1px solid #c7cacd; height: 30px; line-height: 30px; }
		.btn_center { text-align: center; border: 1px solid #000l }	
		.btn_center>a { display: inline-block; width: 100px; height: 35px; line-height: 35px; background-color: #0072bc; color: #FFF; font-weight: bold; border-radius: 5px; }
	</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");

function chkVal(){
	
	if ( $("input[name=imgPath]").is(":checked") == true ){
		var rv = new Array();
		rv["imgPath"] = $(":input:radio[name=imgPath]:checked").val();
		p.popReturnValue(rv);
		p.window.close();
	}else{
		alert("선택된 이미지가 없습니다.");
		return;
	}
	
}

</script>
</head>
<body>
	<ul class="main_icon_box">
		<li>
			<p class="icon"><img src="/common/images/main/img02.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img02.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img03.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img03.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img05.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img05.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img06.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img06.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img07.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img07.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img08.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img08.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img09.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img09.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img10.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img10.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img11.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img11.gif"></p>
		</li>
		<li>
			<p class="icon"><img src="/common/images/main/img12.gif"></p>
			<p class="icon_input"><input type="radio" name="imgPath" value="/common/images/main/img12.gif"></p>
		</li>
	</ul>
	<div class="btn_center">
		<a href="javascript:chkVal();"><tit:txt mid='111914' mdef='선택'/></a>
	</div>
</body>
</html>
