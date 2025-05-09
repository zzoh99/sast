<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html lang="ko"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- <meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=yes"> -->
<title>${ ssnAlias }</title>
<!--   STYLE	 -->
<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
<link rel="stylesheet" type="text/css" href="/common/${theme}/css/style.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css">
<link rel="stylesheet" type="text/css" href="/common/css/mainSub.css">
<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
<link rel="stylesheet" type="text/css" href="/common/css/override.css" />

<!--   JQUERY	 -->
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jScrollPane.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.jcarousel.min.js" type="text/javascript" charset="utf-8"></script>

<script src="${ctx}/common/plugin/D3/d3.min.js"		type="text/javascript"></script>

<!--   VALIDATION	 -->
<script src="${ctx}/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<!--  COMMON SCRIT -->
<script src="${ctx}/common/js/common.js"		type="text/javascript" charset="UTF-8"></script>
<script src="${ctx}/common/js/lang.js"			type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/cookie.js"		type="text/javascript"></script>

<!--  Ajax Error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<!--
<style>
.lock-size {
	overflow: hidden;
	height: 100%;
}

.lock-panel {

	position:absolute;
	top:50%;
	left:50%;
	width:400px;
	height:300px;
	background:#fff;
	z-index: 2000;
	margin:-200px 0 0 -150px;
}
</style> -->
<script type="text/javascript" src="${ctx}/common/js/mainSub.js"></script>
<script type="text/javascript" src="${ctx}/common/js/maincomSub.js"></script>
<script type="text/javascript">

var _pageObj = [];
var gPRow = "";
var pGubun = "";
var _ssnWidegtType = "${sessionScope.ssnWidgetType}";
var defaultTime = "${sessionScope.ssnTimeLock}";
var localeCd    = "${ssnLocaleCd}";
var enterCd     = "${ssnEnterCd}";

$(function() {

	var a=500;

	//$("#lockScreenDis").removeClass("show").addClass("hide");
	$("#lockScreenDis").removeClass("hide").addClass("show");
	$("#devMode").val("${sessionScope.devMode}");
	
	$("#btn_calendar_close").bind("click", function(event) {
		$(this).parent("calendar_on").hide();
	});

	$("#scrollMenu").jScrollPane();
	$("#ulUseMenu").jScrollPane();
	$("#ulRenewCont").jScrollPane();

	$("#userFace").attr("src","/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=${ssnSabun}"+"&t=" + (new Date()).getTime());

	getWidgetList( _ssnWidegtType );
	//setWidget();
	//setWidgetButton();
	setCalendarWidget();

	layoutHeader();

	//권한설정
	createAuthList("${ssnGrpCd}");
	timerInit();

	//회사변경
	createCompanyAuthList("${ssnEnterCd}");



<c:if test="${ssnLocaleCd !='' && ssnLangUseYn == 1}">
	selectLanguage("${ssnLocaleCd}");
	setLangeWidget();
</c:if>

	setThemeFont("${theme}","${wfont}","${maintype}");
	setLevelWidget();
	setFamilySite();
	setDrag();


	// 좌측 메뉴 생성
	createMajorMenu();

	indexResize();

	// 패밀리사이트 변동시 이벤트
	$("#familySite").change( function() {
		goUrl($(this).val()) ;
	});

	// 패밀리 사이트 클릭시 이벤트
	function goUrl(url) {
		if( url == "" ) return ;
		window.open(url) ;
		$("#familySite option:eq(14)").attr("selected", "selected");
	}

	$(".password a").click(function() {
		if(!isPopup()) {return;}

		openPopup('/Popup.do?cmd=pwChPopup','',650,320);
	});



	/* $("#lock_screen").click(disableTop); */
})



function reloadWidget( flag ){

	main_ListBox9( "" , "" , "box_" + flag );
	main_ListBox9( "" , "" , "box_" + flag );
	main_ListBox9( "" , "" , "box_" + flag );
	main_ListBox9( "" , "" , "box_" + flag );
	main_ListBox9( "" , "" , "box_" + flag );

}
function getPopupList() {
	$.each(_pageObj, function(idx, obj) {
		if(obj.obj.closed) {
			_pageObj.splice(idx, 1);
		}
	});

	return _pageObj;
}
</script>
</head>

