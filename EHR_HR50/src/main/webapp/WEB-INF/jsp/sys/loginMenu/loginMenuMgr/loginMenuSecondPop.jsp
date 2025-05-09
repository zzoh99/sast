<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>로그인메뉴관리팝업</title>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp" %>
<head>
	<title>메인아이콘</title>
	<link rel="stylesheet" type="text/css" href="/common/css/main.css">
	<style>
		.main_icon_box { overflow: hidden; width: 790px; height: 600px; overflow: auto; margin: 30px auto; padding-top: 1px; }
		.main_icon_box li { float: left; margin: -1px 0 0 -1px; width: 110px; height: 110px; background-color: #FFF; border: 1px solid #c7cacd; text-align: center; }
		.main_icon_box li:nth-child(even) { background-color: #f0f1f4; }
		.main_icon_box li:nth-child(7n + 1) { margin-left: 0; }
		.main_icon_box li p.icon { font-size: 35px; color: #333; height: 80px; line-height: 80px; }
		.main_icon_box li p.icon_input { border-top: 1px solid #c7cacd; height: 30px; line-height: 30px; }
		.btn_center { text-align: center; border: 1px solid #000l }	
		.btn_center>a { display: inline-block; width: 100px; height: 35px; line-height: 35px; background-color: #0072bc; color: #FFF; font-weight: bold; border-radius: 5px; }
	</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");

function chkVal(){
	
	if ( $("input[name=imgClass]").is(":checked") == true ){
		var rv = new Array();
		rv["imgClass"] = $(":input:radio[name=imgClass]:checked").val();
		p.popReturnValue(rv);
		p.window.close();
	}else{
		alert("선택된 클래스가 없습니다.");
		return;
	}
	
}

</script>
</head>
<body>
	<ul class="main_icon_box">
		<li>
			<p class="icon"><i class="far fa-address-book"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-address-book"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-address-card"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-address-card"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-bars"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-bars"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-bell"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-bell"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-award"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-award"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-binoculars"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-binoculars"></p>
		</li>
		<li>
			<p class="icon"><i class="fab fa-black-tie"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fab fa-black-tie"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-book"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-book"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-book-open"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-book-open"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-book-reader"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-book-reader"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-bookmark"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-bookmark"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-briefcase"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-briefcase"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-building"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-building"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-business-time"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-business-time"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-calculator"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-calculator"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-calendar"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-calendar"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-calendar-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-calendar-alt"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-chalkboard"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-chalkboard"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-chalkboard-teacher"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-chalkboard-teacher"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-chart-bar"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-chart-bar"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-chart-line"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-chart-line"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-chart-pie"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-chart-pie"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-clipboard-check"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-clipboard-check"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-clock"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-clock"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-comment-dots"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-comment-dots"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-desktop"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-desktop"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-edit"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-edit"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-envelope"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-envelope"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-file"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-file"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-file-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-file-alt"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-flag"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-flag"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-folder"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-folder"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-grin"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-grin"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-heart"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-heart"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-history"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-history"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-id-badge"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-id-badge"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-image"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-image"></p>
		</li>
		<li>
			<p class="icon"><i class="fab fa-itunes-note"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fab fa-itunes-note"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-laptop"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-laptop"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-lightbulb"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-lightbulb"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-list-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-list-alt"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-map-marker-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-address-book"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-mobile-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-mobile-alt"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-pen-alt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-pen-alt"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-pen-nib"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-pen-nib"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-pen-square"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-pen-square"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-phone"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-phone"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-receipt"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-address-book"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-seedling"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-seedling"></p>
		</li>
		<li>
			<p class="icon"><i class="fab fa-sistrix"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fab fa-sistrix"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-sitemap"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-sitemap"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-star"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-star"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-street-view"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-street-view"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-thumbs-up"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-thumbs-up"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-tv"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-tv"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-umbrella"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-umbrella"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-volume-up"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-volume-up"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-user"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-user"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-check"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-check"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-clock"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-clock""></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-cog"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-cog"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-edit"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-edit"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-friends"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-friends"></p>
		</li>
		<li>
			<p class="icon"><i class="fas fa-user-circle"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="fas fa-user-circle"></p>
		</li>
		<li>
			<p class="icon"><i class="far fa-window-restore"></i></p>
			<p class="icon_input"><input type="radio" name="imgClass" value="far fa-window-restore"></p>
		</li>
	</ul>
	<div class="btn_center">
		<a href="javascript:chkVal();">선택</a>
	</div>
</body>
</html>
