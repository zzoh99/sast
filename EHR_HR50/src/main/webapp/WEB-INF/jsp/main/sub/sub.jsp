<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>${ ssnAlias }</title>

<!--   STYLE	 -->
<link rel="stylesheet" href="${ctx}/common/js/contextmenu/jquery.contextMenu.css"/>
<!-- <link rel="stylesheet" type="text/css" href="/common/css/main.css"> -->
<link href="${ ctx }/assets/css/common.css" rel="stylesheet" >
<link href="${ ctx }/assets/fonts/font.css" rel="stylesheet" />
<link href="${ ctx }/assets/css/modal.css" rel="stylesheet" >
<link href="${ ctx }/assets/css/process_map.css" rel="stylesheet" >

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script type="text/javascript" src="${ctx}/common/js/jScrollPane.js"></script>
<script type="text/javascript" src="${ctx}/common/js/jquery/jquery.scrollTo.min.js"></script>
<script type="text/javascript" src="${ctx}/common/js/cookie.js"></script>
<%-- <script type="text/javascript" src="${ctx}/common/js/jquery/jquery.defaultvalue.js?ver=<%= System.currentTimeMillis() %>"></script> --%>
<script type="text/javascript" src="${ctx}/common/js/submain.js?ver=20230125"></script>
<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>
<script type="text/javascript" src="${ctx}/common/js/contextmenu/jquery.contextMenu.js"></script>

<script type="text/javascript" src="${ctx}/assets/css/process_map.js"></script>

<script type="text/javascript">

var _pageObj = [];
var gPRow = "";
var pGubun = "";

var defaultTime = "${sessionScope.ssnTimeLock}";
var localeCd    = "${ssnLocaleCd}";
var enterCd     = "${ssnEnterCd}";
var getMenuSeq  = "${result.menuSeq}";
var menuOpenCnt = "${ssnLeftMenuOpenCnt}";

$(function() {
	
	ssnDataRwType = "${ssnDataRwType}"; // add
	
	$("#lockScreenDis").removeClass("hide").addClass("show");
	$("#devMode").val("${sessionScope.devMode}");
	
	$("#subMenu").jScrollPane();
	$("#myMenu").jScrollPane();
	// commonHeader start
<c:if test="${ssnLocaleCd !='' && ssnLangUseYn == 1}">
	selectLanguage("${ssnLocaleCd}");
</c:if>
	layoutHeader();
	createAuthList("${ssnGrpCd}");
	timerInit();
	setThemeFont("${theme}","${wfont}","${maintype}");
	// commonHeader end
	
	createAuthForm();
	// 1뎁스 메뉴 조회 및 생성
	createMajorMenu();
	// 1뎁스 메뉴 이벤트 생성
	majorMenuAction("${result.menuSeq}","${result.prgCd}");
	// 상단 탭 설정
	setTab();
	// 좌측 메뉴 설정
	setLeftMenu();
	// 탑 버튼 설정
	
	//setLevelWidget();
	// mainMenuCd 로 열기
	openMainMenuCd("${result.mainMenuCd}");
	
	subResize();
	
	layoutFooter();
	
	setTopButton();

	//2020.02.05
	$("#gapLink").click(function(){
		$("#btnLayoutSett01").click();
	});

	$(window).resize(subResize);
});

///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
/*
var	msgData		=	ajaxCall("/LangId.do?cmd=getMessage","convReturn=Y",false);
var	msgJson		=	msgData.msg;
var	msgArray	=	[];

$(msgJson).each(function(idx,obj){
	msgArray[obj.keyId]	=	obj.keyText	;
}); 
*/
</script>

