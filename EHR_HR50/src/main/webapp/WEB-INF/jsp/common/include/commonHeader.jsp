<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="lockTime" value="${sessionScope.ssnTimeLock}"/>
<script type="text/javascript">
	var _connect_E_ = "${ssnEnterCd}";
	var _connect_A_ = "${authPg}";
	var _connect_I_ = "${ssnSabun}";
</script>
<script type="text/javascript" src="/common/js/commonHeader.js"></script>

			<div class="header_wrap">
				<h1 id="main_logo">
					<a id="logo" href="/"><!-- 이수시스템 --></a>
				</h1>
				<!-- 임직원 검색 -->
				<div class="member_search">
					<label for="topKeyword"></label>
					<input type="text" id="topKeyword" placeholder="<tit:txt mid='empSearch' mdef='임직원 검색'/>">
					<a class="pointer"><img id="searchUser" src="/common/images/main/btn_search.png" alt="검색하기"></a>
				</div>
				<!-- //임직원 검색 end -->
<c:if test="${ hostIp eq '127.0.0.1' || hostIp eq '0:0:0:0:0:0:0:1' }">
	<c:if test="${ ssnAdmin eq 'Y' && ssnGuideModeYn eq 'Y' }">
				<div style="position: absolute;top:-3px; left:250px;">
					<a id="goDevGuide" class="btn_gnb_home pointer gray"><font style="color:#000;letter-spacing:0;">개발가이드</font></a>
		<c:if test="${ headerType eq 'sub' }">
					<a id="goGrcode" class="btn_gnb_home pointer gray"><font style="color:#000;letter-spacing:0;">공통코드관리</font></a>
					<a id="goQuery" class="btn_gnb_home pointer gray"><font style="color:#000;letter-spacing:0;">쿼리자동생성</font></a>
		</c:if>
					<input type="text" id="devTabUrl" style="width:400px; padding:1px; border:0px; background-color:#FFF5C8; color:blue; font-size:9px; font-family: Consolas, Arial;" /><!-- 개발자 모드 : 탭 URL 표시  -->
				</div>
	</c:if>
</c:if>
				<div style="position: absolute; top:24px; left:250px;">
					<span id="pageLocation" style="height:24px; line-height:24px;"></span>
				</div>

				<!-- global menu -->
				<ul class="gnb">
					<!-- li id="pageLocation" class="location back_none" ></li -->
<c:if test="${ hostIp eq '127.0.0.1' || hostIp eq '0:0:0:0:0:0:0:1' }">
	<c:if test="${ssnAdmin eq 'Y' && ssnDevModeYn eq 'Y' }">
<%-- 개발자 모드 추가 - 20170328 yukpan Start --%>
		<c:if test="${ sessionScope.devMode eq 'A' || sessionScope.devMode eq 'L' }">
					<li id="devArea" >
						<input type="button" onclick="javascript:openLocalePop();" value="다국어팝업"/>
					</li>
		</c:if>
					<li>
		<c:if test="${ sessionScope.devMode eq 'A' }">
						<!-- // DevModeUrl 표기 여부를 컨트롤 할 Checkbox 추가 - 20210417 mschoe Start -->
						<label for="chkDevModeUrl">
							<input type="checkbox" id="chkDevModeUrl" name="chkDevModeUrl" class="checkbox" <c:if test="${sessionScope.chkDevModeUrl==null || sessionScope.chkDevModeUrl=='' || sessionScope.chkDevModeUrl=='Y'}">checked="checked"</c:if> />
							URL 표기
						</label>
						<!-- // DevModeUrl 표기 여부를 컨트롤 할 Checkbox 추가 - 20210417 mschoe End -->
		</c:if>
						<select id="devMode" name="devMode" >
							<option value="">개발자모드X</option>
							<option value="A">모든권한모드</option>
							<option value="L">언어모드</option>
						</select>
					</li>
<%-- 개발자 모드 추가 - 20170328 yukpan End --%>
	</c:if>
</c:if>

<c:if test="${ headerType eq 'sub' }">
					<li>
						<a id="goHome" class="gnb_icon home"><msg:txt mid='goHome' mdef='HOME'/></a>
					</li>
</c:if>
<c:if test="${ssnLocaleCd != '' && ssnLangUseYn == '1' }">
<%--
					<li class="back_none">
						<div class="infoMsgBox" style="top:35px; padding:0px; display:none; color:#ff0000;"></div>
						<btn:a id="alertInfo" mid="alertNotice" mdef="알림"/>
					</li>
