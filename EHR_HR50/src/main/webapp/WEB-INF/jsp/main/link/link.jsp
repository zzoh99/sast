<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>e-HR</title>
<!--   STYLE	 -->
<link rel="stylesheet" href="/common/css/${wfont}.css" />
<link rel="stylesheet" href="/common/${theme}/css/style.css" />

<!--   JQUERY	 -->
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>

<!--   VALIDATION	 -->
<script src="${ctx}/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<!--  COMMON SCRIT -->
<script src="${ctx}/common/js/common.js"		type="text/javascript" charset="UTF-8"></script>

<!--  Ajax Error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script src="${ctx}/common/js/lang.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="${ctx}/common/js/main.js"></script>
<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>
<script type="text/javascript">
$(function() {
	
	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_${ssnEnterCd}.ico' />");
	$(document).attr("title","${ssnAlias}");
	
	goSubPage("${map.mainMenuCd}","","","","${map.prgCd}");
	
});
</script>
</head>
<body>
 	<form id="mainForm" name="mainForm" method="post"><!-- 메뉴값 넘기기 위한 form 수정 필요  -->
		<input type="hidden"	id="mainMenuCd" 	name="mainMenuCd" />
		<input type="hidden"	id="priorMenuCd" 	name="priorMenuCd"/>
		<input type="hidden"	id="menuCd"		 	name="menuCd" 	  />
		<input type="hidden"	id="menuSeq" 		name="menuSeq" 	  />
		<input type="hidden"	id="prgCd" 			name="prgCd" 	  />
		<input type="hidden"	id="mainTabSeq" 	name="mainTabSeq" /><!-- Not Use -->
		<input type="hidden" 	id="mainDate"		name="mainDate"	  />
		
		<!-- 
		<btn:a href="javascript:getWidgetValue();" mid='ok' mdef="확인"/>
		 -->
		
		
	</form>
</div>
</body>
</html>
