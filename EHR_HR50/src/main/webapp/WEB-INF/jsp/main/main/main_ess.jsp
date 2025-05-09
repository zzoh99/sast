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
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/${theme}.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/chart.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/main_ess.css">

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
	<script type="text/javascript" src="${ctx}/assets/js/main_widget.js"></script>

	<!-- ess js 추가 -->
	<script type="text/javascript" src="${stx}/common/js/main_ess.js?ver=<%= System.currentTimeMillis()%>"></script>
	<script>
		var _connect_E_ = "${ssnEnterCd}";
		var _connect_A_ = "${authPg}";
		var _connect_I_ = "${ssnSabun}";
	</script>
	<style>
		div#panalAlertDiv{
			z-index:2;
		}
		/* 비행기 배경화면 주석 */
		.ess-wrap .bg-shape{
			background-image: url('../../common/${theme}/Main/bg_shape.png');
		}
	</style>
</head>
<body class="ess-body">
<%@ include file="/WEB-INF/jsp/common/include/lnb.jsp"%>

<div class="ess-wrap bg-color common">
	<div class="bg-shape"></div>
	<header class="ess-header">
		<div class="logo-wrap">
			<img src="/OrgPhotoOut.do?logoCd=7&orgCd=0&t=<%= new Date().getTime() %>" alt="" class="logo" style="cursor: pointer;" onClick="goMain();">
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

	</header>

	<div class="ess-content">
		<!-- 웰컴메세지 및 검색영역 -->
		<div class="ess-personal">
			<!-- 웰컴 메세지 -->
			<div class="welcome-msg">
				<div class="avatar-wrap">
					<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=${ssnSabun}&t=<%= new Date().getTime() %>" alt="profile">
				</div>
				<div class="inner-wrap">
					<div class="team"></div>
					<div class="msg-wrap"><span class="name">${ssnName}</span><span class="unit">님</span><span class="msg">오늘도 환영합니다</span></div>
				</div>
			</div>
			<!-- 검색 -->
			<div class="search-box">
				<div class="msg-wrap"><i class="mdi-ico">tag_faces</i><span class="msg">어떤 업무를 원하시나요?</span></div>
				<div class="search">
					<input type="text" class="" id="mainHeaderSearchWord" placeholder="인사정보, 업무 검색이 가능합니다.                 ">
					<button class="btn filled thin" onclick="headerSearch()"><i class="mdi-ico">search</i></button>
				</div>
			</div>
		</div>
		<!-- widget -->
		<div class="ess-widget">
			<!--  -->
			<div class="widget-info">
				<div class="approval-wrap">
					<div class="leave-wrap">
						<div class="label pointer" id="vacationDiv">남은연차<i class="mdi-ico">chevron_right</i></div>
						<div class="cnt-wrap"><span class="cnt" id="vacationRestCnt"></span><span class="unit">일</span></div>
					</div>
					<div class="widget big approval ml-auto pointer" id="applAgreeDiv">
						<div class="desc">
							<div class="title">기다리는 결재건이<br><span class="cnt" id="applAgreeCnt"></span>있어요.</div>
						</div>
						<div class="img-wrap ml-auto">
							<img src="/assets/images/ess_widget_memo_2x.png" alt="">
						</div>
					</div>
				</div>
				<div class="approval-cnt">
					<div class="inner-wrap">
						<span class="label">진행 중 결재 건</span>
						<span class="ml-auto cnt pointer" id="applProgCnt"></span>
					</div>
					<div class="inner-wrap divider">
						<span class="label">결재 완료된 건</span>
						<span class="ml-auto cnt pointer" id="applFinCnt"></span>
					</div>
				</div>
				<div class="title-wrap">
					<div class="widget-title">동료일정</div>
					<span class="ml-auto d-flex align-center"><span class="more pointer" id="morePsnlTime">더보기</span><i class="mdi-ico">chevron_right</i></span>
				</div>

				<div class="personal-time">
					<div id="psnl-time-slide" class="swiper">
						<div class="swiper-wrapper" id="psnlTimeDiv"></div>
						<div class="swiper-pagination"></div>
						<div class="swiper-button-next"><i class="mdi-ico">keyboard_arrow_right</i></div>
						<div class="swiper-button-prev"><i class="mdi-ico">keyboard_arrow_left</i></div>
					</div>
				</div>

				<div class="widget-wrapper qna-wrap">
					<div class="inner-wrap wid-100">
						<div class="widget big">
							<div class="img-wrap">
								<img src="/assets/images/ess_widget_qna_2x.png" alt="">
							</div>
							<div class="desc">
								<div class="title big">궁금한 사항이 있으신가요?</div>
								<div class="btn-wrap"><button class="pointer" id="btnInquiry">문의하기</button></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 즐겨찾는 항목 -->
			<div class="widget-favorit">
				<div class="title-wrap">
					<div class="widget-title">즐겨찾는 항목</div>
				</div>
				<div class="widget-wrapper">
					<div class="inner-item1">
						<div class="inner-wrap">
							<div class="widget">
								<div class="header">
									<div class="title"><i class="mdi-ico filled">date_range</i>연간일정</div>
									<!-- <button class="ml-auto"><i class="mdi-ico">chevron_right</i></button> -->
								</div>
								<div class="status-wrap">
									<ul class="status-list" id="annualPlanList">
