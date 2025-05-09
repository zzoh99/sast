<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114494' mdef='복리후생급여항목코드 '/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var newIframe;
var oldIframe;
var oldIframe2;
var iframeIdx;

//Sheet Action
	$(function() {
		iframeIdx = 0;
		newIframe = $('#tabs-1 iframe');
		oldIframe = $('#tabs-2 iframe');
		
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
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/WelfPayItemMgr.do?cmd=viewWelfPayItemMgrTab1"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/WelfPayItemMgr.do?cmd=viewWelfPayItemMgrTab2"+"&authPg=${authPg}");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/WelfPayItemMgr.do?cmd=viewWelfPayItemMgrTab3"+"&authPg=${authPg}");
		}
	}

	/* function hideIframe(){
		if(iframeIdx == 0) {
			newIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		}
	} */


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	</form>
	<div class="innertab inner" >
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><a href="#tabs-1" >국민/건강</a></li>
                <li><a href="#tabs-2" >복리후생/변동급여</a></li>
                <li><a href="#tabs-3" >세팅방법</a></li>
			</ul>
			<div id="tabs-1">
				<div  class='layout_tabs'><iframe id="tab1" name="tab1" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes' style="width:100vw; height: 100vh" ></iframe></div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs'><iframe id="tab2" name="tab2" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes' style="width:100vw; height: 100vh"></iframe></div>
			</div>
			<div id="tabs-3">
				<div  class='layout_tabs'><iframe id="tab3" name="tab3" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes' style="width:100vw; height: 100vh"></iframe></div>
			</div>
		</div>
	</div>

</div>
</body>
</html>