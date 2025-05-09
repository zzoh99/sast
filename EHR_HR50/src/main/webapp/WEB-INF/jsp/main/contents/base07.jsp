<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사마스터</title>
<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />

<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script defer src="${ctx}/assets/plugins/apexcharts-3.42.0/apexcharts.js"></script>
<script src="${ctx}/assets/plugins/swiper-10.2.0/swiper-bundle.min.js" type="text/javascript" charset="utf-8"></script>
<script defer src="${ctx}/assets/plugins/fullcalendar-6.1.8/main.js" type="text/javascript" charset="utf-8"></script>

<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
<script type="text/javascript" src="${ctx}/assets/js/main_widget.js"></script>
<script type="text/javascript">
const menucode = '${mainMenuCd}';

$(function() {
	createwWidget(menucode);
});

</script>

</head>
<body class="iframe_content">
	<div class="main_tab_content">
		<div class="sub_menu_container attendance_container">
			<div class="header">
	          <div class="title_wrap">
	          	<i class="mdi-ico filled">business_center_black</i>
	            <span>급여마스터</span>
	          </div>
	    </div>
	    
	    <div class="swiper widgetSwiper">
	    	 <div id="widgetBody" class="swiper-wrapper">
	    	 </div>
	    	 <div class="swiper-pagination"></div>
	    </div>
	</div>
</body>
</html>
