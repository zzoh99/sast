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
	<script type="text/javascript" src="${stx}/common/js/main_ess_chief.js?ver=<%= System.currentTimeMillis()%>"></script>
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
<body class="ess-main mgr">
<nav id="lnb" class="bg-white">
	<a href="#" class="home"><img src="/common/${theme}/images/icon_home_white.png" alt="home"></a>
	<ul class="main_menu nav-list" id="majorMenu">
	</ul>
</nav>
<div class="ess-wrap bg-white bg-top-theme">
	<div class="header ess-header">
		<div class="logo-wrap">
			<img src="/OrgPhotoOut.do?logoCd=7&orgCd=0&t=<%= new Date().getTime() %>" alt="" onClick="goMain();">
		</div>
		<div class="control">
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
					<!-- 근무중 widget -->
					<div class="widget theme">
                        <div class="header">
                            <div class="title"><i class="mdi-ico filled">work</i>근무중</div>
                        </div>
                        <div class="cnt-wrap">
                            <span class="label">근무</span>
                            <span class="ml-auto"><span class="cnt" id="workEmpCnt"></span><span class="unit">명</span></span>
                        </div>
                    </div>
                    <!-- 휴가중 widget -->
                    <div class="widget theme2">
                        <div class="header">
                            <div class="title"><i class="mdi-ico filled">flight</i>휴가중</div>
                        </div>
                        <div class="cnt-wrap">
                            <span class="label">휴가</span>
                            <span class="ml-auto"><span class="cnt" id="vacationEmpCnt"></span><span class="unit">명</span></span>
                        </div>
                    </div>
				</div>
			</div>
			<div class="ess-dashboard">
				<div class="widget-row">
					<div class="widget-col-12">
						<div class="widget bg-theme chart-wrap">
							<div class="widget-col-4">
								<div class="widget-header">
									<div class="widget-title text-center">팀원 휴가현황</div>
								</div>
								<div class="widget chart-box">
									<div id="vacationStatusChart"></div>
								</div>
							</div>
							<div class="widget-col-4">
								<div class="widget-header">
									<div class="widget-title text-center">초과근무 현황</div>
								</div>
								<div class="widget chart-box">
									<div id="otStatusChart"></div>
								</div>
							</div>
							<div class="widget-col-4">
								<div class="widget-header">
									<div class="widget-title text-center">팀 교육현황</div>
								</div>
								<div class="widget chart-box">
									<div id="eduStatusChart"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="widget-row">
					<div class="widget-col-4">
						<div class="widget column wiget-list-pb">
							<div class="widget-header">
								<div class="widget-title"><i class="mdi-ico filled">assignment_ind</i>결재현황<span class="rate-desc"><span id="applTotCnt"></span><strong class="point-color" id="applEndCnt"></strong></span><strong>완료</strong></div>
							</div>

							<ul class="approval-list" id="applListUl"></ul>
						</div>
					</div>
					<div class="widget-col-4">
						<div class="widget column">
							<div class="widget-header">
								<div class="widget-title btnNotice"><i class="mdi-ico filled">notifications</i>공지사항 <button class="ml-auto"><i class="mdi-ico">chevron_right</i></button></div>
							</div>
							<ul class="notice-list" id="noticeList"></ul>
						</div>
					</div>
					<div class="widget-col-4">
						<div class="widget column">
							<div class="widget-header">
								<div class="widget-title"><i class="mdi-ico filled">sticky_note_2</i>연차현황</div>
							</div>
							<div class="annual-cnt">
								<div class="inner-wrap">
									<span class="label">전체연차</span>
									<span class="ml-auto unit"><strong class="cnt">15</strong>개</span>
								</div>
								<div class="inner-wrap divider">
									<span class="label">잔여연차</span>
									<span class="ml-auto unit"><strong class="cnt point-color">8</strong>개</span>
								</div>
							</div>
							<div class="widget-title sub">팀원현황</div>
							<div>
								<div id="vacation-slide" class="swiper">
									<div class="swiper-wrapper" id="vacationSwipeDiv"></div>
									<div class="swiper-pagination"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>
		<aside class="col-3 ess-memList">
			<div class="widget-title">구성원 현황<span class="cnt ml-auto" id="memListCnt"></span><span class="unit">명</span></div>
			<ul class="card-list-wrap" id="memList"></ul>
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
		getMainEssChiefNotice();

		// 확인하지 않은 알림
		getMainEssChiefNotification();

		// 구성원현황 조회
		getMainEssChiefMemList('${ssnOrgCd}');

		// 연차현황
		getMainEssChiefVacationList();

		// 팀원 휴가현황 차트
		drawMainEssChiefVacationChart();

		// 초과근무 현황 차트
		drawMainEssChiefOtChart();

		// 팀 교육현황 차트
		drawMainEssChiefEduChart();

		// 결재현황
		getMainEssChiefApplList();

		// 팀원 근무 정보 조회
		getMainEssChiefWorkEmp();
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
		getMainEssChiefTalentEmployee($(this).attr('name'));
	});

	// 오른쪽 프로필 카드 박스 지각자 오늘/누적 toggle tab
	$(".toggle-tab-wrap .toggle-tab li").click(function() {
        var activeTab = $(this).attr("today");
            if($(this).attr("rel") == "total"){
                $('.toggle-tab-wrap').addClass('slide');
            }else{
                $('.toggle-tab-wrap').removeClass('slide');
            }
        $(".toggle-tab-wrap .toggle-tab li").removeClass("active");
        $(this).addClass("active");
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
</script>