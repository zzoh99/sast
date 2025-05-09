<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가차수반영비율</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
//선택된 탭
var newIframe;
var oldIframe;
var iframeIdx;

	$(function() {

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명

		$("#searchAppraisalCd").html(famList[2]); //평가명
		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		//탭 높이 변경
		function setIframeHeight() {
		    var iframeTop = $("#tabs ul.tab_bottom").height() + 10;
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		}

		// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
		showIframe();
	});


	function showIframe() {

		if($("#searchAppraisalCd").val() == ""){
			hideIframe();
			return;
		}

		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.jsp");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/View.do?cmd=viewAppElementMgrTab1"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/View.do?cmd=viewAppElementMgrTab2"+"&authPg=${authPg}");
		}
	}

	function hideIframe(){
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		}
	}

</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:showIframe();">
							</select>
						</td>
						<td>
							<a href="javascript:showIframe()" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="innertab inner" style="height:100%;">
		<div id="tabs" class="tab">
			<ul  class="tab_bottom">
				<li><a href="#tabs-1" >평가방법</a></li>
                <li><a href="#tabs-2" >평가SHEET</a></li>
			</ul>
			<div id="tabs-1">
				<div  class='layout_tabs' style="bottom:70px"><iframe id="tab1" name="tab1" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs' style="bottom:70px"><iframe id="tab2" name="tab2" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
		</div>
	</div>
</div>
</body>
</html>