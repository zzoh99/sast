<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>세율 및 과세표준 관리</title>
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
	
	 //Sheet Action
    var selectTab = "tab1";

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
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		}
		
		
     	// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
		showIframe();
	});
	
   
    
//     function doAction() {
//         switch (selectTab) {
//         case "tab1":      tab1.doAction('Search'); break;
//         case "tab2":      tab2.doAction('Search'); break;
//         }
//     }
    
	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");			
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/OrgAppmtMgr.do?cmd=viewOrgAppmtMgrTab1"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/OrgAppmtMgr.do?cmd=viewOrgAppmtMgrTab2"+"&authPg=${authPg}");
		} 
	}
    
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div >
        <div id="tabs" style="position:absolute;width:100%;top:0px;bottom:0">
            <ul class="tab_bottom">
                <li><a href="#tabs-1" onclick="javascript:showIframe()">조직변경</a></li>
                <li><a href="#tabs-2" onclick="javascript:showIframe()">조직이동</a></li>
            </ul>
            <div id="tabs-1">
                <div  class='layout_tabs'><iframe id="tab1" name="tab1" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'><iframe id="tab2" name="tab2" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>