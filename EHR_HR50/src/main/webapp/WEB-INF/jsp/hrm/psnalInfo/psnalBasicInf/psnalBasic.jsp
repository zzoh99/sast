<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />

<!-- js -->
<script src="${ctx}/common/js/jquery/3.6.2/jquery-3.6.2.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" src="${ctx}/common/js/submain.js"></script>
<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>

<script type="text/javascript">
	$(function() {
		initBasic();
		initWelfare();
		initFamily();
		initLicense();
		initCareer();
		initExperience();
		initLangForeign();
		initTimeLine();
	});

	function openBasicDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalBasicLayer'
			, url : '/PsnalBasic.do?cmd=viewPsnalBasicLayer'
			, parameters : p
			, width : 1380
			, height :1000
			, title : '기본정보 상세보기'
			, trigger :[
				{
					name : 'psnalBasicLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openPostDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalPostLayer'
			, url : '/PsnalPost.do?cmd=viewPsnalPostLayer'
			, parameters : p
			, width : 1380
			, height :1000
			, title : '발령 상세보기'
			, trigger :[
				{
					name : 'psnalPostLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openEduDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalEduLayer'
			, url : '/PsnalEdu.do?cmd=viewPsnalEduLayer'
			, parameters : p
			, width : 1380
			, height :1000
			, title : '교육 상세보기'
			, trigger :[
				{
					name : 'psnalEduLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openContactDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalContactLayer'
			, url : '/PsnalContact.do?cmd=viewPsnalContactLayer'
			, parameters : p
			, width : 1000
			, height :650
			, title : '연락처 / 주소 상세보기'
			, trigger :[
				{
					name : 'psnalContactLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openLicenseDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalLicenseLayer'
			, url : '/PsnalLicense.do?cmd=viewPsnalLicenseLayer'
			, parameters : p
			, width : 1500
			, height :650
			, title : '자격 상세보기'
			, trigger :[
				{
					name : 'psnalLicenseLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openFamilyDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalFamilyLayer'
			, url : '/PsnalFamily.do?cmd=viewPsnalFamilyLayer'
			, parameters : p
			, width : 1400
			, height :650
			, title : '가족 상세보기'
			, trigger :[
				{
					name : 'psnalFamilyLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openSchoolDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalSchoolLayer'
			, url : '/PsnalSchool.do?cmd=viewPsnalSchoolLayer'
			, parameters : p
			, width : 1400
			, height :650
			, title : '학력 상세보기'
			, trigger :[
				{
					name : 'psnalSchoolLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openJusticeDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalJusticeLayer'
			, url : '/PsnalJustice.do?cmd=viewPsnalJusticeLayer'
			, parameters : p
			, width : 1400
			, height :1200
			, title : '상벌 상세보기'
			, trigger :[
				{
					name : 'psnalJusticeLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openOverStudyDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalOverStudyLayer'
			, url : '/PsnalOverStudy.do?cmd=viewPsnalOverStudyLayer'
			, parameters : p
			, width : 1400
			, height :1200
			, title : '해외연수 상세보기'
			, trigger :[
				{
					name : 'psnalOverStudyLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openAssuranceDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalAssuranceLayer'
			, url : '/PsnalAssurance.do?cmd=viewPsnalAssuranceLayer'
			, parameters : p
			, width : 1400
			, height :1200
			, title : '보증 상세보기'
			, trigger :[
				{
					name : 'psnalAssuranceLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openLangDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalLangLayer'
			, url : '/PsnalLang.do?cmd=viewPsnalLangLayer'
			, parameters : p
			, width : 1400
			, height :800
			, title : '어학 상세보기'
			, trigger :[
				{
					name : 'psnalLangLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openCareerDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalCareerLayer'
			, url : '/PsnalCareer.do?cmd=viewPsnalCareerLayer'
			, parameters : p
			, width : 1400
			, height :900
			, title : '경력 상세보기'
			, trigger :[
				{
					name : 'psnalCareerLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function openWelfareDetailLayer() {
		let p = {
			userId : '${ssnSabun}',
			userEnterCd : '${ssnEnterCd}'
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'psnalWelfareLayer'
			, url : '/PsnalWelfare.do?cmd=viewPsnalWelfareLayer'
			, parameters : p
			, width : 1400
			, height :1200
			, title : '병역/보훈/장애 상세보기'
			, trigger :[
				{
					name : 'psnalWelfareLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	function initBasic() {
		let data = ajaxCall( "${ctx}/PsnalBasic.do?cmd=getPsnalBasic", "",false).DATA;

		$('#empName').text(data.name);
		$('#jikweeNm').text(data.jikweeNm);
		$('#empSabun').text(data.sabun);
		$('#orgNm').text(data.orgNm);
		$('#hqOrgNm').text(data.hqOrgNm);
		$('#jikchakNm').text(data.jikchakNm);

		let birthDate = data.birYmd + '(만' + data.age + '세)'
		$('#birthDate').text(birthDate);
		$('#jobNm').text(data.jobNm);
		$('#hpAddr').text(data.hpAddr);
		$('#scAddr').text(data.scAddr);
		$('#imAddr').text(data.imAddr);
		$('#addr').text(data.addr);
		$('#statusNm').text(data.statusNm);

		$("#userFace").attr("src","/EmpPhotoOut.do?enterCd="+data.enterCd+"&searchKeyword="+data.sabun+"&t=" + (new Date()).getTime());
	}

	function initWelfare() {
		let armyData = ajaxCall( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareArmyList", "sabun=" + ${ssnSabun}, false).DATA[0];

		if (armyData == null) {
			$('#army').text('해당없음');
		} else {
			let army = armyData.armyNm + ' ' + armyData.transferNm + ' ' + armyData.dischargeCdNm;
			$('#army').text(army);
		}

		let bohunData = ajaxCall( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareBohunList", "sabun=" + ${ssnSabun}, false).DATA[0];
		if (bohunData == null) {
			$('#bohun').text('해당없음');
		} else {
			$('#bohun').text(bohunData.bohunNm);
		}

		let armyEduData = ajaxCall( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareArmyEduList", "sabun=" + ${ssnSabun}, false).DATA[0];
		if (armyEduData == null) {
			$('#armyEdu').text('비대상');
		} else {
			$('#armyEdu').text(armyEduData.targetYn === 'Y' ? '대상' : '비대상');
		}

		let jangData = ajaxCall( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareJangList", "sabun=" + ${ssnSabun}, false).DATA[0];
		if (jangData == null) {
			$('#jang').text('해당없음');
		} else {
			let jang = jangData.jangNm + ' - ' + jangData.jangGradeNm;
			$('#jang').text(jang);
		}
	}

	function initFamily() {
		let famList = ajaxCall( "${ctx}/PsnalFamily.do?cmd=getPsnalFamilyList", "sabun=" + ${ssnSabun}, false).DATA;

		let famHtml = '';
		famList.forEach(function(item, index) {
			famHtml += '<dd class="d-flex">' +
					'<span class="name">' + item.famNm + '</span>' +
					'<span class="mx-auto">' + item.famCdNm + '</span>' +
					'<span>' + formatDateForFamYmd(item.famYmd) + '</span>' +
					'</dd>';
		});

		$('#famList').append(famHtml);
	}

	function formatDateForFamYmd(yyyyMMdd) {
		const year = yyyyMMdd.substring(0, 4);
		const month = yyyyMMdd.substring(4, 6);
		const day = yyyyMMdd.substring(6, 8);
		const date = new Date(year, month - 1, day);

		const formattedDate = (date.getMonth() + 1) + "월 " + date.getDate() + "일";

		return formattedDate;
	}

	function initLicense() {
		let licenseList = ajaxCall( "${ctx}/PsnalLicense.do?cmd=getPsnalLicenseList", "sabun=" + ${ssnSabun}, false).DATA;
		let licenseHtml = '';

		licenseList.forEach(function (item, index) {
			licenseHtml += '<dd class="d-flex justify-content-between">' +
								'<span>' + item.licenseNm + '</span>' +
								'<span class="font-num">' + getPeriod(item.licSYmd, item.licEYmd) + '</span>' +
							'</dd>';
		});

		$('#licenseList').append(licenseHtml);
	}

	function initCareer() {
		let careerList = ajaxCall( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerList", "sabun=" + ${ssnSabun}, false).DATA;
		let careerHtml = '';

		careerList.forEach(function (item, index) {
			careerHtml += '<dd class="d-flex justify-content-between">' +
							'<span>' + item.cmpNm + '</span>' +
							'<span class="font-num">' + getPeriod(item.sdate, item.edate) + '</span>' +
						'</dd>';
		});

		$('#careerList').append(careerHtml);
	}

	function initExperience() {
		let experienceList = ajaxCall( "${ctx}/PsnalBasicInf.do?cmd=getPsnalExperienceList", "sabun=" + ${ssnSabun}, false).DATA;
		let experienceHtml = '';

		experienceList.forEach(function (item, index) {
			experienceHtml += '<dd class="d-flex justify-content-between">' +
					'<span>' + item.tfOrgNm + '</span>' +
					'<span class="font-num">' + getPeriod(item.sdate, item.edate) + '</span>' +
					'</dd>';
		});

		$('#experienceList').append(experienceHtml);
	}

	function initLangForeign() {
		let langList = ajaxCall( "${ctx}/PsnalLang.do?cmd=getPsnalLangForeignList", "sabun=" + ${ssnSabun}, false).DATA;
		let langHtml = '';

		langList.forEach(function (item, index) {
			let foreignNm = item.foreignNm;
			if (item.testPoint != '') {
				foreignNm += ' - ' + item.testPoint;
			}
			langHtml += '<dd class="d-flex justify-content-between">' +
					'<span>' + foreignNm + '</span>' +
					'<span class="font-num">' + getPeriod(item.staYmd, item.endYmd) + '</span>' +
					'</dd>';
		});

		$('#langList').append(langHtml);
	}

	function getPeriod(sYmd, eYmd) {
		let period = formatDate(sYmd);

		if (eYmd != '') {
			period += ' - ' + formatDate(eYmd);
		}

		return period;
	}

	function formatDate(inputDate) {
		if (inputDate.length !== 8) {
			return 'Invalid date format';
		}

		const year = inputDate.substring(0, 4);
		const month = inputDate.substring(4, 6);
		const day = inputDate.substring(6, 8);

		return year + '.' + month + '.' + day;
	}

	function initTimeLine() {
		let timeLineList = ajaxCall( "${ctx}/PsnalBasic.do?cmd=getPsnalTimeLineList", '', false).DATA;
		let timeLineHtml = '';

		const groupedByYear = timeLineList.reduce((acc, currentValue) => {
			const year = currentValue.yyyy;
			if (!acc[year]) {
				acc[year] = [];
			}
			acc[year].push(currentValue);
			return acc;
		}, {});

		const sortedYears = Object.keys(groupedByYear).sort((a, b) => b - a);

		sortedYears.forEach(year => {
			const yearDataList = groupedByYear[year];
			timeLineHtml += '<h3 class="h3 mt-4">' + year + '년</h3>'
						+ '<ul class="timeline">';

			yearDataList.forEach(data => {
				timeLineHtml += '<li class="row ' + data.color + '">'
					 		+ '<p class="font-num h4 font-weight-normal">' + data.mmdd + '</p>'
					 		+ '<div class="history">'
					 		+ '	<p><i class="mdi-ico round h3 pr-2">' + data.icon + '</i>' + data.key + '</p>'
					 		+ '	<p>' + data.historyNm + '</p>'
					 		+'</div>'
					 	+'</li>'
			});

			timeLineHtml += '</ul>';
		});


		$('#timeLineContainer').append(timeLineHtml);
	}

</script>
<div class="hr-container psnal-basic-wrap iframe-bg-aqua">
<%--	<button class="ico-btn bt-outline dark-btn d-flex align-items-center ml-auto mb-3" type="button"><i class="mdi-ico filled pr-2">visibility_off</i>가려진 정보 확인</button>--%>
	<div class="row">
		<div class="box-shadow max-box p-0">
			<div class="profile">
				<div class="d-flex align-items-center">
					<label for="file" class="profile-images-area">
						<div class="thumb"><img id="userFace" src="" alt="프로필 사진"></div>
						<i class="icon-stylus"></i>
					</label>
					<input type="file" name="file" id="file" class="d-none">
					<div class="d-flex align-items-center w-100">
						<p class="name pl-2 d-flex align-items-center">
							<span id="empName" class="h2 text-white fw-bold"></span>
							<span class="badge badge-rounded green ml-2" id="statusNm"></span>
						</p>
						<div class="info ml-auto">
							<p class="text-size-basic" id="jikweeNm"></p>
							<p class="text-boulder" id="empSabun"></p>
						</div>
					</div>
				</div>
				<div class="info psnal-info">
					<p class="text-size-basic text-white" id="hqOrgNm"></p>
					<p class="text-size-basic text-white" id="orgNm"></p>
					<p class="text-size-basic text-white" id="jikchakNm"></p>
				</div>
			</div>
			<div class="col max-box d-flex flex-auto overflow-hidden">
				<div class="scroll">
					<div>
						<div class="d-flex align-items-center">
							<i class="mdi-ico filled pr-1">person</i>
							<h3 class="h3">기본정보</h3>
							<div class="ml-auto">
								<button class="btn ico-btn aside-btn p-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="mdi-ico">more_horiz</i></button>
								<ul class="aside-option dropdown-menu dropdown-menu-right">
									<li onclick="javascript:openBasicDetailLayer()"><a class="dropdown-item">기본정보 상세보기</a></li>
									<li onclick="javascript:openContactDetailLayer()"><a class="dropdown-item">연락처/주소 상세보기</a></li>
								</ul>
							</div>
						</div>
						<ul class="profile-detail">
							<li>
								<dl>
									<dt>생년월일</dt>
									<dd><span id="birthDate"></span></dd>
								</dl>
								<dl>
									<dt>직무</dt>
									<dd><span id="jobNm"></span></dd>
								</dl>
							</li>
							<li>
								<dl>
									<dt>휴대폰</dt>
									<dd><span id="hpAddr"></span></dd>
								</dl>
								<dl>
									<dt>비상연락망</dt>
									<dd><span id="scAddr"></span></dd>
								</dl>
							</li>
							<li>
								<dl>
									<dt>이메일</dt>
									<dd><span id="imAddr"></span></dd>
								</dl>
							</li>
							<li>
								<dl>
									<dt>거주지</dt>
									<dd><span id="addr"></span></dd>
								</dl>
							</li>
						</ul>
					</div>
					<div class="pt-5">
						<div class="d-flex align-items-center">
							<i class="mdi-ico round pr-1">assignment_ind</i>
							<h3 class="h3">병역 / 보훈 / 장애</h3>
							<div class="ml-auto">
								<button class="btn ico-btn aside-btn p-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="mdi-ico">more_horiz</i></button>
								<ul class="aside-option dropdown-menu dropdown-menu-right">
									<li onclick="javascript:openWelfareDetailLayer()"><a class="dropdown-item">병역/보훈/장애 상세보기</a></li>
								</ul>
							</div>
						</div>
						<ul class="profile-detail">
							<li>
								<dl>
									<dt>병역사항</dt>
									<dd><span id="army"></span></dd>
								</dl>
								<dl>
									<dt>보훈사항</dt>
									<dd><span id="bohun"></span></dd>
								</dl>
							</li>
							<li>
								<dl>
									<dt>병역특례</dt>
									<dd><span id="armyEdu"></span></dd>
								</dl>
								<dl>
									<dt>장애사항</dt>
									<dd><span id="jang"></span></dd>
								</dl>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col p-0 max-box d-flex flex-column">
			<div class="col box-shadow flex-auto overflow-hidden">
				<div class="d-flex align-items-center sticky-top tit-sticky">
					<i class="mdi-ico filled pr-1">emoji_events</i>
					<h3 class="h3">자격 / 경력 / 어학</h3>
					<div class="ml-auto">
						<button class="btn ico-btn aside-btn p-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="mdi-ico">more_horiz</i></button>
						<ul class="aside-option dropdown-menu dropdown-menu-right">
							<li onclick="javascript:openLicenseDetailLayer()"><a class="dropdown-item">자격 상세보기</a></li>
							<li onclick="javascript:openCareerDetailLayer()"><a class="dropdown-item">경력 상세보기</a></li>
							<li onclick="javascript:openLangDetailLayer()"><a class="dropdown-item">어학 상세보기</a></li>
						</ul>
					</div>
				</div>
				<div class="scroll">
					<ul class="profile-detail">
						<li>
							<dl id="licenseList">
								<dt>자격</dt>
							</dl>
						</li>
						<li>
							<dl id="careerList">
								<dt>사외경력</dt>
							</dl>
						</li>
						<li>
							<dl id="experienceList">
								<dt>사내경력</dt>
							</dl>
						</li>
						<li>
							<dl id="langList">
								<dt>어학</dt>
							</dl>
						</li>
					</ul>
				</div>
			</div>
			<div class="col box-shadow mt-4">
				<div class="scroll">
					<div class="d-flex align-items-center">
						<i class="mdi-ico filled pr-1">group</i>
						<h3 class="h3">가족정보</h3>
						<div class="ml-auto">
							<button class="btn ico-btn aside-btn p-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="mdi-ico">more_horiz</i></button>
							<ul class="aside-option dropdown-menu dropdown-menu-right">
								<li onclick="javascript:openFamilyDetailLayer()"><a class="dropdown-item">가족정보 상세보기</a></li>
							</ul>
						</div>
					</div>
					<ul class="profile-detail">
						<li>
							<dl id="famList">
								<dt>가족</dt>
							</dl>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="col box-shadow max-box">
			<div class="d-flex align-items-center sticky-top tit-sticky">
				<i class="mdi-ico filled pr-1">view_timeline</i>
				<h3 class="h3">나의 타임라인</h3>
				<div class="ml-auto">
					<button class="btn ico-btn aside-btn p-0" type="button" data-toggle="dropdown" id="dropdownMenuButton" aria-haspopup="true" aria-expanded="false"><i class="mdi-ico">more_horiz</i></button>
					<ul class="aside-option dropdown-menu dropdown-menu-right">
						<li onclick="javascript:openPostDetailLayer()"><a class="dropdown-item">발령 상세보기</a></li>
						<li onclick="javascript:openEduDetailLayer()"><a class="dropdown-item">교육 상세보기</a></li>
						<li onclick="javascript:openSchoolDetailLayer()"><a class="dropdown-item">학력 상세보기</a></li>
						<li onclick="javascript:openJusticeDetailLayer()"><a class="dropdown-item">상벌 상세보기</a></li>
						<li onclick="javascript:openOverStudyDetailLayer()"><a class="dropdown-item">해외연수 상세보기</a></li>
						<li onclick="javascript:openAssuranceDetailLayer()"><a class="dropdown-item">보증 상세보기</a></li>
					</ul>
				</div>
			</div>
			<div class="scroll">
				<div id="timeLineContainer"></div>
			</div>
		</div>
	</div>
</div>

<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>