</head>
<body class="bodywrap">
<div id="devdiv" style="display:none; position:absolute; width:150px; z-index:1;"></div>
<div id="wrap" class="full">
	<form name="ssnChangeForm" id="ssnChangeForm">
		<input type="hidden" name="rurl" id="rurl"  >
		<!-- theme  -->
		<input type="hidden" name="subThemeType"		id="subThemeType" 		value="${theme}" >
		<input type="hidden" name="subFontType"			id="subFontType" 		value="${wfont}" >
		<input type="hidden" name="subMainType"   		id="subMainType" 		value="${maintype}" >
		<input type="hidden" name="ssnTabsLimitCnt"		id="ssnTabsLimitCnt" 	value="${ssnTabsLimitCnt}" >

		<input type="hidden" name="ssnErrorAccYn" 		id="ssnErrorAccYn" 		value="${ssnErrorAccYn}" />

	</form>
	<div class="layout_content">
		<div id="header">
			<c:set var="headerType"  value="sub" />
			<%@ include file="/WEB-INF/jsp/common/include/commonHeader.jsp"%>		
		</div>
		<!--//header end -->
		<!-- 왼쪽메뉴 -->
		<div id="lnb">
			<div id="majorTop" class="onedepth_group" style="height: ${getMainMajorMenuListCount2021.count2021 > 0 ? 'calc(100% - 68px)' : 'calc(100% - 20px)'};">
				<ul class="inner" id="majorMenu1">
				</ul>
				<!-- 하단 메뉴 START-->
	 			<div class="lnb_bott_menu">
					<ul id="etcMenu" class="lnb_etc_menu">
					</ul>
				</div>
				<!-- 하단 메뉴 END -->
				<!-- 하단 up/down 버튼 -->
				<ul class="btn_menu">
					<li>
						<!-- <a class="btn_menu_down" id="btnMenuDown"> -->
						<a class="btn_menu_up" id="btnMenuUp"><i class="fas fa-caret-up"></i></a>
					</li>
					<li>
						<a class="btn_menu_down" id="btnMenuDown"><i class="fas fa-caret-down"></i></a>
					</li>
				</ul>
				<!-- 하단 up/down 버튼 end -->
			</div>
			
			<div id="subMenu" class="twodepth_group scroll-pane">
				<!-- 왼쪽메뉴 타이틀 -->
				<div class="lnb_title">
					<!-- lnb_title01~lnb_title11 메뉴마다 class명 변경 -->
					<span id="subMenuIcon" class="" title=""></span>
					<ul class="lnb_btn">
						<li>
							<a id="viewAll" class="btn_lnb_all pointer" title="<tit:txt mid='201708030000005' mdef='전체보기'/>"></a>
						</li>
						<li>
							<a id="view1Lvl" class="btn_lnb_depth1 pointer" title="<tit:txt mid='201708030000006' mdef='1레벨보기'/>"></a>
						</li>
						<li>
							<a id="view2Lvl" class="btn_lnb_depth2 pointer" title="<tit:txt mid='201708030000007' mdef='2레벨보기'/>"></a>
						</li>
						<li>
							<a id="view3Lvl" class="btn_lnb_depth3 pointer" title="<tit:txt mid='201708030000008' mdef='3레벨보기'/>"></a>
						</li>
					</ul>
				</div>
				<!-- //왼쪽메뉴 타이틀 end -->
				<ul id="subMenuCont" class="twodepth">
					<!-- <li>
						2depth on일 경우
						<a class="menu2_on"><tit:txt mid='112497' mdef='인사정보'/></a>
						<dl>
							<dt>
								3depth on일 경우
								<a class="menu3_on"><tit:txt mid='104301' mdef='인사기본'/></a>
								<a>정규직전환/재입사관리</a>
								<a>인원명부항목정의</a>
								<a>인원명부</a>
							</dt>
							<dd>
								4depth on일 경우
								<a class="menu4_on"><tit:txt mid='104301' mdef='인사기본'/></a>
								<a>정규직전환/재입사관리</a>
							</dd>
						</dl>
					</li>
					<li>
						<a>발령정보</a>
					</li>
					<li>
						<a>사원정보변경</a>
					</li> -->
				</ul>
			</div>
			<div id="myMenu" class="twodepth_group scroll-pane my_menu">
				<!-- 왼쪽메뉴 타이틀 -->
				<div class="lnb_title">
					<!-- lnb_title01~lnb_title11 메뉴마다 class명 변경 -->
					<span id="myMenuIcon" class="lnb_title19" title="나의메뉴"></span>
					<ul class="lnb_btn">
						<li>
							<a id="viewAll" class="btn_lnb_all pointer" title="전체보기"></a>
						</li>
						<li>
							<a id="view1Lvl" class="btn_lnb_depth1 pointer" title="1레벨보기"></a>
						</li>
						<li>
							<a id="view2Lvl" class="btn_lnb_depth2 pointer" title="2레벨보기"></a>
						</li>
						<li>
							<a id="view3Lvl" class="btn_lnb_depth3 pointer" title="3레벨보기"></a>
						</li>
					</ul>
				</div>
				<!-- //왼쪽메뉴 타이틀 end -->
				<ul id="myMenuCont" class="twodepth">
					<li >
						<a>나의 메뉴</a>
						<dl></dl>
					</li>
				</ul>
			</div>
		</div>
		<!-- //왼쪽메뉴 end -->
		<div id="container" class="container" style="margin: 0px;">
			<!-- content -->
			<div class="sub_wrap">
				<div class="sub_content">
					<!-- 상단탭/레이아웃 설정 -->
					<div id="tabs" class="sub_top" style="border: 0px;">
						<!-- 상단탭 -->
						<div id="tabGroup" class="tab_group2 scroll-pane horizontal-only" style="max-height:40px;">
							<ul class="tab_group">
								<!-- <li class="tab_on">
									인사기본
									<a class="tab_close">탭닫기</a>
								</li>
								<li>
									채용발령내용등록
									<a class="tab_close">탭닫기</a>
								</li>
								<li>
									사원정보변경

									<a class="tab_close">탭닫기</a>
								</li> -->
							</ul>
						</div>
						<ul class="btn_sub_tab">
							<li>
								<a id="btnTabPrev" class="btn_tab_prev pointer"><tit:txt mid='113564' mdef='이전'/></a>
							</li>
							<li>
								<a id="btnTabNext" class="btn_tab_next pointer"><tit:txt mid='112495' mdef='다음'/></a>
							</li>
						</ul>
						<!-- //상단탭 end-->
						<!-- 상단레이아웃 설정 -->
						<div class="top_btn_group">
							<a id="btnTabSett" class="btn_layout btn_tab_sett pointer" title="<tit:txt mid='201706280000059' mdef='탭설정'/>"><tit:txt mid='201706280000059' mdef='탭설정'/></a>
							<a id="btnLayoutSett01" class="btn_layout btn_layout_sett01 pointer" title="<tit:txt mid='201706280000056' mdef='좌측화면확장'/>"><tit:txt mid='201706280000056' mdef='좌측화면확장'/></a>
							<a id="btnLayoutSett02" class="btn_layout btn_layout_sett02 pointer" title="<tit:txt mid='201706280000057' mdef='상하화면확장'/>"><tit:txt mid='201706280000057' mdef='상하화면확장'/></a>
							<a id="btnLayoutSett03" class="btn_layout btn_layout_sett03 pointer" title="<tit:txt mid='201706280000058' mdef='전체화면확장'/>"><tit:txt mid='201706280000058' mdef='전체화면확장'/></a>