<body>
	<!-- 스크롤 생기면 배경색이 전체로 안생겨서 넣어줌 2020.08.06 jylee  -->
	<div style="position: fixed; top:0; left:0; right: 0; bottom: 0; background-color: #f0f1f4 !important; "></div>

	<!-- index_wrap -->
	<div id="index_wrap">

		<!-- patten -->
		<div class="bg_pt01"></div>
		<div class="bg_pt02"></div>
		<div class="bg_pt03"></div>
		<!-- //patten end -->

		<form id="mainForm" name="mainForm" method="post"><!-- 메뉴값 넘기기 위한 form 수정 필요  -->
			<input type="hidden" 	id="mainDate"		name="mainDate"	  />
			<input type="hidden" 	id="murl"			name="murl"	  />
		</form>
		<form name=ssnChangeForm id=ssnChangeForm>
			<input type=hidden name=rurl id=rurl  >
			<!--
			<input type=hidden name=subGrpCd id=subGrpCd 			value="${ssnGrpCd}" >
			<input type=hidden name=subGrpNm id=subGrpNm 			value="${ssnGrpNm}" >
			<input type=hidden name=subDataRwType id=subDataRwType 	value="${ssnDataRwType}" >
			<input type=hidden name=subSearchType id=subSearchType 	value="${ssnSearchType}" >
			-->
			<!-- theme  -->
			<input type="hidden" name="subThemeType"		id="subThemeType" 		value="${theme}" >
			<input type="hidden" name="subFontType"			id="subFontType" 		value="${wfont}" >
			<input type="hidden" name="subMainType"   		id="subMainType" 		value="${maintype}" >

		</form>

		<!-- commonheader -->
		<div id="header">
		<c:set var="headerType"   value="main" />
		<!-- 20200911 메인설정이 메뉴바인 경우 권한 설정 활성화 : W는 위젯 -->
		<c:set var="mainMenuType" value="W" />
		<%@ include file="/WEB-INF/jsp/common/include/commonHeader.jsp"%>
		</div>
		<!-- commonheader end -->

		<!-- left_menu -->
		<div id="lnb">
			<div id="majorTop" class="onedepth_group" style="height: ${getMainMajorMenuListCount2021.count2021 > 0 ? 'calc(100% - 68px)' : 'calc(100% - 20px)'};">
			<ul class="inner" id="majorMenu1">
<!-- 좌측 메뉴 START -->
<c:forEach	var="item" items="${mainMajorMenuList}" varStatus="status">
	<c:if test="${item.mainMenuCd ne '20' && item.mainMenuCd ne '21'}">
				<li>
					<a class="lnb_icon${item.mainMenuCd}" murl="${item.murl}" mainMenuCd="${item.mainMenuCd}" grpCd="${item.grpCd}">${item.mainMenuNm}</a>
				</li>
	</c:if>
</c:forEach>
<!-- 좌측 메뉴 END -->
			</ul>
<!-- 하단 메뉴 START-->
<c:if test="${getMainMajorMenuListCount2021.count2021 > 0 }">
 			<div class="lnb_bott_menu">
 				<ul id="etcMenu" class="lnb_etc_menu">
	<c:forEach	var="item" items="${mainMajorMenuList}" varStatus="status">
		<c:if test="${item.mainMenuCd eq '20' || item.mainMenuCd eq '21'}">
				<a href="javascript:;" murl="${item.murl}" mainMenuCd="${item.mainMenuCd}" grpCd="${item.grpCd}">${item.mainMenuNm}</a>
		</c:if>
	</c:forEach>
				</ul>
			</div>
</c:if>
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
		</div>
		<!-- //left_menu end -->
		<div id="index_content">
			<div id="container" class="container">
				<!-- content -->
				<div class="main_wrap">
					<div id="sortable" class="main_content">
						<div class="floatL" style="width:260px; margin-right: 16px" >
							<!-- 프로필 -->
							<div style="width:100%;">
								<div id="profileBox" class="box_250">
									<div class="profile_group">
										<div class="profile_img">
											<img id="userFace" src="/common/images/common/img_left_photo.gif" alt="대표사진">
										</div>
										<div class="profile_txt mat5">
											<span class="profile_name">
												<b id="loginName">${ssnName} </b>
												<b id="loginJikweeNm">
													<c:if test="${ssnJikgubYn ne 'N'}">${ssnJikgubNm}</c:if>
												</b>
											</span>
											<p><span class="f_s11 f_gray_9">최근접속 : ${ ssnLastLogin }</span></p>
										</div>
									</div>
									<div class="profile_btn_group">
										<ul class="profile_btn">
											<li style="background: none;">
												<a id="authMgr" class="authority_sett pointer">${ssnGrpNm}</a>
											</li>
											<li class="password">
												<a class="pw_chg pointer">비밀번호변경</a>
											</li>
										</ul>
										<!-- 권한설정  pop -->
										<div id="levelWidgetMain1" class="pop_authority" style="display: none; left: 60px;">
											<h3 class="pop_title">권한설정</h3>
											<ul id="authList1" class="pop_level_lst">
											</ul>
											<div class="main_pop_btn">
												<a id="levelCancel" class="pop_btn pop_authority_closer">취소</a>
											</div>
										</div>
										<!--//권한설정 pop end -->
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- quick_menu -->
					<div class="floating">
						<ul id="workflowMenu" class="quick_menu">
						</ul>
					</div>
					<!-- //quick_menu end -->
				</div>
				<!-- //content end -->
			</div>
		</div>

		<!-- footer -->
		<div id="footer">
			<div class="copyright">
				<!-- COPYRIGHT ISU SYSTEM Co. Ltd. ALL RIGHT RESERVED. -->
				<%-- COPYRIGHT ${ssnAlias} ALL RIGHT RESERVED. --%>
				${ssnCopyright}
			</div>
		</div>
		<!--//footer end -->
	</div>
	<!--//wrap end -->
	
<c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
</c:if>

<%-- [START] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
<%@ include file="/WEB-INF/jsp/common/include/commonNotification.jsp"%>
<%-- [END] 개인 알림 공통 토스트 메시지 기능 관련 추가 (2022.03.08) --%>
</body>
</html>
