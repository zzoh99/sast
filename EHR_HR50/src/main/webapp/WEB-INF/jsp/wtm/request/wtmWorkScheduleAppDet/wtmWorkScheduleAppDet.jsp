<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무스케쥴신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var timeCdMap, timeColorMap, workLmtObj;

	$(function() {

		parent.iframeOnLoad(450);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부

		//-----------------------------------------------------------------
		doAction("Search");

	});

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 신청내용 값 입력
			const data = ajaxCall( "${ctx}/WtmWorkScheduleApp.do?cmd=getWtmWorkScheduleAppDet", GetParamAll("searchForm"),false);
			if ( data != null && data.DATA != null ){
				$("#ymd").text( formatDate(data.DATA.ymd, "-") );
				$("#workClassNm").text( data.DATA.workClassNm );
				$("#orgNm").text( data.DATA.orgNm );
				$("#applUnitNm").text( data.DATA.applUnitNm );
				$("#sdate").val( formatDate(data.DATA.sdate, "-") );
				$("#edate").val( formatDate(data.DATA.edate, "-") );
			}

			init_sheet();
			break;
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet1
	//---------------------------------------------------------------------------------------------------------------
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"${sNoTy}",Hidden:0, Width:45, Align:"Center", SaveName:"sNo", Sort:0},
			{Header:"상태",	Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"사번",	Type:"Text", 	Hidden:1, Width:70, Align:"Center", SaveName:"sabun", KeyField:0, Format:"", Edit:0},
			{Header:"성명",	Type:"Text", 	Hidden:0, Width:70, Align:"Center", SaveName:"name", KeyField:0, Format:"", Edit:0},
			{Header:"직위",	Type:"Text", 	Hidden:0, Width:70, Align:"Center", SaveName:"jikweeNm", KeyField:0, Format:"", Edit:0},

			//Hidden
			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"orgCd"},
		];

		// 헤더행 동적 생성
		const titleList = ajaxCall("${ctx}/WtmWorkScheduleApp.do?cmd=getWtmWorkScheduleAppDetHeaderList", GetParamAll("searchForm"), false);
		if (titleList != null && titleList.DATA != null) {
			const titles = titleList.DATA
			let weekCnt = 0;
			titles.forEach(function(title, idx) {
				initdata.Cols.push({Header:title.title, Type:"Text", Hidden:0, Width:90, Align:"Center", SaveName:title.saveName, Edit:0});
			})

			// 단위기간 근무시간 표기
			initdata.Cols.push({Header:"합계\n근무\n시간", Type:"Int", Hidden:0, Width:50, Align:"Center", SaveName:"termTimeHour", KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"});
		}

		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet1.SetHeaderRowHeight(50); // 헤더행 높이
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetEditable(0);

		var sXml = sheet1.GetSearchData("${ctx}/WtmWorkScheduleApp.do?cmd=getWtmWorkScheduleAppDetDetailList", GetParamAll("searchForm") );
		sXml = replaceAll(sXml,"BackColor", "#BackColor");
		sheet1.LoadSearchData(sXml);
		$(window).smartresize(sheetResize); sheetInit();
	}	

	//--------------------------------------------------------------------------------
	//  sheet1 Events
	//--------------------------------------------------------------------------------
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			resizeSheetHeight(sheet1, "R"); //시트행 갯수에 맞게 시트 높이 설정 ( 아래 CellProperty 이후에 하면 안됨 시트 버그 같음 ..)
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

		// --------------------------------------------------------------------------------------------------------
		// 기 신청건 체크 
		// --------------------------------------------------------------------------------------------------------
		const params = GetParamAll("searchForm") +
					  IBS_GetColValue(sheet1, "sabun");
		var data = ajaxCall("${ctx}/WtmWorkScheduleApp.do?cmd=getWtmWorkScheduleAppDetDupCnt", params, false);
		
		if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
			alert("해당 기간에 신청 중인 스케줄이 있습니다.\n처리완료 후 신청 해주세요.");
			return false;
		}

		return true;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = true;
		try {
			if ( authPg == "R" )  {
				return true;
			}
			// 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }
			if( sheet1.RowCount() == 0 ){
				alert("신청할 내용이 없습니다.");
				return false;
			}

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}

	/**
		disabled 포함 Form 데이터 리턴
	**/
	function GetParamAll(formId){
		var t = $("#"+formId);
		var disabled = t.find(":disabled").removeAttr("disabled");
		var params = t.serialize();
		disabled.attr("disabled", "disabled");
		return params;
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="200px" />
			<col width="120px" />
			<col width="" />
		</colgroup> 
	
		<tr>
			<th>기준일자</th>
			<td colspan="3">
				<span id="ymd"></span>
			</td>
		</tr>
		<tr>
			<th>근무유형</th>
			<td>
				<span id="workClassNm"></span>
			</td>
			<th>부서</th>
			<td>
				<span id="orgNm"></span>
			</td>
		</tr>
		<tr>
			<th>신청단위</th>
			<td>
				<span id="applUnitNm"></span>
			</td>
			<th>근무기간</th>
			<td>
				<input type="text" class="text" id="sdate" name="sdate" readonly> - <input type="text" id="edate" name="edate" readonly></span>
			</td>
		</tr>
	</table>
	</form>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "330px", "${ssnLocaleCd}"); </script>
</div>
		
</body>
</html>