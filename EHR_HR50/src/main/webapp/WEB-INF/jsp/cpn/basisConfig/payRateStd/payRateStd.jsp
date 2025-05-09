<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112073' mdef='급여지급율관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

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
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		}

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
        case "tab3":      tab3.doAction('Search'); break;
        case "tab4":      tab4.doAction('Search'); break;
        }
    }

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/PayRateTab1Std.do?cmd=viewPayRateTab1Std"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/PayRateTab2Std.do?cmd=viewPayRateTab2Std"+"&authPg=${authPg}");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/PayRateTab3Std.do?cmd=viewPayRateTab3Std"+"&authPg=${authPg}");
		} else if(iframeIdx == 3) {
			newIframe.attr("src","${ctx}/PayRateTab4Std.do?cmd=viewPayRateTab4Std"+"&authPg=${authPg}");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
	</form>
	<div class="innertab inner" style="height: 95%">
        <div id="tabs">
            <ul class="tab_bottom">
                <li><a href="#tabs-1"><tit:txt mid='payRateTab1Std' mdef='휴직'/></a></li>
                <li><a href="#tabs-2"><tit:txt mid='payRateTab2Std' mdef='근태'/></a></li>
                <li><a href="#tabs-3"><tit:txt mid='payRateTab3Std' mdef='징계'/></a></li>
                <li><a href="#tabs-4"><tit:txt mid='payRateTab4Std' mdef='임금피크'/></a></li>
            </ul>

            <div id="tabs-1">
                <div  class='layout_tabs'><iframe id="tab1" name="tab1" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'><iframe id="tab2" name="tab2" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-3">
                <div  class='layout_tabs'><iframe id="tab3" name="tab3" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-4">
                <div  class='layout_tabs'><iframe id="tab4" name="tab4" src='about:blank<%-- /common/hidden.jsp --%>' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>