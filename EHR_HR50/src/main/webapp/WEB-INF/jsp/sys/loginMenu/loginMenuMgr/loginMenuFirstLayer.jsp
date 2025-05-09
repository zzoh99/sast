<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>로그인메뉴관리팝업</title>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<head>
	<title>메인아이콘</title>
	<style>
		.main_icon_box { overflow: hidden; width: 774px; height: 600px; overflow: auto; margin: 30px auto 16px; padding-top: 1px; }
		.main_icon_box li { float: left; margin: -1px 0 0 -1px; width: 110px; height: 110px; background-color: #FFF; border: 1px solid #c7cacd; text-align: center; }
		.main_icon_box li:nth-child(even) { background-color: #f0f1f4; }
		.main_icon_box li:nth-child(7n + 1) { margin-left: 0; }
		.main_icon_box li p.icon { font-size: 35px; color: #333; height: 80px; line-height: 80px; }
		.main_icon_box li p.icon_input { border-top: 1px solid #c7cacd; height: 28px; line-height: 24px;}
		.main_icon_box li p.icon_input input[type="radio"]{ position:relative; width:16px; height:16px; border: 1px solid #9f9f9f; border-radius:50%; }

		/*.btn_center { text-align: center; }*/
		/*.btn_center>a { display: inline-block; width: 100px; height: 35px; line-height: 35px; background-color: #2570f8; color: #FFF; font-weight: bold; border-radius: 8px; }*/
	</style>
<script type="text/javascript">
var loginMenuFirstLayer = { id: 'loginMenuFirstLayer' };
$(function() {
	const modal = window.top.document.LayerModalUtility.getModal(loginMenuFirstLayer.id);
	var arg =  modal.parameters;

	// 라디오 버튼의 value 속성을 비교하여 해당 라디오 버튼 선택
	$('input[type="radio"]').each(function() {

		var value = $(this).val(); // 라디오 버튼의 value 속성 가져오기

		if (value === arg.imgPath) {
			$(this).prop('checked', true); // 해당 라디오 버튼 선택
		}
	});
})

function chkVal(){
	if ( $("input[name=imgPath]").is(":checked") == true ){
		var p = { imgPath: $(":input:radio[name=imgPath]:checked").val() };
		const modal = window.top.document.LayerModalUtility.getModal(loginMenuFirstLayer.id);
		modal.fire(loginMenuFirstLayer.id + 'Trigger', p).hide();
	} else{
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
	<div class="modal_footer">
		<a href="javascript:chkVal();" class="btn filled"><tit:txt mid='111914' mdef='선택'/></a>
	</div>
</body>
</html>
