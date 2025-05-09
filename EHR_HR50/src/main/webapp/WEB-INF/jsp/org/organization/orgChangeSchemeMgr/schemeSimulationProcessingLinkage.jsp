<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var p = eval("${popUpStatus}");
	var sdate1 = "${param.sdate}";
	var versionNm = "${param.versionNm}";
	
	$(function() {
	
	});
	
	// 시트 리사이즈
	function sheetResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;

		$(".ibsheet").each(function() {
			inner_height = getInnerHeight($(this));
			if ($(this).attr("fixed") == "false") {
				value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
				value -= 85;
				if (value < 100) value = 100;
				$(this).height(value);
			}
		});

		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
	
		<form id="mySheetForm" name="mySheetForm" >
			<input type="hidden" id="sdate" name="sdate" />
			<input type="hidden" id="versionNm" name="versionNm" />
			<input type="hidden" id="orgCd" name="orgCd" />
	
			<div class="popup_title bgGray" style="padding:15px 20px;">
				<span class="floatL f_red strong fa-lg">발령연계처리</span>
				&nbsp;
			</div>
			
			<div class="mat15" style="padding:0 20px;">

			</div>
			
		</form>
		
	</div>
</body>
</html>