<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<title>${ ssnAlias }</title>
	<!-- FONT PRELOAD -->
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIcons-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIconsOutlined-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/font.css" as="style">
	
	<!--   STYLE START	 -->
	<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
	<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/override.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/mainSub.css" />
	
	<!-- HR UX 개선 신규 CSS -->
	<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/modal.css" />
	<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
	<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
    <link rel="stylesheet" type="text/css" href="/assets/css/chart.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/colors.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/theme.css" />
    
	<!--   STYLE END      -->
	<!--   JQUERY	 -->
	<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/crypto-js/4.2.0/crypto-js.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/apexcharts-3.42.0/apexcharts.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/swiper-10.2.0/swiper-bundle.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
	<script defer src="${ctx}/assets/plugins/fullcalendar-6.1.8/main.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/jquery/jquery.selectbox-0.2.min.js" type="text/javascript" charset="utf-8"></script>
	<!--
	<script type="text/javascript" src="${ctx}/common/js/jquery.mCustomScrollbar.min.js"></script>
	 -->
	<!--   JQUERY	 -->
	<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
	<script src="${ctx}/common/js/lang.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/cookie.js" type="text/javascript"></script>
	<script type="text/javascript" src="${ctx}/common/js/main.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/submain.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/commonHeader.js"></script>
	
	<!-- widget용 js 추가 -->
	<script type="text/javascript" src="${ctx}/assets/js/util.js"></script>
	<script src="${ctx}/assets/plugins/masonry-4.2.2/masonry.pkgd.min.js"></script>
	<script type="text/javascript" src="${ctx}/assets/js/main_widget.js"></script>
	<script>
		var _connect_E_ = "${ssnEnterCd}";
		var _connect_A_ = "${authPg}";
		var _connect_I_ = "${ssnSabun}";
	</script>
	<style>
		div#panalAlertDiv{
			z-index:2;
		}
	</style>
</head>
<body class="home">
	<%@ include file="/WEB-INF/jsp/common/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/lnb.jsp"%>
	<!-- 신규 LEFT MENU END -->
	
	<main id="container">
		<div class="main_content">
			<div class="swiper widgetSwiper" style="overflow-y: auto;">
				<!-- swiper contents start  -->
				<div id="widgetBody" class="swiper-wrapper">
		        </div>
		        <div class="swiper-pagination"></div>
			</div>
		</div>
	</main>
	<!-- 공통코드 레이어 팝업  -->
	<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/commonLayer.jsp"%>
</body>
</html>
<script type="text/javascript">
var _pageObj = [];
var gPRow = "";
var pGubun = "";
const defaultTime = "${sessionScope.ssnTimeLock}";
const localeCd    = "${ssnLocaleCd}";
const enterCd     = "${ssnEnterCd}";

const session_theme = '${theme}';
const session_font = '${wfont}';
const session_mainT = '${maintype}';

$(function() {
	//세션 타임 및 현재 시간 생성
	headerSTimeInit();
	headerCTimeInit();

	//theme event 등록
	setThemeEvent();

	//권한 정보 생성
	createAuthList();

	//다국어
	<c:if test="${ssnLocaleCd != '' && ssnLangUseYn == 1}">
	selectLanguage("${ssnLocaleCd}");
	</c:if>

	//메인 메뉴 생성
	createMainMenu();

	//메인페이지 위젯 생성
	createwWidget('00');

	$('#errorAcc').hide();
});
</script>