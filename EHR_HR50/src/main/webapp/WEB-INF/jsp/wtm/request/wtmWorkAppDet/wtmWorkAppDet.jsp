<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='wtmAttendDet1' mdef='근무신청 세부내역'/></title>
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
	var srcKey = "${etc02}"; // 변경/취소할 근무의 코드
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

		// 근무 신청내역 Sheet 초기화
		init_wtmWorkAppDetSheet1();

		//----------------------------------------------------------------
		if(authPg === "A") {
			// 근무코드 콤보 설정
			let workCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmWorkAppDetWorkCdList&searchAppYn=Y", false).codeList
					, "requestUseType,baseCnt,maxCnt,applyHour,orgLevelCd,excpSearchSeq"
					, "");
			$("#workCd").html(workCdList[2]);

			// 근무코드 변경 이벤트
			$("#workCd").on("change", function() {
				changeWorkCd();
				doAction1("Sheet1");
			});

			$('#addBtn2').on('click', function() {
				addCnt++;
				makeRow(addCnt, authPg);
			})

			if (srcKey) {
				initUpdDelWorkCd(srcKey);
			}

			$("#workCd").change();
		}else{
			// 읽기전용 일때는 전체 근무코드를 가져 옴.
			// 근무코드 콤보박스 설정
			var workCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmWorkAppDetWorkCdList", false).codeList
					, "requestUseType,baseCnt,maxCnt,applyHour,orgLevelCd,excpSearchSeq"
					, "");
			$("#workCd").html(workCdList[2]);

			// 추가 버튼 hide
			$('#addBtn2').hide();
		}

		doAction1("Search");
	});

	/**
	 * 변경/취소일 경우 해당 신청건의 근무코드 세팅을 위해 근무코드 조회
	 * @param _srcKey {string}
	 */
	function initUpdDelWorkCd(_srcKey) {
		const data = ajaxCall("${ctx}/WtmWorkApp.do?cmd=getWtmWorkAppDetInfoForUpd", "searchApplSeq=" + _srcKey.split("_")[0] + "&searchSeq=" + _srcKey.split("_")[1], false);
		if (data && data.DATA) {
			$("#workCd").val(data.DATA.workCd);
		} else {
			alert("조회 시 실패하였습니다.");
		}
	}

	/**
	 * 근무코드 변경 시 이벤트
	 */
	function changeWorkCd() {

		if( $("#workCd").val() === "" ) {
			$('.inModData-wrap').remove();
			clearHtml();
			addCnt = 0;
			return;
		}

		iframeHeight = 220;
		parent.iframeOnLoad("220px");

		//------------------------------------------------------------------------------------------
		// 현재 근무코드의 근무신청유형
		var baseCnt    = getAttr("workCd", "baseCnt");

		// 최소, 최대 기준일수를 보여줌
		$("#baseCnt").val( baseCnt ) ;
		$("#maxCnt").val( getAttr("workCd", "maxCnt") ) ;

		// 전체 clear
		clearAllRowData();
		addCnt = 0;
		if (authPg === "A") {
			// 근태캘린더에서 시작/종료일자가 넘어올 경우 해당 데이터로 초기화
			if (bfYmd) {
				const bfSYmd = bfYmd.split("_")[0];
				const bfEYmd = bfYmd.split("_")[1];
				makeRowsByYmd(bfSYmd, bfEYmd);
			}
		}
	}

	/**
	 * 입력값 초기화
	 */
	function clearHtml() {

		resetRowData(0);

		$("#maxCnt").val( "" );
		$("#txt_sTime").html( "시작시간" );
		$("#txt_eTime").html( "종료시간" );
	}

	/**
	 * 특정 행의 데이터를 reset
	 * @param idx 행 인덱스
	 */
	function resetRowData(idx) {

		if ($(getInModDataWrapId(idx)).length === 0) {
			return;
		}

		const reqUseType = getAttr("workCd", "requestUseType");

		setRowValue(idx, "sYmd", "");
		setRowValue(idx, "eYmd", "");
		if( reqUseType === "H" ) {
			setRowValue(idx, "reqSHm", "");
			setRowValue(idx, "reqEHm", "");
			setRowValue(idx, "requestHour", "");
		}
		setRowValue(idx, "holDay", "");
		setRowValue(idx, "appDay", "");
		timeCheck(getRowSelector(idx, "sYmd"), idx);
	}

	/**
	 * 모든 신청일자 데이터를 삭제한다.
	 */
	function clearAllRowData() {
		$(getInModDataWrapId()).remove();
	}

	/**
	 * 근무 신청유형에 따라 찾아야 할 inModData-wrap 의 selector id 를 조회
	 * @param idx {string|number} [선택값] 행 순번
	 * @returns {string} inModData-wrap 의 selector id
	 */
	function getInModDataWrapId(idx = "") {
		return idx+"" ? "td#inMod2Data div.inModData-wrap[data-idx=" + idx + "]" : "td#inMod2Data div.inModData-wrap";
	}

	/**
	 * 근태캘린더에서 넘어온 시작/종료일자로 신청 데이터를 만들어준다.
	 * @param sYmd {string} 시작일자(YYYY-MM-DD)
	 * @param eYmd {string} 종료일자(YYYY-MM-DD)
	 */
	function makeRowsByYmd(sYmd, eYmd) {
		const diff = getDaysBetween(sYmd.replace(/[-|.]/gi, ""), eYmd.replace(/[-|.]/gi, ""));
		const reqUseType = getAttr("workCd", "requestUseType");
		if (reqUseType === "H") {
			for (var i = 0 ; i < diff ; i++) {
				makeRow(i, authPg);
				const date = moment(sYmd).add(i, "days").format("YYYY-MM-DD");
				setRowValue(addCnt, "sYmd", date);
				setRowValue(addCnt, "eYmd", date);
				addCnt++;
			}
		} else {
			makeRow(addCnt, authPg);
			setRowValue(addCnt, "sYmd", sYmd);
			setRowValue(addCnt, "eYmd", eYmd);
			addCnt++;
		}
	}

	/**
	 * 신청일자 행 생성
	 * @param idx {string|number} 행 순번
	 * @param _authPg {string} 권한
	 */
	function makeRow(idx, _authPg) {
		const requestUseType = getAttr("workCd", "requestUseType");
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
					     <b><span id="txt_sTime">시작시간</span> : </b>
					     <input id="sYmd${'${idx}'}" name="sYmd" type="text" size="10" class="date2 center ${readonly} ${required} required2 edit-datepicker" readonly />
					     <input name="reqSHm" type="text" class="text center w60 ${required} required2" ${readonly} maxlength="5"/>
					     &nbsp;
					     <b><span id="txt_eTime">종료시간</span> : </b>
					     <input name="eYmd" type="text" size="10" class="date2 center ${readonly} ${required} required2 edit-datepicker" readonly />
					     <input name="reqEHm" type="text" class="text center w60 ${required} required2" ${readonly} maxlength="5"/>
					     &nbsp;
					     <b>적용시간 : </b> <input name="requestHour" type="text" class="text w30 center ${readonly}" ${readonly} maxlength="4"/> 시간
					     <span class="hide">
					     <b>총일수 : </b> <input type="text" name="holDay" class="text w30 center" readonly maxlength="3"/>
					     <b>적용일수 : </b> <input type="text" name="appDay" class="text w30 center" readonly maxlength="4"/>
					     </span>
					    ${'${rmBtnHtml}'}
					 </div>`;
		} else {
			return `<div class="inModData-wrap" data-idx="${'${idx}'}">
					    <b><span id="txt_sYmd">시작일자</span> : </b>
					    <input id="sYmd${'${idx}'}" name="sYmd" type="text" size="10" class="date2 center ${required} required1" readonly />
					    &nbsp;
					    <b><span id="txt_eYmd">종료일자</span> : </b>
					    <input name="eYmd" type="text" size="10" class="date2 center ${required} required1" readonly  />
					    <span style="padding-left:30px;">
					        <b>총일수 : </b> <input type="text" name="holDay" class="text w30 center" readonly maxlength="3"/>&nbsp;
					        <b>적용일수 : </b> <input type="text" name="appDay" class="text w30 center" readonly maxlength="4"/>&nbsp;
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
		const requestUseType = getAttr("workCd", "requestUseType");
		const dataWrapSel = getInModDataWrapId(idx);

		const sYmd = dataWrapSel + " input[name=sYmd]";
		const eYmd = dataWrapSel + " input[name=eYmd]";
		const reqSHm = dataWrapSel + " input[name=reqSHm]";
		const reqEHm = dataWrapSel + " input[name=reqEHm]";

		$(sYmd).datepicker2({
			onReturn: function() {
				const $parent = $(this).parent();
				$parent.find("input[name=eYmd]").val("");
				if (requestUseType === "H") {
					$parent.find("input[name=reqSHm]").val("");
					$parent.find("input[name=reqEHm]").val("");
					$parent.find("input[name=reqEHm]").mask("11:11");
				}
				timeCheck(this, idx);
			}
		})
		$(eYmd).datepicker2({
			enddate: "sYmd" + idx,
			onReturn: function() {
				const $parent = $(this).parent();
				$parent.find("input[name=reqEHm]").val("");
				timeCheck(this, idx);
			}
		})

		$([sYmd, eYmd, reqSHm, reqEHm].join(",")).on("blur", function() {
			timeCheck(this, idx);
		})

		$([reqSHm, reqEHm].join(",")).mask("11:11");

		const removeRowBtnId = dataWrapSel + " button[name=removeRow]";
		$(removeRowBtnId).on("click", function() {
			$(this).parent().remove();
		})
	}

	/**
	 * 적용시간 계산
	 * @param obj {*} 입력한 항목의 jquery selector
	 * @param idx {string|number} 행 순번
	 */
	function timeCheck(obj, idx) {
		var requestUseType = getAttr("workCd", "requestUseType");
		var baseCnt = getAttr("workCd", "baseCnt");
		var applyHour = getAttr("workCd", "applyHour");

		if (!isValidInputTime(obj, idx)) {
			setRowValue(idx, "holDay", "");
			setRowValue(idx, "appDay", "");
			if (requestUseType === 'H') {
				setRowValue(idx, "requestHour", ""); // 적용시간 초기화
			}
			return;
		}

		const sYmd = getRowValue(idx, "sYmd")
				, eYmd = getRowValue(idx, "eYmd");

		if (requestUseType === 'H') {

			const param = "sabun=" + searchApplSabun
					+ "&workCd=" + $("#workCd").val()
					+ "&reqSHm=" + getRowValue(idx, "reqSHm")
					+ "&reqEHm=" + getRowValue(idx, "reqEHm")
					+ "&sYmd=" + sYmd
					+ "&eYmd=" + eYmd;

			// 적용시간 계산
			const reqHours = ajaxCall("/WtmWorkApp.do?cmd=getWtmWorkAppDetHour", param, false);
			if (reqHours != null && reqHours != undefined && reqHours.DATA != null && reqHours.DATA != undefined) {

				//시간차 처리를 위한 산식 삽입
				const requestHour = Number(reqHours.DATA.hours);
				setRowValue(idx, "requestHour", requestHour);
				setRowValue(idx, "holDay", requestHour * baseCnt);
				setRowValue(idx, "appDay", requestHour * baseCnt);
			}

		} else {

			const param = "sabun=" + $("#searchApplSabun").val()
					+ "&applSeq=" + $("#searchApplSeq").val()
					+ "&workCd=" + $("#workCd").val()
					+ "&sYmd=" + sYmd
					+ "&eYmd=" + eYmd;

			// 신청일 기준 체크
			const map = ajaxCall("/WtmWorkApp.do?cmd=getWtmWorkAppDetApplDay", param, false);
			if (!map || !map.DATA || map.DATA.authYn !== "Y") {
				alert("신청 대상자가 아닙니다.");
				$(obj).val("");
				return;
			}

			let dayBetween = getDaysBetween(sYmd , eYmd);
			setRowValue(idx, "holDay", dayBetween);
			setRowValue(idx, "appDay", dayBetween - map.DATA.holidayCnt);
		}
	}

	/**
	 * 입력한 시간이 유효한지 확인
	 * @param obj 현재 입력중인 엘레먼트의 jQuery selector
	 * @param idx {string|number} 행 순번
	 * @returns {boolean}
	 */
	function isValidInputTime(obj, idx) {
		const requestUseType = getAttr("workCd", "requestUseType");
		let timeList = [];

		// 현재 입력 값
		let sTime = getRowValue(idx, "sYmd")
				, eTime = getRowValue(idx, "eYmd");
		if (requestUseType === "H") {
			sTime += " " + getRowValue(idx, "reqSHm");
			eTime += " " + getRowValue(idx, "reqEHm");
		}
		const sMmt = moment(sTime)
				, eMmt = moment(eTime);

		/* 1. 신청일자 유효성 체크 */
		if(!sMmt.isValid() || !eMmt.isValid()) return false;

		// 1-2. 시작일, 종료일 기간이 올바르지 않은 경우 알림 처리
		if( sMmt.isAfter(eMmt) ) {
			alert("시작일과 종료일을 정확히 입력하세요.");
			$(obj).val("");
			return false;
		}

		// 입력한 모든 기간 수집
		$(getInModDataWrapId()).each(function() {
			const idx = Number($(this).attr("data-idx"));
			let start = getRowValue(idx, "sYmd")
					, end = getRowValue(idx, "eYmd");
			if (requestUseType === "H") {
				start += " " + getRowValue(idx, "reqSHm");
				end += " " + getRowValue(idx, "reqEHm");
			}
			timeList.push({ "idx": idx, "start": moment(start), "end": moment(end) });
		});

		let isDup = false;
		for (const obj of timeList) {
			if (obj.idx === idx) continue;

			const tmpSMmt = obj.start
					, tmpEMmt = obj.end;

			if (!tmpSMmt.isValid() && !tmpEMmt.isValid()) continue;

			if (sMmt.isBefore(tmpEMmt) && eMmt.isAfter(tmpSMmt)) {
				isDup = true;
				break;
			}
		}
		if(isDup) {
			alert("신청일자가 겹치는 건이 있습니다. 신청일자를 확인해주세요.");
			$(obj).val("");
			return false;
		}

		return true;
	}

	//Sheet 초기화
	function init_wtmWorkAppDetSheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"근태명",		Type:"Text",		Hidden:0,	Width:100, 	Align:"Center",		ColMerge:0,	SaveName:"workNm",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"시작시간",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"sYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0, Edit:0},
			{Header:"종료시간",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"eYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0, Edit:0},
			{Header:"신청시간(분)",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",		ColMerge:0,	SaveName:"requestMm",	KeyField:0,	CalcLogic:"",	Format:"",  Edit:0},
			{Header:"취소",			Type:"CheckBox",  	Hidden:0,  	Width:40,   Align:"Center",  	ColMerge:0, SaveName:"cancelChk",	KeyField:0, CalcLogic:"",   Format:"",  Edit:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"근태디테일ID",	Type:"Hidden",  	Hidden:1,  	SaveName:"gntWorkId"},
			{Header:"상위신청서순번",	Type:"Hidden",  	Hidden:1,  	SaveName:"bfApplSeq"},
			{Header:"seq",			Type:"Hidden",  	Hidden:1,  	SaveName:"seq"},
		]; IBS_InitSheet(wtmWorkAppDetSheet1, initdata1);wtmWorkAppDetSheet1.SetEditable(1);wtmWorkAppDetSheet1.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

		wtmWorkAppDetSheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		wtmWorkAppDetSheet1.SetDataAlternateBackColor(wtmWorkAppDetSheet1.GetDataBackColor()); //홀짝 배경색 같게
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var params = "searchApplSeq="+searchApplSeq;
				detData = ajaxCall("${ctx}/WtmWorkApp.do?cmd=getWtmWorkAppDetList", params, false).DATA;

				if ( detData && detData.length > 0 ) {

					clearAllRowData();
					$("#workCd").val( detData[0].workCd );
					changeWorkCd();
					var reqUseType = getAttr("workCd", "requestUseType");

					detData.forEach((item, idx) => {
						if(item.reqType === 'I') { // 근무 신청인 경우
							const _idx = Number(item.seq);

							// 입력 폼 추가
							makeRow(_idx, authPg);

							setRowValue(_idx, "sYmd", formatDate(item.sYmd,"-"));
							setRowValue(_idx, "eYmd", formatDate(item.eYmd,"-"));
							setRowValue(_idx, "holDay", item.holDay);
							setRowValue(_idx, "appDay", item.appDay);

							if(reqUseType === 'H') {
								// 시간단위
								setRowValue(_idx, "reqSHm", formatTime(item.reqSHm,"-"));
								getRowSelector(_idx, "reqSHm").mask("11:11");
								setRowValue(_idx, "reqEHm", formatTime(item.reqEHm,"-"));
								getRowSelector(_idx, "reqEHm").mask("11:11");
								setRowValue(_idx, "requestHour", item.requestMm / 60);
							}

							addCnt = _idx;
						}
					})

					$("#workReqReason").val( detData[0].workReqReason );
				}
				doAction1("Sheet1");
				break;
			case "Sheet1":
				let param = "searchApplSabun="+$("#searchApplSabun").val()
						+"&workCd="+$("#workCd").val();

				wtmWorkAppDetSheet1.DoSearch( "${ctx}/WtmWorkApp.do?cmd=getWtmWorkAppDetSheet1List", param );
				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// wtmWorkAppDetSheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function wtmWorkAppDetSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(authPg == "A") {
				if (srcKey) {
					for (var i = wtmWorkAppDetSheet1.HeaderRows(); i < wtmWorkAppDetSheet1.RowCount() + wtmWorkAppDetSheet1.HeaderRows(); i++) {
						const tgtKey = wtmWorkAppDetSheet1.GetCellValue(i, "bfApplSeq") + "_" + wtmWorkAppDetSheet1.GetCellValue(i, "seq");

						if (srcKey === tgtKey) {
							wtmWorkAppDetSheet1.SetCellValue(i, 'cancelChk', "Y");
						}
					}
				}
			} else {
				wtmWorkAppDetSheet1.SetEditable(0);
				detData.forEach((item, idx) => {
					const bfApplSeq = item.bfApplSeq;
					const bfSeq = item.bfSeq;

					for(var i = wtmWorkAppDetSheet1.HeaderRows(); i < wtmWorkAppDetSheet1.RowCount()+wtmWorkAppDetSheet1.HeaderRows(); i++) {
						if(wtmWorkAppDetSheet1.GetCellValue(i, "bfApplSeq") === bfApplSeq && wtmWorkAppDetSheet1.GetCellValue(i, "seq") === bfSeq) {
							wtmWorkAppDetSheet1.SetCellValue(i, 'cancelChk', "Y");
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
		var reqUseType = $("#workCd option:selected").attr("requestUseType");

		if(reqUseType === 'H') {
			$(".required2").each(function(index){
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

			// 근무 신청 데이터
			let insDataList = [];
			const reqUseType = getAttr("workCd", "requestUseType");
			$(getInModDataWrapId("")).each(function() {
				const idx = $(this).attr("data-idx");
				const sYmd = getRowValue(idx, "sYmd");
				const eYmd = getRowValue(idx, "eYmd");
				if (reqUseType === "H") {
					const reqSHm = getRowValue(idx, "reqSHm");
					const reqEHm = getRowValue(idx, "reqEHm");
					if (isValidTime(sYmd, reqSHm) && isValidTime(eYmd, reqEHm)) {
						const requestHour = getRowValue(idx, "requestHour");
						const holDay = getRowValue(idx, "holDay");
						const appDay = getRowValue(idx, "appDay");
						insDataList.push({sYmd: sYmd, eYmd: eYmd, reqSHm: reqSHm, reqEHm: reqEHm, requestHour: requestHour, holDay: holDay, appDay: appDay, seq: idx});
					}
				} else {
					if (isValidTime(sYmd) && isValidTime(eYmd)) {
						const holDay = getRowValue(idx, "holDay");
						const appDay = getRowValue(idx, "appDay");
						insDataList.push({sYmd: sYmd, eYmd: eYmd, holDay: holDay, appDay: appDay, seq: idx});
					}
				}
			});

			// 근무 취소 데이터
			let delDataList = [];
			let idx = 1;
			for(var i = wtmWorkAppDetSheet1.HeaderRows(); i < wtmWorkAppDetSheet1.RowCount()+wtmWorkAppDetSheet1.HeaderRows(); i++) {
				const cancelChk = wtmWorkAppDetSheet1.GetCellValue(i, 'cancelChk');
				if(cancelChk === 'Y') {
					let sYmd = wtmWorkAppDetSheet1.GetCellValue(i, 'sYmd');
					let eYmd = wtmWorkAppDetSheet1.GetCellValue(i, 'eYmd');
					let appDay = wtmWorkAppDetSheet1.GetCellValue(i, 'appDay')
					let holDay = wtmWorkAppDetSheet1.GetCellValue(i, 'holDay')
					let bfApplSeq = wtmWorkAppDetSheet1.GetCellValue(i, 'bfApplSeq')
					let leaveId = wtmWorkAppDetSheet1.GetCellValue(i, 'leaveId')
					let bfSeq = wtmWorkAppDetSheet1.GetCellValue(i, 'seq')
					delDataList.push({sYmd: sYmd, eYmd: eYmd, appDay: appDay, holDay: holDay, bfApplSeq: bfApplSeq, leaveId: leaveId, bfSeq: bfSeq, seq: idx});
					idx++;
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
				url: "${ctx}/WtmWorkApp.do?cmd=saveWtmWorkAppDet",
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
		return moment(ymd.replace(/[-|.]/gi, "") + (hm.replace(/:/gi, "") ? " " + hm.replace(/:/gi, "") : "")).isValid();
	}

	/**
	 * 특정 행의 name 을 가지고 jQuery Selector 조회
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @returns {string} 값 정보
	 */
	function getRowSelector(idx, name) {
		return $(getInModDataWrapId(idx)).find("[name=" + name + "]");
	}

	/**
	 * 특정 행의 name 을 가지고 정보 조회
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @returns {string} 값 정보
	 */
	function getRowValue(idx, name) {
		return $(getInModDataWrapId(idx)).find("[name=" + name + "]").val().replace(/[-|:]/gi, "");
	}

	/**
	 * 특정 행의 name 을 가지고 정보 설정
	 * @param idx {string|number} 행 순번
	 * @param name {string} Element의 name
	 * @param value {*} 설정할 값
	 */
	function setRowValue(idx, name, value) {
		$(getInModDataWrapId(idx)).find("[name=" + name + "]").val(value);
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

	<%-- 근태 변경/취소 관련 --%>
	<input type="hidden" id="gntDtlId"        name="gntDtlId"	     value=""/>

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
		<th>근무</th>
		<td>
			<select id="workCd" name="workCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
		</td>
	</tr>
	<tr id="inMod4">
		<th>근무 신청 내역</th>
		<td colspan="3">
			<script type="text/javascript"> createIBSheet("wtmWorkAppDetSheet1", "100%", "150px", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	<tr>
		<th colspan="4" class="text-center">근무 신청</th>
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
			<textarea id="workReqReason" name="workReqReason" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
		</td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>