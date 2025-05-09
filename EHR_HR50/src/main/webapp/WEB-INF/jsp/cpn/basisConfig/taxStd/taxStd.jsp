<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114123' mdef='세율 및 과세표준 관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<!-- 날짜 콤보 박스 생성을 위함 -->
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<!-- 날짜 콤보 박스 생성을 위함 -->

<script type="text/javascript">

	//선택된 탭
	var newIframe;
	var oldIframe;
	var iframeIdx;

	$(function() {

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
		    var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
		    var searchBarHeight = $("#mySheetForm").height();
		    var iframeHeight = $(".wrapper").height() - searchBarHeight;
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		    $(".wrapper .inner").each(function() {
		        $(this).css("height",iframeHeight);
		    });
		}

		$("#searchTaxRateNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction(); $(this).focus(); }
        });

        $("#searchYear").val("<%=DateUtil.getCurrentTime("yyyy")%>") ;

     	// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
		showIframe();
	});

    //Sheet Action
    var selectTab = "tab1";

    function doAction() {
        switch (selectTab) {
        case "tab1":      tab1.doAction('Search'); break;
        case "tab2":      tab2.doAction('Search'); break;
        }
    }

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/TaxStd.do?cmd=viewTaxTab1Std"+"&authPg=${authPg}");
			selectTab = "tab1";
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/TaxStd.do?cmd=viewTaxTab2Std"+"&authPg=${authPg}");
			selectTab = "tab2";
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113322' mdef='년도'/></th>
						<td>  <input id="searchYear" name="searchYear" type="text" class="text w50" maxlength="4"/> </td>
						<th><tit:txt mid='112365' mdef='세율명 '/> </th>
						<td>  <input id="searchTaxRateNm" name ="searchTaxRateNm" type="text" class="text" /> </td>
						<td> <a href="javascript:doAction()" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
        <div id="tabs">
            <ul class="tab_bottom">
                <li><btn:a href="#tabs-1" onclick="javascript:showIframe()" mid='110723' mdef="세율관리"/></li>
                <li><btn:a href="#tabs-2" onclick="javascript:showIframe()" mid='111480' mdef="과세표준"/></li>
            </ul>
            <div id="tabs-1">
                <div  class='layout_tabs'><iframe id="tab1" name="tab1" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'><iframe id="tab2" name="tab2" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
