<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='wtmAttendDet1' mdef='근태신청 세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/plugins/moment.js-2.30.1/moment-with-locales.js"></script>

<script type="text/javascript">
	var searchApplSeq    = "${searchApplSeq}";
	var adminYn          = "${adminYn}";
	var authPg           = "${authPg}";
	var searchSabun      = "${searchSabun}";
	var searchApplSabun  = "${searchApplSabun}";
	var searchApplInSabun= "${searchApplInSabun}";
	var searchApplYmd    = "${searchApplYmd}";
	var applStatusCd	 = "";
	var pGubun         = "";
	var gPRow = "";
	var codeLists;
	var bfYmd = "${etc01}"; // 신규 신청 시 기간 (시작일, 종료일로 이루어짐) (시작일_종료일)
	var srcKey = "${etc02}"; // 변경/취소할 근태의 코드
	var appType = "${etc03}"; // 신청유형(I: 입력, D: 변경/취소)
	var periodYn = '';
	var addCnt = '0';

	var iframeHeight = 220;  /* 신청상세 iframe 높이 */
	var detData;

	$(function() {
		parent.iframeOnLoad(iframeHeight);  //220px보다 작으면 달력이 짤림.
		//----------------------------------------------------------------
		$("#searchSabun").val(searchSabun);
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
		// 근태종류 콤보박스 설정
		var params = "";
		if(authPg == "A"){ // 신청,임시저장일 때는 근태신청 가능한 코드만 가져옴.
			params = "&searchAppYn=Y";
		}
		var gntGubunCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmAttendAppDetGntGubunList"+params, false).codeList, "");
		$("#gntGubunCd").html(gntGubunCdList[2]);

		// 근태 신청내역 Sheet 초기화
		init_wtmAttendAppDetSheet1();

		if(authPg === "A") {
			// 근태종류 변경 이벤트
			$("#gntGubunCd").bind("change", function() {
				// 근태코드 콤보박스 설정
				var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmAttendAppDetGntCdList&searchGntGubunCd="+$("#gntGubunCd").val()+"&searchAppYn=Y", false).codeList
						, "gntGubunCd,requestUseType,baseCnt,maxCnt,holInclYn,stdApplyHour,vacationYn,minusAllowYn,orgLevelCd,excpSearchSeq,divCnt"
						, "");
				$("#gntCd").html(gntCdList[2]).change();
			});

			// 근태코드 변경 이벤트
			$("#gntCd").bind("change", function() {
				changeGntCd();
				doAction1("Sheet1");
			});

			// 사용 휴가 변경 시
			$("#leaveId").bind("change", function() {
				changeLeaveId();
			});

			// 신청일자 추가 버튼 클릭 이벤트
			$('#addBtn2').on('click', function() {
				addCnt++;
				makeRow(addCnt, authPg);
			})

			if (srcKey) {
				// 변경/취소건일 경우 근태코드 세팅
				initUpdDelGntCd(srcKey);
			} else {
				// 최초 호출
				$("#gntGubunCd").change();
			}

		} else {
			// 읽기전용 일때는 전체 근태코드를 가져 옴.
			// 근태코드 콤보박스 설정
			var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmAttendAppDetGntCdList"+params, false).codeList
					      , "requestUseType,vacationYn,baseCnt,gntGubunCd,baseCnt,maxCnt,holInclYn,gntCdDel1,divCnt"
			              , "");
			$("#gntCd").html(gntCdList[2]);

			// 추가 버튼 hide
			$('#addBtn2').hide();
		}

		doAction1("Search");
	})

	/**
	 * 변경 취소일 경우
	 * @param _srcKey {string}
	 */
	function initUpdDelGntCd(_srcKey) {
		const data = ajaxCall("${ctx}/WtmAttendApp.do?cmd=getWtmAttendAppDetInfoForUpd", "searchApplSeq=" + _srcKey.split("_")[0] + "&searchSeq=" + _srcKey.split("_")[1], false);
		if (data && data.DATA) {
			$("#gntGubunCd").val(data.DATA.gntGubunCd).change();
			$("#gntCd").val(data.DATA.gntCd).change();
		} else {
			alert("조회 시 실패하였습니다.");
		}
	}

	/**
	 * 사용연차휴가 콤보 생성
	 */
	function initLeaveId() {
		var vacationYn = getAttr("gntCd", "vacationYn");	// 발생근태사용여부

		// 잔여연차휴가 목록 조회
		if( vacationYn === "Y" ) {
			const oldLeaveId = $("#leaveId").val();
			if ($('input[name="sYmd"]').length === 0) return;
			let sYmd = $('input[name="sYmd"]').map((idx, obj) => obj.value).get().reduce((min, current) => {
				return current < min ? current : min;
			});

			let eYmd = $('input[name="eYmd"]').map((idx, obj) => obj.value).get().reduce((max, current) => {
				return current > max ? current : max;
			});

			let param  = "queryId=getWtmAttendAppUseCdList";
			param += "&searchSabun="+searchApplSabun;
			param += "&searchGntGubunCd=" + $("#gntGubunCd").val();
			param += "&sYmd="+sYmd.replace(/-/gi, "");
			param += "&eYmd="+eYmd.replace(/-/gi, "");
			param += "&searchBfApplSeq="+$("#bfApplSeq").val();
			let leaveIdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", param, false).codeList
					, "gntCd, useSYmd, useEYmd, creCnt, useCnt, usedCnt, restCnt, minusAllowYn"
					, "사용 휴가를 선택해주십시오.");
			$("#leaveId").html(leaveIdList[2]);
			// 사용 휴가의 항목이 1개인 경우 해당 항목 자동 선택
			if(authPg === 'A' && $("#leaveId option").length === 2) {
				$('#leaveId option:last').prop('selected', true);

				if(oldLeaveId !== $("#leaveId").val()) changeLeaveId(); // 기존에 선택한 사용휴가와 다른 휴가를 선택한경우
			}
		}
	}

	/**
	 * 근태코드 변경 시 이벤트
	 */
	function changeGntCd() {

		if( $("#gntCd").val() === "" ) {
			// 선택된 근태코드가 없을 경우 초기화
			$('.inModData-wrap').remove();
			clearHtml();
			addCnt = 0;
			return;
		}

		// 발생근태사용여부 확인
		const vacationYn = getAttr("gntCd", "vacationYn");
		if(vacationYn === "Y") {
			// 사용휴가 콤보 생성
			initLeaveId();
			if( authPg === "A" && !$("#leaveId").hasClass("required") ) {
				$("#leaveId").addClass("required");
			}
			$("#inMod3").show();
			iframeHeight = 250;
		} else {
			if( $("#leaveId").hasClass("required") ) {
				$("#leaveId").removeClass("required");
			}
			$("#inMod3").hide();
			iframeHeight = 220;
		}
		parent.iframeOnLoad(iframeHeight + "px");

		//------------------------------------------------------------------------------------------
		// 현재 근태코드의 근태신청유형
		var reqUseType = getAttr("gntCd", "requestUseType");
		var baseCnt    = getAttr("gntCd", "baseCnt");

		// 최소, 최대 기준일수를 보여줌
		$("#baseCnt").val( baseCnt ) ;
		$("#maxCnt").val( getAttr("gntCd", "maxCnt") ) ;

		// 전체 clear
		clearAllRowData();
		addCnt = 0;
		if (authPg === "A") {
			// 근태캘린더에서 시작/종료일자가 넘어올 경우 해당 데이터로 초기화
			if (bfYmd) {

				const bfSYmd = bfYmd.split("_")[0];
				const bfEYmd = bfYmd.split("_")[1];
				makeRowsByYmd(bfSYmd, bfEYmd); // 근태캘린더에서 넘어온 시작/종료일자로 기본 신청 데이터 생성

			}
			/*
			else {
				makeRow(0, authPg); // 사용자 편의성을 위해 빈 첫 번째 행을 자동으로 생성

				// 근태신청유형에 따라 시간 체크 로직이 다름
				if( reqUseType == "H" ) {
					// 시간차 신청
					hourCheck($getRowSelectorByName(0, "applYmd"), 0);
				} else {
					// 그외 종일, 오전, 오후 등..
					dateCheck($getRowSelectorByName(0, "sYmd"), 0);
				}
			}
			 */
		}
	}

	/**
	 * 입력값 초기화
	 */
	function clearHtml() {

		resetRowData(0); // 첫번째 행 초기화
		$("#gntReqReason").val( "" );

		$("#restDayTitle").text("") ;

		$("#maxCnt").val( "" );
		$("#txt_sTime").html( "시작시간" );
		$("#txt_eTime").html( "종료시간" );
	}

	/**
	 * 특정 행의 데이터를 reset
	 * @param idx {string|number} 행 인덱스
	 */
	function resetRowData(idx) {

		if ($(getInModDataWrapId(idx)).length === 0) {
			return;
		}

		const reqUseType = getAttr("gntCd", "requestUseType");

		if ( reqUseType === "H" ) {
			// 시간단위
			setRowValue(idx, "applYmd", "");
			setRowValue(idx, "reqSHm", "");
			setRowValue(idx, "reqEHm", "");
			setRowValue(idx, "requestHour", "");
		} else {
			// 종일, 오전/오후단위, 반반차 등
			setRowValue(idx, "sYmd", "");
			setRowValue(idx, "eYmd", "");
		}
		setRowValue(idx, "holDay", "");
		setRowValue(idx, "appDay", "");
	}

	/**
	 * 모든 신청일자 데이터를 삭제한다.
	 */
	function clearAllRowData() {
		$(getInModDataWrapId()).remove();
	}

	/**
	 * 근태 신청유형에 따라 찾아야 할 inModData-wrap 의 selector id 를 조회
	 * @param idx {string|number} [선택값] 행 순번
	 * @returns {string} inModData-wrap 의 selector id
	 */
	function getInModDataWrapId(idx = "") {
		return idx+"" ? "td#inMod2Data div.inModData-wrap[data-idx=" + idx + "]" : "td#inMod2Data div.inModData-wrap";
	}

	/**
	 * 근태캘린더에서 넘어온 시작/종료일자로 기본 신청 데이터를 만들어준다.
	 * @param sYmd {string} 시작일자(YYYY-MM-DD)
	 * @param eYmd {string} 종료일자(YYYY-MM-DD)
	 */
	function makeRowsByYmd(sYmd, eYmd) {
		const diff = getDaysBetween(sYmd.replace(/[-|.]/gi, ""), eYmd.replace(/[-|.]/gi, ""));
		const reqUseType = getAttr("gntCd", "requestUseType");
		if ( reqUseType === "AM" || reqUseType === "PM" || reqUseType === "HAM1" || reqUseType === "HAM2" || reqUseType === "HPM1" || reqUseType === "HPM2" || reqUseType === "H" ) {
			for (var i = 1 ; i <= diff ; i++) {
				makeRow(i, authPg);
				const date = moment(sYmd).add(i-1, "days").format("YYYY-MM-DD");
				if (reqUseType === "H") {
					// 시간차 신청
					setRowValue(i, "applYmd", date);
					$getRowSelectorByName(i, "applYmd").blur();
				} else {
					// 그외 종일, 오전, 오후 등..
					setRowValue(i, "sYmd", date);
					setRowValue(i, "eYmd", date);
					$getRowSelectorByName(i, "sYmd").blur();
				}
				addCnt++;
			}
			initLeaveId();
		} else {
			// 일단위 근태
			makeRow(addCnt, authPg);
			setRowValue(addCnt, "sYmd", sYmd);
			setRowValue(addCnt, "eYmd", eYmd);
			$getRowSelectorByName(addCnt, "sYmd").blur();
			initLeaveId();
			addCnt++;
		}

		// 적용일자가 0인 행은 삭제
		$(getInModDataWrapId()).each(function() {
			const idx = $(this).attr("data-idx");
			const appDay = getRowValue(idx, "appDay");
			if (appDay+"" === "0") {
				$(this).remove();
			}
		})
	}

	/**
	 * 신청일자 행 생성
	 * @param idx {string|number} 행 순번
	 * @param _authPg {string} 권한
	 */
	function makeRow(idx, _authPg) {
		const requestUseType = getAttr("gntCd", "requestUseType");
		const html = makeRowHtml(requestUseType, idx, _authPg);
		$("#addBtn2").before(html);
		parent.setIframeHeight('authorFrame');
		if (_authPg === "A")
			setDatepickerAndEvent(idx);
	}

	/**
	 * 신청타입별 신청일자 영역 Html 텍스트 조회
	 * @param reqUseType {string} 신청타입
	 * @param idx {string|number} 행 순번
	 * @param _authPg {string} 권한
	 * @returns {string} HTML 텍스트
	 */
	function makeRowHtml(reqUseType, idx, _authPg) {
		const rmBtnHtml = (_authPg === "A") ? `<button type="button" name="removeRow" class="btn filled ml-auto">삭제</button>` : ``;
		if (reqUseType === "H") {
			return `<div class="inModData-wrap" data-idx="${'${idx}'}">
					    <input id="applYmd${'${idx}'}" name="applYmd" type="text" size="10" class="date2 center ${readonly} ${required} required2 edit-datepicker" readonly />
					    &nbsp;
					    <b><span id="txt_sTime">시작시간</span> : </b>
					    <input name="reqSHm" type="text" class="text center ${required} required2" ${readonly} maxlength="5"/>
					    &nbsp;
					    <b><span id="txt_eTime">종료시간</span> : </b>
					    <input name="reqEHm" type="text" class="text center ${required} required2" ${readonly} maxlength="5"/>
					    &nbsp;
					    <b>적용시간 : </b>
					    <input name="requestHour" type="text" class="text w50 center ${readonly}" ${readonly} maxlength="4"/> 시간
					    <span class="hide">
					        <b>총일수 : </b> <input type="text" name="holDay" class="text w50 center" readonly maxlength="3"/>&nbsp;
					        <b>적용일수 : </b> <input type="text" name="appDay" class="text w50 center" readonly maxlength="4"/>&nbsp;
					    </span>
					    ${'${rmBtnHtml}'}
					</div>`;
		} else {
			const spanEYmdDisplayHtml = (reqUseType !== "D") ? ` style="display: none;"` : ``;
			return `<div class="inModData-wrap" data-idx="${'${idx}'}">
					    <input id="sYmd${'${idx}'}" name="sYmd" type="text" size="10" class="date2 center ${required} required1" readonly  />
					    <span class="span_eYmd" ${'${spanEYmdDisplayHtml}'}>
					        <input type="text" class="text w10 left transparent center" value="~" readonly tabindex="-1">
					        <input name="eYmd" type="text" size="10" class="date2 center ${required} required1" readonly  />
					    </span>
					    <span style="padding-left:30px;">
					        <b>총일수 : </b> <input type="text" name="holDay" class="text w50 center" readonly maxlength="3"/>&nbsp;
					        <b>적용일수 : </b> <input type="text" name="appDay" class="text w50 center" readonly maxlength="4"/>&nbsp;
					    </span>
					    ${'${rmBtnHtml}'}
					</div>`;
		}
	}

	/**
	 * 신청일자 항목 datepicker 설정 및 이벤트 바인딩
	 * @param idx {string|number} 행 순번
	 */
	function setDatepickerAndEvent(idx) {
		const requestUseType = getAttr("gntCd", "requestUseType");
		const dataWrapSel = getInModDataWrapId(idx);

		if ( requestUseType === "H" ) {
			const applYmdId = dataWrapSel + " input[name=applYmd]";
			const reqSHmId = dataWrapSel + " input[name=reqSHm]";
			const reqEHmId = dataWrapSel + " input[name=reqEHm]";

			$(applYmdId).datepicker2({
				onReturn: function() {
					hourCheck(this, idx);
				}
			});

			$(reqSHmId).mask("11:11");
			$(reqEHmId).mask("11:11");

			$([applYmdId, reqSHmId, reqEHmId].join(',')).on("blur", function() {
				hourCheck(this, idx);
			});
		} else {
			const sYmdId = dataWrapSel + " input[name=sYmd]";
			const eYmdId = dataWrapSel + " input[name=eYmd]";

			$(sYmdId).datepicker2({
				onReturn: function(date) {
					const $parent = $(this).parent();
					$parent.find("input[name=eYmd]").val("");
					dateCheck(this, idx);
					initLeaveId();
				}
			});

			$(eYmdId).datepicker2({
				enddate: "sYmd"+idx,
				onReturn: function(date) {
					dateCheck(this, idx);
					initLeaveId();
				}
			});

			$([sYmdId, eYmdId].join(',')).on("blur", function() {
				dateCheck(this, idx);
			});
		}

		// 삭제 버튼 이벤트
		const removeRowBtnId = dataWrapSel + " button[name=removeRow]";
		$(removeRowBtnId).on("click", function() {
			$(this).parent().remove();
		})
	}

	/**
	 * 입력한 시간이 유효한지 확인
	 * @param obj 현재 입력중인 엘레먼트의 jQuery selector
	 * @param idx {string|number} 행 순번
	 * @returns {boolean}
	 */
	function isValidInputTime(obj, idx) {
		const requestUseType = getAttr("gntCd", "requestUseType");
		let timeList = [];

		// 현재 입력 값
		let sMmt, eMmt;
		if (requestUseType === "H") {
			sMmt = moment(getRowValue(idx, "applYmd") + " " + getRowValue(idx, "reqSHm"));
			eMmt = moment(getRowValue(idx, "applYmd") + " " + getRowValue(idx, "reqEHm"));
		} else {
			sMmt = moment(getRowValue(idx, "sYmd"));
			eMmt = moment(getRowValue(idx, "eYmd"));
		}

		// 신청일자 유효성 체크
		if(!sMmt.isValid() || !eMmt.isValid()) return false;

		// 시작일, 종료일 기간이 올바르지 않은 경우 알림 처리
		if( sMmt.isAfter(eMmt) ) {
			alert("시작일과 종료일을 정확히 입력하세요.");
			$(obj).val("");
			return false;
		}

		// 입력한 모든 기간 수집
		$(getInModDataWrapId()).each(function() {
			const idx = Number($(this).attr("data-idx"));
			let start, end;
			if (requestUseType === "H") {
				start = moment(getRowValue(idx, "applYmd") + " " + getRowValue(idx, "reqSHm"));
				end = moment(getRowValue(idx, "applYmd") + " " + getRowValue(idx, "reqEHm"));
			} else {
				start = moment(getRowValue(idx, "sYmd"));
				end = moment(getRowValue(idx, "eYmd"));
			}
			timeList.push({ "idx": idx, "start": start, "end": end });
		});

		// 중복 여부 체크
		let isDup = false;
		for (const obj of timeList) {
			if (obj.idx === idx) continue;

			const tmpSMmt = obj.start
					, tmpEMmt = obj.end;

			// 유효한 시간의 데이터만 중복 여부 체크
			if (!tmpSMmt.isValid() && !tmpEMmt.isValid()) continue;

			if (requestUseType === "H") {
				// 시간단위 근태 (신청이 18:00 ~ 20:00, 20:00 ~ 22:00 일 경우 20:00 은 중복된 데이터가 아님)
				if (sMmt.isBefore(tmpEMmt) && eMmt.isAfter(tmpSMmt)) {
					isDup = true;
					break;
				}
			} else {
				// 시간단위 제외한 근태 (신청이 2025-02-14 ~ 2025-02-15, 2025-02-15 ~ 2025-02-16 일 경우 2025-02-15 는 중복된 데이터임)
				if ((sMmt.isSame(tmpEMmt) || sMmt.isBefore(tmpEMmt)) && (eMmt.isSame(tmpSMmt) || eMmt.isAfter(tmpSMmt))) {
					isDup = true;
					break;
				}
			}
		}
		if(isDup) {
			alert("신청일자가 겹치는 건이 있습니다. 신청일자를 확인해주세요.");
			$(obj).val("");
			return false;
		}

		return true;
	}

	//--------------------------------------------------------------------------------
	//  적용시간 계산
	//--------------------------------------------------------------------------------
	function hourCheck(obj, idx) {
		const requestUseType = getAttr("gntCd", "requestUseType");

		// 중복건 확인
		if (!isValidInputTime(obj, idx)) {
			if (requestUseType === "H") {
				setRowValue(idx, "requestHour", ""); // 적용시간 초기화
			}
			setRowValue(idx, "holDay", "");
			setRowValue(idx, "appDay", "");
			return;
		}

		var baseCnt = getAttr("gntCd", "baseCnt");
		var param = "sabun="+searchApplSabun
		+"&gntCd=" + $("#gntCd").val()
		+"&reqSHm=" + getRowValue(idx, "reqSHm")
		+"&reqEHm=" + getRowValue(idx, "reqEHm")
		+"&applYmd=" + getRowValue(idx, "applYmd");

		// 적용시간 계산
		var holiDayCnt = ajaxCall("/WtmAttendApp.do?cmd=getWtmAttendAppDetHour",param ,false);
		if( holiDayCnt != null && holiDayCnt != undefined && holiDayCnt.DATA != null && holiDayCnt.DATA != undefined ) {
			var requestHour = Number(holiDayCnt.DATA.restTime);

			//시간차 처리를 위한 산식 삽입
			if(getRowValue(idx, "appDay") > 0 && baseCnt == 0.125) {
				setRowValue(idx, "holDay", requestHour*baseCnt);
				setRowValue(idx, "appDay", requestHour*baseCnt);
			}

			setRowValue(idx, "requestHour", requestHour);
		}
	}

	//--------------------------------------------------------------------------------
	//  신청일자 유효성 체크 및 총일수, 적용일수 계산
	//--------------------------------------------------------------------------------
	function dateCheck(obj, idx) {

		try{

			const reqUseType = getAttr("gntCd", "requestUseType");
			let sYmd, eYmd;

			if (reqUseType === "H") {
				// 시간단위 근태
				sYmd = getRowValue(idx, "applYmd");
				eYmd = sYmd;
			} else {
				// 시간단위를 제외한 근태
				sYmd = getRowValue(idx, "sYmd");
				eYmd = getRowValue(idx, "eYmd");

				// 1-1. 신청구분이 반차, 반반차단위인 경우, 시작/종료일을 동일하게 설정
				if (isHalfType(reqUseType) && sYmd) {
					setRowValue(idx, "eYmd", sYmd);
					eYmd = sYmd;
				}
			}

			// 1-3. 중복되는지 확인
			if (!isValidInputTime(obj, idx)) {
				setRowValue(idx, "holDay", "");
				setRowValue(idx, "appDay", "");
				return;
			}

			/* 2.총일수, 적용일수 계산 */
			var param = "sabun="+$("#searchApplSabun").val()
			+"&applSeq="+$("#searchApplSeq").val()
			+"&gntCd="+$("#gntCd").val()
			+"&sYmd="+sYmd
			+"&eYmd="+eYmd;

			// 휴일 체크
			var map = ajaxCall("/WtmAttendApp.do?cmd=getWtmAttendAppDetHolidayCnt", param, false);
			if( map.DATA.authYn == "N") {
				alert("신청 대상자가 아닙니다.");
				$(obj).val("");
				return;
			}

			if (isHalfType(reqUseType)) {
				// 반차(또는 반반차) 유형의 경우 적용일자를 신청단위일수의 최대값으로 적용
				const maxCnt = getAttr("gntCd", "maxCnt");
				setRowValue(idx, "holDay", maxCnt);
				if (map.DATA.holidayCnt > 0) {
					setRowValue(idx, "appDay", "0");
				} else {
					setRowValue(idx, "appDay", maxCnt);
				}
			} else {
				// 그 외의 경우 적용일자는 시작/종료일로 판단
				const dayBetween = getDaysBetween(sYmd, eYmd);
				setRowValue(idx, "holDay", dayBetween);
				setRowValue(idx, "appDay", dayBetween - map.DATA.holidayCnt);
			}

			/*
				시간차 신청이 아닌경우에만 적용일수 재계산. -> 단축근무자 케이스를 고려하기 위함.
				계산식 : (일 근무시간 * BASE_CNT / 휴무적용시간) * BASE_CNT
						단, 일 근무시간이 아직 산정되지 않은 경우, 근태코드 관리의 적용일수를 사용한다.
			 */
			if(reqUseType !== 'H') {
				// 일 근무시간 조회
				const data = ajaxCall("/WtmAttendApp.do?cmd=getWtmAttendAppDetWorkHours",param ,false);
				if ( data != null && data.DATA != null ){
					const baseCnt = getAttr("gntCd", "baseCnt");
					const stdApplyHour = getAttr("gntCd", "stdApplyHour");
					let appDay = 0;
					data.DATA.forEach(item => {
						const workHours = data.DATA.workHours;
						const holidayCnt = data.DATA.holidayCnt;
						// 휴무일이 아닐때
						if(holidayCnt === 0) {
							if(workHours > 0) {
								// 일 근무시간이 있는 경우, 계산식 적용
								appDay += (workHours * baseCnt / stdApplyHour) * baseCnt;
							} else {
								// 일 근무시간이 없는 경우, 근태코드 기본 적용일수 사용.
								appDay += baseCnt;
							}
							// 계산된 적용일수 적용
							setRowValue(idx, "appDay", appDay);
						}
					})
				}
			}
		}catch(e){

		}
	}

	/**
	 * 사용휴가 변경 이벤트
	 */
	function changeLeaveId() {
		if( $("#leaveId").val() !== "" ) {
			var restCnt = Number(getAttr("leaveId", "restCnt"));
			let appDaySum = $('input[name="appDay"]')
					.map((i, el) => parseInt(el.value))
					.get()
					.reduce((acc, curr) => acc + curr, 0);
			var minusAllowYn = getAttr("leaveId", "minusAllowYn");

			// 적용일수가 선택한 잔여연차보다 큰 경우 선택 불가 처리
			if( authPg === "A" && minusAllowYn == "N" && appDaySum > restCnt ) {
				alert("사용할수 있는 잔여일수가 부족합니다.");
				$("#leaveId").val("");
				$("#leaveId").focus();
			}
		}
	}

	/**
	 * 신청내역 Sheet 초기화
	 */
	function init_wtmAttendAppDetSheet1() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"근태구분",		Type:"Text",		Hidden:0,	Width:100, 	Align:"Center",		ColMerge:0,	SaveName:"gntGubunNm",	KeyField:0,	Format:"",		Edit:0 },
			{Header:"근태명",		Type:"Text",		Hidden:0,	Width:100, 	Align:"Center",		ColMerge:0,	SaveName:"gntNm",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"sYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0, Edit:0},
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"eYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0, Edit:0},
			{Header:"총일수",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"holDay",		KeyField:0,	CalcLogic:"",	Format:"",  Edit:0},
			{Header:"적용일수",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"appDay",		KeyField:0,	CalcLogic:"",	Format:"",  Edit:0},
			{Header:"취소",			Type:"CheckBox",  	Hidden:0,  	Width:80,   Align:"Center",  	ColMerge:0, SaveName:"cancelChk",	KeyField:0, CalcLogic:"",   Format:"",  Edit:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"상위신청서순번",	Type:"Hidden",  	Hidden:1,  	SaveName:"bfApplSeq"},
			{Header:"신청휴가",		Type:"Hidden",  	Hidden:1,  	SaveName:"leaveId"},
			{Header:"seq",			Type:"Hidden",  	Hidden:1,  	SaveName:"seq"},
		]; IBS_InitSheet(wtmAttendAppDetSheet1, initdata1);wtmAttendAppDetSheet1.SetEditable(1);wtmAttendAppDetSheet1.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

		wtmAttendAppDetSheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		wtmAttendAppDetSheet1.SetDataAlternateBackColor(wtmAttendAppDetSheet1.GetDataBackColor()); //홀짝 배경색 같게
	}

	// 근태변경신청용 from -> 입력 항목 타이틀 변경 및 근태구분, 근태 고정
	// function setModifyForm(type, periodYn) {
	//
	// 	// 종료일자 숨기기: 기간 단위로 변경신청X
	// 	if(periodYn === 'N') $("#span_eYmd").hide();
	//
	// 	// 입력 항목 타이틀 변경
	// 	if(type === 'U') {
	// 		if(authPg === 'A') {
	// 			// 근태구분, 근태 고정
	// 			$("#gntGubunCd").attr('disabled', true);
	// 			$("#gntCd").attr('disabled', true);
	// 		}
	// 		$("#inMod1Title").text('변경일자');
	// 		$("#inMod2Title").text('변경일자');
	// 		$("#inMod5Title").text('변경사유');
	// 		if(periodYn === 'Y') {
	//
	// 		} else {
	// 			// 특정 일자 변경 신청의 경우 기존 근태일자 출력
	// 			$("#inMod6").show();
	// 		}
	// 	} else if(type === 'D') {
	// 		// 근태삭제인 경우, 사유 입력항목을 제외하고 전체 readonly 처리
	// 		if(authPg === 'A') {
	// 			$('#dataFrm').find('input[type="text"], textarea').prop('readonly', true);
	// 			$('#dataFrm').find('input, textarea, select').prop('disabled', true);
	// 			$('#dataFrm').find('input[type="text"]').removeClass('date2 w70');
	// 			$("#gntReqReason").attr("readonly", false);
	// 			$("#gntReqReason").attr("disabled", false);
	// 		}
	//
	// 		$("#sYmd").val($("#gntYmd").val());
	// 		$("#eYmd").val($("#gntYmd").val());
	// 		$("#inMod1Title").text('취소일자');
	// 		$("#inMod2Title").text('취소일자');
	// 		$("#inMod5Title").text('취소사유');
	// 		dateCheck($("#sYmd")[0]);
	// 	}
	//
	// }

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var params = "searchApplSeq="+searchApplSeq;
				detData = ajaxCall("${ctx}/WtmAttendApp.do?cmd=getWtmAttendAppDetList", params, false).DATA;

				if ( detData && detData.length > 0) {

					clearAllRowData();
					$("#gntGubunCd").val( detData[0].gntGubunCd );
					if(authPg == "A") {
						$("#gntGubunCd").change();
					}
					$("#gntCd").val( detData[0].gntCd );
					changeGntCd() ;

					var reqUseType = getAttr("gntCd", "requestUseType");

					detData.forEach((item, idx) => {
						if(item.reqType === 'I') { // 휴가 신청인 경우
							const _idx = Number(item.seq);
							makeRow(_idx, authPg);
							if(reqUseType === 'H') {
								setRowValue(_idx, "applYmd", formatDate(item.sYmd,"-"));
								setRowValue(_idx, "reqSHm", formatTime(item.reqSHm));
								setRowValue(_idx, "reqEHm", formatTime(item.reqEHm));
								setRowValue(_idx, "requestHour", item.requestHour);
							} else {
								setRowValue(_idx, "sYmd", formatDate(item.sYmd,"-"));
								setRowValue(_idx, "eYmd", formatDate(item.eYmd,"-"));
							}
							setRowValue(_idx, "holDay", item.holDay);
							setRowValue(_idx, "appDay", item.appDay);

							addCnt = _idx;

							if( item.leaveId != undefined && item.leaveId != null ) {
								initLeaveId();
								$("#leaveId").val( item.leaveId );
								changeLeaveId();
							}
						}
					})

					$("#gntReqReason").val( detData[0].gntReqReason );
				}
				doAction1("Sheet1");
				break;
			case "Sheet1":
				let param = "searchApplSabun="+$("#searchApplSabun").val()
						+"&gntCd="+$("#gntCd").val()
						+"&leaveId="+$("#leaveId").val();

				wtmAttendAppDetSheet1.DoSearch( "${ctx}/WtmAttendApp.do?cmd=getWtmAttendAppDetSheet1List", param );
				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// wtmAttendAppDetSheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function wtmAttendAppDetSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(authPg == "A") {
				if (srcKey) {
					for(var i = wtmAttendAppDetSheet1.HeaderRows(); i < wtmAttendAppDetSheet1.RowCount()+wtmAttendAppDetSheet1.HeaderRows(); i++) {
						const tgtKey = wtmAttendAppDetSheet1.GetCellValue(i, "bfApplSeq") + "_" + wtmAttendAppDetSheet1.GetCellValue(i, "seq");

						if(srcKey === tgtKey) {
							wtmAttendAppDetSheet1.SetCellValue(i, 'cancelChk', "Y");
						}
					}
				}
			} else {
				wtmAttendAppDetSheet1.SetEditable(0);
				detData.forEach((item, idx) => {
					const bfApplSeq = item.bfApplSeq;
					const bfSeq = item.bfSeq;

					for(var i = wtmAttendAppDetSheet1.HeaderRows(); i < wtmAttendAppDetSheet1.RowCount()+wtmAttendAppDetSheet1.HeaderRows(); i++) {
						if(wtmAttendAppDetSheet1.GetCellValue(i, "bfApplSeq") === bfApplSeq && wtmAttendAppDetSheet1.GetCellValue(i, "seq") === bfSeq) {
							wtmAttendAppDetSheet1.SetCellValue(i, 'cancelChk', "Y");
							break;
						}
					}
				})
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(){
		var ch = true;
		var reqUseType = $("#gntCd option:selected").attr("requestUseType");

		if(reqUseType === 'H') {
			$(".required2").each(function() {
				if (!$(this).is(":visible")) return true;	// 숨겨진 컨트롤은 each 반복중 continue 함
				if($(this).val() == null || $(this).val() == ""){
					switch ($(this).attr("name")) {
						case "reqSHm":
							alert($("#txt_sTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
							break;
						case "reqEHm":
							alert($("#txt_eTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
							break;
						default:
							alert($(this).prev().find("span").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
							break;
					}
					$(this).focus();
					ch =  false;
					return false;
				}
			});
		} else {
			$(".required1").each(function(index){
				if (!$(this).is(":visible")) return true;	// 숨겨진 컨트롤은 each 반복중 continue 함
				if($(this).val() == null || $(this).val() == ""){
					alert($(this).prev().find("span").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
					$(this).focus();
					ch =  false;
					return false;
				}
			});
		}

		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(){
		var returnValue = false;

		try{
			if ( authPg == "R" )  {
				return true;
			}

	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

			// disabled 속성 제거
			$('#dataFrm').find('input, textarea, select').prop('disabled', false);

			// 휴가 신청 데이터
			let insDataList = [];
			const reqUseType = getAttr("gntCd", "requestUseType");
			let idx = 1;
			$(getInModDataWrapId()).each(function() {
				idx = Number($(this).attr("data-idx"));
				if(reqUseType === 'H') {
					const applYmd = getRowValue(idx, "applYmd");
					const reqSHm = getRowValue(idx, "reqSHm");
					const reqEHm = getRowValue(idx, "reqEHm");
					if (isValidTime(applYmd, reqSHm) && isValidTime(applYmd, reqEHm)) {
						const requestHour = getRowValue(idx, "requestHour");
						const holDay = getRowValue(idx, "holDay");
						const appDay = getRowValue(idx, "appDay");
						const leaveId = $("#leaveId").val();
						insDataList.push({sYmd: applYmd, eYmd: applYmd, reqSHm: reqSHm, reqEHm: reqEHm, requestHour: requestHour, holDay: holDay, appDay: appDay, leaveId: leaveId, seq: idx});
					}
				} else {
					const sYmd = getRowValue(idx, "sYmd");
					const eYmd = getRowValue(idx, "eYmd");
					if (isValidTime(sYmd) && isValidTime(eYmd)) {
						const holDay = getRowValue(idx, "holDay");
						const appDay = getRowValue(idx, "appDay");
						const leaveId = $("#leaveId").val();
						insDataList.push({sYmd: sYmd, eYmd: eYmd, holDay: holDay, appDay: appDay, leaveId: leaveId, seq: idx});
					}
				}
			})

			// 휴가 취소 데이터
			let delDataList = [];
			for(var i = wtmAttendAppDetSheet1.HeaderRows(); i < wtmAttendAppDetSheet1.RowCount()+wtmAttendAppDetSheet1.HeaderRows(); i++) {
				const cancelChk = wtmAttendAppDetSheet1.GetCellValue(i, 'cancelChk');
				if(cancelChk === 'Y') {
					idx++;
					let sYmd = wtmAttendAppDetSheet1.GetCellValue(i, 'sYmd');
					let eYmd = wtmAttendAppDetSheet1.GetCellValue(i, 'eYmd');
					let appDay = wtmAttendAppDetSheet1.GetCellValue(i, 'appDay');
					let holDay = wtmAttendAppDetSheet1.GetCellValue(i, 'holDay');
					let bfApplSeq = wtmAttendAppDetSheet1.GetCellValue(i, 'bfApplSeq');
					let leaveId = wtmAttendAppDetSheet1.GetCellValue(i, 'leaveId');
					let bfSeq = wtmAttendAppDetSheet1.GetCellValue(i, 'seq');
					delDataList.push({sYmd: sYmd, eYmd: eYmd, appDay: appDay, holDay: holDay, bfApplSeq: bfApplSeq, leaveId: leaveId, bfSeq: bfSeq, seq: idx});
				}
			}

			if (insDataList.length === 0 && delDataList.length === 0) {
				alert("저장할 데이터가 없습니다. 취소 또는 신청 데이터를 입력해주세요.");
				return false;
			}

			//저장
			const params = JSON.stringify({
				insDataList: insDataList,
				delDataList: delDataList,
				...Object.fromEntries(new FormData($("#dataFrm")[0]))
			})

			$.ajax({
				url: "${ctx}/WtmAttendApp.do?cmd=saveWtmAttendAppDet",
				type: "post",
				async: false,
				data: params,
				contentType : "application/json; charset=utf-8",
				success : function(data) {
					if(data.Result.Code < 1) {
						alert(data.Result.Message);
						returnValue = false;
					}else{
						returnValue = true;
					}
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});

		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			returnValue = false;
		}

		return returnValue;
	}

	// 지정 ID의 엘레멘트의 지정 속성값 반환
	function getAttr(eleId, attrNm) {
		var obj = $("#" + eleId);
		var tagName = obj.prop('tagName');

		if(tagName.toUpperCase() == "SELECT") {
			obj = $("option:selected", obj);
		}

		return obj.attr(attrNm);
	}

	/**
	 * 입력한 날짜 (그리고 시간) 가 유효한지 여부 판단
	 * @param ymd {string} [필수값] 날짜
	 * @param hm {string} [선택값] 시간
	 * @returns {boolean} 유효한지 여부
	 */
	function isValidTime(ymd, hm = "") {
		if (!ymd) return false;
		return moment(ymd.replace(/[-|.]/gi, "") + (hm+"" ? " " + hm.replace(/:/gi, "") : "")).isValid();
	}

	/**
	 * 특정 행의 name 을 가지고 jQuery Selector 조회
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @returns {object} selector 정보
	 */
	function $getRowSelectorByName(idx, name) {
		return $(getInModDataWrapId(idx)).find("[name=" + name + "]");
	}

	/**
	 * 특정 행의 className 을 가지고 jQuery Selector 조회
	 * @param idx {string|number} 행 순번
	 * @param className {string} Element의 className
	 * @returns {object} selector 정보
	 */
	function $getRowSelectorByClassName(idx, className) {
		return $(getInModDataWrapId(idx)).find("." + className);
	}

	/**
	 * 특정 행의 name 을 가지고 정보 조회
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @returns {string} 값 정보
	 */
	function getRowValue(idx, name) {
		return $getRowSelectorByName(idx, name).val().replace(/[-|:]/gi, "");
	}

	/**
	 * 특정 행의 name 을 가지고 정보 설정
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @param value {*} 설정할 값
	 */
	function setRowValue(idx, name, value) {
		$getRowSelectorByName(idx, name).val(value);
	}

	/**
	 * 근태신청유형에 따라 반차(또는 반반차) 유형인지 조회
	 * @param requestUseType {string} 근태신청유형
	 * @returns {boolean} 반차여부
	 */
	function isHalfType(requestUseType) {
		return (requestUseType === "AM" || requestUseType === "PM" || requestUseType === "HAM1" || requestUseType === "HAM2"
				|| requestUseType === "HPM1" || requestUseType === "HPM2");
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="dataFrm" id="dataFrm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchSabun"       name="searchSabun"		 value=""/>
	<input type="hidden" id="baseCnt"           name="baseCnt"		     value=""/>
	<input type="hidden" id="maxCnt"            name="maxCnt"		     value=""/>
	<input type="hidden" id="applType"          name="applType"		     value=""/>
	<input type="hidden" id="bfApplSeq"         name="bfApplSeq"	     value=""/>

	<!-- 발생근태 관련 -->
	<input type="hidden" id="srcGntCd"          name="srcGntCd"		     value=""/>
	<input type="hidden" id="srcUseSYmd"        name="srcUseSYmd"	     value=""/>
	<input type="hidden" id="srcUseEYmd"        name="srcUseEYmd"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>

	<table class="default outer" style="table-layout: fixed;">
	<colgroup>
		<col width="100px" />
		<col width="250px" />
		<col width="100px" />
		<col width="" />
	</colgroup>
	<tr>
		<th>근태구분</th>
		<td>
			<select id="gntGubunCd" name="gntGubunCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
		</td>
		<th>근태</th>
		<td>
			<select id="gntCd" name="gntCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
		</td>
	</tr>
	<tr id="inMod4">
		<th>휴가 신청 내역</th>
		<td colspan="3">
			<script type="text/javascript"> createIBSheet("wtmAttendAppDetSheet1", "100%", "150px", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	<tr>
		<th colspan="4" class="text-center">휴가 신청</th>
	</tr>
	<tr id="inMod3" style="display:none;">
		<th>사용 휴가</th>
		<td colspan="3">
			<select id="leaveId" name="leaveId" class="${selectCss}" ${selectDisabled}></select>
		</td>
	</tr>
	<tr id="inMod2">
		<th id="inMod2Title">신청일자</th>
		<td id="inMod2Data" colspan="3">
			<button type="button" id="addBtn2" class="btn outline ml-auto">추가</button>
		</td>
	</tr>
	<tr id="inMod5">
		<th id="inMod5Title">신청사유</th>
		<td colspan="3">
			<textarea id="gntReqReason" name="gntReqReason" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
		</td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>