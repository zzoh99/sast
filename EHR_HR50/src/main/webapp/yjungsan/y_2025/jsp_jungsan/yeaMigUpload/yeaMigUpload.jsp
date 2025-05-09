<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head><title>이관업로드관리</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%
String ssnGrpCd = (String)session.getAttribute("ssnGrpCd");
String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");

String reCalc = (request.getParameter("reCalc")==null) ? "" : removeXSS((String)request.getParameter("reCalc"), "1");
%>
<script type="text/javascript">

	var ssnGrpCd    = "<%=ssnGrpCd%>";
	var ssnEnterCd  = "<%=ssnEnterCd%>";

	var newIframe;
	var oldIframe;
	var iframeIdx;
	var tabObj;
	var scrollRange = 60;

	$(function() {
		$("#menuNm").val($(document).find("title").text());

		//기준년도 조회
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "");
		$("#searchAdjustType").html(adjustTypeList[2]);

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;
		newIframe.attr("src","<%=jspPath%>/yeaMigUpload/yeaMigInfoTab.jsp?authPg=<%=authPg%>&reCalc=<%=reCalc%>");
		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		function showIframe() {
			if (typeof oldIframe != 'undefined') {
				oldIframe.attr("src","<%=jspPath%>/common/hidden.jsp");
			}
			$("#useDiv").hide();
			if (iframeIdx == 0) {
				newIframe.attr("src","<%=jspPath%>/yeaMigUpload/yeaMigInfoTab.jsp?authPg=<%=authPg%>&reCalc=<%=reCalc%>");
			} else if (iframeIdx == 1) {
				newIframe.attr("src","<%=jspPath%>/yeaMigUpload/yeaMigCurWpTab.jsp?authPg=<%=authPg%>&reCalc=<%=reCalc%>");
				$("#searchWorkCd").val("A");
				$("#useDiv").show();
			} else if (iframeIdx == 2) {
				newIframe.attr("src","<%=jspPath%>/yeaMigUpload/yeaMigIncomeDdctTab.jsp?authPg=<%=authPg%>&reCalc=<%=reCalc%>");
			} else if (iframeIdx == 3) {
				newIframe.attr("src","<%=jspPath%>/yeaMigUpload/yeaMigTaxReductDdctTab.jsp?authPg=<%=authPg%>&reCalc=<%=reCalc%>");
			}
		}
		setIframeHeight();
	});

	//탭 높이 변경
	function setIframeHeight() {
		var iframeTop = $("#tabs ul").height() + 16;
		$(".layout_tabs").each(function() {
			$(this).css("top",iframeTop);
		});
	}

	function allTabSearch(){
		newIframe[0].contentWindow.doAction1('Search');
	}

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
 				allTabSearch();
			}
		});
	});

</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="mainForm" name="mainForm">
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		<input type="hidden" id="tNum" name="tNum" value="" />
			<div class="sheet_search outer">
				<table>
					<tr>
					    <td><span>년도</span>
							<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center" maxlength="4" style="width:35px"/>
						</td>
						<td>
							<span>업무구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:allTabSearch();" class="box"></select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td id="useDiv" style="display: none">
							<span>근무지 유형</span>
							<select id="searchWorkCd" name ="searchWorkCd" onChange="javascript:allTabSearch();" >
								<option value="A">현</option>
								<option value="B">종전1</option>
								<option value="C">종전2</option>
								<option value="D">납세조합</option>
							</select>
						</td>
						<td><a href="javascript:allTabSearch();" id="btnSearch" class="button">조회</a></td>
					</tr>
				</table>
			</div>
		</form>
		<div id="tabs" style="position:absolute;width:100%;top:50px;bottom:0">
			<ul>
				<li><a href="#tabs-1"><span id="tab1Title">기본정보</span></a></li>
				<li><a href="#tabs-2"><span id="tab2Title">현/종전근무지정보</span></a></li>
				<li><a href="#tabs-3"><span id="tab8Title">소득공제</span></a></li>
				<li><a href="#tabs-4"><span id="tab9Title">세액감면세액공제</span></a></li>
			</ul>
			<div id="tabs-1">
				<div class="layout_tabs"><iframe id="iframeTab1" src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-2">
				<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-3">
				<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
			<div id="tabs-4">
				<div class="layout_tabs"><iframe src="<%=jspPath%>/common/hidden.jsp" frameborder="0" class="tab_iframes"></iframe></div>
			</div>
		</div>
	</div>
</body>
<style type="text/css">
 td {padding-right: 5px;}
.ui-tabs .ui-tabs-nav li {
    list-style: none;
    float: left;
    position: relative;
    margin: 0 -1px 0 0;
    padding: 5px;
    padding-top: inherit;
    white-space: nowrap;
	background: #eef1f3;
    border: 1px solid #b8c6cc;
    border-bottom: 0px;
}
.ui-tabs-nav li.ui-tabs-active {
	background: white;
	white-space: nowrap;
}
</style>
</html>