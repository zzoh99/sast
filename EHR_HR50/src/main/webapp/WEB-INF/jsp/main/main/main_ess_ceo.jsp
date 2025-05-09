<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
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

	<!-- bootstrap -->
	<link rel="stylesheet" href="/common/plugin/bootstrap/css/bootstrap.min.css">
	
	<!-- HR UX 개선 신규 CSS -->
	<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/modal.css" />
	<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
	<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/${theme}.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/chart.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/main_ess_leader.css">

	<!--   STYLE END      -->
	<!--   JQUERY	 -->
	<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/apexcharts-3.42.0/apexcharts.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/assets/plugins/swiper-10.2.0/swiper-bundle.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
	<script defer src="${ctx}/assets/plugins/fullcalendar-6.1.8/main.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/jquery/jquery.selectbox-0.2.min.js" type="text/javascript" charset="utf-8"></script>

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
	<%--<script type="text/javascript" src="${ctx}/assets/js/main_widget.js"></script>--%>

	<!-- ess js 추가 -->
	<script type="text/javascript" src="${stx}/common/js/main_ess_ceo.js?ver=<%= System.currentTimeMillis()%>"></script>
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
<body class="ess-main">
<nav id="lnb">
	<a href="#" class="home"><img src="/common/${theme}/images/icon_home.png" alt="home"></a>
	<ul class="main_menu nav-list" id="majorMenu">
	</ul>
</nav>
<div class="ess-wrap bg-color">
	<div class="bg-shape"></div>
	<div class="header ess-header">
		<div class="logo-wrap">
			<img src="/OrgPhotoOut.do?logoCd=7&orgCd=0&t=<%= new Date().getTime() %>" alt="" onClick="goMain();">
		</div>
		<div class="control">
			<!-- search box -->
			<div class="search-box">
				<div class="search">
					<input type="text" class="" id="mainHeaderSearchWord" placeholder="">
					<button class="btn filled thin" id="mainHeaderSearchBtn" onclick="headerSearchCeo()"><i class="mdi-ico">search</i></button>
				</div>
			</div>
			<div class="custom-select">
				<div class="avatar-wrap">
					<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=${ssnSabun}&t=<%= new Date().getTime() %>" alt="profile">
				</div>
				<div class="custom_select no_style">
					<button class="select_toggle">
						<span>${ssnName}</span><i class="mdi-ico">arrow_drop_down</i>
					</button>
					<!-- 개발 시 참고: fix_width 클래스 시 너비 픽스와 세로 스크롤 없음 -->
					<div class="select_options fix_width align_center" style="visibility: hidden;">
						<div class="option" onClick="changeUser();"><i class="mdi-ico">lock</i>비밀번호 변경</div>
						<div class="option" onClick="logout();"><i class="mdi-ico">logout</i>로그아웃</div>
					</div>
				</div>
			</div>
			<c:if test="${ssnCompanyMgrYn == 'Y'}">
			<div>
				<a href="#" class="chgCompany">
					<i class="mdi-ico filled">domain</i>
					${ssnEnterNm} 법인전환
				</a>
			</div>
			</c:if>
			<div class="account_info">
				<i class="mdi-ico filled account_circle">account_circle</i>
				<div class="custom_select no_style">
					<button class="select_toggle">
						<span>${ssnGrpNm}</span><i class="mdi-ico">arrow_drop_down</i>
					</button>
					<div id="possibleAuthList" class="select_options fix_width align_center"></div>
				</div>
			</div>

			<div class="session-wrap">
