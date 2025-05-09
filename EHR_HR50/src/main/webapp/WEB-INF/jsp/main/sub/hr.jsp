<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>${ ssnAlias }</title>
	<!-- FONT PRELOAD -->
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIcons-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIconsOutlined-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/font.css" as="style">
	
	<!--   STYLE START	 -->
	<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
	<link rel="stylesheet" type="text/css" href="/common/${theme}/css/style.css">
	<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/override.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/mainSub.css" />
	<link rel="stylesheet" type="text/css" href="/common/js/contextmenu/jquery.contextMenu.css"/>
	
	<!-- HR UX 개선 신규 CSS -->
	<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
	<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />	
	<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
	<link rel="stylesheet" href="/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
	<link href="${ ctx }/assets/css/modal.css" rel="stylesheet" >
	<link href="${ ctx }/assets/css/process_map.css" rel="stylesheet" >
	<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/colors.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/theme.css" />
	
	<!-- 근태 css -->
	<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
	<!--   STYLE END      -->
	
	<!--   JQUERY	 -->
	<script type="text/javascript" src="/common/js/ras/script.js"></script>
	<script src="${ctx}/common/js/jquery/3.6.2/jquery-3.6.2.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/crypto-js/4.2.0/crypto-js.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/apexcharts-3.42.0/apexcharts.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/swiper-10.2.0/swiper-bundle.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript" src="${ctx}/common/js/contextmenu/jquery.contextMenu.js"></script>
	<script src="${ctx}/common/js/jquery/jquery.selectbox-0.2.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="${rdUrl}/ReportingServer/html5/js/crownix-viewer.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${rdUrl}/ReportingServer/html5/css/crownix-viewer.min.css">
	
	<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/jquery/jquery.mask.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>
	<c:choose>
		<c:when test="${sessionScope.ssnLocaleCd =='' || sessionScope.ssnLocaleCd =='ko_KR' }">
			<script src="${ctx}/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
		</c:when>
		<c:otherwise>
			<script src="${ctx}/common/js/jquery/datepicker_lang_EN.js"	type="text/javascript" charset="utf-8"></script>
		</c:otherwise>
	</c:choose>
	
	<!--
	<script type="text/javascript" src="${ctx}/common/js/jquery.mCustomScrollbar.min.js"></script>
	 -->
	<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
	<script src="${ctx}/common/js/lang.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/cookie.js" type="text/javascript"></script>
	<script type="text/javascript" src="${ctx}/common/js/main.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/submain.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/util.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${ctx}/assets/js/util.js"></script>
	<script src="${ctx}/common/js/commonIBSheet.js" type="text/javascript" charset="utf-8"></script>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script type="text/javascript" src="${ctx}/common/js/jquery/jquery.scrollTo.min.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/jScrollPane.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/include/header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/lnb.jsp"%>
	<form id="subForm">
		<input type="hidden" name="surl" id="surl" />
		<input type="hidden" name="murl" id="murl" />
	</form>
	<div id="container" class="container" style="margin: 0px;" >
		<div class="sub_wrap">
			<div class="sub_content">
				<div id="mainMenuTabs" class="sub_top" style="border: 0;">
					<div id="mainMenuTabGroup" class="tab_group2 scroll-pane horizontal-only" style="max-height:29px;">
						<ul class="tab_group">
						</ul>
						<ul class="btn_sub_tab">
							<li>
								<i class="mdi-ico">arrow_back_ios</i>
								<a id="btnTabPrev" class="btn_tab_prev pointer"><tit:txt mid='113564' mdef='이전'/></a>
							</li>
							<li>
								<i class="mdi-ico">arrow_forward_ios</i>
								<a id="btnTabNext" class="btn_tab_next pointer"><tit:txt mid='112495' mdef='다음'/></a>
							</li>
						</ul>
					</div>
					<div class="top_btn_group">
						<a id="btnTabSett" class="btn_layout btn_tab_sett pointer" title="<tit:txt mid='201706280000059' mdef='탭설정'/>"><tit:txt mid='201706280000059' mdef='탭설정'/></a>
						<a id="btnLayoutSett01" class="btn_layout btn_layout_sett01 pointer" title="<tit:txt mid='201706280000056' mdef='좌측화면확장'/>"><tit:txt mid='201706280000056' mdef='좌측화면확장'/></a>
						<a id="btnLayoutSett02" class="btn_layout btn_layout_sett02 pointer" title="<tit:txt mid='201706280000057' mdef='상하화면확장'/>"><tit:txt mid='201706280000057' mdef='상하화면확장'/></a>
						<a id="btnLayoutSett03" class="btn_layout btn_layout_sett03 pointer" title="<tit:txt mid='201706280000058' mdef='전체화면확장'/>"><tit:txt mid='201706280000058' mdef='전체화면확장'/></a>
						<div id="tabWidgetMain" class="pop_authorityW">
							<p class="pop_title title"><tit:txt mid='tabSetting' mdef='탭(상단) 설정'/></p>
							<ul class="pop_level_lst">
								<li><input id="setTabAutoCloseCheck" type="checkbox" checked="true" /><tit:txt mid='112512' mdef=' 첫번째 탭 자동종료'/></li>
							</ul>
							<p>
								<input type="hidden" name="ssnTabsLimitCnt"		id="ssnTabsLimitCnt" 	value="${ssnTabsLimitCnt}" >
								<tit:txt mid='112513' mdef='탭 갯수가 ${ssnTabsLimitCnt}개를 넘으면 첫번째 탭이 자동으로 종료됩니다.' margs='${ssnTabsLimitCnt}'/>
							</p>
							<div class="main_pop_btn">
								<btn:a id="tabOk" css="pop_btn pop_authority_close" mid='110716' mdef="확인"/>
								<btn:a id="tabCancel" css="pop_btn pop_authority_close" mid='110778' mdef="취소"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- helpBox -->
	<a href="javascript:toggleHelpBox();" id="btnHelpBox" class="fas fa-question-circle pointer hide" title="도움말 보기"></a>
	<div id="area_helpBox" class="helpBox">
		<dl class="_header mab25">
			<dt>
				<h3 class="menuNm fas fa-question-circle"></h3>
			</dt>
			<dd>
				<a href="javascript:toggleHelpBox();" class="mar10" title="close" tabindex="-1"><img src="${ctx}/common/images/popup/close_w.png" /></a>
			</dd>
		</dl>
		<div id="_helpPopup" class="mab15 ma-x-20">
			<h4 class="title disp_flex alignItem_center justify_between">
				<div class="f_bold"><span class="fas fa-info mal15 mar5"></span>도움말</div>
				<div><a id="btnOpenHelpPop" class="far fa-window-restore mar15 pointer"></a></div>
			</h4>
		</div>
		<div id="_relateMenu" class="_relateMenu ma-x-20">
			<div>
				<h4 class="title">
					<span class="fas fa-paperclip mal10 mar5"></span>연관 메뉴
				</h4>
			</div>
			<ul class="list mat5 ma-x-10"></ul>
		</div>
	</div>
	<!-- [END] helpBox -->
	<!--  
	<c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
	공통코드 레이어 팝업
	</c:if>
	-->
	<!-- 공통코드 레이어 팝업  -->
	<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
	<!-- 2023-12-14 AS-IS 에서 사용하는 layer 팝업이 동기방식의 html 불러오기가 모달이 바인딩되는 시점과 맞지 않음 -->
	<!-- 내용이 없는 상태로 바인딩되면서 element 전부 사라짐 -> 흰화면으로 바뀜 -> 비동기방식의 모달 추가함 -->
	<%@ include file="/WEB-INF/jsp/common/include/commonLayer.jsp"%>

	<%-- [START] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
	<%@ include file="/WEB-INF/jsp/common/include/commonNotification.jsp"%>
	<%-- [END] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