--%>
					<li style="position:relative;">
						<a class="language">
<%--&lt;%&ndash; --%>
<%--							<img src="/common/images/icon/flags_${ssnLocaleCd}.png" style="vertical-align:text-bottom;" id="langFlag" />--%>
<%--							<span id="chgComp">${ssnLocaleCountry}</span>--%>
<%--&ndash;%&gt;--%>
							<span id="chgComp">${ssnLocaleLanguage}</span>
						</a>
						<!-- <a id="chgComp" class="btn_gnb_down pointer">상세보기</a> -->
						<!-- 권한설정  pop -->
						<div id="chgCompMain" class="pop_authorityL">
							<p class="pop_title"><tit:txt mid='langSetting' mdef='언어 설정'/></p>
							<ul id="langeList" class="pop_level_lst">
							</ul>
							<div class="main_pop_btn">
								<a id="langeCancel" class="pop_btn pop_authority_close"><tit:txt mid='112396' mdef='취소'/></a>
							</div>
						</div>
					</li>
</c:if>
<%--
					<li>
						<div class=langeWidget>
							<div id="langeWidgetMain">
								<div class="shadow"></div>
								<div class="content">
									<div class="title"><tit:txt mid='langSetting' mdef='언어 설정'/></div>
									<ul  id="langeList"></ul>
									<div class="button">
										<a id="langeCancel" css="gray" mid="cancel" mdef="취소"/>
									</div>
								</div>
							</div>
						</div>
						<img src="/common/images/icon/flags_${ssnLocaleCd}.png" style="vertical-align:text-bottom;" id="langFlag" /><a id="langeMgr" style="padding-right: 10px;"> ${ssnLocaleCountry}</a>
					</li>
--%>
					<c:if test="${ ssnAdminYn == 'Y' }">
					<li>
						<a class="company_change">
							<span>${ssnEnterNm}</span>
						</a>
						<a id="chgCompany" class="btn_gnb_down pointer mar10">상세보기</a>
					</li>
					</c:if>

<!-- 20200911 메인설정이 메뉴바인 경우 권한 설정 활성화 -->
<c:if test="${ headerType eq 'sub' || mainMenuType eq 'M' }">
					<li style="position:relative;">
					<!-- <li> -->
						<a class="gnb_icon authority">
							<span id="chgGrp">${ssnGrpNm}</span>
						</a>
						<!--// 권한설정  pop -->
						<div id="levelWidgetMain" class="pop_authority">
							<p class="pop_title"><tit:txt mid='authSetting' mdef='권한 설정'/></p>
							<ul class="pop_level_lst" id="authList1"></ul>
							<a id="levelCancel" class="pop_btn pop_authority_close"><tit:txt mid='112396' mdef='취소'/></a>
						</div>
						<!--//권한설정 pop end -->
					</li>
</c:if>
<c:if test="${ sessionScope.ssnMainSitemapViewYn eq 'Y' }">
					<li style="position:relative;">
						<a id="viewMenuMap" class="pointer language sitemap" >전체메뉴</a>
					</li>
</c:if>
<c:if test="${ sessionScope.ssnMainSearchmenuViewYn eq 'Y' }">
					<li style="position:relative;">
						<a id="viewMenuCd" class="pointer language search" >메뉴검색</a>
					</li>