<%--
							<a id="addMyMenu" class="btn_layout btn_mymenu pointer hide" title="<tit:txt mid='myMenu' mdef='나의메뉴'/> 추가"><tit:txt mid='myMenu' mdef='나의메뉴'/></a>
 							<div class="tabWidget">
								<div id="tabWidgetMain" style="margin:-1px 0 0 -45px;">
									<div class="shadow"></div>
									<div class="content">
										<div class="title"><tit:txt mid='tabSetting' mdef='탭(상단) 설정'/></div>
										<ul>
											<li><input id="setTabAutoCloseCheck" type="checkbox" checked="true" /><tit:txt mid='112512' mdef=' 첫번째 탭 자동종료'/></li>
										</ul>
										<p><tit:txt mid='112513' mdef='탭 갯수가 ${ssnTabsLimitCnt}개를 넘으면 첫번째 탭이 자동으로 종료됩니다.' margs='${ssnTabsLimitCnt}'/></p>
										<div class="button">
											<btn:a id="tabOk" css="pink" mid='110716' mdef="확인"/>
											<btn:a id="tabCancel" css="gray" mid='110778' mdef="취소"/>
										</div>
									</div>
								</div>
							</div>
--%>
							<div id="tabWidgetMain" class="pop_authorityW">
								<p class="pop_title title"><tit:txt mid='tabSetting' mdef='탭(상단) 설정'/></p>
								<ul class="pop_level_lst">
									<li><input id="setTabAutoCloseCheck" type="checkbox" checked="true" /><tit:txt mid='112512' mdef=' 첫번째 탭 자동종료'/></li>
								</ul>
								<p><tit:txt mid='112513' mdef='탭 갯수가 ${ssnTabsLimitCnt}개를 넘으면 첫번째 탭이 자동으로 종료됩니다.' margs='${ssnTabsLimitCnt}'/></p>
								<div class="main_pop_btn">
									<btn:a id="tabOk" css="pop_btn pop_authority_close" mid='110716' mdef="확인"/>
									<btn:a id="tabCancel" css="pop_btn pop_authority_close" mid='110778' mdef="취소"/>
								</div>
							</div>
						</div>
						<!-- //상단레이아웃 설정 end -->
					</div>
					<!-- //상단탭/레이아웃 설정 end -->
					<!-- <div class="contents">
						내용들어갑니다.
					</div> -->
				</div>
			</div>
			<!-- //content end -->
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
			<a href="javascript:toggleHelpBox();" class="mar10" title="close"><img src="${ctx}/common/images/popup/close_w.png" /></a>
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

<div id="gapLink" class="gapbarhide">&nbsp;</div>

<c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
</c:if>

<%-- [START] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
<%@ include file="/WEB-INF/jsp/common/include/commonNotification.jsp"%>
<%-- [END] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
</body>
</html>