</body>
</html>
<script type="text/javascript">
var _pageObj = [];
var gPRow = "";
var pGubun = "";
const defaultTime = "${sessionScope.ssnTimeLock}";
const localeCd    = "${ssnLocaleCd}";
const enterCd     = "${ssnEnterCd}";
const mainMenuCd  = "${result.mainMenuCd}";
var mainMenuSeq = "${result.menuSeq}";
var mainPrgCd = "${result.prgCd}";
var dataRwType = "${ssnDataRwType}";

var mainLinkedBarProcMapSeq = '${result.linkedBarProcMapSeq}';
var mainLinkedBarProcSeq = '${result.linkedBarProcSeq}';

const session_theme = '${theme}';
const session_font = '${wfont}';
const session_mainT = '${maintype}';

$(function() {
	//세션 타임 및 현재 시간 생성
	headerSTimeInit();
	headerCTimeInit();
	
	//권한 정보 생성
	createAuthList();

	//다국어
	<c:if test="${ssnLocaleCd != '' && ssnLangUseYn == 1}">
	selectLanguage("${ssnLocaleCd}");
	</c:if>

	//theme event 등록
	setThemeEvent();

	//메인 메뉴 생성
	createMainMenu();
	onLnbEvent();

	// 상단 탭 설정
	setTab();
	openMain(mainMenuCd);
	subResize();
	setTopButton();

	//선택된 메뉴에 따른 메뉴 펼치기 event
	menuOpenByMenuSeq('${result.menuSeq}');
});

