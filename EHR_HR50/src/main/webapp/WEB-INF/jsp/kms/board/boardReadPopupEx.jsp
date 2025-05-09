<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		$(".close").click(function() {
			p.self.close();
		});

		submitCall($("#srchPopFrm"),"iFrame_popup","POST","${ctx}/Board.do?cmd=viewBoardRead");
		jQuery('#iFrame_popup').bind('load', function() { $('#iFrame_popup').contents().find('.btn').hide(); });
	});

	/*20200909 주석 처리
	function setCookie(name, value, expiredays ) {
		var todayDate = new Date();
		todayDate.setDate( todayDate.getDate() + expiredays );
		var seq_val = $("#bbsSeq").val();
		document.cookie = name + "_" + seq_val + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}
	*/

	//20200909 로직 추가
	//오늘하루 열지 않기 쿠키(00:00기준 하루)
	function setCookie(name, value, expiredays ) {
		var todayDate = new Date();
		    todayDate = new Date(parseInt(todayDate.getTime() / 86400000) * 86400000 + 54000000);

		if ( todayDate > new Date() )  {
			expiredays = expiredays - 1;
		}

		todayDate.setDate( todayDate.getDate() + expiredays );
		var seq_val = $("#bbsSeq").val();
		document.cookie = name + "_" + seq_val + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}

	function closeWin() {
		if ($("#popupChk").attr("checked")) {
			//202009 로직 수정
			//setCookie( "popup", "done" , 1);
			setCookie( "Notice", "done" , 1);
			p.self.close();
		}
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>${param.bbsNm}</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<iframe name="iFrame_popup" id="iFrame_popup" src="" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" style="width:100%;height:650px;"></iframe>

		<form id="srchPopFrm" name="srchPopFrm" >
			<input type=hidden id="bbsCd" name="bbsCd" value="${param.bbsCd}">
			<input type=hidden id="bbsSeq" name="bbsSeq" value="${param.bbsSeq}">
			<input type="checkbox" id="popupChk" name="popupChk" value="" onclick="javascript:closeWin()">&nbsp;하루동안 이창을 열지않음
		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