<%--				<span id="headerCTime" class="datetime"></span>--%>
				<span></span>
				<span id="headerSTime" class="countdown">--:--:--</span>
				<a href="#"><i class="mdi-ico add_circle" onclick="headerSTimeInit();">add_circle</i></a>
			</div>
			<ul class="btn-settings">
			<c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
				<li class="change-user">
					<button class="">
						<i class="mdi-ico filled">person</i>
					</button>
				</li>
			</c:if>
				<li class="setting">
					<div class="custom_select no_style icon">
						<button class="select_toggle">
							<i class="mdi-ico filled">settings</i>
						</button>
						<div id="themeList" class="select_options fix_width align_center">
			            	<div class="header">테마 설정</div>
			            	<div class="option" theme="blue"><span class="circle blue"></span>Blue</div>
			            	<div class="option" theme="orange"><span class="circle orange"></span>Orange</div>
			            	<div class="option" theme="red"><span class="circle red"></span>Red</div>
			            	<div class="option" theme="chicken"><span class="circle orange-red"></span>Orange Red</div>
			            	<div class="option" theme="greenOrange"><span class="circle green-orange"></span>Green Orange</div>
							<div class="option" theme="gold"><span class="circle gold"></span>Gold</div>
			            	<div class="option" theme="green"><span class="circle green"></span>Green</div>
			            	<div class="option" theme="skyblue"><span class="circle skyblue"></span>SkyBlue</div>
			            	<div class="option" theme="navy"><span class="circle navy"></span>Navy</div>
			            	<!-- <div class="option" theme="white"><span class="circle white"></span>White</div> -->
			          	</div>
					</div>
				</li>
				<li class="user-alert">
					<button class="">
						<i class="mdi-ico filled">notifications</i>
					</button>
				</li>
				<li>
					<button class="lock">
						<i class="mdi-ico filled" onClick="disableTop();">lock</i>
					</button>
				</li>
			</ul>
		</div>

		<!-- 메인페이지 알림 시작 -->
		<div id="panalAlertDiv" class="panalAlert" style="display:none;">
			<div class="panalAlert_title">
				<a class="title_icon"></a>
				<span style="font-size:18px">알 림</span>
				<a class="mdi-ico btn-close">close</a>
			</div>
			<ul id="panalAlert"></ul>
			<div class="toastMsgDiv">
				<div class="title alignL">
					<span>개인 알림</span>
					<a href="" class="btn_deleteAllToastMsg">[알림 모두 지우기]</a>
				</div>
				<div class="toastMsgBox">
					<ul class="toastMsgList"></ul>
				</div>
			</div>
			<div class="panalAlert_todayClose mal25">
				<span><label for="panalAlertTodayClose">오늘 하루 그만보기</label></span>
				<input type="checkbox" id="panalAlertTodayClose" name="panalAlertTodayClose" />
			</div>
		</div>
		<!-- 메인페이지 알림 종료-->

	</div>
	<div class="row ess-body">
		<main class="col-9 ess-content">
			<!-- 웰컴메세지 및 검색영역 -->
			<div class="ess-personal">
				<!-- 웰컴 메세지 -->
				<div class="welcome-msg">
					<div class="avatar-wrap">
						<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=${ssnSabun}&t=<%= new Date().getTime() %>" alt="profile">
					</div>
					<div class="inner-wrap">
						<div class="position">${ssnGrpNm}</div>
						<div class="msg-wrap"><span class="name">${ssnName}</span><span class="unit">님</span><span class="msg">오늘도 환영합니다</span></div>
					</div>
				</div>
				<!-- 위젯 wrapper -->
				<div class="widget-wrapper">
					<div class="widget acc">
						<img src="/common/${theme}/images/icon_dashboard_acc.png" alt="acc">
					</div>
					<!-- 결재 widget -->
					<div class="widget black">
                        <div class="header">
                            <div class="title"><i class="mdi-ico filled">assignment</i>결재</div>
                            <button class="ml-auto" id="btnApplAgree"><i class="mdi-ico">chevron_right</i></button>
                        </div>
                        <div class="cnt-wrap">
                            <span class="label">결재현황</span>
                            <span class="ml-auto"><span class="cnt" id="applAgreeCnt"></span><span class="unit">건</span></span>
                        </div>
                    </div>
				</div>
			</div>
			<div class="ess-dashboard">
				<div class="row widget-row">
					<div class="col-4 widget-col-4">
						<div class="widget bg-white small2 with-tab">
	                        <ul class="tab-wrap" id="numberPeople">
	                            <li class="widget-tab"><a href="#tab-all">전사</a></li>
	                            <li class="widget-tab"><a href="#tab-pbu">A-Unit</a></li>
	                            <li class="widget-tab"><a href="#tab-hsbu">B-Unit</a></li>
	                        </ul>
	                        <ul class="widget info" id="tab-all">
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">groups</i>
	                                </div>
	                                <div class="label">총인원</div>
	                                <div class="cnt-wrap"><span class="cnt">7,400</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">work</i>
	                                </div>
	                                <div class="label">재직</div>
	                                <div class="cnt-wrap"><span class="point-color cnt">7,331</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">volunteer_activism</i>
	                                </div>
	                                <div class="label">휴직</div>
	                                <div class="cnt-wrap"><span class="cnt">69</span><span class="unit">명</span></div>
	                            </li>
	                        </ul>
	                        <ul class="widget info" id="tab-pbu">
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">groups</i>
	                                </div>
	                                <div class="label">총인원</div>
	                                <div class="cnt-wrap"><span class="cnt">6,500</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">work</i>
	                                </div>
	                                <div class="label">재직</div>
	                                <div class="cnt-wrap"><span class="point-color cnt">6,452</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">volunteer_activism</i>
	                                </div>
	                                <div class="label">휴직</div>
	                                <div class="cnt-wrap"><span class="cnt">48</span><span class="unit">명</span></div>
	                            </li>
	                        </ul>
	                        <ul class="widget info" id="tab-hsbu">
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">groups</i>
	                                </div>
	                                <div class="label">총인원</div>
	                                <div class="cnt-wrap"><span class="cnt">900</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">work</i>
	                                </div>
	                                <div class="label">재직</div>
	                                <div class="cnt-wrap"><span class="point-color cnt">879</span><span class="unit">명</span></div>
	                            </li>
	                            <li>
	                                <div class="icon-wrap">
	                                    <i class="mdi-ico filled">volunteer_activism</i>
	                                </div>
	                                <div class="label">휴직</div>
	                                <div class="cnt-wrap"><span class="cnt">21</span><span class="unit">명</span></div>
	                            </li>
	                        </ul>
	                    </div>
						<div class="widget bg-theme small1">
							<div class="img-wrap">
								<img src="/assets/images/ess_widget_leave_2x.png" alt="">
							</div>
							<div class="inner-wrap">
								<div><span class="label">퇴사</span><span class="cnt" id="empRetCnt"></span><span class="unit">명</span></div>
								<p class="desc" id="retRateGap"></p>
							</div>
						</div>
					</div>
					<div class="col-8 widget-col-8">
						<div class="widget bg-theme chart-wrap">
							<div class="widget-col-6">
								<div class="widget-header">
									<div class="widget-title"><i class="mdi-ico filled">person</i>인원현황</div>
									<ul class="tab-wrap">
										<li class="widget-tab pointer psnl-status on" num="1">연령</li>
										<li class="widget-tab pointer psnl-status" num="2">근무지</li>
										<li class="widget-tab pointer psnl-status" num="3">직군/지위</li>
										<li class="widget-tab pointer psnl-status" num="4">평가</li>
									</ul>
								</div>
								<div class="widget chart-box">
									<div id="psnlStatusChart"></div>
								</div>
							</div>
							<div class="widget-col-6">
								<div class="widget-header">
									<div class="widget-title"><i class="mdi-ico filled">insights</i>인건비현황</div>
								</div>
								<p class="chart-desc">*당해년도 개인별 실지급액 기준</p>
								<div class="widget chart-box">
									<div id="costStatusChart"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="widget-row">
					<div class="widget-col-4">
						<div class="widget bg-theme column">
							<div class="widget-header">
								<div class="widget-title"><i class="mdi-ico filled">assignment_ind</i>주목할 인재</div>
								<ul class="tab-wrap">
									<li class="widget-tab pointer tabTalentEmployee on" name="New">신규입사자</li>
									<li class="widget-tab pointer tabTalentEmployee" name="Core">핵심인재</li>
								</ul>
							</div>

							<div class="talent-employee">
								<div id="talent-employee-slide" class="swiper">
									<div class="swiper-wrapper" id="talentEmployeeDiv"></div>
									<div class="swiper-pagination"></div>
								</div>
							</div>

						</div>
					</div>
					<div class="widget-col-4">
						<div class="widget column">
							<div class="widget-header">
								<div class="widget-title"><i class="mdi-ico filled">stacked_bar_chart</i>본부별 실적</div>
							</div>
							<div class="dropDown-wrap">
                                <div class="custom_select">
                                    <select name="" id="">
                                        <option value="">선택</option>
                                        <option value="all">본부전체</option>
                                        <option value="HR">HR</option>
                                        <option value="DX">디지털융합</option>
                                        <option value="manager">경영전략</option>
                                    </select>
                                </div>
                                <div class="custom_select">
                                    <select name="" id="">
                                        <option value="">선택</option>
                                        <option value="quarter1">1분기</option>
                                        <option value="quarter2">2분기</option>
                                        <option value="quarter3">3분기</option>
                                        <option value="quarter4">4분기</option>
                                    </select>
                                </div>
                            </div>
							<div class="chart-wrap">
								<div id="achieveStatusChart" style="margin-left: -1.167rem;"></div>
							</div>
						</div>
					</div>
					<div class="widget-col-4">
						<div class="widget column wiget-notice-pb">
							<div class="widget-header">
								<div class="widget-title btnNotice"><i class="mdi-ico filled">notifications</i>공지사항 <button class="ml-auto"><i class="mdi-ico">chevron_right</i></button></div>
							</div>
							<ul class="notice-list" id="noticeList"></ul>
						</div>
					</div>
				</div>
			</div>
		</main>
		<aside class="col-3 ess-memList">
			<ul class="tab-wrap">
				<li class="widget-tab pointer mem-list on" name="Exec">임원</li>
				<li class="widget-tab pointer mem-list" name="Leader">팀장</li>
				<li class="widget-tab pointer mem-list" name="All">전직원</li>