function callsortAbleTab() {
	const sortableElem = $('.tab_group').sortable("instance");
	if(sortableElem){
		const tabs = sortableElem.element[0].querySelectorAll("li");
		setTabsOrder(tabs)
	}

	let tabToRefresh = $('#tabs').tabs();

	$('.tab_group').sortable({
		items: '.ui-tabs-tab',
		helper: 'clone',
		axis: 'x',
		delay: 100,
		distance: 5,
		create: function (e, ui) {
			const tabs = e.target.querySelectorAll("li");
			setTabsOrder(tabs);
		},
		update: (e, ui) => {
			const tabs = e.target.querySelectorAll("li");
			setTabsOrder(tabs);
			tabToRefresh.tabs("refresh");
		},
		change: function (e, ui) {}
	  });
}

function setTabsOrder(elements) {
  let elemLength = elements.length;

  elements.forEach((element) => {
    element.style.zIndex = elemLength;
    elemLength--;
  });
}

<%--function showRdLayer(eleId, url, data, opt){--%>
<%--	//암호화 호출--%>
<%--	const result = ajaxTypeJson(url, data, false);--%>
<%--	//적용--%>
<%--	var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', eleId);--%>
<%--	viewer.setParameterEncrypt(11);--%>
<%--	viewer.openFile(result.DATA.path, result.DATA.encryptParameter, opt);--%>
<%--}--%>

function showRdLayer(url, data, opt, title, cW, cH, top, left){
	//암호화 호출
	const result = ajaxTypeJson(url, data, false);

	let layerModal = new window.top.document.LayerModal({
		id : 'rdLayer' //식별자ID
		, url : '/CommonCodeLayer.do?cmd=viewCommonRdLayer' //팝업에 띄울 화면 jsp
		, parameters : {
			"p" : result.DATA.path,
			"d" : result.DATA.encryptParameter,
			"o" : opt,
			"u" : url,
			"ud": data
		}
		, width : (cW != null && cW != undefined)?cW:1000
		, height : (cH != null && cH != undefined)?cH:800
		, top : (top != null && top != undefined) ? top : 0
		, left : (left != null && left != undefined) ? left : 0
		, title : (title != null && title != undefined)?title:'-'
		, trigger :[ //콜백
			{
				name : 'rdLayer'
				, callback : function(rv){
				}
			}
		]
	});
	layerModal.show();
	//적용
	<%--var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service');--%>
	<%--viewer.setParameterEncrypt(11);--%>
	<%--viewer.openFile(result.DATA.path, result.DATA.encryptParameter, opt);--%>
}

function showRdLayerAddToolbar(url, data, opt, toolbar){
	//암호화 호출
	const result = ajaxTypeJson(url, data, false);
	//적용
	var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', 'crownix-viewer');
	viewer.setParameterEncrypt(11);
	if(toolbar != null && toolbar != undefined) {
		if (Array.isArray(toolbar)) {
			for (var i = 0; i < toolbar.length; i++) {
				viewer.addToolbarItem(toolbar[i]);
			}
		} else {
			viewer.addToolbarItem(toolbar);
		}
	}
	viewer.openFile(result.DATA.path, result.DATA.encryptParameter, opt);
}

</script>