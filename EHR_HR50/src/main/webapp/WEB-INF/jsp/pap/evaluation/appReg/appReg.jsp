<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/jquery/jquery.inputmask.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.inputmask.numeric.extensions.js" type="text/javascript" charset="utf-8"></script>

<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>
<link href="/assets/plugins/slick-1.8.1/slick.css" rel="stylesheet">
<link href="/assets/plugins/slick-1.8.1/slick-theme.css" rel="stylesheet">
<script type="text/javascript" src="/assets/plugins/slick-1.8.1/slick.min.js"></script>
<script type="text/javascript" src="/assets/plugins/slimScroll-1.3.8/jquery.slimscroll.min.js"></script>

<style type="text/css">
	.hr-container .team {font-size:13px; color: #384152 !important;}
	.hr-container .select select{font-size: 12px; border: 1px solid #ced4da; border-radius: 0.25rem; padding: .375rem .75rem;}
	.hr-container .group {padding-bottom:16px; padding-right:16px; padding-left: 16px;}
	.hr-container .group.year {padding-top:16px;}
	.hr-container .group:not(:first-child) {margin-bottom:24px; padding-top:24px;}

	.hr-container .group:not(:last-child) {
		border-bottom: 1px solid #e0e0e0;
	}

	.hr-container .group .subject {
		font-size: 16px;
		font-weight: 700;
		color: #384152;
	}

	.hr-container .box .box-list {
		padding: 16px 20px;
		margin-top: 10px;
		border: solid 1px #dedede;
		border-radius: 6px;
	}

	.hr-container .box .box-list.active {
		border-color: #167ef7;
		background-color: #f6faff;
	}

	.hr-container .info .name {
		font-size: 15px;
		font-weight: 500;
		color: #384152;
		margin-left: 4px;
	}

	.hr-container .info .position {
		font-size: 14px;
		color: #777e87;
		margin-left: 4px;
	}

	.hr-container .app-seq-box .wrap_chart {
		position: relative;
		margin-top: -8px;
		margin-bottom: -8px;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item {
		position: relative;
		width: 88px;
		font-size: 16px;
		margin: 0 auto;
		animation: donutfade 1s;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-hole {
		fill: #f6faff;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-ring {
		stroke: #b1d4fd;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-segment {
		stroke: #167ef7;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-text {
		position: absolute;
		top: 28px;
		width: 100%;
		fill: #384152;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-text .donut-data {
		font-size: 14px;
		font-weight: bold;
		line-height: 1;
		letter-spacing: -0.42px;
		text-align: center;
		color: #384152;
	}

	.hr-container .app-seq-box .wrap_chart .svg-item .donut-text .donut-total {
		margin-top: 4px;
		font-size: 12px;
		font-weight: 400;
		line-height: 1;
		text-align: center;
		text-anchor: middle;
		color: #777e87;
	}

	.hr-container .depth2 .app-emp-box {
		padding: 16px;
	}

	.hr-container .depth2 .submission-wrap {
		margin-top: 10px;
	}

	.hr-container .app-nth-area {
		padding-left: 16px;
		padding-right: 16px;
		padding-bottom: 16px;
	}

	.app-emp-box-list .box-list .profile {
		position: relative;
	}

	.app-emp-box-list .box-list .profile .profile-info {
		margin-left: 14px;
	}

	.mt-20 {
		margin-top: 20px;
	}
</style>

<script type="text/javascript">

	let APP_DATA = {
		appList: []
		, currIndex: null
		, currAppData: {}
	};

	let SEQ_DATA = {
		seqList: []
		, currIndex: null
		, currSeqData: {}
	};

	let EMP_DATA = {
		empList: []
		, currIndex: null
		, currEmpData: {}
	};

	let OBJ_DATA = {
		objData: {}
	}

	$(function() {
		// slimScroll 적용.
		$('.hr-container .scroll').slimScroll({
			height: '100vh'
			, wheelStep: 5
			, disableFadeOut: true
		});

		// 평가 가능한 평가년도 조회
		const appYearList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppYearList&searchAppStepCd=5",false).codeList, ""); // 평가년도
		$("#searchYear").on('change', function(e) {
			// 평가년도의 목표등록 가능한 평가명 리스트 조회
			doAction("INIT_APP");
		});
		$("#searchYear").html(appYearList[2]).change();
	});

	async function doAction(type) {
		if (type === "INIT_APP") {
			// 평가년도 영역 초기화
			await setAppData();
			await setAppSeqData();
			await setAppEmpData();
			setAppForm();
			setAppSeqForm();
			setAppEmpForm();
		} else if (type === "INIT_SEQ") {
			await setAppSeqData();
			await setAppEmpData();
			setAppSeqForm();
			setAppEmpForm();
		} else if (type === "INIT_APP_EMP") {
			// 평가대상자 영역 초기화
			await setAppEmpData();
			setAppEmpForm();
		}
	}

	// 평가ID 데이터 조회
	async function setAppData(activeIndex) {
		if (!activeIndex) {
			console.log("setAppData>> activeIndex is " + activeIndex);
			APP_DATA.appList = await getAppData();
			activeIndex = 0;
		}

		APP_DATA.currIndex = activeIndex;

		if (APP_DATA.appList && APP_DATA.appList.length > 0) {
			APP_DATA.currAppData = APP_DATA.appList[activeIndex];
		}
	}

	// 평가차수 데이터 조회
	async function setAppSeqData(activeIndex) {
		if (!activeIndex) {
			console.log("setAppSeqData>> activeIndex is " + activeIndex);
			SEQ_DATA.seqList = await getAppSeqData();
			activeIndex = 0;
		}

		SEQ_DATA.currIndex = activeIndex;

		if (SEQ_DATA.seqList && SEQ_DATA.seqList.length > 0) {
			SEQ_DATA.currSeqData = SEQ_DATA.seqList[activeIndex];
		}
	}

	// 평가대상자 데이터 조회
	async function setAppEmpData(activeIndex) {
		if (!activeIndex) {
			console.log("setAppEmpData>> activeIndex is " + activeIndex);
			EMP_DATA.empList = await getAppEmpData();
			activeIndex = 0;
		}

		console.log("setAppEmpData >>");
		console.log(EMP_DATA);

		EMP_DATA.currIndex = activeIndex;

		if (EMP_DATA.empList && EMP_DATA.empList.length > 0) {
			EMP_DATA.currEmpData = EMP_DATA.empList[activeIndex];
		}
	}

	/**
	 * 평가명 List 초기화
	 */
	function setAppForm() {
		// 평가명 List내 모든 항목 삭제.
		const appListBox = $("div.app-list");
		appListBox.empty();

		// carousel 이벤트 추가.
		if(APP_DATA.appList.length > 0) {

			// 평가년도 ID form 데이터 추가
			APP_DATA.appList.forEach((obj, idx) => {
				const div =
						$(	"<div class=\"slick-item box-list\">" +
							"	<span class=\"badge\"><i class=\"breadcrumb-item\"></i>" + obj.statusNm + "</span>" +
							"	<p class=\"subject\">" + obj.appraisalNm + "</p>" +
							"	<span class=\"date\"><i class=\"mdo-ico\">event_note</i>" + obj.appSYmd + " ~ " + obj.appEYmd + "</span>" +
							"</div>");

				if (obj.closeYn !== "Y")
					div.addClass("ing");

				appListBox.append(div);
			});

			appListBox.slick({
				arrows: false,
				responsive: true,
				dots: true,
				initialSlide: APP_DATA.currIndex
			}).off().on("beforeChange", function(e, s, currIndex, nextIndex) {
				// 평가년도 영역 변경 시
				console.log("beforeChange!!");
				if (nextIndex !== APP_DATA.currIndex) {
					APP_DATA.currIndex = nextIndex;
					APP_DATA.currAppData = APP_DATA.appList[APP_DATA.currIndex];
					doAction("INIT_STEP");
				}
			});
		}
	}

	/**
	 * 평가단계 List 초기화
	 */
	function setAppSeqForm() {
		// 평가단계 List내 모든 항목 삭제.
		const appSeqBox = $("div#appSeqArea>ul.app-seq-box");
		appSeqBox.empty();

		console.log("setAppSeqForm >>");
		console.log(SEQ_DATA.seqList);

		if (SEQ_DATA.seqList) {

			SEQ_DATA.seqList.forEach((obj, idx) => {
				if (!obj) return;

				let liTag;

				if (obj.appSeqCd === "0") {
					// 평가차수 중 본인평가
					liTag =
							$(	"<li class=\"box-list\" index=\"" + idx + "\">" +
								"	<p class=\"subject d-flex align-items-center\">" + obj.appSeqNm + "<span class=\"team divider d-flex align-items-center\">" + obj.appOrgNm + "</span><span class=\"data\"></span></p>" +
								"	<div class=\"d-flex align-items-center flex-wrap\">" +
								getStatusIconTagText(obj.statusCd, "d-flex align-items-center") +
								"		<ul class=\"detail-head dot\">" +
								"			<li>업적 <span>" + obj.mboTAppSelfPoint + "(" + obj.mboTAppSelfClassCd + ")</span></li>" +
								"			<li>역량 <span>" + obj.compTAppSelfPoint + "(" + obj.compTAppSelfClassCd + ")</span></li>" +
								"			<li>종합 <span>" + obj.appSelfPoint + "(" + obj.appSelfClassCd + ")</span></li>" +
								"		</ul>" +
								"	</div>" +
								"</li>");
				} else {
					// 평가차수 중 N차 평가
					liTag =
							$(	"<li class=\"box-list\" index=\"" + idx + "\">" +
								"	<div class=\"clearfix\">" +
								"		<div class=\"float-left\">" +
								"			<span class=\"subject\">" + obj.appSeqNm + "</span>" +
								getStatusIconTagText(obj.statusCd, "d-flex align-items-center mt-20") +
								"		</div>" +
								"		<div class=\"wrap_chart float-right\">" +
								"			<div class=\"svg-item\">" +
								"				<svg width=\"100%\" height=\"100%\" viewBox=\"0 0 40 40\" class=\"donut\">" +
								"					<circle class=\"donut-hole\" cx=\"20\" cy=\"20\" r=\"15.91549430918954\"></circle>" +
								"					<circle class=\"donut-ring\" cx=\"20\" cy=\"20\" r=\"15.91549430918954\" fill=\"transparent\" stroke-width=\"4\"></circle>" +
								"					<!-- stroke-dasharray 값을 바꾸면 됨 -->" +
								"					<circle class=\"donut-segment\" cx=\"20\" cy=\"20\" r=\"15.91549430918954\" fill=\"transparent\" stroke-width=\"4\" stroke-dasharray=\"0 100\" stroke-dashoffset=\"25\" data-tot-tgt-cnt=\"" + obj.totCnt + "\" data-conf-tgt-cnt=\"" + obj.finCnt + "\"></circle>" +
								"				</svg>" +
								"				<div class=\"donut-text\">" +
								"					<div class=\"donut-data\">" + obj.totCnt + "</div>" +
								"					<div class=\"donut-total\">" + obj.finCnt + "명</div>" +
								"				</div>" +
								"			</div>" +
								"		</div>" +
								"	</div>" +
								"</li>");
				}

				if (liTag)
					appSeqBox.append(liTag);
			});

			console.log(appSeqBox);
			appSeqBox.find("li.box-list").first().addClass("active");

			// 클릭 이벤트 등록
			appSeqBox.find("li.box-list").off("click").on("click", function(e) {
				// active 상태 변경.
				appSeqBox.find("li.box-list.active").removeClass("active");
				$(this).addClass("active");

				SEQ_DATA.currIndex = $(this).attr("index");
				SEQ_DATA.currSeqData = SEQ_DATA.seqList[SEQ_DATA.currIndex];
				console.log("!!클릭이벤트");
				console.log($(this).attr("index"));
				console.log(SEQ_DATA.currSeqData);
				doAction("INIT_APP_EMP");
			});

			$.each(appSeqBox.find("li.box-list div.progress-bar"), function(idx, obj) {
				console.log($(obj).closest("li.box-list"));
				const rate = $(obj).closest("li.box-list").data("compRate");
				console.log(rate);
				$(obj).prop("aria-valuenow", rate).css("width", rate);
			});
		}
	}

	// 평가대상자 view 초기화
	function setAppEmpForm() {

		// 목표승인 대상자 List내 모든 항목 삭제.
		const appEmpArea = $("div.app-emp-area");
		const appEmpBox = appEmpArea.find("div.app-emp-box");
		appEmpBox.find("div.app-emp-box-list").remove();

		console.log("setAppEmpForm>>");
		console.log(EMP_DATA.currEmpData);
		if (SEQ_DATA.currSeqData.appSeqCd === "0") {
			// 본인평가일 경우 평가대상자 영역 hide
			appEmpArea.addClass("hide");
			return;
		} else {
			appEmpArea.removeClass("hide");
		}

		if (EMP_DATA.empList) {
			const appEmpBoxFinList =
					$("<div class=\"app-emp-box-list\">" +
							"	<div class=\"approval-title-wrap\">" +
							"		<p class=\"team d-inline-block\">평가완료</p>" +
							"	</div>" +
							"</div>"); // 평가완료 대상자 박스
			const appEmpBoxNoFinList =
					$("<div class=\"app-emp-box-list\">" +
							"	<div class=\"approval-title-wrap\">" +
							"		<p class=\"team d-inline-block\">미평가</p>" +
							"	</div>" +
							"</div>"); // 미평가 대상자 박스

			EMP_DATA.empList.forEach((obj, idx) => {
				let boxTag = "";
				boxTag += "<ul class=\"box\">";
				boxTag += "	<li class=\"box-list\" index=\"" + idx + "\">";
				boxTag += "		<div class=\"profile clearfix\">";

				if (obj.appraisalYn === "Y") {
					// 평가완료
					if (SEQ_DATA.currSeqData.appSeqCd === "1") // 1차평가
						boxTag += "		<div class=\"status text-center\">" + obj.app1stRank + "</div>";
					else if (SEQ_DATA.currSeqData.appSeqCd === "2") // 2차평가
						boxTag += "		<div class=\"status text-center\">" + obj.app2ndRank + "</div>";
					else if (SEQ_DATA.currSeqData.appSeqCd === "6") // 3차평가
						boxTag += "		<div class=\"status text-center\">" + obj.app3rdRank + "</div>";
				}

				boxTag += "			<div class=\"thumb float-left\"><img src=\"/EmpPhotoOut.do?searchKeyword=" + obj.sabun + "\" alt=\"프로필\"/></div>";
				boxTag += "			<div class=\"profile-info float-left\">";
				boxTag += "				<span class=\"name\">" + obj.name + "</span>";
				boxTag += "				<span class=\"position\">" + obj.jikweeNm + "</span>";
				boxTag += "			</div>";
				boxTag += "		</div>";
				boxTag += "		<div class=\"submission-wrap\">";
				boxTag += getStatusIconTagText(obj.appraisalYn);
				boxTag += "			<span class=\"dot\"></span>";

				if (obj.mboTargetYn === "Y") {
					// 업적평가 대상자일 경우에만 표기.
					boxTag += "			<span class=\"label\">업적</span>";
					boxTag += "			<span class=\"desc\">";

					if (SEQ_DATA.currSeqData.appSeqCd === "1") // 1차평가
						boxTag += obj.mboTApp1stPoint + "(" + obj.mboTApp1stClassCd + ")";
					else if (SEQ_DATA.currSeqData.appSeqCd === "2") // 2차평가
						boxTag += obj.mboTApp2ndPoint + "(" + obj.mboTApp2ndClassCd + ")";
					else if (SEQ_DATA.currSeqData.appSeqCd === "6") // 3차평가
						boxTag += obj.mboTApp3rdPoint + "(" + obj.mboTApp3rdClassCd + ")";

					boxTag += "			</span>";
				}

				if (obj.compTargetYn === "Y") {
					// 역량평가 대상자일 경우에만 표기.
					boxTag += "			<span class=\"label\">역량</span>";
					boxTag += "			<span class=\"desc\">";

					if (SEQ_DATA.currSeqData.appSeqCd === "1") // 1차평가
						boxTag += obj.compTApp1stPoint + "(" + obj.compTApp1stClassCd + ")";
					else if (SEQ_DATA.currSeqData.appSeqCd === "2") // 2차평가
						boxTag += obj.compTApp2ndPoint + "(" + obj.compTApp2ndClassCd + ")";
					else if (SEQ_DATA.currSeqData.appSeqCd === "6") // 3차평가
						boxTag += obj.compTApp3rdPoint + "(" + obj.compTApp3rdClassCd + ")";

					boxTag += "			</span>";
				}

				// 종합평가 정보
				boxTag += "			<span class=\"label\">종합</span>";
				boxTag += "			<span class=\"desc\">";

				if (SEQ_DATA.currSeqData.appSeqCd === "1") // 1차평가
					boxTag += obj.app1stPoint + "(" + obj.app1stClassCd + ")";
				else if (SEQ_DATA.currSeqData.appSeqCd === "2") // 2차평가
					boxTag += obj.app2ndPoint + "(" + obj.app2ndClassCd + ")";
				else if (SEQ_DATA.currSeqData.appSeqCd === "6") // 3차평가
					boxTag += obj.app3rdPoint + "(" + obj.app3rdClassCd + ")";

				boxTag += "			</span>";

				boxTag += "		</div>";
				boxTag += "	</li>";
				boxTag += "</ul>";

				if (obj.appraisalYn === "Y") {
					// 평가완료
					appEmpBoxFinList.append($(boxTag));
				} else {
					// 미평가
					appEmpBoxNoFinList.append($(boxTag));
				}
			});
			appEmpBox.append(appEmpBoxNoFinList);
			appEmpBox.append(appEmpBoxFinList);

			appEmpBox.find(".app-emp-box-list").first().find("li.box-list").first().addClass("active");

			// 클릭 이벤트 등록
			appEmpBox.find("div.app-emp-box-list>ul.box")
					.off('click')
					.on('click', function(e) {
						appEmpBox.find("div.app-emp-box-list>ul.box").removeClass("active");
						$(this).addClass("active");

						EMP_DATA.currIndex = $(this).attr("index");
						EMP_DATA.currEmpData = EMP_DATA.empList[EMP_DATA.currIndex];
						doAction("INIT_OBJ");
					});
		}
	}


	function getStatusIconTagText(statusCd, addClass = "") {
		let text = "<span class=\"cate " + addClass;
		if (statusCd === "Y")
			text += " on";

		text += "\"><i class=\"mdo-ico\">";
		if (statusCd === "N")
			text += "remove_done</i>미평가";
		else
			text += "file_download_done</i>평가완료";

		text += "</span>";
		return text;
	}

	// 평가명 리스트 데이터 조회
	async function getAppData() {
		return ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList2&searchAppStepCds=5,&searchAppYear="+$("#searchYear").val(),false).codeList;
	}

	// 평가차수 데이터 조회
	async function getAppSeqData() {
		if (!APP_DATA.currAppData) return {};

		return ajaxCall("${ctx}/AppReg.do?cmd=getAppRegAppStepList"
				, "searchAppraisalCd=" + APP_DATA.currAppData.appraisalCd +
					"&searchSabun=${sessionScope.ssnSabun}" +
					"&searchAppStepCd=5", false).DATA; // 본인평가 및 N차평가
	}

	// 평가차수 데이터 조회
	async function getAppEmpData() {
		if (!APP_DATA.currAppData) return {};
		if (!SEQ_DATA.currSeqData) return {};

		return ajaxCall("${ctx}/App1st2nd.do?cmd=getApp1st2ndList1"
				, "searchAppraisalCd=" + APP_DATA.currAppData.appraisalCd +
				"&searchAppSeqCd=" + SEQ_DATA.currSeqData.appSeqCd +
				"&searchAppSabun=${sessionScope.ssnSabun}" +
				"&searchAppStepCd=5", false).DATA; // 본인평가 및 N차평가
	}
</script>
<style type="text/css">

</style>
</head>
<body class="hidden">
	<div class="wrapper">
		<form id="empForm" name="empForm" >
		</form>
		<div class="d-flex hr-container">
			<div class="row">
				<!-- 평가년도 -->
				<div class="col col-3 p-0 depth1">
					<div class="scroll">
						<div class="group year">
							<div class="d-flex justify-content-between align-items-center">
								<p class="sub-title">평가년도</p>
								<div class="select">
									<select name="searchYear" id="searchYear">
										<option value="2022">2022</option>
										<option value="2022">2023</option>
										<option value="2022">2024</option>
									</select>
								</div>
							</div>
							<!-- slide -->
							<div class="app-list"></div>
							<%--<div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
								<div class="carousel-inner box">
									<div class="carousel-item box-list ing active">
										<span class="badge"><i class="breadcrumb-item"></i>진행중</span>
										<p class="subject">2022년도 종합 평가</p>
										<span class="date"><i class="mdo-ico">event_note</i>2022.01.01 ~ 2024.12.31</span>
									</div>
									<div class="carousel-item box-list">
										<span class="subject">
											2022년도 종합 평가
											<div class="badge"><i class="breadcrumb-item"></i><span class="">진행완료</span></div>
										</span>
										<span class="date"><i class="mdo-ico">event_note</i>2022.01.01 ~ 2024.12.31</span>
									</div>
									<div class="carousel-item box-list end">
										<span class="subject">
											2022년도 종합 평가
											<div class="badge"><i class="breadcrumb-item"></i><span class="">badge</span></div>
										</span>
										<span class="date"><i class="mdo-ico">event_note</i>2022.01.01 ~ 2024.12.31</span>
									</div>
								</div>
								<div class="carousel-indicators">
									<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
									<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" class="active" aria-current="true" aria-label="Slide 2"></button>
									<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" class="active" aria-current="true" aria-label="Slide 3"></button>
								</div>
							</div>--%>
						</div>
						<div id="appSeqArea" class="group step">
							<div class="d-flex">
								<p class="sub-title">평가단계</p>
							</div>
							<ul class="box app-seq-box">
								<li class="box-list active">
									<p class="subject d-flex align-items-center">본인평가<span class="team divider d-flex align-items-center">사업본부</span><span class="data">2024.01.01</span></p>
									<div class="d-flex align-items-center flex-wrap">
										<span class="cate on d-flex align-items-center"><i class="mdo-ico">file_download_done</i>평가완료</span>
										<ul class="detail-head dot">
											<li>업적 <span>88(A)</span></li>
											<li>역량 <span>88(A)</span></li>
											<li>종합 <span>88(A)</span></li>
										</ul>
									</div>
								</li>
								<li class="box-list">
									<div class="d-flex justify-content-between">
										<span class="subject">목표승인</span>
										<span class="result">100<span class="unit">%</span></span>
									</div>
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: 100%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" data-tgt-rate="100"></div>
									</div>
									<div class="d-flex justify-content-end">
										<span class="cnt">4</span>
										<span class="total">/ 4명</span>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- 평가배분현황 -->
				<div class="col col-3 p-0 depth2 app-emp-area">
					<div class="scroll">
						<div class="padding app-emp-box">
							<p class="sub-title">평가배분현황</p>
							<div class="approval-title-wrap">
								<p class="team d-inline-block">평가대상자</p>
							</div>
							<div class="app-emp-box-list">
								<div class="approval-title-wrap">
									<p class="team d-inline-block">평가완료</p>
								</div>
								<ul class="box">
									<li class="box-list active">
										<div class="info">
											<div class="thumb"><img src="https://flexible.img.hani.co.kr/flexible/normal/970/649/imgdb/original/2020/1012/20201012501979.jpg" alt="프로필"></div>
											<span class="name">고양이</span>
											<span class="position">회장님</span>
										</div>
										<span class="cate on"><i class="mdo-ico">file_download_done</i>승인완료</span>
									</li>
									<li class="box-list">
										<div class="info">
											<div class="thumb"><img src="https://flexible.img.hani.co.kr/flexible/normal/970/649/imgdb/original/2020/1012/20201012501979.jpg" alt="프로필"></div>
											<span class="name">집사</span>
											<span class="position">인턴</span>
										</div>
										<span class="cate"><i class="mdo-ico">file_download_done</i>승인대기</span>
									</li>
								</ul>
							</div>
							<div class="app-emp-box-list">
								<div class="approval-title-wrap">
									<p class="team d-inline-block">미평가</p>
									<span class="unit">1<span class="total">/2</span></span>
								</div>
								<ul class="box">
									<li class="box-list active">
										<div class="info">
											<div class="thumb"><img src="https://flexible.img.hani.co.kr/flexible/normal/970/649/imgdb/original/2020/1012/20201012501979.jpg" alt="프로필"></div>
											<span class="name">홍길동</span>
											<span class="position">직급</span>
										</div>
										<span class="cate on"><i class="mdo-ico">file_download_done</i>승인완료</span>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
				<!-- 본인평가 및 N차 평가 데이터 -->
				<div class="col p-0 depth3">
					<div class="scroll">
						<div class="app-nth-area">
							<p class="sub-title">
								본인평가
								<span class="cate on"><i class="mdo-ico">file_download_done</i>승인완료</span>
								<span class="team dot">사업본부</span>
							</p>
							<div class="d-flex justify-content-between align-items-end pt-3">
								<div class="profile">
									<div class="info">
										<div class="thumb"><img src="https://flexible.img.hani.co.kr/flexible/normal/970/649/imgdb/original/2020/1012/20201012501979.jpg" alt="프로필"></div>
										<span class="name">김길동</span>
										<span class="position">직급</span>
										<span class="team divider">사업본부</span>
									</div>
								</div>
								<div class="btns blue-btns">
									<button class="ico-btn"><i class="mdo-ico">chat</i>의견보기</button>
									<button class="btn ico-btn"><i class="mdo-ico">done_all</i>제출</button>
								</div>
							</div>
							<!-- tab -->
							<ul class="nav nav-tabs">
								<li class="nav-item"><a class="nav-link active" href="#mboTab" data-toggle="tab">업적</a></li>
								<li class="nav-item"><a class="nav-link" href="#compTab" data-toggle="tab">역량</a></li>
							</ul>
							<div class="tab-content box">
								<div class="tab-pane fade active show" id="mboTab">
									<div class="d-flex justify-content-between align-items-end">
										<p class="sub-title">
											목표작성
											<span class="percent">100%</span>
										</p>
										<div class="btns navy-btns">
											<button>조직목표</button>
											<button class="btn ico-btn"><i class="mdo-ico">track_changes</i>목표추가</button>
										</div>
									</div>
									<!-- accordion -->
									<div class="box-list">
										<div class="collapsed theme" data-toggle="collapse" data-target="#mboAccordion1-1" aria-expanded="false">
											<div class="subject">
												<span class="ico-txt blue"><i class="mdo-ico">group</i>조직목표</span>
												<span class="dot"><span class="percent">30%</span></span>
												<span class="tit">매출액 달성</span>
											</div>
											<div class="btns ico-btns">
												<button><i class="mdo-ico mr-0">mode_edit_outline</i></button>
												<button><i class="mdo-ico mr-0">delete_outline</i></button>
											</div>
										</div>
										<div class="collapse" id="mboAccordion1-1">
											<div class="box-wrap">
												<div class="box-list">
													<h3 class="mb-4">KPI목표</h3>
													<span>1000억</span>
												</div>
												<div class="box-list">
													<h3>내용/평가산식</h3>
													<span>1000억</span>
												</div>
												<div class="box-list">
													<h3>의견</h3>
													<span>1000억</span>
												</div>
											</div>
										</div>
									</div>
									<div class="box-list">
										<div class="collapsed theme" data-toggle="collapse" data-target="#mboAccordion1-2" aria-expanded="false">
											<div class="subject">
												<span class="ico-txt green"><i class="mdo-ico">person</i>개인목표</span>
												<span class="dot"><span class="percent">30%</span></span>
												<span class="tit">매출액 달성</span>
											</div>
										</div>
										<div class="collapse" id="mboAccordion1-2">
											<div class="box-wrap">
												<div class="box-list">
													<h3 class="mb-4">KPI목표</h3>
													<span>1000억</span>
												</div>
												<div class="box-list">
													<h3>내용/평가산식</h3>
													<span>1000억</span>
												</div>
												<div class="box-list">
													<h3>의견</h3>
													<span>1000억</span>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="tab-pane fade" id="compTab">
									<div class="d-flex justify-content-between align-items-end">
										<p class="sub-title">
											목표작성
											<span class="percent">100%</span>
										</p>
										<div class="btns navy-btns">
											<button>조직목표</button>
											<button class="btn ico-btn"><i class="mdo-ico">track_changes</i>목표추가</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>