</c:if>
					<li class="">
						<a id="alertInfo" class="pointer language alertInfo" >알림</a>
					</li>
					
 					<li class="hide" id="lockScreenDis">
						<a id="lockScreen" class="gnb_icon pc_hold"><tit:txt mid='2019061300070' mdef='화면잠금'/></a>
					</li>
					<li class="back_none">
						<a id="txtTimer" class="time_delay_txt"><!-- 04:59:23 --></a>
						<a id="lockReset" href="javascript:resetTimer();" class="gnb_icon time_delay" title="<tit:txt mid='2019061300071' mdef='시간연장'/>"><tit:txt mid='2019061300071' mdef='시간연장'/></a>
					</li>
					<c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
						<li class="back_none">
							<a id="chgUser" class="gnb_icon user_modify" title="<tit:txt mid='chgUser' mdef='사용자 변경 로그인'/>"><tit:txt mid='chgUser' mdef='사용자 변경 로그인'/></a>
						</li>
					</c:if>
					<li class="back_none">
						<a id="themeWidget" class="gnb_icon theme_sett" title="<tit:txt mid='setTheme' mdef='테마설정'/>"><tit:txt mid='setTheme' mdef='테마설정'/></a>
					</li>
					<li class="back_none">
						<a id="logout" class="gnb_icon logout" title="<tit:txt mid='114568' mdef='로그아웃'/>"><tit:txt mid='114568' mdef='로그아웃'/></a>
					</li>
				</ul>
				<!-- //global menu end -->
				<div class="pop_theme" id="themeWidgetMain">
					<p class="pop_title"><tit:txt mid='113583' mdef='테마 설정'/></p>
					<ul class="pop_theme_lst">
						<li class="theme1" theme="theme1">
							<p>
								<span></span>AquaBlue
							</p>
						</li>
						<li class="theme2" theme="theme2">
							<p class="theme_on">
								<span></span>Green
							</p>
						</li>
						<li class="theme3" theme="theme3">
							<p>
								<span></span>Blue
							</p>
						</li>
						<li class="theme4" theme="theme4">
							<p>
								<span></span>Orange
							</p>
						</li>
						<li class="theme5" theme="theme5">
							<p>
								<span></span>LeafGreen
							</p>
						</li>
						<li class="theme6" theme="theme6">
							<p>
								<span></span>EarthBrown
							</p>
						</li>
					</ul>
					<p class="pop_title2"><tit:txt mid='112511' mdef='폰트 설정'/></p>
					<ul class="pop_theme_font">
						<li>
							<input type="checkbox" checked="checked" id="nanum" value="nanum">
							<label for="nanum"><span><tit:txt mid='112169' mdef='나눔고딕'/></span></label>
						</li>
						<li>
							<input type="checkbox" id="notosans" value="notosans">
							<label for="notosans"><span><tit:txt mid='2019061400004' mdef='본고딕'/></span></label>
						</li>
						<li>
							<input type="checkbox" id="malgun" value="malgun">
							<label for="malgun"><span><tit:txt mid='2019061400005' mdef='맑은고딕'/></span></label>
						</li>
					</ul>
					<p class="pop_title2"><tit:txt mid='112511' mdef='메인설정'/></p>
					<ul class="pop_main_type">
						<li>
							<input type="checkbox" checked="checked" id="mainMenuTypeM" value="M">
							<label for="mainMenuTypeM"><span>메뉴바</span></label>
						</li>
						<li>
							<input type="checkbox" id="mainMenuTypeW" value="W">
							<label for="mainMenuTypeW"><span>위젯</span></label>
						</li>
					</ul>
					<p class="pop_theme_txt">
					<tit:txt mid='114275' mdef='테마 or 폰트설정 : [확인]클릭 시'/>
					<tit:txt mid='113585' mdef='홈 화면으로 이동 후 반영됩니다.'/>
					<!-- 테마 or 폰트 설정 : [확인]클릭 시 홈 화면으로 이동 후 반영됩니다. -->
					</p>
					<a class="pop_btn_point" id="themeOk"><tit:txt mid='104435' mdef='확인'/></a><a class="pop_btn pop_theme_close"  id="themeCancel"><tit:txt mid='112396' mdef='취소'/></a>
				</div>
			</div>
<%-- [2022.03.08] 기능 충돌로 인해 사용 안함
<!-- 개인별 알림 2020.06.09 -->
			<div id="dialogAlertInfo" style="display:none;">
				<iframe name="iframeAlertInfo" id="iframeAlertInfo" frameborder="0" width="100%" height="100%"></iframe>
			</div>
 --%>
<%-- 알림 메시지 목록 레이어 박스 영역 --%>
			<div id="panalAlertDiv" class="panalAlert" style="display:none;">
				<div class="panalAlert_title">
					<a class="title_icon"></a>
					<span style="font-size:18px">알 림</span>
					<a class="title_close"></a>
				</div>
				<ul id="panalAlert"></ul>
<c:if test="${ ssnNotificationUseYn eq 'Y' }">
				<div class="toastMsgDiv">
					<div class="title alignL">
						<span>개인 알림</span>
						<a href="javascript:deleteAllToastMsg('all');" class="btn_deleteAllToastMsg">[알림 모두 지우기]</a>
					</div>
					<div class="toastMsgBox">
						<ul class="toastMsgList"></ul>
					</div>
				</div>
</c:if>
				<div class="panalAlert_todayClose mal25">
					<span><label for="panalAlertTodayClose">오늘 하루 그만보기</label></span>
					<input type="checkbox" id="panalAlertTodayClose" name="panalAlertTodayClose" />
				</div>
			</div>
<%-- 알림 메시지 목록 레이어 박스 영역 --%>