<%--				<li class="widget-tab pointer mem-list" name="Late">지각</li>--%>
			</ul>
			<div class="widget-title"><span id="memListTitle"></span><span class="cnt" id="memListCnt"></span><span class="unit">명</span>
				<div class="toggle-tab-wrap hide" id="lateToggle">
                    <ul class="toggle-tab">
                        <li class="tab-slider active" rel="today">오늘</li>
                        <li class="tab-slider" rel="total">누적</li>
                    </ul>
            	</div>
			</div>
			<ul class="card-list" id="memList"></ul>
		</aside>
	</div>
</div>

<!-- 공통코드 레이어 팝업  -->
<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/commonLayer.jsp"%>
<%-- 알림 토스트 --%>
<%@ include file="/WEB-INF/jsp/common/include/notification.jsp"%>
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

		//메인 메뉴 생성
		createMainMenu();

		// 공지사항
		getMainEssCeoNotice();

		// 결재정보
		getMainEssCeoAppl();

		// 확인하지 않은 알림
		getMainEssCeoNotification();

		// 인원현황
		getMainEssCeoEmpCnt();

		// 퇴직현황
		getMainEssCeoRetireInfo();

		// 주목할 인재
		getMainEssCeoTalentEmployee('New');

		// 인원현황 차트
		drawPersonnelStatus(1);

		// 본부별 실적 차트
		drawAchieveStatusChart();

		// 인건비 현황 차트
		drawCostStatusChart();

		// 직원리스트 조회
		getMainEssCeoMemList("Exec");
	});

	// 사용자변경 클릭 event
	$('.change-user').on('click', function(){
		if(!isPopup()) {return;}

		if (!confirm(getMsgLanguage({"msgid": "msg.201707120000007", "defaultMsg":"관리자 권한으로 접근 하였습니다.\n관리자가 아닌 경우 접근경로를 확인가능하며,\n인사상 불이익이 있을 수 있습니다.\n\n본인의 아이디와 비밀번호를 사용 바랍니다."}))){
			return;
		}

		gPRow = "";
		pGubun = "chgUserLayer";
		const url = '/chgUserLayer.do?cmd=viewChgUserLayer';
		let chgUserLayer = new window.top.document.LayerModal({
			id: 'chgUserLayer',
			url: url,
			width: 900,
			height: 750,
			title: '사용자 변경 로그인'
		});
		chgUserLayer.show();
	});

	// 공지사항 클릭 event
	$('.btnNotice').off().click(function() {
		goSubPage('20', '', '', '', '/Board.do?cmd=viewBoardMgr||bbsCd=10000');
	});

	// 알림버튼 클릭 event
	$('.user-alert').on('click', function(){
		getPanalAlertList2('${ssnSabun}', true);
	});

	// 결재 더보기 클릭 시 결재할 문서로 이동
	$('#btnApplAgree').off().click(function() {
		goSubPage("10", "", "", "", "AppBeforeLst.do?cmd=viewAppBeforeLst");
	});


	// 확인하지 않은 이벤트 클릭시 알림창 오픈
	$('#btnNotificationChk').off().click(function() {
		getPanalAlertList2('${ssnSabun}', true);
	});

	// 주목할인재 탭 클릭
	$('.tabTalentEmployee').off().click(function() {
		$('.tabTalentEmployee').not(this).removeClass('on');
		$(this).addClass('on');
		getMainEssCeoTalentEmployee($(this).attr('name'));
	});

	// 회사변경 버튼 클릭
	$('.chgCompany').on('click', function(){
		const url = '/chgCompanyLayer.do?cmd=viewChgCompanyLayer';
		let changeCompanyLayer = new window.top.document.LayerModal({
			id: 'changeCompanyLayer',
			url: url,
			width: 450,
			height: 370,
			title: '<tit:txt mid='113568' mdef='회사변경'/>'
		});
		changeCompanyLayer.show();
	});

    // 인원현황 탭 클릭
    $('.psnl-status').off().click(function(){
		$('.psnl-status').not(this).removeClass('on');
		$(this).addClass('on');
		drawPersonnelStatus($(this).attr('num'));
	});

	// 인원리스트 탭 클릭
	$('.mem-list').off().click(function() {
		$('.mem-list').not(this).removeClass('on');
		$('#lateToggle').addClass('hide')
		$(this).addClass('on');
		getMainEssCeoMemList($(this).attr('name'));
		if($(this).attr('name') == 'Late') $('#lateToggle').removeClass('hide')
	});

	// 인원리스트 지각자 오늘/누적 toggle tab
	$(".toggle-tab-wrap .toggle-tab li").click(function() {
		if($(this).attr("rel") == "total"){
			$('.toggle-tab-wrap').addClass('slide');
            $("#memList .status").removeClass('hide');
		}else{
			$('.toggle-tab-wrap').removeClass('slide');
            $("#memList .status").addClass('hide');
		}
		$(".toggle-tab-wrap .toggle-tab li").removeClass("active");
		$(this).addClass("active");
	});

	$("#mainHeaderSearchWord").keydown(function(e) {
		if (e.keyCode == '13') {
			$('#mainHeaderSearchBtn').trigger('click');
		}
	});

	//상단 이미지 없을 때, 이미지 감추기
	$(".widget-wrapper img").each(function () {
        if (!this.complete || this.naturalWidth === 0) {
            $(this).hide(); // 이미지가 로드되지 않았을 경우 숨김
        }
    }).on("error", function () {
        $(this).hide(); // 이미지 로드 실패 시 숨김
    });
</script>