<%--										<li class="list"><P>평가 목표</P><div><i class="mdi-ico">event</i><span class="date">24.01.01 - 24.01.15</span></div></li>--%>
<%--										<li class="list"><P>평가 중간 점검</P><div><i class="mdi-ico">event</i><span class="date">24.01.01 - 24.01.15</span></div></li>--%>
<%--										<li class="list"><P>평가 종합평가</P><div><i class="mdi-ico">event</i><span class="date">24.01.01 - 24.01.15</span></div></li>--%>
<%--										<li class="list"><P>연차 촉진 계획</P><div><i class="mdi-ico">event</i><span class="date">24.01.01 - 24.01.15</span></div></li>--%>
<%--										<li class="list"><P>연말정산</P><div><i class="mdi-ico">event</i><span class="date">24.01.01 - 24.01.15</span></div></li>--%>
									</ul>
									<!-- status가 4개 이상일 경우 -->
									<!-- <span class="status-more">+3</span> -->
								</div>
							</div>
						</div>
					</div>
					<div class="inner-item2">
						<div class="inner-wrap">
							<div class="widget with-btn">
								<div class="title-wrap">
									<div class="ico-round savings">
										<i class="mdi-ico filled">savings</i>
									</div>
									<div class="title">급여</div>
								</div>
								<div class="btn-wrap"><button class="pointer" id="btnPayChk">확인하기</button></div>
							</div>
						</div>
						<div class="inner-wrap">
							<div class="widget with-btn">
								<div class="title-wrap">
									<div class="ico-round watch">
										<i class="mdi-ico filled">watch_later</i>
									</div>
									<div class="title">근태관리</div>
								</div>
								<div class="btn-wrap"><button class="pointer" id="btnSetWork">설정하기</button></div>
							</div>
						</div>
						<div class="inner-wrap">
							<div class="widget">
								<div class="header">
									<div class="title"><i class="mdi-ico filled">notifications</i>공지사항</div>
									<button class="ml-auto btnNotice"><i class="mdi-ico">chevron_right</i></button>
								</div>
								<div class="cnt-wrap">
									<span class="label">새로운 공지</span>
									<span class="ml-auto pointer btnNotice"><span class="cnt" id="noticeCnt"></span><span class="unit">건</span></span>
								</div>
							</div>
						</div>
						<div class="inner-wrap">
							<div class="widget bg-grey">
								<div class="header">
									<div class="title"><i class="mdi-ico filled">menu</i>전체메뉴</div>
								</div>
								<div class="btn-wrap">
									<span class="desc">전체 메뉴 화면으로 이동합니다</span>
									<button class="ml-auto round" onClick="callMenuListLayer();"><i class="mdi-ico pointer language sitemap">chevron_right</i></button>
								</div>
							</div>
						</div>
					</div>
					
				</div>
				<div class="widget-wrapper notify-wrap">
					<div class="inner-wrap wid-50">
						<div class="widget big work">
							<!-- <div class="img-wrap">
								<img src="/assets/images/ess_widget_work_2x.png" alt="">
							</div> -->

							<!-- on 출근하기 disabled 비활성화 -->
							<div class="btn-wrap">
								<button class="work-btn pointer on" type="button"><i class="mdi-ico"></i></button>
							</div>
							<div class="inner-wrap desc">
								<div class="work-time">
									<span class="label week-label">주 근로시간</span><span class="cnt" id="totWorkHour"></span><span class="time-label"> / 52시간</span>
								</div>
								<div class="progress-wrap">
									<div class="progress">
										<div class="bar" style="width: calc(60.5%);"></div><!-- bar 클래스에 class="green" 추가 시 초록색의 진행바가 보임 / 해당 dom에 인라인으로 가로 사이즈 입력시 progress 바가 보임 -->
									</div>
								</div>
								<div class="inout-wrap">
									<span class="info">출근 <span class="time" id="st">-</span></span>
									<span class="info">퇴근 <span class="time" id="et">-</span></span>
								</div>
							</div>
						</div>
					</div>
					<div class="inner-wrap wid-50">
						<div class="widget big event">
							<div class="img-wrap">
								<img src="/assets/images/ess_widget_event_2x.png" alt="">
							</div>
							<div class="desc">
								<div class="title">확인하지 않은 이벤트가<br><span class="cnt" id="unchkNotification"></span>있어요.</div>
								<div class="btn-wrap"><button class="pointer" id="btnNotificationChk">확인하기</button></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
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

		//메인페이지 위젯 생성
		createwWidget('00');

		// 공지사항
		getMainEssNotice();

		// 남은연차
		getMainEssVacation();

		// 결재정보
		getMainEssAppl();

		// 확인하지 않은 알림
		getMainEssNotification();

		// 근태정보
		getMainEssWorkTime();

		// 동료일정
		getMainEssPsnlTime();

		// 연간일정
		getMainEssAnnualPlan();

		// 배경 이미지 확인
		var bgUrl = `../../common/${theme}/Main/bg_shape.png`;

	    if (!bgUrl || bgUrl.includes("${theme}")) {
	        //console.warn("올바른 bgUrl이 아님:", bgUrl);
	        return; // 적용하지 않음
	    }

	    var img = new Image();
	    img.src = bgUrl;

	    img.onload = function () {
	        $(".ess-wrap .bg-shape").css("background-image", `url('${bgUrl}')`);
	    };

	    img.onerror = function () {
	        //console.warn("배경 이미지가 존재하지 않음:", bgUrl);
	        $(".ess-wrap .bg-shape").css("background-image", "none");
	    };
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

	// 남은 연차 타이틀 클릭 시 근태신청 메뉴로 이동
	$('#vacationDiv').off().click(function() {
		goSubPage("08", "", "", "", "VacationApp.do?cmd=viewVacationApp");
	});

	// 기다리는 결재 건 클릭 시 결재할 문서로 이동
	$('#applAgreeDiv').off().click(function() {
		goSubPage("10", "", "", "", "AppBeforeLst.do?cmd=viewAppBeforeLst");
	});

	// 진행중 결재 건 클릭 시 기안한 문서로 이동
	$('#applProgCnt').off().click(function() {
		goSubPage("10", "", "", "", "AppBoxLst.do?cmd=viewAppBoxLst");
	});

	// 결재 완료된 건 클릭 시 모든 문서로 이동
	$('#applFinCnt').off().click(function() {
		goSubPage("10", "", "", "", "AppAfterLst.do?cmd=viewAppAfterLst");
	});

	// 급여 확인하기 클릭 시 개인별급여내역 으로 이동
	$('#btnPayChk').off().click(function() {
		goSubPage("07","","","","PerPayPartiUserSta.do?cmd=viewPerPayPartiUserSta");
	});

	// 근태관리 설정하기 클릭 시 근무스케쥴신청 으로 이동
	$('#btnSetWork').off().click(function() {
		goSubPage("08","","","","WorkScheduleOrgApp.do?cmd=viewWorkScheduleOrgApp");
	});

	// 문의하기 클릭 시 HR문의요청 으로 이동
	$('#btnInquiry').off().click(function() {
		goSubPage("02","","","","HrQueryApp.do?cmd=viewHrQueryApp");
	});

	// 확인하지 않은 이벤트 클릭시 알림창 오픈
	$('#btnNotificationChk').off().click(function() {
		getPanalAlertList2('${ssnSabun}', true);
	});

	// 검색창에서 enter key 입력시 event
	$("#mainHeaderSearchWord").on("keyup",function(key){
		if(key.keyCode==13) {
			headerSearch();
		}
	});

	// 동료일정 더보기 클릭시, 조직원근태현황으로 이동
	$('#morePsnlTime').off().click(function() {
		goSubPage("08","","","","PsnlTimeCalendar.do?cmd=viewPsnlTimeCalendar");
	});

	// 출퇴근 버튼 토글
	$(".work-btn").click(function(e){
		e.preventDefault();

		if($(this).hasClass('on')) {
			prcMainEssWorkTime('1');
		} else if(!$(this).is(":disabled")) {
			prcMainEssWorkTime('2');
		}
	})

</script>