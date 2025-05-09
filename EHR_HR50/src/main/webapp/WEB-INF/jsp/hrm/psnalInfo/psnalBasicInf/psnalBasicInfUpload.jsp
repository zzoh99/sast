<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
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
	
	 //Sheet Action
    var selectTab = "tab11";

	$(function() {
		
		newIframe = $('#tabs-11 iframe');
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
	
	function showIframe() {
		
		
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}
// 		if(iframeIdx == 0) {
// 			newIframe.attr("src","${ctx}/OrgAppmtMgrTab1.do?cmd=viewOrgAppmtMgrTab1"+"&authPg=${authPg}");
// 		} else if(iframeIdx == 1) {
// 			newIframe.attr("src","${ctx}/OrgAppmtMgrTab2.do?cmd=viewOrgAppmtMgrTab2"+"&authPg=${authPg}");
// 		} else 
// 		
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/PsnalNojoUpload.do?cmd=viewPsnalNojoUpload"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/PsnalNosaUpload.do?cmd=viewPsnalNosaUpload"+"&authPg=${authPg}");
		} 
	}
    
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div >
        <div id="tabs" style="position:absolute;width:100%;top:0px;bottom:0">
            <ul class="tab_bottom">
<!--                 <li><btn:a href="#tabs-1" onclick="javascript:showIframe()" mid='110916' mdef="기본"/></li> -->
<!--                 <li><btn:a href="#tabs-2" onclick="javascript:showIframe()" mid='111358' mdef="주소"/></li> -->
<!--                 <li><btn:a href="#tabs-3" onclick="javascript:showIframe()" mid='110756' mdef="가족"/></li> -->
<!--                 <li><btn:a href="#tabs-4" onclick="javascript:showIframe()" mid='111194' mdef="학력"/></li> -->
<!--                 <li><btn:a href="#tabs-5" onclick="javascript:showIframe()" mid='110757' mdef="자격"/></li> -->
<!--                 <li><btn:a href="#tabs-6" onclick="javascript:showIframe()" mid='111054' mdef="경력"/></li> -->
<!--                 <li><btn:a href="#tabs-7" onclick="javascript:showIframe()" mid='110917' mdef="상벌"/></li> -->
<!--                 <li><btn:a href="#tabs-8" onclick="javascript:showIframe()" mid='111055' mdef="어학"/></li> -->
<!--                 <li><btn:a href="#tabs-9" onclick="javascript:showIframe()" mid='111056' mdef="보증"/></li> -->
<!--                 <li><btn:a href="#tabs-10" onclick="javascript:showIframe()" mid='111511' mdef="병역"/></li> -->
                <li><btn:a href="#tabs-11"  mid='111195' mdef="노조"/></li>
                <li><btn:a href="#tabs-12"  mid='111681' mdef="노사협의회"/></li>
<!--                 <li><btn:a href="#tabs-13" onclick="javascript:showIframe()" mid='110758' mdef="여권"/></li> -->
<!--                 <li><btn:a href="#tabs-14" onclick="javascript:showIframe()" mid='111512' mdef="비행경력"/></li> -->
            </ul>
<!--             <div id="tabs-1"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab1" name="tab1" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-2"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab2" name="tab2" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-3"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab3" name="tab3" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-4"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab4" name="tab4" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-5"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab5" name="tab5" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-6"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab6" name="tab6" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-7"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab7" name="tab7" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-8"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab8" name="tab8" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-9"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab9" name="tab9" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-10"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab10" name="tab10" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
            <div id="tabs-11">
                <div  class='layout_tabs'><iframe id="tab11" name="tab11" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
            <div id="tabs-12">
                <div  class='layout_tabs'><iframe id="tab12" name="tab12" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div>
            </div>
<!--             <div id="tabs-13"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab13" name="tab13" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
<!--             <div id="tabs-14"> -->
<%--                 <div  class='layout_tabs'><iframe id="tab13" name="tab13" src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div> --%>
<!--             </div> -->
        </div>
    </div>
</div>
</body>
</html>
